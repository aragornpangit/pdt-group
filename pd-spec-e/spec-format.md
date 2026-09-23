# SPEC 格式（pd-spec-e）

写 SPEC 时才读这份参考：模板、粒度禁令、撰写原则、升版规则、长期知识的去向。命名与归属见 [`SKILL.md`](SKILL.md) 与 [`../pdt-leader/group-conventions.md`](../pdt-leader/group-conventions.md)。

SPEC 是**产品部门唯一的交付文档**：它同时承载 what/why（问题与方案，用户视角）与 how（实现决策与测试决策），供 DM 与 TM 直接开工。格式内化自 mattpocock [`to-spec`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-spec/SKILL.md)（2026-09-21），不依赖外部命令。

## 模板

```markdown
# SPEC: {功能标题}

| 字段 | 值 |
|---|---|
| 编号 | SPEC-{seq}-{feature-key} |
| 版本 | v1.0 |
| 日期 | {YYYY-MM-DD} |
| 状态 | Draft |
| 前序 SPEC | {关联编号，无则删此行} |

## 1. Problem Statement

{用户视角的问题陈述：用户当前遇到什么。引用具体报告编号或 file:line，不写「存在一些问题」这类空话}

## 2. Solution

{用户视角的解决方案：这次要做什么}

## 3. User Stories

编号列表，格式 `As an <actor>, I want a <feature>, so that <benefit>`；要**尽量穷尽**，覆盖功能的各个方面。

## 4. Implementation Decisions

- 将新建 / 修改的模块
- 这些模块将被修改的接口
- 开发方给出的技术澄清
- 架构决策
- Schema 变更
- API 契约
- 具体的交互

## 5. Testing Decisions

- 什么算好测试（**只测外部行为，不测实现细节**）
- 哪些模块会被测
- 同类测试的既有先例

## 6. Out of Scope

- {明确排除的事项}

## 7. Further Notes

{补充：根因分析 file:line、变更历史表、运行时验证项、依赖与约束}
```

## 粒度禁令

**不写具体文件路径与代码片段**（`They may end up being outdated very quickly`）。

唯一例外：prototype 产出的、比散文更精确地编码了决策的片段（状态机 / reducer / schema / 类型形状），可内联在对应决策下，并注明来自 prototype。裁到决策密集处，不要整段 demo。

## 撰写原则

1. **问题有据**：反例是「目前存在一些问题」，换成报告编号或 `file:line`
2. **用户故事穷尽**：第 3 节是 SPEC 的主体，不是装饰
3. **决策可执行**：第 4 节给到模块、接口、契约，让 DM 无需再猜
4. **测试可测**：第 5 节写清「只测外部行为」的判据
5. **非目标声明**：第 6 节把范围蔓延挡在开工之前

## 术语

用项目 `CONTEXT.md`（或领域词汇表）与代码中已有的命名；两者都没有时按代码命名固化，并在 SPEC 首次出现处定义一次。SPEC 用词与代码一致，DM 与 TM 才不会产生第二套叫法。

## 升版规则

调整已有 SPEC 时**改当前文件**，不新建：

1. 读当前版本，确认要改哪几条
2. 在 Further Notes 追加变更历史表（轮次 / 参数值 / 反馈，最新一轮加粗）
3. 版本号递增（v1.0 → v2.0）
4. 同步方案与验收相关内容

仅大范围改写（问题、方案、范围整体换血）才新建 SPEC，并在元信息表写明前序 SPEC 编号。

## 长期知识的去向

SPEC 是**用完即弃**的：它记录本次工作已做的决策，供下一个 context window 读取；工作交付后不再维护。需要长期留存的知识写到别处：

| 内容 | 去处 | 归属 |
|---|---|---|
| 领域术语与语言 | `CONTEXT.md`（项目根） | PM |
| 架构决策与其取舍 | `docs/adr/`（一决策一文件 `NNNN-{slug}.md`） | DM |
