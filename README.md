# Macbook Setup

Setup for my new Mac.
Special Thanks to https://github.com/danvega/new-macbook-setup/tree/master/2021

## Get Started

### Automated setup

From the repository root, run:

```sh
./bootstrap.sh
```

[`bootstrap.sh`](./bootstrap.sh) checks for the Xcode Command Line Tools and
Homebrew, installs them when needed, applies [`Brewfile`](./Brewfile), and
installs Miniforge from its official installer. It then restores the tracked
[VS Code settings](./vscode/settings.json), [Claude Code
settings](./claude/settings.json), and [SSH host configuration](./ssh/config)
before verifying the main command-line tools. If
macOS opens the Xcode Command Line Tools installer, finish the installation and
run the script again. Optional apps and VS Code extensions are not installed by
the script. SSH keys and `known_hosts` are never copied.

For individual Xcode CLI Tools, Homebrew, Brewfile, troubleshooting, and optional
app commands, see [`MANUAL-SETUP.md`](./MANUAL-SETUP.md).

### Python environments with Miniforge

Miniforge replaces Anaconda in this setup. `bootstrap.sh` installs the official
distribution to `~/miniforge3`, initializes `conda` for zsh, and disables
automatic activation of the `base` environment. Both `conda` and `mamba` are
available after opening a new terminal.

Miniforge is intentionally installed with its upstream installer instead of a
Homebrew cask, following the project's installation recommendation. See the
[manual Miniforge steps](./MANUAL-SETUP.md#miniforge) if the bootstrap cannot be
used.

### Git Config
```sh
git config --global user.email ""
git config --global user.name ""
```
Next, https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh

### Verify Node & NPM

Node is installed by `Brewfile` through Homebrew so `node`, `npm`, and `npx` are
available system-wide, including to macOS GUI apps that do not load a
shell-managed Node version. Confirm the installation with:

```sh
which node
which npm
which npx
node -v
npm -v
npx -v
```

Homebrew normally installs the executables under `/opt/homebrew/bin` on Apple
Silicon and `/usr/local/bin` on Intel Macs. Fully restart any GUI app that needs
Node after installation.

### Repository Instructions

Project-specific Codex instructions are kept in [`AGENTS.md`](./AGENTS.md) and
should be synced with the rest of this repository.

### AI Desktop Apps and CLIs

- `chatgpt` installs the ChatGPT desktop app, which includes the Codex desktop
  experience.
- `codex` installs the standalone Codex CLI for terminal workflows.
- `claude` installs the Claude desktop app.
- `claude-code` installs the standalone Claude Code CLI for terminal workflows.

The desktop apps and CLIs are installed separately so both interfaces remain
available. Their account connectors require interactive authorization and are
therefore not configured by `bootstrap.sh`. Follow the [AI apps and connectors
checklist](./MANUAL-SETUP.md#ai-apps-and-connectors) to connect Notion, Gmail,
Google Calendar, and an Obsidian vault after installation.

The global Claude Code configuration is tracked in
[`claude/settings.json`](./claude/settings.json) and restored to
`~/.claude/settings.json` by `bootstrap.sh`. Credentials, sessions, and project
history are never copied. See the [manual Claude Code
steps](./MANUAL-SETUP.md#claude-code-user-settings) to restore it by hand.

### PDF tooling

`poppler` provides `pdftotext`, `pdfimages`, and related utilities that AI
tools use to read PDFs from the command line. Verify it with:

```sh
pdftotext -v
```

### Obsidian Plugins

See [`OBSIDIAN-PLUGINS.md`](./OBSIDIAN-PLUGINS.md) for the current community and
core plugin inventory.

### Oh My Zsh

See [`OH-MY-ZSH.md`](./OH-MY-ZSH.md) for the optimized shell configuration,
lazy Miniforge and SDKMAN loading, preserved custom paths, and startup timing
commands.

### SDKs - Use [SDKMAN](https://sdkman.io/install) could easily manage different SDKs
- Full list of SDKs [https://sdkman.io/sdks](https://sdkman.io/sdks)
- Java - use `sdk install java` to install stable version Java

### Raycast Extensions
- cheatsheet
- search books
- word search
- ocr
- google translate
- myip
- slack
- notion
- ......

### Clean Up Cache
```sh
brew cleanup --prune=all
```
