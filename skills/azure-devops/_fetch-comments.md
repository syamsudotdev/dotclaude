# Fetch PR Comments

No az CLI support — REST API only.

## All threads

```bash
curl -s -H "$AUTH_HDR" "$ADO_PR/threads?$V" \
  | jq '[.value[] | {id, status, file: .threadContext.filePath, comments: [.comments[] | {author: .author.displayName, content, date: .publishedDate}]}]'
```

## Active (unresolved) threads only

```bash
curl -s -H "$AUTH_HDR" "$ADO_PR/threads?$V" \
  | jq '[.value[] | select(.status == "active")]'
```
