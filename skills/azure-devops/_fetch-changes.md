# Fetch PR Code Changes

No az CLI support for diffs — REST API only.

## List iterations and changed files

```bash
# Get latest iteration ID
ITER=$(curl -s -H "$AUTH_HDR" "$ADO_PR/iterations?$V" | jq '.value[-1].id')

# List changed files in latest iteration
curl -s -H "$AUTH_HDR" "$ADO_PR/iterations/$ITER/changes?$V" | jq '[.changeEntries[] | {changeType, path: .item.path}]'
```

## Line-level diff

```bash
# Get base and head commits from iteration, then diff
ITER_DATA=$(curl -s -H "$AUTH_HDR" "$ADO_PR/iterations/$ITER?$V")
BASE=$(echo "$ITER_DATA" | jq -r '.commonRefCommit.commitId')
HEAD=$(echo "$ITER_DATA" | jq -r '.sourceRefCommit.commitId')

curl -s -H "$AUTH_HDR" "$ADO_API/diffs/commits?baseVersion=$BASE&targetVersion=$HEAD&$V" \
  | jq '[.changes[] | {path: .item.path, changeType}]'
```

## Raw file content at HEAD

```bash
FILE="/path/to/file"
curl -s -H "$AUTH_HDR" "$ADO_API/items?path=$FILE&version=$HEAD&$V"
```
