#!/usr/bin/env bash

# Spark machine setup.
#
# Links the shared agent configuration and reports the local GPU tooling.
# Installs nothing: the Spark machine is provisioned separately.

set -euo pipefail

readonly SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly LINK_AGENT_DOCS_SCRIPT="${SETUP_DIR}/link-agent-docs.sh"

log() {
    printf '\n==> %s\n' "$1"
}

if [[ "$(uname -s)" != "Linux" ]]; then
    printf 'setup-spark.sh supports Linux only.\n' >&2
    printf 'Use setup-mac.sh on the Mac.\n' >&2
    exit 1
fi

if command -v sbatch >/dev/null 2>&1; then
    printf 'Slurm was detected, so this looks like a cluster node, not Spark.\n' >&2
    printf 'Use setup-hpc.sh instead.\n' >&2
    exit 1
fi

if [[ ! -f "${LINK_AGENT_DOCS_SCRIPT}" ]]; then
    printf 'Agent configuration link script not found at %s.\n' \
        "${LINK_AGENT_DOCS_SCRIPT}" >&2
    exit 1
fi

log "Detected environment: Spark"
printf '  Case 2 routing applies: local GPU work under 15 minutes stays local.\n'
printf '  Heavy, long, or fan-out jobs go to FASRC sbatch.\n'

bash "${LINK_AGENT_DOCS_SCRIPT}"

log "Checking local GPU"
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader |
        sed 's/^/  /'

    gpu_memory="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader |
        head -1)"

    # Unified-memory parts such as GB10 report no discrete VRAM. There the total
    # system memory is the GPU-accessible pool, and it is what actually bounds a
    # local job under the Case 2 routing rules.
    if [[ "${gpu_memory}" == *N/A* ]]; then
        if [[ -r /proc/meminfo ]]; then
            memory_kb="$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)"
            printf '  unified memory, %s GiB total system memory\n' \
                "$(( memory_kb / 1024 / 1024 ))"
        else
            printf '  unified memory, total unknown\n'
        fi
    else
        printf '  %s dedicated GPU memory\n' "${gpu_memory}"
    fi
else
    printf '  nvidia-smi missing; local GPU work is not available.\n'
fi

log "Checking agent tooling"
for command_name in git python3 claude codex; do
    if command_path="$(command -v "${command_name}" 2>/dev/null)"; then
        printf '  %-8s %s\n' "${command_name}" "${command_path}"
    else
        printf '  %-8s missing\n' "${command_name}"
    fi
done

printf '\nSpark setup completed.\n'
