---
name: azure-devops
description: >-
  Azure DevOps operations: PRs, pipelines, work items, and wiki pages.

  Trigger when user:
  - Pastes any dev.azure.com URL
  - Asks about Azure DevOps PRs, builds, tickets, or wiki
---

# Azure DevOps — Universal URL Router

## 1. Parse URL

Detect resource type from URL pattern and extract variables:

| Pattern | Type | Extract |
|---------|------|---------|
| `dev.azure.com/{org}/{project}/_git/{repo}/pullrequest/{id}` | PR | ORG, PROJECT, REPO, PR_ID |
| `dev.azure.com/{org}/{project}/_build/results?buildId={id}` | Pipeline | ORG, PROJECT, BUILD_ID |
| `dev.azure.com/{org}/{project}/_build/definition?definitionId={id}` | Pipeline def | ORG, PROJECT, DEF_ID |
| `dev.azure.com/{org}/{project}/_workitems/edit/{id}` | Work item | ORG, PROJECT, WI_ID |
| `dev.azure.com/{org}/{project}/_wiki/wikis/{wiki}/{pageId}/{pageName}` | Wiki | ORG, PROJECT, WIKI, PAGE_ID, PAGE_NAME |

URL-decode `%20` → space for PROJECT before using in az CLI flags.

```bash
# Set these from the parsed URL — NEVER hardcode
ORG="<from-url>"
PROJECT="<from-url, decoded>"
PROJECT_ENC=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$PROJECT'))")
```

## 2. Auth

```bash
# Check existing auth first
az account show -o json 2>/dev/null | jq '.user.name'

# If not authenticated:
# Option A: interactive
az login && az devops configure --defaults organization=https://dev.azure.com/$ORG project="$PROJECT"

# Option B: PAT
export AZURE_DEVOPS_EXT_PAT="<your-pat>"
export ADO_AUTH=$(echo -n ":$AZURE_DEVOPS_EXT_PAT" | base64)
```

## 3. Shared REST base (for PR and pipeline REST calls)

```bash
V="api-version=7.1"
AUTH_HDR="Authorization: Basic $ADO_AUTH"
# Only for PR operations:
ADO_API="https://dev.azure.com/$ORG/$PROJECT_ENC/_apis/git/repositories/$REPO"
ADO_PR="$ADO_API/pullRequests/$PR_ID"
```

## 4. az CLI Reference — key quirks

NEVER guess az flags. Key gotchas:

- `pr show`, `pr update`, `pr set-vote`: **NO `--project` flag**
- `boards work-item show`: **NO `--project` flag**
- PR comments, diffs, iterations: **REST only**, no az CLI
- Wiki page show often fails via CLI — use `az rest` with resource `499b84ac-1321-427f-aa17-267ca6975798`
- Always quote project names with spaces: `--project "My Project"`
- URL-encode spaces as `%20` in REST URLs

## 5. Dispatch

Load partial(s) from `/Users/nrsys/.claude/skills/azure-devops/`:

### Pull Request

| Intent | File |
|--------|------|
| PR title, description, status | `_fetch-details.md` |
| Changed files, diffs | `_fetch-changes.md` |
| Comments, review threads | `_fetch-comments.md` |
| Create a PR | `_create-pr.md` |
| Vote, post comment, reply | `_add-comment.md` |

For full PR review, load `_fetch-details.md`, `_fetch-changes.md`, `_fetch-comments.md` in parallel.

### Other resources

| Intent | File |
|--------|------|
| Pipeline build results, logs | `_pipeline.md` |
| Work item / ticket details | `_workitem.md` |
| Wiki page content | `_wiki.md` |

### General

| Intent | File |
|--------|------|
| Install, authenticate, setup | `_prerequisites.md` |
| Error troubleshooting | `_errors.md` |

## 6. Unrecognized URL

If the URL doesn't match any pattern above, tell the user the URL format isn't recognized and ask what resource they're trying to access.
