# Source: TheOracle v2.0 @ 2026-05-22

---
name: conductor
description: Resume Conductor — load project context, display status, and await orders
---

# 🎵 Conductor — Resume Protocol

When the user invokes `/conductor`, execute the following sequence to restore session context and present actionable status.

---

## Step 1: Load Context

Read the following files from the project's `conductor/` directory. If any file is missing, note it but do not halt — the project may be partially initialized.

| File | Purpose |
|------|---------|
| `conductor/relay.md` | Cross-session handoff messages and context |
| `conductor/pulse.md` | Current project state, recent decisions, next steps |
| `conductor/tracks.md` | All tracks organized by domain |
| `conductor/project-context.md` | Product definition, tech stack, guidelines |

Additionally, read these if they exist:
- `conductor/workflow.md` — Workflow rules and conventions
- `conductor/agent-rules/*.md` — Book-sourced coding rules (if present, read all `.md` files in this directory)

> **IMPORTANT:** If `conductor/` does not exist at all, halt immediately and tell the user:
> "Conductor is not initialized. Run `/conductor-init` to set up the project."

---

## Step 2: Status Report

Invoke the status protocol by reading and executing `~/Hermes/TheOracle/protocols/status.md`.

The status report should present:

```
🎵 Conductor Online

📍 Last Session: {date from pulse.md} — {focus}
🔄 Active Tracks: {count}
⚠️ Blockers: {count or "None"}

Quick Status:
{list of active tracks with one-line status each}

Ready for orders, Captain. What's our heading?
```

Parse `conductor/tracks.md` to identify all registered tracks and their paths. For each active track, read its `metadata.json` and `plan.md` to determine:
- Current phase and task in progress
- Overall progress (tasks completed / total)
- Any blockers

---

## Step 3: Await Orders

Present the following options to the user:

| Action | Description |
|--------|-------------|
| **Implement** | Pick a track and start working on tasks from its `plan.md` |
| **Review** | Review completed work on a track |
| **New Track** | Create a new track → invoke `/new-track` |
| **Checkpoint** | Save session state → invoke `/checkpoint` |
| **Revert** | Roll back recent changes on a track |

Wait for the user's selection and proceed accordingly:

- **Implement** → Load the selected track's `plan.md`, find the next pending task, and begin implementation. Follow the workflow rules in `conductor/workflow.md`.
- **Review** → Read the track's `spec.md` and `plan.md`, verify completed tasks against acceptance criteria, and present a review summary.
- **New Track** → Tell the user to invoke `/new-track` or begin the new-track protocol inline.
- **Checkpoint** → Tell the user to invoke `/checkpoint` or begin the checkpoint protocol inline.
- **Revert** → Identify the target track and changes to revert. Confirm with the user before executing any destructive operations.

---

## Session Behavior

Once initialized, maintain awareness of:
- Current track context throughout the session
- Workflow rules from `conductor/workflow.md`
- Domain-specific caution levels from `conductor/tracks.md`
- Any blockers or urgent items from `conductor/pulse.md`
