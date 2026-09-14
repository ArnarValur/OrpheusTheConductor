# Pulse — Orpheus

> **Updated:** 2026-09-15 00:20 by checkpoint
> State only, cap ~60 lines. Rewritten from scratch at every checkpoint —
> if you are appending to this file, you are doing it wrong.

## 📍 Now — what runs where

- Repo on `main`; v3.2 committed locally (track c291d3c · boot warning 7454766 · Agent fe481a6 · this checkpoint). `origin/main` was 9355fb5 before this checkpoint's push.
- Plugin `orpheus` **3.2.0** in the working tree: 5 Skills + 1 Agent (`drift-watchdog`); `claude plugin validate .` clean; isolated-`HOME` install from the local path lists Agents (1).
- User-scope install still **3.1.0** — refresh pending: `claude plugin marketplace update merkurial-studio` → `claude plugin update orpheus`.
- **Live**: github.com/ArnarValur/OrpheusTheConductor — fresh-consumer install verified 2026-09-15 from an isolated `HOME` (clone → install → 5 Skills at 3.1.0).
- Merged worktree `magical-spence-348695` + its branch retired; `git worktree list` = main only.
- This repo's auto-memory is symlinked into the Obsidian vault: `~/Documents/Claude Memory/Orpheus`.

## 🚀 Active tracks

- 🟢 **drift_watchdog_20260915** — P1–P3 done; P4 left: post-checkpoint watchdog run + user manual verification → tracks/platform/drift_watchdog_20260915/plan.md
- 🟡 **v3_port_20260711** — P1–P4 complete + live-verified; consumer rollout remains → tracks/platform/v3_port_20260711/plan.md

## ⚠️ Blockers

- None.

## 📋 Next queue

1. Post-checkpoint watchdog run on this repo (expect the no-op line) → tick P4; refresh the user-scope install to 3.2.0.
2. Arnar: manual verification of P4 — boot `/conductor` on a repo with a stale pulse (expect the ⚠️ line); watch `drift-watchdog` fire on its own in a real session. Tune its description if it under/over-fires (ADR 0009).
3. Roll out v3.2 to consumers via `/conductor-init` (AgentPollus, Charon, Unixplor, …) — emitted `conductor.md` gains the stale warning. DittoDatto stays hands-off (agent-rules/behavioral.md).
4. Launch writeup — the 78K-token → ~340-line story (r/ClaudeAI / dev.to); the repo gets no eyes without it.
5. Next `/grill`: glossary rows **Pulse**, **Index**, **Track**, **Checkpoint** still describe the v3.0 shape (Session Memory, dynamic index, `metadata.json`, decision sweep) — reword to ADR 0008.

## 📌 Parked

- v3.1 Hardening backlog → conductor/prd.md ("Deferred to v3.1 — Hardening").
- Hook-based drift check (deterministic, no model cost) → ADR 0009 "Considered Options"; revisit if the Agent's cost draws complaints.
