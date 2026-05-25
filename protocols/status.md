# Protocol: Status

<!-- Source: TheOracle v2.1 @ 2026-05-25 -->

> Displays current progress across all tracks and tasks.

## 1.0 System Directive

You are an AI agent. Your function is to provide a status overview of the project's tracks, their implementation progress, and the project's domain-knowledge surface.

**CRITICAL:** Validate every tool call. Halt on failure.

---

## 1.1 Setup Check

Using the [File Resolution Protocol](./file-resolution.md), resolve and verify (required):

- **Tracks Registry** (`conductor/tracks.md`)
- **Product & Operational Context** (`conductor/project-context.md`)
- **Workflow** (`conductor/workflow.md`)

If ANY missing → Halt with setup instructions.

Load v2.1 lazy context (absence is valid; counts feed the status report):

- **Domain Glossary** (`conductor/context.md`) — count entities
- **Product Requirements** (`conductor/prd.md`) — present / absent
- **ADR Directory** (`conductor/adr/*.md`) — count + most recent
- **Documentation** (`conductor/docs/`) — file count (no content read)

---

## 2.0 Status Overview

### 2.1 Read Project Plan

1. Read the Tracks Registry
2. Parse to identify all registered tracks and their paths
   - Match lines in both formats: `- [ ] **Track:` (standard) and `## [ ] Track:` (legacy)
3. For each track: resolve and read its Implementation Plan

### 2.2 Parse and Summarize

1. Identify phases (top-level headings) and tasks (bullet points with status markers)
2. Count: total phases, total tasks, completed `[x]`, in-progress `[~]`, pending `[ ]`

### 2.3 Present Status

Output a structured report:

```markdown
# Project Status Report

**Date:** <current timestamp>
**Project Status:** On Track / Behind Schedule / Blocked

## Current Work
- **Active Track:** <track description>
- **Current Phase:** <phase name>
- **Current Task:** <task marked [~]>
- **Next Action:** <next task marked [ ]>

## Blockers
<any items marked as blockers in relay.md, or "None">

## Progress Summary
| Track | Domain | Phases | Tasks | Completed | In Progress | Pending | Progress |
|-------|--------|--------|-------|-----------|-------------|---------|----------|
| <name> | <domain> | N | N | N | N | N | N/N (X%) |

**Overall:** X/Y tasks completed (Z%)
```
