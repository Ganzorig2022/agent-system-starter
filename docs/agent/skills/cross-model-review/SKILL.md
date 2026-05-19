---
name: cross-model-review
description: Two-model plan review loop — one model drafts a plan, a second model critiques it inline, then the author revises. One model tends to catch edge cases and consistency drift; the other catches over-engineering and premature abstraction. Use before any non-trivial change, before writing code.
---

# Cross-Model Plan Review

A short, file-anchored protocol for reviewing a plan with a second model.
Skip for bug fixes, copy changes, dependency bumps, or anything contained to
one file.

## Trigger (any one is enough)

- Touches shared/core infrastructure or crosses a module boundary.
- Adds, moves, or renames a module boundary.
- Changes auth, permissions, or security-sensitive code.
- Adds a new runtime dependency.
- Modifies DB schema or migrations.
- Spans more than ~3 files for one logical change.

## The loop

### 1. Author drafts the plan

Write the plan to `.agent/plans/active.md` (`Status: draft`) with these
sections, in order:

- **Goal** — 1–2 sentences. Why this is worth doing now.
- **Files to add / change** — explicit paths, not vague areas.
- **Validation plan** — which tests, which manual smokes.
- **Out of scope** — anything tempting that this plan does **not** do. This
  section is load-bearing; it is what the reviewer uses to detect scope creep.

### 2. Switch tools — ask the other model to critique inline

The reviewer appends a `## Review (<model>)` block to `## Notes`. Numbered
points. Each point is one of:

- A concrete defect (with file:line where possible).
- A specific simplification (with the simpler form sketched).
- A missing edge case (with the failing scenario named).

Lean on each model's known strength:

- **The careful model reviewing** — edge cases, consistency with existing
  patterns, dependency-array / lifecycle correctness, whether the plan honors
  the invariants recorded in `.agent/decisions/`.
- **The lean model reviewing** — over-engineering, premature abstractions,
  unnecessary new files, whether a simpler form preserves the intent, whether
  any new flag/option pulls its weight.

### 3. Author revises

For each numbered review point, append directly under it one of:

- `> applied: <one-line summary of the change to the plan>`
- `> rejected: <one-line reason>`

Do **not** silently delete review points. The trail is part of the artifact.

### 4. Optional second pass

If the revision was substantial (more than half the points applied, or the
file list changed), run one more round. Two passes is usually the ceiling —
three signals the plan needs to be rewritten, not refined.

## Termination

The loop is done when **both** are true:

- Every numbered review point has an `applied:` or `rejected:` line under it.
- The author no longer feels the plan needs another pass.

Then the human approves and the planner sets `Status: approved`.

## What NOT to do

- Don't run both models on the same draft in parallel — you lose the
  corrective signal and end up averaging two takes.
- Don't ask the reviewer to "improve" the plan. Ask only what is wrong,
  missing, or over-built.
- Don't keep review notes in chat. They live in the plan file so the next
  agent can audit the decision trail without replaying a session.
- Don't use this loop on trivial changes. The overhead exceeds the value and
  trains both models to over-plan small work.
