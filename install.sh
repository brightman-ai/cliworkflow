#!/usr/bin/env bash
# cliworkflow 安装：中立根 ~/.cliworkflow + Claude 原生 slash + Codex per-command skill
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
[ "$ROOT" != "$HOME/.cliworkflow" ] && ln -sfn "$ROOT" "$HOME/.cliworkflow"
mkdir -p "$HOME/.claude/commands" "$HOME/.codex/skills"
for f in "$ROOT"/commands/cw-*.md; do ln -sfn "$f" "$HOME/.claude/commands/$(basename "$f")"; done   # Claude → /cw-*
for d in "$ROOT"/skills/cw-*;      do ln -sfn "$d" "$HOME/.codex/skills/$(basename "$d")";  done      # Codex → /skills 浏览 + 裸词
echo "✓ installed."
echo "  Claude: /cw-*（补全）   Codex: \$cw-*（\$ 触发）｜ /skills 选择器 ｜ 裸词 'cw-clarify …'（重启 codex 生效）"
echo "  卸载：删 ~/.claude/commands/cw-*、~/.codex/skills/cw-*、~/.cliworkflow"
