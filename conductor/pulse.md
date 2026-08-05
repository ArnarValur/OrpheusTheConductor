# Pulse — Orpheus

> **Updated:** 2026-08-05 by checkpoint (v3.1 shape migration)
> State only, cap ~60 lines. Rewritten from scratch at every checkpoint —
> if you are appending to this file, you are doing it wrong.

## 📍 Now — what runs where

- Repo on `main`; v3.1 rebuild committed (story: relay 2026-08-05; decision: ADR 0008).
- Plugin `orpheus` v3.1.0, installed user-scope from this repo (registers the five Commands).
- **Live**: github.com/ArnarValur/OrpheusTheConductor — `origin/main` = local `main` (00a9c70), MIT, full history.
- Merged worktree `magical-spence-348695` still attached under `.claude/worktrees/` (safe to remove from `main`).

## 🚀 Active tracks

- 🟡 **v3_port_20260711** — platform: P1–P4 complete + live-verified; consumer rollout remains → tracks/platform/v3_port_20260711/plan.md

## ⚠️ Blockers

- None.

## 📋 Next queue

1. Verify `/plugin marketplace add ArnarValur/OrpheusTheConductor` installs on a consumer machine.
2. Launch writeup — the 78K-token → ~340-line story (r/ClaudeAI / dev.to); the repo gets no eyes without it.
3. Retire the merged worktree: `git worktree remove` from `main`.
4. Roll out the v3.1 upgrade to consumers (AgentPollus, Charon, Unixplor, …) via `/conductor-init` — DittoDatto is already migrated by hand; hands off (see agent-rules/behavioral.md).

## 📌 Parked

- v3.1 Hardening backlog → conductor/prd.md ("Deferred to v3.1 — Hardening").
