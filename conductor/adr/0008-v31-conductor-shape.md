# v3.1 conductor shape — one fact one home, repo files bind

> **Recorded:** 2026-08-05
> **Status:** accepted

DittoDatto's conductor was rebuilt by hand on 2026-08-05 after a full audit exposed unbounded growth (relay without guardrails, pulse carrying history, eager ADR loads — ~78K-token hot sets). We decided to generalize that rebuilt shape as **Orpheus v3.1** and make `/conductor-init` emit it for every future repo: state-only pulse (~60-line cap, rewritten never appended), relay as the single session-story home (≤10-line entries; past 12, trim to newest 8 and archive), the two laws in workflow (one fact one home; a ruling binds only when it lands in a repo file), a static Hot/Warm/Cold index (reconcile ceremony retired), and self-contained `/conductor` + `/checkpoint` emitted into `.claude/commands/` whose halt messages point at git history, never at init. `metadata.json` is retired; lessons graduate to `agent-rules/` (technical auto, behavioral ask-first).

## Consequences

- Initialized repos boot (~300–400-line hot set) and checkpoint with **no plugin dependency**; the plugin adds `/conductor-init`, `/grill`, `/new-track` on top.
- Existing conductors upgrade via reinit as **preserve + checklist**: structure automatically, state by human judgment — never regenerated. DittoDatto itself is hands-off (migrated by hand; see `agent-rules/behavioral.md`).
- `templates/commands/` is the single source of truth; the plugin's command copies carry only their two documented divergences.

## Supersedes

Shape-level behavior of the v3.0 primitives: dynamic index + `index-sync` protocol, pulse Session Memory / Recently Completed, checkpoint decision sweep, and per-track `metadata.json`.
