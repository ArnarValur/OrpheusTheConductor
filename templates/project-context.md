<!-- Template: Orpheus v3.1 -->
# Project Context — <Project Name>

> Single identity + operational document for this project.
>
> **Created at init; user-edited thereafter — no command writes here.**
>
> Section order is deliberate: **identity-first (1–3), operational-second (4–8).**
> Agents partial-reading this file should see *what the product is* before *how to behave when working on it*.

---

## 1. Product Definition

<!-- Identity. Populated at init (Product Definition grill). -->

- **Name:** <Product name>
- **Tagline:** <One-line description>
- **Description:** <What does it do? What problem does it solve?>
- **Target Audience:** <Who is this for?>
- **Key Differentiators:** <What makes this unique?>

---

## 2. Product Guidelines

<!-- Brand voice, UX principles, accessibility. Populated at init. -->

- **Brand Voice:** <Technical / casual / formal — tone and personality>
- **UX Principles:** <e.g. "simplicity first", "mobile-first", "keyboard-accessible">
- **Accessibility:** <e.g. WCAG 2.1 AA>

---

## 3. Tech Stack

<!-- Languages, frameworks, deployment. Populated at init. -->

- **Languages:** <Primary programming language(s)>
- **Frameworks:** <Frontend / backend frameworks>
- **Databases:** <Data storage solutions>
- **Deployment Targets:** <Where this runs — cloud, self-hosted, edge>
- **Hosting:** <Hosting provider / platform>

---

## 4. Caution Levels

<!-- Customize per project — replace the example rows with this project's real domains.
     Do NOT record live infrastructure facts (regions, ports, hosts) here as permanent
     truths; enumerate live state where the work happens, and keep hard constraints in
     §7 Project-Specific Constraints. -->

| Domain              | Level       | Notes                                   |
|---------------------|-------------|-----------------------------------------|
| UI / Pages          | 🟡 Careful  | Visual impact — verify rendering        |
| Config / Build      | 🔴 Critical | Can break everything — verify before    |
| Shared packages     | 🔴 Critical | Cross-project impact                    |
| Content / Assets    | 🟢 Normal   | Low risk                                |
| conductor/ files    | 🟡 Careful  | Source of truth — don't corrupt         |

---

## 5. Domain Expertise

<!-- Customize for this project -->

| Area                | Confidence  | Notes                                   |
|---------------------|-------------|-----------------------------------------|
| <!-- e.g. Nuxt 4 -->     | <!-- High/Medium/Low --> | <!-- specifics -->             |
| <!-- e.g. Firebase -->    | <!-- High/Medium/Low --> | <!-- specifics -->             |
| <!-- e.g. Tailwind -->    | <!-- High/Medium/Low --> | <!-- specifics -->             |

---

## 6. Preferred Workflows

1. **Session Start Protocol:**
   - Boot with `/conductor` — it loads the hot set (pulse, last relay entry, tracks one-liners, workflow, behavioral rules, glossary) and nothing else
   - Warm-load track plans, ADRs, and technical rules only when work enters their domain

2. **Checkpoint Frequency:**
   - Checkpoint after every completed phase
   - Consider mid-phase checkpoints for long phases (>5 tasks)

3. **Decision Logging:**
   - Architectural decisions live in `conductor/adr/` — proposed and approved in-session, written at `/checkpoint`
   - Live state lives in `conductor/pulse.md`; the session story in `conductor/relay.md`; lessons in `conductor/agent-rules/`
   - Verify actual state on disk before proposing changes

4. **Debugging Protocol:**
   - Check legacy interference before blaming new code
   - If a fix fails twice, stop and escalate
   - Audit actual state vs documented state

---

## 7. Project-Specific Constraints

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

## 8. Environment Notes

<!-- Add any environment-specific details -->

<!--
Examples:
- Dev server runs on port 3000
- Uses .env.local for secrets (not committed)
- Requires Node 20+
- Database: PostgreSQL 15 on localhost:5432
-->
