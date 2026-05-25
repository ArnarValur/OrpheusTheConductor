# Source: TheOracle v2.0 @ 2026-05-22

---
name: conductor-init
description: Initialize Conductor — scaffold project structure through an interactive grill
---

# 🎵 Conductor Init — Project Scaffolding

When the user invokes `/conductor-init`, execute this interactive setup sequence to scaffold a Conductor-managed project.

---

## Step 1: Detect Project Maturity

Determine if this is a **Brownfield** (existing) or **Greenfield** (new) project.

**Brownfield indicators** — if ANY are present, classify as Brownfield:
- Version control directories: `.git`, `.svn`, `.hg`
- Dependency manifests: `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pubspec.yaml`
- Source code directories: `src/`, `app/`, `lib/` containing code files
- An existing `conductor/` directory (previous initialization)

**Greenfield** — ONLY if none of the above are found.

**If an existing `conductor/` directory is detected:**
> Ask the user: "A `conductor/` directory already exists. Do you want to reinitialize (this will overwrite existing configuration) or abort?"
> If abort, halt. If reinitialize, proceed but warn about overwriting.

**If Brownfield:**
1. Announce existing project detected
2. If uncommitted git changes exist, warn: "You have uncommitted changes. Commit or stash before proceeding."
3. Perform a read-only scan: analyze `README.md`, manifest files, and directory structure to infer project context
4. Respect `.gitignore` and `.geminiignore` when scanning
5. Summarize findings: inferred tech stack, architecture type, project goal

**If Greenfield:**
1. Announce new project initialization
2. Initialize git repo if `.git` doesn't exist: `git init`
3. Ask: "What are you building?" — use the response as the initial concept

---

## Step 2: Product Definition Grill

Ask these questions **sequentially** (one at a time, wait for response before next). Maximum 5 questions. For each question, provide 3 suggested answers plus a write-in option.

Topics to cover:
- **Product name** — What is the project called?
- **Tagline** — One-line description
- **Description** — What does it do? What problem does it solve?
- **Target audience** — Who is this for?
- **Key differentiators** — What makes this unique?

For Brownfield projects, pre-fill suggestions from the code analysis.

After gathering responses, draft `project-context.md` content for the Product Definition section. Present for review and approval before writing.

---

## Step 3: Product Guidelines Grill

Ask sequentially. Maximum 3 questions. Topics:

- **Brand voice** — Technical/casual/formal? Tone and personality.
- **UX principles** — Key design principles (e.g., "simplicity first", "mobile-first")
- **Accessibility** — Accessibility standards to follow (e.g., WCAG 2.1 AA)

Draft the Guidelines section for `project-context.md`. Present for review.

---

## Step 4: Tech Stack Grill

Ask sequentially. Maximum 5 questions. Topics:

- **Languages** — Primary programming language(s)
- **Frameworks** — Frontend/backend frameworks
- **Databases** — Data storage solutions
- **Deployment targets** — Where will this run? (cloud, self-hosted, edge, etc.)
- **Hosting** — Hosting provider/platform

For Brownfield projects, present the inferred stack and ask for confirmation rather than starting from scratch.

Draft the Tech Stack section for `project-context.md`. Present for review.

---

## Step 5: Code Style Guide Selection

List available style guides from `~/Hermes/TheOracle/templates/code_styleguides/`:

| Guide | File |
|-------|------|
| C++ | `cpp.md` |
| C# | `csharp.md` |
| Dart | `dart.md` |
| General | `general.md` |
| Go | `go.md` |
| HTML/CSS | `html-css.md` |
| JavaScript | `javascript.md` |
| Python | `python.md` |
| TypeScript | `typescript.md` |

**Recommend** guides based on the tech stack defined in Step 4. Ask the user to confirm or customize the selection.

> "Based on your tech stack, I recommend: {recommended guides}. Would you like to proceed with these, or customize the selection?"

---

## Step 6: Workflow Mode Selection

Present two workflow modes and ask the user to choose:

### Strict Mode
- **Best for:** Products, production apps, TDD-driven development
- Enforces test-driven development (write tests first)
- Requires phase completion verification
- Commit after every task
- Code coverage requirements
- Full spec → plan → implement cycle

