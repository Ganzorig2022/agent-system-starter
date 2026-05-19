# .agent/plans/ — the approved work order

## Why

Plans were drafted in machine-local files (`~/.claude/plans/<slug>.md`) and
handed to the worker by copy-paste. A fresh session on another device could
not recover the approved plan. This directory puts the plan in Git so every
agent refers to the same artifact.

This file describes the **plan lifecycle only**. Session startup is defined in
`../README.md` and nowhere else — do not restate it here.

## Files

| File              | Lifespan    | Writer                          | Purpose                                  |
| ----------------- | ----------- | ------------------------------- | ---------------------------------------- |
| active.md         | per task    | planner drafts; worker archives | The one approved, executable work order  |
| archive/\*.md     | append-only | worker (on completion)          | Completed plans, kept for the record     |

Only **one** plan is active at a time.

## Roles

- **Planner** (e.g. Claude) drafts and updates `active.md`, and sets
  `Status: approved` when the plan is final and the human has authorized it.
- **Worker** (e.g. Codex) executes — and executes **only** `active.md`, and
  only when its `Status` is `approved` or `in-progress`.

The repo owns the handoff: the planner writes the plan, the worker reads it.
No copy-paste middleman for routine work. External review (e.g. another model)
is **optional** and reserved for hard or high-risk plans; when used, fold the
revisions into `active.md` and note them in `## Notes`.

## Status values

`none` (empty, no active plan) → `draft` (planner writing) → `approved` (review
settled, ready for the worker) → `in-progress` (worker executing) → archived
on completion.

## Lifecycle

1. The planner drafts `active.md` with `Status: draft`, iterating until final.
   (Optional: external review for a hard plan — see Roles.)
2. The planner sets `Status: approved` (only after explicit human approval).
3. The worker sets `Status: in-progress` and executes.
4. On completion the worker:
   - moves `active.md` to `archive/YYYY-MM-DD-<slug>.md`,
   - resets `active.md` to the empty state (`Status: none`, sections cleared),
   - updates `../state.md` to record the outcome and the next focus.

## Relationship to state.md

- `../state.md` is the durable **status narrative** — what's done, current
  focus, blockers, next step.
- `active.md` is the **executable work order** — the worker executes this, not
  `state.md`.
- `state.md` carries one pointer line: `Active plan: plans/active.md
  (Status: …)` or `Active plan: none`.
- They are never merged: `state.md` is never the work order; `active.md` is
  never the status narrative.

## Boundary

`active.md` is the ephemeral work order. A non-obvious **architectural** choice
made while planning or reviewing still goes to `../decisions/NN-*.md` — the
plan is not the durable decision record.
