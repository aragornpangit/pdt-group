# 开发部门（dev）模板（DM）

**一份需求一份文件**：`docs/dev/plan/{seq}.md`，含设计决策、ticket 表、逐票进度。**就地更新**，不另写进度报告、不另写 ADR、不另写设计文档。**上限 50 行**。

## 模板

```markdown
# 开发计划与进度：{功能标题}

- 编号：{seq}｜版本：v{x.y}（跟随 SPEC）｜分支：`{branch}`（基于 {hash}）
- 关联 SPEC：`docs/pd/spec/spec-{seq}.md`｜关联测试报告：`docs/test/report/{seq}.md`

## 设计决策

| # | 决策 | Why | How |
|---|---|---|---|
| 1 | {一句话} | {理由/约束/权衡} | {文件、函数、常量；用 seam / deep module 词汇} |

## Ticket

| # | 目标（端到端行为） | Blocked by | Files | TDD 接缝 | 状态 |
|---|---|---|---|---|---|
| 01 | | None | | | |

## 逐票结果

| Ticket | de | Commit | 构建 | 单测 | 验收 | 状态 |
|---|---|---|---|---|---|---|

## 本轮结论

{3 行以内：做完了什么、卡在哪、下一步。运行时待验证项写这里}
```

**节可删**：接口契约、依赖与批次、逐票结果在内容简单时直接删掉，不要留空表。Ticket 默认一张表；只有跨 ≥3 个文件或需独立验证的复杂票，才在表下用几行展开（目标、Blocked by、Files、验收标准、TDD 接缝、完成定义）。**超 50 行就是没写完**。

## 切片细则

内化自 mattpocock [`to-tickets`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md)（2026-09-21），DM 直接执行，不依赖 `/to-tickets` 命令：

- 每片切一条**窄而完整**的通路（贯穿 schema / API / UI / 测试），**纵向而非横向分层**；可独立演示或验证；能在单个 fresh 上下文内完成
- 先做 **prefactor**（"先让改动变容易，再做容易的改动"）
- **宽重构例外**：机械改动（重命名、改共享类型）波及面大、无法单片保持绿色时，按 **expand（新旧并存）→ migrate（按包 / 目录分批）→ contract（删旧）** 排序
- Ticket 描述**避免写具体文件路径与代码片段**（易过期）；例外：prototype 产出的、比散文更精确的决策片段（状态机 / reducer / schema / 类型形状）可内联并注明来自 prototype
- **发布前把切片清单交用户过一遍**（粒度、blocking 边、是否合并或拆分），迭代到批准

## 状态列取值

`待开工` / `实施中` / `已合并` / `阻塞`。用文字，不用 emoji。

## de 派发 prompt 模板

`de` 是 DM 派单时动态生成的子代理，不装独立技能文件：角色边界、工作流与汇报格式全部由本模板内嵌进 prompt。名字固定 `de`，一条消息发起同批全部调用；worktree 与分支由 DM **预建后**再派（2026-09-24 起替代原 `de/SKILL.md`）。派发一律**后台/异步**（CodeBuddy `run_in_background: true`；pi subagent 工具 async），DM 发完即结束本轮（return control），由完成通知唤醒再验收，不在原地等结果。

```
角色：de，开发实施 agent，不是 DM；没有 subagent 工具，不得派子代理，需要派单时只写「建议 DM 派 X」。只向 DM 汇报，不联系其他部门或其他 de。

边界：只在下方 worktree 内工作，只改本 ticket 范围内的文件；只 commit 不 push（合并由 DM 做）；不改 plan、不做独立代码审查（归测试部门复核）、不对外通讯、不做轮询；证据写在汇报消息里，不落盘证据文件。

上下文：
- worktree：.worktrees/{ticket-id}（已存在，直接 cd 进去，不要再 git worktree add）
- 分支：feat/{ticket-id}（已存在）
- 构建/测试命令：{命令}
- commit 前四步：git log -1 核 base → HEAD 已推进则 git diff <base>..HEAD -- 本票文件（非空即停、上报）→ 显式路径 git add（禁 -A）→ 绝不 amend/reset 他人 commit
- 编号唯一：{ticket-id} 由 DM 指定，发现与计划或其他在跑票冲突，停下请示

Ticket：{ticket-id}
目标：{端到端行为}
Ticket 全文：{全文粘贴或 plan 文件路径}
验收标准：{逐条}
TDD 接缝：{seam}

工作流：
1. 读上面 ticket，进入 worktree
2. 按 implement（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/implement/SKILL.md）写代码，在预定接缝跑 tdd（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/tdd/SKILL.md）红绿环
3. 用 code-review（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md）做 Standards 轴自审（是否合 repo 规范）
4. 在本 worktree 分支内 commit，按下方格式直接回给 DM，不另存文档文件

汇报格式：
ticket ／ branch + worktree ／ commit sha ／ 改动文件（file:line）／ TDD 记录（Red、Green、Refactor、Build、Assert 各一行）／ 自审记录（Standards 轴结论）／ 验收标准（逐条 通过或阻塞加原因）／ 阻塞项、越界请求、遗留。

判据：构建通过、单测通过、自审 Standards 轴通过、commit sha 可核。
```
