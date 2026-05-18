# Errors

| Error | Fix |
|-------|-----|
| `TF401019: repository not found` | Check `$REPO` and URL-encoded `$PROJECT` |
| `401 Unauthorized` | `az login` or refresh PAT |
| `TF14044: Access Denied` | PAT needs Code (Read) scope |
| `az: command not found` | `brew install azure-cli` |
| `az repos: not found` | `az extension add --name azure-devops` |

## Gotchas

- Quote project names with spaces in az CLI: `--project "My Project"`
- URL-encode spaces as `%20` in REST API URLs
- PAT base64 must include leading colon: `echo -n ":$PAT" | base64`
- Iteration IDs start at 1, not 0
