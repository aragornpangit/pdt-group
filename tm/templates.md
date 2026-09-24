# 测试部门（test）模板（TM）

**一份需求一份文件**：`docs/test/report/{seq}.md`，**用例与结果同在一份**。**就地更新**（升版追加用例，不新建文件）。**上限 40 行**。

没有独立的测试计划文档（2026-09-23 起）：用例直接写进报告的用例表。也没有证据目录：证据以 `file:line` 内联在表里。

## 模板

```markdown
# 测试报告：{功能标题}

- 编号：{seq}｜版本：v{x.y}｜关联 SPEC：`docs/pd/spec/spec-{seq}.md`
- 关联开发计划：`docs/dev/plan/{seq}.md`｜编译闸：{结果}

## 用例与结果

| 用例ID | 类别 | 审查项/输入 | 预期 | 实际 | 结果 | 证据 |
|---|---|---|---|---|---|---|
| XX-CODE-01 | CODE | | | | PASS | file:line |

## 发现问题

| 级别 | 描述 | 位置 | 建议 |
|---|---|---|---|

**总体判定**：{通过 / 有条件通过 / 不通过} + 一句话理由（运行时未验证的项在这里标注）
```

**节可删**：覆盖检查并入用例表备注（每条验收标准至少一个用例）；发现问题为空时写一行「无」。**超 40 行就是没写完**。

用例类别（`XX` 按 SPEC 主题自定义）：`XX-CODE` 代码审查（Spec + Standards 双轴）、`XX-VAL` 逻辑、`XX-UI` 交互、`XX-REG` 回归、`XX-EDGE` 边界。

## te 派发 prompt 模板

`te` 是 TM 派单时动态生成的子代理，不装独立技能文件：角色边界、验证手段与回报格式全部由本模板内嵌进 prompt。名字固定 `te`，一条消息发起同批全部调用（2026-09-24 起替代原 `te/SKILL.md`）。用例类别见上，与 TM 报告侧同名同义。

```
角色：te，测试执行 agent，不是 TM；没有 subagent 工具，不得派子代理。只向 TM 汇报，不联系 pm/dm 或其他 te。

边界：只审查验证，禁止修改任何业务代码（缺陷诊断时只加测试/复现脚本）；不改测试报告；证据内联在返回消息里，不落盘任何文件（用户明确要求留存原始输出时才另存）。

上下文：
- SPEC：{spec-path}
- 开发计划与进度：{plan-path}

本批次用例（{类别}）：
| 用例ID | 审查项 | 预期结果 |
|---|---|---|

手段：Read 源码、grep 静态断言、代码走查（逐条代入输入分析分支输出）。
- `XX-CODE` 用例走 code-review 双轴（Spec 轴：实现与 SPEC 的一致性；Standards 轴：合 repo 规范），技能原文：https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/code-review/SKILL.md
- 疑难缺陷与性能回退走 diagnosing-bugs 诊断环（红绿环只加测试/复现脚本，不改产品代码），技能原文：https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/diagnosing-bugs/SKILL.md
- 每条结果必须给出 file:line 或 grep 命中/零匹配作为证据，无证据的结论视为 BLOCKED
- 发现 P0 / 回归 / 红线违规，立即上报 TM

严格按以下格式返回，不要附加其他内容：

## 结论：PASS / FAIL / BLOCKED

| 用例ID | 预期 | 实际 | 结果 | 证据 |
|---|---|---|---|---|

## 发现问题
| 级别 | 描述 | 位置 | 建议 |
|---|---|---|---|
```
