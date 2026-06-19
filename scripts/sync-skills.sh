#!/usr/bin/env bash
# Sync canonical skills from docs/agent/skills/ to harness skill dirs.
# Canonical wins; mirrors are fully overwritten (including deletions).
#
# Override targets with:
#   AGENT_SKILL_TARGETS=".codex/skills .agents/skills" scripts/sync-skills.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$ROOT/docs/agent/skills"
read -r -a TARGETS <<< "${AGENT_SKILL_TARGETS:-.codex/skills .agents/skills .opencode/skills}"

if [ ! -d "$CANONICAL" ]; then
  echo "error: canonical skills dir missing at $CANONICAL" >&2
  exit 1
fi

shopt -s nullglob
for skill_path in "$CANONICAL"/*/; do
  name="$(basename "$skill_path")"
  for target in "${TARGETS[@]}"; do
    dest="$ROOT/$target/$name"
    mkdir -p "$dest"
    rsync -a --delete "$skill_path" "$dest/"
    echo "synced: $name -> $target/$name"
  done
done
