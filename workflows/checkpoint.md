# Source: TheOracle v2.0 @ 2026-05-22

---
name: checkpoint
description: Save session state — update pulse, archive if needed, commit changes
---

# 🎵 Checkpoint — Save Session State

When the user invokes `/checkpoint`, execute this sequence to persist the current session state.

Supports `--quick` flag: `/checkpoint --quick` skips the decision log step (Step 3).

---

## Step 1: Session Summary

Determine the session focus. Either:
- Infer from conversation context (preferred), or
- Ask the user: "What was the main focus of this session?"

Gather:
- What was worked on
- What was completed
- What is still in progress
- Any decisions made
- Suggested next steps

---

## Step 2: Update `conductor/pulse.md`

Update the following sections in `conductor/pulse.md`:

```markdown
**Last Updated:** {current timestamp}
**Session Focus:** {summary}

## 🚀 Active Tracks
## ✅ Recently Completed
## ⚠️ Blockers
## 🧠 Session Memory
## 📋 Next Session Suggestions
```

These section names are parsed by Conductor. **Do not rename them.**

### 200-Line Archiving Guardrail

After updating, check if `pulse.md` exceeds 200 lines. If it does:

1. **Session Memory:** Keep only the **last 2 sessions**. Move older entries to `conductor/pulse-archive/{YYYY-MM-DD}.md`
2. **Recently Completed:** Keep only the **last 5 entries**. Move older rows to the same archive file
3. Add a reference below each trimmed section:
   > 📦 Full history: `conductor/pulse-archive/{YYYY-MM-DD}.md`
4. Archive files are **append-only** — add new archived content at the bottom of existing files

---

## Step 3: Decision Log Update

> **Skipped with `--quick` flag.**

If any architectural, design, or significant technical decisions were made during the session, append them to the Session Memory section in `pulse.md`:

```markdown
### Decision: {title}
- **Date:** {date}
- **Context:** {why this decision was needed}
- **Decision:** {what was decided}
- **Rationale:** {why this option was chosen}
- **Alternatives considered:** {other options}
```

---

## Step 4: Track Status Check

For any tracks worked on during this session:

1. Update the track's `plan.md` — mark completed tasks with `[x]`
2. Update `metadata.json` — set `status` and `updated_at` fields
3. If a track is fully completed:
   - Update `metadata.json` status to `completed`
   - Move the track entry from "Active Tracks" to "Completed Tracks" in `conductor/tracks.md`

---

## Step 5: Relay Handoff Entry

Append a timestamped entry to `conductor/relay.md`:

```markdown
## {YYYY-MM-DD HH:MM}
- **Session:** {focus summary}
- **Tracks touched:** {list of track IDs}
- **Status:** {brief status}
- **Decisions:** {key decisions or "None"}
- **Next:** {suggested next actions}
```

---

## Step 6: Git Commit

Stage and commit all conductor changes:

```bash
git add conductor/
git commit -m "checkpoint: {brief summary}"
```

---

## Step 7: Confirm

Tell the user:

> "✅ Checkpoint saved. Session state captured in `pulse.md`."
>
> **Options:**
> - Continue working on current track
> - Switch to a different track
> - End session
