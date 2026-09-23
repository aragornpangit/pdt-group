# 开发部门（dev）模板（DM）

设计决策与技术架构落在开发计划的 `README.md`（DM 定口径、`dm-a` 落笔）；跨轮的架构决策由 DM 落 `docs/adr/`。

开发计划与进度报告是轮次产出，共享同一命名 `{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}`：**计划是目录**，**报告是同名文件**。

## 开发计划（docs/dev/plan/{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}/）

一个需求一个计划**目录**，内含计划本体与各 Ticket 文件。**一 ticket 一文件**，不合并成单文件。

```
docs/dev/plan/{seq}-{feature-key}-{YYYYMMDD-HHmm}-v{x.y}/
├── README.md          # 计划本体
├── 01-{ticket-slug}.md
├── 02-{ticket-slug}.md
└── ...
```

### README.md（计划本体）

```markdown
# 开发计划：{功能标题}

- 编号：{seq}
- 创建时间：{YYYY-MM-DD HH:mm}
- 版本：v{x.y}（跟随 SPEC 版本）
- 分支：`{branch}`（基于 commit {hash}）
- 关联 SPEC：`docs/pd/spec/{spec-file}`
- 关联测试报告：`docs/test/report/{report-file}`（修复类填写）
- Ticket：本目录 `01-*.md` 起

## 背景

{从 SPEC 或测试报告提取的摘要}

## 设计决策

### 1. {决策标题}
- **Why:** {理由、约束、权衡}
- **How:** {文件、函数、常量、逻辑；用 codebase-design 的 seam / deep module 词汇描述}

## 技术架构

### 分层与依赖方向

### 组件职责

| 组件 | 职责 | 依赖 |
|---|---|---|

### 数据流

## 接口契约

| 接口 | 输入 | 输出 | 约束 |
|---|---|---|---|

## 关键流程

## 风险与取舍

## 验收标准映射

| # | 验收标准 | 实现位置 | 验证方式 |
|---|---|---|---|

## 依赖图

01 ──┐
02 ──┼──> 04
03 ──┘

## 并行批次

| 批次 | Ticket | 说明 |
|---|---|---|
| 1 | 01, 02, 03 | 无依赖边、无文件冲突，并行派发 |
| 2 | 04 | 依赖批次 1 全部完成 |

## 运行时验证

{需运行环境才能执行的项；范围排除见 SPEC 的 Out of Scope}
```

### Ticket 文件（`{NN}-{slug}.md`）

编号按**依赖序**（blockers first），从 `01` 起。

```markdown
# {NN}: {Ticket 标题}

- **目标:** {端到端行为，从用户视角描述，不是逐层实现清单}
- **Blocked by:** {阻塞它的 Ticket 编号，无则 "None（可立即开工）"}
- **Files:** {涉及文件}
- **验收标准:** {可勾选条目}
- **TDD 接缝:** {在哪个行为上先红后绿}
- **完成定义:** 构建通过 + 单测通过 + 自审 Standards 轴通过 + 在 worktree 分支内 commit
```

### 切片细则

内化自 mattpocock [`to-tickets`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md)（2026-09-21），DM 直接执行，不依赖 `/to-tickets` 命令：

- 每片切一条**窄而完整**的通路（贯穿 schema / API / UI / 测试），**纵向而非横向分层**；可独立演示或验证；能在单个 fresh 上下文内完成
- 先做 **prefactor**（"先让改动变容易，再做容易的改动"）
- **宽重构例外**：机械改动（重命名、改共享类型）波及面大、无法单片保持绿色时，按 **expand（新旧并存）→ migrate（按包 / 目录分批，各自成片）→ contract（删旧）** 排序；批次无法独立保持绿色时共用集成分支，由一个 integrate-and-verify 片兜底
- Ticket 描述**避免写具体文件路径与代码片段**（易过期）；例外：prototype 产出的、比散文更精确的决策片段（状态机 / reducer / schema / 类型形状）可内联并注明来自 prototype
- **发布前把切片清单交用户过一遍**（粒度、blocking 边、是否合并或拆分），迭代到批准

## 进度报告（docs/dev/report/）

```markdown
# 开发进度报告：{功能标题}

- 报告日期：{YYYY-MM-DD}（编号与时间戳沿用计划目录名，作为关联键）
- 分支：`{branch}`
- 对应计划：`docs/dev/plan/{同名目录}/`
- 关联 SPEC：`docs/pd/spec/{spec-file}`

## 总体状态

| 维度 | 状态 |
|---|---|
| 计划制定 | 完成 |
| Ticket 拆分 | 完成（Ticket 01~NN） |
| 代码实施 | 完成（Ticket 01~NN） |
| 构建闸 | BUILD SUCCESSFUL |
| 全量测试 | 通过 / {失败项} |
| 运行时验证 | 待环境就绪 |

## 逐 Ticket 完成情况

| Ticket | 负责 de | 分支 | Commit | TDD | 验收标准 | 状态 |
|---|---|---|---|---|---|---|

## TDD 执行记录

| Ticket | Red | Green | Refactor | Build | Assert |
|---|---|---|---|---|---|

## 修改文件清单

| 文件 | 改动行 | 类型 |
|---|---|---|

## 运行时待验证项
```

验收结果见「逐 Ticket 完成情况」表；范围排除见 SPEC 的 Out of Scope。

状态列用文字（完成 / 阻塞 / 待验证），不用 emoji，除非用户要求。
