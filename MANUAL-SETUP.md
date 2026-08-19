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
```

VS Code extensions are intentionally not exported or restored because the
current machine contains extensions that should not be carried to a new Mac.

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
