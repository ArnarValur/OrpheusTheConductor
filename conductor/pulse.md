# Pulse — Orpheus

> **Updated:** 2026-09-15 08:51 by checkpoint
> State only, cap ~60 lines. Rewritten from scratch at every checkpoint —
> if you are appending to this file, you are doing it wrong.

## 📍 Now — what runs where

- Repo on `main`; v3.2.0 on `origin/main` (checkpoint eb4cc2b + pulse touch 002cf3b). Working tree clean before this checkpoint.
- Plugin `orpheus` **3.2.0** in the working tree: 5 Skills + 1 Agent (`drift-watchdog`, name kept — self-describing for public consumers).
- User-scope install **3.2.0** (`~/.claude/plugins/cache/merkurial-studio/orpheus/3.2.0`, refreshed 2026-09-15). New sessions get the Agent.
- **Live**: github.com/ArnarValur/OrpheusTheConductor — fresh-consumer install verified 2026-09-15.
- `git worktree list` = main only.
- **Obsidian**: every conductor is opened through a symlink wrapper at `~/Documents/Project-Vaults/<Project>/{conductor,memory}` (10 projects wired 2026-09-15). `conductor/` stays the canonical folder name — no `<project>-conductor/` rename. This repo's auto-memory: `Project-Vaults/Orpheus/memory`.
- **Pollux retired** (2026-09-15): its systemd watchers, state, and cache are gone; generated vault copies archived at `~/Documents/Archives/pollux-vaults/`; source sleeps at `~/Hermes/AgentPollux`. Hermes stack asleep too (`hermes-webui` + CaptainsVault mount removed, gateway service removed).
- Hot set at boot: 427 lines (budget 400) — `workflow.md` is 226 of them.

## 🚀 Active tracks

- 🟢 **drift_watchdog_20260915** — P1–P3 done; P4: post-checkpoint run passed (no-op); Arnar's manual verification left → tracks/platform/drift_watchdog_20260915/plan.md
- 🟡 **v3_port_20260711** — P1–P4 complete + live-verified; consumer rollout remains → tracks/platform/v3_port_20260711/plan.md

## ⚠️ Blockers

- None.

## 📋 Next queue

1. Arnar: manual verification of P4 — boot `/conductor` on a repo with a stale pulse (expect the ⚠️ line); watch `drift-watchdog` fire on its own in a real session. Tune its description if it under/over-fires (ADR 0009).
2. Roll out v3.2 to consumers via `/conductor-init` (Charon, Unixplor, MyReciBook, ZeroGravity, …) — emitted `conductor.md` gains the stale warning. DittoDatto stays hands-off (agent-rules/behavioral.md).
3. Trim `workflow.md` (226 lines) so the hot set lands inside the 400-line budget.
4. Launch writeup — the 78K-token → ~340-line story (r/ClaudeAI / dev.to); the repo gets no eyes without it.
5. Next `/grill`: glossary rows **Pulse**, **Index**, **Track**, **Checkpoint** still describe the v3.0 shape (Session Memory, dynamic index, `metadata.json`, decision sweep) — reword to ADR 0008.

## 📌 Parked

- v3.1 Hardening backlog → conductor/prd.md ("Deferred to v3.1 — Hardening").
- Hook-based drift check (deterministic, no model cost) → ADR 0009 "Considered Options"; revisit if the Agent's cost draws complaints.
- Agent rename `drift-watchdog` → `pollux` — declined 2026-09-15 (codename hides what it does); track plan D6.
