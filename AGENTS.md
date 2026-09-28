# AGENTS.md：本仓的组织宪法

本仓是一个 **skill 容器仓**（monorepo of skills）。这份文件写的是**组织规则**，不是某个技能的内容。改仓库结构前先读这里。

方法论出处：`p00292/monorepo`。本仓遵循其主体规则，但有一处**刻意偏离**，见第 2 节。

---

## 1. 骨架

```
Skills/
├── AGENTS.md          # 本文件：仓库宪法
├── CHANGELOG.md       # 变更记录
├── README.md          # 面向人的总目录
├── skills/            # 唯一放技能的地方
│   └── <bucket>/<skill-name>/
└── docs/              # 人读文档，镜像 skills/ 的桶结构
    └── <bucket>/<skill-name>.md
```

**根目录不放 `SKILL.md`。** 放了就退化成「一个大技能」，不再是容器。

## 2. 分桶：按功能语义（对方法论的刻意偏离）

参考方法论要求**按生命周期**分桶（推广 / 非推广）。**本仓不这么做**，改为**按功能语义**分桶：

| 桶 | 收什么 |
|---|---|
| `network/` | 网络、代理、隧道、远程接入 |
| `gitlab/` | 内部 GitLab 的使用（建项目、推送、Web 登录） |
| `llm-serving/` | LLM 推理服务的部署与运维 |
| `agent-tooling/` | Agent 工具链集成，以及技能仓自身的方法论 |
| `annotation/` | 数据标注平台的运维与任务创建 |
| `pdt-group/` | PDT 集团的角色技能族（一级部门加三个二级部门，共 10 个角色） |
| `internal-systems/` | 公司内部系统（宇视 Portal / SSE / BPM）的流程申请与审批自动化 |
| `im-cli/` | 即时通讯 CLI（钉钉 `dws`、飞书 `lark-cli`）的连接配置台账 |
| `ml-tooling/` | 机器学习数据的增广与端侧模型构建 |

**偏离理由**：本仓技能的生命周期差异不明显，多数技能都是长期可用的；按功能分桶更利于**检索**（想配代理就去 `network/`，想推代码就去 `gitlab/`）。生命周期信息改由 `CHANGELOG.md` 承载。

**代价（必须知情）**：方法论里「推广桶 vs 非推广桶」这条杠杆没了，因此**本仓没有「非推广桶」**，所有桶的技能都进顶层 README 与 `docs/`。若将来需要「留着但不推广」的技能，回到方法论的生命周期分桶，不要在本方案上打补丁。

**方法论原文与差异对照**：`skills/agent-tooling/monorepo/SKILL.md` 保存的是**上游方法论**，其文首「偏离声明」逐条列出它与本仓的 6 处差异（本节的刻意偏离是其中唯一刻意的一处）。两者冲突时，以本文件为准。

**本仓是异构的**：`pdt-group/` 是一个完整的团队角色族（5 个角色，有内部层级与依赖），与其余五个桶的个人工具链性质不同。这是「按功能语义分桶」的必然结果，不是失误。它的集团规范集中在 `pdt-group/pm/group-conventions.md`，本文件不重复。

**新增一个桶的条件**：至少 2 个技能，且都不适合放进现有桶。只有一个技能时不要为它建桶（`annotation/` 目前只有 1 个，是用户指定的既有安排）。

## 3. 单技能解剖

```
skills/<bucket>/<skill-name>/
├── SKILL.md          # 必需。技能本体 + YAML frontmatter
├── scripts/          # 可选。技能自带的脚本
└── *.md              # 可选。技能的附属文档（如 reference.md）
```

**目录名必须等于 `SKILL.md` 里的 `name` 字段。**

frontmatter 要求：

| 字段 | 必填 | 说明 |
|---|---|---|
| `name` | 是 | 与目录名一致 |
| `description` | 是 | 触发语要**丰富**：model-invoked 的技能全靠它被自动够到 |
| `disable-model-invocation` | 否 | `true` = 只能由人敲 `/xxx` 触发。见第 4 节 |

## 4. 分类轴：user-invoked vs model-invoked

这是**唯一的分类轴**。

| | 判定 | 职责 |
|---|---|---|
| **User-invoked** | `disable-model-invocation: true` | 只有人敲 `/xxx` 才触发；**编排** |
| **Model-invoked** | 无此字段，靠 `description` 触发语 | 人可敲，**模型也能自动够到**；承载可复用**纪律** |

