#!/usr/bin/env bash
# Verify each harness skill dir is byte-identical to the canonical source.
# Exit non-zero with diff output if drift is detected.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CANONICAL="$ROOT/docs/agent/skills"
TARGETS=(".codex/skills" ".agents/skills" ".opencode/skills")

if [ ! -d "$CANONICAL" ]; then
  # No canonical source yet — nothing to check.
  exit 0
fi

fail=0
shopt -s nullglob
for skill_path in "$CANONICAL"/*/; do
  name="$(basename "$skill_path")"
  for target in "${TARGETS[@]}"; do
    dest="$ROOT/$target/$name"
    if [ ! -d "$dest" ]; then
      echo "MISSING: $target/$name"
      fail=1
      continue
    fi
    if ! diff -qr "$skill_path" "$dest" >/dev/null 2>&1; then
      echo "DRIFT: $target/$name differs from canonical"
      diff -r "$skill_path" "$dest" || true
      fail=1
    fi
  done
done

if [ "$fail" -ne 0 ]; then
  echo
  echo "Skill drift detected. Fix with: scripts/sync-skills.sh" >&2
  exit 1
fi
