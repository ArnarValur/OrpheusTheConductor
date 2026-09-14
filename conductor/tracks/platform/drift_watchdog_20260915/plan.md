# Plan — Drift Watchdog

> Track: `drift_watchdog_20260915` · Domain: **platform** 🔴 · Type: **feature** · Status: **active** · Created: 2026-09-15
> Mode: **Light** — plan → execute → verify; four short phases.

---

## Phase 1 — Design ✅

- [x] Task: Record the decision — ADR 0009 (Agent + boot warning; hooks rejected)
- [x] Task: Write `spec.md` (F1–F5, acceptance, out of scope)
- [x] Task: Glossary — add **Agent** to `context.md` (entity, relationship, boundary vs Command)

## Phase 2 — Boot warning ✅

- [x] Task: Add the stale-pulse bullet to `templates/commands/conductor.md` Step 4
- [x] Task: Sync `commands/conductor.md` (plugin copy) and `.claude/commands/conductor.md` (self-host copy)
- [x] ✅ Verify: `diff` of the three files shows only the documented divergences

## Phase 3 — Agent ✅

- [x] Task: Author `agents/drift-watchdog.md` (frontmatter + four checks + report contract + rules)
- [x] Task: Bump `plugin.json` / `marketplace.json` → 3.2.0; mention the Agent in both descriptions
- [x] Task: README — title → v3.2, add "The Agent" section, update Status
- [x] ✅ Verify: `claude plugin validate .` passes

## Phase 4 — Verify

- [x] Task: Fresh install in an isolated `HOME` from the local path → `claude plugin details orpheus` lists Agents (1)
- [x] Task: Live run before checkpoint — real repo: stale pulse (41 d) only; fixture clone with 3 code-only commits: stale pulse + 3-commit drift (Sonnet, 2026-09-15)
- [ ] Task: Live run after checkpoint → no-op line
- [ ] Task: Conductor — User Manual Verification 'Verify' (Protocol in workflow.md)

---

## Decisions

- **D1** — Stale threshold is **14 days**: long enough to skip a normal fortnight gap, short enough to catch the six-week silence that motivated this track.
- **D2** — Commit drift threshold is **3 commits** outside `conductor/` since the last conductor touch; one or two is a normal task cadence.
- **D3** — "Silence" is a one-line no-op (`drift-watchdog: nothing to report.`), because a subagent's final message always returns to the parent — an empty reply reads as a failure.
- **D4** — Cap checks use `pulse.md` > 72 lines (60-line cap + 20 % grace) and `relay.md` > 12 entries (the checkpoint guardrail's own trigger).
- **D5** — Thresholds live here, not in the ADR; change them by editing this plan and the Agent file together.
