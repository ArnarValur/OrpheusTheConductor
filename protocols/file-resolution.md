# File Resolution Protocol

**PROTOCOL: How to locate conductor files within any project.**

To find a file (e.g., "**Product Definition**") within a specific context (Project Root or a specific Track):

## Step 1: Identify Index

Determine the relevant index file:

- **Project Context:** `conductor/index.md`
- **Track Context:**
  1. Resolve and read the **Tracks Registry** (via Project Context)
  2. Find the entry for the specific `<track_id>`
  3. Follow the link provided in the registry to locate the track's folder. The index file is `<track_folder>/index.md`
  4. **Fallback:** If the track is not yet registered (e.g., during creation) or the link is broken:
     1. Resolve the **Tracks Directory** (via Project Context)
     2. The index file is `<Tracks Directory>/<track_id>/index.md`

## Step 2: Check Index

Read the index file and look for a link with a matching or semantically similar label.

## Step 3: Resolve Path

If a link is found, resolve its path **relative to the directory containing the `index.md` file**.

*Example:* If `conductor/index.md` links to `./workflow.md`, the full path is `conductor/workflow.md`.

## Step 4: Fallback

If the index file is missing or the link is absent, use the **Default Path** keys below.

## Step 5: Verify

You MUST verify the resolved file actually exists on the disk.

## Default Paths (Project)

| Document | Default Path |
|----------|-------------|
| **Product Definition** | `conductor/product.md` |
| **Tech Stack** | `conductor/tech-stack.md` |
| **Workflow** | `conductor/workflow.md` |
| **Product Guidelines** | `conductor/product-guidelines.md` |
| **Project Context** | `conductor/project-context.md` |
| **Tracks Registry** | `conductor/tracks.md` |
| **Tracks Directory** | `conductor/tracks/` |
| **Pulse** | `conductor/pulse.md` |
| **Relay** | `conductor/relay.md` |
| **Agent Rules** | `conductor/agent-rules/` |

## Default Paths (Track)

| Document | Default Path |
|----------|-------------|
| **Specification** | `conductor/tracks/<domain>/<track_id>/spec.md` |
| **Implementation Plan** | `conductor/tracks/<domain>/<track_id>/plan.md` |
| **Metadata** | `conductor/tracks/<domain>/<track_id>/metadata.json` |
