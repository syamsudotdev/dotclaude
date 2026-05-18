---
name: jira-transition
description: |
  Batch-transition Jira issues matching a JQL filter to a target status.
  Use when moving multiple tickets at once (e.g., "move all P1 cobroke tickets to Dev Testing").
  Trigger words: "transition tickets", "move tickets", "batch jira", "jira transition"
---

# Jira Batch Transition

Move multiple Jira issues to a target status in one operation.

## Usage

User provides:
- **JQL filter** — e.g., `project = COBROKE AND priority = P1 AND status = 'To Do'`
- **Target status** — e.g., `Dev Testing`, `Done`, `In Progress`

## Steps

### 1. Search
Query matching issues via `searchJiraIssuesUsingJql`. Display count + issue keys.

### 2. Confirm
Show list of issues that will be transitioned. **Wait for user confirmation before proceeding.**

### 3. Transition
For each issue:
1. `getTransitionsForJiraIssue` — find transition ID matching target status
2. `transitionJiraIssue` — execute transition
3. Report success/failure per issue

### 4. Summary
Report: X succeeded, Y failed (with error details for failures).

## Rules

- NEVER transition without user confirmation
- If target status not available for an issue, skip it and report why
- Show exact JQL used before searching
- Max 50 issues per batch — if more matched, warn and ask to narrow filter
