# Conductor Index — Orpheus

> Static map of the conductor. Hot is read at every boot; Warm is loaded when
> work enters the domain; Cold only on explicit request. Lazy files appear as
> plain paths until created — turn them into links when they land.

## Hot — every boot

- [Pulse](./pulse.md) — live state, rewritten each checkpoint
- [Relay](./relay.md) — last entry only at boot
- [Tracks](./tracks.md) — one-liners only
- [Workflow](./workflow.md) — the two laws + task lifecycle
- [Behavioral rules](./agent-rules/behavioral.md)
- [Glossary](./context.md)

## Warm — when work enters the domain

- Track plans — `tracks/<track-id>/plan.md` (+ `spec.md` when present)
- [Decisions](./adr/) — load by domain, never wholesale
- [Technical rules](./agent-rules/technical.md) — graduated technical lessons
- [Project Context](./project-context.md) — identity, guidelines, tech stack
- [Product requirements](./prd.md)
- Long-form docs — `docs/` (human-authored; load specific files only)
- [Code Style Guides](./code_styleguides/)

## Cold — explicit request only

- Archives — `pulse-archive/` (trimmed relay entries, old state)
- [Scratchpad](./scratchpad.md) — user-owned notes; conductor never writes here
