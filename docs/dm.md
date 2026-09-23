# dm

## What it does

开发经理（DM），PDT 集团 **dev 开发部门**负责人。

根据 SPEC 定设计决策与切片口径，**自己落笔**开发计划与进度（一份文件，就地更新，≤ 50 行），把 plan 拆成 tracer-bullet 纵向切片，按实际情况派生 n 个并行 `de` 在 git worktree 内实施，最后验收合并。

三个词贯穿每一步：**接缝**、**切片**、**实证**。

## When to reach for it

- SPEC 或测试报告更新
- 要求制定或执行开发计划
- 收到需修复的测试报告（缺陷退回）

## Common questions

**Ticket 从哪来？**
把设计决策落成 `docs/dev/plan/{seq}.md`，再拆成 tracer-bullet 纵向切片（每片贯穿各层、可独立验证、单上下文可完成），按依赖序编号，**默认一张表**。切片流程内化自 mattpocock `to-tickets`（见 [`dm/templates.md`](../dm/templates.md) 的「切片细则」）。

**`de` 派生几个？**
n = 当前可并行 ticket 数（依赖图的宽度），按实际情况决定，可为 1。**同一文件被多个 ticket 触碰时降为串行。**不要为了「用满 n」而把任务拆碎。

**DM 写哪些文档？**
只有一份：`docs/dev/plan/{seq}.md`，计划与进度同文件，≤ 50 行。不写进度报告、不写 ADR、不写设计文档。只在计划有实质变更时更新，不每轮写。

**DM 能写业务代码吗？**
不能。DM 不写业务代码、不改 SPEC、不写测试报告。

**汇报拓扑是怎样的？**
DM 是开发部门唯一中心。`de` **只向 DM 汇报、只接受 DM 的安排**，不得直接联系 pm/tm 或其他角色，也不得写跨部门文档。

## It's working if

`docs/dev/plan/{seq}.md` 存在且 ≤ 50 行，含设计决策（每条有 Why 与 How）与 ticket 表；每个 `de` 在独立 worktree 分支内提交，DM 复核后合并；进度与验收结论已用 herdr 送达 pm 与 tm。
