# Behavioral Rules

> How the human wants agents to work in this repo and its consumers.
> Graduated at checkpoints — behavioral rules land here only with explicit approval.

- **DittoDatto's keys are intentional.** The keys under `conductor/docs/keys/` (and local `.env`) in DittoDatto are there on purpose — never flag them as a hazard, scrub them, or alarm about them. ADR 0005's `.gitignore` keeping them local (never committed) IS the handling. _(graduated 2026-08-05 from pulse history, approved)_
- **Never regenerate into DittoDatto.** It was migrated to the v3.1 shape by hand (2026-08-05, full audit). Tooling and templates generalize FROM it; nothing writes INTO it. _(graduated 2026-08-05, approved in-session)_
