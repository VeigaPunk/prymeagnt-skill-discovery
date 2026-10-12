#!/usr/bin/env bash
# Private target-entry symlink probe; invoke once per actual installer version.
set -euo pipefail
installer="${1:?usage: r12-target-directory-link.sh <installer-path>}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
source="$tmp/source"
mkdir -p "$source/a-ordinary" "$source/z-linked"
printf '%s\n' '---' 'name: a-ordinary' 'description: Ordinary fixture.' '---' '# Ordinary' > "$source/a-ordinary/SKILL.md"
printf '%s\n' '---' 'name: z-linked' 'description: Linked destination fixture.' '---' '# Linked' > "$source/z-linked/SKILL.md"
for label in mixed linked-only ordinary-only; do
  project="$tmp/$label-project"
  target="$project/.prime/agent/skills"
  outside="$tmp/$label-outside"
  mkdir -p "$target" "$outside" "$tmp/$label-source"
  printf '%s\n' 'outside sentinel unchanged' > "$outside/sentinel.txt"
  case "$label" in
    mixed) cp -a "$source"/. "$tmp/$label-source/"; ln -s "$outside" "$target/z-linked" ;;
    linked-only) cp -a "$source/z-linked" "$tmp/$label-source/"; ln -s "$outside" "$target/z-linked" ;;
    ordinary-only) cp -a "$source/a-ordinary" "$tmp/$label-source/" ;;
  esac
  set +e
  SKILLS_SOURCE="$tmp/$label-source" "$installer" "$target" > "$tmp/$label.install.log" 2>&1
  install_rc=$?
  prime-agent prompt --cwd "$project" --json > "$tmp/$label.inventory.json" 2> "$tmp/$label.inventory.err"
  prompt_rc=$?
  set -e
  count="$(grep -c '^installed skill:' "$tmp/$label.install.log" || true)"
  if [ -f "$outside/SKILL.md" ]; then outside_write=yes; else outside_write=no; fi
  if [ "$(cat "$outside/sentinel.txt")" = 'outside sentinel unchanged' ]; then sentinel=unchanged; else sentinel=changed; fi
  if [ -L "$target/z-linked" ]; then dest_link=yes; else dest_link=no; fi
  if [ -f "$target/a-ordinary/SKILL.md" ]; then ordinary=yes; else ordinary=no; fi
  printf '%s install-exit=%s count=%s outside-write=%s sentinel=%s destination-link=%s ordinary=%s prompt-exit=%s\n' "$label" "$install_rc" "$count" "$outside_write" "$sentinel" "$dest_link" "$ordinary" "$prompt_rc"
  if [ "$prompt_rc" -eq 0 ]; then
    python3 - "$tmp/$label.inventory.json" "$label" <<'PY'
import json, re, sys
text = json.load(open(sys.argv[1]))['prompt']
for name in ('z-linked', 'a-ordinary'):
    print(f'{sys.argv[2]} inventory {name}=' + ('present' if re.search(r'<name>' + name + r'</name>', text) else 'absent'))
PY
  fi
done
