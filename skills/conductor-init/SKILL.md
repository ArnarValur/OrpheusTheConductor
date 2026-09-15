---
name: conductor-init
description: "Initialize Conductor in a project. Scaffolds the v3.1 shape: state-only pulse, story-only relay, workflow with the two laws, static index, and self-contained /conductor + /checkpoint commands, and wires an Obsidian vault wrapper (conductor + memory symlinks) under ~/Documents/Project-Vaults/ when that folder exists. On existing conductors, upgrades structure in place (preserving all state) and hands the human a migration checklist. Use when starting a new project or upgrading an existing one."
---

# Conductor Init

Scaffold a Conductor-managed project through an interactive setup sequence. On brownfield projects, performs a targeted domain scan to pre-populate `conductor/context.md`. On existing conductors, upgrades structural files in place — all state is preserved and reshaping is handed to the human as a checklist.

## Instructions

1. Conductor files live under `conductor/` in the project root. All conductor-related reads and writes target this directory.
2. Read and execute the [conductor-init workflow](./workflow.md) step by step.
