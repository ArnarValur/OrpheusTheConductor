<!-- Template: TheOracle v2.0 -->
# Project Context — <Project Name>

> Operational context for this project. Customize per conductor branch.
> Persona and communication style are handled separately — this file is purely operational.

---

## Caution Levels

| Domain              | Level       | Notes                                   |
|---------------------|-------------|-----------------------------------------|
| UI / Pages          | 🟡 Careful  | Visual impact — verify rendering        |
| Config / Build      | 🔴 Critical | Can break everything — verify before    |
| Shared packages     | 🔴 Critical | Cross-project impact                    |
| Firebase Functions  | 🔴 Critical | ALWAYS `europe-west1` — never `us-central1` |
| Content / Assets    | 🟢 Normal   | Low risk                                |
| conductor/ files    | 🟡 Careful  | Source of truth — don't corrupt         |

---

## Domain Expertise

<!-- Customize for this project -->

| Area                | Confidence  | Notes                                   |
|---------------------|-------------|-----------------------------------------|
| <!-- e.g. Nuxt 4 -->     | <!-- High/Medium/Low --> | <!-- specifics -->             |
| <!-- e.g. Firebase -->    | <!-- High/Medium/Low --> | <!-- specifics -->             |
| <!-- e.g. Tailwind -->    | <!-- High/Medium/Low --> | <!-- specifics -->             |

---

## Preferred Workflows

1. **Session Start Protocol:**
   - Read `conductor/relay.md` first (pending messages, blockers)
   - Then read `conductor/pulse.md` (current state, recent progress)
   - Review `conductor/tracks.md` for next task

2. **Checkpoint Frequency:**
   - Checkpoint after every completed phase
   - Consider mid-phase checkpoints for long phases (>5 tasks)

3. **Decision Logging:**
   - Log non-obvious decisions in git notes
   - Update `pulse.md` after every major step
   - Verify actual state on disk before proposing changes

4. **Debugging Protocol:**
   - Check legacy interference before blaming new code
   - If a fix fails twice, stop and escalate
   - Audit actual state vs documented state

---

## Project-Specific Constraints

<!-- Add constraints unique to this project -->

<!--
Examples:
- Region lock: All cloud functions must deploy to europe-west1
- Browser support: Must support Safari 16+
- Performance: First paint under 2s on 4G
- Data: No user data in logs
- Dependencies: Pin all major versions
-->

---

## Environment Notes

<!-- Add any environment-specific details -->

<!--
Examples:
- Dev server runs on port 3000
- Uses .env.local for secrets (not committed)
- Requires Node 20+
- Database: PostgreSQL 15 on localhost:5432
-->
