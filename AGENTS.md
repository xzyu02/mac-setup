# Repository Instructions

- Choose the simplest implementation that fully meets the current requirements.
- Prefer established, well-maintained libraries over custom implementations.

## TODO maintenance

- Maintain `TODOs.md` only when it already exists in the repository or the user explicitly asks for TODO tracking. Do not create it solely for a routine change.
- When TODO tracking is in use, record completed work as a checked (`[x]`) item with enough detail to identify the original issue and its resolution.
- Preserve unfinished items as unchecked (`[ ]`) entries. Do not mark an item complete until the implementation and appropriate verification are finished.
- Keep completed fixes and working features in a dedicated **Completed / fixed features** section.
- Keep future work and unfinished features in a separate **Planned features** section. Do not leave checked items mixed into the planned section; move them to the completed section when they are finished.
- Use `TODOs.md` as the canonical project TODO file. Do not create timestamped or alternate TODO files unless requested.
- Every time `TODOs.md` is changed, refresh its `Last updated: YYYY-MM-DD HH:MM:SS TZ` line using the current local date, time, and timezone.

## Preserve existing functionality

- Do not remove, replace, or silently weaken an existing function, feature, interaction, or visual behavior unless the user explicitly asks for its removal or the change is strictly required by the request.
- Treat refactors and screen rebuilds as behavior-preserving work. Before replacing an existing implementation, inspect the current behavior and relevant Git history so previously supported functionality is carried forward.
- When new requirements overlap an existing feature, extend the feature instead of discarding older behavior. If the requirements genuinely conflict, ask for direction or clearly explain the necessary tradeoff before removing anything.
- After changes, verify both the requested behavior and nearby existing behavior that could regress. Add or update regression coverage when practical.

## Git commits

- Start every commit message subject with an appropriate type tag, such as `[WIP]`, `[FEA]`, `[MRG]`, or `[FIX]`.
- Write a concise subject line followed by a descriptive body whenever the commit contains completed features or fixes.
- When `TODOs.md` is in use, stage the implementation and its `TODOs.md` updates in the same commit, with every included feature or fix recorded under **Completed / fixed features**. Never leave a required TODO update unstaged or for a later commit.
- List in the body exactly the checked TODO items covered by the staged changes — all of them, and no unrelated historical entries. Do not reduce a multi-feature commit to a single line or to one of several included TODOs.

## Handoff documents

When asked to write or update a handoff document (including requests that spell it `HANDOFF.md` or `HANDSOFF.md`), create or update the requested Markdown file with current, verified information. Include all of the following sections:

1. **What changed** — the implementation completed during the work period, including important behavior and files changed.
2. **Issues remaining** — known bugs, caveats, incomplete integrations, and anything that still needs device or visual QA.
3. **TODOs remaining** — all relevant unchecked work from `TODOs.md`, summarized without presenting completed work as outstanding.
4. **Codebase structure** — the app’s architecture, major directories, important files, data flow, and where future work should be made.
5. **Verification** — commands or manual checks run, their results, and any verification that could not be performed.

Before writing a handoff, inspect the current working tree, `TODOs.md`, and any existing handoff file. Do not copy stale claims from an older handoff without confirming them against the current codebase. Mention uncommitted changes when present.


## Compute environment routing

Before starting any GPU, training, or large-scale compute work, determine the
current environment and follow the matching case. Detect it, do not assume:

- **Mac** — `uname -s` is `Darwin`.
- **Spark** — Linux with a local NVIDIA GPU (`nvidia-smi` succeeds) and no
  Slurm (`sbatch` not on `PATH`).
- **FASRC** — Slurm is available (`sbatch` on `PATH`) or `/n/holylabs` exists.

State the detected environment before proposing where a job should run.
Never silently downgrade a GPU job to CPU, shrink a model, or cut steps to make
it fit locally. If the work does not fit the current machine, say so and ask.

### Case 1 — Local Mac

The Mac is for light work only: code edits, refactors, unit tests, small
CPU-light checks, dry runs, and config/shape inspection.

- Do not run GPU jobs, and do not run heavy CPU jobs either — no training, no
  large data processing, no long-running or memory-hungry work.
- Do not install CUDA-only dependencies on the Mac.
- For anything heavier, never `ssh` to the cluster, transfer data, or `sbatch`
  without explicit approval in the current session — present the plan first:
  partition, GPU count, time limit, and target paths. Approval for one job is
  not approval for the next.
- Writing HPC scripts locally is fine and encouraged — authoring a `sbatch`
  script is not the same as submitting it.

### Case 2 — Spark machine (local GPU available)

Keep local anything that fits the local GPU and finishes in well under
15 minutes:

- Correctness and smoke tests, single-config debug runs, shape/dtype checks.
- Short profiling and small-batch inference.

Route to FASRC `sbatch` when the job is heavy or fans out:

- Full training or fine-tuning runs, and long evaluation suites.
- Hyperparameter sweeps, seed sweeps, ablations, or anything that benefits from
  many concurrent jobs.
- Multi-GPU or multi-node work, or a model/batch that does not fit local memory.
- Anything expected to exceed 15 minutes, or that should survive disconnection.

