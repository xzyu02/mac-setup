#!/usr/bin/env bash

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BREWFILE_PATH="${SETUP_DIR}/Brewfile"

log() {
    printf '\n==> %s\n' "$1"
}

if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'This bootstrap script supports macOS only.\n' >&2
    exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
    log "Requesting the Xcode Command Line Tools installer"
    xcode-select --install || true
    printf 'Finish the installer, then run ./bootstrap.sh again.\n'
    exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command -v brew >/dev/null 2>&1; then
    brew_executable="$(command -v brew)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_executable="/opt/homebrew/bin/brew"
elif [[ -x /usr/local/bin/brew ]]; then
    brew_executable="/usr/local/bin/brew"
else
    printf 'Homebrew was installed but its executable could not be found.\n' >&2
    exit 1
fi

eval "$("${brew_executable}" shellenv)"

if [[ ! -f "${BREWFILE_PATH}" ]]; then
    printf 'Brewfile not found at %s.\n' "${BREWFILE_PATH}" >&2
    exit 1
fi

log "Installing standard packages from Brewfile"
brew bundle --file="${BREWFILE_PATH}"

log "Checking the Brewfile installation"
brew bundle check --file="${BREWFILE_PATH}"

log "Verifying command-line tools"
missing_command=0
for command_name in brew git node npm npx codex claude; do
    if command_path="$(command -v "${command_name}" 2>/dev/null)"; then
        printf '  %-8s %s\n' "${command_name}" "${command_path}"
    else
        printf '  %-8s missing\n' "${command_name}" >&2
        missing_command=1
    fi
done

if (( missing_command != 0 )); then
    printf 'Bootstrap completed, but one or more expected commands are missing.\n' >&2
    exit 1
fi

printf '\nMac setup bootstrap completed successfully.\n'
