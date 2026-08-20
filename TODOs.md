# TODOs

Last updated: 2026-08-20 13:03:18 EDT

## Planned features

None currently.

## Completed / fixed features

- [x] Documented a reusable Oh My Zsh optimization that avoids duplicate NVM and eager runtime initialization while preserving custom paths, Java, Conda access, and aliases.
- [x] Added a repository-wide Git ignore rule for macOS `.DS_Store` metadata files.
- [x] Documented the manual ChatGPT/Codex and Claude connector setup for Notion, Gmail, Google Calendar, and local Obsidian vault access without storing authentication data.
- [x] Replaced the Anaconda Homebrew cask with an idempotent official Miniforge installation, disabled automatic base activation, and added conda/mamba verification.
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
