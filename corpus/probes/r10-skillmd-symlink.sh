#!/usr/bin/env bash
# Private source/target and fresh-process probe; pass the installer version explicitly.
set -euo pipefail
installer="${1:?usage: r10-skillmd-symlink.sh <installer-path>}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
source="$tmp/source"
project="$tmp/private-project"
target="$project/.prime/agent/skills"
mkdir -p "$source/r10-ghost" "$source/r10-absolute" "$source/r10-internal/docs" "$source/r10-peer" "$project"
printf '%s\n' '---' 'name: r10-ghost' 'description: External relative link fixture.' '---' '# Ghost' > "$source/outside.md"
printf '%s\n' '---' 'name: r10-absolute' 'description: External absolute link fixture.' '---' '# Absolute' > "$tmp/absolute.md"
printf '%s\n' '---' 'name: r10-internal' 'description: Internal relative link fixture.' '---' '# Internal' > "$source/r10-internal/docs/real.md"
printf '%s\n' '---' 'name: r10-peer' 'description: Ordinary skill fixture.' '---' '# Peer' > "$source/r10-peer/SKILL.md"
ln -s ../outside.md "$source/r10-ghost/SKILL.md"
ln -s "$tmp/absolute.md" "$source/r10-absolute/SKILL.md"
ln -s docs/real.md "$source/r10-internal/SKILL.md"
set +e
SKILLS_SOURCE="$source" "$installer" "$target" > "$tmp/install.log" 2>&1
install_rc=$?
set -e
installed_count="$(grep -c '^installed skill:' "$tmp/install.log" || true)"
printf 'install exit=%s installed-count=%s\n' "$install_rc" "$installed_count"
for name in r10-ghost r10-absolute r10-internal r10-peer; do
  if [ -f "$target/$name/SKILL.md" ]; then file=yes; else file=no; fi
  if [ -L "$target/$name/SKILL.md" ]; then symlink=yes; else symlink=no; fi
  printf 'target %s file=%s symlink=%s\n' "$name" "$file" "$symlink"
done
set +e
prime-agent prompt --cwd "$project" --json > "$tmp/inventory.json" 2> "$tmp/inventory.err"
prompt_rc=$?
set -e
printf 'fresh-process prompt exit=%s\n' "$prompt_rc"
if [ "$prompt_rc" -eq 0 ]; then
  python3 - "$tmp/inventory.json" <<'PY'
import json, re, sys
text = json.load(open(sys.argv[1]))['prompt']
for name in ('r10-ghost', 'r10-absolute', 'r10-internal', 'r10-peer'):
    print('inventory %s=%s' % (name, 'present' if re.search(r'<name>' + name + r'</name>', text) else 'absent'))
PY
fi
rm -rf "$source/r10-internal" "$source/r10-peer"
set +e
SKILLS_SOURCE="$source" "$installer" "$tmp/only-external" > "$tmp/only-external.log" 2>&1
only_external_rc=$?
set -e
only_external_count="$(grep -c '^installed skill:' "$tmp/only-external.log" || true)"
printf 'only-external exit=%s installed-count=%s\n' "$only_external_rc" "$only_external_count"