**当前状态：本仓 38 个技能全部是 model-invoked**，都没有 `disable-model-invocation`。

`gitlab-push` 的 `description` 里带 `/gitlab-push` 触发词，但它**不是** user-invoked：用户日常说的是「推到 gitlab」，加上 `disable-model-invocation: true` 会让模型不再自动够到它，属于行为回退。`herdr` 的 `description` 明确写了「仅在用户明确提到 Herdr 时使用」，但那是靠描述约束，不是靠开关，同样不加该字段。

**硬约束**：user-invoked 可以调 model-invoked，**绝不能调另一个 user-invoked**。

## 5. 登记：改动技能要同步 4 处

新增、改名、删除任何技能，下面 4 处**要么都有、要么都没有**：

| # | 位置 | 范围 |
|---|---|---|
| 1 | 顶层 `README.md` 的技能表 | 全部技能 |
| 2 | 桶内 `skills/<bucket>/README.md` | 本桶技能 |
| 3 | `docs/<bucket>/<skill-name>.md` | 全部技能 |
| 4 | `CHANGELOG.md` | 记这次改动 |

> 参考方法论的第 3 处是 `.claude-plugin/plugin.json`。**本仓不适用**：本仓不是 Claude Code 插件仓，各机器是**复制式安装**（见第 7 节），没有插件清单。

## 6. 硬性纪律

1. **散文禁用 em-dash（U+2014）**。范围：`SKILL.md`、`docs/`、`README.md`、`AGENTS.md`、`CHANGELOG.md`、代码注释。要断句就**改写**（逗号 / 冒号 / 句号 / 括号 / 连词），**严禁盲目字符替换**。校验见第 8 节。
2. **每条目一行**：桶内 README 每个技能一行，一行描述。
3. **登记一致性**（第 5 节）。
4. **不留死代码**：技能退役即**删除目录**，不建 `deprecated/` 之类的坟场，在 `CHANGELOG.md` 记明替代者。
5. **相对链接必须可达**：`SKILL.md` 与 `docs/` 里的相对链接，目标文件必须存在。校验见第 8 节。

## 7. 安装约定：仓内分桶，装到 harness 要拍平

仓内路径是 `skills/<bucket>/<skill-name>/`，但安装到 harness 的技能目录时要**拍平**：

```
skills/<bucket>/<skill-name>/   →   <harness-skills-dir>/<skill-name>/
```

**这条很重要**：多个 `SKILL.md` 里引用了安装后的绝对路径，例如

- `gitlab-push/SKILL.md` 引用 `~/.pi/agent/skills/gitlab-push/scripts/gitlab_tunnel.sh`
- `login-gitlab-web-l490/SKILL.md` 同样引用上面那条
- `cbc-herdr/SKILL.md` 让把 `scripts/herdr-agent-state.sh` 拷到 `~/.codebuddy/hooks/`

只要按「拍平」安装，这些引用就继续有效；若把桶层级也带进 harness 目录，它们全部失效。

安装示例（Linux / Git Bash）：

```bash
cp -r skills/network/adb-tunnel ~/.pi/agent/skills/adb-tunnel
```

## 8. 校验清单（改完结构跑一遍）

在仓库根目录执行。任一项失败会打印 `FAIL:` 行并**以非零码退出**，可以直接用在 CI 或 pre-commit 里。

