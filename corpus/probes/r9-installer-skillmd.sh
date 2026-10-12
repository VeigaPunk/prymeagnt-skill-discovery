#!/usr/bin/env bash
# Isolated regression probe. Pass an installer path to test that exact version.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
installer="${1:-$repo/scripts/install-skills.sh}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/source/fake" "$tmp/source/valid"
printf junk > "$tmp/source/fake/junk.txt"
printf '# Valid fixture\n' > "$tmp/source/valid/SKILL.md"
run_install() {
  local target="$1"
  SKILLS_SOURCE="$tmp/source" "$installer" "$target"
}
set +e
run_install "$tmp/mixed" >"$tmp/mixed.log" 2>&1
mixed_rc=$?
set -e
mixed_count=$(grep -c '^installed skill:' "$tmp/mixed.log" || true)
printf 'mixed exit=%s installed-count=%s\n' "$mixed_rc" "$mixed_count"
test -s "$tmp/mixed/valid/SKILL.md"
if [ -e "$tmp/mixed/fake" ]; then fake_present=yes; else fake_present=no; fi
printf 'mixed fake-destination=%s\n' "$fake_present"
rm -rf "$tmp/source/valid"
set +e
run_install "$tmp/only-fake" >"$tmp/only-fake.log" 2>&1
only_fake_rc=$?
set -e
only_fake_count=$(grep -c '^installed skill:' "$tmp/only-fake.log" || true)
printf 'only-fake exit=%s installed-count=%s\n' "$only_fake_rc" "$only_fake_count"
if [ -e "$tmp/only-fake/fake" ]; then only_fake_present=yes; else only_fake_present=no; fi
printf 'only-fake destination=%s\n' "$only_fake_present"
