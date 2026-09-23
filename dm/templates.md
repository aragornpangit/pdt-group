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
