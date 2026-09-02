---
name: handoff
description: Write or update a handoff document capturing both the live session thread and the project's current state, so a different agent, a different harness, or a different person can resume the work cold. Use when asked to write, create, or update a handoff, a HANDOFF.md, or a HANDSOFF.md; when work is being moved to another repository or another tool; or when it is being handed to a colleague.
---

# Handoff documents

A handoff is read by someone with none of this session's context — a fresh
agent, the same work in another harness, or another person. Write for that
reader. Anything only this conversation knows is lost unless it goes in the
file.

## Where it goes

`HANDOFF.md` in the root of the repository being worked on, unless the user
names a different path. It is a tracked file that travels with the code, which
is what makes it useful for moving repositories or handing work to a person.

Before committing one, check it for local-only detail that will not mean
anything elsewhere: unpushed branch names, absolute paths under `/Users/...`,
scratch directories, machine-specific hostnames. Rewrite them as
repository-relative paths or name them as local.

## Before writing

Never write a handoff from conversation memory alone. Inspect first:

- `git status` and `git diff` — the working tree as it actually is now.
- `git log` — what recently landed, so finished work is not described as pending.
- `TODOs.md`, if the repository uses one.
- Any existing handoff file. Confirm each of its claims against the current
  code before carrying it forward; stale claims are the main failure mode.

## Required sections

Both halves matter. The session thread is what a summary would throw away; the
project state is what a newcomer cannot reconstruct quickly.

### The live thread

1. **Task in flight** — what is being worked on right now, how far it got, and
   the single next action the reader should take. Be specific enough to resume
   without re-deriving the goal.
2. **Decisions and rationale** — choices made this session and *why*, including
   approaches considered and rejected. This is the highest-value section and the
   one most often lost. Record constraints the user stated, and corrections they
   gave.
3. **Open questions** — anything awaiting a decision from the user, and what is
   blocked behind each one.

### The project state

4. **What changed** — implementation completed during the work period, with
   important behavior and the files touched.
5. **Issues remaining** — known bugs, caveats, incomplete integrations, and
   anything still needing device or visual QA.
6. **TODOs remaining** — relevant unchecked work from `TODOs.md`, summarized
   without presenting completed work as outstanding.
7. **Codebase structure** — architecture, major directories, important files,
   data flow, and where future work should go.
8. **Verification** — commands or manual checks run and their results, plus any
   verification that could not be performed and why.

## Rules

- **Reference, do not duplicate.** Point at specs, diffs, PRs, and issues by
  repository-relative path or URL. Copying them in makes the handoff long and
  stale at the same time. Duplicate only what exists nowhere but this
  conversation.
- **State the working tree honestly.** Say explicitly when changes are
  uncommitted, when a branch is unpushed, and when tests were not run. A handoff
  that overstates completeness is worse than none.
- **Separate verified from assumed.** Mark anything not directly confirmed
  against the code as an assumption.
- **Carry the user's own conventions forward** — commit tagging, TODO
  structure, environment routing — so the next agent does not have to rediscover
  them.
