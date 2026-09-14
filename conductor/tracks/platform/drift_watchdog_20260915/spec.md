# Spec — Drift Watchdog

> Track: `drift_watchdog_20260915` · Domain: **platform** 🔴 · Type: **feature**
> Created: 2026-09-15

## Overview

The conductor cannot notice its own staleness. Boot (`/conductor`) is a read ceremony; `/checkpoint` runs only when asked; nothing watches the gap. On Orpheus itself the pulse went 41 days without a rewrite (2026-08-05 → 2026-09-15) while the next queue silently aged. This track closes the gap in two places: a **stale-pulse warning at boot**, and a **read-only background Agent** (`drift-watchdog`) that fires during a session and speaks only when there is something to fix. Decision: ADR 0009.

## Functional Requirements

| # | Requirement | Anchor |
|---|-------------|--------|
| F1 | **Boot warning** — `/conductor` Step 4 emits one warning line when the `> **Updated:**` date in `pulse.md` is more than 14 days before today. Lands in `templates/commands/conductor.md` and both copies (`commands/`, `.claude/commands/`), preserving the documented divergence contract. | ADR 0008 |
| F2 | **Agent packaging** — `agents/drift-watchdog.md` at the plugin root: `model: sonnet`, `background: true`, tools limited to Read, Grep, Glob, Bash. `claude plugin details orpheus` lists **Agents (1)**. | ADR 0009 |
| F3 | **Four checks** — (a) pulse stale > 14 days; (b) ≥ 3 commits touching files outside `conductor/` since the last commit that touched `conductor/`; (c) registry ↔ plan mismatch: an Active one-liner in `tracks.md` whose `plan.md` is missing, or whose plan has no unchecked task left; (d) cap breach: `pulse.md` > 72 lines or `relay.md` > 12 entries. Old-shape pulse (`Session Memory` / `Recently Completed`) short-circuits to a single "upgrade" finding. | ADR 0008, ADR 0009 |
| F4 | **Report contract** — only when actionable; ≤ 8 lines; every finding names the file and the fix. Nothing actionable → exactly one line: `drift-watchdog: nothing to report.` | ADR 0009 |
| F5 | **Read-only + house rules** — the Agent never edits a file. It reads `conductor/agent-rules/behavioral.md` when present and obeys it (hands-off repos get no edit suggestions). | behavioral.md |

## Non-Functional Requirements

- **No runtime dependencies** — markdown + git + coreutils only (PRD out-of-scope guard).
- **Cheap** — always-on cost ≤ ~150 tokens; reads only the hot set, the `plan.md` files named in `tracks.md`, and `git log`. Never loads ADRs, `docs/`, or archives.
- **Silent off-target** — a repo without `conductor/pulse.md` gets the no-op line and nothing else.
- **Degrades quietly** — no remote, detached HEAD, shallow clone, or a pulse without an `Updated:` line must not crash the check; flag "unknown" once at most.

## Acceptance Criteria

- ✅ `claude plugin validate .` passes; a fresh install in an isolated `HOME` lists **Agents (1)**.
- ✅ The three `conductor.md` files differ only by the documented divergences (header comment; init pointer; old-shape bullet).
- ✅ Run against this repo **before** the session checkpoint, the Agent reports the stale pulse and the commits-since-conductor drift; run **after** it, the Agent returns the no-op line.
- ✅ Boot on a repo whose pulse is > 14 days old shows the stale warning.

## Edge Cases & Constraints

- Shallow clones truncate `git log` — count what is visible, never error.
- A pulse dated in the future (clock skew) → treat as fresh.
- `tracks.md` one-liners that point at a domain path but no `plan.md` yet → finding (c), phrased as "plan missing", not as an error.
- The Agent must never suggest regenerating or rewriting a conductor that `behavioral.md` marks hands-off (DittoDatto).

## Dependencies

- ADR 0008 (v3.1 shape — the file caps and the `Updated:` line the checks rely on).
- ADR 0009 (this track's decision).

## Out of Scope

- Hooks (`hooks.json` stays empty — see ADR 0009 options).
- Any write-back: auto-checkpoint, auto-moving tracks to Done, editing the pulse.
- Per-project thresholds or config files.
- Cowork verification of Agent registration (CLI only this track).
- Consumer rollout — remains the existing next-queue item (`/conductor-init` reinit per repo).
