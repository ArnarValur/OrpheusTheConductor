#!/bin/sh
# Orpheus release & template-sync check (POSIX sh).
# Prints one line per check. Degrades quietly when ~/.claude or remotes are absent.
# Exits non-zero only on a real failure (manifest mismatch, command drift, or behind remote).
set -u

cd "$(dirname "$0")/.." || exit 1
rc=0

# 1. Manifest versions (.claude-plugin/plugin.json == .claude-plugin/marketplace.json)
p_ver=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' .claude-plugin/plugin.json | head -n 1)
m_ver=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' .claude-plugin/marketplace.json | head -n 1)
if [ -n "$p_ver" ] && [ "$p_ver" = "$m_ver" ]; then
  printf 'OK   manifests: plugin.json = marketplace.json (%s)\n' "$p_ver"
else
  printf 'FAIL manifests: plugin.json (%s) != marketplace.json (%s)\n' "${p_ver:-missing}" "${m_ver:-missing}"
  rc=1
fi

# 2. Self-host commands (.claude/commands/ == templates/commands/ minus <!-- Template: header)
if [ ! -d .claude/commands ]; then
  printf 'SKIP .claude/commands: directory not present\n'
else
  bad=""
  for c in conductor checkpoint; do
    if [ ! -f ".claude/commands/$c.md" ] || ! grep -v '^<!-- Template:' "templates/commands/$c.md" | diff -q - ".claude/commands/$c.md" >/dev/null 2>&1; then
      bad="${bad:+$bad, }$c.md"
    fi
  done
  if [ -z "$bad" ]; then
    printf 'OK   self-host commands: .claude/commands/{conductor,checkpoint}.md match templates\n'
  else
    printf 'FAIL self-host commands: drift in %s\n' "$bad"
    rc=1
  fi
fi

# 3. Plugin commands (commands/ vs templates/commands/ allowlist: /conductor-init, old-shape guard, header comment)
allow='^(<!-- (Template|Plugin copy)|.*(/conductor-init|Old-shape guard:|perform the migration|`conductor/` is missing — recover it from git history))'
bad=""
for c in conductor checkpoint; do
  if grep -v '^<!-- Template:' "templates/commands/$c.md" 2>/dev/null | grep -q '/conductor-init'; then
    bad="${bad:+$bad, }templates/$c.md(mentions /conductor-init)"
    continue
  fi
  unallowed=$(diff "templates/commands/$c.md" "commands/$c.md" 2>/dev/null \
    | sed -n 's/^[<>] //p' | grep -v '^$' \
    | grep -vE "$allow" || true)
  if [ -n "$unallowed" ]; then
    bad="${bad:+$bad, }$c.md"
  fi
done
if [ -z "$bad" ]; then
  printf 'OK   plugin commands: commands/{conductor,checkpoint}.md match allowlist divergences\n'
else
  printf 'FAIL plugin commands: unexpected divergence in %s\n' "$bad"
  rc=1
fi

# 4. Installed plugin cache version (~/.claude/plugins/installed_plugins.json vs plugin.json)
inst_file="${HOME:-}/.claude/plugins/installed_plugins.json"
if [ ! -f "$inst_file" ]; then
  printf 'SKIP installed cache: %s not present\n' "$inst_file"
else
  i_ver=$(awk '/"orpheus@merkurial-studio"/{f=1} f && /"version"/{gsub(/.*"version"[[:space:]]*:[[:space:]]*"|".*/,""); print; exit}' "$inst_file")
  if [ -z "$i_ver" ]; then
    printf 'SKIP installed cache: orpheus@merkurial-studio not found in installed_plugins.json\n'
  elif [ "$i_ver" = "$p_ver" ]; then
    printf 'OK   installed cache: %s matches plugin.json (%s)\n' "$i_ver" "$p_ver"
  else
    printf 'WARN installed cache: installed is %s, plugin.json is %s (refresh install after push)\n' "$i_ver" "$p_ver"
  fi
fi

# 5. Git working tree & remote status (plugin repo + private conductor repo when present)
for dir in . conductor; do
  [ "$dir" = "conductor" ] && [ ! -d conductor/.git ] && continue
  label="plugin repo"
  [ "$dir" = "conductor" ] && label="conductor repo"
  if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'SKIP git (%s): not a git worktree\n' "$label"
    continue
  fi
  dirty=$(git -C "$dir" status --porcelain 2>/dev/null || true)
  sync="no-upstream"
  if git -C "$dir" rev-parse --verify origin/main >/dev/null 2>&1; then
    counts=$(git -C "$dir" rev-list --left-right --count origin/main...HEAD 2>/dev/null || true)
    behind=$(printf '%s' "$counts" | awk '{print $1}')
    ahead=$(printf '%s' "$counts" | awk '{print $2}')
    if [ "${behind:-0}" -gt 0 ]; then
      printf 'FAIL git (%s): %s commit(s) behind origin/main\n' "$label" "$behind"
      rc=1
      continue
    elif [ "${ahead:-0}" -gt 0 ]; then
      sync="${ahead} ahead of origin/main"
    else
      sync="in sync with origin/main"
    fi
  fi
  if [ -n "$dirty" ]; then
    printf 'WARN git (%s): dirty working tree (%s)\n' "$label" "$sync"
  elif [ "$sync" = "in sync with origin/main" ] || [ "$sync" = "no-upstream" ]; then
    printf 'OK   git (%s): clean, %s\n' "$label" "$sync"
  else
    printf 'WARN git (%s): clean, %s\n' "$label" "$sync"
  fi
done

exit "$rc"
