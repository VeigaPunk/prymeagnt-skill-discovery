#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/skill-discovery-r4.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT
SOURCE="$SCRATCH/source"
TARGET="$SCRATCH/.prime/agent/skills"
mkdir -p "$SOURCE/skill-discovery-probe"
cat > "$SOURCE/skill-discovery-probe/SKILL.md" <<'SKILL'
---
name: skill-discovery-probe
description: Disposable probe for isolated skill discovery verification.
---

# Probe

This skill exists only to verify isolated discovery.
SKILL
SKILLS_SOURCE="$SOURCE" "$ROOT/scripts/install-skills.sh" "$TARGET"
FILE="$TARGET/skill-discovery-probe/SKILL.md"
test -f "$FILE"
grep -q '^name: skill-discovery-probe$' "$FILE"
grep -q '^description: Disposable probe for isolated skill discovery verification\.$' "$FILE"
INVENTORY="$(prime-agent prompt --cwd "$SCRATCH")"
printf '%s\n' "$INVENTORY" | grep -F '<name>skill-discovery-probe</name>'
printf '%s\n' "$INVENTORY" | grep -F "<location>$FILE</location>"
