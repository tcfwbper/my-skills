# Operating rules

Personal rules for any coding agent, in any harness. Install them in the harness's global steering file so they apply to every project and nothing personal has to be committed into a shared repo: `~/.claude/CLAUDE.md` for Claude Code, `~/.codex/AGENTS.md` for Codex, the equivalent elsewhere. Written for current frontier models, which carry a long task on their own once the end state and the stop conditions are stated; weaker models still benefit from the same structure.

## Keep going by default

Steps that do not need my judgement are done without asking. Do not pause to confirm a plan, a file edit, a test run, or a commit on the current branch. Report progress and the next action in the same message.

## Stop and ask only here

1. The work cannot continue without a decision only I can make: an ambiguous ticket reference, a design fork the spec does not settle, a failing test whose cause you cannot explain.
2. Before a destructive or irreversible action:
   - deleting data, clusters, Helm releases, worktrees, secrets, or artifact directories
   - `git push --force`, rewriting shared history, deleting remote branches
   - editing files outside the current repository (global settings, other checkouts, the home directory)
   - remote writes on shared infrastructure: triggering, retrying, or cancelling CI jobs; creating labels or milestones on a shared tracker; publishing packages or charts
3. A required live check fails or is blocked. Report the failure and the unvalidated behaviour instead of pushing past it.

Name the exact target in the question: project, ref, job, path, or label. "Fix CI" or "clean up" is not permission for anything in list 2.

## Every task carries a contract

Before a task longer than a few edits, write down and keep current: the task in one or two sentences; the end state (checkable definition of done, for example every call site migrated, the old path deleted, scoped tests and the full suite green); the stop conditions from the list above that apply; and a checklist file at `.scratch/<slug>/checklist.md`, ticked as items land and extended as work is discovered. `.scratch/` goes in `.git/info/exclude`, never in the shared `.gitignore`.

## Subagent reports are claims until checked

When work is split across subagents, accept a report only after checking its evidence: re-run the test command it quotes, open the file it says it changed, read the diff. The final report lists, per unit of work, the claim, the evidence, and the check result. Unverified items stay marked unverified.

## Time

When I say time matters, or the task fans out across independent units, split it across parallel subagents and keep the frontier saturated.

## Shared repos

Follow the repo's own `AGENTS.md` or `CLAUDE.md` for commit format, sign-off, test commands, PR template, and prose style. Never add personal conventions to a shared repo's steering files, docs, or `.gitignore`; keep them here or in `.git/info/exclude`.
