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
[VS Code settings](./vscode/settings.json) and [SSH host
configuration](./ssh/config), links the [Claude Code
settings](./claude/settings.json), and installs the required VS Code Remote -
SSH and Python extensions before verifying the main command-line tools. If
macOS opens the Xcode Command Line Tools installer, finish the installation and
run the script again. Other VS Code extensions are not installed by the script.
SSH keys and `known_hosts` are never copied.

For individual Xcode CLI Tools, Homebrew, Brewfile, troubleshooting, and optional
app commands, see [`MANUAL-SETUP.md`](./MANUAL-SETUP.md).

### Python environments with Miniforge

Miniforge replaces Anaconda in this setup. `bootstrap.sh` installs the official
distribution to `~/miniforge3`, initializes `conda` for zsh, and disables
automatic activation of the `base` environment. Both `conda` and `mamba` are
available after opening a new terminal.

Miniforge `26.5.3-0` is installed with its pinned upstream installer instead of
a Homebrew cask, following the project's installation recommendation. See the
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

### Shared agent configuration

[`AGENTS.md`](./AGENTS.md) holds the shared Codex and Claude Code instructions,
including the compute environment routing rules and the FASRC Cannon / Kempner
reference. This repository is the single source of truth for that file on every
machine: the Mac, the Spark machine, and FASRC.

[`link-agent-docs.sh`](./link-agent-docs.sh) symlinks the instructions and the
tracked Claude Code settings into the user-level configuration directories so
they stay current in every project:

```text
~/.claude/CLAUDE.md  ->  AGENTS.md
~/.claude/settings.json -> claude/settings.json
~/.codex/AGENTS.md   ->  AGENTS.md   (only when Codex is present)
```

The FASRC reference is kept inline in `AGENTS.md` rather than in a separate
file. Instruction files are loaded once per session, so an inline section is
always in context, while a separate file has to be read on demand and can drop
out of a long session after a context compaction.

Symlinks are used instead of copies so `git pull` is the only step needed to
update a machine. An existing regular file at any target is backed up once to
`<target>.pre-mac-setup` before it is replaced, and re-running the script is
safe.

#### Per-device setup scripts

Each device has its own setup script, and each refuses to run on the wrong kind
of machine. Run the matching one once after cloning:

| Device | Script | Purpose |
|---|---|---|
| Mac | [`setup-mac.sh`](./setup-mac.sh) | Links the agent instructions and Claude settings |
| Spark | [`setup-spark.sh`](./setup-spark.sh) | Links the agent configuration, reports the local GPU |
| FASRC | [`setup-hpc.sh`](./setup-hpc.sh) | Links the agent configuration, checks the checkout path and shared HF cache |

All three delegate the linking to `link-agent-docs.sh`, which is the only
cross-platform piece. None of them install packages or submit jobs.

[`bootstrap.sh`](./bootstrap.sh) installs accessories and applications on a new
Mac and invokes the same linking helper. It must not be run on the Spark machine
or on FASRC.

On FASRC, clone into the persistent lab code area rather than `$HOME`, following
the path rules in the FASRC reference section of [`AGENTS.md`](./AGENTS.md):

```sh
git clone <repo-url> /n/holylabs/schung_lab/Lab/xizheng/mac-setup
```

The per-device script only needs to run once per machine. After that, keep each
machine current with a plain pull. Adding a shell alias makes this easy to
remember:

```sh
alias agentsync='git -C ~/dev/mac-setup pull'
```

Point the alias at the local checkout on each machine, since the clone path
differs: `~/dev/mac-setup` on the Mac, `~/mac-setup` on the Spark machine, and
the lab code area on FASRC.

The symlinks always match the local checkout, so the only drift to watch for is
a machine whose checkout is behind the remote.

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
[`claude/settings.json`](./claude/settings.json) and symlinked to
`~/.claude/settings.json` by every per-device setup script and by `bootstrap.sh`.
Credentials, sessions, and project history are never copied. See the [manual
Claude Code steps](./MANUAL-SETUP.md#claude-code-user-settings) to link it by
hand.

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
