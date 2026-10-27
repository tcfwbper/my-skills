#!/usr/bin/env bash
# Symlink every skill in this repo into the local skill directories each harness reads:
#   ~/.claude/skills  (Claude Code)
#   ~/.agents/skills  (Codex and other Agent Skills-compatible harnesses)
# A `git pull` then keeps installed skills current. Re-run after adding, removing, or renaming a skill.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
for DEST in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$DEST"
  for dir in "$REPO"/skills/*/; do
    name="$(basename "$dir")"
    [ -f "$dir/SKILL.md" ] || continue
    ln -sfn "${dir%/}" "$DEST/$name"
    echo "linked $name -> $DEST"
  done
done
