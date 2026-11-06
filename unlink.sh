#!/usr/bin/env bash
# Undo link.sh: remove the symlinks for this repo's skills from ~/.claude/skills and ~/.agents/skills.
# Only symlinks that point at this repo's skill directory are removed; real directories, symlinks to
# elsewhere, and missing entries are left alone. Both locations are tried regardless of what is installed.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"

unlink_from() {
  local dest="$1" dir name target
  if [ ! -d "$dest" ]; then
    echo "$dest not found, skipping"
    return 0
  fi
  for dir in "$REPO"/skills/*/; do
    name="$(basename "$dir")"
    [ -f "$dir/SKILL.md" ] || continue
    target="$dest/$name"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "${dir%/}" ]; then
      rm "$target"
      echo "unlinked $name from $dest"
    elif [ -e "$target" ] || [ -L "$target" ]; then
      echo "skipped $name in $dest (not a link to this repo)"
    fi
  done
}

unlink_from "$HOME/.claude/skills"
unlink_from "$HOME/.agents/skills"
