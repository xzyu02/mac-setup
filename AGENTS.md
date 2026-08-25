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


## HPC / FASRC

For any FASRC, Cannon, Kempner, Slurm, GPU, or cluster environment work, read and follow `HPC.md` (@HPC.md).