Before submitting, confirm the local run passed at small scale — use Spark as
the debug tier so cluster jobs do not fail on trivial errors. Ask permission
before the first submission of a task, then report job IDs and log paths.

### Case 3 — On FASRC (Cannon / Kempner)

- Never run GPU or heavy compute on a login node; use `salloc` or `sbatch`.
- Use the paths, accounts, partitions, and environment conventions in the FASRC
  reference below exactly as written.

## FASRC Cannon / Kempner reference

This is the authority on cluster paths, accounts, partitions, Slurm options, and
Python environments, in all three routing cases — including when writing job
scripts from a Mac or the Spark machine.

### Paths

- User: `xzyu`; lab folder: **`xizheng`** — do not use `$USER` in lab paths.
- Code / envs / projects: `/n/holylabs/schung_lab/Lab/xizheng/`
- Job I/O / checkpoints / logs: `/n/netscratch/schung_lab/Lab/xizheng/`
- Shared HF cache:

```bash
export HF_HOME=/n/holylabs/schung_lab/Lab/huggingface_cache
```

Use `holylabs` for persistent code/project files, not training output.  
Use `netscratch` for job output; retention is ~90 days.  
Keep `$HOME` for dotfiles/config only.

#### Path Shortcuts

Two symlinks in `$HOME` point at the two lab areas, with matching `cd` aliases:

| Shortcut | Alias | Target |
|---|---|---|
| `~/lab` | `cdlab` | `/n/holylabs/schung_lab/Lab/xizheng/` |
| `~/scratch` | `cdscratch` | `/n/netscratch/schung_lab/Lab/xizheng/` |

Create the symlinks once on a login node:

```bash
ln -sfn /n/holylabs/schung_lab/Lab/xizheng "$HOME/lab"
ln -sfn /n/netscratch/schung_lab/Lab/xizheng "$HOME/scratch"
```

And define the aliases in `~/.bashrc`:

```bash
alias cdlab='cd ~/lab'
alias cdscratch='cd ~/scratch'
```

These are conveniences for interactive shells only. Keep writing the full
`/n/holylabs/...` and `/n/netscratch/...` paths in `#SBATCH` directives, job
scripts, and config files — Slurm does not expand `~` in options such as
`#SBATCH -o`, and aliases do not exist in non-interactive job shells.

### Python Environments

Mamba is provided by:

```bash
module load python
```

Envs live at:

```text
/n/holylabs/schung_lab/Lab/xizheng/envs/<name>
```

Before creating one:

```bash
ls /n/holylabs/schung_lab/Lab/xizheng/envs
```

Reuse a matching env. Otherwise use `dev` for early experiments or a project-specific env.

Create envs on a compute node:

```bash
salloc -p test -c 2 --mem=4GB -t 0-02:00
module load python
mamba create --prefix /n/holylabs/schung_lab/Lab/xizheng/envs/<name>   -c conda-forge python=3.12 pip wheel
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

### Slurm

Kempner account:

```bash
-A kempner_schung_lab
```

Check currently available partitions with:

```bash
spart
```

#### Partition Guide

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

#### GPU Node Specs

Physical node capacity:
- A100 node: **64 CPU cores, 1 TB RAM**
- H100 node: **96 CPU cores, 1.5 TB RAM**

Kempner scheduling caps are lower per requested GPU:
- `kempner` / A100: up to **16 CPU cores + 240 GB RAM per GPU**
- `kempner_h100` / H100: up to **24 CPU cores + 360 GB RAM per GPU**

Do not confuse full-node hardware capacity with per-GPU scheduling limits. For a
1-GPU H100 job, normally request at most:

```bash
#SBATCH -c 24
#SBATCH --mem=360G
```

#### GPU Constraints on Requeue

For `gpu_requeue`, optionally select the GPU type with:

```bash
#SBATCH --constraint=h100   # H100
#SBATCH --constraint=a100   # A100
```

#### Kempner Limits

Across `kempner`, `kempner_h100`, `kempner_h200`, and `kempner_rtx`:

- Max **16 GPUs per user**
- Max **96 GPUs per Kempner account**

`kempner_requeue` and `gpu_requeue` are preemptible. Jobs using them must
checkpoint and support restart/requeue.

Typical job:

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

#### Checking Jobs and Resource Usage

List your own pending and running jobs:

```bash
squeue --me
```

Review finished jobs — state, elapsed time, exit code, memory high-water mark:

```bash
sacct -j <job_id>
sacct -j <job_id> --format=JobID,JobName,Partition,State,Elapsed,ReqMem,MaxRSS,ExitCode
sacct -S 2026-08-01                      # everything since a date
```

Check what a job actually consumed with:

```bash
jobstats <job_id>
```

It reports requested versus used CPU and memory for a running or completed job.
Use it before resubmitting a job to right-size `-c` and `--mem` instead of
guessing: over-requesting memory or cores lowers fairshare and lengthens the
queue wait, while under-requesting memory gets the job killed.

#### Job Priority

Priority is fairshare (lower recent usage ranks higher) plus job age, so even
with low fairshare queued jobs move up over time. View a partition's pending
queue with:

```bash
showq -o -p <partition>
```
