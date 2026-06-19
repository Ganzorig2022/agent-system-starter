#!/usr/bin/env bash
# Install the .agent/ cross-agent convention into an existing repo.
#
# Usage:
#   ./init.sh [target-repo-path]      # defaults to the current directory
#
# Never overwrites an existing file — it only adds what is missing and
# reports what it skipped, so it is safe to re-run.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
TARGET="$(cd "${1:-.}" && pwd)"

if [ "$SRC" = "$TARGET" ]; then
  echo "error: target is the starter repo itself." >&2
  echo "       pass the path to your project, e.g. ./init.sh ../my-project" >&2
  exit 1
fi

if [ ! -d "$TARGET/.git" ]; then
  echo "warning: $TARGET is not a git repo. The plan handoff travels via git;"
  echo "         run 'git init' there before relying on it."
fi

echo "Installing agent system into: $TARGET"
echo

copied=0
skipped=0

copy() {
  local rel="$1"
  local from="$SRC/$rel"
  local to="$TARGET/$rel"
  if [ -e "$to" ]; then
    echo "  skip (exists): $rel"
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$to")"
  cp -R "$from" "$to"
  echo "  add:           $rel"
  copied=$((copied + 1))
}

copy .agent
copy docs/agent
copy scripts/sync-skills.sh
copy scripts/check-skills-sync.sh
copy CLAUDE.md
copy AGENTS.md

# .gitignore — append the local/ rule if missing, never clobber the file.
GI="$TARGET/.gitignore"
if [ -f "$GI" ] && grep -qxF '.agent/local/' "$GI"; then
  echo "  skip (exists): .gitignore (.agent/local/ rule)"
  skipped=$((skipped + 1))
else
  printf '\n# Machine-local agent notes (never committed)\n.agent/local/\n' >> "$GI"
  echo "  add:           .gitignore (.agent/local/ rule)"
  copied=$((copied + 1))
fi

chmod +x "$TARGET/scripts/sync-skills.sh" "$TARGET/scripts/check-skills-sync.sh" 2>/dev/null || true

echo
echo "Done — $copied added, $skipped skipped."
echo
echo "Next steps:"
echo "  1. Fill in .agent/context.md   (architecture, conventions, gotchas)."
echo "  2. Set the date in .agent/state.md."
echo "  3. If your harness needs hidden skill mirrors, run scripts/sync-skills.sh."
echo "  4. Optionally wire scripts/check-skills-sync.sh into your pre-commit hook;"
echo "     it checks only mirror dirs that exist."
echo "  5. If CLAUDE.md / AGENTS.md were skipped, merge in the pointer to"
echo "     .agent/README.md by hand."
echo "  6. Commit: git add -A && git commit -m 'chore(agent): adopt .agent/ convention'"
