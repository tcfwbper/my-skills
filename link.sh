#!/usr/bin/env bash
# Symlink every skill in this repo into the skill directory of each harness installed on this machine:
#   Claude Code (`claude` found)  -> ~/.claude/skills
#   Codex       (`codex` found)   -> ~/.agents/skills
# Each harness is detected and linked independently; a missing one is skipped, not an error.
# A `git pull` then keeps installed skills current. Re-run after adding, removing, or renaming a skill.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"

# has_tool <command> [fallback paths...]: true if the command is on PATH or any fallback is executable.
has_tool() {
  local cmd="$1"; shift
  command -v "$cmd" >/dev/null 2>&1 && return 0
  local p
  for p in "$@"; do [ -x "$p" ] && return 0; done
  return 1
}

link_into() {
  local dest="$1" dir name
  mkdir -p "$dest"
  for dir in "$REPO"/skills/*/; do
    name="$(basename "$dir")"
    [ -f "$dir/SKILL.md" ] || continue
    ln -sfn "${dir%/}" "$dest/$name"
    echo "linked $name -> $dest"
  done
}

installed=0

if has_tool claude "$HOME/.claude/local/claude" "$HOME/.local/bin/claude"; then
  echo "Claude Code detected"
  link_into "$HOME/.claude/skills"
  installed=$((installed + 1))
else
  echo "Claude Code not found, skipping ~/.claude/skills"
fi

if has_tool codex; then
  echo "Codex detected"
  link_into "$HOME/.agents/skills"
  installed=$((installed + 1))
else
  echo "Codex not found, skipping ~/.agents/skills"
fi

if [ "$installed" -eq 0 ]; then
  echo "Neither Claude Code nor Codex found on PATH; nothing linked." >&2
  exit 1
fi