```bash
python3 - <<'EOF'
import pathlib, re, sys

root = pathlib.Path('.')
fails = []

skills = {}          # skill-name -> (bucket, skill_dir)
for f in sorted(root.glob('skills/*/*/SKILL.md')):
    bucket, name = f.parts[1], f.parts[2]
    skills[name] = (bucket, f.parent)

# 1) 根目录不许有 SKILL.md
if (root / 'SKILL.md').exists():
    fails.append('根目录出现了 SKILL.md')

# 2) 所有 SKILL.md 必须在 skills/<bucket>/<name>/ 下
for f in sorted(root.rglob('SKILL.md')):
    if '.git' in f.parts or len(f.parts) != 4:
        fails.append(f'技能不在 skills/<bucket>/<name>/ 下: {f}')

# 3) frontmatter 的 name 必须等于目录名
for name, (bucket, d) in skills.items():
    head = (d / 'SKILL.md').read_text(encoding='utf-8').split('---')[1]
    m = re.search(r'^name:\s*(.+)$', head, re.M)
    got = m.group(1).strip() if m else None
    if got != name:
        fails.append(f'{d}/SKILL.md 的 name={got}，目录名={name}')

# 4) 全仓禁用 em-dash（U+2014），按码点判定，规则文档自身不会误报
for p in sorted(root.rglob('*.md')):
    if '.git' in p.parts:
        continue
    for i, line in enumerate(p.read_text(encoding='utf-8').splitlines(), 1):
        if '\u2014' in line:
            fails.append(f'em-dash: {p}:{i}')

# 5) docs/ 与 skills/ 必须一一对应
for name, (bucket, _) in skills.items():
    if not (root / 'docs' / bucket / f'{name}.md').exists():
        fails.append(f'缺 docs/{bucket}/{name}.md')
for p in sorted(root.glob('docs/*/*.md')):
    if p.stem not in skills:
        fails.append(f'多余的 docs 页（无对应技能）: {p}')

# 6) 相对链接必须可达（fence 用变量拼，避免在本代码块里出现三反引号而截断围栏）
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

for f in fails:
    print('FAIL:', f)
print(f'\n技能数: {len(skills)}，问题数: {len(fails)}')
sys.exit(1 if fails else 0)
EOF
```

改完结构后跑一次，必须输出「问题数: 0」并以退出码 0 结束。

**推荐用封装脚本**（2026-09-28 立）：`bash scripts/check-skills.sh`，它内部**显式取 rc**，非零即 **loud FAIL** 并打印 `FAIL:` 摘录（含 `file:line`），**调用方只看它的退出码**；这样避免「管道后取 rc」丢码（TM 实测三次复发、已工具化）。

## 9. 新增一个技能的步骤

1. 定桶（第 2 节），建 `skills/<bucket>/<name>/`
2. 写 `SKILL.md`（第 3 节 frontmatter），定 user / model-invoked（第 4 节）
3. 登记 4 处（第 5 节）
4. 写 `docs/<bucket>/<name>.md`（四段式，见下）
5. 跑第 8 节校验
6. `CHANGELOG.md` 加一条

## 10. docs 页格式（四段式）

`docs/<bucket>/<name>.md` 固定四段，面向「我该不该用它」，**从 `SKILL.md` 提炼而不是复制**：

1. **What it does**
2. **When to reach for it**
3. **Common questions**
4. **It's working if**

## 11. 凭证纪律：一律外置，禁止入库

`SKILL.md`、`scripts/`、示例代码里**不得出现任何明文凭证**（密码、token、PAT、私钥口令）。本仓是私有仓，但这不构成理由：提交过的凭证会永久留在 git 历史里，删除文件也抹不掉。

**做法**：凭证集中放本机 `~/.config/uniview/.env`（权限 `600`），技能优先读环境变量，读不到再回落到该文件。

| 键 | 用途 |
|---|---|
| `UNIVIEW_ACCOUNT` | 宇视 Portal / BPM / SSE / aTrust 账号 |
| `UNIVIEW_PASSWORD` | 同上密码（aTrust 门户登录用的是同一个，末尾带小数点） |
| `UNIVIEW_SSH_PASSWORD` | `10.223.32.19` 主机 SSH 密码；本机 `sudo` 免交互也用它（`echo "$UNIVIEW_SSH_PASSWORD" \| sudo -S ...`） |

- `SKILL.md` 的命令示例一律写占位符，例如 `--password "$UNIVIEW_PASSWORD"`，并在「Prerequisites」里说明凭证从哪来
- 脚本内的凭证读取封装成一段本地 helper（先查环境变量，再解析 `.env`），不要在每个脚本里各写一份解析逻辑
- `.env` 由 `.gitignore` 屏蔽：`.env`、`**/.env`、`*.env`；仓库根的 `.env.example` 是模板（全假值），复制到 `~/.config/uniview/.env` 后改真值
- 新增或修改技能后，提交前自检 `skills/` 下不得有凭证字面量（第 8 节校验脚本之外单独跑一次 grep）
- 若某个技能确实需要展示真实格式，用 `.env.example` 的假值，绝不用真值
- 历史文档里出现过的密码字面量可能已过期或抄错（同一口令的标点变体很多，实测常与 `.env` 对不上）；一律以 `~/.config/uniview/.env` 为准，不要照抄旧文档
- 账号与密码同等对待：不要在脚本里把账号写死成 `_cred` 的默认值；读不到就报错退出，不要静默用空值继续跑
