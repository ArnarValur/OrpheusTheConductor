# DittoDatto Pilot — Supervised Migration Runbook

> Track: `v3_port_20260711` · Phase 4 acceptance test.
>
> **⏸️ NOT auto-executed.** Deferred on purpose: DittoDatto is a *separate live repo carrying real secrets* (ADR 0005), it lives outside this port worktree, and its acceptance needs interactive `/conductor` verification. Run this **together, supervised.** This runbook drives [`protocols/migrate.md`](../../../protocols/migrate.md).

## Precondition

- Orpheus v3.0 plugin installed / available (Phase 3 verified live): `claude --plugin-dir <orpheus-repo>` or a marketplace install. Confirm `/orpheus:conductor` resolves.

## Steps

1. **Locate** the DittoDatto repo on PlutoII (and/or Saturn). Confirm the path before touching anything.
2. **Safety:** clean working tree; branch it — `git switch -c migrate/orpheus-v3`. Record the current SHA for rollback.
3. **Secrets first (ADR 0005).** DittoDatto was observed carrying a live `.env` and a service-account key under `conductor/docs/keys/`. BEFORE anything else, add `conductor/.gitignore` (`docs/keys/`, `*.env`, `.obsidian/`). **If those secrets are already committed in git history, STOP** — decide on a history scrub separately; `migrate.md` does not rewrite history.
4. **Run `migrate.md` §3:** retire `.agents/workflows/` (+ any redundant root `workflows/`); confirm the plugin resolves the Commands; run index-sync.
5. **Preserve check:** diff `conductor/` content — `pulse` / `relay` / `tracks` / `adr` / `context` / `prd` / `project-context` must be **byte-unchanged** (ADR 0003).
6. **Verify acceptance:** run `/conductor` inside DittoDatto → resume works on the plugin; `.agents/workflows/` is gone; secrets are gitignored.
7. **Flag manual drift — do NOT auto-fix** (migrate.md §4): DittoDatto's dual/divergent sub-PRDs, forked ADR numbering, and silently-missing ADR 0014. Note these for a separate cleanup pass.
8. **Commit:** `migrate: v2.x → Orpheus v3.0 (retire deploy copies, add secrets gitignore)`.

## After the pilot

- If clean, the ~9 remaining v2.x projects (AgentPollus, Charon, Unixplor, …) migrate the same way — **out of this track's scope**, tracked separately.
