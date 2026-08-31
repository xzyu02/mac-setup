#!/usr/bin/env bash

# FASRC Cannon / Kempner setup.
#
# Links the shared agent configuration on a cluster login node and checks the
# checkout location against the path rules in the FASRC reference section of
# AGENTS.md. Installs nothing and submits no jobs.

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly LINK_AGENT_DOCS_SCRIPT="${SETUP_DIR}/link-agent-docs.sh"
readonly LAB_CODE_DIR="/n/holylabs/schung_lab/Lab/xizheng"
readonly HF_CACHE_DIR="/n/holylabs/schung_lab/Lab/huggingface_cache"

log() {
    printf '\n==> %s\n' "$1"
}

if ! command -v sbatch >/dev/null 2>&1 && [[ ! -d /n/holylabs ]]; then
    printf 'This does not look like a FASRC cluster node.\n' >&2
    printf 'Use setup-mac.sh on the Mac or setup-spark.sh on the Spark machine.\n' >&2
    exit 1
fi

if [[ ! -f "${LINK_AGENT_DOCS_SCRIPT}" ]]; then
    printf 'Agent configuration link script not found at %s.\n' \
        "${LINK_AGENT_DOCS_SCRIPT}" >&2
    exit 1
fi

log "Detected environment: FASRC"
printf '  Case 3 routing applies: follow the FASRC reference in AGENTS.md.\n'
printf '  Never run GPU or heavy compute on a login node; use salloc or sbatch.\n'

log "Checking the checkout location"
if [[ "${SETUP_DIR}" == "${LAB_CODE_DIR}"/* ]]; then
    printf '  %s is in the persistent lab code area.\n' "${SETUP_DIR}"
else
    printf '  Warning: %s is outside %s.\n' "${SETUP_DIR}" "${LAB_CODE_DIR}"
    printf '  The FASRC reference keeps code in the lab folder and $HOME for\n'
    printf '  dotfiles only.\n'
fi

bash "${LINK_AGENT_DOCS_SCRIPT}"

log "Checking the shared Hugging Face cache"
if [[ -d "${HF_CACHE_DIR}" ]]; then
    printf '  %s available.\n' "${HF_CACHE_DIR}"
else
    printf '  Warning: %s not found.\n' "${HF_CACHE_DIR}"
fi
printf '  Export it in job scripts: export HF_HOME=%s\n' "${HF_CACHE_DIR}"

log "Checking Slurm tooling"
for command_name in sbatch squeue salloc spart; do
    if command_path="$(command -v "${command_name}" 2>/dev/null)"; then
        printf '  %-8s %s\n' "${command_name}" "${command_path}"
    else
        printf '  %-8s missing\n' "${command_name}"
    fi
done
printf '  `module` is a shell function and is not checked here.\n'

printf '\nFASRC setup completed.\n'
printf 'Review partitions with spart before submitting jobs.\n'
