# Repo context — <PROJECT NAME>

> Fill this in once when you adopt the agent system, then keep it accurate.
> This is the stable brief every agent reads first. If a line here ever
> conflicts with the code, the code wins — fix the stale line.
> Delete this quote block once the file is filled in.

## What this repo is

<One paragraph: what the app does, its runtime, who calls it / what it calls.>

Core rule: **the repository is the source of truth.** If guidance conflicts
with current code, tests, config, or docs, trust the repo and update the
stale instruction.

## Architecture

- `<path>/` — <what lives here>
- `<path>/` — <what lives here>

## Sibling / related repos

- `<repo>` — <relationship>. Override per-machine paths in `.agent/local/`.
- _Remove this section if the repo is standalone._

## Conventions

- Runtime / language: <e.g. Node + TypeScript>
- Package manager: <e.g. pnpm>
- Key scripts: <install> / <dev> / <build> / <lint> / <test>
- Branch naming: <e.g. `feat/<TICKET>`, `fix/<TICKET>`, `chore/...`>
- Commit prefix: conventional commits. Use `chore(agent):` for `.agent/`-only changes.

## When to run which tests

- <change type> → <test command>
- <change type> → <test command>

## Work rules

- Think before coding; restate task, assumptions, likely files, and validation plan before editing.
- Choose the simplest working solution. Surgical changes only — touch only files the task requires.
- Match existing patterns and style.
- No speculative features. No unrelated refactors, renames, or formatting churn.
- No new dependency unless clearly justified.
- Do not claim verified work without actual validation — if you didn't run it, say so.

## Gotchas

- <surprising behavior or footgun a fresh agent must know>

## Security

Mandatory checks before any commit:
- [ ] No hardcoded secrets, API keys, passwords, or tokens in source
- [ ] All user inputs validated at system boundaries
- [ ] SQL / NoSQL queries use parameterized form — no string concatenation
- [ ] HTML output is sanitized — no raw user content injected into the DOM
- [ ] Auth and authorization checks are present on every relevant endpoint
- [ ] Error messages do not leak stack traces, internal paths, or secret values
- [ ] `.env*`, private keys, credentials, and customer data are never committed

Additional project-specific constraints:
- <e.g. rate limiting required on public endpoints>
- <e.g. PII must not be logged>

Never print, copy, commit, or summarize secret values. Mention env variable names only when needed; never reveal values.

## Glossary

- **<term>** — <definition>
