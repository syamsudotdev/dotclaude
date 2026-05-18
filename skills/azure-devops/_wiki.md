# Fetch Wiki Page

Wiki URLs use page ID (e.g., `/16/Frontend-PRD`) but the API uses hierarchical paths (e.g., `/SearchPoint/Frontend-PRD`). Must resolve ID → path first.

## Step 1: Resolve page ID to path

Walk the wiki tree from root, matching the target PAGE_ID:

```bash
ADO_RESOURCE="499b84ac-1321-427f-aa17-267ca6975798"
WIKI_API="https://dev.azure.com/$ORG/$PROJECT_ENC/_apis/wiki/wikis/$WIKI"

# Start from root, list immediate children
az rest --method get --resource "$ADO_RESOURCE" \
  --uri "$WIKI_API/pages?path=/&recursionLevel=oneLevel&api-version=7.0" \
  | jq -r '.subPages[]? | "\(.id) \(.path)"'
```

If PAGE_ID not found at root level, recurse into each subpage path:

```bash
# Check subpages of a path
az rest --method get --resource "$ADO_RESOURCE" \
  --uri "$WIKI_API/pages?path=$SUBPAGE_PATH&recursionLevel=oneLevel&api-version=7.0" \
  | jq -r '.subPages[]? | "\(.id) \(.path)"'
```

Repeat until you find the matching page ID. Typically 1-2 levels deep.

## Step 2: Fetch page content

Once you have the resolved path:

```bash
# Try az CLI first
az devops wiki page show --wiki "$WIKI" --path "$RESOLVED_PATH" \
  --org "https://dev.azure.com/$ORG" --project "$PROJECT" -o json \
  | jq -r '.page.content'
```

If CLI fails (common), use REST:

```bash
az rest --method get --resource "$ADO_RESOURCE" \
  --uri "$WIKI_API/pages?path=$RESOLVED_PATH&includeContent=true&api-version=7.0" \
  | jq -r '.content'
```

## Gotchas

- `az devops wiki page show` requires `--project` (unlike most commands)
- Page paths with spaces need URL-encoding in REST but not in CLI `--path`
- The page name in the URL (e.g., `Frontend-PRD`) uses dashes for spaces — actual path may differ
- `recursionLevel=full` can be slow on large wikis — prefer `oneLevel` and walk
