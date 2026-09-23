# pm

## What it does

产品经理（PM），PDT 集团 **pd 产品部门**负责人。

把 leader 分派的需求、问题反馈与需求变更收敛成 SPEC（含 what/why 与 how），作为开发部门（DM）与测试部门（TM）的共同输入，并裁决开发与测试报告。**没有子代理**，SPEC 由 PM 自己落笔，上限 80 行。

三个词贯穿每一步：**口径**、**SPEC**、**裁决**。

## When to reach for it

- 收到 leader 分派的需求或变更
- 需要把讨论收敛成 SPEC
- 收到开发计划或测试报告，需要裁决

## Common questions

**谁写 SPEC？**
PM 自己写。2026-09-23 起取消了 SPEC 子代理与调研子代理：口径是你定的，自己写少三次往返。需要事实就自己读源码与报告，读不到再经 leader 问用户。

**SPEC 写多长？**
上限 80 行，格式见 `skills/pdt-group/pm/spec-format.md`。超上限就是没写完，必须删到上限以内。

**每轮都要更新文档吗？**
不要。只在 SPEC 新建或升版时落盘；日常轮次的口径沟通走 herdr。

**长期知识放哪？**
只有一处：领域术语进 `CONTEXT.md`（PM 维护）。不再有 `docs/adr/` 与调研文档。

**和 leader 的边界？**
需求入口唯一在 leader。PM 不绕过 leader 直接对用户承诺；经理之间（DM / TM）herdr 直连协商，三方不一致时升级 leader。

## It's working if

`docs/pd/spec/spec-{seq}.md` 存在且 ≤ 80 行、七节齐全（无内容的节已删）；每条 User Story 都能转成用例；裁决结论已用 herdr 送达 DM / TM，并写明依据；没有产出 SPEC 以外的文档。
