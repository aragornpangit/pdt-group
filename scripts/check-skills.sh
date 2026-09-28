#!/usr/bin/env bash
# 容器仓 §8 校验封装（唯一入口；2026-09-28 立）
#
# 存在理由：§8 的校验脚本若用「管道后取 rc」会丢 rc（TM 实测三次复发，2026-09-28）。
# 按元纪律「靠记得遵守的纪律必然复发」⇒ 把它工具化：本脚本内部显式取 rc，
# 非零即 loud FAIL 并打印 FAIL 摘录；调用方只看本脚本的退出码（不再关心管道）。
#
# 用法：bash scripts/check-skills.sh
#   退出码 0  = §8 问题数 0
#   退出码 非0 = 校验失败（原样透传 §8 的 rc）或提取失败（3）
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || { echo "SKILLS-CHECK FAIL: 无法进入仓库根"; exit 2; }

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

sed -n "/^python3 - <<'EOF'/,/^EOF$/p" AGENTS.md | sed '1d;$d' > "$TMP"
if [ ! -s "$TMP" ]; then
  echo "SKILLS-CHECK FAIL: 未能从 AGENTS.md 提取第 8 节校验脚本（围栏或路径变了）"
  exit 3
fi

out="$(python3 "$TMP" 2>&1)"
rc=$?

if [ "$rc" -ne 0 ]; then
  echo "=== SKILLS-CHECK FAIL (rc=$rc) ==="
  echo "$out" | grep -n '^FAIL:' || echo "$out" | tail -5
  echo "================================="
  exit "$rc"
fi

n="$(printf '%s\n' "$out" | sed -n 's/.*问题数: \([0-9]\{1,\}\)$/\1/p' | tail -1)"
echo "SKILLS-CHECK OK: problems=${n:-?} rc=0"
exit 0
