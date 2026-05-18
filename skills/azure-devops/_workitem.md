# Fetch Work Item / Ticket

## az CLI

```bash
az boards work-item show --id "$WI_ID" --org "https://dev.azure.com/$ORG" -o json \
  | jq '{
    id: .id,
    title: .fields["System.Title"],
    state: .fields["System.State"],
    type: .fields["System.WorkItemType"],
    assignedTo: .fields["System.AssignedTo"].displayName,
    iteration: .fields["System.IterationPath"],
    description: .fields["System.Description"],
    acceptanceCriteria: .fields["Microsoft.VSTS.Common.AcceptanceCriteria"],
    tags: .fields["System.Tags"],
    priority: .fields["Microsoft.VSTS.Common.Priority"],
    parent: .relations[]? | select(.rel == "System.LinkTypes.Hierarchy-Reverse") | .url
  }'
```

**Note:** `--project` is NOT needed for work-item show.

## Common fields

| Field key | Content |
|-----------|---------|
| `System.Title` | Title |
| `System.State` | New / Active / Resolved / Closed |
| `System.WorkItemType` | User Story / Task / Bug / Epic |
| `System.Description` | HTML body |
| `Microsoft.VSTS.Common.AcceptanceCriteria` | AC (HTML) |
| `System.AssignedTo` | Object with `.displayName`, `.uniqueName` |
| `System.IterationPath` | Sprint path |
| `System.Tags` | Semicolon-separated tags |
| `Microsoft.VSTS.Common.Priority` | 1-4 |

## List child work items

```bash
az boards work-item show --id "$WI_ID" --org "https://dev.azure.com/$ORG" -o json \
  | jq '[.relations[]? | select(.rel == "System.LinkTypes.Hierarchy-Forward") | .url | split("/") | last]'
```

Then fetch each child ID individually.

## Update work item

```bash
az boards work-item update --id "$WI_ID" --org "https://dev.azure.com/$ORG" \
  --state "Active" --assigned-to "user@example.com"
```
