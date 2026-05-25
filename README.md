# TheOracle v2.0

> Spec-driven development orchestrator for Merkurial-studio.

TheOracle provides structured, spec-driven development workflows for any project. It scaffolds projects with product definitions, tech stacks, and development workflows, then manages the full lifecycle of feature tracks from specification through implementation, review, and completion.

## Slash Commands

TheOracle provides 4 Antigravity workflow commands. These are deployed to a project's `.agents/workflows/` directory during initialization.

| Command | Purpose |
|---------|---------|
| `/conductor-init` | Initialize conductor in a project — interactive grill for product definition, tech stack, guidelines, workflow mode, and optional first track |
| `/conductor` | Resume work — loads project context, presents status, awaits orders |
| `/new-track` | Create a new feature/bug/chore track with spec and implementation plan |
| `/checkpoint` | Save session state — pulse update, decision log, relay handoff, git commit |

## Workflow Modes

TheOracle supports two workflow modes, selected during `/conductor-init`:

- **Strict** — Full TDD: Red → Green → Refactor, >80% coverage gate, 11-step task lifecycle. For products and production codebases.
- **Light** — Plan → Execute → Verify. No mandatory test-first, no coverage gates. For prototypes, websites, and experiments.

## Per-Project Structure

After running `/conductor-init`, your project gets:

```
project-root/
├── .agents/workflows/          ← Slash commands (conductor, checkpoint, new-track)
├── conductor/
│   ├── index.md                ← Links to all conductor files
│   ├── product.md              ← What you're building
│   ├── product-guidelines.md   ← Brand voice, UX principles
│   ├── tech-stack.md           ← Languages, frameworks, deployment targets
│   ├── workflow.md             ← Development workflow (strict or light)
│   ├── project-context.md      ← Caution levels, constraints
│   ├── pulse.md                ← Session memory
│   ├── relay.md                ← Cross-session handoffs
│   ├── tracks.md               ← Track registry
│   ├── tracks/                 ← Feature/bug/chore tracks
│   │   └── <domain>/<track_id>/
│   └── code_styleguides/       ← Language-specific style guides
```

## Updating Workflows in Existing Projects

Two options:

1. **Re-initialize:** Run `/conductor-init` again — it detects brownfield projects and offers to update workflow files while preserving your conductor state.
2. **Manual copy:** Copy updated workflow files from `~/Hermes/TheOracle/workflows/` to your project's `.agents/workflows/`. Each file has a `# Source: TheOracle v2.0 @ <date>` header for version tracking.

## Protocols

Detailed agent protocols live in `~/Hermes/TheOracle/protocols/`:

| Protocol | Purpose |
|----------|---------|
| `file-resolution.md` | How to locate conductor files within any project |
| `implement.md` | Execute tasks from a track's implementation plan |
| `new-track.md` | Create a new track with spec and plan |
| `review.md` | Code review against guidelines and plan |
| `revert.md` | Git-aware undo of tracks, phases, or tasks |
| `status.md` | Progress dashboard across all tracks |

## Source

- **Upstream inspiration:** [gemini-cli-extensions/conductor](https://github.com/gemini-cli-extensions/conductor)
