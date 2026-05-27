---
name: verification-loop
description: Run a structured build → type → lint → test → security → diff verification pass before marking work done or opening a PR. Produces a concise PASS/FAIL report across all gates.
---

# Verification Loop

A structured quality gate pass for any agent session. Run this before claiming work is done, before opening a PR, or after any significant refactor.

## When to Use

- After completing a feature or significant code change
- Before creating a PR
- After refactoring
- When you want to confirm all quality gates pass

## Verification Phases

Run each phase in order. If a phase hard-fails (build broken, tests failing), stop and fix before continuing — don't collect a full report of a broken build.

### Phase 1: Build

```bash
# Node / JavaScript / TypeScript
npm run build 2>&1 | tail -20
# or: pnpm build / yarn build

# Go
go build ./... 2>&1

# Python
python -m py_compile src/**/*.py 2>&1

# Dart / Flutter
dart analyze 2>&1 | tail -20
# or: flutter build <target> 2>&1 | tail -20
```

If build fails: **STOP. Fix before continuing.**

### Phase 2: Type Check

```bash
# TypeScript
npx tsc --noEmit 2>&1 | head -30

# Python (if pyright or mypy configured)
pyright . 2>&1 | head -30
mypy . 2>&1 | head -30

# Dart
dart analyze 2>&1 | head -30
```

Report all type errors. Fix critical ones before continuing.

### Phase 3: Lint

```bash
# JavaScript / TypeScript
npm run lint 2>&1 | head -30

# Python
ruff check . 2>&1 | head -30

# Go
golangci-lint run 2>&1 | head -30

# Dart
dart analyze 2>&1 | head -30
```

### Phase 4: Tests

```bash
# Node / JavaScript / TypeScript
npm test -- --coverage 2>&1 | tail -50

# Go
go test ./... 2>&1

# Python
pytest --tb=short 2>&1 | tail -30

# Dart / Flutter
flutter test 2>&1 | tail -30
```

Report:
- Total tests / Passed / Failed
- Coverage % (target: 80% minimum where configured)

### Phase 5: Secret Scan

Check for accidentally committed secrets or debug artifacts:

```bash
# Hardcoded secrets (adjust patterns to your stack)
grep -rn "sk-\|api_key\s*=\|password\s*=\|secret\s*=" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.go" \
  --exclude-dir=node_modules --exclude-dir=.git . 2>/dev/null | head -10

# Debug artifacts left in source
grep -rn "console\.log\|print(\|fmt\.Println\|debugger" \
  --include="*.ts" --include="*.tsx" --include="*.js" \
  --exclude-dir=node_modules . 2>/dev/null | head -10
```

### Phase 6: Diff Review

```bash
git diff --stat
git diff HEAD~1 --name-only 2>/dev/null || git diff --cached --name-only
```

Review each changed file for:
- Unintended changes slipping into the diff
- Missing error handling
- Edge cases not covered by tests

## Output Format

After all phases, produce this report:

```
VERIFICATION REPORT
===================

Build:     [PASS/FAIL]
Types:     [PASS/FAIL] (N errors)
Lint:      [PASS/FAIL] (N warnings)
Tests:     [PASS/FAIL] (N/M passed, N% coverage)
Secrets:   [PASS/FAIL] (N issues)
Diff:      N files changed

Overall:   [READY / NOT READY] for PR

Issues to fix:
1. ...
2. ...

Tests run: [list]
Tests not run: [list and why]
```

The "Tests run / not run" lines feed directly into the session-end update in `.agent/state.md`.

## Checkpoints for Long Sessions

For sessions spanning multiple files or hours, run a lightweight checkpoint after each logical unit of work:

- After completing a function or module
- After finishing a component
- Before switching to a new task area

A checkpoint is Phases 1 + 4 only — build and tests. Save the full 6-phase pass for end-of-session.
