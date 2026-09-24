# pdt-group 技能台账

集团经理角色（pm / dm / tm）所用的 mattpocock 工程技能，按 **mattpocock 的语义**分配到 pd / dev / test 三个部门。`de` / `te` 是经理派发阶段动态生成的子代理，不装独立技能文件（模板见 `dm/templates.md`、`tm/templates.md`）。各角色 SKILL.md 只写自己接线用到的那几条，不在此复述。

**上游仓库**：[`mattpocock/skills`](https://github.com/mattpocock/skills)（GitHub，`main` 分支）。下表每个技能名都链到它在 `main` 上的 `SKILL.md` raw 地址（raw 根 `https://raw.githubusercontent.com/mattpocock/skills/main/`），点开即读到上游原文。

**本地镜像**：本环境另有内网 fork `pdt-group/mattpocock-skills`（同内容，供离线安装），**上游才是规范来源**；两者不一致时以上游 GitHub 为准。

**类型轴**（mattpocock 原文）：**user-invoked** 只能由人敲命令，职责是**编排**；**model-invoked** 可由人敲、也可被 agent 自动够到，承载**可复用纪律**。user-invoked 可以调 model-invoked，**绝不能调另一个 user-invoked**。

## pd 产品部门（PM）：需求 → SPEC

| 技能 | 类型 | 语义 | 谁执行 |
|---|---|---|---|
| [`grilling`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md) | MODEL | 拷问原语，是 `grill-me` / `grill-with-docs` / `triage` / `wayfinder` / `improve-codebase-architecture` 的共同底座 | PM |
| [`grill-me`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grill-me/SKILL.md) | USER | 非代码场景的拷问 | 用户敲 |
| [`grill-with-docs`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/grill-with-docs/SKILL.md) | USER | 拷问 + 同步更新 `CONTEXT.md` | 用户敲，PM 接 |
| [`domain-modeling`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/domain-modeling/SKILL.md) | MODEL | 主动建/磨领域模型：挑战术语、边界场景压测、更新 `CONTEXT.md` | PM |
| [`prototype`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/prototype/SKILL.md) | MODEL | 一次性原型回答设计问题（状态/逻辑类或 UI 变体） | PM（决定是否做） |
| [`to-spec`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-spec/SKILL.md) | USER | 对话 → SPEC，发布到 tracker（**已内化为 [`spec-format.md`](../pm/spec-format.md)**） | PM |
| [`writing-for-agents`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/writing-for-agents/SKILL.md) | MODEL | 写「给 agent 读」的文档（SPEC 正是此类） | PM |
| [`to-questionnaire`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/to-questionnaire/SKILL.md) | USER | 自己答不了的决策 → 交给能答的人填的问卷 | 用户敲，PM 接 |
| [`triage`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/triage/SKILL.md) | USER | issue 走 triage 角色状态机（需标签配置） | 用户敲，PM 接 |
| [`wait-what`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/wait-what/SKILL.md) | USER | 消息没落地时让 agent 用 `CONTEXT.md` 词汇重讲 | 用户敲 |
| [`handoff`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/handoff/SKILL.md) | USER | 会话自我交接（仅用户明确要求时） | PM |

## dev 开发部门（DM）：设计 → 实现 → 合并

| 技能 | 类型 | 语义 | 谁执行 |
|---|---|---|---|
| [`codebase-design`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/codebase-design/SKILL.md) | MODEL | deep module 的共享词汇与纪律（行为多、接口小、放在干净 seam） | DM |
| [`wayfinder`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/wayfinder/SKILL.md) | USER | 超过单 session 的工作拆成决策票地图，逐张解 | DM |
| [`to-tickets`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md) | USER | plan/spec → tracer-bullet tickets + blocking 边（**已内化为 [`templates.md`](../dm/templates.md) 的「切片细则」**） | DM |
| [`implement`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/implement/SKILL.md) | USER | 按 spec/tickets 实施，驱动 `tdd`，收尾 `code-review` | `de`（DM 动态派生，见 dm/templates.md） |
| [`tdd`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/tdd/SKILL.md) | MODEL | 红绿环，一次一个纵向切片 | `de`（DM 动态派生） |
| [`code-review`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md) | MODEL | **Standards 轴**自审（合 repo 规范 + Fowler 坏味道基线） | `de`（DM 动态派生） |
| [`resolving-merge-conflicts`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/resolving-merge-conflicts/SKILL.md) | MODEL | 逐 hunk 按意图追溯消解冲突，做完操作（绝不 `--abort`） | DM |
| [`improve-codebase-architecture`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/improve-codebase-architecture/SKILL.md) | USER | 扫描深化机会 → HTML 报告 → 拷问选中的那个（**条件**：PM 明确要求技术债清理） | DM |
| [`wizard`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/wizard/SKILL.md) | MODEL | 生成交互式 bash 向导，带人做只有人能做的步骤（凭证 / CI / 迁移）（**条件**） | DM |
| [`setup-pre-commit`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/misc/setup-pre-commit/SKILL.md) | MODEL | Husky + lint-staged + 类型检查 + 测试（**条件**） | DM |
| [`git-guardrails-claude-code`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/misc/git-guardrails-claude-code/SKILL.md) | MODEL | 拦危险 git 命令（**条件**） | DM |
| [`migrate-to-shoehorn`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/misc/migrate-to-shoehorn/SKILL.md) | MODEL | 测试文件的 `as` 断言迁移（**条件**：TS 项目） | DM |
| [`handoff`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/handoff/SKILL.md) | USER | 会话自我交接（仅用户明确要求时） | DM |

## test 测试部门（TM）：独立复核 → 缺陷定位

| 技能 | 类型 | 语义 | 谁执行 |
|---|---|---|---|
| [`code-review`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md) | MODEL | **Spec + Standards 双轴**独立复核（并行子代理，互不污染），对应 `XX-CODE` 用例 | `te`（TM 动态派生，见 tm/templates.md） |
| [`diagnosing-bugs`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/diagnosing-bugs/SKILL.md) | MODEL | 疑难缺陷 / 性能回退的诊断环（红 → 最小化 → 假设 → 插桩 → 修 → 回归） | `te`（TM 动态派生） |
| [`handoff`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/handoff/SKILL.md) | USER | 会话自我交接（仅用户明确要求时） | TM |

> `de` 与 `te` 共用 `code-review` 但轴不同：`de` 做 Standards 自审，`te` 做 Spec + Standards 独立复核，互为独立证据。两者均为经理派发阶段动态生成的子代理，技能接线写在派发 prompt 模板（`dm/templates.md`、`tm/templates.md`）里。

## 跨角色与未纳入

| 技能 | 类型 | 归属 | 说明 |
|---|---|---|---|
| [`ask-matt`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/ask-matt/SKILL.md) | USER | pm | 路由器：问「该用哪个技能 / 流程」 |
| [`research`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/research/SKILL.md) | MODEL | pm | 2026-09-23 起未接线：PM 需要事实自行读源码与报告，不派调研子代理 |
| [`setup-matt-pocock-skills`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/setup-matt-pocock-skills/SKILL.md) | USER | 一次性 | 配 issue tracker / triage 标签 / 文档目录，每仓跑一次 |

**未纳入**（与 PDT 流程无关或属个人工具链）：`teach`、`scaffold-exercises`、`writing-beats` / `writing-fragments` / `writing-shape`（写作类），以及 `in-progress/` 桶的 `claude-handoff`、`implement-spec`、`loop-me`、`retro`、`setup-ts-deep-modules`（上游尚未定稿）。

## 维护

技能增减时只改本表；各角色 SKILL.md 的指针段保持与之一致。
