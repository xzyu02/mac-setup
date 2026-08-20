#!/usr/bin/env bash

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BREWFILE_PATH="${SETUP_DIR}/Brewfile"
readonly MINIFORGE_DIR="${HOME}/miniforge3"
readonly SSH_CONFIG_SOURCE="${SETUP_DIR}/ssh/config"
readonly VSCODE_SETTINGS_SOURCE="${SETUP_DIR}/vscode/settings.json"

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

log "Installing Miniforge"
miniforge_conda="${MINIFORGE_DIR}/bin/conda"

if [[ -x "${miniforge_conda}" ]]; then
    printf '  Existing Miniforge installation found at %s.\n' "${MINIFORGE_DIR}"
elif [[ -e "${MINIFORGE_DIR}" ]]; then
    printf '%s exists but does not contain a usable Miniforge installation.\n' \
        "${MINIFORGE_DIR}" >&2
    printf 'Move or remove that directory, then run ./bootstrap.sh again.\n' >&2
    exit 1
else
    machine_architecture="$(uname -m)"
    case "${machine_architecture}" in
        arm64 | x86_64) ;;
        *)
            printf 'Unsupported macOS architecture: %s\n' "${machine_architecture}" >&2
            exit 1
            ;;
    esac

    miniforge_installer="$(mktemp "${TMPDIR:-/tmp}/miniforge-installer.XXXXXX")"
    miniforge_url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-${machine_architecture}.sh"

    if ! curl -fsSLo "${miniforge_installer}" "${miniforge_url}"; then
        rm -f "${miniforge_installer}"
        printf 'Failed to download Miniforge from %s.\n' "${miniforge_url}" >&2
        exit 1
    fi

    if ! bash "${miniforge_installer}" -b -p "${MINIFORGE_DIR}"; then
        rm -f "${miniforge_installer}"
        printf 'Miniforge installation failed.\n' >&2
        exit 1
    fi
    rm -f "${miniforge_installer}"
fi

"${miniforge_conda}" init zsh
"${miniforge_conda}" config --set auto_activate_base false
export PATH="${MINIFORGE_DIR}/condabin:${MINIFORGE_DIR}/bin:${PATH}"
printf '  Miniforge initialized for zsh; automatic base activation is disabled.\n'

log "Restoring VS Code user settings"
vscode_user_dir="${HOME}/Library/Application Support/Code/User"
vscode_settings_target="${vscode_user_dir}/settings.json"
vscode_settings_backup="${vscode_settings_target}.pre-mac-setup"

if [[ ! -f "${VSCODE_SETTINGS_SOURCE}" ]]; then
    printf 'VS Code settings not found at %s.\n' "${VSCODE_SETTINGS_SOURCE}" >&2
    exit 1
fi

mkdir -p "${vscode_user_dir}"

if [[ -f "${vscode_settings_target}" ]] &&
    ! cmp -s "${VSCODE_SETTINGS_SOURCE}" "${vscode_settings_target}"; then
    if [[ ! -e "${vscode_settings_backup}" ]]; then
        cp "${vscode_settings_target}" "${vscode_settings_backup}"
        printf '  Backed up existing settings to %s\n' "${vscode_settings_backup}"
    fi
fi

if [[ ! -f "${vscode_settings_target}" ]] ||
    ! cmp -s "${VSCODE_SETTINGS_SOURCE}" "${vscode_settings_target}"; then
    cp "${VSCODE_SETTINGS_SOURCE}" "${vscode_settings_target}"
    printf '  Installed %s\n' "${vscode_settings_target}"
else
    printf '  Existing VS Code settings already match the repository.\n'
fi

printf '  VS Code extensions are intentionally not migrated.\n'

log "Restoring SSH host configuration"
ssh_user_dir="${HOME}/.ssh"
ssh_config_target="${ssh_user_dir}/config"
ssh_config_backup="${ssh_config_target}.pre-mac-setup"

if [[ ! -f "${SSH_CONFIG_SOURCE}" ]]; then
    printf 'SSH configuration not found at %s.\n' "${SSH_CONFIG_SOURCE}" >&2
    exit 1
fi

mkdir -p "${ssh_user_dir}"
chmod 700 "${ssh_user_dir}"

if [[ -f "${ssh_config_target}" ]] &&
    ! cmp -s "${SSH_CONFIG_SOURCE}" "${ssh_config_target}"; then
    if [[ ! -e "${ssh_config_backup}" ]]; then
        cp "${ssh_config_target}" "${ssh_config_backup}"
        chmod 600 "${ssh_config_backup}"
        printf '  Backed up existing config to %s\n' "${ssh_config_backup}"
    fi
fi

if [[ ! -f "${ssh_config_target}" ]] ||
    ! cmp -s "${SSH_CONFIG_SOURCE}" "${ssh_config_target}"; then
    cp "${SSH_CONFIG_SOURCE}" "${ssh_config_target}"
    printf '  Installed %s\n' "${ssh_config_target}"
else
    printf '  Existing SSH config already matches the repository.\n'
fi

chmod 600 "${ssh_config_target}"
printf '  SSH keys and known_hosts are intentionally not migrated.\n'

log "Verifying command-line tools"
missing_command=0
for command_name in brew git node npm npx conda mamba codex claude; do
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
printf 'Complete AI connector authorization in MANUAL-SETUP.md.\n'
