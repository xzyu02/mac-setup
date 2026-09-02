---
name: fasrc
description: The FASRC Cannon and Kempner cluster reference — partitions and what each is for, per-GPU core and memory caps, Kempner GPU holding limits, requeue constraints, Python environment creation and activation, the job script template, and the Slurm monitoring commands. Load before naming any partition, account, #SBATCH option, or cluster environment command, including when writing or editing a job script from a Mac or the Spark machine.
---

# FASRC Cannon / Kempner reference

The authority on cluster partitions, Slurm options, and Python environments.
Use these values exactly as written; do not guess a partition, account, or
resource figure that is not here.

The lab paths and a sample `#SBATCH` header are kept inline in `AGENTS.md`, so
they are already in context. Everything else is here.

## Slurm

Kempner account: `-A kempner_schung_lab`. Check currently available partitions
with `spart`.

### Partition Guide

| Partition | Use |
|---|---|
| `test` | short CPU setup/debug jobs |
| `shared` | normal CPU jobs |
| `intermediate` | CPU jobs up to 14 days |
| `bigmem` / `bigmem_intermediate` | high-memory CPU jobs |
| `gpu` / `gpu_h200` | general FASRC GPU jobs |
| `gpu_test` | short GPU tests |
| `gpu_requeue` | opportunistic/preemptible GPU jobs |
| `kempner` | A100, prototyping / small-mid models |
| `kempner_h100` | H100, larger training / FP8 |
| `kempner_h200` | H200, largest or memory-heavy workloads |
| `kempner_rtx` | RTX 6000; FP4/RT, avoid heavy multi-GPU sharding |
| `kempner_requeue` | preemptible Kempner jobs; use for non-urgent heavy work |

Other accessible partitions include `serial_requeue`, `sapphire`, `remoteviz`,
`unrestricted`, `kempner_interactive`, and `kempner_gpu_priority`; inspect with
`spart` / `sinfo` before using them.

### GPU Node Specs

Kempner scheduling caps — submit with no more than this per requested GPU:

| Partition | Per GPU |
|---|---|
| `kempner` | **16 cores, 240 GB** |
| `kempner_h100` | **24 cores, 360 GB** |
| `kempner_h200` | **16 cores, 360 GB** |
| `kempner_rtx` | **16 cores, 180 GB** |

`kempner_h200` takes H100's memory ceiling but A100's core ceiling, so an H100
script moved to it must drop from 24 cores to 16.

### GPU Constraints on Requeue

For `gpu_requeue`, optionally select the GPU type with:

```bash
#SBATCH --constraint=h100   # H100, A100, H200 ...
```

### Kempner Limits

Summed across `kempner`, `kempner_h100`, `kempner_h200`, and `kempner_rtx`:

- A user may hold at most **16 GPUs** at once.
- An account, such as `kempner_schung_lab`, may hold at most **96 GPUs** at once.

`kempner_requeue` and `gpu_requeue` are preemptible. Jobs using them must
checkpoint and support restart/requeue.

### Typical job

```bash
#!/bin/bash
#SBATCH -A kempner_schung_lab
#SBATCH -p kempner_h100
#SBATCH --gres=gpu:1
#SBATCH -c 24
#SBATCH --mem=360G
#SBATCH -t 0-04:00
#SBATCH -o /n/netscratch/schung_lab/Lab/xizheng/logs/%x_%j.out

module load python
source activate /n/holylabs/schung_lab/Lab/xizheng/envs/<name>
export HF_HOME=/n/holylabs/schung_lab/Lab/huggingface_cache

python train.py
```

### Checking Jobs and Resource Usage

```bash
squeue --me                              # your pending and running jobs
sacct -j <job_id>                        # state, elapsed, exit code, MaxRSS
sacct -j <job_id> --format=JobID,JobName,Partition,State,Elapsed,ReqMem,MaxRSS,ExitCode
sacct -S 2026-08-01                      # everything since a date
jobstats <job_id>                        # requested vs used CPU and memory
```

`jobstats` works on running and completed jobs. Check it before resubmitting to
right-size `-c` and `--mem` instead of guessing: over-requesting memory or cores
lowers fairshare and lengthens the queue wait, while under-requesting memory
gets the job killed.

### Job Priority

Priority is fairshare (lower recent usage ranks higher) plus job age, so even
with low fairshare queued jobs move up over time. View a partition's pending
queue with `showq -o -p <partition>`.

## Python Environments

Envs live at `/n/holylabs/schung_lab/Lab/xizheng/envs/<name>`. List them with
`ls` first and reuse a match; otherwise use `dev` for early experiments or a
project-specific env. Create on a compute node:

```bash
salloc -p test -c 2 --mem=4GB -t 0-02:00
module load python          # provides mamba
mamba create --prefix /n/holylabs/schung_lab/Lab/xizheng/envs/<name> \
  -c conda-forge python=3.12 pip wheel
```

Activate with:

```bash
module load python
source activate /n/holylabs/schung_lab/Lab/xizheng/envs/<name>
```

Rules:
- Use `source activate`, not `mamba activate`.
- `pip install` only inside an activated env.
- Never `sbatch` from an activated env.
- No `conda init` block in `~/.bashrc`.
- Use `conda-forge`; `repo.anaconda.com` is blocked.
- Explicitly install CUDA-compatible builds for GPU envs.

## Path Shortcuts

Two `$HOME` symlinks point at the lab areas, with matching `cd` aliases. Create
the symlinks once on a login node, and keep the aliases in `~/.bashrc`:

```bash
ln -sfn /n/holylabs/schung_lab/Lab/xizheng "$HOME/lab"
ln -sfn /n/netscratch/schung_lab/Lab/xizheng "$HOME/scratch"

alias cdlab='cd ~/lab'            # /n/holylabs/schung_lab/Lab/xizheng/
alias cdscratch='cd ~/scratch'    # /n/netscratch/schung_lab/Lab/xizheng/
```

These are conveniences for interactive shells only. Keep writing the full
`/n/holylabs/...` and `/n/netscratch/...` paths in `#SBATCH` directives, job
scripts, and config files — Slurm does not expand `~` in options such as
`#SBATCH -o`, and aliases do not exist in non-interactive job shells.
