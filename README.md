# Orpheus v3.4

> A conductor, not a copilot.

Orpheus is a Claude Code plugin that runs the workflow around your code: **spec → plan → implement → review → checkpoint**. It doesn't write the code. It keeps each project's plans, decisions and progress in a `conductor/` folder that lives in git.

Pure markdown and shell. No dependencies.

## Install

```
/plugin marketplace add ArnarValur/OrpheusTheConductor
/plugin install orpheus@merkurial-studio
```

## Commands

| Command | What it does |
|---------|--------------|
| `/conductor-init` | Sets up `conductor/` in a project, or upgrades an old one without losing anything. Also links it as an Obsidian vault if `~/Documents/Project-Vaults/` exists. |
| `/conductor` | Starts a session: loads the current state and reports where things stand. |
| `/grill` | Sharpens the project's vocabulary, decisions and requirements. |
| `/new-track` | Starts a new feature with a spec and a step-by-step plan. |
| `/checkpoint` | Saves the session: updates state, logs what happened, merges to main. |

Plus **drift-watchdog**, a background agent that warns when the conductor falls out of date. It never edits files.

## The `conductor/` folder

| File | Holds |
|------|-------|
| `pulse.md` | Where things stand right now |
| `relay.md` | A short log of each session |
| `tracks/` | One folder per feature: spec and plan |
| `adr/` | Decisions and why they were made |
| `context.md` | The project's vocabulary |
| `prd.md` | What the product should do |
| `agent-rules/` | Lessons learned |

Want the notes private? Make `conductor/` its own git repo and ignore it in the main one. Orpheus then commits there instead.

## License

MIT. See [LICENSE](./LICENSE).
