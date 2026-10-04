#!/usr/bin/env bash
# 发布镜像仓专属校验（2026-09-29 立）
#
# 存在理由：check-skills.sh 抽取的是容器仓 AGENTS.md §8 的校验，按
# skills/<bucket>/<name>/ 布局判定；本仓是拍平镜像（<role>/SKILL.md 直接放仓根），
# 结构规则必然 4 条 FAIL，退出码不可用。本脚本按镜像布局重写同一套检查，
# 让退出码真正可用（em-dash / 死链 / name 一致性 / docs 对应全保留）。
#
# 用法：bash scripts/check-mirror.sh
#   退出码 0  = 问题数 0
#   退出码 非0 = 校验失败（非零码 + loud FAIL 摘录）
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || { echo "MIRROR-CHECK FAIL: 无法进入仓库根"; exit 2; }

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

cat > "$TMP" <<'PYEOF'
import pathlib, re, sys

root = pathlib.Path('.')
fails = []

roles = {}          # role-name -> role_dir
for f in sorted(root.glob('*/SKILL.md')):
    if '.git' in f.parts:
        continue
    roles[f.parts[0]] = f.parent

# 1) 根目录不许有 SKILL.md（放了就退化成一个大技能）
if (root / 'SKILL.md').exists():
    fails.append('根目录出现了 SKILL.md')

# 2) 所有 SKILL.md 必须在 <role>/SKILL.md（2 层深度），镜像拍平布局
for f in sorted(root.rglob('SKILL.md')):
    if '.git' in f.parts:
        continue
    if len(f.parts) != 2:
        fails.append(f'SKILL.md 不在 <role>/SKILL.md 平铺位置: {f}')

# 3) frontmatter 的 name 必须等于目录名；name 必填
for name, d in roles.items():
    head = (d / 'SKILL.md').read_text(encoding='utf-8').split('---')[1]
    m = re.search(r'^name:\s*(.+)$', head, re.M)
    got = m.group(1).strip() if m else None
    if got != name:
        fails.append(f'{d}/SKILL.md 的 name={got}，目录名={name}')

# 4) 全仓禁用 em-dash（U+2014），按码点判定
for p in sorted(root.rglob('*.md')):
    if '.git' in p.parts:
        continue
    for i, line in enumerate(p.read_text(encoding='utf-8').splitlines(), 1):
        if '\u2014' in line:
            fails.append(f'em-dash: {p}:{i}')

# 5) docs/ 与角色目录一一对应（docs/<role>.md 四段式页）
for name in roles:
    if not (root / 'docs' / f'{name}.md').exists():
        fails.append(f'缺 docs/{name}.md')
for p in sorted(root.glob('docs/*.md')):
    if p.stem not in roles:
        fails.append(f'多余的 docs 页（无对应角色）: {p}')

# 6) 相对链接必须可达（剥离围栏代码块后再查）
fence = '`' * 3
for p in sorted(root.rglob('*.md')):
    if '.git' in p.parts:
        continue
    text = re.sub(fence + r'.*?' + fence, '', p.read_text(encoding='utf-8'), flags=re.S)
    for m in re.finditer(r'\[[^\]]*\]\(([^)]+)\)', text):
        t = m.group(1).strip()
        if t.startswith(('http://', 'https://', 'mailto:', '#')):
            continue
        t = t.split('#')[0]
        if t and not (p.parent / t).exists():
            fails.append(f'失效链接: {p} -> {t}')

# 7) SKILL.md 行数 ≤ 50（2026-09-30 用户指定；附属参考文档不限，细则拆同目录 .md）
for name, d in roles.items():
    n = len((d / 'SKILL.md').read_text(encoding='utf-8').splitlines())
    if n > 50:
        fails.append(f'{d}/SKILL.md 行数 {n} > 50')

# 8) 团队纪律编号必须从 1 起连续无缺号（2026-10-04 立；曾出现 15,16,18,...,99）
gc = (root / 'pm' / 'group-conventions.md')
if gc.exists():
    gtext = gc.read_text(encoding='utf-8')
    nums = [int(m.group(1)) for m in
            re.finditer(r'^\|\s*(\d+)\s*\|\s*[^|]+\|', gtext, re.M)]
    if not nums:
        fails.append('group-conventions.md 里找不到团队纪律表')
    elif nums != list(range(1, len(nums) + 1)):
        fails.append(f'团队纪律编号不连续: {nums}')

