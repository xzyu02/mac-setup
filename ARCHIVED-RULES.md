# Archived rules

Rules retired from `AGENTS.md`. Nothing links or imports this file, so agents
do not load it. To restore a rule, move its section back into `AGENTS.md`.

## Branch per feature, commit when done

These rules replace the default "commit only when the user asks" behavior, in
every repository.

- Before implementing a feature or fix, branch off the default branch:
  `feat/<thread>/<short-slug>` for new work, `fix/<thread>/<short-slug>` for
  repairs. Never implement directly on the default branch. If the name is
  taken, add a numeric suffix.
- `<thread>` is the line of work the branch belongs to, so concurrent agents
  are legible at a glance in `git branch`. Keep to this closed set — a thread
  only one branch ever uses has stopped being a coordination signal:
  `data` (datasets, preprocessing, loaders), `train` (training loop,
  optimization, fine-tuning), `eval` (benchmarks, metrics, harnesses),
  `analysis` (figures, statistics, interpreting results), `infra` (Slurm
  scripts, environments, tooling, repo plumbing), `paper` (writeup and
  publication figures). In a repository with no such threads, drop the level
  and use `feat/<short-slug>`.
- Never name a branch exactly `feat/<thread>`. Git stores refs as paths, so
  `feat/train` and `feat/train/lora-rank` cannot both exist — whichever comes
  second is refused.
- Once the work is complete and verified, commit it to that branch without
  asking and without waiting to be told, following the commit message rules in
  `AGENTS.md`.
- Push your own `feat/` or `fix/` branch without asking. Nothing shared
  depends on it, and only the default branch needs a request.
- When the feature is ready, say so and propose the merge — do not merge it
  yourself. Once told to, merge into the default branch with
  `git merge --no-ff` and an `[MRG]` subject so the branch stays a visible
  unit in the history, then delete the merged branch.

## Push restrictions

Replaced by **Branches and pushing** in `AGENTS.md`, which lets agents push the
branch they are working on, including the default branch.

From **Requires an explicit request**:

- Merging into the default branch, and pushing the default branch. Pushing
  your own feature branch does not need one.

From **Working alongside other agents**:

- Work only on your own branch.
- When work is on a branch, push it before the session ends even if the
  feature is unfinished, so another machine or agent can pick the thread up.
  An unpushed branch is invisible to every other device.
