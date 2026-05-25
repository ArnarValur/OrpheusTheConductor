# TheOracle v2.1

> Spec-driven development orchestrator for Merkurial-studio.

TheOracle provides structured, spec-driven development workflows for any project. It scaffolds projects with a consolidated identity + operational document, a domain glossary, architectural decision records, and full development workflows — then manages the full lifecycle of feature tracks from specification through implementation, review, and completion.

## What's New in v2.1

- **Consolidated project context** — `project-context.md` is now a single identity + operational document. The v2.0 `product.md` / `product-guidelines.md` / `tech-stack.md` split has been merged in (identity-first, operational-second section order).
- **Domain awareness** — new `conductor/context.md` (domain glossary) and optional `conductor/context-map.md` (bounded-context map) drive domain-aware spec generation in `/new-track`.
- **Architectural Decision Records** — `conductor/adr/` holds batched ADRs proposed at the end of `/grill`, `/new-track`, and `/checkpoint` runs.
- **Living PRD** — `conductor/prd.md` is created lazily when product scope crystallizes during `/grill`.
- **Long-form docs under the conductor roof** — `conductor/docs/` replaces the old `.docs/` convention. Human-authored only.
- **Dynamic `index.md`** — links are appended lazily by [`protocols/index-sync.md`](./protocols/index-sync.md) as files come into existence. No dead links, ever.
- **Reader/writer contracts** — each workflow declares what it reads and writes in its frontmatter, making the system self-documenting.

## Slash Commands

TheOracle provides 5 Antigravity workflow commands. These are deployed to a project's `.agents/workflows/` directory during initialization.

| Command | Purpose |
|---------|---------|
| `/conductor-init` | Initialize conductor in a project — interactive grill for product identity, tech stack, guidelines, workflow mode, and (brownfield) targeted domain scan |
| `/conductor` | Resume work — loads project context, defensive index reconcile, presents status, awaits orders |
| `/grill` | Repeatable domain refinement — sharpens `context.md`, batches ADR proposals, offers to write/update `prd.md` |
| `/new-track` | Create a new feature/bug/chore track with domain-aware spec and implementation plan |
| `/checkpoint` | Save session state — ADR gate for decision classification, pulse update, relay handoff, git commit |

> Note: `/grill` is separate from the native `/grill-me` Antigravity command, which is left untouched.

## Workflow Modes

TheOracle supports two workflow modes, selected during `/conductor-init`:

- **Strict** — Full TDD: Red → Green → Refactor, >80% coverage gate, 11-step task lifecycle. For products and production codebases.
- **Light** — Plan → Execute → Verify. No mandatory test-first, no coverage gates. For prototypes, websites, and experiments.

## Per-Project Structure (v2.1)

After running `/conductor-init`, your project gets:

```text
project-root/
├── .agents/workflows/          ← Slash commands (conductor, conductor-init, grill, new-track, checkpoint)
├── conductor/
│   ├── index.md                ← Dynamic central index (no dead links — see protocols/index-sync.md)
│   ├── project-context.md      ← CONSOLIDATED: identity + operational
│   ├── workflow.md             ← Development workflow (strict or light)
│   ├── context.md              ← Domain glossary (lazy — pre-populated brownfield, created by /grill greenfield)
│   ├── context-map.md          ← Optional — multi-bounded-context projects only
│   ├── prd.md                  ← Living product requirements (lazy — created by /grill when scope emerges)
│   ├── adr/                    ← Architectural decision records (batched by /grill, /new-track, /checkpoint)
│   │   └── .gitkeep
│   ├── docs/                   ← Long-form human-authored documentation
│   │   └── .gitkeep
│   ├── agent-rules/            ← Optional — installed by the agent-rules plugin
│   ├── code_styleguides/       ← Language-specific style guides (copied at init)
│   ├── pulse.md                ← Session memory
│   ├── pulse-archive/          ← Archived session states
│   ├── relay.md                ← Cross-session handoffs
│   ├── tracks.md               ← Track registry
│   └── tracks/                 ← Feature/bug/chore tracks
│       └── <domain>/<track_id>/
│           ├── index.md
│           ├── spec.md         ← Domain-aware (reads context.md + adr/* + prd.md)
│           ├── plan.md
│           └── metadata.json
```

## Updating Workflows in Existing Projects

Two options:

1. **Re-initialize:** Run `/conductor-init` again — it detects brownfield projects and offers to update workflow files while preserving your conductor state, including the v2.0 → v2.1 migration path (consolidate `product.md` / `product-guidelines.md` / `tech-stack.md` into `project-context.md` if found as separate files).
2. **Manual copy:** Copy updated workflow files from `~/Hermes/TheOracle/workflows/` to your project's `.agents/workflows/`. Each file has a `# Source: TheOracle v2.1 @ <date>` header for version tracking.

## Protocols

Detailed agent protocols live in `~/Hermes/TheOracle/protocols/`:

| Protocol | Purpose |
|----------|---------|
| `file-resolution.md` | How to locate conductor files within any project (v2.1 defaults) |
| `index-sync.md` | **NEW v2.1** — shared protocol for lazy `index.md` appends + defensive reconcile |
| `implement.md` | Execute tasks from a track's implementation plan |
| `new-track.md` | Create a new track with domain-aware spec and plan |
| `review.md` | Code review against guidelines and plan |
| `revert.md` | Git-aware undo of tracks, phases, or tasks |
| `status.md` | Progress dashboard across all tracks |

## Design Documents

- [`conductor-v2.1-design-brief.md`](./conductor-v2.1-design-brief.md) — full design rationale (D1–D12)
- [`conductor-v2.1-design-brief-supplement.md`](./conductor-v2.1-design-brief-supplement.md) — second-pass seams + polish (now absorbed into the main brief; retained as audit trail)

## Source

- **Upstream inspiration:** [gemini-cli-extensions/conductor](https://github.com/gemini-cli-extensions/conductor)
- **Grill inspiration:** [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/engineering)
