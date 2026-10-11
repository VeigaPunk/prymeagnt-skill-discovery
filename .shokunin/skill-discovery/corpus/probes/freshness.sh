#!/usr/bin/env bash
# Read-only comparison of committed skill source, installed copies, and new-process discovery.
set -euo pipefail
repo="$(git rev-parse --show-toplevel)"
cd "$repo"
version="$(prime-agent --version)"
printf 'date=%s\nprime-agent=%s\nsource_commit=%s\n' "$(date -Is)" "$version" "$(git rev-parse HEAD)"
failed=0
inventory="$(prime-agent prompt 2>/dev/null)"
for name in godspeed shokunin ufo; do
  source="skills/$name/SKILL.md"
  source_hash="$(git show "HEAD:$source" | sha256sum | cut -d' ' -f1)"
  source_mtime="$(stat -c '%y' "$source")"
  printf 'skill=%s source_sha256=%s source_mtime=%s\n' "$name" "$source_hash" "$source_mtime"
  for root in "${PRIME_AGENT_CODING_AGENT_DIR:-$HOME/.prime/agent}/skills" "$HOME/.agents/skills"; do
    installed="$root/$name/SKILL.md"
    [ -f "$installed" ] || continue
    installed_hash="$(sha256sum "$installed" | cut -d' ' -f1)"
    installed_mtime="$(stat -c '%y' "$installed")"
    if [ "$source_hash" = "$installed_hash" ]; then result=match; else result=DRIFT; failed=1; fi
    printf 'installed=%s sha256=%s mtime=%s comparison=%s\n' "$installed" "$installed_hash" "$installed_mtime" "$result"
  done
  location="$(printf '%s\n' "$inventory" | grep -A4 -F "<name>$name</name>" | grep -m1 '<location>' | sed -E 's/.*<location>(.*)<\/location>.*/\1/' || true)"
  if [ -n "$location" ]; then printf 'fresh_inventory=%s location=%s\n' discovered "$location"; else printf 'fresh_inventory=%s\n' MISSING; failed=1; fi
done
exit "$failed"
