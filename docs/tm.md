# tm

## What it does

测试经理（TM），PDT 集团 **test 测试部门**的负责人。根据 SPEC 文档与开发进度报告设计测试用例与结论，派 `tm-a` 撰写测试计划与测试报告，按可并行测试数派发 `te` 子代理并行执行，复核结果并退回缺陷。

三个词贯穿每一步：**证据**、**映射**、**复核**。

## When to reach for it

- SPEC 新增或升版
- DM 产出进度报告
- 要求编写或执行测试

## Common questions

**`te` 是什么角色？**
TM 的子代理（测试执行者）：只向 TM 汇报、只接受 TM 的安排，持有并执行两项能力，即 `code-review`（**Spec + Standards 双轴独立复核**，对应 `XX-CODE` 用例）与 `diagnosing-bugs`（缺陷与性能回退诊断）。`te` 不改产品代码、不写跨部门文档。

**`te` 派生几个？**
按可并行测试数派生。

**通讯拓扑是怎样的？**
TM 是测试部门唯一中心。`tm-a` / `te` 只向 TM 汇报，不得联系 leader/PM/DM 或其他角色，不写跨部门文档。TM 把各 engineer 的返回复核归并后，交 `tm-a` 落成统一测试报告。

**`te` 的 `code-review` 和 `de` 的自审有什么区别？**
轴不同：`de` 做 Standards 自审，`te` 做 Spec + Standards 独立复核，两者互为独立证据。

**TM 能改 SPEC 或写业务代码吗？**
不能。TM 不写业务代码、不改 SPEC、不改开发计划。

## It's working if

`docs/test/plan/` 与 `docs/test/report/` 由 `tm-a` 落笔；每条验收标准都有对应用例，没有漏测；`te` 的复核结论有证据支撑（红绿反馈环、`file:line`）；发现的缺陷已按格式退回；`docs/status.md` 的测试两列（`测试计划` / `测试状态`）由 TM 维护，取值 `待编写` / `待执行` / `通过` / `阻塞` / `需修复`。
