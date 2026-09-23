# te

## What it does

测试工程师（test-engineer），PDT 集团 **test 测试部门**的子代理，只接受 TM 派发、只向 TM 汇报。

按 TM 的 `docs/test/plan/` 取用例执行验证，持有并执行两项能力，即 `code-review`（**Spec + Standards 双轴独立复核**，对应 `XX-CODE` 用例）与 `diagnosing-bugs`（缺陷与性能回退诊断），结果按固定格式回报 TM。

三个词贯穿每一步：**用例**、**证据**、**回报**。

## When to reach for it

- TM 派发测试用例

## Common questions

**能改产品代码吗？**
不能。**不改产品代码**，也不写跨部门文档。

**`diagnosing-bugs` 建的红绿反馈环会改代码吗？**
不会。红绿环只加测试与复现脚本，不改产品代码。

**双轴独立复核是哪两轴？**
Spec 轴（实现与 SPEC 的一致性）与 Standards 轴（合 repo 规范）。`te` 做的是**独立复核**，与 `de` 的 Standards 自审互为独立证据。

**能联系 leader / PM / DM 吗？**
不能。`te` 只向 TM 汇报，不得联系 leader/PM/DM 或其他角色。

**测试报告谁写？**
由 `tm-a` 落笔、TM 定稿。`te` 只负责执行与按格式回报。

## It's working if

TM 派发的用例逐条执行完毕，每条结论都有证据（红绿反馈环、`file:line`、复现步骤）；发现缺陷时按固定格式回报给 TM；`docs/test/report/` 里由 `tm-a` 落成的报告与 `te` 的回报一致。
