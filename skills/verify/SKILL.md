---
name: verify
description: |
  Run the full verification pipeline: ktlint format, compile, and unit tests.
  Use when verifying code changes are correct before committing.
  Trigger words: "verify", "check", "validate", "run tests", "test this", "make sure it works"
---

# Verify Skill

Run format + compile + test pipeline for changed code.

## Steps (sequential — each must pass before next)

### 1. Format
```bash
./gradlew ktlintFormat
```
If formatting changes files, note which files were modified.

### 2. Compile
```bash
./gradlew compileDebugKotlin
```
If compilation fails, fix errors before proceeding. Max 5 fix iterations.

### 3. Test
```bash
./gradlew runAffectedUnitTests
```
If tests fail, enter fix loop (max 5 iterations per test class). Report exact failure counts.

## Module-scoped verification

When changes are limited to a single module, run targeted commands for speed:
```bash
./gradlew :<module>:ktlintFormat
./gradlew :<module>:compileDebugKotlin
./gradlew :<module>:testPublicDebugUnitTest
```

Common module paths:
- `:app` — main app module
- `:common:cobroke` — cobroke business logic
- `:common:profile` — profile module
- `:core:compose` — shared compose components

## Rules

- Run ALL three steps in sequence — format MUST come first
- If format changes files, re-verify compilation
- NEVER claim success if any step has failures
- Report: files formatted, compilation status, test count (passed/failed/skipped)
- If tests fail after 5 fix iterations, STOP and report the failures — do not comment out or delete tests
