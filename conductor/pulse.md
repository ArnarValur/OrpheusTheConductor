# Pulse — Orpheus

> **Updated:** 2026-09-15 12:57 by checkpoint
> State only, cap ~60 lines. Rewritten from scratch at every checkpoint —
> if you are appending to this file, you are doing it wrong.

## 📍 Now — what runs where

- Repo on `main` = `origin/main` (8c6a791 before this checkpoint). Working tree clean.
- Plugin `orpheus` **3.3.0** in the working tree: 5 Skills + 1 Agent (`drift-watchdog`). New in 3.3.0: `/conductor-init` Step 13b wires the Obsidian vault wrapper on fresh inits and in-place upgrades.
- User-scope install **3.3.0** — uninstall + install from the local marketplace 2026-09-15 12:5x; installed script dry-run against this repo produced the right two links. New sessions get it.
- **Live**: github.com/ArnarValur/OrpheusTheConductor — fresh-consumer install verified 2026-09-15 (3.2.0 era).
- `git worktree list` = main only.
- **Obsidian**: conductors open through `~/Documents/Project-Vaults/<Project>/{conductor,memory}` symlink wrappers. 10 projects were wired by hand this morning (before the never-hand-wire rule); from now on init does it. `conductor/` stays the canonical folder name.
- **Machine**: Pollux retired (watchers, state, cache gone; vault copies at `~/Documents/Archives/pollux-vaults/`); Hermes asleep (`hermes-webui` + CaptainsVault mount, gateway service removed); away-week cron and `~/.surrealdb` removed.
- Hot set at boot: 427 lines (budget 400) — `workflow.md` is 226 of them.

## 🚀 Active tracks

- 🟢 **drift_watchdog_20260915** — P1–P3 done; P4: post-checkpoint run passed (no-op); Arnar's manual verification left → tracks/platform/drift_watchdog_20260915/plan.md
- 🟡 **v3_port_20260711** — P1–P4 complete + live-verified; consumer rollout remains → tracks/platform/v3_port_20260711/plan.md

## ⚠️ Blockers

- None.

## 📋 Next queue

1. Arnar: re-run `/conductor-init` (fresh session, 3.3.0) on the project he just initialized — first real run of Step 13b.
2. Arnar: manual verification of P4 — boot `/conductor` on a repo with a stale pulse (expect the ⚠️ line); watch `drift-watchdog` fire on its own. Tune its description if it under/over-fires (ADR 0009).
3. Roll out v3.3 to consumers via `/conductor-init` (Charon, Unixplor, MyReciBook, ZeroGravity, …). DittoDatto stays hands-off (agent-rules/behavioral.md).
4. Trim `workflow.md` (226 lines) so the hot set lands inside the 400-line budget.
5. Launch writeup — the 78K-token → ~340-line story (r/ClaudeAI / dev.to).
6. Next `/grill`: glossary rows **Pulse**, **Index**, **Track**, **Checkpoint** still describe the v3.0 shape — reword to ADR 0008.

## 📌 Parked

- v3.1 Hardening backlog → conductor/prd.md ("Deferred to v3.1 — Hardening").
- Hook-based drift check (deterministic, no model cost) → ADR 0009 "Considered Options".
- Agent rename `drift-watchdog` → `pollux` — declined 2026-09-15 → track plan D6.
