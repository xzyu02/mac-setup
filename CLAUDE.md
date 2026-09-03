@AGENTS.md

# mac-setup project rules

These rules apply to this repository only, and are written inline rather than
imported so they always load — a nested `@` import silently fails to expand.
They deliberately replace the default "commit only when the user asks"
behavior. Other projects keep that default until they carry this section too,
so copy this file's **Branch per feature** and **Still requires an explicit
request** sections into any repository that should work the same way.

## Branch per feature, commit when done

- Before implementing a feature or fix, branch off the default branch:
  `feat/<short-slug>` for new work, `fix/<short-slug>` for repairs. Never
  implement directly on `main`. If the name is taken, add a numeric suffix.
- Once the work is complete and verified, commit it to that branch without
  asking and without waiting to be told. Follow the commit message rules in
  `AGENTS.md`, and stage the `TODOs.md` update in the same commit.
- Commit each feature or fix as it finishes rather than batching unrelated
  work into one commit.
- When the feature is ready, merge it into the default branch with
  `git merge --no-ff` and an `[MRG]` subject so the branch stays a visible
  unit in the history, then delete the merged branch.

## Still requires an explicit request

- `git push`, and anything outward-facing: pull requests, tags, releases, new
  remotes. `claude/settings.json` also gates `git push` behind a prompt.
- Rewriting history that is already merged or shared: `commit --amend`,
  `rebase` of the default branch, `reset --hard`, any force push.
- Committing unfinished, unverified, or actively-iterating work. Leave it in
  the working tree and say what is left.
- Staging pre-existing unrelated changes that were already dirty when the
  session began. Commit only what the current task touched.

## Multiple agents in one repository

- Work only on your own branch. Never commit to, merge, or delete a branch
  another session created, and never switch a branch out from under one.
- Re-check the default branch for new commits immediately before merging.
  Resolve any conflict on the feature branch, never by rewriting the default
  branch.
