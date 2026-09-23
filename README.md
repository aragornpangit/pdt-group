# pdt-group

**把一支软件团队装进 agent 会话里。**

PDT 集团是一套**角色技能族**：一个一级部门加三个二级部门，共 5 个角色。每个角色是一个可被 agent 加载的 `SKILL.md`，各自运行在独立会话中，通过 herdr 消息协作，把「用户需求 → SPEC → 纵向切片实施 → 独立验证」这条链路完整跑起来。

它不是工具技能，而是**一套组织协议**：规定谁向谁汇报、产物落哪个目录、什么话走哪条通道。

> 本项目的方法论骨架建立在 [Matt Pocock](https://github.com/mattpocock) 的开源技能集之上，明确引用了他的多个技能，并从中收获很多。逐条清单与收获见 **[ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md)**。

## 发布镜像说明

**本仓是发布镜像（release mirror），不是唯一的写作现场。**

- **规范来源**：作者的技能容器仓 `Skills` 里的 `pdt-group` 桶（内网私有仓 `p00292/Skills`，非公开）。角色定义、集团口径与台账在那里维护。
- **同步方向**：单向，容器仓 → 本仓。改动先在容器仓落地，再同步到这里发布。
- **本仓用途**：对外分发与阅读。你可以自由 fork 与自改（MIT），但本仓**不接受**直接改动的回流，改了会在下次同步时被覆盖。
- **两者不一致时**：以容器仓为准；若你只读得到本仓，就以本仓当次快照为准。

同步时保留的角色目录结构是「一角色一目录、直接放仓根」，与容器仓内 `skills/pdt-group/<角色>/` 的拍平结果一致。

## 组织架构

```
pdt-group（一级部门，负责人 pm：用户入口 ＋ 产品经理）
├── pd   产品部门       经理 pm  → SPEC（自己落笔，≤ 80 行）
├── dev  开发部门       经理 dm  → 开发计划与进度（自己落笔，≤ 50 行）
│   └── de × n                单 ticket 实施 → git worktree + tdd
└── test 测试部门       经理 tm  → 测试报告（自己落笔，≤ 40 行）
    └── te × n                用例执行
```

三条派发铁律：

- 子代理**只向本部门经理汇报**，只接受本部门经理安排
- **经理间直通**：pm / dm / tm 用 herdr 横向直接协商，不经第三人转达
- 两方无法一致时**由 pm 裁决**，结论用 herdr 回给相关部门

## 五个角色

| 角色 | 层级 | 职责 |
|---|---|---|
| [`pm`](pm/SKILL.md) | 集团入口 ＋ 经理 | 产品经理兼集团负责人：集团唯一用户入口，组建并管理 dm/tm 会话，跨部门协调与顶层裁决；自己落笔 SPEC（≤ 80 行，含 what/why 与 how），裁决开发/测试报告。集团层零文档产出 |
| [`dm`](dm/SKILL.md) | 经理 | 开发经理。定设计决策与切片口径（自己落笔计划与进度，≤ 50 行），按实际情况派生 n 个 `de`，验收合并 |
| [`tm`](tm/SKILL.md) | 经理 | 测试经理。设计用例与结论（自己落笔测试报告，≤ 40 行），按实际情况派生 n 个 `te`，复核并退回缺陷 |
| [`de`](de/SKILL.md) | 子代理 | 开发工程师。在 DM 预建的 git worktree 内 implement → tdd → 自审 → commit |
| [`te`](te/SKILL.md) | 子代理 | 测试工程师。执行用例，持 `code-review` 与 `diagnosing-bugs` |

每个角色另有一页面向人的说明（四段式：What it does / When to reach for it / Common questions / It's working if），见 [`docs/`](docs/)。

## 一条需求怎么走完

需求从 pm 进，沿 pd → dev → test 单向流动，`{seq}` 是贯穿全链的锚（由 pm 立 SPEC 时生成，开发计划与测试报告沿用）：

1. **pd**：`grilling` 拷问收敛决策 → pm 自己取证（读源码、报告、配置）→ pm 自己落 SPEC
2. **dev**：DM 定设计决策（落 `docs/dev/plan/{seq}.md`）并按 tracer-bullet 纵向切片 → 按实际情况派生 n 个 `de`，各自在 worktree 内实施、走 tdd 红绿环、Standards 轴自审、分支内 commit → DM 验收合并
3. **test**：tm 按五类用例设计（直接写进报告）→ 派生 n 个 `te` 并行执行 → tm 复核后 herdr 双发 pm 与 dm

## 文档纪律（本项目的核心取舍）

2026-09-23 起，本项目按「文档是副产品，不是工作日志」重排了文档面：

- **文档白名单**：全集团只有 SPEC（≤ 80 行）、开发计划与进度（≤ 50 行）、测试报告（≤ 40 行）、`CONTEXT.md` 领域术语，以及 herdr 不可用时的 `docs/status.md` 兜底。**不新建文档类型**；集团层（pm 的用户入口职责）**零文档产出**
- **不要每轮都写文档**：只在有实质产出或口径变化时才动文档，日常轮次进度与结论走 herdr
- **一份需求一份文件，就地更新**：不按轮次新建文件，历史版本由 git 承载
- **证据内联**：报告里给 `file:line` 或 grep 结果即可，不落盘证据文件
- **时间预算**：同一 feature 的文档写作累计不超过实现时间的 10%

集团口径的唯一来源是 [`pm/group-conventions.md`](pm/group-conventions.md)。

## 安装

把 5 个角色目录**拍平**拷进 harness 的技能目录，不要带任何层级：

```bash
for d in pm dm tm de te; do
  cp -r "$d" ~/.codex/skills/
done
```

`pdt-group` 是一个完整团队，要**全部装上**才有意义（角色之间有派发依赖）。`~/.codex/skills` 换成你所用 harness 的技能目录即可。

## 目录结构

```
.
├── README.md                 # 本文件
├── ACKNOWLEDGMENTS.md        # 对 mattpocock/skills 的致谢与引用清单
├── AGENTS.md                 # 仓库约定（给 agent 读）
├── LICENSE                   # MIT
├── pm/
│   ├── SKILL.md              # 产品经理兼集团负责人（用户入口）
│   ├── group-conventions.md  # 集团口径唯一来源：通信/文档/命名/看板
│   ├── team-bootstrap.md     # 终端探测、dm/tm 会话创建、手动模式提示词
│   ├── skill-inventory.md    # 角色 ↔ 上游技能台账
│   └── spec-format.md        # SPEC 格式
├── dm/{SKILL.md, templates.md}
├── tm/{SKILL.md, templates.md}
├── de/SKILL.md
├── te/SKILL.md
└── docs/                     # 面向人的四段式角色说明（5 页）
```

## 依赖

| 依赖 | 用途 | 是否随本仓分发 |
|---|---|---|
| [`mattpocock/skills`](https://github.com/mattpocock/skills) | 提供 `grilling`、`research`、`to-spec`、`to-tickets`、`implement`、`tdd`、`code-review`、`diagnosing-bugs`、`handoff` 等能力 | 否，独立仓，需自行安装 |
| herdr | 通信主通道（终端多路复用器，agent 之间定向发消息） | 否，独立工具 |

`mattpocock/skills` 是本项目的上游方法论来源，请直接访问其仓库并按 MIT 许可使用；本仓不拷贝其文件。

## 许可

本仓采用 **MIT License**，见 [LICENSE](LICENSE)。

上游 [`mattpocock/skills`](https://github.com/mattpocock/skills) 同为 MIT；本仓没有拷贝其任何文件，引用方式见 [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md)。
