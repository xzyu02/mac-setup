#!/usr/bin/env bash

# Mac agent configuration.
#
# Links the shared agent instruction docs on the local Mac. Accessory and
# application installation is handled separately by bootstrap.sh.

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly LINK_AGENT_DOCS_SCRIPT="${SETUP_DIR}/link-agent-docs.sh"

log() {
    printf '\n==> %s\n' "$1"
}

if [[ "$(uname -s)" != "Darwin" ]]; then
    printf 'setup-mac.sh supports macOS only.\n' >&2
    printf 'Use setup-spark.sh on the Spark machine or setup-hpc.sh on FASRC.\n' >&2
    exit 1
fi

if [[ ! -f "${LINK_AGENT_DOCS_SCRIPT}" ]]; then
    printf 'Agent doc link script not found at %s.\n' "${LINK_AGENT_DOCS_SCRIPT}" >&2
    exit 1
fi

log "Detected environment: Mac"
printf '  Case 1 routing applies: light edits and CPU-light work only.\n'

bash "${LINK_AGENT_DOCS_SCRIPT}"

log "Checking agent tooling"
for command_name in git claude codex; do
    if command_path="$(command -v "${command_name}" 2>/dev/null)"; then
        printf '  %-8s %s\n' "${command_name}" "${command_path}"
    else
        printf '  %-8s missing\n' "${command_name}"
    fi
done

printf '\nMac agent configuration completed.\n'
printf 'Run ./bootstrap.sh separately to install Mac accessories and apps.\n'
