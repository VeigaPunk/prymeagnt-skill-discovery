#!/usr/bin/env bash
# Read-only comparison of committed skill source, winning installed copies, and new-process discovery.
set -euo pipefail
repo="$(git rev-parse --show-toplevel)"
cd "$repo"
fixture="${SKILL_DISCOVERY_FIXTURE:-0}"
source_root="${SKILL_DISCOVERY_SOURCE_ROOT:-$repo/skills}"
primary_root="${SKILL_DISCOVERY_PRIMARY_ROOT:-${PRIME_AGENT_CODING_AGENT_DIR:-$HOME/.prime/agent}/skills}"
competing_root="${SKILL_DISCOVERY_COMPETING_ROOT:-$HOME/.agents/skills}"
if [ "$fixture" = 1 ]; then
  version=fixture
  inventory="$(cat "$SKILL_DISCOVERY_INVENTORY_FILE")"
else
  version="$(prime-agent --version)"
  inventory="$(prime-agent prompt 2>/dev/null)"
fi
printf 'date=%s\nprime-agent=%s\nsource_commit=%s\n' "$(date -Is)" "$version" "$(git rev-parse HEAD)"
failed=0
for name in godspeed shokunin ufo; do
  source="$source_root/$name/SKILL.md"
  if [ "$fixture" = 1 ]; then source_hash="$(sha256sum "$source" | cut -d' ' -f1)"; else source_hash="$(git show "HEAD:skills/$name/SKILL.md" | sha256sum | cut -d' ' -f1)"; fi
  source_mtime="$(stat -c '%y' "$source")"
  printf 'skill=%s source_sha256=%s source_mtime=%s\n' "$name" "$source_hash" "$source_mtime"
  winning="$primary_root/$name/SKILL.md"
  if [ ! -f "$winning" ]; then
    printf 'winning_installed=%s MISSING\n' "$winning"
    failed=1
  else
    installed_hash="$(sha256sum "$winning" | cut -d' ' -f1)"
    installed_mtime="$(stat -c '%y' "$winning")"
    if [ "$source_hash" = "$installed_hash" ]; then result=match; else result=DRIFT; failed=1; fi
    printf 'winning_installed=%s sha256=%s mtime=%s comparison=%s\n' "$winning" "$installed_hash" "$installed_mtime" "$result"
  fi
  competing="$competing_root/$name/SKILL.md"
  if [ -f "$competing" ]; then
    competing_hash="$(sha256sum "$competing" | cut -d' ' -f1)"
    if [ "$source_hash" = "$competing_hash" ]; then result=match; else result=DRIFT; fi
    printf 'competing_candidate=%s sha256=%s comparison=%s (informational)\n' "$competing" "$competing_hash" "$result"
  fi
  location="$(printf '%s\n' "$inventory" | grep -A4 -F "<name>$name</name>" | grep -m1 '<location>' | sed -E 's/.*<location>(.*)<\/location>.*/\1/' || true)"
  if [ -n "$location" ]; then
    printf 'fresh_inventory=discovered location=%s\n' "$location"
    if [ "$location" != "$winning" ]; then printf 'fresh_inventory_target=MISMATCH expected=%s\n' "$winning"; failed=1; fi
  else printf 'fresh_inventory=MISSING\n'; failed=1; fi
done
exit "$failed"
