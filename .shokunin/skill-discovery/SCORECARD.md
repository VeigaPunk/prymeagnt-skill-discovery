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