# 9) 纪律编号引用不得悬空（跨文件）
#    跨文件只认显式写法「团队纪律第 N 条」/「纪律第 N 条」（dm 的 19 条是另一张表，
#    裸「第 N 条」在 dm/tm 侧指的是各自文件内的条号，不查）；
#    group-conventions.md 内部的裸「第 N 条」一律指本文件的团队纪律表，必须查。
#    （曾出现「第 22 条」指向已删旧编号；也出现过 communication-style.md 的「纪律 16」，
#      纪律表只有 9 条。旧版只扫 group-conventions.md 本文件，跨文件漏检）
for p in sorted(root.rglob('*.md')):
    if '.git' in p.parts:
        continue
    text = p.read_text(encoding='utf-8')
    # 「纪律第 N 条」一律查；「纪律 N 条」若是**数自己那张表的条数**（如 dm 的 19 条全文）
    # 则跳过，只有后面不跟「条」时（「按纪律 16，」）才算悬空引用；
    # group-conventions.md 内部的裸「第 N 条」一律指本文件的团队纪律表，必须查。
    pat = (r'(?:团队纪律|纪律)[ \t]*第[ \t]*(\d+)[ \t]*条|'
           r'(?:团队纪律|纪律)[ \t]+(\d+)(?![ \t]*条)' if p != gc
           else r'(?:团队纪律|纪律)[ \t]*第[ \t]*(\d+)[ \t]*条|'
                r'(?:团队纪律|纪律)[ \t]+(\d+)(?![ \t]*条)|'
                r'第[ \t]*(\d+)[ \t]*条')
    for m in re.finditer(pat, text):
        n = int(next(g for g in m.groups() if g))
        if n not in nums:
            line = text[:m.start()].count('\n') + 1
            fails.append(f'{p}:{line} 悬空引用「第 {n} 条」，纪律表只有 {nums}')

# 10) communication-style.md §3 对照表与 §4 grep 词表必须一致（防两表漂移 ⇒ 机检假绿）
cs = root / 'pm' / 'communication-style.md'
if cs.exists():
    ctext = cs.read_text(encoding='utf-8')
    try:
        table = ctext.split('## 3.')[1].split('## 4.')[0]
        terms = set()
        for line in table.splitlines():
            if line.startswith('|') and '---' not in line:
                cells = [c.strip() for c in line.strip('|').split('|')]
                if cells[0] == '内部术语':
                    continue
                for w in re.split(r'\s*/\s*', cells[0]):
                    if w.strip():
                        terms.add(w.strip())
        g = re.search(r"grep -nE '([^']+)'", ctext)
        words = set(g.group(1).split('|')) if g else set()
        # 纯英文词不进 grep（避免误伤正常英文），比对时剔除
        en = {w for w in terms if w.isascii()}
        if (terms - en) - words:
            fails.append('communication-style.md §3 有词不在 §4 grep 词表: '
                         f'{sorted((terms - en) - words)}')
        if words - terms:
            fails.append('communication-style.md §4 grep 词表有词不在 §3 对照表: '
                         f'{sorted(words - terms)}')
    except IndexError:
        fails.append('communication-style.md 找不到 §3 / §4 标题')

# 11) dm/disciplines.md 条号必须 1 起连续，且与 dm/SKILL.md 声明的条数一致
dd = root / 'dm' / 'disciplines.md'
if dd.exists():
    dtext = dd.read_text(encoding='utf-8')
    dnums = [int(m.group(1)) for m in
             re.finditer(r'^(\d+)\.\s+\*\*', dtext, re.M)]
    if dnums != list(range(1, len(dnums) + 1)):
        fails.append(f'dm/disciplines.md 条号不连续: {dnums}')
    m = re.search(r'派单与收口纪律（强制，(\d+) 条）',
                  (root / 'dm' / 'SKILL.md').read_text(encoding='utf-8'))
    if m and int(m.group(1)) != len(dnums):
        fails.append(f'dm/SKILL.md 声明 {m.group(1)} 条，disciplines.md 实有 {len(dnums)} 条')

for f in fails:
    print('FAIL:', f)
print(f'\n角色数: {len(roles)}，问题数: {len(fails)}')
sys.exit(1 if fails else 0)
PYEOF

out="$(python3 "$TMP" 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  echo "=== MIRROR-CHECK FAIL (rc=$rc) ==="
  echo "$out" | grep -n '^FAIL:' || echo "$out" | tail -5
  echo "=================================="
  exit "$rc"
fi

r="$(printf '%s\n' "$out" | sed -n 's/.*角色数: \([0-9]\{1,\}\)，.*/\1/p' | tail -1)"
echo "MIRROR-CHECK OK: roles=${r:-?} problems=0 rc=0"
exit 0
