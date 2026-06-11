---
name: ship
description: |
  Full ship pipeline: verify (format + compile + test), then commit and push.
  Use when ready to ship changes to remote.
  Trigger words: "ship", "ship it", "commit and push", "push this", "land this"
---

# Ship Skill

Verify + commit + push pipeline. Nothing ships without passing verification.

## Steps

### 1. Verify
Run the full `/verify` pipeline (format → compile/typecheck → test). `/verify` is
**stack-agnostic** — it detects the project's language(s)/tooling and runs the
right commands (and verifies every stack whose files changed in a multi-stack
repo). **If any step fails, STOP. Do not proceed to commit.**

### 2. Review staged changes
```bash
git status
git diff --cached
git diff
```
Show the user what will be committed. Stage specific files only — never `git add -A` or `git add .`.

### 3. Commit
- Default to conventional commit format: `feat(scope):`, `fix(scope):`, `refactor(scope):`, `test(scope):`, `docs(scope):` — but if the repo's own `git log` follows a different convention, match that instead.
- 1-2 sentence message focused on "why" not "what"
- Use HEREDOC format:
```bash
git commit -m "$(cat <<'EOF'
feat(auth): add token refresh with optimistic retry
EOF
)"
```

### 4. Push
```bash
git push origin HEAD
```
Report commit hash and remote status after push.

## Rules

- NEVER ship if verification fails — fix first
- NEVER use `git add -A` — stage specific files by name
- NEVER force push
- NEVER skip hooks (--no-verify)
- Show staged files + commit message to user before committing
- If push fails, diagnose (auth? remote? conflict?) and report — do not retry blindly
- After successful push, report: commit hash, branch, files changed count
