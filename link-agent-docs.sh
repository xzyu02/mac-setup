#!/usr/bin/env bash

# Links the repository's shared agent instructions and Claude Code settings into
# the user-level Claude Code and Codex configuration directories. Symlinks are
# used so that `git pull` alone keeps every machine current, with no copy step
# to re-run.
#
# Safe to run on macOS, the Spark machine, and FASRC login nodes.

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly AGENTS_SOURCE="${SETUP_DIR}/AGENTS.md"
readonly CLAUDE_SETTINGS_SOURCE="${SETUP_DIR}/claude/settings.json"
readonly CLAUDE_SKILLS_SOURCE="${SETUP_DIR}/claude/skills"

log() {
    printf '\n==> %s\n' "$1"
}

# link_file <source> <target>
#
# Creates target as a symlink to source. An existing symlink is repointed. An
# existing regular file is backed up once to <target>.pre-mac-setup before it is
# replaced. An existing directory is treated as a fatal error.
link_file() {
    local source="$1"
    local target="$2"
    local backup="${target}.pre-mac-setup"

    if [[ ! -f "${source}" ]]; then
        printf 'Tracked configuration file not found at %s.\n' "${source}" >&2
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

# link_skills
#
# Symlinks each tracked skill directory into ~/.claude/skills/<name>. Skills are
# linked one at a time rather than by linking the whole skills directory, so
# skills installed from elsewhere can live alongside the tracked ones. A real
# directory already at a target is a fatal error; it is never replaced.
link_skills() {
    local target_root="${HOME}/.claude/skills"
    local source_skill target_skill skill_name

    if [[ ! -d "${CLAUDE_SKILLS_SOURCE}" ]]; then
        printf '  No tracked skills directory; skipped %s\n' "${target_root}"
        return 0
    fi

    mkdir -p "${target_root}"

    for source_skill in "${CLAUDE_SKILLS_SOURCE}"/*/; do
        [[ -d "${source_skill}" ]] || continue

        source_skill="${source_skill%/}"
        skill_name="$(basename -- "${source_skill}")"
        target_skill="${target_root}/${skill_name}"

        if [[ -d "${target_skill}" && ! -L "${target_skill}" ]]; then
            printf '  %s is a real directory; move or remove it, then run this script again.\n' \
                "${target_skill}" >&2
            exit 1
        fi

        if [[ -L "${target_skill}" ]] && [[ "$(readlink "${target_skill}")" == "${source_skill}" ]]; then
            printf '  %s already linked\n' "${target_skill}"
            continue
        fi

        ln -sfn "${source_skill}" "${target_skill}"
        printf '  %s -> %s\n' "${target_skill}" "${source_skill}"
    done
}

# The FASRC reference used to be a separate HPC.md linked alongside AGENTS.md.
# Its contents are now a section of AGENTS.md, so the old symlink is dangling and
# is cleaned up here. A real file kept at that path by hand is left alone.
remove_stale_hpc_link() {
    local stale="${HOME}/.claude/HPC.md"

    if [[ ! -L "${stale}" ]]; then
        return 0
    fi

    if [[ "$(readlink "${stale}")" == "${SETUP_DIR}/HPC.md" ]] || [[ ! -e "${stale}" ]]; then
        rm "${stale}"
        printf '  Removed stale symlink %s\n' "${stale}"
        printf '  The FASRC reference is now a section of AGENTS.md.\n'
    fi
}

log "Linking shared agent configuration"

link_file "${AGENTS_SOURCE}" "${HOME}/.claude/CLAUDE.md"
link_file "${CLAUDE_SETTINGS_SOURCE}" "${HOME}/.claude/settings.json"
link_skills
remove_stale_hpc_link

# Codex reads ~/.codex/AGENTS.md. Only link it where Codex is actually present so
# the directory is not created on machines that do not use it.
if [[ -d "${HOME}/.codex" ]] || command -v codex >/dev/null 2>&1; then
    link_file "${AGENTS_SOURCE}" "${HOME}/.codex/AGENTS.md"
else
    printf '  Codex not detected; skipped %s\n' "${HOME}/.codex/AGENTS.md"
fi

printf '\nAgent configuration linked. Run `git pull` in %s to update it.\n' \
    "${SETUP_DIR}"
