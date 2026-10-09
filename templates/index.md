<!-- Template: Orpheus v3.1 | index.md is a STATIC map. No reconcile logic, no per-boot sync — update only when the file layout itself changes. Lazy files are listed as plain paths (not links) until they exist. Placeholder: {PROJECT_NAME}. -->
# Conductor Index — {PROJECT_NAME}

> Static map of the conductor. Hot is read at every boot; Warm is loaded when
> work enters the domain; Cold only on explicit request. Lazy files appear as
> plain paths until created — turn them into links when they land.

## Hot — every boot

- [Pulse](./pulse.md) — live state, rewritten each checkpoint
- [Relay](./relay.md) — last entry only at boot
- [Tracks](./tracks.md) — one-liners only
- [Workflow](./workflow.md) — the two laws + task lifecycle
- Behavioral rules — `agent-rules/behavioral.md` _(lazy — created on first graduated lesson)_
- Glossary — `context.md` _(lazy — created when domain language is first captured)_

## Warm — when work enters the domain

- Track plans — `tracks/<track-id>/plan.md` (+ `spec.md` when present)
- Decisions — `adr/` (load by domain, never wholesale)
- Technical rules — `agent-rules/technical.md` _(lazy — created on first graduated lesson)_
- [Project Context](./project-context.md) — identity, guidelines, tech stack
- Product requirements — `prd.md` _(lazy — created on demand)_
- Long-form docs — `docs/` (human-authored; load specific files only)
- [Code Style Guides](./code_styleguides/)

## Cold — explicit request only

- Archives — `pulse-archive/` (trimmed relay entries, old state)
- [Scratchpad](./scratchpad.md) — user-owned notes; conductor never writes here