### Light Mode
- **Best for:** Prototypes, websites, experiments, spikes
- No mandatory TDD
- Flexible commit cadence
- Simplified planning (no phase verification gates)
- Faster iteration, fewer guardrails

> "Which workflow mode fits this project?"

---

## Step 7: Create Directory Structure

Create the `conductor/` directory and its subdirectories:

```
conductor/
├── tracks/
├── pulse-archive/
└── code_styleguides/
```

Command: `mkdir -p conductor/tracks conductor/pulse-archive conductor/code_styleguides`

---

## Step 8: Copy Style Guides

Copy the selected style guides from `~/Hermes/TheOracle/templates/code_styleguides/` to `conductor/code_styleguides/`.

Example:
```bash
cp ~/Hermes/TheOracle/templates/code_styleguides/typescript.md conductor/code_styleguides/
cp ~/Hermes/TheOracle/templates/code_styleguides/general.md conductor/code_styleguides/
```

Always include `general.md` regardless of selection.

---

## Step 9: Copy Workflow Template

Based on the mode selected in Step 6:

- **Strict:** Copy `~/Hermes/TheOracle/templates/workflow-strict.md` → `conductor/workflow.md`
- **Light:** Copy `~/Hermes/TheOracle/templates/workflow-light.md` → `conductor/workflow.md`

---

## Step 10: Create `project-context.md`

Write `conductor/project-context.md` using the template at `~/Hermes/TheOracle/templates/project-context.md` as a base. Populate it with all information gathered during Steps 2–4.

The file should contain these sections:
```markdown
# Project Context

## Product Definition
- **Name:** {name}
- **Tagline:** {tagline}
- **Description:** {description}
- **Target Audience:** {audience}
- **Key Differentiators:** {differentiators}

## Product Guidelines
- **Brand Voice:** {voice}
- **UX Principles:** {principles}
- **Accessibility:** {standards}

## Tech Stack
- **Languages:** {languages}
- **Frameworks:** {frameworks}
- **Databases:** {databases}
- **Deployment Targets:** {targets}
- **Hosting:** {hosting}
```

---

## Step 11: Create Conductor Files

### `conductor/index.md`
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

### `conductor/relay.md`
```markdown
# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

---

## {YYYY-MM-DD HH:MM}
- **Session:** Initial setup
- **Status:** Project initialized with Conductor
- **Next:** Begin first track or define project scope
```

### `conductor/pulse.md`
```markdown
# Pulse — Current Project State

**Last Updated:** {current date}
**Session Focus:** Project initialization

## 🚀 Active Tracks
_No tracks yet. Create one with `/new-track`._

## ✅ Recently Completed
_None yet._

## ⚠️ Blockers
_None._

## 🧠 Session Memory
- Project initialized with Conductor

## 📋 Next Session Suggestions
- Create the first track with `/new-track`
- Review project-context.md for accuracy
```

### `conductor/tracks.md`
```markdown
# Tracks Registry

All tracks organized by domain. Each track links to its dedicated folder.

---

## 🗂️ Domain Structure

| Domain | Path | Caution Level |
|--------|------|---------------|
| _Define domains when creating tracks_ | | |

---

## Active Tracks

_No tracks yet._

## Completed Tracks

_None._
```

---

## Step 12: Deploy Workflow Files

Copy the Conductor workflow files to the project's `.agents/workflows/` directory so they are available as slash commands:

```bash
mkdir -p .agents/workflows
cp ~/Hermes/TheOracle/workflows/conductor.md .agents/workflows/
cp ~/Hermes/TheOracle/workflows/checkpoint.md .agents/workflows/
cp ~/Hermes/TheOracle/workflows/new-track.md .agents/workflows/
```

Each copied file already contains the `# Source: TheOracle v2.0` header.

---

## Step 13: Initial Track Generation (Optional)

Ask the user:
> "Would you like to create the first track now, or do that later with `/new-track`?"

If yes, invoke the `/new-track` workflow inline.
If no, skip to Step 14.

---

## Step 14: Git Commit

Stage all conductor files and commit:

```bash
git add conductor/ .agents/workflows/
git commit -m "chore: initialize conductor (TheOracle v2.0)"
```

Announce completion:
> "✅ Conductor initialized. Your project is ready."
> "Run `/conductor` to see status, or `/new-track` to create your first track."

