# agent-system-starter

A portable, repo-local convention that gives **Claude, Codex, and opencode** the
same deterministic startup, memory, and planner→worker handoff — in any project,
on any device, across any session. No MCP, no servers, no automation framework.
Just markdown that lives in Git.

## What you get

```
.agent/
  README.md          # the protocol — startup, session-end, working discipline
  context.md         # stable repo brief (you fill this in)
  state.md           # current snapshot, overwritten each task
  plans/
    README.md        # plan lifecycle: draft → approved → in-progress → archived
    active.md         # the one approved work order — the planner→worker baton
    archive/          # completed plans
  decisions/         # append-only record of non-obvious technical choices
  handoffs/          # mid-task orientation notes, only when needed
  local/             # per-machine paths/ports — gitignored
CLAUDE.md            # pointer → .agent/README.md (Claude reads this)
AGENTS.md            # pointer → .agent/README.md (Codex / opencode read this)
docs/agent/
  SKILLS.md          # how the skill pack works
  skills/            # canonical skills (cross-model-review bundled)
scripts/
  sync-skills.sh        # mirror canonical skills into each harness dir
  check-skills-sync.sh  # pre-commit guard against skill drift
```

## How to adopt it

### New project — use as a GitHub template

Click **"Use this template"** on GitHub, or:

```bash
npx degit Ganzorig2022agent-system-starter my-new-project
```

### Existing project — run the init script

Clone this starter repo somewhere, then run its installer against the project
repo you want to adopt the convention in:

```bash
git clone https://github.com/Ganzorig2022/agent-system-starter.git
cd agent-system-starter
./init.sh /path/to/your-existing-project
```

`init.sh` is run from the starter repo, but the path argument must point to your
target repo. Running `./init.sh` with no argument inside `agent-system-starter`
is intentionally rejected, because the starter repo is the source template.

`init.sh` never overwrites an existing file — it adds what is missing, reports
what it skipped, and is safe to re-run.

## After installing

1. Fill in `.agent/context.md` — architecture, conventions, gotchas, glossary.
2. Set today's date in `.agent/state.md`.
3. Run `scripts/sync-skills.sh` to mirror skills into the harness dirs.
4. Wire `scripts/check-skills-sync.sh` into your pre-commit hook.
5. Commit everything — the convention only works when it is in Git.

## What's portable vs. project-specific

- **Portable (shipped here):** the `.agent/` structure, the startup protocol,
  the plan lifecycle, the pointer files, the skill mechanism, and the generic
  `cross-model-review` skill.
- **Project-specific (you write):** `context.md`, `state.md`, your own
  `decisions/`, and any stack-specific skills under `docs/agent/skills/`.

## License

MIT.
