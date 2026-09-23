# dm

## What it does

开发经理（DM），PDT 集团 **dev 开发部门**的负责人。根据 SPEC 文档定设计决策与切片口径，派 `dm-a` 撰写开发计划目录（`README.md` 计划本体，含设计决策与技术架构节 ＋ 一 ticket 一文件的各切片）与进度报告，把 plan 拆成 tracer-bullet 纵向切片后派单给 `de` 在 git worktree 内实施，最后验收合并。

三个词贯穿每一步：**接缝**、**切片**、**实证**。

## When to reach for it

- SPEC 或测试报告更新
- 要求制定或执行开发计划
- 收到需修复的测试报告（缺陷退回）

## Common questions

**Ticket 从哪来？**
把已写好的 plan 拆成 tracer-bullet 纵向切片（每片贯穿各层、可独立验证、单上下文可完成），声明 blocking 边，按依赖序编号，**一 ticket 一文件**落 `docs/dev/plan/{计划目录}/{NN}-{slug}.md`。切片流程内化自 mattpocock `to-tickets`（见 `dm/templates.md` 的「切片细则」），不依赖 `/to-tickets` 命令。

**`de` 派生几个？**
n = 当前可并行 ticket 数（依赖图的宽度）。**同一文件被多个 ticket 触碰时降为串行。**不要为了「用满 n」而把任务拆碎。

**DM 能写业务代码吗？**
不能。DM 不写业务代码、不改 SPEC、不写测试计划。

**汇报拓扑是怎样的？**
DM 是开发部门唯一中心。子代理 `dm-a` / `de` **只向 DM 汇报、只接受 DM 的安排**，不得直接联系 leader/TM/PM 或其他 engineer，也不得写跨部门文档（`docs/pd/`、`docs/test/` 下任何文件）。产出只落本 ticket 的 worktree 分支与 DM 指定位置。

**设计决策写什么？**
落在开发计划目录的 `README.md`：背景、设计决策、技术架构（分层与依赖方向 / 组件职责 / 数据流）、接口契约、关键流程、风险与取舍。每条决策写成 **Why**（理由、约束、权衡）加 **How**（文件、函数、常量、逻辑）。跨轮的架构决策由 DM 另落 `docs/adr/`。

## It's working if

`docs/dev/plan/` 下的计划目录（`README.md` 含设计决策与技术架构，决策都有 Why 与 How ＋ `{NN}-{slug}.md`）与 `docs/dev/report/` 同名报告由 `dm-a` 落笔；每个 `de` 在独立 worktree 分支内提交，DM 复核后合并；`docs/status.md` 的开发两列（`开发计划` / `开发状态`）由 DM 维护，取值 `规划中` / `实施中` / `已提交` / `待验证`。
