# Domain Glossary — TheOracle

> Ubiquitous language for this project. All commands, specs, and discussions use these terms verbatim.
>
> **Created by `/conductor-init` brownfield scan; refined by `/grill`.**

---

## Entities

| Term | Definition | Also Known As |
|------|-----------|---------------|
| **Conductor** | The per-project orchestration state and directory (`conductor/`) that manages spec-driven development — containing identity, operational context, tracks, session state, domain glossary, and architectural decisions. | — |
| **Track** | A discrete unit of work (feature, bug, chore, or spike) with its own specification, implementation plan, and metadata, organized under a domain directory. | — |
| **Track Type** | Classification of a track's purpose: `feature`, `bug`, `chore`, or `spike`. | — |
| **Track ID** | Unique identifier for a track, formatted as `{snake_case_name}_{YYYYMMDD}`. | — |
| **Domain** | A logical grouping of related tracks (e.g., `workflows`, `protocols`, `templates`) with an associated caution level, used as a subdirectory under `conductor/tracks/`. | — |
| **Specification** | The domain-aware feature specification document (`spec.md`) for a track, containing overview, requirements, acceptance criteria, edge cases, dependencies, and out-of-scope items. | `spec.md`, Spec |
| **Implementation Plan** | The phased task checklist (`plan.md`) for a track, structured as Phases → Tasks → Sub-tasks with checkbox status markers. | `plan.md`, Plan |
| **Phase** | A top-level grouping within an implementation plan representing a stage of work. | — |
| **Task** | An individual work item within a phase, tracked with checkbox status markers (`[ ]` pending, `[~]` in-progress, `[x]` complete). | — |
| **Checkpoint** | A session-state snapshot: ADR gate, pulse update, relay handoff, git commit. Invoked by `/checkpoint`. | — |
| **Pulse** | Session memory document (`pulse.md`). Tracks active work, blockers, and next-session suggestions. | Session Memory |
| **Pulse Archive** | Historical session states archived from pulse.md when it exceeds the 200-line guardrail. | — |
| **Relay** | Cross-session handoff document (`relay.md`). Timestamped entries for context continuity. | Cross-Session Handoff |
| **Domain Glossary** | The ubiquitous language document (`context.md`) containing domain entities, relationships, and terminology boundaries. | `context.md` |
| **Context Map** | Optional bounded-context registry (`context-map.md`) for multi-domain projects. | — |
| **ADR** | Architectural Decision Record (`conductor/adr/NNNN-{kebab-title}.md`) documenting a settled decision with datetime, status, context, and rationale. Must satisfy the three-criteria test. | Architectural Decision Record |
| **PRD** | Living product requirements document (`prd.md`). Created lazily by `/grill` when product scope crystallizes. | Product Requirements Document |
| **Project Context** | Consolidated identity + operational document (`project-context.md`). Created by `/conductor-init`, user-edited thereafter. | — |
| **Tracks Registry** | Central registry (`tracks.md`) listing all tracks organized by domain. | — |
| **Index** | Dynamic central index (`index.md`) linking to all conductor files that actually exist on disk. Maintained via Index Sync Protocol. | Conductor Index |
| **Grill** | Interactive question-and-answer refinement session. Used by `/conductor-init` for setup and `/grill` for domain refinement. | — |
| **Reader/Writer Contract** | YAML frontmatter in each workflow file declaring which conductor files it reads and writes. Core predictability mechanism. | R/W Contract, Frontmatter Contract |
| **Caution Level** | Per-domain risk classification (🟢 Normal / 🟡 Careful / 🔴 Critical) influencing how carefully agents operate. | — |
| **Workflow Mode** | Two operational modes: Strict (TDD + phase gates) or Light (flexible iteration). Selected during `/conductor-init`. | Strict Mode, Light Mode |
| **Lazy File Creation** | Design pattern where files only exist when there's something to write — no empty templates or stubs. | Lazy |
| **Brownfield** | A project with existing code, dependencies, and version control. Triggers domain scan during `/conductor-init`. | Existing Project |
| **Greenfield** | A new project with no existing code. Gets minimal scaffolding. | New Project |
| **Settled Decision** | An ADR with status `accepted` that must not be re-litigated without explicit user request. | — |

## Relationships

_Refine with `/grill`._

## Terminology Boundaries

_Refine with `/grill`._
