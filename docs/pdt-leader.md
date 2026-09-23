# pdt-leader

## What it does

PDT 集团的负责人，也是一级部门 `pdt-group` 的负责人，**用户主要跟这个角色沟通**。

它组建并管理 PM / DM / TM 三个二级部门负责人的伙伴会话，承接用户的需求、变更与问题反馈，把诉求分派到对应部门，并做跨部门协调与顶层裁决。

组织架构：

```
pdt-group（一级部门）
└── pdt-leader（用户入口）
    ├── pd   产品部门（经理 pm）：pd-researcher × N、pd-spec-e
    ├── dev  开发部门（经理 dm）：dm-a、de × N
    └── test 测试部门（经理 tm）：tm-a、te × N
```

三个词贯穿每一步：**入口**、**分派**、**总览**。

## When to reach for it

- 用户启动 PDT、提出需求 / 变更 / 问题反馈
- 需要跨部门协调
- 部门之间对需求、范围或验收口径有分歧，需要顶层裁决
- 要组建集团（探测终端、起三个经理会话）

## Common questions

**用户能直接找 PM/DM/TM 吗？**
不能绕过 leader 对外承诺。用户需求先进 leader，再由 leader 分派给对应部门。

**三个经理之间能直接沟通吗？**
能。PM/DM/TM 之间可直接协商（横向通道，不必经 leader 转达）。但三方对需求、范围、验收口径**无法达成一致时要升级 leader 裁决**，leader 的结论落 `docs/status.md`，各方执行。

**集团状态看哪里？**
`docs/status.md` 是集团唯一共享状态，各列由对应部门维护，leader 只读总览。看板与实际状态不一致时以实际状态为准并回写看板。

**用什么通信？**
herdr 优先，看板兜底。能发 herdr 定向消息就发，同时把进度落盘到看板；看板始终是唯一共享状态，消息会丢、文件不会。

**怎么做会话自我交接？**
只有 leader/PM/DM/TM 四个负责人会做，且**只写给自己未来的会话**，用 mattpocock 的 `/handoff` 生成，落 `docs/handoff/`。**不做角色与角色之间的 handoff**，跨角色传递走 herdr 消息与看板。

**组建集团时要探测什么？**
探测宿主终端，顺序 `HERDR_ENV` → `TMUX` → `WEZTERM_PANE` → `WT_SESSION` → Ghostty → `WSL_DISTRO_NAME`，取第一个命中，结果写入 `.pdt/team.json`；一个都没命中才请用户选。

## It's working if

`.pdt/team.json` 记录了终端与三个会话；`docs/status.md` 看板存在且三方各自的列都在维护；在 herdr 里能定位到 `pm` / `dm` / `tm` 三个会话并发出定向消息。

配套文档（都在本技能目录内）：`group-conventions.md`（集团唯一规范来源：目录布局、文件命名、看板格式、交接、通信）、`team-bootstrap.md`（终端探测、会话创建、手动模式提示词）、`skill-inventory.md`（技能台账）。
