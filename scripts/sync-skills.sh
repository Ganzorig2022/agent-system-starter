#!/usr/bin/env bash
# Sync canonical skills from docs/agent/skills/ to each harness skill dir.
# Canonical wins; mirrors are fully overwritten (including deletions).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$ROOT/docs/agent/skills"
TARGETS=(".codex/skills" ".agents/skills" ".opencode/skills")

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
