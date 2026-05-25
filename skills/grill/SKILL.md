---
name: grill
description: "Repeatable domain-refinement session for a Conductor-initialized project. Reads project-context.md, context.md, adr/, and prd.md, produces a 1-paragraph orientation summary, runs an interview loop, sharpens the domain glossary, and batches ADR proposals + optional PRD writes at the end of the command. Separate from the native /grill-me — this is the Conductor-aware variant that produces written output."
---

# Grill (Conductor)

Domain refinement, ADR batching, and lazy PRD writing for a project that has been through `/conductor-init`.

## Instructions

1. Read the [File Resolution Protocol](../../protocols/file-resolution.md) to locate conductor files in the project.
2. Read the [Index Sync Protocol](../../protocols/index-sync.md) — `/grill` is one of its writers.
3. Read and execute the [grill workflow](../../workflows/grill.md) step by step.

## When NOT to use

- The user wants the native Antigravity grill experience → use `/grill-me` instead.
- The project has no `conductor/` directory → tell the user to run `/conductor-init` first.
- The user wants to create a feature track → use `/new-track` (which itself is domain-aware on top of `/grill`'s output).
