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
- When `TODOs.md` is in use, include corresponding recent checked TODO items in the same commit as the implementation.
- Before committing, review `TODOs.md` if it exists and make sure tracked features or fixes included in the commit are recorded under **Completed / fixed features**.
- Do not commit implementation changes while leaving required TODO updates unstaged or for a later commit.
- Write commits with a concise subject line followed by a descriptive commit body whenever the commit contains completed features or fixes.
- When relevant checked TODO items exist, list each one in the commit body. Do not summarize a multi-feature commit with only a single-line message or mention only one of several included TODOs.
- Keep unrelated historical completed TODOs out of the commit message; include the complete set that corresponds to the staged changes being committed.

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
- For anything heavier, stop and ask permission before touching FASRC. Present
  the plan first: partition, GPU count, time limit, and target paths.
- Never `ssh` to the cluster, transfer data, or `sbatch` without explicit
  approval in the current session. Approval for one job is not approval for the
  next.
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
- Use the HPC reference's paths, accounts, partitions, and environment
  conventions as written.

### The HPC reference

`~/.claude/HPC.md` is the authority on paths, accounts, partitions, Slurm
options, and Python environments. `link-agent-docs.sh` installs it at that path
on every machine, so it is available from the Mac and the Spark machine as well
as on the cluster.

Read `~/.claude/HPC.md` with the Read tool before doing any of the following,
and do not answer from memory or guesswork:

- Naming a partition, account, or `#SBATCH` option.
- Writing or editing an `sbatch` script or an `salloc` command.
- Choosing cluster paths for code, environments, checkpoints, or logs.
- Creating or activating a cluster Python environment.

Do not rely on an `@` import for this file: nested imports from within an
imported instruction file are not expanded, so its contents are not in context
until it is actually read. The tracked `claude/settings.json` pre-approves
`Read(~/.claude/HPC.md)`, so no permission prompt is expected wherever those
settings are installed.