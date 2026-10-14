# 开发部门（dev）模板（DM）

**一份需求一份文件**：`docs/dev/plan/{seq}-devPlan-{语义slug}-{时间戳}-v{N}.md`（命名见 [`../pm/group-conventions.md`](../pm/group-conventions.md)「文件命名」，seq 沿用 SPEC 的序号），含设计决策、ticket 表、逐 ticket 进度。**版本内就地更新**，实质修订升版落新文件；不另写进度报告、不另写 ADR、不另写设计文档。**50 行基准，可适度超出**（超了先删冗余，删无可删在文件头登记原因）。

## 模板

```markdown
# 开发计划与进度：{功能标题}

- 编号：{seq}｜版本：v{N}（跟随 SPEC）｜分支：`{branch}`（基于 {hash}）
- 关联 SPEC：`docs/pd/spec/{seq}-spec-*.md`｜关联测试报告：`docs/test/report/{seq}-testReport-*.md`

## 设计决策

| # | 决策 | Why | How |
|---|---|---|---|
| 1 | {一句话} | {理由/约束/权衡} | {文件、函数、常量；用 seam / deep module 词汇} |

## Ticket

| # | 目标（端到端行为） | Blocked by | Files | TDD 接缝 | 状态 |
|---|---|---|---|---|---|
| 01 | | None | | | |

## 逐 ticket 结果

| Ticket | de | Commit | 构建 | 单测 | 验收 | 状态 |
|---|---|---|---|---|---|---|

## 本轮结论

{3 行以内：做完了什么、卡在哪、下一步。运行时待验证项写这里}
```

**节可删**：接口契约、依赖与批次、逐 ticket 结果在内容简单时直接删掉，不要留空表。ticket 默认一张表；只有跨 ≥3 个文件或需独立验证的复杂 ticket，才在表下用几行展开（目标、Blocked by、Files、验收标准、TDD 接缝、完成定义）。**超基准先删冗余，删无可删在文件头登记原因**。

## 切片细则

内化自 mattpocock [`to-tickets`](https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/to-tickets/SKILL.md)，DM 直接执行，不依赖 `/to-tickets` 命令：

- 每片切一条**窄而完整**的通路（贯穿 schema / API / UI / 测试），**纵向而非横向分层**；可独立演示或验证；能在单个 fresh 上下文内完成
- 先做 **prefactor**（"先让改动变容易，再做容易的改动"）
- **宽重构例外**：机械改动（重命名、改共享类型）波及面大、无法单片保持绿色时，按 **expand（新旧并存）→ migrate（按包 / 目录分批）→ contract（删旧）** 排序
- ticket 描述**避免写具体文件路径与代码片段**（易过期）；例外：prototype 产出的、比散文更精确的决策片段（状态机 / reducer / schema / 类型形状）可内联并注明来自 prototype
- **发布前把切片清单交用户过一遍**（粒度、blocking 边、是否合并或拆分），迭代到批准

## 状态列取值

`待开工` / `实施中` / `已合并` / `阻塞`。用文字，不用 emoji。

**别与看板混**：这里是 **ticket 级**状态（一个需求内每张工单各一值）。看板 `docs/status.md` 的 `开发状态` 列是**需求级**（`规划中` / `实施中` / `已提交` / `待验证`，见 [`../pm/group-conventions.md`](../pm/group-conventions.md)「看板」），两者粒度不同、不要求同词。

## de 派发 prompt 模板

`de` 是 DM 派单时动态生成的子代理，不装独立技能文件：角色边界、工作流与汇报格式全部由本模板内嵌进 prompt。名字固定 `de`，一条消息发起同批全部调用；worktree 与分支由 DM **预建后**再派。派发一律**后台/异步**（机制映射见 [`../pm/group-conventions.md`](../pm/group-conventions.md)「组织架构」），DM 发完即结束本轮（return control），由完成通知唤醒再验收，不在原地等结果。

**派发参数（写在调用上，不写进 prompt 文本）**：`context: "fresh"`（不继承父对话）＋ `timeoutMs`（团队纪律第 6 条：写工单时即填，设备 / 长链路 ≥ 45 min 并按段切分汇报，纯文档工单可短）。**取号互斥（团队纪律第 14 条）**：开工/派单前**实查三类目录**（`docs/pd/spec/`／`docs/dev/plan/`／`docs/test/report/`）确认号未占 ＋ **取到号立即通告 PM/TM** ＋ 冲突按「**先落盘者先占**」裁定、另一方**升号并留痕**。**设备独占（团队纪律第 13 条）**：涉设备工单的**前置探测／`trap` 复位／装机登记／装回或交还**四件必写进 prompt；设备窗由 DM 排（同一设备不得两票并发）。模板正文也把 `timeoutMs` 列成一行，让 DM 抄工单时不会漏。

**已退役旋钮禁令（2026-10-12，TM 复核发现 ／ DM 升为通用）**：凡涉及**已退役旋钮/开关**（如 `tryrotate`，自 031-P1-1.3 起**整段退役**、代码里只打 WARN）的工单，**不得设计「同构建、仅切旋钮」路线**（切配置旋钮 ⇒ **行为不变**，但自证键（如 `t33_tryrotate_state/_applied`）可能**仍报 1** ⇒ **假阴性陷阱**，比「恒 0 键」更危险）；**A/B 类必须两构建**（各登记产物 SHA ＋ 源码该行留痕），**禁用自证键当「臂已切」证据**。

