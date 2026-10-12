#!/usr/bin/env bash
# Native private installer and fresh-process inventory probe, one installer version per invocation.
set -euo pipefail
installer="${1:?usage: r11-source-directory-link.sh <installer-path>}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
source="$tmp/source"
project="$tmp/private-project"
target="$project/.prime/agent/skills"
mkdir -p "$source/ordinary" "$tmp/external" "$project"
printf '%s\n' '---' 'name: outside-skill' 'description: External directory fixture.' '---' '# Outside' > "$tmp/external/SKILL.md"
printf '%s\n' '---' 'name: ordinary' 'description: Ordinary skill fixture.' '---' '# Ordinary' > "$source/ordinary/SKILL.md"
ln -s "$tmp/external" "$source/outside-skill"
run_case() {
  label="$1"
  destination="$2"
  private_project="$3"
  set +e
  SKILLS_SOURCE="$source" "$installer" "$destination" > "$tmp/$label.install.log" 2>&1
  install_rc=$?
  prime-agent prompt --cwd "$private_project" --json > "$tmp/$label.inventory.json" 2> "$tmp/$label.inventory.err"
  prompt_rc=$?
  set -e
  count="$(grep -c '^installed skill:' "$tmp/$label.install.log" || true)"
  if [ -d "$destination/outside-skill" ]; then outside_target=yes; else outside_target=no; fi
  if [ -d "$destination/ordinary" ]; then ordinary_target=yes; else ordinary_target=no; fi
  printf '%s install-exit=%s count=%s outside-target=%s ordinary-target=%s prompt-exit=%s\n' "$label" "$install_rc" "$count" "$outside_target" "$ordinary_target" "$prompt_rc"
  if [ "$prompt_rc" -eq 0 ]; then
    python3 - "$tmp/$label.inventory.json" "$label" <<'PY'
import json, re, sys
text = json.load(open(sys.argv[1]))['prompt']
for name in ('outside-skill', 'ordinary'):
    print(f'{sys.argv[2]} inventory {name}=' + ('present' if re.search(r'<name>' + name + r'</name>', text) else 'absent'))
PY
  fi
}
run_case mixed "$target" "$project"
rm -rf "$source/ordinary"
mkdir -p "$tmp/only-project"
run_case only-link "$tmp/only-project/.prime/agent/skills" "$tmp/only-project"
