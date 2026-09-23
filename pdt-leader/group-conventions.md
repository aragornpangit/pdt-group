# PDT 集团口径：目录 / 命名 / 看板 / 交接 / 通信

本文件是 PDT 集团的**唯一规范来源**。看板本体是各项目 `docs/status.md`，其格式由本文件定义。

## 组织架构

```
pdt-group（一级部门）
└── pdt-leader            集团领导 · 用户入口
    ├── pd  产品部门      经理 pm
    │   ├── pd-researcher × N   调研      → docs/pd/research/
    │   └── pd-spec-e           SPEC      → docs/pd/spec/
    ├── dev 开发部门      经理 dm
    │   ├── dm-a                开发文档  → docs/dev/{plan,report}/
    │   └── de × N              纵向切片  → .worktrees/{ticket}
    └── test 测试部门     经理 tm
        ├── tm-a                测试文档  → docs/test/{plan,report}/
        └── te × N              测试执行  → docs/test/evidence/
```

- 子代理只向**本部门经理**汇报，只接受本部门经理安排
- **经理间直通**：PM/DM/TM 横向直接协商；三方无法一致时升级 leader 裁决，结论落 `docs/status.md`
- 多实例命名：`pd-researcher` 用编号实例（`-1`/`-2`/`-3`…）；`de`/`te` 用同名多实例（数量分别由工单数、可并行测试数决定）

## 目录布局

```
CONTEXT.md               # 领域术语与语言（PM 独占，长期知识）
docs/
├── status.md            # 集团共享看板
├── handoff/             # 四个负责人的会话自我交接
├── adr/                 # 架构决策记录：NNNN-{slug}.md（DM 独占，长期知识）
├── pd/
│   ├── research/        # 调研结论（pd-researcher 独占，按需）
│   └── spec/            # SPEC（pd-spec-e 独占；含 what/why 与 how，产品部门唯一交付文档）
├── dev/
│   ├── plan/            # 开发计划：{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}/ 目录，内含 README.md（设计决策与技术架构）与一 ticket 一文件（dm-a 独占，轮次）
│   ├── report/          # 进度报告（dm-a 独占，轮次）
│   └── evidence/        # 开发证据（de / DM 独占）
└── test/
    ├── plan/            # 测试计划（tm-a 独占，基线累积用例）
    ├── report/          # 测试报告（tm-a 独占，轮次）
    └── evidence/        # 测试证据（te 独占）
```

目录缺失时 `mkdir -p`。

## 文件命名

一条规则区分全部文件：**名字里有 `YYYYMMDD-HHmm` 的是轮次产出（每轮新建），没有的是基线文档（升版改同一文件）**。开发计划的轮次产出是一个**目录**（内含计划本体与各 Ticket 文件）；基线文档目前只有 `CONTEXT.md`、`docs/adr/` 与测试计划。

| 文档 | 命名 |
|---|---|
| SPEC | `spec-{seq}-{feature-key}.md` |
| 调研 | `research-{YYYY-MM-DD}-{seq}-{topic-key}.md` |
| 开发计划 | `{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}/`（目录，内含 `README.md` 与 `{NN}-{slug}.md`） |
| 进度报告 | `{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}.md`（与计划目录同名） |
| 测试计划 | `test-plan-{seq}-{feature-key}.md` |
| 测试报告 | `{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}.md` |

- **`{seq}` 是整条链的锚**：同一需求在 SPEC、开发计划、测试报告里用同一个 seq，由 DM 写 plan 时生成，其余沿用
- 调研的日期取创建日，不随升版变
- 测试计划按基线处理（升版覆盖）而非轮次，因为它要**累积用例**：SPEC 升版时把「旧值零残留」的 CODE 用例追加进同一份计划

## 证据目录

| 目录 | 归属 | 命名 |
|---|---|---|
| `docs/dev/evidence/` | `de` / DM | `{seq}-{feature-key}/` |
| `docs/test/evidence/` | `te` | `{seq}-{feature-key}/` |

- **不加轮次时间戳**：同一需求的证据在同一目录内**累积**
- **原始文本类证据必须落盘为文件**（命令输出、运行日志、状态抓取等），不得只存在于会话上下文；截图类按用例编号前缀命名
- **只增不改**：需更正时**新增更正文件**，不覆盖原证据；被证伪的结论保留**废止记录**（标注「已废止 + 更正者 + 更正值」）
- 报告正文对每条结论给 `file:line` 或「文件名 + 行号」，不接受无证据结论
- 各写各的目录，不跨部门代写

