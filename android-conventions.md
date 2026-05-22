# Android Conventions
Prioritize using android-studio-index MCP tools for code navigation and refactoring.
Prioritize using android-studio-debugger MCP tools to interact with the IDE debugger.
ALWAYS refer to "android -h" for android CLI.

## Build Verification Order

1. **First**: Use `ide_diagnostics` (android-studio-index MCP) to check for compilation errors — faster, no full rebuild.
2. **Only if IDE unavailable or diagnostics insufficient**: Fall back to Gradle build (`./gradlew :<module>:compileDebugKotlin`).

## Testing — Android / Kotlin

- SharedFlow/StateFlow in tests: prefer `UnconfinedTestDispatcher` over `StandardTestDispatcher` to avoid timing issues and test hangs.
- Never use infinite spin-loops or while-loop polling in tests.
- Use Turbine's `test {}` extension for Flow assertions.

## Architecture Conventions

- Create separate repository contracts/interfaces rather than adding methods to existing repositories unless explicitly told otherwise.

## Compose Conventions

- Prefer `LifecycleEventEffect` over manual `LocalLifecycleOwner` + `repeatOnLifecycle` patterns.
- Use `collectAsStateWithLifecycle` instead of `collectAsState`.
