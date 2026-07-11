# Product Requirements — Orpheus

> Living PRD. Created by `/grill` on 2026-07-11. Updated surgically — no rewrites.

## Overview

Orpheus (formerly TheOracle) is the spec-driven development orchestrator for Merkurial-studio. It is a conductor, not a copilot: it doesn't write code, it orchestrates the workflow around the code — spec, plan, implement, review, checkpoint — through per-project `conductor/` state managed by five Commands. v3.0 re-platforms Orpheus from the Google Antigravity 2.0 plugin system to the Claude ecosystem (Claude Code + Cowork).

## In Scope (v3.0)

- **Rename sweep:** TheOracle → Orpheus across all ~20 referencing files — `plugin.json`, README, source headers (`# Source: Orpheus v3.0 @ <date>`), templates, project context, glossary.
- **Plugin packaging:** Orpheus ships as a Claude Code plugin (Commands + skills bundled); one install serves all projects in Claude Code CLI and Cowork. `protocols/` travel inside the plugin — the inlining constraint is retired.
- **Primitive port:** Antigravity `ask_question` tool → Claude `AskUserQuestion`; `.agents/workflows/` deploy target retired.
- **Migration:** ~10 live v2.x projects (DittoDatto, AgentPollus, Charon, Unixplor, …) migrate via the `/conductor-init` brownfield re-init path — preserve `conductor/` state untouched, retire `.agents/workflows/` copies. Migration logic ships as `protocols/migrate.md` inside the plugin; `/conductor` resume signposts it when v2.x remnants are detected (ADR 0004).

## Out of Scope

- Changes to `conductor/` state formats — pulse, relay, tracks, ADR formats are unchanged in v3.0.
- New Commands beyond the existing five.
- Runtime dependencies — Orpheus stays pure markdown + shell.

## Deferred to v3.1 — Hardening

> Not in the v3.0 re-platform. Captured here from pulse Session Memory (DittoDatto token measurement, 2026-07-11) so the scope line is explicit: **v3.0 ships the port; v3.1 tunes it.** Rationale: token/state guardrails only matter once the plugin ships and runs at scale.

- **Relay guardrail** — `relay.md` grows unbounded (measured 22K tokens / 66 entries; regrew 12 days after a manual archive). Add an archiving guardrail + tail-read in `/conductor` resume.
- **Size-based pulse guardrail** — current guardrail is line-based (14K tokens at 188/200 lines; lines ≠ tokens). Bound by size/tokens instead.
- **ADR lazy-index** — all ADRs eager-load at resume (measured 42 ADRs ≈ 15K tokens). Add a summary index with lazy load.
- **Tracks collapse** — completed tracks bloat `tracks.md`; collapse or archive them.
- **Contract + secrets lint** — ship `scripts/lint.sh` to validate reader/writer frontmatter contracts and scan for secrets.
- **Golden-session evals** — regression-test Commands via headless `claude -p` runs.
- **Parallel-session advisory marker** — advisory lock so concurrent sessions don't clobber Conductor state.
- **Track-status authority** — make `metadata.json` the single source of truth for track status, with extended defensive reconcile in `/conductor`.

## Open Questions

- Plugin distribution mechanics: local marketplace vs git-sourced install.
- Whether protocols become plugin-referenced files or stay inlined for robustness in restricted contexts.
- Per-project Command overrides (hybrid model) — not in v3.0; revisit if a project needs divergent behavior.

## Update — 2026-07-11 02:18

- Drew the v3.0 scope line: **v3.0 is the re-platform only** (rename / package / port / migrate). Added the **Deferred to v3.1 — Hardening** section, moving the DittoDatto improvement backlog out of volatile pulse Session Memory into the living PRD.
- Deferred (not recorded): Light-vs-Strict self-host workflow mode — `workflow.md` still carries the Strict/TDD template, which has no coverage surface for a pure-markdown product. To be resolved inside the v3.0 port track (rename sweep) or a future grill/ADR.
