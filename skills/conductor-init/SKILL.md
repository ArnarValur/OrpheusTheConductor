---
name: conductor-init
description: "Initialize Conductor in a project (TheOracle v2.1). Scaffolds structured development with a consolidated identity + operational context, tech stack, workflow mode, code style guides, lazy adr/ and docs/ directories, and optional brownfield targeted-domain scan that pre-populates context.md. Migrates v2.0 conductors to v2.1 in place without clobbering tracks/pulse/relay. Use when starting a new project or upgrading an existing one to v2.1."
---

# Conductor Init (v2.1)

Scaffold a Conductor-managed project through an interactive grill. On brownfield projects, performs a targeted domain scan to pre-populate `conductor/context.md`. On existing v2.0 conductors, performs the v2.0 → v2.1 in-place migration (D9 from the design brief).

## Instructions

1. Read the [File Resolution Protocol](../../protocols/file-resolution.md) to understand conductor file locations.
2. Read the [Index Sync Protocol](../../protocols/index-sync.md) — `conductor-init` is one of its writers (initial `index.md` + conditional appends when brownfield scan or `.docs/` migration runs).
3. Read and execute the [conductor-init workflow](../../workflows/conductor-init.md) step by step.
