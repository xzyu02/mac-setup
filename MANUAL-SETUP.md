# Manual Mac Setup

Use these steps when [`bootstrap.sh`](./bootstrap.sh) cannot be used or when a
setup step needs to be run individually.

## Xcode Command Line Tools

Request Apple's installer:

```sh
xcode-select --install
```

Finish the macOS installer before continuing. Confirm the tools are available:

```sh
xcode-select -p
```

## Homebrew

Install [Homebrew](https://brew.sh/):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the installer output to add Homebrew to the current shell. Homebrew is
normally installed under `/opt/homebrew` on Apple Silicon and `/usr/local` on
Intel Macs.

## Standard packages and apps

From this repository's root, apply [`Brewfile`](./Brewfile):

```sh
brew bundle
brew bundle check
```

`brew bundle` can be run again: installed entries are reused and missing entries
are installed.

## AI apps and connectors

`Brewfile` installs the ChatGPT desktop app (including Codex), Codex CLI, Claude
Desktop, Claude Code, and Obsidian. The connector setup below remains manual
because each service requires an account login, OAuth consent, and sometimes a
workspace administrator's approval. Do not commit OAuth tokens, app caches, or
generated connector configuration to this repository.

### ChatGPT and Codex

ChatGPT and Codex use the same public plugin catalog, but install and enable the
plugins from each environment where they will be used:

1. Open ChatGPT Desktop and sign in.
2. Open **Plugins**, then install **Notion**, **Gmail**, and **Google Calendar**.
3. Select **Connect** when prompted and complete each service's authorization.
4. Start a new Chat or Codex task, then test each plugin with `@Notion`,
   `@Gmail`, or `@Google Calendar`.
5. Start Codex CLI, enter `/plugins`, install the same three plugins, and start a
   new CLI session so their skills and tools are loaded.

Connector login cannot be automated by `bootstrap.sh`. Plugin availability can
also depend on the account plan, region, and workspace policy. See the official
[ChatGPT and Codex plugin guide](https://learn.chatgpt.com/docs/plugins).

There is no first-party Obsidian connector documented in the current OpenAI
plugin guide. To work on a local Obsidian vault, use Codex inside the ChatGPT
desktop app and open the vault directory as the task workspace, or run Codex CLI
from the vault root:

```sh
cd "/path/to/Obsidian Vault"
codex
```

Grant access only to the intended vault. A third-party Obsidian MCP/plugin is
optional; inspect its permissions and source before installing it.

### Claude Desktop and Claude Code

Claude's remote connectors are account based. Once connected, they are
available across supported Claude surfaces, including Claude Desktop and Claude
Code:

1. Open Claude Desktop and sign in.
2. Go to **Customize > Connectors** and open the connector directory.
3. Connect **Notion**, **Gmail**, and **Google Calendar**, then complete each
   authorization flow.
4. For Team or Enterprise accounts, ask an owner to enable the connectors if
   they are unavailable.
5. Start a new Claude Desktop chat and a new Claude Code session, then confirm
   each connector is available.

For an Obsidian vault, the simplest Claude Code setup is to start it from the
vault root:

```sh
cd "/path/to/Obsidian Vault"
claude
```

For Claude Desktop, open **Settings > Extensions** and install a trusted local
filesystem or Obsidian desktop extension if one is available. Local extensions
are machine-specific and still require interactive permission, so they are not
part of the automated bootstrap. See Anthropic's [connector
guide](https://support.claude.com/en/articles/11176164-use-connectors-to-extend-claude-s-capabilities)
and [desktop extension
guide](https://support.claude.com/en/articles/10949351-getting-started-with-local-mcp-servers-on-claude-desktop).

## Miniforge

[Miniforge](https://github.com/conda-forge/miniforge) provides a minimal
`conda` and `mamba` installation that uses conda-forge by default. Install the
official build for the Mac's architecture:

```sh
miniforge_version="26.5.3-0"
miniforge_installer="$(mktemp "${TMPDIR:-/tmp}/miniforge-installer.XXXXXX")"
curl -fsSLo "$miniforge_installer" \
    "https://github.com/conda-forge/miniforge/releases/download/$miniforge_version/Miniforge3-$miniforge_version-MacOSX-$(uname -m).sh"
bash "$miniforge_installer" -b -p "$HOME/miniforge3"
rm -f "$miniforge_installer"
"$HOME/miniforge3/bin/conda" config --set auto_activate_base false
```

Open a new terminal, then verify `conda --version` and `mamba --version`.
Miniforge is kept outside `Brewfile` because its upstream project does not
recommend Homebrew's repackaged installation. Configure the lazy Conda loader
from [`OH-MY-ZSH.md`](./OH-MY-ZSH.md) instead of running `conda init zsh`. The
installer is pinned to Miniforge `26.5.3-0` so new Macs do not silently receive
a different release when GitHub's `latest` alias changes.

## VS Code settings

The canonical VS Code user configuration is tracked in
[`vscode/settings.json`](./vscode/settings.json). `bootstrap.sh` copies it to the
standard macOS VS Code user directory and saves a different existing file once
as `settings.json.pre-mac-setup` before replacing it.

To restore it manually from the repository root:

```sh
vscode_user_dir="$HOME/Library/Application Support/Code/User"
mkdir -p "$vscode_user_dir"
cp vscode/settings.json "$vscode_user_dir/settings.json"
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-python.python
```

The bootstrap installs Microsoft's Remote - SSH and Python extensions so the
restored SSH hosts appear in Remote Explorer and the tracked Python editor
settings work. Other VS Code extensions are intentionally not exported or
restored because the current machine contains extensions that should not be
carried to a new Mac.

## Claude Code user settings

The canonical global Claude Code configuration is tracked in
[`claude/settings.json`](./claude/settings.json). `bootstrap.sh` copies it to
`~/.claude/settings.json` and saves a different existing file once as
`settings.json.pre-mac-setup` before replacing it.

To restore it manually from the repository root:

```sh
mkdir -p ~/.claude
cp claude/settings.json ~/.claude/settings.json
```

Only `settings.json` is tracked. Credentials, sessions, shell snapshots,
project history, and per-project `settings.local.json` files stay on the
machine that created them and must never be committed.

## SSH host configuration

The reusable SSH host list is tracked in [`ssh/config`](./ssh/config).
`bootstrap.sh` restores it to `~/.ssh/config`, uses permissions `700` for the
directory and `600` for the config, and saves a different existing file once as
`config.pre-mac-setup`.

To restore it manually from the repository root:

```sh
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config
```

Private keys, public keys, and `known_hosts` are intentionally excluded. Restore
or generate the referenced `~/.ssh/id_ed25519` separately and add its public key
to the appropriate services.

## Optional apps

These applications are intentionally excluded from `Brewfile`. Install only the
ones needed on a particular Mac:

```sh
brew install --cask youdaodict \
    eudic \
    transocks \
    mendeley \
    dropzone \
    alt-tab \
    monitorcontrol
```
