#!/usr/bin/env bash
# Read-only fresh-process inventory probe. This does NOT test daemon reload.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/skill-discovery-r5.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT
TARGET="$SCRATCH/.prime/agent/skills"
mkdir -p "$TARGET"
probe="$TARGET/skill-discovery-r5-probe"
run_inventory() {
  local label="$1"
  local output="$SCRATCH/$label.txt"
  prime-agent prompt --cwd "$SCRATCH" > "$output" &
  local process_pid=$!
  printf 'phase=%s process_pid=%s command=prime-agent prompt --cwd %q\n' "$label" "$process_pid" "$SCRATCH"
  wait "$process_pid"
  printf 'phase=%s inventory_sha256=' "$label"
  sha256sum "$output" | cut -d' ' -f1
  if grep -Fq '<name>skill-discovery-r5-probe</name>' "$output"; then
    grep -A4 -F '<name>skill-discovery-r5-probe</name>' "$output" | head -5
  else
    printf 'phase=%s probe_skill=ABSENT\n' "$label"
  fi
}
printf 'prime_agent=%s\n' "$(prime-agent --version)"
printf 'scope=private-temporary-cwd-and-.prime-agent-skills; no install into user skill directory\n'
run_inventory before
mkdir -p "$probe"
cat > "$probe/SKILL.md" <<'SKILL'
---
name: skill-discovery-r5-probe
description: Disposable R5 fresh-process inventory probe.
---

# Probe
SKILL
printf 'edited_file=%s sha256=' "$probe/SKILL.md"
sha256sum "$probe/SKILL.md" | cut -d' ' -f1
run_inventory after
printf 'daemon_reload=NOT_TESTED fresh_process_inventory=TESTED\n'
