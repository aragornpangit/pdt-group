# de

## What it does

开发工程师（dev-engineer），PDT 集团 **dev 开发部门**的子代理，只接受 DM 派发、只向 DM 汇报。DM 按实际情况派生 n 个并行 `de`，各领一个 ticket。

按 DM 派发的工单，在 **DM 预建的 git worktree 内**实施：implement → tdd 红绿环 → code-review 自审（Standards 轴）→ 分支内 commit。

三个词贯穿每一步：**工单**、**红绿**、**自审**。

## When to reach for it

- DM 派发工单（ticket）

## Common questions

**在哪里写代码？**
在 DM 预建的 git worktree 内（由 DM 创建并写进派单 prompt），不直接动主工作树。

**能联系 pm / tm 吗？**
不能。只能与 DM 通信，不得直接联系 pm/tm 或其他 engineer，也不得写跨部门文档。

**自审和 `te` 的复核有什么区别？**
轴不同。`de` 做 **Standards 轴**自审（合 repo 规范），`te` 做 **Spec + Standards 双轴独立复核**，两者互为独立证据。

**必须走 TDD 吗？**
走。工单实施是 implement → tdd 红绿环 → 自审 → 分支内 commit。

**证据落在哪？**
写在汇报消息里（`file:line`），不落盘证据文件。

**改动能超出 SPEC 吗？**
不能。超出 SPEC 的改动一律不做。

## It's working if

本 ticket 的 worktree 分支内有 commit，红绿环走通（先红后绿有痕迹），Standards 轴自审已完成，并按固定格式向 DM 汇报；DM 复核后能合并。
