# TheOracle v2.0 — Implementation Plan

> Conductor-derived spec-driven development orchestrator for PlutoII.

## Background

TheOracle v1 was built for the Mercury SSD workstation (Predator Helios 300, user `addinator`). It was a Gemini CLI extension using TOML commands, with hardcoded Mercury paths and a relay protocol for multi-agent TUI communication.

Oracle v2.0 adapts this system for PlutoII (Pop!_OS, user `solmundur`, Antigravity IDE) with these key changes:
- TOML commands → Antigravity workflow markdown files
- Gemini CLI extension → Antigravity skill in `~/Hermes/TheOracle/`
- Mercury paths → PlutoII paths
- `hrelay` CLI → native Antigravity subagent communication + file-based cross-session relay
- Agent profile → lean project-context (persona handled by `/hermes`)
- Registry.json → killed (projects self-describe via their own `conductor/`)
- TDD-only → selectable strict/light workflow modes

## Design Decisions (from grill session)

| Decision | Choice |
|----------|--------|
| Integration model | Antigravity workflows, copied to projects during init |
| Agent profile | Stripped to operational context only → `project-context.md` |
| Relay protocol | Killed as CLI. Lightweight `conductor/relay.md` file for cross-session handoffs |
| Track organization | `conductor/tracks/{domain}/{snake_case}_{YYYYMMDD}/` |
| Project registry | Killed. Per-project self-contained conductors |
| TDD workflow | Two modes: strict (products) and light (prototypes). Selected during init |
| Slash commands | 4 workflows: `/conductor`, `/conductor-init`, `/checkpoint`, `/new-track` |
| Storage location | `~/Hermes/TheOracle/` — workflows copied to projects with version stamp |
| Deployment method | Copy with `# Source: TheOracle @ {date}` header |
| Code styleguides | All 9 stored in TheOracle, selectively deployed during init |
| Saturn integration | None. SSH access is sufficient. No special conductor protocol |
| Jules template | Killed. Antigravity subagents replace external delegation templates |
| Mercury context | Killed. Covered by `GEMINI.md` + `/hermes` persona |
| Naming | TheOracle v2.0. Per-file date stamps for version tracking |

---

## Proposed Changes

### TheOracle Core

#### [NEW] SKILL.md

Main entry point for Antigravity. Defines:
- Skill name: `the-oracle`
- Description: spec-driven development orchestrator
- When to use: starting projects, creating tracks, resuming work, reviewing
- How to use: step-by-step protocol selection based on user intent
- References to protocols, templates, and workflows
- Removes all Mercury/hrelay/Hermesopolis references
- Removes relay protocol and skills library CLI references

#### [NEW] README.md

Human-readable overview of TheOracle v2.0. Documents:
- What it does
- The 4 slash commands
- Per-project structure when conductor is initialized
- How to update workflow files in existing projects

---

### Protocols (6 files)

All protocols go in `~/Hermes/TheOracle/protocols/`. These are reference documents read by agents during specific operations.

#### [NEW] file-resolution.md

Ported directly from old Oracle. No changes needed — fully infrastructure-agnostic. Defines the 5-step protocol for locating conductor files.

#### [NEW] implement.md

Ported from old Oracle with minor updates:
- References `workflow.md` (which may be strict or light mode) instead of hardcoded TDD
- Removes references to `hrelay` for blocker reporting
- Adds `relay.md` file-based handoff for blockers instead

#### [NEW] new-track.md

Ported from old Oracle with updates:
- Track path uses `conductor/tracks/{domain}/{snake_case}_{YYYYMMDD}/` format
- Domain selection step added (from old workflow template)
- References updated workflow mode awareness

#### [NEW] review.md

Ported directly. No Mercury-specific references. Fully reusable.

#### [NEW] revert.md

Ported directly. No changes needed.

#### [NEW] status.md

Ported directly. No changes needed.

---

### Templates (scaffolding materials)

All templates go in `~/Hermes/TheOracle/templates/`. These are copied into projects during `/conductor-init`.

#### [NEW] workflow-strict.md

Adapted from old Oracle's 14KB `workflow.md`. Full TDD workflow:
- Red → Green → Refactor cycle
- >80% coverage gate
- 11-step standard task workflow
- Phase completion checkpointing
- Git commit protocol
- Emergency procedures

Split into sections optimized for partial reads (core workflow vs reference sections).

#### [NEW] workflow-light.md

New file. Lighter workflow for prototypes, websites, and non-product projects:
- Plan → Execute → Verify cycle (no mandatory test-first)
- Git commit protocol (same as strict)
- Checkpointing (same as strict)
- No coverage gates
- No TDD Red/Green/Refactor mandate

#### [NEW] project-context.md

Replaces old `agent-profile.md`. Contains ONLY:
- Caution Levels table (UI, Config, Shared packages, etc.)
- Domain Expertise table
- Preferred Workflows (session start, checkpoint frequency)
- Project-specific constraints (e.g., Firebase region, deployment targets)

All persona/personality/chain-of-command content removed (handled by `/hermes`).

#### [NEW] index.md

Template for `conductor/index.md` — the project context index that links to all conductor files.

#### [COPY] code_styleguides/

All 9 files copied from old Oracle unchanged:
`cpp.md`, `csharp.md`, `dart.md`, `general.md`, `go.md`, `html-css.md`, `javascript.md`, `python.md`, `typescript.md`

---

### Workflows (Antigravity slash commands)

