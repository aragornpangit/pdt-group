# AGENTS.md：本仓的组织宪法（发布镜像仓）

本仓是 **pdt-group 角色技能族的发布镜像（release mirror）**，不是 skill 容器仓。容器仓（内网私有仓 `Skills`，`skills/pdt-group/<角色>/` 布局）是唯一写作现场；本仓由它单向同步而来，用于对外分发与阅读。

与容器仓宪法的差异：容器仓的 `skills/<bucket>/<name>/` 结构规则、§8 结构校验、多桶登记流程在本仓**不适用**（本仓是拍平布局）。本仓有自己的校验脚本（见第 4 节）。

## 1. 骨架（拍平布局：一角色一目录，直接放仓根）

```
.
├── AGENTS.md          # 本文件
├── README.md          # 面向人的总目录与安装说明
├── ACKNOWLEDGMENTS.md # 对上游 mattpocock/skills 的致谢
├── CHANGELOG 不在本仓维护，变更记录以容器仓为准
├── pm/  dm/  tm/  scout/   # 四个可安装角色，各含 SKILL.md 与附属参考文档
├── docs/              # 面向人的四段式角色说明（docs/<role>.md，与角色一一对应）
└── scripts/check-mirror.sh  # 本仓专属校验：结构、em-dash、死链、name 一致、docs 对应、SKILL.md 行数、纪律编号连续与悬空引用
```

**根目录不放 `SKILL.md`**；`SKILL.md` 只能出现在 `<role>/SKILL.md` 一层。

## 2. 角色与内容归属

- `pm` / `dm` / `tm` / `scout` 是四个可安装角色；`de` / `te` 是 DM / TM 派发阶段动态生成的子代理，**不装技能文件**（模板内嵌在 `dm/templates.md`、`tm/templates.md`）。另有两处按需派生、同样不装技能文件：PM 的取证 / 核查类子代理、Scout 的调研子代理（按需派数个 sub-agent）
- **集团口径唯一来源 = `pm/group-conventions.md`**：组织架构、通信、文档白名单、表达纪律、团队纪律表都只在那里写一份，四个角色的 SKILL.md 只留指针与角色特有的执行面，**不复述全文**（防多份漂移）
- **表达纪律唯一详细版 = `pm/communication-style.md`**：黑话对照表与 grep 自检只在这一份
- 改纪律先改 group-conventions.md，再核对各 SKILL.md 的指针与执行面描述仍然准确

## 3. 硬性纪律

1. **散文禁用 em-dash（U+2014）**。范围：一切 `.md` 与代码注释。要断句就改写（逗号 / 冒号 / 句号 / 括号 / 连词），严禁盲目字符替换。
2. **目录名必须等于该目录 `SKILL.md` 的 `name` 字段**。
3. **相对链接必须可达**；`docs/<role>.md` 与四个角色目录一一对应，不多不少。
4. **不留死代码**：内容废除就删除，不建 `deprecated/` 坟场；需要在别处留指针。
5. **凭证不入库**：任何文件不得出现明文密码 / token / PAT；示例一律用环境变量占位符。
6. **同步方向单向**：容器仓 → 本仓。在本仓直接改动会被下次同步覆盖；确需修改时先改容器仓再同步（急修可先落本仓，但必须登记回流）。
7. **SKILL.md 不超过 50 行**（2026-09-30 用户指定，`check-mirror.sh` 机检）：细则、长清单放同目录附属参考文档（如 `disciplines.md` / `templates.md`），SKILL.md 只留入口、核心约束与指针。交付物（SPEC / 计划 / 报告 / 调研）的行数上限是**基准**，可适当超出（见 group-conventions「写作纪律」）。

## 4. 校验（改完跑一遍）

```bash
bash scripts/check-mirror.sh
```

必须输出 `MIRROR-CHECK OK ... problems=0 rc=0` 且退出码 0。检查项（11 条）：

| # | 检查项 |
|---|---|
| 1 | 根目录无 SKILL.md |
| 2 | SKILL.md 只在 `<role>/` 一层 |
| 3 | frontmatter `name` 与目录名一致 |
| 4 | 全仓无 em-dash（U+2014） |
| 5 | `docs/<role>.md` 与角色目录一一对应 |
| 6 | 相对链接可达（剥离围栏代码块后） |
| 7 | `SKILL.md` ≤ 50 行 |
| 8 | 团队纪律表编号从 1 起连续无缺号 |
| 9 | 纪律编号引用不悬空：`团队纪律第 N 条` / `纪律 N` 全仓查，`group-conventions.md` 内的裸「第 N 条」也查（`dm` 的 19 条是另一张表，不查） |
| 10 | `pm/communication-style.md` §3 黑话对照表与 §4 grep 词表一致（防两表漂移 ⇒ 机检假绿） |
| 11 | `dm/disciplines.md` 条号 1 起连续，且与 `dm/SKILL.md` 声明的条数一致 |

第 9-11 条是 2026-10-04 补的（旧版只查 group-conventions.md 本文件，跨文件漏检，`pm/communication-style.md` 里那句引用一个已被删掉的旧编号就是这么漏过去的）。

> 容器仓布局的 `check-skills.sh`（抽取容器仓宪法 §8 执行）在本仓必然结构 FAIL，已删除；不要在本仓重建它。
