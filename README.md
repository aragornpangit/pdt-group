# pdt-group

**把一支软件团队装进 agent 会话里。**

PDT 集团是一套**角色技能族**：一个一级部门加三个二级部门，共 10 个角色。每个角色是一个可被 agent 加载的 `SKILL.md`，各自运行在独立会话中，通过 herdr 消息与共享看板协作，把「用户需求 → SPEC → 纵向切片实施 → 独立验证」这条链路完整跑起来。

它不是工具技能，而是**一套组织协议**：规定谁向谁汇报、产物落哪个目录、什么话走哪条通道。

> 本项目的方法论骨架建立在 [Matt Pocock](https://github.com/mattpocock) 的开源技能集之上，明确引用了他的多个技能，并从中收获很多。逐条清单与收获见 **[ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md)**。

## 组织架构

```
pdt-group（一级部门）
└── pdt-leader            集团领导 · 用户入口
    ├── pd  产品部门      经理 pm
    │   ├── pd-researcher × N   调研      → docs/pd/research/
    │   └── pd-spec-e           SPEC      → docs/pd/spec/
    ├── dev 开发部门      经理 dm
    │   ├── dm-a                开发文档  → docs/dev/{plan,report}/
    │   └── de × N              纵向切片  → .worktrees/{ticket}
    └── test 测试部门     经理 tm
        ├── tm-a                测试文档  → docs/test/{plan,report}/
        └── te × N              测试执行  → docs/test/evidence/
```

三条派发铁律：

- 子代理**只向本部门经理汇报**，只接受本部门经理安排
- **经理间直通**：PM / DM / TM 横向直接协商
- 三方无法一致时**升级 leader 裁决**，结论落 `docs/status.md`

## 十个角色

| 角色 | 层级 | 职责 |
|---|---|---|
| [`pdt-leader`](pdt-leader/SKILL.md) | 一级 | 集团领导、用户入口。组建并管理 PM/DM/TM 三个伙伴会话，分派诉求，跨部门协调与顶层裁决 |
| [`pm`](pm/SKILL.md) | 经理 | 产品经理。把需求收敛成 SPEC（含 what/why 与 how），裁决开发/测试报告 |
| [`dm`](dm/SKILL.md) | 经理 | 开发经理。定设计决策与切片口径（落 plan），派单给 `de`，验收合并 |
| [`tm`](tm/SKILL.md) | 经理 | 测试经理。设计用例与结论，派发 `te`，复核并退回缺陷 |
| [`pd-researcher`](pd-researcher/SKILL.md) | 子代理 | 产品调研，带出处取证，只读，可多实例并行 |
| [`pd-spec-e`](pd-spec-e/SKILL.md) | 子代理 | SPEC 撰写与升版（产品部门唯一交付文档），独占 `docs/pd/spec/` |
| [`de`](de/SKILL.md) | 子代理 | 开发工程师。在 DM 预建的 git worktree 内 implement → tdd → 自审 → commit |
| [`te`](te/SKILL.md) | 子代理 | 测试工程师。执行用例，持 `code-review` 与 `diagnosing-bugs` |
| [`dm-a`](dm-a/SKILL.md) | 子代理 | 开发文档秘书，独占 `docs/dev/{plan,report}/` |
| [`tm-a`](tm-a/SKILL.md) | 子代理 | 测试文档秘书，独占 `docs/test/{plan,report}/` |

每个角色另有一页面向人的说明（四段式：What it does / When to reach for it / Common questions / It's working if），见 [`docs/`](docs/)。

## 一条需求怎么走完

需求从 leader 进，沿 pd → dev → test 单向流动，`{seq}` 是贯穿全链的锚（由 DM 写计划时生成，SPEC 与测试报告沿用）：

1. **pd**：`grilling` 拷问收敛决策 → `pd-researcher` 带出处取证 → `pd-spec-e` 落 SPEC
2. **dev**：DM 定设计决策（落计划目录的 `README.md`）并按 tracer-bullet 纵向切片 → `de` 在 worktree 内实施、走 tdd 红绿环、Standards 轴自审、分支内 commit → DM 验收合并
3. **test**：TM 按五类用例设计 → `te` 执行并落证据 → `tm-a` 拟报告 → TM 复核后双发 leader 与 DM

## 三条设计纪律

这三条是本项目与普通「提示词集合」的区别所在：

- **文档独占（单写者）**：每个目录只有一个角色能写。`research/` 归 `pd-researcher`、`spec/` 归 `pd-spec-e`、`dev/plan|report/` 归 `dm-a`、`test/plan|report/` 归 `tm-a`。三个经理都不亲自落笔，只定口径。既是防并发写冲突，也是一套权限模型。
- **指针化 vs 自包含**：目录布局、命名、看板格式只留一处（[`pdt-leader/group-conventions.md`](pdt-leader/group-conventions.md)），其余指向它；而验证方法、断言语义这类会被反复改写、且需要局部精度的条目，各技能自己写全并注明「与 X 侧同名同义」，不指向对方，避免对方改表时静默漂移。
- **轮次 vs 基线**：一条规则区分全部文件，名字里有 `YYYYMMDD-HHmm` 的是轮次产出（每轮新建），没有的是基线文档（升版覆盖同一文件）。

集团口径的唯一来源是 [`pdt-leader/group-conventions.md`](pdt-leader/group-conventions.md)。

## 安装

把 10 个角色目录**拍平**拷进 harness 的技能目录，不要带任何层级：

```bash
for d in pdt-leader pm dm tm pd-researcher pd-spec-e de te dm-a tm-a; do
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
├── pdt-leader/
│   ├── SKILL.md
│   ├── group-conventions.md  # 集团口径唯一来源：目录/命名/看板/交接/通信
│   ├── team-bootstrap.md     # 终端探测、会话创建、手动模式提示词
│   └── skill-inventory.md    # 角色 ↔ 上游技能台账
├── pm/SKILL.md
├── dm/{SKILL.md, templates.md}
├── tm/{SKILL.md, templates.md}
├── pd-researcher/SKILL.md
├── pd-spec-e/{SKILL.md, spec-format.md}
├── de/SKILL.md
├── te/SKILL.md
├── dm-a/SKILL.md
├── tm-a/SKILL.md
└── docs/                     # 面向人的四段式角色说明
```

## 依赖

| 依赖 | 用途 | 是否随本仓分发 |
|---|---|---|
| [`mattpocock/skills`](https://github.com/mattpocock/skills) | 提供 `grilling`、`research`、`to-spec`、`to-tickets`、`implement`、`tdd`、`code-review`、`diagnosing-bugs`、`handoff` 等能力 | 否，独立仓，需自行安装 |
| herdr | 首选通信通道（终端多路复用器，agent 之间定向发消息） | 否，独立工具 |

`mattpocock/skills` 是本项目的上游方法论来源，请直接访问其仓库并按 MIT 许可使用；本仓不拷贝其文件。
