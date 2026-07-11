# Spec — Orpheus v3.0 Port

> Track: `v3_port_20260711` · Domain: **platform** 🔴 · Type: **feature**
> Created: 2026-07-11

## Overview

Re-platform Orpheus (formerly TheOracle, ≤ v2.1) from the Google Antigravity 2.0 plugin system to the Claude ecosystem (Claude Code CLI + Cowork). Orpheus ships as a single installable Claude Code plugin bundling the five Commands, skills, and Protocols — ending the per-project fan-out deployment that on 2026-06-18 required 21 file updates across 10 projects (ADR 0002).

Scope is the **re-platform only**. Token/state hardening (relay guardrail, size-based pulse, ADR lazy-index, tracks-collapse, lint script, evals, session marker, metadata authority) is deferred to **v3.1** per the PRD "Deferred to v3.1 — Hardening" section.

## Functional Requirements

| # | Requirement | Anchor |
|---|-------------|--------|
| F1 | **Rename sweep** — TheOracle → Orpheus across ~20 forward-facing files: `plugin.json`, README, source headers (`# Source: Orpheus v3.0 @ <date>`), templates, `project-context.md`, glossary references. | PRD |
| F2 | **Primitive port** — Antigravity `ask_question` → Claude `AskUserQuestion` in all five Commands; retire the `.agents/workflows/` deploy target. | PRD |
| F3 | **Plugin packaging** — bundle Commands + skills + Protocols as a Claude Code plugin (`plugin.json` manifest + `marketplace.json`); one install serves CLI + Cowork. Protocols ship **un-inlined** inside the plugin. | ADR 0002, ADR 0004 |
| F4 | **Self-host workflow mode** — rewrite `workflow.md` from Strict/TDD → **Light** (flexible iteration). Recorded as ADR 0006. | grill 2026-07-11 |
| F5 | **Migration protocol** — author `protocols/migrate.md` (detect v2.x · preserve `conductor/` untouched · retire `.agents/workflows/` copies · confirm plugin availability); invoked by `/conductor-init`, signposted by `/conductor` when v2.x remnants are detected. | ADR 0003, ADR 0004 |
| F6 | **Pilot migration** — migrate **DittoDatto** as the acceptance test. | this track |

## Non-Functional Requirements

- **No runtime dependencies** — Orpheus stays pure markdown + shell (PRD out-of-scope guard).
- **No `conductor/` state-format changes** — pulse / relay / tracks / ADR formats unchanged (PRD out-of-scope).
- **Secrets never travel** — `/conductor-init` ships `conductor/.gitignore` covering `docs/keys/`, `*.env`, `.obsidian/` (ADR 0005); verified during the DittoDatto pilot.
- **Backward compatibility** — preserve the v2.0 → v2.1 re-init precedent; migration is idempotent / re-runnable.

## Acceptance Criteria

- ✅ All five Commands register and run as **native slash commands in Claude Code CLI *and* Cowork**, using `AskUserQuestion`.
- ✅ `grep -ri theoracle` is clean except intentional legacy/AKA mentions (glossary "TheOracle (legacy)", historical ADR/relay entries).
- ✅ A single plugin install lets a fresh project run `/conductor-init → /conductor → /grill → /new-track → /checkpoint` end-to-end.
- ✅ `workflow.md` is Light mode; no TDD / coverage gates remain.
- ✅ DittoDatto migrates cleanly: `conductor/` state intact, `.agents/workflows/` retired, secrets gitignored, `/conductor` resume works on the plugin.

## Edge Cases & Constraints

- **Restricted contexts** (headless / cron, no interactive auth or MCP) — Protocols must still function; being plugin-bundled (not inlined) keeps them available.
- **`AskUserQuestion` affordances** differ from `ask_question`: max 4 questions/modal, 2–4 options each, an "Other" write-in is always present. Ported prompts must fit these limits.
- **Forked v2.x state** — DittoDatto carries dual diverging sub-PRDs, forked ADR numbering, and a silently-missing ADR 0014. `migrate.md` **preserves as-is** and does NOT auto-fix (those are v3.1 / manual concerns).
- **Preserve history** — the rename must not rewrite legitimate historical "TheOracle" mentions in ADRs and relay entries; only forward-facing surfaces are renamed.
- **Command-name collisions** — guard against clashes with other installed Claude Code plugins.
- **`project-context.md` is user-owned** — the sweep touches its stale `v2.1` / "Antigravity" text, but changes are confirmed with the user rather than silently rewritten.

## Dependencies

- **None blocking** — this is the foundational track.
- **Downstream:** all v3.1 hardening tracks depend on this shipping first.
- **External:** the Claude Code plugin system (`plugin.json` / `marketplace.json` manifest schema).

## Out of Scope

- v3.1 hardening (see PRD "Deferred to v3.1").
- New Commands beyond the existing five.
- Migrating the other ~9 live v2.x projects (only the DittoDatto pilot here).
- Per-project Command overrides (hybrid model).
- Any `conductor/` state-format changes.
