# Claude Code Config

Personal Claude Code configuration for Android development with multi-agent orchestration.

## Setup

### CLI Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [rtk](https://github.com/rtk-ai/rtk) | `cargo install rtk` | Token-optimized CLI proxy (60-90% savings) |
| [tre](https://github.com/dduan/tre) | `brew install tre-command` | Directory tree explorer |
| [uv](https://github.com/astral-sh/uv) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | Python runner (`uv run`) |
| [android](https://developer.android.com/studio/command-line) | Via Android Studio SDK | Android CLI for layout inspection, screenshots, ADB |
| [ctx7](https://www.npmjs.com/package/ctx7) | `npm install -g ctx7@latest` | Context7 docs CLI |
| [jq](https://jqlang.github.io/jq/) | `brew install jq` | JSON processor (required by hooks) |
| [gh](https://cli.github.com/) | `brew install gh` | GitHub CLI |
| [az](https://learn.microsoft.com/en-us/cli/azure/) | `brew install azure-cli` | Azure DevOps CLI |

### Plugins

Install via `/install-plugin`:

```
atlassian@claude-plugins-official    # Jira + Confluence integration
context7@claude-plugins-official     # Library docs lookup
frontend-design@claude-plugins-official  # UI/UX implementation
claude-mem@thedotmack               # Persistent memory via MCP (marketplace: github:thedotmack/claude-mem)
```

Project-scoped (install within project dir):
```
skill-creator@claude-plugins-official
```

### Skills (Google LLC, Apache 2.0)

Installable via skill marketplace. Gitignored — reinstall on setup:

| Skill | Description |
|-------|-------------|
| `agp-9-upgrade` | AGP 9 migration |
| `edge-to-edge` | Compose edge-to-edge + insets |
| `migrate-xml-views-to-jetpack-compose` | XML → Compose migration |
| `navigation-3` | Navigation 3 migration + recipes |
| `play-billing-library-version-upgrade` | Play Billing Library upgrade |
| `r8-analyzer` | R8/ProGuard keep rules analysis |

### Skills (Custom, tracked in repo)

| Skill | Description |
|-------|-------------|
| `android-cli` | Android CLI layout/screenshot/ADB orchestration |
| `azure-devops` | Azure DevOps PRs, pipelines, work items, wiki |
| `caveman` | Ultra-compressed communication mode (~75% token savings) |
| `caveman-compress` | Compress CLAUDE.md/memory files into caveman format |
| `find-docs` | Context7 documentation retrieval |
| `ide-index-mcp` | JetBrains IDE Index MCP guide |
| `jetbrains-debugger` | JetBrains Debugger MCP guide |
| `jira-transition` | Batch Jira issue transitions |
| `ship` | verify + commit + push pipeline |
| `verify` | ktlint format + compile + test pipeline |

### MCP Servers (external, configure separately)

- **JetBrains IDE Index** — `ide_find_references`, `ide_find_definition`, etc.
- **JetBrains Debugger** — `start_debug_session`, `set_breakpoint`, etc.
- **Chrome DevTools** — browser automation via Vivaldi
- **FFF** — fast file finder with frecency ranking
- **Codebase Memory** — `search_graph`, `search_code`, `trace_call_path`