All workflows go in `~/Hermes/TheOracle/workflows/`. These are copied to project `.agents/workflows/` during `/conductor-init`.

#### [NEW] conductor.md

`/conductor` — The resume command. Steps:
1. Load context: read `conductor/relay.md`, `conductor/pulse.md`, `conductor/tracks.md`, `conductor/project-context.md`
2. Present status report (invoke status protocol)
3. Await orders (implement, review, new track, checkpoint)

Source header: `# Source: TheOracle v2.0 @ {date}`

#### [NEW] conductor-init.md

`/conductor-init` — Scaffolding grill. Steps:
1. Detect Brownfield vs Greenfield
2. Interactive Product Definition grill
3. Product Guidelines grill
4. Tech Stack grill (with deployment_targets)
5. Code Style Guide selection (from TheOracle template library)
6. Workflow mode selection (strict vs light)
7. Create `conductor/` directory structure
8. Copy selected styleguides from TheOracle
9. Copy selected workflow template
10. Create `project-context.md` from template
11. Create `index.md`, `relay.md`, `pulse.md`, `tracks.md`
12. Deploy workflow files (conductor.md, checkpoint.md, new-track.md) to `.agents/workflows/` with version stamp
13. Initial track generation (optional)
14. Git commit

**Note:** This workflow references TheOracle templates by absolute path (`~/Hermes/TheOracle/templates/`).

#### [NEW] checkpoint.md

`/checkpoint` — Save session state. Steps:
1. Session summary → write to `conductor/pulse.md`
2. 200-line archiving guardrail on pulse.md
3. Decision log update
4. Track status check
5. Relay.md handoff entry (timestamped)
6. Git commit
7. Confirm

Quick mode: `--quick` skips decision log.

Source header: `# Source: TheOracle v2.0 @ {date}`

#### [NEW] new-track.md

`/new-track` — Create new track. Steps:
1. Gather info (description, type)
2. Domain selection (from existing domains in tracks.md or new)
3. Create track folder: `conductor/tracks/{domain}/{snake_case}_{YYYYMMDD}/`
4. Generate files (metadata.json, spec.md, plan.md, index.md)
5. Update tracks.md registry
6. Git commit
7. Confirm

Source header: `# Source: TheOracle v2.0 @ {date}`

---

## Target Directory Structure

```
~/Hermes/TheOracle/
├── implementation_plan.md      ← This file
├── SKILL.md                    ← Main entry point (Antigravity skill)
├── README.md                   ← Human-readable overview
├── protocols/                  ← Reference docs for agent operations
│   ├── file-resolution.md
│   ├── implement.md
│   ├── new-track.md
│   ├── review.md
│   ├── revert.md
│   └── status.md
├── templates/                  ← Scaffolding materials
│   ├── workflow-strict.md
│   ├── workflow-light.md
│   ├── project-context.md
│   ├── index.md
│   └── code_styleguides/
│       ├── cpp.md
│       ├── csharp.md
│       ├── dart.md
│       ├── general.md
│       ├── go.md
│       ├── html-css.md
│       ├── javascript.md
│       ├── python.md
│       └── typescript.md
└── workflows/                  ← Antigravity workflow files (copied to projects)
    ├── conductor.md
    ├── conductor-init.md
    ├── checkpoint.md
    └── new-track.md
```

---

## Files Killed (not migrated from old Oracle)

| Old File | Reason |
|----------|--------|
| `mercury-context.md` | Redundant with `GEMINI.md` + `/hermes` |
| `registry.json` | Per-project self-contained conductors |
| `Mercury System Overview.md` | Old hardware reference, not reusable |
| `GEMINI.md` | Backward-compat shim, not needed in Antigravity |
| `jules_request_template.md` | Replaced by Antigravity native subagents |
| `protocols/relay.md` | hrelay CLI killed; relay concept lives in `conductor/relay.md` file |
| `commands/conductor/*.toml` | Gemini CLI format dead; replaced by workflow markdowns |
| `templates/agent-profile.md` | Replaced by stripped `project-context.md` |

---

## Source Material

Old Oracle location: `~/Hermes/Ideas/Oracle(Old)/`
Upstream inspiration: [gemini-cli-extensions/conductor](https://github.com/gemini-cli-extensions/conductor)

---

## Verification Plan

### Automated Tests

1. Verify all files exist at expected paths:
   ```bash
   find ~/Hermes/TheOracle -type f | sort
   ```

2. Verify no Mercury/old references remain:
   ```bash
   grep -ri "mercury\|/mercury\|addinator\|hrelay\|hermes_agent_id\|hermesopolis" ~/Hermes/TheOracle/
   ```

3. Verify workflow files have source headers:
   ```bash
   head -1 ~/Hermes/TheOracle/workflows/*.md
   ```

### Manual Verification

1. Open a test project, run `/conductor-init` to verify the scaffolding grill works end-to-end
2. Verify `/conductor` loads context and presents status correctly
3. Verify `/new-track` creates properly structured track directories
4. Verify `/checkpoint` saves state to pulse.md and commits

### Post-Migration

1. Verify old Oracle can be safely removed:
   ```bash
   diff -rq ~/Hermes/Ideas/Oracle\(Old\)/templates/code_styleguides ~/Hermes/TheOracle/templates/code_styleguides
   ```
2. Trash the old Oracle: `trash ~/Hermes/Ideas/Oracle\(Old\)/`
