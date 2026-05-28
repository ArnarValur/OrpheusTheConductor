<!-- Template: TheOracle v2.1 -->
# Project Context — TheOracle

> Single identity + operational document for this project.
>
> **Created by `/conductor-init`; user-edited thereafter — no command writes here.**
>
> Section order is deliberate: **identity-first (1–3), operational-second (4–8).**
> Agents partial-reading this file should see *what the product is* before *how to behave when working on it*.

---

## 1. Product Definition

- **Name:** TheOracle
- **Tagline:** Spec-driven development orchestrator for Merkurial-studio
- **Description:** TheOracle provides structured, spec-driven development workflows for any project. It scaffolds projects with consolidated identity documents, domain glossaries, and architectural decision records — then manages the full lifecycle of feature tracks from specification through implementation, review, and completion. It solves the problem of ad-hoc development processes by enforcing a disciplined but flexible workflow.
- **Target Audience:** Arnar Valur (sole developer at Merkurial-studio) — and the AI agents working alongside him.
- **Key Differentiators:** It's a conductor, not a copilot. It doesn't write code for you — it orchestrates the workflow around the code: spec, plan, implement, review, checkpoint. The agent follows the structure instead of improvising.

---

## 2. Product Guidelines

- **Brand Voice:** Technical and precise — documentation-grade. Clear section headers, YAML frontmatter contracts, markdown tables for structured data. No filler.
- **UX Principles:** Predictability first. Every command does exactly what its contract says — no surprises, no side effects outside the declared writes list. Agents and humans can reason about behavior from the frontmatter alone.
- **Accessibility:** Markdown-first output — ensure all generated files render cleanly in Antigravity, VS Code, GitHub, and Obsidian. No custom syntax that breaks standard renderers.

---

## 3. Tech Stack

- **Languages:** Markdown + YAML frontmatter + Shell when applicable
- **Frameworks:** Google Antigravity 2.0 plugin system — skills, workflows, protocols, and plugin.json
- **Databases:** Filesystem-as-database (conductor/ directory tree). If needed, basic JSON or similar bash key-value simplicity.
- **Deployment Targets:** Local + Git-distributed — plugin lives locally, conductor/ state travels with the repo
- **Hosting:** No hosting — pure local plugin. Source repo at ~/Hermes/TheOracle on PlutoII.

---

## 4. Caution Levels

| Domain                  | Level       | Notes                                            |
|-------------------------|-------------|--------------------------------------------------|
| Workflows (`.agents/`)  | 🔴 Critical | These ARE the product — breaking changes affect every project using TheOracle |
| Protocols               | 🔴 Critical | Shared contracts — changes cascade to all workflows |
| Templates               | 🟡 Careful  | Affect new projects only, but set expectations   |
| Skills (SKILL.md)       | 🟡 Careful  | Entry points for slash commands — must match workflows |
| Design briefs           | 🟢 Normal   | Reference documents — read-only in practice      |
| conductor/ files        | 🟡 Careful  | Source of truth — don't corrupt                  |
| plugin.json             | 🔴 Critical | Plugin identity — version bumps have meaning     |

---

## 5. Domain Expertise

| Area                        | Confidence | Notes                                              |
|-----------------------------|------------|----------------------------------------------------|
| Antigravity Plugin System   | High       | TheOracle is built on it — skills, workflows, plugin.json |
| Markdown document systems   | High       | The entire product is structured markdown          |
| YAML frontmatter contracts  | High       | Reader/writer contracts drive workflow predictability |
| Domain-Driven Design (DDD)  | Medium     | Borrowed concepts: bounded contexts, glossaries, ubiquitous language |
| Git workflow orchestration  | Medium     | Commits, branching via tracks — but not a Git tool |

---

## 6. Preferred Workflows

1. **Session Start Protocol:**
   - Read `conductor/relay.md` first (pending messages, blockers)
   - Then read `conductor/pulse.md` (current state, recent progress)
   - Review `conductor/tracks.md` for next task

2. **Checkpoint Frequency:**
   - Checkpoint after every completed phase
   - Consider mid-phase checkpoints for long phases (>5 tasks)

3. **Decision Logging:**
   - Architectural decisions live in `conductor/adr/` (batched by `/grill`, `/new-track`, or `/checkpoint`)
   - Operational notes live in `conductor/pulse.md` Session Memory
   - Verify actual state on disk before proposing changes

4. **Debugging Protocol:**
   - Check legacy interference before blaming new code
   - If a fix fails twice, stop and escalate
   - Audit actual state vs documented state

---

## 7. Project-Specific Constraints

- **Self-hosting:** TheOracle must be able to manage itself via its own conductor/ directory. Avoid circular references in workflows.
- **No runtime dependencies:** TheOracle is pure markdown + shell. No npm, no pip, no build step.
- **Version discipline:** plugin.json version must be bumped with every release. Workflow files carry `# Source: TheOracle v{version} @ {date}` headers.
- **Backward compatibility:** v2.0 → v2.1 migration path must be preserved. Don't break re-init on older conductors.

---

## 8. Environment Notes

- **Source location:** `~/Hermes/TheOracle` on PlutoII (Pop!_OS, user `solmundur`)
- **Plugin install path:** `~/.gemini/config/plugins/the-oracle` (symlinked or copied)
- **Template source:** `~/Hermes/TheOracle/templates/` — style guides, workflow templates, project-context template
- **Workflow deploy target:** Per-project `.agents/workflows/` directory
- **Git:** Single `main` branch. Tracks are logical (conductor/tracks/), not Git branches.
