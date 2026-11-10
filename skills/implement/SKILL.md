---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

## Contract first

Before writing code, state the task contract in one message and keep it current in a checklist file:

- Task: what changes, in one or two sentences, in the project's glossary vocabulary.
- End state: the checkable definition of done, taken from the ticket's acceptance criteria or the spec's done-when section. Default: every acceptance criterion met, the old path removed where the work replaces one, scoped tests and the full suite green, the review loop closed with no open critical or high finding.
- Stop conditions: the operating rules in the user's global steering file (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, or equivalent). If none are loaded, stop only when a decision is yours to make but the spec does not settle it, before any destructive action, or when a test fails and you cannot explain why.
- Checklist file: one per task at `.scratch/<slug>/checklist.md` (add `.scratch/` to `.git/info/exclude` if it is not ignored). Tick items as they land; add newly discovered work to it instead of carrying it in your head.
- Crit code: a `crit:v1;...` string from the user, kept for the final publish. Without one, the contract message says the final review goes to chat unless a code arrives before then, and work continues.

Steps that need no decision from the user are done without asking. Report progress and the next action in the same message.

## Build

Call the Skill tool with "code-quality" once before the first slice, and keep its rubric as the bar for every slice. Each known constraint in the spec or ticket gets its explaining comment where the code encodes it.

Call the Skill tool with "tdd" where possible, at pre-agreed seams. After each slice goes green, check the slice against every rubric category and refactor what falls short while the tests stay green, before starting the next slice.

Use the repo's own check commands, found in the nearest `AGENTS.md`, `CONTRIBUTING.md`, or build config, rather than guessing a runner: the scoped test target for the packages you touched regularly (for example `bazel test //path/to/pkg/... --test_output=streamed`, `go test ./...`, `pnpm test <file>`), typechecking and lint regularly, and the full suite once at the end. Where the nearest `AGENTS.md` requires an extra test kind for the area (a behaviour suite, a contract test), that kind is part of the end state.

## Review loop

When the build is green, run the review loop. Each round:

1. Call the Skill tool with "code-review". Round 1 is a full review of the work against the spec or ticket. Later rounds are re-reviews: pass the round number, the previous round's findings with what you did about each, and the base of the fix diff (the revision the previous round reviewed), so every reviewer re-checks only what the fixes affect. The Crit code goes only to the final publish call below.
2. Treat each finding as a claim: confirm it against the code before acting. Fix every confirmed critical and high finding. Fix confirmed medium and low findings unless the fix exceeds the agreed scope; record each one you leave with the reason.
3. Re-run the scoped tests and checks the fixes touch, then start the next round.

The loop ends when a round returns no confirmed critical or high finding and nothing new at medium or above from the fixes, or after three rounds. If critical or high findings remain after round three, stop and report them as open items with the evidence.

When the loop ends and a Crit code is available, call the Skill tool with "code-review" once more with the Crit code and the instruction to publish the final round's report; it reuses that report when the code has not changed since.

## Close out

Commit your work to the current branch using the repo's commit convention (Conventional Commits with a scope where `CONTRIBUTING.md` asks for it; `git commit -s` where the repo requires a DCO sign-off). Do not push unless asked.

Finish with one message: the checklist with every item ticked or explicitly left open, the test commands you ran and their results, each review round's outcome (fixed, rejected with reason, left open), the commit, the human review order from the final review, and the next action.
