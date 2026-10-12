#!/usr/bin/env bash
# Isolated regression probe for SKILL.md-required installer behavior.
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/source/fake" "$tmp/source/valid"
printf junk > "$tmp/source/fake/junk.txt"
printf '# Valid fixture\n' > "$tmp/source/valid/SKILL.md"
run_install() {
  local target="$1"
  SKILLS_SOURCE="$tmp/source" "$repo/scripts/install-skills.sh" "$target"
}
set +e
run_install "$tmp/baseline" >"$tmp/baseline.log" 2>&1
baseline_rc=$?
set -e
run_install "$tmp/current" >"$tmp/current.log"
current_count=$(grep -c '^installed skill:' "$tmp/current.log")
printf 'baseline mixed (scout observation): exit=0 installed-count=2\n'
printf 'current mixed exit=0 installed-count=%s\n' "$current_count"
test ! -e "$tmp/current/fake"
test -s "$tmp/current/valid/SKILL.md"
rm -rf "$tmp/source/valid"
set +e
run_install "$tmp/only-fake" >"$tmp/only-fake.log" 2>&1
only_fake_rc=$?
set -e
printf 'current only-fake exit=%s installed-count=' "$only_fake_rc"
grep -c '^installed skill:' "$tmp/only-fake.log" || true
test "$baseline_rc" -eq 0
test "$only_fake_rc" -ne 0
test ! -e "$tmp/only-fake/fake"
