# pm

## What it does

产品经理（PM），PDT 集团 **pd 产品部门**的负责人。把 leader 分派的需求、问题反馈与需求变更收敛成 **SPEC**（产品部门唯一交付文档，同时承载 what/why 与 how），作为开发部门（DM）与测试部门（TM）的共同输入，并裁决开发与测试报告。

下属两个子角色，按需派生：`pd-researcher` × N（调研）、`pd-spec-e`（SPEC）。

三个词贯穿每一步：**证据**、**可测**、**看板**。

## When to reach for it

- 收到 leader 分派的需求或变更
- 需要把讨论收敛成 SPEC
- 收到开发报告或测试报告，需要裁决
- 调研面大、需要并行取证（此时 PM 会派生多个 `pd-researcher`）

## Common questions

**`pd-researcher` 是单例吗？**
**不是**。调研面大、需要并行取证时，PM 可一次派生多个（`pd-researcher-1`、`pd-researcher-2`、`pd-researcher-3` 等），各领一条调研线独立取证、分别向 PM 汇报。产出统一落 `docs/pd/research/`，靠命名里的 `{seq}` / `{topic-key}` 区分文件。派发时要在 prompt 里写明该实例负责的调研线与产出文件名，避免多实例写同一文件。

**PM 能写代码或执行测试吗？**
不能。PM 不写代码、不执行测试、不制定开发或测试计划，这些分别属于 DM 与 TM。

**SPEC 谁写？**
PM 负责口径与裁决，实际落笔派给 `pd-spec-e`。SPEC 是产品部门唯一交付文档，含 what/why（问题与方案）与 how（实现决策与测试决策），不再另写 PRD。

**产出落在哪？**
`docs/pd/spec/`、`docs/pd/research/`，以及长期知识 `CONTEXT.md`（领域术语，PM 维护）；目录布局与命名以 `group-conventions.md` 为唯一来源。SPEC 用完即弃，长期知识进 `CONTEXT.md` 与 `docs/adr/`。

**和 leader 的边界？**
需求入口唯一在 leader。PM 不绕过 leader 直接对外承诺。三方经理之间有分歧时升级 leader 裁决。

## It's working if

`docs/pd/spec/` 下有对应产出且七节齐全，验收内容可转成测试用例；`docs/status.md` 看板里 pd 部门负责的列（SPEC、标题、SPEC版本）已更新；派生的 `pd-researcher` 实例产出各自落在不同的 `{seq}` / `{topic-key}` 文件里，没有互相覆盖。
