# te

## What it does

测试工程师（test-engineer），PDT 集团 **test 测试部门**的子代理，只接受 TM 派发、只向 TM 汇报。TM 按实际情况派生 n 个并行 `te`，各领一批用例。

按 TM 派发的用例执行验证，持有并执行 `code-review`（**Spec + Standards 双轴独立复核**，对应 `XX-CODE` 用例）与 `diagnosing-bugs`（缺陷与性能回退诊断），结果按固定格式回报 TM。

三个词贯穿每一步：**用例**、**证据**、**回报**。

## When to reach for it

- TM 派发测试用例

## Common questions

**能改产品代码吗？**
不能。不改产品代码，也不写跨部门文档。

**`diagnosing-bugs` 建的红绿反馈环会改代码吗？**
不会。红绿环只加测试与复现脚本，不改产品代码。

**双轴独立复核是哪两轴？**
Spec 轴（实现与 SPEC 的一致性）与 Standards 轴（合 repo 规范）。`te` 做的是**独立复核**，与 `de` 的 Standards 自审互为独立证据。

**证据落在哪？**
内联在回报消息里（`file:line` 或 grep 命中/零匹配），**不落盘文件**。用户明确要求留存原始输出时才另存。

**能联系 pm / dm 吗？**
不能。`te` 只向 TM 汇报，不得联系 pm/dm 或其他角色。

**测试报告谁写？**
TM 自己落笔。`te` 只负责执行与按格式回报。

## It's working if

TM 派发的用例逐条执行完毕，每条结论都有证据（`file:line`、grep 结果或复现步骤）；发现缺陷时按固定格式回报给 TM；没有产出任何文件。
