<!-- Template: Orpheus v3.0 -->
# Project Context — Orpheus

> Single identity + operational document for this project.
>
> **Created by `/conductor-init`; user-edited thereafter — no command writes here.**
>
> Section order is deliberate: **identity-first (1–3), operational-second (4–8).**
> Agents partial-reading this file should see *what the product is* before *how to behave when working on it*.

---

## 1. Product Definition

- **Name:** Orpheus
- **Tagline:** Spec-driven development orchestrator for Merkurial-studio
- **Description:** Orpheus provides structured, spec-driven development workflows for any project. It scaffolds projects with consolidated identity documents, domain glossaries, and architectural decision records — then manages the full lifecycle of feature tracks from specification through implementation, review, and completion. It solves the problem of ad-hoc development processes by enforcing a disciplined but flexible workflow. Formerly TheOracle (≤ v2.1); v3.0 re-platforms from Google Antigravity to the Claude ecosystem (Claude Code + Cowork).
- **Target Audience:** Arnar Valur (sole developer at Merkurial-studio) — and the AI agents working alongside him.
- **Key Differentiators:** It's a conductor, not a copilot. It doesn't write code for you — it orchestrates the workflow around the code: spec, plan, implement, review, checkpoint. The agent follows the structure instead of improvising.

---

## 2. Product Guidelines

- **Brand Voice:** Technical and precise — documentation-grade. Clear section headers, YAML frontmatter contracts, markdown tables for structured data. No filler.
- **UX Principles:** Predictability first. Every Command does exactly what its contract says — no surprises, no side effects outside the declared writes list. Agents and humans can reason about behavior from the frontmatter alone.
- **Accessibility:** Markdown-first output — ensure all generated files render cleanly in Claude Code, Cowork, VS Code, GitHub, and Obsidian. No custom syntax that breaks standard renderers.

---

## 3. Tech Stack

- **Languages:** Markdown + YAML frontmatter + Shell when applicable
- **Frameworks:** Claude Code plugin system — Commands (slash), skills, Protocols, and plugin.json. Distributed via a git-sourced marketplace.
- **Databases:** Filesystem-as-database (conductor/ directory tree). If needed, basic JSON or similar bash key-value simplicity.
- **Deployment Targets:** Local + Git-distributed — the plugin installs once per machine and serves every project; conductor/ state travels with each repo.
- **Hosting:** No hosting — pure local plugin. Source repo at `~/Projects/Orpheus` on PlutoII.

---

## 4. Caution Levels

| Domain                              | Level       | Notes                                            |
|-------------------------------------|-------------|--------------------------------------------------|
| Commands (`.claude/commands/` + plugin) | 🔴 Critical | These ARE the product — breaking changes affect every project using Orpheus |
| Protocols (`protocols/`)            | 🔴 Critical | Shared, plugin-shipped procedures — changes cascade to all Commands |
| Templates                           | 🟡 Careful  | Affect new projects only, but set expectations   |
| Skills (SKILL.md)                   | 🟡 Careful  | Entry points for slash commands — must match Commands |
| Design briefs                       | 🟢 Normal   | Reference documents — read-only in practice      |
| conductor/ files                    | 🟡 Careful  | Source of truth — don't corrupt                  |
| plugin.json                         | 🔴 Critical | Plugin identity — version bumps have meaning     |

---

## 5. Domain Expertise

| Area                        | Confidence | Notes                                              |
|-----------------------------|------------|----------------------------------------------------|
| Claude Code Plugin System   | Medium     | Orpheus v3.0 is built on it — Commands, skills, Protocols, plugin.json, marketplaces |
| Markdown document systems   | High       | The entire product is structured markdown          |
| YAML frontmatter contracts  | High       | Reader/writer contracts drive Command predictability |
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

- **Self-hosting:** Orpheus must be able to manage itself via its own conductor/ directory. Avoid circular references in Commands. (Orpheus self-hosts under **Light** workflow mode — ADR 0006.)
- **No runtime dependencies:** Orpheus is pure markdown + shell. No npm, no pip, no build step.
- **Version discipline:** plugin.json version must be bumped with every release. Source files carry `# Source: Orpheus v{version} @ {date}` headers.
- **Backward compatibility:** the v2.x → v3.0 migration path must be preserved (via `/conductor-init` + `protocols/migrate.md`, ADR 0003/0004). Don't break re-init on older conductors.

---

## 8. Environment Notes

- **Source location:** `~/Projects/Orpheus` on PlutoII (Pop!_OS, user `solmundur`)
- **Plugin distribution:** git-sourced Claude Code marketplace (the Orpheus repo) — exact install mechanics finalized in the v3.0 packaging phase. One install serves Claude Code CLI + Cowork.
- **Template source:** `~/Projects/Orpheus/templates/` — style guides, workflow templates, project-context template. Bundled inside the plugin.
- **Cross-machine sync:** conductor/ state + plugin travel via Git between PlutoII and Saturn (ASUS Ascent GX10, user `arnar`, `ssh saturn`).
- **Git:** Single `main` branch. Tracks are logical (`conductor/tracks/`), not Git branches.
