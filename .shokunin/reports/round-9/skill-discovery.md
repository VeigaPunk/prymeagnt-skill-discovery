# Skill discovery R9 — require SKILL.md for installer sources

Date: 2026-10-12
Branch: `craft/skill-r9-canonical`
Agent identity: `skill-discovery-shokunin <skill-discovery@shokunin.local>` (author and committer)
Baseline: `9ff68f594b66ec42f49c0d432037c31bf4405ded`

## Change and actual baseline comparison

The installer now skips source directories without `SKILL.md` before target creation/copy. The guard is `[ -f "$src/SKILL.md" ] || continue`; no YAML parser or dependency was introduced.

The reproducible probe `.shokunin/skill-discovery/corpus/probes/r9-installer-skillmd.sh <installer-path>` executes exactly the supplied installer on isolated mixed and only-fake fixtures, computes exit codes/counts/destination presence, and prints those observed values. I extracted the actual baseline script using `git show 9ff68f594b66ec42f49c0d432037c31bf4405ded:scripts/install-skills.sh` into a temporary executable, then ran baseline and current:

| Installer | Fixture | Exit | Installed count | fake destination |
|---|---|---:|---:|---|
| baseline | fake+junk and valid SKILL.md | 0 | 2 | yes |
| baseline | only fake+junk | 0 | 1 | yes |
| current | fake+junk and valid SKILL.md | 0 | 1 | no |
| current | only fake+junk | 1 | 0 | no |

Temporary sources and targets were cleaned up. `git diff --check` passed. No live daemon, discovery process, or `/reload` was used.

## Axis verdict

- **Operability: narrowly improved.** Directories without the required manifest file are no longer copied or counted as installed skills; both mixed-positive and all-invalid cases were measured against actual baseline and current installers.
- **Freshness: unchanged.** This installation filter does not prove fresh-process discovery or reload.

This clean candidate supersedes the earlier R9 candidate: its initial probe mislabeled a current-installer run as baseline, and its Git author/committer identity was misspelled (`skill-discovery-shonkin`). Do not admit or rely on that candidate's commits. No manifest/global/push/shared installation changes.
