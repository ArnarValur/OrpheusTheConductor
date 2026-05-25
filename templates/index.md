<!-- Template: TheOracle v2.1 -->
# Conductor Index — <Project Name>

> Central index for all conductor files. Start here.
>
> **Dynamic by design.** Only links to files that actually exist on disk are
> listed. New sections and links are appended by `/grill`, `/new-track`, and
> `/checkpoint` via [`protocols/index-sync.md`](../protocols/index-sync.md)
> as files are created lazily over the project lifecycle.
>
> Why: Obsidian auto-creates an empty file when a link target is missing —
> which would defeat lazy creation and pollute the repo with empty stubs.

---

## Context

<!-- Identity + operational + (later) domain glossary, PRD, agent rules. -->

- [Project Context](./project-context.md)
- [Workflow](./workflow.md)
- [Code Style Guides](./code_styleguides/)

<!--
Appended lazily by later commands (see protocols/index-sync.md):
- [Domain Glossary](./context.md)              ← `/grill` or brownfield `/conductor-init`
- [Context Map](./context-map.md)              ← multi-context projects only
- [Product Requirements](./prd.md)             ← `/grill` when scope crystallizes
- [Agent Rules](./agent-rules/)                ← `/conductor-init` when agent-rules plugin is installed
-->

---

## State

- [Pulse](./pulse.md)
- [Relay](./relay.md)
- [Tracks Registry](./tracks.md)
- [Tracks Directory](./tracks/)

---

<!--
Sections below are created lazily on first relevant write
(see protocols/index-sync.md). Do not pre-create them.

## Decisions
- [ADR Directory](./adr/)                      ← created on first ADR

## Documentation
- [Project Docs](./docs/)                      ← created on `.docs/` migration or first doc
-->

## Quick Start

1. Read `relay.md` — check for pending messages or blockers
2. Read `pulse.md` — understand current state
3. Read `tracks.md` — find your next task
4. Follow `workflow.md` — execute the task lifecycle
