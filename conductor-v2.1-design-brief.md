# Conductor v2.1 — Domain Docs, ADRs & The Grill

> **Purpose:** Design brief for the next evolution of TheOracle's Conductor system.
> Consolidate project documentation into `conductor/`, add domain-aware grilling,
> and produce living documentation as a side effect of design conversations.
>
> **Created:** 2026-05-25 — session `491dc99f`
> **Revised:** 2026-05-25 — session `e20ad7b9` (5 rounds of refinement + architectural review + v2.0 audit)
> **Status:** ✅ Ready for implementation.

---

## Problem Statement

Currently, Merkurial-studio projects have **two parallel documentation trees**:

1. **`conductor/`** — TheOracle's structured development state (product definition, tech stack, workflow, tracks, session state)
2. **`.docs/`** — manually maintained documentation, reports, guides, API docs

This creates friction:
- Two folders to open in Obsidian to get the full picture
- Domain knowledge (glossary, terminology, design decisions) lives in neither — it's scattered across chat history and developer memory
- Architectural decisions aren't recorded — future agents and future sessions re-litigate settled questions
- The native `/grill-me` is a pure Q&A session that produces **no written output** — shared understanding exists only in the conversation, not in the repo
- `/new-track` creates specs in a vacuum — no domain awareness, no glossary, no ADR context

Additionally, the **v2.0 codebase is internally inconsistent** (see D7) — `conductor-init.md` produces a different file structure than what `README.md`, `file-resolution.md`, `templates/index.md`, and `SKILL.md` expect. v2.1 fixes this.

---

## Inspiration

