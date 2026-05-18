# Fetch PR Details

## az CLI

```bash
az repos pr show --id "$PR_ID" --org "https://dev.azure.com/$ORG" \
  --query "{title:title, description:description, status:status, createdBy:createdBy.displayName, source:sourceRefName, target:targetRefName}" -o json
```

## REST API

```bash
curl -s -H "$AUTH_HDR" "$ADO_PR?$V" | jq '{title, description, status, createdBy: .createdBy.displayName, source: .sourceRefName, target: .targetRefName}'
```
