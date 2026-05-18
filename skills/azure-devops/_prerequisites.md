# Prerequisites

## Install

```bash
brew install azure-cli && az extension add --name azure-devops
```

## Authenticate

```bash
# Interactive
az login
az devops configure --defaults organization=https://dev.azure.com/$ORG project="$PROJECT"

# OR PAT (generate at https://dev.azure.com/{org}/_usersSettings/tokens)
# Scopes needed: Code (Read), Pull Request Threads (Read & Write), Code (Write) for creating PRs
export AZURE_DEVOPS_EXT_PAT="<your-pat>"
export ADO_AUTH=$(echo -n ":$AZURE_DEVOPS_EXT_PAT" | base64)
```

## Verify

```bash
az account show  # check auth
az repos pr show --id 1 --org "https://dev.azure.com/$ORG"  # test access
```
