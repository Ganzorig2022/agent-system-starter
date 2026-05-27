# Skills

Cross-agent skills for this repo. A skill is reusable knowledge an agent loads
on demand — not part of the always-on startup context.

## Agent Skills Pack

- **Canonical source: `docs/agent/skills/<name>/`.** Edit skills here, then run
  `scripts/sync-skills.sh`.
- **Mirrors (do NOT edit directly):** `.codex/skills/`, `.agents/skills/`,
  `.opencode/skills/`. They are rewritten from canonical by the sync script;
  `scripts/check-skills-sync.sh` runs in pre-commit and fails the commit on
  drift.

## Bundled skills

- `cross-model-review` — two-model plan review loop; read before drafting any
  non-trivial plan when two capable models are available.
- `codebase-onboarding` — four-phase recon and mapping protocol; run when
  joining a new repo to populate `.agent/context.md` and produce an onboarding
  summary.
- `verification-loop` — structured build → type → lint → test → secret-scan →
  diff pass; run before claiming work done or opening a PR.

## Adding your own skills

1. Create `docs/agent/skills/<name>/SKILL.md` with YAML frontmatter
   (`name`, `description`) followed by the skill body.
2. Run `scripts/sync-skills.sh` to mirror it into every harness dir.
3. Commit the canonical file **and** the regenerated mirrors together.

Keep stack-specific skills (React, a given cloud, a given framework) here too —
they travel with the repo that needs them.
