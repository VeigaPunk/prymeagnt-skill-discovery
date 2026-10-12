# 2026-10-12 — Probe: headless command/reload channel (operator-run)

Follow-up to r14 (disposable daemon ran; no trustworthy /reload receipt).
Operator probed the daemon APIs directly on a private daemon
(/tmp/probe-continuation, preflight PASS, receipts in r15-probe-raw/).

## Verified
1. `prime-agent send <agent> <text>` writes a daemon-side receipt: the
   session JSONL gains a custom_message/agent_message event with timestamp
   and sender id. (r14's missing receipt class EXISTS for operator intent.)
2. `prime-agent schedule add <agent> "in 1m" -- <text>` fires a REAL turn:
   the prompt lands as a proper user `message` event in the session JSONL.
   So daemon-injected turns are recorded trustworthily.

## Blockers (precise)
1. Scheduled/sent text arrives as a user MESSAGE, not an executed slash
   command: scheduled "/reload" produced no reload effect and no command
   event. There is no headless channel that executes slash commands.
2. Live turns need credentials: the isolated daemon initialized
   auth.json to `{}` (2 bytes) and model turns silently never complete
   (worker stderr shows no error). Same-session inventory observation is
   therefore impossible without operator credentials entering the scratch
   store — operator-owned, deliberately not done in this probe.

## Consequence for box 2
SHONEN box 2 (install -> /reload -> same-session discovery) remains
unchecked, now pinned to two substrate gaps rather than "no safe daemon":
(a) no headless slash-command channel; (b) isolated stores start
credential-empty and turns fail silently. Note: r14's "five setup events"
sessions were almost certainly never model-alive for the same reason.

## Substrate asks (operator-owned)
1. A command channel: e.g. `prime-agent send <agent> --slash /reload`, or
   schedule delivering slash commands as command events in the JSONL.
2. Fail loudly when a turn cannot obtain credentials (no silent zero-reply).
3. Optionally: a sanctioned credential-injection path for isolated stores.
