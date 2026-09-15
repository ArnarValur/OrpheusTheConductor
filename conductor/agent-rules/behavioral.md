# Behavioral Rules

> How the human wants agents to work in this repo and its consumers.
> Graduated at checkpoints — behavioral rules land here only with explicit approval.

- **DittoDatto's keys are intentional.** The keys under `conductor/docs/keys/` (and local `.env`) in DittoDatto are there on purpose — never flag them as a hazard, scrub them, or alarm about them. ADR 0005's `.gitignore` keeping them local (never committed) IS the handling. _(graduated 2026-08-05 from pulse history, approved)_
- **Never regenerate into DittoDatto.** It was migrated to the v3.1 shape by hand (2026-08-05, full audit). Tooling and templates generalize FROM it; nothing writes INTO it. _(graduated 2026-08-05, approved in-session)_
- **Never copy or sync a conductor into a vault.** Obsidian opens each conductor through one symlink, `~/Documents/Project-Vaults/<Project>` → `conductor/`, with Claude's auto-memory symlinked inside as `conductor/memory` (gitignored); the summer-2026 Pollux copy-and-sync approach is retired for good. `conductor/` stays the canonical folder name. _(graduated 2026-09-15, approved in-session)_
- **Never hand-wire consumers.** Any change to the conducting system (vault wiring, commands, state shape, agents) lands in Orpheus itself — `/conductor-init`, its templates, or the plugin Skills — and reaches projects through the plugin update plus a `/conductor-init` re-run. Touching consumer projects one by one is forbidden, even when it looks faster. _(graduated 2026-09-15, stated by Arnar in-session)_
