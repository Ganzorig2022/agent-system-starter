# State — 2026-06-19 — Codex customization layering adapted

## Current focus

Adapted the starter docs and skill mirror scripts for a split customization
model: `.agent/` remains repo-local state/protocol, while global harness
customization such as `~/.codex/skills`, `~/.codex/rules`,
`~/.codex/commands`, and `~/.codex/agents` is treated as an optional workflow
layer.

**Active plan:** none — see `plans/active.md`.

## Status

Status: idle

## Tests

Tests run: `bash -n init.sh`, `bash -n scripts/sync-skills.sh`,
`bash -n scripts/check-skills-sync.sh`, `bash scripts/check-skills-sync.sh`.

Tests not run: none.

## Next likely step

Status is idle. If a target harness needs hidden repo-local skill mirrors, run
`scripts/sync-skills.sh` in that target repo after installation.
