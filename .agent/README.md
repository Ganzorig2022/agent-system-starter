# .agent/ — repo-local agent memory

## Why

New agent sessions and new machines lose context. This directory is the durable handoff.

## Files

| File            | Lifespan    | Writer                               | Purpose                                                                     |
| --------------- | ----------- | ------------------------------------ | --------------------------------------------------------------------------- |
| context.md      | months      | human or agent (rarely)              | Stable: architecture, conventions, gotchas, glossary                        |
| state.md        | per task    | agent (when meaningful work changes) | Current snapshot. Overwritten.                                              |
| plans/          | per task    | planner drafts; worker archives      | Approved work order (`active.md`) + completed-plan `archive/`. See `plans/README.md`. |
| decisions/\*.md | append-only | agent (rare)                         | Non-obvious technical choices a future agent might reverse                  |
| handoffs/\*.md  | append-only | agent (only when needed)             | When work is incomplete/blocked/risky, or carries reasoning the diff cannot |
| local/          | per machine | agent (when asked)                   | Ports, paths, CLI locations. Gitignored.                                    |

## Session start

This is the single source of truth for the startup sequence. `CLAUDE.md` and
`AGENTS.md` only point here; they specify no order of their own.

1. Read `.agent/context.md`, `.agent/state.md`, and `.agent/plans/active.md`. If `active.md` Status is `approved` or `in-progress`, it is the work order — execute it; if `none`, there is no active plan — plan or ask before editing.
2. Run `git status --short` and `git log --oneline -10`. Trust Git over `state.md` if they disagree.
3. If `state.md` looks stale relative to Git, say so out loud and ask before continuing.
4. If `state.md` references a handoff (`see handoffs/<file>`), read that one file.
5. Restate task, assumptions, files likely to change, and validation plan. Then code.

`decisions/` is not auto-loaded. Consult the relevant `decisions/NN-*.md` only
when touching a boundary it governs.

## Session end (do the minimum)

Update `state.md` only if **meaningful work changed**: task started/finished, branch switched, next step changed, new blocker, new open question.

Create a handoff (`handoffs/YYYY-MM-DD-HHMM-<slug>.md`) **only if** one of:

- work is incomplete and the next agent needs orientation beyond `state.md`
- a non-trivial decision was deferred and the reasoning isn't in any commit
- there's a known risk or surprising behavior the next agent must know
- the diff alone would mislead a fresh reader

Otherwise: do not create a handoff. A good commit message is enough.

On completing an approved plan, archive `plans/active.md` to `plans/archive/`, reset `active.md` to its empty state, and update `state.md`. Full lifecycle: `plans/README.md`.

Add a `decisions/` entry only when a choice would otherwise be silently reversed by a future agent. Not for "I used Map instead of Object."

## Cross-repo work

If the current task spans repos, add a `## Cross-repo impact` section to `state.md` listing related repos, branches, and a last-known status hint for each. Verify sibling status with:

```bash
cat ../<sibling>/.agent/state.md
git -C ../<sibling> branch --show-current
git -C ../<sibling> log --oneline -10
git -C ../<sibling> status --short
grep -rn <TICKET-ID> ../<parent-glob>*/.agent/ 2>/dev/null
```

Only edit this repo's section. Don't update sibling repos' state on their behalf.

## What never goes in `.agent/`

- Secrets, tokens, credentials, API keys, signed URLs.
- Raw logs, full stack traces, dumps. Link to a file or PR comment instead.
- Anything derivable from `git log` / `git diff`.
- Long discussions. Link to a PR or issue.
- Step-by-step replays of the session (that's `git log -p`).

## Working discipline

How every agent works between Session start and Session end — any task, any harness:

- **Think before coding.** State assumptions out loud. If the request is ambiguous, ask or lay out the interpretations — never silently pick one. Push back before implementing a needlessly complex approach.
- **Simplicity first.** Ship the minimum that solves the stated problem. No speculative features, no single-use abstractions, no unrequested flexibility. If 200 lines could be 50, rewrite it.
- **Surgical changes.** Touch only what the request demands. Don't reformat, rename, or "improve" adjacent code. Only remove unused imports/variables your own edits created; flag other dead code, don't delete it.
- **Goal-driven execution.** Turn vague directives into testable success criteria, then loop until verified. For a bug fix, write the failing test first.

## Agent rules

- Repo is source of truth. If `state.md` conflicts with the code or `git log`, trust Git and update `state.md`.
- Never store secrets. Never paste large logs. Never duplicate Git history into markdown.
- Explicitly list **tests run** and **tests not run** at end of session.
- Do not invent a "next step" if the work is genuinely done — write `Status: idle` and leave it.