## 看板格式

首个 SPEC 创建时初始化（实际只留表头，删掉示例行）：

```markdown
# 需求状态看板

| SPEC | 标题 | SPEC版本 | 开发计划 | 开发状态 | 测试计划 | 测试状态 | 更新时间 |
|---|---|---|---|---|---|---|---|
| spec-001-user-sync | 用户同步 | v1.0 | 001-user-sync-20260810-1430-v1.0 | 已提交 | test-plan-001-user-sync | 待编写 | 2026-08-10 |
```

- 每行一个需求项，更新时间一律写绝对日期
- PM：新增行，维护 `SPEC` / `标题` / `SPEC版本`
- DM：维护 `开发计划` / `开发状态`，取值 `规划中` / `实施中` / `已提交` / `待验证`
- TM：维护 `测试计划` / `测试状态`，取值 `待编写` / `待执行` / `通过` / `阻塞` / `需修复`
- leader：只读总览，跨部门裁决结论写入本表
- 看板与实际状态不一致时，以实际状态为准并回写看板
- `开发计划` 列一个值可推出 `docs/dev/plan/{值}/`（目录）、`docs/dev/report/{值}.md`、`docs/test/report/{值}.md`

## 交接（handoff）

**只用于自我交接**：仅 `pdt-leader` / `pm` / `dm` / `tm` 在**自己的会话收尾**时，给未来的自己留一份交接文档，用 mattpocock 的 [`/handoff`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/handoff/SKILL.md) 生成，统一落 `docs/handoff/`，命名 `handoff-{role}-{主题}-{yyyymmdd-HHmmss}.md`（role ∈ leader / pm / dm / tm）。

**不做角色之间的 handoff**：跨角色传递走 herdr 消息与 `docs/status.md`；子代理不写 handoff。

- 触发：本角色会话即将结束且工作未闭环，或用户明确要求
- 写作纪律：先 commit 并 push，以远程为准（未推送的必须在文档中显式标注）；只写接手所需的最小充分信息；交接前先更新看板对应行；自包含，不依赖本次会话记忆
- 接手流程：读最新 handoff（按时间戳排序）→ 核验环境与产物（环境在线状态、产物 SHA、工作树 diff、证据目录存在性）→ 与看板对照，不一致以实际为准并回写 → 按 Next Move 执行

## 通信：herdr 优先，看板兜底

leader 与 PM/DM/TM、以及三个经理之间，都用 `herdr` 定向沟通（CLI 语法见 herdr 技能本身，本仓不附带）。herdr 不可用时退回**文件通道**：把进度与结论写进 `docs/status.md`，靠 md 文件互相感知。

两条通道不冲突：能发 herdr 消息就发，同时把进度落盘。消息会丢，文件不会。

| 角色 | 读 | 写 | 维护的看板列 |
|---|---|---|---|
| leader | 全部 | `docs/handoff/`、看板裁决项 | 总览（不占列） |
| PM | `dev/report`、`test/report`、`dev/plan`、`test/plan` | `pd/research`、`pd/spec`、`CONTEXT.md`、`docs/handoff/` | SPEC、标题、SPEC版本 |
| DM | `pd/spec`、`test/report`（修复类） | `dev/plan`、`dev/report`、`dev/evidence`、`docs/adr/`、`docs/handoff/` | 开发计划、开发状态 |
| TM | `pd/spec`、`dev/report` | `test/plan`、`test/report`、`test/evidence`、`docs/handoff/` | 测试计划、测试状态 |

- 每轮开工先读一次本文件
- 产出落盘即更新自己那一行；跨部门结论写进看板，不靠转述
- 需要对方裁决或接手的内容走 herdr 定向消息或写进看板（**不用 handoff**）
- 收件人按 tab label 现查（label 稳定，pane ID 重启会变），不写死 ID
- 上游更新由用户/leader 触发，或在本轮任务开始时检查一次，不做轮询

## 会话与 label

会话名固定 `leader` / `pm` / `dm` / `tm`，label 集合 `{leader, pm, dm, tm}`。

## 跨技能引用纪律

- **指针化**：目录布局、看板格式、命名规则、herdr CLI 语法只留一处（本文件），其余指向它
- **自包含**：验证方法、断言语义这类会被反复改写的具体条目，各技能自己写全，注明「与 X 侧同名同义」，不指向对方，避免对方改表时静默漂移
