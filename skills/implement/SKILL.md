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
- End state: the checkable definition of done, taken from the ticket's acceptance criteria or the spec's done-when section. Default: every acceptance criterion met, the old path removed where the work replaces one, scoped tests and the full suite green, review findings resolved.
- Stop conditions: the operating rules in the user's global steering file (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, or equivalent). If none are loaded, stop only when a decision is yours to make but the spec does not settle it, before any destructive action, or when a test fails and you cannot explain why.
- Checklist file: one per task at `.scratch/<slug>/checklist.md` (add `.scratch/` to `.git/info/exclude` if it is not ignored). Tick items as they land; add newly discovered work to it instead of carrying it in your head.

Steps that need no decision from the user are done without asking. Report progress and the next action in the same message.

## Build

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Use the repo's own check commands, found in the nearest `AGENTS.md`, `CONTRIBUTING.md`, or build config, rather than guessing a runner: the scoped test target for the packages you touched regularly (for example `bazel test //path/to/pkg/... --test_output=streamed`, `go test ./...`, `pnpm test <file>`), typechecking and lint regularly, and the full suite once at the end. Where the nearest `AGENTS.md` requires an extra test kind for the area (a behaviour suite, a contract test), that kind is part of the end state.

## Close out

Once done, call the Skill tool with "code-review-local" to review the work. Treat each finding as a claim: confirm it against the diff before acting. Fix the confirmed findings, and list the ones you rejected with the reason.

Commit your work to the current branch using the repo's commit convention (Conventional Commits with a scope where `CONTRIBUTING.md` asks for it; `git commit -s` where the repo requires a DCO sign-off). Do not push unless asked.

Finish with one message: the checklist with every item ticked or explicitly left open, the test commands you ran and their results, the commit, and the next action.
