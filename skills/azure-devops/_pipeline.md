# Fetch Pipeline / Build

## Build results

```bash
az pipelines build show --id "$BUILD_ID" --org "https://dev.azure.com/$ORG" --project "$PROJECT" -o json \
  | jq '{
    id: .id,
    buildNumber: .buildNumber,
    status: .status,
    result: .result,
    pipeline: .definition.name,
    sourceBranch: .sourceBranch,
    requestedBy: .requestedBy.displayName,
    startTime: .startTime,
    finishTime: .finishTime,
    reason: .reason
  }'
```

## Build timeline (stages/jobs/tasks)

```bash
az rest --method get --resource "499b84ac-1321-427f-aa17-267ca6975798" \
  --uri "https://dev.azure.com/$ORG/$PROJECT_ENC/_apis/build/builds/$BUILD_ID/timeline?api-version=7.1" \
  | jq '[.records[] | select(.type == "Stage" or .type == "Job" or .type == "Task") | {name, type, state, result, startTime, finishTime, errorCount, warningCount}]'
```

## Build logs

```bash
# List all log files
az rest --method get --resource "499b84ac-1321-427f-aa17-267ca6975798" \
  --uri "https://dev.azure.com/$ORG/$PROJECT_ENC/_apis/build/builds/$BUILD_ID/logs?api-version=7.1" \
  | jq '[.value[] | {id, lineCount, url}]'

# Fetch specific log by ID
az rest --method get --resource "499b84ac-1321-427f-aa17-267ca6975798" \
  --uri "https://dev.azure.com/$ORG/$PROJECT_ENC/_apis/build/builds/$BUILD_ID/logs/$LOG_ID?api-version=7.1"
```

## Pipeline definition

```bash
az pipelines show --id "$DEF_ID" --org "https://dev.azure.com/$ORG" --project "$PROJECT" -o json \
  | jq '{id: .id, name: .name, path: .path, yamlPath: .process.yamlFilename, defaultBranch: .repository.defaultBranch}'
```

## Recent builds for a definition

```bash
az pipelines build list --definition-ids "$DEF_ID" --org "https://dev.azure.com/$ORG" --project "$PROJECT" --top 5 -o json \
  | jq '[.[] | {id, buildNumber, status, result, sourceBranch, finishTime}]'
```
