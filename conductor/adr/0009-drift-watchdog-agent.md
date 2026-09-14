# Drift watchdog — Orpheus ships a read-only background Agent

> **Recorded:** 2026-09-15 00:20
> **Status:** accepted

Orpheus's own pulse sat untouched from 2026-08-05 to 2026-09-15 and nothing said so: `/conductor` only reads, `/checkpoint` only runs when asked, and no part of the system watches the gap between them. We decided to close that gap in two complementary places. **Boot** gets a stale-pulse warning (`> **Updated:**` older than 14 days) in the `/conductor` template and both of its copies. **During the session**, Orpheus ships its first **Agent** — `agents/drift-watchdog.md`: Sonnet, `background: true`, read-only tools (Read, Grep, Glob, Bash), invoked proactively by the parent model after commits or feature work in any repo that carries `conductor/pulse.md`. It checks four drifts — stale pulse, code commits since the conductor was last touched, tracks registry vs. plan mismatch, hot-set cap breaches — and reports at most eight lines, only when something is actionable; otherwise exactly one no-op line. It never writes a file and obeys `conductor/agent-rules/behavioral.md` (so hands-off repos stay hands-off). The pattern is borrowed from Anthropic's Product Tracking plugin (`tracking-watchdog`): a cheap background monitor whose silence is a contract.

## Considered Options

- **A hook (`hooks.json`, Stop / PostToolUse) that greps the pulse date** — deterministic and free of model cost, but it ships shell to every consumer on every event, cannot judge whether a drift is real, and hooks were deliberately left empty in v3.x. Revisit if the Agent's token cost becomes a complaint.
- **Bake the checks into `/checkpoint`** — rejected: checkpoint is exactly the thing that does not fire when the human forgets. The failure mode needs a watcher that runs *without* being asked.
- **A scheduled task / cron outside the repo** — external to the plugin, not repo-bound, and invisible to consumers who install from the marketplace.
- **Boot warning only, no Agent** — catches the start of a session but not a long session that drifts while running. Kept as half of the answer.

## Consequences

- Plugin surface is now **Commands + Protocols + Agents**; `plugin.json` bumps to **3.2.0**. The glossary gains **Agent** (model-invoked, background, read-only) as distinct from **Command** (user-invoked, may write).
- Every consumer session pays the Agent's always-on description cost (~100–150 tokens) plus Sonnet spend per firing. A chatty watchdog is a bug: the ≤8-line, actionable-only report and the one-line no-op are part of the contract, not style.
- Proactive firing depends on the parent model choosing to invoke the Agent from its description — wording in the frontmatter is load-bearing and is the first thing to tune if it under- or over-fires.
- The Agent reads only the hot set plus `git log`; it never loads ADRs, `docs/`, or track plans beyond the `plan.md` files named in `tracks.md`.
- Thresholds (14 days, 3 commits, pulse > 72 lines, relay > 12 entries) are track-scoped decisions in `tracks/platform/drift_watchdog_20260915/plan.md`, not ADR-level — change them there.
