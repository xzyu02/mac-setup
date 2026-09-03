# Repository Instructions

- Choose the simplest implementation that fully meets the current requirements.
- Prefer established, well-maintained libraries over custom implementations.

## TODO maintenance

- Maintain `TODOs.md` only when it already exists in the repository or the user explicitly asks for TODO tracking. Do not create it solely for a routine change.
- Record completed work as a checked (`[x]`) item with enough detail to identify the original issue and its resolution, and leave unfinished work unchecked (`[ ]`) — an item is complete only once the implementation and appropriate verification are finished.
- Keep completed fixes and working features under a dedicated **Completed / fixed features** section and future or unfinished work under a separate **Planned features** section. Move an item across when it is finished; never leave checked items mixed into the planned section.
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
- Never revert or reconstruct working-tree changes just to split history into a tidier intermediate commit — the risk of losing or mangling finished work outweighs a cleaner log. Commit each feature or fix once it is done instead, so the history separates itself.

## Branch per feature, commit when done

These rules replace the default "commit only when the user asks" behavior, in
every repository.

- Before implementing a feature or fix, branch off the default branch:
  `feat/<short-slug>` for new work, `fix/<short-slug>` for repairs. Never
  implement directly on the default branch. If the name is taken, add a
  numeric suffix.
- Once the work is complete and verified, commit it to that branch without
  asking and without waiting to be told, following the commit message rules
  above.
- Push your own `feat/` or `fix/` branch without asking. Nothing shared
  depends on it, and only the default branch needs a request.
- When the feature is ready, say so and propose the merge — do not merge it
  yourself. Once told to, merge into the default branch with
  `git merge --no-ff` and an `[MRG]` subject so the branch stays a visible
  unit in the history, then delete the merged branch.

## Requires an explicit request

- Merging into the default branch, and pushing the default branch. Pushing
  your own `feat/` or `fix/` branch does not need one.
- Anything outward-facing: pull requests, tags, releases, new remotes.
- Committing unfinished, unverified, or actively-iterating work. Leave it in
  the working tree and say what is left.
- Staging pre-existing unrelated changes that were already dirty when the
  session began. Commit only what the current task touched.

## Destructive Git operations

These destroy work that another branch, another machine, or another agent may
be the only holder of, and the loss usually cannot be undone from the local
checkout. They are not covered by a general approval to work on a task, or by
permission granted for one of them earlier in the session. Name what would be
lost, then wait for an instruction to do exactly that thing.

- Any force push: `push --force`, `push --force-with-lease`.
- Rewriting history that is already merged or shared: `commit --amend`,
  `rebase` of the default branch, `reset --hard`.
- Discarding uncommitted work: `stash`, `checkout --`, `restore`, `clean`.
  This includes doing it to make a pull, merge, or branch switch apply
  cleanly — if the tree has to be clean first, say so and ask.
- Deleting a branch that is unmerged, or that another session created.

## Working alongside other agents

Assume another agent — in another session, or on another machine — may be
working on the same repository at the same time. The local checkout is not
authoritative, and a clean working tree does not mean an up-to-date one. These
rules constrain how the branch flow above touches shared history.

- Run `git fetch` and report what it shows — ahead/behind counts, uncommitted
  work, unpushed commits — before starting any work that will change the
  repository. A stale base is cheap to fix beforehand and expensive after.
- Work only on your own branch. Never commit to, merge, or delete a branch
  another session created, and never switch a branch out from under one.
- Re-check the default branch for new commits immediately before merging into
  it, not just at the start of the session.
- When work is on a branch, push it before the session ends even if the
  feature is unfinished, so another machine or agent can pick the thread up.
  An unpushed branch is invisible to every other device.
- Stop and ask on any merge or rebase conflict in code, config, or job
  scripts. The other side is another thread's finished work and its intent is
  not visible from the diff — report the conflicting files and wait. Resolve
  it on the feature branch once told to, never by rewriting the default
  branch. The one exception is `TODOs.md`, where the resolution is always to
  keep both sides' entries and refresh the `Last updated:` line.

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

Load the `fasrc` skill before writing the job script; the partition, per-GPU
caps, and environment commands come from it, not from the local setup.

### Case 3 — On FASRC (Cannon / Kempner)

- Never run GPU or heavy compute on a login node; use `salloc` or `sbatch`.
- Load the `fasrc` skill and use its partitions, Slurm options, and environment
  conventions exactly as written.

## FASRC Cannon / Kempner reference

The lab paths and a sample job header are kept here because they are small and
must never be guessed. Everything else — the partition guide, per-GPU core and
memory caps, GPU holding limits, Python environment setup, the full job
template, and the Slurm monitoring commands — lives in the **`fasrc` skill**.

Load that skill before naming any partition, account, `#SBATCH` option, or
cluster environment command, in all three routing cases, including when writing
job scripts from a Mac or the Spark machine. Do not fill in a partition or a
resource figure from memory.

### Paths

- User: `xzyu`; lab folder: **`xizheng`** — do not use `$USER` in lab paths.
- Code / envs / projects: `/n/holylabs/schung_lab/Lab/xizheng/`
- Job I/O / checkpoints / logs: `/n/netscratch/schung_lab/Lab/xizheng/`
- Shared HF cache: `export HF_HOME=/n/holylabs/schung_lab/Lab/huggingface_cache`

Use `holylabs` for persistent code/project files, not training output.  
Use `netscratch` for job output; retention is ~90 days.  
Keep `$HOME` for dotfiles/config only.

### Sample job header

The H100 case, as a shape to start from — not values to reuse unchecked:

```bash
#!/bin/bash
#SBATCH -A kempner_schung_lab
#SBATCH -p kempner_h100          # confirm the partition in the fasrc skill
#SBATCH --gres=gpu:1
#SBATCH -c 24                    # per-GPU core cap varies by partition
#SBATCH --mem=360G               # per-GPU memory cap varies by partition
#SBATCH -t 0-04:00
#SBATCH -o /n/netscratch/schung_lab/Lab/xizheng/logs/%x_%j.out
```

The account and the log path are correct as written. The partition and its
per-GPU core and memory caps are not — take those from the skill.
