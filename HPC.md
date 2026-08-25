# FASRC Cannon / Kempner

## Paths

- User: `xzyu`; lab folder: **`xizheng`** — do not use `$USER` in lab paths.
- Code / envs / projects: `/n/holylabs/schung_lab/Lab/xizheng/`
- Job I/O / checkpoints / logs: `/n/netscratch/schung_lab/xizheng/`
- Shared HF cache:

```bash
export HF_HOME=/n/holylabs/schung_lab/Lab/huggingface_cache
```

Use `holylabs` for persistent code/project files, not training output.  
Use `netscratch` for job output; retention is ~90 days.  
Keep `$HOME` for dotfiles/config only.

## Python Environments

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

## Slurm

Kempner account:

```bash
-A kempner_schung_lab
```

Check currently available partitions with:

```bash
spart
```

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


### GPU Constraints on Requeue

For `gpu_requeue`, optionally select the GPU type with:

```bash
#SBATCH --constraint=h100   # H100
#SBATCH --constraint=a100   # A100
```

### Kempner Limits

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
#SBATCH -o /n/netscratch/schung_lab/xizheng/logs/%x_%j.out

module load python
source activate /n/holylabs/schung_lab/Lab/xizheng/envs/<name>
export HF_HOME=/n/holylabs/schung_lab/Lab/huggingface_cache

python train.py
```

### Job Priority

Slurm job priority is mainly determined by:
- **Fairshare** — lower recent resource usage gives higher priority.
- **Job age** — waiting jobs gain priority over time.

So even with low fairshare, queued jobs will eventually move up.

View the pending queue for a partition with:

```bash
showq -o -p <partition>
```