**红臂判据禁令（2026-10-12，TM 实证 ／ DM 升为通用）**：**红臂（反向臂）判据必须区分「预期红」与「环境/编译失败」**：`expect FAIL` 类判据**不得只判 `rc≠0`**（否则**编译破损 rc=90 会被记成「OK（红）」⇒ 假的有牙**，等于被测修复**未被真正验证**）；**编译/环境失败一律 HARD FAIL／ERROR（BLOCKED，不得记 OK）**，红臂判据应写「**编译成功 ∧ rc==1**」或等价显式式；**并须补一条「故意让其编译失败 ⇒ 必须 ERROR」的反向臂**。**同族共律（集团纪律 `G16`，PM 2026-10-12 立）**：**判据／工具与自身条件脱钩**：**六类耦合面：对象／环境／执行树／批次／能力面／同一载体两处表述**（第 6 类 PM 2026-10-12 追补：同一文档**改了正文节、漏改总表** ⇒ 读者按总表判断即错 ⇒ **配套动作：先改表再改正文，改完 `grep` 复核两处一致**）。今日判例索引：① 编译失败当预期红（假的有牙）② 判据随执行树反转 ③ 自证键报 1 而行为不变（**能力面**不对齐）④ reset 脚本静默失败 ⑤ 侧车恒 0 键 ⑥ 注释≠事实。⇒ **派单逐条自查**：红臂是否区分「预期红/环境失败」？判据是否声明 `worktree@commit`？自证键是否与**能力面**两侧比对？（同族 `G3`／`G8`；不回头改旧行，第 11 条）

**★ 配套动作（G16·读数↕事实，TM 2026-10-12 附议）：凡引读数作结论，必须同时给「读数面 ↕ 事实面」两侧证据**（缺事实面 ⇒ 不得定论）。今日三例：① **FPS HUD ＝ `consumeJson` 到达率 ＝ 检测帧率**（却当预览帧率用）② 退役旋钮 `t33_tryrotate_applied` 仍按配置报 1 ③ `reset_device.sh` install 失败仍报成功。

**★ 配套动作（G16·产物时点，DM 2026-10-12 自曝）：产物类门（读 APK／`.so`／构建产物）必须先完成构建、再跑门。** 反序会读到**旧产物**（今日实测：合并 053 后**先跑门**得 `.so` 导出 `Java_bcr_nh_`=30、**后跑构建**才 31 ⇒ 门报红实为**时点错**，非缺陷）。⇒ **验收固定序：构建 → 门 → （真机项）**；另一形态：**未跟踪新文件期跑「范围为门」会假绿**（`git diff` 不列未跟踪 ⇒ 白名单外恰 0 ⇒ 假过）⇒ **提交后复跑为准**。

```
角色：de，开发实施 agent，不是 DM；没有 subagent 工具，不得派子代理，需要派单时只写「建议 DM 派 X」。只向 DM 汇报，不联系其他部门或其他 de。

边界：只在下方 worktree 内工作，只改本 ticket 范围内的文件；只 commit 不 push（合并由 DM 做）；不改 plan、不做独立代码审查（归测试部门复核）、不对外通讯、不做轮询；证据写在汇报消息里，不落盘证据文件。

上下文：
- 超时：timeoutMs = {毫秒}（派发时必须已填，不得留空、不得依赖默认值）
- worktree：{worktree 绝对路径}（DM 已建好，直接 cd 进去，不要再 git worktree add；此后所有编辑与命令一律用这个绝对路径，严禁在主仓工作树写任何文件或提交任何东西）
- 分支：feat/{ticket-id}（已存在）
- 构建/测试命令：{命令}
- 定位材料：{报错原文 ＋ file:line ＋ 复现命令或日志路径；修复 / 诊断类工单必填三件，团队纪律第 12 条，缺件 DM 先取证再派}
- 静态断言：{命令或断言清单}（每 ticket 必跑，不攒到最后）
- commit 前四步：git log -1 核 base → HEAD 已推进则 git diff <base>..HEAD -- 本 ticket 文件（非空即停、上报）→ 显式路径 git add（禁 -A）→ 绝不 amend/reset 他人 commit
- 编号唯一：{ticket-id} 由 DM 指定，发现与计划或其他在跑 ticket 冲突，停下请示
- 设备（仅涉设备工单填，团队纪律第 8/13 条）：前置探测（`adb devices -l` ／ `settings get system user_rotation` ／ `settings get system accelerometer_rotation` ／ `dumpsys package <pkg>` 的 `lastUpdateTime`）＋脚本用 **`trap` 无条件复位**（rotation／SP／开关态）＋结束**装回 canonical 或明确交还**＋**装机登记（包名/SHA/时刻）**；**并发表单只写「本票在跑」**，设备独占由 DM 排窗（同一设备不得两票并发）

Ticket：{ticket-id}
目标：{端到端行为}
ticket 全文：{全文粘贴或 plan 文件路径}
验收标准：{逐条}
TDD 接缝：{seam}

工作流：
1. 读上面 ticket，进入 worktree
2. 按 implement（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/implement/SKILL.md）写代码，在预定接缝跑 tdd（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/tdd/SKILL.md）红绿环
3. 用 code-review（https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md）做 Standards 轴自审（是否合 repo 规范）
4. 跑上面给的静态断言（不攒到最后）
5. 在本 worktree 分支内 commit，按下方格式直接回给 DM，不另存文档文件

汇报格式：
ticket ／ branch + worktree ／ commit sha ／ 改动文件（file:line）／ TDD 记录（Red、Green、Refactor、Build、Assert 各一行）／ 静态断言输出 ／ 自审记录（Standards 轴结论）／ 验收标准（逐条 通过或阻塞加原因）／ **设备状态复位自证**（仅涉设备工单：贴复位后回读：`user_rotation`／`accelerometer_rotation`／SP／`dumpsys package` 的 `lastUpdateTime`，并写清**装了哪个包、何时装、何时复位**）／ 阻塞项、越界请求、遗留。

判据：构建通过、单测通过、静态断言通过、自审 Standards 轴通过、commit sha 可核。
```
