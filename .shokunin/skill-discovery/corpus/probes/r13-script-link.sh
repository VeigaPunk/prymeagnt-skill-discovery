#!/usr/bin/env bash
# Private native installer-path probe. Pass an absolute installer path.
set -euo pipefail
installer="$(realpath -e -- "${1:?usage: r13-script-link.sh <installer-path>}")"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/override/override-r13"
ln -s "$installer" "$tmp/bin/install-skills.sh"
printf '%s\n' '---' 'name: override-r13' 'description: Explicit override fixture.' '---' '# Override' > "$tmp/override/override-r13/SKILL.md"
run_case() {
  local label="$1" entry="$2" override="$3" project="$tmp/$1-project" target rc prompt_rc count inventory
  target="$project/.prime/agent/skills"
  mkdir -p "$project"
  set +e
  if [ "$override" = yes ]; then
    SKILLS_SOURCE="$tmp/override" "$entry" "$target" > "$tmp/$label.install.log" 2>&1
  else
    "$entry" "$target" > "$tmp/$label.install.log" 2>&1
  fi
  rc=$?
  prime-agent prompt --cwd "$project" --json > "$tmp/$label.inventory.json" 2> "$tmp/$label.inventory.err"
  prompt_rc=$?
  set -e
  count="$(grep -c '^installed skill:' "$tmp/$label.install.log" || true)"
  printf '%s install-exit=%s count=%s prompt-exit=%s\n' "$label" "$rc" "$count" "$prompt_rc"
  if [ "$rc" -ne 0 ]; then sed -n '1,2p' "$tmp/$label.install.log"; fi
  if [ "$prompt_rc" -eq 0 ]; then
    python3 - "$tmp/$label.inventory.json" "$label" "$target" <<'PY'
import json, re, sys
text = json.load(open(sys.argv[1]))['prompt']
for name in ('godspeed', 'shokunin', 'ufo', 'override-r13'):
    skill = re.search(r'<skill>\s*<name>' + name + r'</name>.*?</skill>', text, re.S)
    location = f'<location>{sys.argv[3]}/{name}/SKILL.md</location>'
    print(f'{sys.argv[2]} private-inventory {name}=' + ('present' if skill and location in skill.group() else 'absent'))
PY
  fi
}
run_case direct "$installer" no
run_case linked "$tmp/bin/install-skills.sh" no
run_case override "$tmp/bin/install-skills.sh" yes
