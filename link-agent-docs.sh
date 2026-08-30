#!/usr/bin/env bash

# Links the repository's shared agent instruction files into the user-level
# Claude Code and Codex configuration directories. Symlinks are used so that
# `git pull` alone keeps every machine current, with no copy step to re-run.
#
# Safe to run on macOS, the Spark machine, and FASRC login nodes.

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly AGENTS_SOURCE="${SETUP_DIR}/AGENTS.md"
readonly HPC_SOURCE="${SETUP_DIR}/HPC.md"

log() {
    printf '\n==> %s\n' "$1"
}

# link_doc <source> <target>
#
# Creates target as a symlink to source. An existing symlink is repointed. An
# existing regular file is backed up once to <target>.pre-mac-setup before it is
# replaced. An existing directory is treated as a fatal error.
link_doc() {
    local source="$1"
    local target="$2"
    local backup="${target}.pre-mac-setup"

    if [[ ! -f "${source}" ]]; then
        printf 'Agent instruction file not found at %s.\n' "${source}" >&2
        exit 1
    fi

    mkdir -p "$(dirname -- "${target}")"

    if [[ -d "${target}" && ! -L "${target}" ]]; then
        printf '%s is a directory; move or remove it, then run this script again.\n' \
            "${target}" >&2
        exit 1
    fi

    if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source}" ]]; then
        printf '  %s already linked\n' "${target}"
        return 0
    fi

    if [[ -f "${target}" && ! -L "${target}" ]]; then
        if [[ ! -e "${backup}" ]]; then
            cp "${target}" "${backup}"
            printf '  Backed up existing file to %s\n' "${backup}"
        fi
    fi

    ln -sfn "${source}" "${target}"
    printf '  %s -> %s\n' "${target}" "${source}"
}

log "Linking shared agent instruction docs"

link_doc "${AGENTS_SOURCE}" "${HOME}/.claude/CLAUDE.md"
link_doc "${HPC_SOURCE}" "${HOME}/.claude/HPC.md"

# Codex reads ~/.codex/AGENTS.md. Only link it where Codex is actually present so
# the directory is not created on machines that do not use it.
if [[ -d "${HOME}/.codex" ]] || command -v codex >/dev/null 2>&1; then
    link_doc "${AGENTS_SOURCE}" "${HOME}/.codex/AGENTS.md"
else
    printf '  Codex not detected; skipped %s\n' "${HOME}/.codex/AGENTS.md"
fi

printf '\nAgent instruction docs linked. Run `git pull` in %s to update them.\n' \
    "${SETUP_DIR}"