**Repo:** [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/engineering) — see [original analysis](file:///home/solmundur/.gemini/antigravity/brain/491dc99f-e42b-40a6-b9af-cd0aa3cb842e/conductor-v2.1-design-brief.md) for the full breakdown. Key insight: every skill speaks the same domain language. The documentation backbone is the connective tissue.

---

## All Decisions

### D1: Keep native `/grill-me` untouched

Leave the native Antigravity command alone — it may evolve with future patches. Add `/grill` as a **separate, enhanced** skill in the Conductor ecosystem.

### D2: Cherry-pick only "baking & grilling" skills

| Skill | Decision | Rationale |
|-------|----------|-----------|
| **grill-with-docs** | ✅ → `/grill` | Core — the grill that produces documentation |
| **to-prd** | ✅ Folded into `/grill` | Not a separate command — grill offers to write `prd.md` when product scope crystallizes |
| `to-issues` | ❌ | We don't use a separate issue tracker — tracks are our issues |
| `improve-codebase-architecture` | ❌ | Review tool, not a documentation producer. Consider later. |
| `tdd` | ❌ | Overlaps with `conductor/workflow.md` (strict mode) + agent-rules |
| `diagnose` | ❌ | Bug diagnosis — orthogonal to baking/grilling |
| `prototype` | ❌ | Standalone, no documentation output |

### D3: ADR format with datetime + batched proposals

```md
# {Short title of the decision}

> **Recorded:** 2026-05-25 13:45
> **Status:** accepted

{1-3 sentences: what's the context, what did we decide, and why.}
```

Optional sections (only when they add genuine value):
- **Considered Options** — when rejected alternatives are worth remembering
- **Consequences** — when non-obvious downstream effects need callout
- **Superseded by** — when a later ADR replaces this one

**When to write an ADR** (all three must be true):
1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why on earth?"
3. **Real trade-off** — there were genuine alternatives, you picked one for specific reasons

**How ADRs are proposed (no inline writes):**
During a `/grill` or `/new-track` session, the agent accumulates candidate decisions internally. At the **end of the command invocation** (see D10), it presents them as a batch: *"These decisions crystallized — want me to record them as ADRs?"* The user picks which ones stick. This prevents clutter from rapid iteration mid-session. Only finalized decisions get committed to `adr/`.

### D4: Brownfield init pre-populates `context.md` (targeted scan)

When `/conductor-init` runs on a brownfield codebase, it performs a **targeted domain scan** — not a naive grep across the entire codebase. The scan:
1. **Asks the user:** *"Where does your core domain logic live?"* (e.g., `src/domain/`, `models/`, `app/entities/`)
2. **Prioritizes:** Model/entity directories, database schema files (`.surql`, SQL migrations), type definitions, and API route handlers
3. **Excludes:** Utility/infrastructure code (`Logger`, `Config`, `DatabaseConnector`, `AuthMiddleware`) — these are technical, not domain concepts

Pre-populates `conductor/context.md` with inferred domain terms. The `/grill` can then refine these with a conditional: *"The context already contains these terms — want to update them?"*

Greenfield projects get no `context.md` file — created lazily by `/grill` when the first domain term emerges.

### D5: `context-map.md` confirmed, per-context structure deferred

Multi-bounded-context projects (like DittoDatto) need `context-map.md`. The file is part of v2.1.

> [!IMPORTANT]
> **🔮 Future note for DittoDatto conductor-init:**
> When DittoDatto gets conductor'd, it will need per-context domain glossaries (booking engine, customer portal, admin dashboard, Flutter apps — each with their own domain language). The proposed structure is `conductor/contexts/{name}/context.md`, keeping everything under the conductor roof rather than scattering into source directories. But design the exact shape when you're staring at the real codebase, not in the abstract. Root `context.md` holds cross-context terms; per-context files hold context-specific language. `context-map.md` at root links them together.
>
> **Naming alignment:** When multi-context is implemented, the `{domain}` folder under `tracks/` must map directly to a registered bounded context name in `context-map.md`. `/new-track` should validate the domain against `context-map.md` and load the corresponding glossary at `conductor/contexts/{domain}/context.md`. Without this enforcement, track domains and context names will drift apart.
>
> — Session `e20ad7b9`, 2026-05-25

**Forward-compatible validation gate (implemented now as no-op):** `/new-track` Step 2 (Domain Selection) checks for `context-map.md`. When it exists, the chosen domain MUST match a registered context name. When it doesn't exist, accept any domain (current behavior). This costs nothing today and prevents migration pain later.

### D6: `spec.md` stays `spec.md`

No rename to `frd.md`. The PRD→FRD naming hierarchy is logically clean but adds cognitive overhead for no practical gain. `spec.md` is immediate and clear. The upgrade is making it **domain-aware**, not renaming it.

### D7: Consolidate `project-context.md` (fix v2.0 inconsistency)

> [!WARNING]
> **v2.0 is internally inconsistent.** The audit confirmed:
> - `conductor-init.md` Step 10 writes Product Definition + Guidelines + Tech Stack into ONE file: `project-context.md`
> - `README.md`, `templates/index.md`, `file-resolution.md`, and `SKILL.md` all assume FOUR separate files: `product.md`, `product-guidelines.md`, `tech-stack.md`, `project-context.md`
> - The `templates/project-context.md` template contains only operational info (caution levels, domain expertise) — no product identity
>
> Any agent following `conductor-init` today produces a conductor that `file-resolution.md` can't resolve.

**Decision: Option A — consolidate.** `project-context.md` becomes the **single identity + operational document**. Kill `product.md`, `product-guidelines.md`, `tech-stack.md` as separate files.

Razor-sharp boundary with `prd.md`:
- **`project-context.md`** = Identity + operational constraints. What the product *is*, how agents should behave, tech stack, guidelines, caution levels, domain expertise. Written once by `/conductor-init`.
- **`prd.md`** = Living scope document. Features, capabilities, what's in and what's out. Written by `/grill` when product scope crystallizes. Evolves over time.

They share no sections.

**v2.0 files that must be updated in lockstep:**

| File | Change |
|------|--------|
| `templates/project-context.md` | Merge: add Product Definition, Guidelines, Tech Stack sections alongside existing operational sections |
| `templates/index.md` | Remove references to `product.md`, `product-guidelines.md`, `tech-stack.md` |
| `protocols/file-resolution.md` | Remove `product.md`, `product-guidelines.md`, `tech-stack.md` rows; add new v2.1 paths |
| `README.md` | Update per-project structure to show consolidated `project-context.md` |
| `skills/the-oracle/SKILL.md` | Update per-project structure |

### D8: Lazy file creation + `.gitkeep` for directories

Files only exist when there's something to write. No empty templates sitting in the repo. Init scaffolds **directories** with `.gitkeep` files so the structure is visible in Git (Git does not track empty directories). Files like `context.md`, `prd.md`, and ADRs are created lazily by `/grill` and `/new-track` when content emerges.

**Git compatibility:** `conductor/adr/.gitkeep` and `conductor/docs/.gitkeep` are written during init. When the first real file is added to these directories, the `.gitkeep` can optionally be removed.

### D9: v2.0 → v2.1 migration path

Brownfield re-init on a v2.0 conductor must:

1. **Add new directories:** `adr/.gitkeep`, `docs/.gitkeep`
2. **Run targeted domain scan** only if `context.md` doesn't already exist
3. **Handle product.md split:** If separate `product.md`, `product-guidelines.md`, `tech-stack.md` exist (v2.0 README structure), offer to merge their content into `project-context.md` and remove the originals. If `project-context.md` already contains everything (v2.0 conductor-init structure), no action needed.
4. **Rewrite `index.md`** to the new dynamic format, keeping only links to files that actually exist
5. **Update workflow source headers** from `v2.0` to `v2.1`
6. **Do NOT clobber:** Preserve existing tracks, pulse, relay, pulse-archive, agent-rules, code_styleguides

### D10: ADR session boundary

"At end of session" means **end of each command invocation** — when the workflow returns control to the user. NOT at the end of a conversation.

Three back-to-back `/grill` runs produce three separate ADR batches, not one giant batch. This prevents amnesia and keeps each batch scoped to its conversation context.

### D11: `/checkpoint` becomes ADR gate

Today, `checkpoint.md` Step 3 appends decisions into `pulse.md`'s Session Memory. With ADRs, this creates **two competing decision logs** — one ephemeral in `pulse.md`, one durable in `adr/`.

**Fix:** Repurpose Step 3 as a decision classifier:

> *"I noticed N decisions this session. Which are architectural (→ ADR in `conductor/adr/`), which are operational (→ pulse Session Memory), which are ephemeral (→ drop)?"*

This is the same batching pattern as D3, applied at checkpoint time. The symmetry is itself cohesion. Architectural decisions get a permanent home in `adr/`; operational notes stay in `pulse.md` where they belong.

### D12: `conductor/docs/` defined

`conductor/docs/` is for **long-form human-authored documentation** — guides, reports, post-mortems, API references. It is **read-only to all commands** except explicit user-driven writes. No command auto-generates content here.

This replaces the existing `.docs/` convention, bringing it under the conductor roof.

---

## The Document Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│ PRODUCT LEVEL (one per project)                                 │
│                                                                 │
│  project-context.md  ← WHAT is the product, HOW agents behave  │
│  context.md          ← HOW we talk about the domain (glossary)  │
│  context-map.md      ← WHERE are the bounded contexts (optional)│
│  prd.md              ← WHAT are we building, full product scope │
│  adr/                ← WHY we decided things this way           │
│  docs/               ← Long-form human-authored documentation   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│ FEATURE LEVEL (one per track)                                   │
│                                                                 │
│  tracks/{domain}/{track}/                                       │
│    spec.md           ← WHAT this specific feature does          │
│    plan.md           ← HOW and WHEN we build it (phases/tasks)  │
│    metadata.json     ← Machine-readable track state             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

| Document | Scope | Answers | Written by | Lifecycle |
|----------|-------|---------|------------|-----------|
| `project-context.md` | Product | What is this? Tech stack? Guidelines? Constraints? | `/conductor-init` | Written once, updated rarely |
| `context.md` | Domain | Domain terms? Entity relationships? | `/grill`, `/new-track`, `/conductor-init` (brownfield) | Living document, grows over time |
| `context-map.md` | Domain | Where are the bounded contexts? | `/grill` or manual | Only for multi-context projects |
| `prd.md` | Product | What's the full scope we're building? | `/grill` (when scope crystallizes) | Living document, evolves with product |
| `adr/` | Product | Why did we make this decision? | `/grill`, `/new-track`, `/checkpoint` (batched) | Append-only (supersede, never edit) |
| `docs/` | Project | Guides, reports, post-mortems | Human-authored only | Read-only to commands |
| `spec.md` | Feature | What does this track deliver? | `/new-track` (domain-aware) | Created per track, frozen once approved |
| `plan.md` | Feature | How do we implement the spec? | `/new-track` | Execution checklist, updated during work |

---

## The Two-Phase Model

```
Phase 1: /conductor-init                  Phase 2: /grill → /new-track
┌─────────────────────────────┐           ┌────────────────────────────────────┐
│  Lay the foundation         │           │  Refine on top of foundation       │
│                             │           │                                    │
│  • Product definition       │           │  /grill (repeatable)               │
│  • Tech stack               │──────────▶│    • Sharpen domain language       │
│  • Workflow mode            │           │    • Crystallize ADRs (batched)    │
│  • Code style guides        │           │    • Update context.md             │
│  • Agent rules              │           │    • Write/update prd.md           │
│  • Pre-populated context.md │           │      (when product scope emerges)  │
│    (brownfield) or empty    │           │                                    │
│    dirs (greenfield)        │           │  /new-track (now domain-aware)     │
│                             │           │    • Read context + ADRs + PRD     │
└─────────────────────────────┘           │    • Grill for feature scope       │
       RUN ONCE                           │    • Write spec.md + plan.md       │
                                          │    • Append new terms to context   │
                                          │    • Batch ADR proposals           │
                                          │                                    │
                                          │  /checkpoint (ADR gate)            │
                                          │    • Classify: ADR vs pulse vs drop│
                                          └────────────────────────────────────┘
                                                   RUN MANY TIMES
```

**Key principle:** Init creates *structure and identity*. The grill creates *understanding*. Tracks create *work*. Checkpoints classify *decisions*.

---

## Flow: How it all connects

```
/conductor-init
  └──→ project-context.md (product identity + operational context, consolidated)
  └──→ context.md (pre-populated for brownfield, nothing for greenfield)
  └──→ scaffolding (adr/.gitkeep, docs/.gitkeep, code_styleguides/, etc.)

/grill (repeatable, runs on top of init)
  ├── reads: project-context.md, context.md, adr/*, prd.md, codebase
  ├── orientation: produces 1-paragraph summary of what's already established before first question
  ├── writes: context.md updates (domain terms sharpened)
  ├── batches: adr/ proposals (presented at end of command, user approves)
  ├── offers: write/update prd.md (when product scope emerges from conversation)
  └── appends: index.md links for any newly created files

/new-track (domain-aware feature creation)
  ├── reads: context.md, adr/*, prd.md (knows the product scope)
  ├── validates: domain against context-map.md (when it exists)
  ├── grills: 3-5 questions using domain language
  ├── writes: tracks/{domain}/{track}/spec.md (domain-aware feature spec)
  ├── writes: tracks/{domain}/{track}/plan.md (implementation plan)
  ├── writes: context.md (appends new domain terms discovered during spec)
  ├── batches: adr/ proposals (at end of command, user picks which stick)
  └── appends: index.md links for any newly created files

/checkpoint (ADR gate)
  ├── reads: pulse.md session memory for accumulated decisions
  ├── classifies: architectural → adr/, operational → pulse session memory, ephemeral → drop
  └── writes: approved ADRs to adr/ with datetime
```

---

## Reader/Writer Contracts

Every workflow file gets a frontmatter block declaring what it reads and writes. This makes the system self-documenting and is the foundation for a future `conductor-doctor` command that can validate integrity.

```yaml
# Example: grill.md frontmatter
---
name: grill
reads:
  - conductor/project-context.md
  - conductor/context.md
  - conductor/prd.md
  - conductor/adr/
writes:
  - conductor/context.md
  - conductor/prd.md         # conditional
  - conductor/adr/*.md       # conditional, batched at command end
  - conductor/index.md       # link appends only
---
```

Each deliverable workflow file must include this. Agents should respect the declared scope — no command writes outside its contract.

---

## Shared Protocol: Index Sync (`protocols/index-sync.md`)

Extracted to prevent drift across multiple writers. Every command that lazily creates a file uses this protocol.

**Append rules:**

| File created | Section in `index.md` | Link text |
|---|---|---|
| `context.md` | `## Context` | `- [Domain Glossary](./context.md)` |
| `prd.md` | `## Context` | `- [Product Requirements](./prd.md)` |
| First ADR in `adr/` | New `## Decisions` section | `- [ADR Directory](./adr/)` |
| `.docs/` migrated to `docs/` | New `## Documentation` section | `- [Project Docs](./docs/)` |
| `agent-rules/` installed | `## Context` | `- [Agent Rules](./agent-rules/)` |

**Reconcile path:** `/conductor` resume can run a defensive reconcile — scan `conductor/` for files that exist on disk but are missing from `index.md`, and append their links. This turns lazy index sync from a brittle convention into a recoverable invariant.

---

## Intent Routing (extend SKILL.md)

| User intent | Command |
|---|---|
| "Set up conductor" / new project | `/conductor-init` |
| "Where am I, what's next?" / resume | `/conductor` |
| "Let's think about the product/domain/decisions" | `/grill` |
| "I want to build X" / new feature | `/new-track` |
| "Start working" / implement | `/conductor` → implement protocol |
| "Review" / check my code | `/conductor` → review protocol |
| "Save state" / checkpoint | `/checkpoint` |
| "Undo" / revert | `/conductor` → revert protocol |
| "Status" / progress | `/conductor` → status protocol |

---

## Implementation Deliverables

### 1. New Skill: `/grill`

A new skill in `the-oracle` plugin, adapted from Matt's `grill-with-docs`:

- Same core interview loop (one question at a time, explore codebase, recommend answers)
- **Reads** `conductor/context.md`, `conductor/adr/`, `conductor/project-context.md`, `conductor/prd.md` before starting
- **Re-entry contract:** On entry, `/grill` MUST produce a 1-paragraph orientation summary of what's already established in `context.md`, `prd.md`, and `adr/` before asking its first question. This prevents re-litigation of settled decisions.
- **Writes** domain glossary updates to `conductor/context.md` as terminology sharpens
- **Batches** ADR proposals — accumulates candidate decisions during the interview, presents them at end of command invocation (D10) for user approval. Only approved ADRs are written to `conductor/adr/`
- **Offers** to write/update `conductor/prd.md` when product scope emerges
- Creates files lazily — only when there's something to write
- **Appends** links to `index.md` via `protocols/index-sync.md` for any newly created files
- **Does NOT** replace native `/grill-me`
- **Reader/writer contract** in frontmatter

### 2. Update: `/conductor-init` v2.1

Add to the scaffolding:

- **Directory structure:** Add `conductor/adr/`, `conductor/docs/` to `mkdir -p`, with `.gitkeep` in each
- **Brownfield context scan:** After product definition grill (Step 3), perform a **targeted** domain scan. Ask the user where core domain logic lives, then scan models/entities/schema files. Exclude infrastructure/utility code. Pre-populate `conductor/context.md` with inferred entities, relationships, terminology
- **Greenfield:** Create `conductor/adr/` and `conductor/docs/` directories with `.gitkeep` only (no content files)
- **`.docs/` migration:** If existing `.docs/` found, ask: "Move `.docs/` into `conductor/docs/`?"
- **Dynamic `index.md`:** Only include links to files that actually exist at init time. Use `protocols/index-sync.md` for append rules.
- **Source header:** `# Source: TheOracle v2.1 @ 2026-05-25`
- **Reader/writer contract** in frontmatter

**Init-time `index.md`** (minimal — only links to files that exist):

```markdown
# Conductor Index

## Context
- [Project Context](./project-context.md)
- [Workflow](./workflow.md)
- [Code Style Guides](./code_styleguides/)

## State
- [Pulse](./pulse.md)
- [Relay](./relay.md)
- [Tracks Registry](./tracks.md)
- [Tracks Directory](./tracks/)
```

**Links added dynamically by later commands** (via `protocols/index-sync.md`):

| When | Link added to `index.md` |
|------|-------------------------|
| `/grill` creates `context.md` | `- [Domain Glossary](./context.md)` under Context |
| `/grill` creates `prd.md` | `- [Product Requirements](./prd.md)` under Context |
| `/grill` or `/new-track` creates first ADR | `## Decisions` section + `- [ADR Directory](./adr/)` |
| `/conductor-init` finds `.docs/` to migrate | `## Documentation` section + `- [Project Docs](./docs/)` |
| `/conductor-init` installs agent-rules | `- [Agent Rules](./agent-rules/)` under Context |

> This prevents broken links in Obsidian. In Obsidian's default behavior, clicking a dead link auto-creates an empty file — which would defeat lazy creation and pollute the repo.

### 3. Update: `/new-track` — Domain-Aware

Upgrade the existing workflow:

- **Before the spec grill:** Read `conductor/context.md`, `conductor/adr/*`, and `conductor/prd.md` (if they exist)
- **Domain validation (D5 forward-compat):** When `context-map.md` exists, validate the chosen domain against registered context names. When it doesn't exist, accept any domain (current behavior).
- **During the grill:** Use domain glossary terms in questions and suggestions
- **New domain terms:** When the spec interview introduces new entities or terminology not in `context.md`, append them to the glossary automatically (or offer to)
- **ADR proposals:** Accumulate candidate decisions during the spec interview. At end of command invocation (D10), batch-present them to the user for approval before writing to `adr/`
- **Index sync:** Append links via `protocols/index-sync.md` for any newly created files
- Track `spec.md` content stays the same structure, just informed by domain context
- **Source header:** `# Source: TheOracle v2.1 @ 2026-05-25`
- **Reader/writer contract** in frontmatter

### 4. Update: `/checkpoint` — ADR Gate (D11)

Repurpose Step 3:

- Scan session for accumulated decisions
- Present classification prompt: *"I noticed N decisions this session. Which are architectural (→ ADR), which are operational (→ pulse session memory), which are ephemeral (→ drop)?"*
- Write approved architectural decisions to `adr/` with datetime
- Keep operational decisions in `pulse.md` Session Memory as before
- Drop ephemeral decisions
- **Source header:** `# Source: TheOracle v2.1 @ 2026-05-25`
- **Reader/writer contract** in frontmatter

### 5. Update: `/conductor` resume

Add to context loading (Step 1):
- `conductor/context.md` — domain glossary (if exists)
- `conductor/prd.md` — product scope (if exists)
- `conductor/adr/*.md` — architectural decision records (if any)
- Awareness of `conductor/docs/` (check index, don't read all)
- **Defensive reconcile:** Run `protocols/index-sync.md` reconcile path to catch any files present on disk but missing from `index.md`

### 6. Update: File resolution protocol

**New defaults table** (replaces current):

| Document | Default Path |
|----------|-------------|
| Product & Operational Context | `conductor/project-context.md` |
| Domain Glossary | `conductor/context.md` |
| Context Map | `conductor/context-map.md` |
| Product Requirements | `conductor/prd.md` |
| Workflow | `conductor/workflow.md` |
| ADR Directory | `conductor/adr/` |
| Documentation | `conductor/docs/` |
| Agent Rules | `conductor/agent-rules/` |
| Tracks Registry | `conductor/tracks.md` |
| Tracks Directory | `conductor/tracks/` |
| Pulse | `conductor/pulse.md` |
| Relay | `conductor/relay.md` |

**Removed rows:** `conductor/product.md`, `conductor/tech-stack.md`, `conductor/product-guidelines.md` (consolidated into `project-context.md` per D7)

**Track defaults** (unchanged):

| Document | Default Path |
|----------|-------------|
| Specification | `conductor/tracks/<domain>/<track_id>/spec.md` |
| Implementation Plan | `conductor/tracks/<domain>/<track_id>/plan.md` |
| Metadata | `conductor/tracks/<domain>/<track_id>/metadata.json` |

### 7. Fix v2.0 inconsistency (D7 lockstep updates)

| File | Change |
|------|--------|
| `templates/project-context.md` | Merge: add Product Definition, Guidelines, Tech Stack sections alongside existing operational sections |
| `templates/index.md` | Remove references to `product.md`, `product-guidelines.md`, `tech-stack.md`; use new dynamic format |
| `protocols/file-resolution.md` | Replace defaults table with v2.1 version (see deliverable #6) |
| `README.md` | Update per-project structure to show consolidated `project-context.md` + new v2.1 files |
| `skills/the-oracle/SKILL.md` | Update per-project structure + extend intent routing table |

### 8. New: `protocols/index-sync.md`

Shared protocol for dynamic index management:
- Append rules per file type (exact link text and target section)
- Reconcile path for defensive rebuilds during `/conductor` resume
- Used by: `/grill`, `/new-track`, `/checkpoint`, `/conductor`

### 9. New: `protocols/reader-writer-contracts.md` (reference)

Documents the contract format and lists all workflow contracts in one place for cross-reference. Individual contracts live in each workflow's frontmatter; this file is the central registry.

---

## `context.md` Templates

### Brownfield (pre-populated by targeted init scan)

```markdown
# Domain Context

> Domain glossary and ubiquitous language for {project-name}.
> Updated by `/grill` and `/new-track` sessions. Last refined: {datetime}.

## Entities

| Term | Definition | Also known as |
|------|-----------|---------------|
| {Entity} | {Inferred from codebase scan} | {aliases found in code} |

## Relationships

- {Entity A} → {relationship} → {Entity B}

## Terminology Boundaries

- We say "{preferred term}", not "{rejected alternative}"

## Notes

_Pre-populated from targeted domain scan during `/conductor-init`. Refine with `/grill`._
```

### Greenfield

No file created. `/grill` creates it lazily when the first domain term emerges, using this structure:

```markdown
# Domain Context

> Domain glossary and ubiquitous language for {project-name}.
> Updated by `/grill` and `/new-track` sessions. Last refined: {datetime}.

## Entities

| Term | Definition | Also known as |
|------|-----------|---------------|

## Relationships

## Terminology Boundaries
```

---

## Proposed Structure (v2.1)

```
conductor/
├── index.md                ← central index (dynamic, no broken links)
├── project-context.md      ← CONSOLIDATED: product + guidelines + tech + operational
├── context.md              ← NEW: domain glossary (lazy, brownfield pre-populated)
├── context-map.md          ← NEW: bounded context map (optional, multi-domain)
├── prd.md                  ← NEW: product requirement document (lazy, living)
├── workflow.md             ← development workflow (exists)
├── adr/                    ← NEW: architectural decision records
│   ├── .gitkeep
│   ├── 0001-chose-surrealdb.md
│   └── 0002-event-sourcing-for-orders.md
├── docs/                   ← NEW: human-authored long-form documentation
│   └── .gitkeep
├── agent-rules/            ← book-sourced coding rules (exists from v2.0.1)
├── code_styleguides/       ← language style guides (exists)
├── tracks/                 ← feature work (exists, specs now domain-aware)
│   └── {domain}/
│       └── {track_id}/
│           ├── index.md
│           ├── spec.md     ← now domain-aware
│           ├── plan.md
│           └── metadata.json
├── pulse-archive/          ← archived session states (exists)
├── pulse.md                ← current session state (exists)
├── relay.md                ← cross-session handoff (exists)
└── tracks.md               ← tracks registry (exists)
```

---

## Verification Plan

### Core flow verification:

1. **`/conductor-init`** on a fresh greenfield project — confirm new dirs created with `.gitkeep`, no content files, `index.md` has no broken links
2. **`/conductor-init`** on a brownfield project (e.g., `~/SurrealDB/`) — confirm targeted scan asks for domain logic location, `context.md` pre-populated with domain terms (not infrastructure noise)
3. **`/grill`** on an initialized project — confirm it reads existing context, produces orientation summary, `context.md` updates, and batches ADR proposals at command end
4. **`/grill`** scope crystallization — confirm it offers to write `prd.md` and appends link to `index.md`
5. **`/new-track`** on a project with `context.md` and ADRs — confirm spec uses domain language, new terms appended to glossary
6. **`/conductor`** resume — confirm it loads new files during context loading and runs defensive index reconcile
7. **Obsidian safety** — confirm `index.md` contains no dead links at any point in the lifecycle
8. **Git safety** — confirm `git clone` + `conductor/` has all expected directories intact

### Integration verification:

9. **Round-trip test:** `/conductor-init` → `/grill` → `/new-track` → `/checkpoint` → `/conductor`. Confirm no broken refs in `index.md`, no orphan files in `conductor/`, no duplicate decision records across `pulse.md` and `adr/`
10. **v2.0 → v2.1 brownfield re-init** on a real v2.0 project (one that has the old separate `product.md` files). Verify D9 migration doesn't lose content
11. **Reader/writer contract validation** — for each workflow, verify its declared reads/writes match actual file operations

---

## What Was Already Built

### `/agent-rules` Plugin ✅ (session `491dc99f`)

- **Plugin:** `~/.gemini/config/plugins/agent-rules-books/`
- **14 books** bundled (mini + full tiers)
- **Smart install:** `conductor/agent-rules/` if Conductor exists, `.agents/rules/` if not
- **TheOracle updated:** `/conductor` loads agent-rules during resume
- **See:** [walkthrough](file:///home/solmundur/.gemini/antigravity/brain/491dc99f-e42b-40a6-b9af-cd0aa3cb842e/walkthrough.md)
