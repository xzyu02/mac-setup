# TODOs

Last updated: 2026-08-19 18:13:43 EDT

## Planned features

None currently.

## Completed / fixed features

- [x] Saved the reusable SSH host configuration and added permission-safe bootstrap restoration without copying keys or `known_hosts`.
- [x] Preserved the current VS Code user settings under `vscode/` and added safe bootstrap restoration without migrating extensions.
- [x] Moved manual Xcode CLI Tools, Homebrew, Brewfile, and optional-app instructions into a dedicated guide linked from the README.
- [x] Added an idempotent macOS `bootstrap.sh` for Xcode CLI Tools, Homebrew, Brewfile installation, and command verification.
- [x] Added a declarative `Brewfile` for the standard Mac setup while keeping optional applications outside the default installation.
- [x] Switched Node.js setup from NVM to a system-level Homebrew installation with verification commands.
- [x] Added shared repository instructions for Codex and Claude Code through `AGENTS.md` and `CLAUDE.md`.
- [x] Documented separate Homebrew installs for the ChatGPT and Claude desktop apps and the Codex and Claude Code CLIs.
- [x] Added a versioned inventory of the currently installed and enabled Obsidian community and core plugins.
- [x] Made TODO maintenance optional for routine changes unless `TODOs.md` already exists or the user explicitly requests tracking.
