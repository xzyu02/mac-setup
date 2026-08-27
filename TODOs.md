# TODOs

Last updated: 2026-08-26 23:04:51 EDT

## Planned features

- [ ] linear mouth migration config file if possible?
- [ ] can i migrate screen settings as well (display behavior)

## Completed / fixed features

- [x] Updated the default Homebrew desktop app set to add Hidden Bar and Tailscale while no longer installing Docker or MotrixNext.
- [x] Added reusable SSH aliases for the Spark internal and Tailscale addresses.
- [x] Disabled the VS Code Secondary Side Bar's default visibility so Chat no longer opens automatically in new windows or workspaces.
- [x] Added Microsoft's Python extension to bootstrap setup so VS Code Python support and the tracked Python editor settings work on a new Mac.
- [x] Replaced the floating placeholder Miniforge download with the pinned `26.5.3-0` release and versioned macOS installer filename.
- [x] Added the Microsoft Remote - SSH VS Code extension to bootstrap setup so restored SSH hosts appear in Remote Explorer on a new Mac.
- [x] Preserved the global Claude Code `settings.json` under `claude/` and added safe bootstrap restoration to `~/.claude/settings.json` without migrating credentials, sessions, or project history.
- [x] Added the `poppler` formula to `Brewfile` so `pdftotext` and related PDF utilities used by AI PDF reading are installed by default.
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
