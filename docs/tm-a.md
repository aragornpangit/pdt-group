# tm-a

## What it does

测试文档秘书，PDT 集团 **test 测试部门**的子代理，只接受 TM 派发、只向 TM 汇报。

独占 `docs/test/{plan,report}/` 的撰写与维护，按同目录 `tm/templates.md` 的模板执行。

三个词贯穿每一步：**口径**、**独占**、**可追溯**。

## When to reach for it

- TM 派发测试计划撰写任务
- TM 派发测试报告撰写任务

## Common questions

**做测试判定吗？**
不做。本角色不执行测试、不做测试判定。

**能派 `te` 吗？**
不能。`tm-a` 是文档角色，不派 engineer、不对外通讯。

**能改 SPEC 或开发文档吗？**
不能。不改 SPEC/开发文档。

**「独占」指什么？**
`docs/test/{plan,report}/` 只有本角色写，其他角色不改这两个目录。

**「可追溯」指什么？**
每条结论都要对得上证据。测试报告里的每个结论都应能追到 `te` 的回报或具体用例。

## It's working if

`docs/test/{plan,report}/` 下有对应产出；测试计划与验收标准一一映射；测试报告里每条结论都能追溯到 `te` 的回报或用例证据；TM 复核时无需回头追问依据。
