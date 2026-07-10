# Product Requirements — Orpheus

> Living PRD. Created by `/grill` on 2026-07-11. Updated surgically — no rewrites.

## Overview

Orpheus (formerly TheOracle) is the spec-driven development orchestrator for Merkurial-studio. It is a conductor, not a copilot: it doesn't write code, it orchestrates the workflow around the code — spec, plan, implement, review, checkpoint — through per-project `conductor/` state managed by five Commands. v3.0 re-platforms Orpheus from the Google Antigravity 2.0 plugin system to the Claude ecosystem (Claude Code + Cowork).

## In Scope (v3.0)

- **Rename sweep:** TheOracle → Orpheus across all ~20 referencing files — `plugin.json`, README, source headers (`# Source: Orpheus v3.0 @ <date>`), templates, project context, glossary.
- **Plugin packaging:** Orpheus ships as a Claude Code plugin (Commands + skills bundled); one install serves all projects in Claude Code CLI and Cowork. `protocols/` travel inside the plugin — the inlining constraint is retired.
- **Primitive port:** Antigravity `ask_question` tool → Claude `AskUserQuestion`; `.agents/workflows/` deploy target retired.
- **Migration:** ~10 live v2.x projects (DittoDatto, AgentPollus, Charon, Unixplor, …) migrate via the `/conductor-init` brownfield re-init path — preserve `conductor/` state untouched, retire `.agents/workflows/` copies.

## Out of Scope

- Changes to `conductor/` state formats — pulse, relay, tracks, ADR formats are unchanged in v3.0.
- New Commands beyond the existing five.
- Runtime dependencies — Orpheus stays pure markdown + shell.

## Open Questions

- Plugin distribution mechanics: local marketplace vs git-sourced install.
- Whether protocols become plugin-referenced files or stay inlined for robustness in restricted contexts.
- Per-project Command overrides (hybrid model) — not in v3.0; revisit if a project needs divergent behavior.
