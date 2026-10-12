# Skill discovery R9 — require a skill manifest file

Date: 2026-10-12
Branch: `craft/skill-r9-missing`
Agent identity: `skill-discovery-shokunin <skill-discovery@shokunin.local>` (author and committer)
Baseline: `9ff68f594b66ec42f49c0d432037c31bf4405ded`

## Change and evidence

The installer treated any visible directory as an installed skill, despite the documented `skills/<name>/SKILL.md` format. Added one source-loop check: `[ -f "$src/SKILL.md" ] || continue`, before target creation/copy. No YAML parser, live daemon, discovery command, or `/reload` was used.

Reproducible isolated fixture: `.shokunin/skill-discovery/corpus/probes/r9-installer-skillmd.sh` creates a junk-only `fake` directory and valid `valid/SKILL.md` in a temporary source. Its recorded run results:

- Mixed baseline (scout observation): exit 0, installed count 2 (fake junk directory plus valid directory).
- Current mixed source: exit 0, installed count 1; fake absent and valid SKILL.md present.
- Current only-fake source: exit 1, installed count 0; fake absent.

The probe records the scout's baseline separately and asserts current positive/negative behavior. Existing documented installer and R7/R8 controls were not changed.

## Axis verdict

- **Operability: narrowly improved.** Directories lacking the required `SKILL.md` are skipped before destination creation and copying; junk no longer counts as an installed skill. The positive/negative isolated checks passed.
- **Freshness: unchanged.** Installation alone does not demonstrate process discovery or reload. No live daemon or `/reload` check was run.

No manifest/global state/push or shared installation was touched.


## Append-only correction: actual baseline comparison

This addendum supersedes the initial fixture description above: the original probe used the current installer for its supposed baseline run, and the first report text therefore incorrectly described a scout-derived count as if it were baseline-probe evidence. The earlier text is retained for audit history; do not rely on its baseline characterization.

The probe has been corrected to accept an installer path (`.shokunin/skill-discovery/corpus/probes/r9-installer-skillmd.sh <path>`), execute that exact binary/script for both fixtures, and print computed exit codes, installed counts, and destination presence. Baseline was extracted with `git show 9ff68f594b66ec42f49c0d432037c31bf4405ded:scripts/install-skills.sh` to a temporary executable. Actual results: baseline mixed exit 0/count 2/fake destination yes; baseline only-fake exit 0/count 1/destination yes. Current mixed exit 0/count 1/fake destination no; current only-fake exit 1/count 0/destination no. All four invocations were isolated; temporary fixtures cleaned up.

The correction confirms the bounded verdict: **operability narrowly improved** because non-skill directories are not copied or counted; **freshness unchanged**, since no live discovery/reload was performed.
