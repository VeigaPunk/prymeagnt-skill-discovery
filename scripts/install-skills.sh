#!/usr/bin/env bash
# install-skills.sh — copy the repo's skills/ content into prime-agent's
# user skill discovery directory.
#
# Usage: scripts/install-skills.sh [TARGET_DIR]
#   TARGET_DIR defaults to ${PRIME_AGENT_CODING_AGENT_DIR:-$HOME/.prime/agent}/skills.
#   The script fails loudly rather than guessing when the default's parent
#   config dir does not exist — pass the confirmed directory explicitly.
#
# Environment:
#   SKILLS_SOURCE   source dir (default: <repo>/skills)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${SKILLS_SOURCE:-$SCRIPT_DIR/../skills}"
AGENT_DIR="${PRIME_AGENT_CODING_AGENT_DIR:-$HOME/.prime/agent}"
TARGET="${1:-$AGENT_DIR/skills}"

fail() {
  echo "error: $*" >&2
  exit 1
}

if [ "$TARGET" = "$AGENT_DIR/skills" ] && [ ! -d "$AGENT_DIR" ]; then
  fail "prime-agent user config dir not found: $AGENT_DIR
       pass the confirmed skill discovery dir as the first argument:
       $0 <target-dir>"
fi

if [ ! -d "$SOURCE" ] || [ -z "$(ls -A "$SOURCE" 2>/dev/null)" ]; then
  fail "no skills to install: '$SOURCE' is missing or empty
       expected skills/<name>/SKILL.md in the repo, or set SKILLS_SOURCE"
fi

mkdir -p "$TARGET"

installed=0
for src in "$SOURCE"/*/; do
  [ -L "${src%/}" ] && continue
  [ -d "$src" ] || continue
  [ -f "$src/SKILL.md" ] || continue
  if [ -L "$src/SKILL.md" ]; then
    link="$(readlink "$src/SKILL.md")"
    case "$link" in /*) continue ;; esac
    source_dir="$(realpath -e -- "$src")"
    link_target="$(realpath -e -- "$src/SKILL.md")"
    case "$link_target" in "$source_dir"/*) ;; *) continue ;; esac
  fi
  name="$(basename "$src")"
  case "$name" in .*) continue ;; esac
  [ -L "$TARGET/$name" ] && fail "skill destination is a symlink: $TARGET/$name"
  mkdir -p "$TARGET/$name"
  cp -a "$src". "$TARGET/$name/"
  if [ -L "$src/SKILL.md" ]; then
    cp -L --remove-destination -- "$src/SKILL.md" "$TARGET/$name/SKILL.md"
  fi
  echo "installed skill: $name -> $TARGET/$name"
  installed=$((installed + 1))
done

[ "$installed" -gt 0 ] || fail "no skill directories found under $SOURCE (expected skills/<name>/)"
echo "done: $installed skill(s) installed into $TARGET"
