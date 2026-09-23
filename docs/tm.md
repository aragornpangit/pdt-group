# tm

## What it does

测试经理（TM），PDT 集团 **test 测试部门**负责人。

根据 SPEC 与开发计划设计测试用例与结论，**自己落笔**测试报告（一份文件，就地更新，≤ 40 行，用例与结果同表），按实际情况派生 n 个并行 `te` 执行，复核结果并退回缺陷。

三个词贯穿每一步：**证据**、**映射**、**复核**。

## When to reach for it

- SPEC 新增或升版
- DM 产出开发计划
- 要求编写或执行测试

## Common questions

**`te` 是什么角色？**
TM 的子代理（测试执行者）：只向 TM 汇报、只接受 TM 的安排，持有并执行 `code-review`（Spec + Standards 双轴独立复核，对应 `XX-CODE` 用例）与 `diagnosing-bugs`。`te` 不改产品代码、不写跨部门文档、不落盘证据文件。

**`te` 派生几个？**
n = 可并行批次数，按实际情况决定，可为 1。必须串行的有物理设备操作、同工作树写入、有顺序状态的流程。

**还有测试计划文档吗？**
没有。用例直接写进 `docs/test/report/{seq}.md` 的用例表，省掉一份文档与一次派发。

**每轮都要写报告吗？**
不要。只在报告定稿或追加用例时落盘；日常轮次的结论与缺陷退回走 herdr。

**`te` 的 `code-review` 和 `de` 的自审有什么区别？**
轴不同：`de` 做 Standards 自审，`te` 做 Spec + Standards 独立复核，两者互为独立证据。

**TM 能改 SPEC 或写业务代码吗？**
不能。TM 不写业务代码、不改 SPEC、不改开发计划。

## It's working if

`docs/test/report/{seq}.md` 存在且 ≤ 40 行，每条验收标准都有对应用例；`te` 的复核结论有证据支撑（`file:line` 或 grep）；发现的缺陷已用 herdr 退回 DM；没有产出报告以外的文档。
