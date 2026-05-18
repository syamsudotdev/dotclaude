# Create a Pull Request

## az CLI

```bash
az repos pr create \
  --org "https://dev.azure.com/$ORG" --project "$PROJECT" --repository "$REPO" \
  --source-branch "$(git rev-parse --abbrev-ref HEAD)" --target-branch "main" \
  --title "PR title" --description "Description here." \
  --draft false
```

## REST API

```bash
curl -s -X POST -H "$AUTH_HDR" -H "Content-Type: application/json" \
  -d '{"title":"PR title","description":"Description","sourceRefName":"refs/heads/BRANCH","targetRefName":"refs/heads/main","isDraft":false}' \
  "$ADO_API/pullRequests?$V"
```
