# 致谢

## Matt Pocock 与 `mattpocock/skills`

本项目的方法论骨架，直接建立在 **Matt Pocock** 的开源技能集之上。他的工作是这个项目能成立的前提，我们从中收获极多。

- 上游仓库：[`mattpocock/skills`](https://github.com/mattpocock/skills)（MIT License）
- 作者主页：<https://github.com/mattpocock>
- 仓库自述：Skills for Real Engineers. Straight from my .agents directory.

### 具体引用了哪些技能

下表是**明确引用**，不是笼统致敬。每一行都可在本项目里找到对应接线点，技能名直接链到上游 `main` 分支的原文：

| 本项目位置 | 引用的上游技能 |
|---|---|
| `pm` 的访谈环节 | [`grilling`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md) |
| `pm` 的按需取证 | [`research`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/research/SKILL.md) |
| `pm` 的 SPEC 格式 | [`to-spec`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-spec/SKILL.md)，已内化为 `pm/spec-format.md` |
| `dm` 的设计词汇 | [`codebase-design`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/codebase-design/SKILL.md) |
| `dm` 的切片口径 | [`to-tickets`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md)，已内化为 `dm/templates.md` 的「切片细则」 |
| `dm` 的冲突消解 | [`resolving-merge-conflicts`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/resolving-merge-conflicts/SKILL.md) |
| `de` 的实施环 | [`implement`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/implement/SKILL.md)、[`tdd`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/tdd/SKILL.md)、[`code-review`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md)（Standards 轴自审） |
| `te` 的独立复核 | [`code-review`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md)（Spec + Standards 双轴）、[`diagnosing-bugs`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/diagnosing-bugs/SKILL.md) |
| 四个负责人的按需会话交接 | [`handoff`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/handoff/SKILL.md) |
| 全员通用 | [`writing-for-agents`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/writing-for-agents/SKILL.md)、[`domain-modeling`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/domain-modeling/SKILL.md)、[`prototype`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/prototype/SKILL.md)、[`wayfinder`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/wayfinder/SKILL.md)、[`wizard`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/wizard/SKILL.md)、[`triage`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/triage/SKILL.md)、[`ask-matt`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/ask-matt/SKILL.md) |

完整台账（含 invocation 类型与执行者）见 [`pm/skill-inventory.md`](pm/skill-inventory.md)。

### 收获了什么

按影响从大到小，都是可指认的具体改变，不是客套：

1. **user-invoked / model-invoked 这条正交轴**，是本项目整个角色分层的依据。把「编排」与「纪律」分开之后，才有了「经理负责编排、子代理承载可复用纪律」的结构。这条轴比任何具体技能都更有价值。
2. **把纪律下沉为原语**的做法（`grilling` 是 `grill-me` / `grill-with-docs` / `triage` / `wayfinder` / `improve-codebase-architecture` 的共同底座）直接启发了本项目：把「文档独占」「证据只增不改」这类规则写成可被自动够到的纪律，而不是散落进各角色的提示词里。
3. **tracer-bullet 纵向切片**改变了我们的派单粒度。此前按层横切，改成「窄而完整、可独立演示、单上下文可完成」的通路后，`de` 的并行度与验收确定性都来自这里。
4. **`to-spec` 的单文档形态**（what/why 与 how 同在一份）让本项目取消了 PRD 与 design.md 两份文档，交付件从 3 份收敛到 1 份；后来的文档减负（砍掉 ADR、调研、测试计划、证据目录）也是沿这条线继续走的。
5. **`code-review` 的双轴**（Spec / Standards）成为 `de` 自审与 `te` 独立复核的证据分离依据：同一技能，两个轴，互为独立证据。
6. **容器仓（monorepo of skills）的组织方式**同样是从他的仓库实践中提取的。

### 许可与使用方式

上游 `mattpocock/skills` 采用 **MIT License**。

本项目**没有拷贝**他的任何文件。处理方式是两种：

- 技能名以链接形式引用，读的是上游 `main` 分支的原文；
- `to-spec` 与 `to-tickets` 的**语义**被改写内化成本项目自己的格式文档（`pm/spec-format.md`、`dm/templates.md`），并在文中注明出处。

若要使用上游技能本身，请直接访问 [`mattpocock/skills`](https://github.com/mattpocock/skills) 并遵循其 MIT 许可。
