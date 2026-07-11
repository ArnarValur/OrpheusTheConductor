# DittoDatto Pilot — Supervised Migration Runbook

> Track: `v3_port_20260711` · Phase 4 acceptance test.
>
> **⏸️ NOT auto-executed.** Deferred on purpose: DittoDatto is a *separate live repo* outside this port worktree, and its acceptance needs interactive `/conductor` verification. Run this **together, supervised.** This runbook drives [`protocols/migrate.md`](../../../protocols/migrate.md).

## Precondition

- Orpheus v3.0 plugin installed / available (Phase 3 verified live): `claude --plugin-dir <orpheus-repo>` or a marketplace install. Confirm `/orpheus:conductor` resolves.

## Steps

1. **Locate** the DittoDatto repo on PlutoII (and/or Saturn). Confirm the path before touching anything.
2. **Safety:** clean working tree; branch it — `git switch -c migrate/orpheus-v3`. Record the current SHA for rollback.
3. **Keep local keys local (ADR 0005).** DittoDatto intentionally keeps local keys under `conductor/docs/keys/` (and a local `.env`) — they are *meant to be there* and are left completely untouched. Just ensure `conductor/.gitignore` (`docs/keys/`, `*.env`, `.obsidian/`) is present so they stay local and never travel with the repo. Do not move, scrub, or flag them.
4. **Run `migrate.md` §3:** retire `.agents/workflows/` (+ any redundant root `workflows/`); confirm the plugin resolves the Commands; run index-sync.
5. **Preserve check:** diff `conductor/` content — `pulse` / `relay` / `tracks` / `adr` / `context` / `prd` / `project-context` must be **byte-unchanged** (ADR 0003).
6. **Verify acceptance:** run `/conductor` inside DittoDatto → resume works on the plugin; `.agents/workflows/` is gone; secrets are gitignored.
7. **Flag manual drift — do NOT auto-fix** (migrate.md §4): DittoDatto's dual/divergent sub-PRDs, forked ADR numbering, and silently-missing ADR 0014. Note these for a separate cleanup pass.
8. **Commit:** `migrate: v2.x → Orpheus v3.0 (retire deploy copies, add secrets gitignore)`.

## After the pilot

- If clean, the ~9 remaining v2.x projects (AgentPollus, Charon, Unixplor, …) migrate the same way — **out of this track's scope**, tracked separately.
