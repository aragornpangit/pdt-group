#!/usr/bin/env bash
# 跨仓一致性校验：镜像仓 ACKNOWLEDGMENTS.md ↔ 容器仓 skills/pdt-group/pm/inventory.md
#
# 存在理由（2026-10-14 立）：两份技能清单分处两仓，容器仓桶 README 明说「两边改动要
# 一起走」，但各自仓内的校验都看不到对方 ⇒ 只改一边不会被任何机检抓到。本脚本专查这条。
#
# 判据（两条，各配反向臂验证过）：
#   1) ACK 里出现的每个上游技能，必须在 inventory 里有登记（ACK ⊆ inventory）
#   2) 同名技能在两处链到的上游路径必须一致（防上游改名 / 移桶后只改一边）
# 反向差（inventory 有、ACK 无）只打印 INFO，不判失败：ACK 是引用清单，不必列全台账。
#
# 用法：
#   bash scripts/check-cross-repo.sh <容器仓根路径>
#   PDT_CONTAINER_REPO=<容器仓根路径> bash scripts/check-cross-repo.sh
#   PDT_CONTAINER_REPO=<容器仓根路径> bash scripts/check-mirror.sh   # 主校验顺带跑这条
# 退出码：0 = 一致；1 = 不一致；2 = 容器仓路径无效（响亮失败，不得当通过）
set -uo pipefail

MIRROR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER="${1:-${PDT_CONTAINER_REPO:-}}"

if [ -z "$CONTAINER" ]; then
  echo "CROSS-CHECK FAIL: 未给容器仓路径。用法：bash scripts/check-cross-repo.sh <容器仓根路径>（或设 PDT_CONTAINER_REPO）"
  exit 2
fi

INV="$CONTAINER/skills/pdt-group/pm/inventory.md"
ACK="$MIRROR_ROOT/ACKNOWLEDGMENTS.md"
for f in "$INV" "$ACK"; do
  if [ ! -f "$f" ]; then
    echo "CROSS-CHECK FAIL: 路径无效，找不到 $f"
    exit 2
  fi
done

out="$(python3 - "$ACK" "$INV" <<'PYEOF'
import re, sys

PAT = re.compile(
    r'raw\.githubusercontent\.com/mattpocock/skills/main/skills/([^/]+)/([^/]+)/SKILL\.md')

def grab(path):
    """技能名 -> 该文件里链到的上游路径集合（同名多路径也能看出来）"""
    found = {}
    for line in open(path, encoding='utf-8'):
        for bucket, name in PAT.findall(line):
            found.setdefault(name, set()).add(f'/skills/{bucket}/{name}/SKILL.md')
    return found

ack = grab(sys.argv[1])
inv = grab(sys.argv[2])
fails = []

# 判据 1：ACK 引用的技能必须在台账里登记
missing = sorted(set(ack) - set(inv))
if missing:
    fails.append('ACK 引用了 inventory 未登记的技能: ' + ', '.join(missing))

# 判据 2：同名技能两处路径必须一致
for name in sorted(set(ack) & set(inv)):
    if ack[name] != inv[name]:
        fails.append(f'同名技能路径不一致 {name}: ACK={sorted(ack[name])} '
                     f'inventory={sorted(inv[name])}')

only_inv = sorted(set(inv) - set(ack))
for f in fails:
    print('FAIL:', f)
if only_inv:
    print('INFO: inventory 有、ACK 未列（引用清单不必列全台账）:', ', '.join(only_inv))
print(f'ack={len(ack)} inv={len(inv)}')
sys.exit(1 if fails else 0)
PYEOF
)"
rc=$?

printf '%s\n' "$out" | grep -v '^ack=' | sed 's/^/  /' || true
counts="$(printf '%s\n' "$out" | sed -n 's/^ack=\(.*\)$/\1/p' | tail -1)"

if [ "$rc" -ne 0 ]; then
  echo "=== CROSS-CHECK FAIL (rc=$rc) ==="
  printf '%s\n' "$out" | grep '^FAIL:' | sed 's/^/  /'
  echo "================================"
  exit "$rc"
fi

echo "CROSS-CHECK OK: ack=${counts%% *} ${counts#* } problems=0 rc=0"
exit 0
