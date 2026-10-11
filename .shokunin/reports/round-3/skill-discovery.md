# skill-discovery — round 3 report

## Work performed
- Corrected the freshness probe to distinguish the primary/winning installed target from competing candidates, report absent winning files as failures, and require fresh inventory path equality. Evidence: `.shokunin/skill-discovery/corpus/probes/freshness.sh` (committed at `d0e5c46566518ee4bd4926ce0c7e40e9c5933602`).
- Added fixture-only path/inventory controls and tested isolated positive and negative cases. Positive: three matching primary files and three stale competing files yielded exit 0; absent primary targets yielded exit 1; one drifted primary yielded exit 1. Evidence: direct fixture command using `SKILL_DISCOVERY_FIXTURE=1` and isolated `/tmp/skilldisc-fixture-tsq6pw_4` roots; positive output reported competing drift as informational.
- Recorded the unresolved question of whether configured/default primary root always matches runtime winner in `.shokunin/l0-questions.md`; routed around it by requiring inventory location to match the configured/default root and failing on mismatch.
- Re-read the shokunin contract and the godspeed directive before work. Evidence: `/home/vgpnk/.agents/skills/shokunin/SKILL.md` and `/home/vgpnk/.prime/agent/skills/godspeed/directive.md`.

## Landed changes
- Updated `corpus/probes/freshness.sh` and appended Round 3 evidence in `LOG.md`; updated owned-axis status in `SCORECARD.md`. All carried by commit `d0e5c46566518ee4bd4926ce0c7e40e9c5933602`. `git diff --check` passed before commit.
- No install, live inventory verification, or existing-process reload was run; this round uses isolated fixtures only.

## Before → after measurements
- Operability (one falsifiable claim): before, absent installed candidate files were skipped and stale non-winning candidates contributed to failure. After, three matching winning targets + three stale competitors exit 0; missing winning targets and a drifted winner exit 1. Counting command: `grep -c 'winning_installed=.*MISSING' .shokunin/skill-discovery/corpus/probes/freshness.sh` (1), and `grep -c '(informational)' .shokunin/skill-discovery/corpus/probes/freshness.sh` (1); behavioral tests executed as above. Change measured at commit `d0e5c46566518ee4bd4926ce0c7e40e9c5933602`.
- Freshness: before and after, no real install or reload lifecycle was tested this round. No freshness change is claimed; competing root ownership remains open. Measured at commit `d0e5c46566518ee4bd4926ce0c7e40e9c5933602`.

## Verdicts
- `operability`: **improved** — isolated test cases falsify both absent-target and drifted-winner health, while stale competitors do not fail the positive fixture.
- `freshness`: **unchanged** — no live install/reload or environment freshness claim tested.

## SHONEN
- [x] Real decision tables/error patterns/checklists with cited sources; verified by named non-author `round1-independent-review` and `round2-independent-review`; receipts in `.shokunin/skill-discovery/LOG.md`.
- [ ] End-to-end domain task executed and logged; actual install plus reload lifecycle untouched.
- [x] Instructions executable without oral context; verified by named non-author `round1-independent-review` and `round2-independent-review`; receipts in `.shokunin/skill-discovery/LOG.md`.
- [x] No cross-domain bleed; PROVINCE remains accurate; verified by named non-author `round1-independent-review` and `round2-independent-review`; receipts in `.shokunin/skill-discovery/LOG.md`.
