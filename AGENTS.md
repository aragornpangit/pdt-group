# AGENTS.md：本仓约定

这是 `pdt-group` 角色技能族的仓库。本文件写给在这个仓里干活的 agent。

## 骨架

    pdt-group-repo/
    ├── README.md            # 项目主页
    ├── ACKNOWLEDGMENTS.md   # 对 mattpocock/skills 的致谢与引用清单
    ├── AGENTS.md            # 本文件
    ├── <角色名>/            # 5 个角色，一角色一目录
    │   ├── SKILL.md         # 必需，含 YAML frontmatter
    │   └── *.md             # 可选附属文档（templates / spec-format / group-conventions 等）
    └── docs/<角色名>.md     # 面向人的四段式说明，与角色目录一一对应

**角色目录直接放在仓根**，不再套一层桶目录：这样安装到 harness 时无需拍平，仓内相对链接（如 `../pm/group-conventions.md`）也直接可用。

**目录名必须等于 `SKILL.md` 里的 `name` 字段。**

## 硬性纪律

1. **散文禁用 em-dash（U+2014）**。范围：`SKILL.md`、`docs/`、`README.md`、`ACKNOWLEDGMENTS.md`、`AGENTS.md`、代码注释。要断句就改写（逗号 / 冒号 / 句号 / 括号 / 连词），严禁盲目字符替换。
2. **凭证一律外置，禁止入库**。`SKILL.md`、脚本、示例里不得出现任何明文凭证（密码、token、PAT、私钥口令）。凭证放本机 `~/.config/uniview/.env`（权限 `600`），技能优先读环境变量，读不到再回落到该文件。提交前 grep 一次。
3. **登记一致性**：新增、改名、删除任何角色，下面三处要么都有、要么都没有：本仓 `README.md` 的角色表、`docs/<角色名>.md`、`pm/skill-inventory.md` 的台账。
4. **不留死代码**：角色退役即删除目录，不建 `deprecated/` 坟场，在提交信息里记明替代者。
5. **相对链接必须可达**：`SKILL.md` 与 `docs/` 里的相对链接，目标文件必须存在。

## 改动后自检

```bash
# 1) 禁 em-dash
grep -rn $'\u2014' --include='*.md' . | grep -v '^\./\.git' || echo "em-dash: 0"

# 2) 禁明文凭证
grep -rniE 'glpat-[A-Za-z0-9_-]{10,}|AppSecret|api[_-]?token' --include='*.md' . || echo "凭证: 0"

# 3) 角色目录与 name 字段一致 + docs 一一对应
for d in pm dm tm de te; do
  grep -q "^name: $d$" "$d/SKILL.md" || echo "FAIL: $d 的 name 不匹配"
  [ -f "docs/$d.md" ] || echo "FAIL: 缺 docs/$d.md"
done
```

## 上游归属

本项目的方法论骨架来自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT）。改动涉及上游技能的接线方式时，同步更新 [`ACKNOWLEDGMENTS.md`](ACKNOWLEDGMENTS.md) 与 [`pm/skill-inventory.md`](pm/skill-inventory.md)。**不要**把上游文件拷进本仓，用链接引用。

## 发布与同步

本仓是**发布镜像**：规范来源是作者的技能容器仓 `Skills` 的 `pdt-group` 桶（内网私有仓 `p00292/Skills`）。同步是单向的，容器仓 → 本仓。

因此在本仓里直接改角色定义、集团口径或台账，都会在下次同步时被覆盖。发现需要改的地方，按下面处理：

- **你在本仓有写权限**：改容器仓那一侧，再重新同步；
- **你是外部读者**：开 issue 或提 PR 说明意图，改动会在容器仓落地后随同步出现在本仓。

同步动作本身只需覆盖这 5 个角色目录与 `docs/`，`README.md`、`AGENTS.md`、`ACKNOWLEDGMENTS.md`、`LICENSE` 属于本仓自有文件，不参与覆盖。
