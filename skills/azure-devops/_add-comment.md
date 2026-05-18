# Vote and Comment on a PR

## Vote (az CLI)

```bash
az repos pr set-vote --id "$PR_ID" --org "https://dev.azure.com/$ORG" --vote "approve"
# Values: approve | approve-with-suggestions | reset | wait-for-author | reject
```

## Post comment thread (REST API)

```bash
# General comment
curl -s -X POST -H "$AUTH_HDR" -H "Content-Type: application/json" \
  -d '{"comments":[{"content":"COMMENT_TEXT","commentType":1}],"status":"active"}' \
  "$ADO_PR/threads?$V"
```

## Inline comment (on file/line)

```bash
curl -s -X POST -H "$AUTH_HDR" -H "Content-Type: application/json" \
  -d '{"comments":[{"content":"COMMENT_TEXT","commentType":1}],"threadContext":{"filePath":"FILE_PATH","rightFileStart":LINE,"rightFileEnd":LINE},"status":"active"}' \
  "$ADO_PR/threads?$V"
```

## Reply to existing thread

```bash
curl -s -X POST -H "$AUTH_HDR" -H "Content-Type: application/json" \
  -d '{"content":"REPLY_TEXT","commentType":1}' \
  "$ADO_PR/threads/THREAD_ID/comments?$V"
```
