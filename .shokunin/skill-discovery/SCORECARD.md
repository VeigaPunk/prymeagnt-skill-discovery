# skill-discovery scorecard — probation baseline

Owned axes: operability, freshness. Scores are not assigned without a measured craft round.

| axis | score | evidence / counting command | last change |
|---|---|---|---|
| operability | improved (L1 verdict requested) | Round 4 `.shokunin/skill-discovery/corpus/probes/isolated-lifecycle.sh` passed: disposable install + frontmatter checks + fresh inventory resolved the scratch project target. R7 also closes a root-store false pass in the daemon preflight: `/` was accepted as private store before and is now refused; before/after fake-path fixtures in R7 report. | round 7 |
| freshness | unchanged (L1 verdict requested) | R5 separate fresh `prime-agent prompt --cwd <scratch>` processes discovered private project-local skill pre/post edit; explicitly not daemon reload. R5 report and `corpus/probes/fresh-process-inventory.sh`. | round 5 |

planned: none; safe isolated daemon lifecycle/API unavailable; reload remains unverified and SHONEN box 2 unchecked.
retired: none.


## L1 appendix — R7 closure (2026-10-12T02:01:56Z)

Supersedes the proposed L1-requested wording above for round 7 only. Independent reviewer `skill-r7-review` at `80b6ce4` admits **operability improved; freshness unchanged**. Operability evidence is the root-store (`/`) preflight false-pass correction, independently reviewed; it does not establish daemon isolation. Freshness has no new evidence. No daemon/session/reload was run; the end-to-end SHONEN claim remains unmade and box 2 remains unchecked.


## L1 appendix — R9 closure (2026-10-12)

R9: **operability narrowly improved; freshness unchanged**. Actual baseline and current installers were exercised with identical private fake+valid and only-fake fixtures using `corpus/probes/r9-installer-skillmd.sh <installer-path>`. Baseline mixed exit 0/count 2 and only-fake exit 0/count 1; current mixed exit 0/count 1 and only-fake exit 1/count 0. This demonstrates source-format filtering only, not process discovery or reload. Report: `.shokunin/reports/round-9/skill-discovery.md`.

## R11 lane observation — 2026-10-12 (awaiting L1 verdict)

Operability **improved narrowly**: direct source directory link now skipped before target creation. Baseline/current mixed install 0/2 → 0/1 and only-link 0/1 → 1/0; fresh-process inventory excludes outside-skill and preserves ordinary. Freshness **unchanged**: fresh CLI processes only; no daemon/reload. See `.shokunin/reports/round-11/skill-discovery.md` and private R11 probe; R9/R10 controls passed.

## R12 lane observation — 2026-10-12 (awaiting L1 verdict)

Operability **improved narrowly** at destination-entry symlink guard: actual baseline/current mixed exit/count 0/2 → 1/1, linked-only 0/1 → 1/0, ordinary-only 0/1 → 0/1. Outside write yes → no, existing outside sentinel unchanged. Freshness **unchanged**: fresh CLI inventory only, no daemon/reload. See `.shokunin/reports/round-12/skill-discovery.md` and private R12 probe; R9/R10/R11 controls passed.

## R13 lane observation — 2026-10-12 (awaiting L1 verdict)

Operability **improved narrowly**: actual `b929d86` private direct/linked installer exit/count 0/3 and 1/0 → current 0/3 and 0/3; explicit private override 0/1 → 0/1. Fresh CLI inventory tied to the private target has all three ordinary skills in the current linked and direct cases (baseline linked had none); override has only the override skill. Freshness **unchanged**: no existing daemon/session reload. Counting command: `corpus/probes/r13-script-link.sh <absolute-installer-path>`, baseline extracted with `git show b929d86:scripts/install-skills.sh`; R9–R12 controls passed. Score not raised pending L1 decision; no daemon/shared/provider/atomicity or portability claim beyond GNU realpath.
