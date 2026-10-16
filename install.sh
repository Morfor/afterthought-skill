#!/usr/bin/env bash
# Install Afterthought for Claude Code (user level, all projects).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
c="$HOME/.claude"
command -v jq >/dev/null || { echo "jq is required (install it with your package manager)"; exit 1; }

mkdir -p "$c/agents" "$c/skills/afterthought" "$c/afterthought/solutions"
cp "$here/agents/afterthought.md" "$c/agents/afterthought.md"
cp "$here/skills/afterthought/SKILL.md" "$c/skills/afterthought/SKILL.md"
# Seed the tree only when it is empty, never overwrite your files.
if [ -z "$(ls -A "$c/afterthought/solutions")" ]; then
  cp -r "$here/solutions/." "$c/afterthought/solutions/"
fi

# Add the UserPromptSubmit hook that shows the tree's top folders.
s="$c/settings.json"
[ -f "$s" ] || echo '{}' > "$s"
cmd='d="$HOME/.claude/afterthought/solutions"; [ -d "$d" ] && echo "Afterthought tree $d: $(ls -1 "$d" | paste -sd " ") (look up by names before multi-step work; afterthought skill before any agent)" 2>/dev/null || true'
if jq -e --arg c "$cmd" '[.hooks.UserPromptSubmit[]?.hooks[]?.command] | index($c)' "$s" >/dev/null; then
  echo "Hook already present."
else
  cp "$s" "$s.bak-afterthought"
  jq --arg c "$cmd" '.hooks.UserPromptSubmit += [{"hooks":[{"type":"command","command":$c,"timeout":5}]}]' "$s.bak-afterthought" > "$s"
  echo "Hook added (backup: $s.bak-afterthought)."
fi
echo "Afterthought installed. Restart Claude Code (or open /hooks once) to load it."
