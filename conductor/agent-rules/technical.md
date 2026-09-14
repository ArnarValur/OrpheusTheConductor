# Technical Rules

> Lessons about the code, stack, or tooling — graduated automatically at checkpoints.

- **Test a consumer install in an isolated `HOME`.** `HOME=<scratch> claude plugin marketplace add <repo-or-path>` → `claude plugin install orpheus@merkurial-studio` → `claude plugin details orpheus` proves the component inventory (Skills / Agents) without touching the real `~/.claude`. Use the git remote to see what consumers get; a local path to test the working tree. _(graduated 2026-09-15)_
- **Test an Agent before it is installed.** Run its markdown body through the Agent tool (`general-purpose`, `model: sonnet`) against a scratch clone seeded with the condition under test (e.g. 3 code-only commits). Cheap, reproducible, no plugin reinstall needed. _(graduated 2026-09-15)_
- **`claude plugin details` is not proof of what sessions load.** It reads the marketplace source (here: this working tree). The truth is `~/.claude/plugins/installed_plugins.json` + the cache dir it names — that copy sat at 3.0.0 for two months while `details` said 3.1/3.2. `claude plugin update` fails with "not found" on this local-path marketplace; refresh with `claude plugin uninstall orpheus` → `claude plugin install orpheus@merkurial-studio`, then check the cache. _(graduated 2026-09-15)_
