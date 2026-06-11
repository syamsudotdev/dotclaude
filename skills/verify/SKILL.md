---
name: verify
description: |
  Run the verification pipeline for changed code: format → compile/typecheck → test.
  Language-agnostic: detects the project's stack(s) and runs the right commands.
  Use when verifying code changes are correct before committing.
  Trigger words: "verify", "check", "validate", "run tests", "test this", "make sure it works"
---

# Verify Skill

Run **format → compile/typecheck → test** for the changed code. Each phase must
pass before the next. The skill is **stack-agnostic**: detect what the project
uses and run the matching commands. Prefer the project's *own* declared
scripts/tasks over hardcoded tool names.

## Step 0 — Detect the stack(s)

1. Find which files changed: `git status --short` + `git diff --name-only` (and `--cached`).
2. Map changed paths → stack(s) by marker files. A repo can have **several**
   (e.g. a JS frontend + a Rust/`src-tauri` backend) — verify **each stack whose
   files changed**, scoped to those files/modules where possible.

| Marker file(s) | Stack | Format | Compile / Typecheck | Test |
|---|---|---|---|---|
| `package.json` | Node / TS / JS | `prettier`/`eslint --fix` (or `fmt`/`lint` script) | `tsc --noEmit` or `build` script | `test` script (vitest/jest/playwright) |
| `Cargo.toml` | Rust | `cargo fmt` | `cargo check` | `cargo test` |
| `gradlew`, `build.gradle(.kts)` | Android / Kotlin / JVM | `./gradlew ktlintFormat` (or `spotlessApply`) | `./gradlew compileDebugKotlin` (or `assemble`) | `./gradlew test`/`runAffectedUnitTests` |
| `go.mod` | Go | `gofmt -w` / `go fmt ./...` | `go build ./...` / `go vet ./...` | `go test ./...` |
| `pyproject.toml`, `setup.py`, `requirements.txt` | Python | `ruff format` (or `black`) | `ruff check` / `mypy` | `pytest` |
| `pom.xml` | Maven/JVM | `spotless:apply` (if configured) | `mvn -q compile` | `mvn test` |
| `*.csproj`, `*.sln` | .NET | `dotnet format` | `dotnet build` | `dotnet test` |
| `composer.json` | PHP | `php-cs-fixer fix` | `composer ...`/`phpstan` | `phpunit` |
| `Gemfile` | Ruby | `rubocop -A` | — | `rspec` / `rake test` |
| `mix.exs` | Elixir | `mix format` | `mix compile` | `mix test` |
| `Makefile`/`Justfile` | any | `make fmt`/`just fmt` | `make build` | `make test` |

### Detection rules
- **Project scripts win.** If `package.json` defines `format`/`lint`/`build`/`test`
  scripts, a `Makefile`/`Justfile` has `fmt`/`build`/`test` targets, or there's a
  `CONTRIBUTING`/CI config naming the commands — use those, not the generic
  fallback. They encode the project's real intent.
- **Detect the package manager** for Node: `pnpm-lock.yaml`→`pnpm`, `yarn.lock`→`yarn`,
  `bun.lockb`→`bun`, else `npm`. (`npm run <script>`, `pnpm <script>`, etc.)
- A phase that the stack **doesn't have is skipped, not failed** — e.g. no
  formatter configured → report "no formatter configured" and move on. Never
  invent a tool that isn't set up.
- If you can't identify the stack, ask the user for the format/compile/test
  commands rather than guessing.

## Steps (sequential — each must pass before the next)

### 1. Format
Run the detected formatter. If it modifies files, note which — and re-run
compile (step 2) since formatting can change what compiles.

### 2. Compile / Typecheck
Run the detected compile/typecheck command. If it fails, fix errors before
proceeding. Max 5 fix iterations, then STOP and report.

### 3. Test
Run the detected test command, scoped to the changed area when the runner
supports it (affected/changed/module filters) for speed; otherwise run the
suite. If tests fail, enter a fix loop (max 5 iterations), then STOP and report
exact pass/fail/skip counts.

## Rules

- Run all three phases **in order** — format first. Skip a phase only if the
  stack genuinely lacks it (and say so).
- For **multi-stack** repos, verify every stack with changed files; report each
  separately.
- NEVER claim success if any phase has failures.
- NEVER comment out, skip, or delete tests to make them "pass". After 5 fix
  iterations, STOP and report.
- Report: stack(s) detected, files formatted, compile status, test counts
  (passed/failed/skipped) per stack.
