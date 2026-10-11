# Skill discovery R5 — freshness axis probe

Date: 2026-10-11
Branch: `craft/skill-discovery-r5`
Agent identity: `skill-discovery-shonen <skill-discovery@shokunin.local>` (author and committer)

## Axis and decision

**Freshness** was the sole axis move. A safe daemon-backed fresh-session/`/reload` lifecycle was not available without using the shared live daemon/TUI. The supported CLI documents `prime-agent shutdown` as stopping *every* agent and background service; `prime-agent status` showed no background services at probe start, but `prime-agent list` showed many existing sessions and process inspection showed daemon PID 3336 plus workers. So stop/shutdown was not safe. No supported daemon socket isolation/start API was found in CLI help (`prime-agent --help`, `help status`, `help attach`, `help doctor`, `help shutdown`). We did not start a session, send `/reload`, signal processes, or edit settings/shared skill paths.

Fallback probe was run as explicitly **not daemon reload**: two separate fresh `prime-agent prompt --cwd <private scratch>` processes discovered inventory before and after creation of a disposable skill under the scratch project's private `.prime/agent/skills`. Probe: `.shokunin/skill-discovery/corpus/probes/fresh-process-inventory.sh`. Exit 0. Before inventory SHA-256 `42b8d2712e7a3a98d38b4b80608d28a4225394505f528e06607dc396131675bb`, probe absent (process PID 25867). After file SHA-256 `6dcfbe91a812d409c1e0e84464ee8a51d35d9859abdb779a8e09cb04c1c91cd8`; after inventory SHA-256 `26fa1112f9a1bc11e2a3ca41964a74736ef898d60891e79cec3ed313652e775d` (process PID 25877), discovered name/type/description/location under `/tmp/skill-discovery-r5.tfuIea/.prime/agent/skills/...`. Both invocation receipts reported shell PID 25722; each `prime-agent prompt` was a separate CLI process. Script's EXIT trap removed scratch. This measures fresh-process inventory discovery only; it does **not** measure existing-process cache invalidation, daemon-session behavior, or `/reload`.

Reproduce from repo root:

```sh
bash .shokunin/skill-discovery/corpus/probes/fresh-process-inventory.sh
```

No model inference was called; no OpenAI Sol/Luna model routing was involved; no 402 route was touched.

## Axis verdict

- **Freshness: unchanged** — new-process inventory picks up a newly added project-local skill, but no evidence for `/reload` or an extant daemon session. Do not overclaim freshness/reload.
- **Operability: unchanged** — R4 private installer pass preserved; this round adds an isolated inventory probe but no changes to install/operability procedure.
- **SHONEN box 2: unchecked** — end-to-end domain task in the relevant daemon reload sense remains unverified. This fallback is not a substitute for daemon reload.

## Safety and limits

The CLI can create interactive sessions (`prime-agent "..."` per docs), but those use the shared daemon; isolation of its daemon-backed session lifecycle is not documented. The session's required private session-dir option does not establish a private daemon/socket. Hence safe choice was to refrain, not simulate. Existing shared daemon sessions and workers were observed but not modified. No MANIFEST, global harness, source skill, shared install, settings, or push touched.


## Conformance recheck

After moving this report to the round report path, reran `bash .shokunin/skill-discovery/corpus/probes/fresh-process-inventory.sh`: exit 0, fresh process PIDs 26082 (before) and 26092 (after), before inventory SHA-256 `dd8c838a442450af7f8c133dede70d67b70ea1fbb1454730d35f06443aa03eac`, after inventory SHA-256 `9ce31488a5e162a690ca039e89d5850930d15a6d79bb1ee3c37148bd43889c9e`. New skill absent pre-edit, discovered post-edit at private scratch location; temporary directory cleaned. Still only fresh-process discovery, not reload.
