# Skill discovery R8 — installer source preflight (no-axis)

Date: 2026-10-12
Branch: `craft/skill-r8-installer`
Agent identity: `skill-discovery-shonen <skill-discovery@shokunin.local>` (author and committer)
Baseline: `46ccbf12cf366adc470e837af62c2a2539c52b58`

## Scope and observations

The assigned bounded opportunity was preflighting source skills before installation so a malformed later source cannot leave a partially populated target. I made **no source patch**. Inspection of `scripts/install-skills.sh` shows it checks source existence/nonemptiness (line 31), creates the target (line 35), then iterates skill directories and copies them (lines 38–43); it does not validate `SKILL.md` or YAML frontmatter.

The documented skill-creator contract at `/home/vgpnk/.local/share/prime-agent/skills/skill-creator/SKILL.md` says `SKILL.md` has YAML frontmatter (line 8), description is required and a missing/empty description is silently not loaded (line 53), and verification checks it is nonempty (line 77). It describes `/reload` and other sessions picking skills up on start (line 78). Thus installer acceptance is not evidence of daemon or session discoverability.

The source repo's three skill files were checked locally and all use folded descriptions (`description: >` or `description: >-`). The host has Ruby/Psych, but Ruby is not a declared installer dependency; Python 3 here cannot import PyYAML (`ModuleNotFoundError`). I did not introduce a dependency or attempt an ad hoc Bash frontmatter parser: that would not safely cover YAML validity, folded blocks, and quoted scalars. No installer, provider, daemon, or discovery CLI was invoked. No private fixture was run in this report-only round.

L1's baseline scout finding is **secondhand**: L1 reported that a private source skill with an empty description was copied and counted with exit 0, while documented discovery silently skipped it. I did not independently rerun that fixture and claim no new exit code.

## Axis verdict proposal

- **Operability: unchanged.** No preflight behavior was changed or locally validated before/after; the reported baseline gap remains.
- **Freshness: unchanged.** No live skill inventory, fresh-process discovery, or reload was checked.

No axis improved. The end-to-end install/discovery lifecycle remains distinct from installer acceptance. No shared installation/configuration, provider, daemon, MANIFEST, global state, or push was touched.
