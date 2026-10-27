---
name: implement-spec
description: "Implement the result of /to-spec and /to-tickets in code."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work, the full test suite green on that branch, and a final report that lists each ticket with its evidence.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed. Time matters here: keep the frontier saturated with running implementers.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

A subagent's report is a claim until checked. Accept it only after you have re-run the scoped test command it quotes and read the diff it says it produced. A report without evidence goes back for evidence.

## Steps

1. Read the spec and tickets to understand the task graph. Open the run's checklist file at `.scratch/<spec-slug>/checklist.md` (add `.scratch/` to `.git/info/exclude` if it is not ignored) listing every ticket, its blockers, and its state: ready, running, merged, blocked. Keep it current throughout the run.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets: relevant codebase files or external documentation. Give it a writable notes directory outside the repo, or under a path `.gitignore` already hides, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch. If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after the first merge in step 5 (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

4. Use **implementer subagents** to implement each ticket, each in its own worktree on its own branch. Put worktrees under the directory the repo ignores for them when it has one (`.worktrees/` is common), otherwise outside the repo. Each implementer's brief is the full task contract: a pointer to the ticket and spec, the end state (its acceptance criteria met, scoped tests green), the stop conditions from the user's global steering file, the repo's commit convention (Conventional Commits, `git commit -s` where DCO is required), and the report format below. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `tdd` to build the ticket;
   - merges the integration branch tip into its own branch before reporting done;
   - reports: ticket, branch, commit SHA, the exact test command run and its last lines, anything left open.

5. Once an **implementer subagent** completes, check its evidence as described above, then merge its work to the integration branch with a **merger subagent**. Re-run the scoped tests on the integration branch after the merge; a red result goes back to the implementer, never forward.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, run the full suite on the integration branch, then call the Skill tool with `code-review` on it. Confirm each finding against the diff; fix the confirmed ones in a single **implementer subagent** and list the rejected ones with reasons.

8. If a draft PR exists, call the Skill tool with "pr" to shape its body, then mark it ready for review. Otherwise, close each ticket (GitHub issue, or `Status: done` in the local file) and report the integration branch.

9. List the worktrees this run created and ask the user before removing them: worktree deletion is a destructive action.

10. Finish with one report: a table of ticket, commit, test command, check result (verified, unverified, or failed), followed by the full-suite result on the integration branch and the next action.
