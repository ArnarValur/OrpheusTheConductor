#!/usr/bin/env bash
# Orpheus /conductor-init Step 13b — link the conductor as an Obsidian vault.
# Run from the project root. Idempotent. Skips when ~/Documents/Project-Vaults/ is absent (that folder is the opt-in).
#   ~/Documents/Project-Vaults/<project> -> <repo>/conductor                  (the vault IS the conductor — never a copy)
#   <repo>/conductor/memory              -> ~/.claude/projects/<slug>/memory  (Claude's auto-memory, gitignored)
set -u

root="$HOME/Documents/Project-Vaults"
[ -d "$root" ] || { echo "🗂️ Obsidian vault skipped — $root not present"; exit 0; }
[ -d conductor ] || { echo "⚠️ No conductor/ in $PWD — run this from the project root"; exit 1; }

project="$(basename "$PWD")"
slug="$(printf '%s' "$PWD" | sed 's#[^A-Za-z0-9]#-#g')"   # Claude Code's per-project memory folder name
mem="$HOME/.claude/projects/$slug/memory"

# Never replace a real folder — a symlink is the only shape either path may have.
for p in "conductor/memory" "$root/$project"; do
  if [ -e "$p" ] && [ ! -L "$p" ]; then
    echo "⚠️ $p is a real folder — move it away, then re-run this step"; exit 1
  fi
done

mkdir -p "$mem"
ln -sfn "$mem" "$PWD/conductor/memory"

# Gitignore the memory link. Append only (never replace a .gitignore), and commit that one path
# with a pathspec so nothing else that happens to be staged rides along.
if [ -d conductor/.git ]; then   # private conductor repo: the ignore lives inside it
  if ! grep -qx 'memory' conductor/.gitignore 2>/dev/null; then
    printf '\n# Claude auto-memory symlink (machine-local, never commit)\nmemory\n' >> conductor/.gitignore
    git -C conductor add .gitignore && git -C conductor commit -qm "chore: gitignore memory symlink" -- .gitignore
  fi
elif ! grep -qx 'conductor/memory' .gitignore 2>/dev/null; then
  printf '\n# Claude auto-memory symlink (machine-local, never commit)\nconductor/memory\n' >> .gitignore
  git add .gitignore && git commit -qm "chore: gitignore conductor/memory symlink" -- .gitignore
fi

ln -sfn "$PWD/conductor" "$root/$project"
echo "🗂️ Obsidian vault linked: $root/$project -> $PWD/conductor (memory inside)"
