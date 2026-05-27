---
name: conductor-init
description: "Initialize Conductor in a project. Scaffolds structured development with project context, tech stack, workflow mode, code style guides, and domain scan. Migrates existing conductors in place without clobbering tracks/pulse/relay. Use when starting a new project or upgrading an existing one."
---

# Conductor Init

Scaffold a Conductor-managed project through an interactive setup sequence. On brownfield projects, performs a targeted domain scan to pre-populate `conductor/context.md`. On existing conductors, performs an in-place migration preserving all user data.

## Instructions

1. Conductor files live under `conductor/` in the project root. All conductor-related reads and writes target this directory.
2. Read and execute the [conductor-init workflow](../../workflows/conductor-init.md) step by step.
