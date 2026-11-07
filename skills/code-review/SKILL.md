---
name: code-review
description: "Review code changes against their issue and PR with four subagents covering correctness, boundaries, system invariants, and tests. Use when the user asks to review a branch, local diff, or PR, or when an implementation finishes and needs review."
---

Review the change and report confirmed findings grouped by risk. Read code and run bounded checks; edit no project files, commit nothing, push nothing, and post no remote comments. When another skill calls this skill, that caller decides which findings to fix.

End state: the issue and PR context is understood, all four review assignments have a result or an explicit coverage gap, and every published finding is verified against the reviewed revision. Stop and report when the target or base cannot be resolved, the code cannot be read, or there is no change to review. Report unavailable context as a limitation rather than inventing requirements.

## Prepare the review

1. Resolve the target from the user or calling skill: a PR number, URL, `<owner>/<repo>#<n>`, branch, or local changes. Without a target, review the current local branch. For GitHub, resolve the repo from the reference or `git remote -v`; on a fork use upstream for the tracker. Pass `--repo <owner>/<repo>` to every `gh` call.

2. Pin the change:
   - For a PR, read `gh pr view <n> --repo <r> --json number,title,url,state,isDraft,baseRefName,baseRefOid,headRefName,headRefOid,body,files,closingIssuesReferences,statusCheckRollup,reviews,comments` and the paginated inline comments with `gh api repos/<r>/pulls/<n>/comments --paginate`. Read the full `gh pr diff <n> --repo <r>`. Use the recorded base and head SHAs for surrounding code; a local checkout is usable only if it matches the revision being reviewed. Fetch review-thread resolution state when needed to distinguish settled discussion from open objections. If the PR head changes during collection, refresh the context before dispatch.
   - For local changes, use the base named by the user or caller; otherwise use `git merge-base HEAD <remote>/<default>` with the repo's default branch, upstream on a fork. Read `git diff <base>`, `git log --oneline <base>..HEAD`, and every untracked file from `git status --porcelain`. The scope includes committed and uncommitted changes. Record HEAD, base, and working-tree state so later edits are not silently mixed into the review.

3. Read the issues and PR discussion to establish the problem. Use issues named by the user or caller, linked by the PR, or referenced in the branch and commit messages. Read each issue body and all comments, including linked acceptance criteria and decisions that change scope. For a local branch, also read an associated PR when one exists. Produce a shared brief: problem, requirements, explicitly excluded scope, unresolved decisions, and sources. When no issue or PR exists, derive intent from the available request and commits and label it as inferred. Distinguish explicit exclusions from work merely absent from the diff.

4. Collect applicable rules from `CODING_STANDARDS.md`, `CONTRIBUTING.md`, root `AGENTS.md` (or a non-stub `CLAUDE.md`), and nested instructions governing changed paths. Identify relevant callers, consumers, configuration, schemas, and test commands. Share the target revisions, diff, requirements brief, rules, code access method, and check/CI results with every subagent. Preparation is complete when each reviewer can inspect the same change and trace its requirements to sources.

## Four subagent reviews

Create exactly four subagents, one for each assignment below. Run them concurrently where capacity permits; if fewer than four slots are available, launch the remaining assignments as slots free up. Each subagent reviews the entire relevant change through its assigned lens and may read surrounding code. It must not delegate again or invoke this skill recursively.

Each subagent has a maximum of six minutes of wall-clock time from dispatch, including reading, checks, and reporting. Give it an absolute deadline and require it to return partial results before that deadline. Track each deadline in the parent, use bounded waits and command timeouts that fit the remaining budget, and stop or interrupt an unfinished subagent at its deadline. Do not extend the budget by restarting its assignment. If delegation is unavailable, report that the four-agent review could not run and mark its coverage incomplete.

| Subagent | Assignment | Required coverage |
| --- | --- | --- |
| Correctness | Does the code implement all requirements? What is outside this implementation's scope? | Map requirements to code; identify missing, wrong, or extra behavior. Separate agreed exclusions from unimplemented requirements and inferred scope. |
| Boundaries | Are Owns, Delegates, and Must not do respected, including implicit assumptions? | Establish each changed component's responsibilities from contracts, callers, and prior behavior. Trace input validation and transformation, output shape and semantics, delegated work, forbidden responsibilities, and wiring through call sites, registration, configuration, and dependency injection. Cite evidence for implicit assumptions. |
| System | Does the change preserve Invariants and coexist with system assumptions and existing tech debt? | Trace affected flows beyond the changed files. Inventory existing functionality affected by the change and check for regressions against its prior behavior. Check relevant state transitions, ordering, concurrency, persistence, compatibility, failure recovery, and workarounds. Show the concrete interaction through which an existing assumption or tech debt would cause a failure. |
| Tests | Do tests cover relevant Edge Cases and fit the test pyramid? | Compare changed behavior with existing and new tests: boundaries, empty or invalid inputs, failure paths, and relevant state or concurrency cases. Assess assertions, mocks, and test level: broad fast unit coverage, focused integration coverage of real seams, and selective end-to-end coverage of critical flows. Use the repo's architecture and documented test strategy; require no fixed ratios. |

Give every subagent these reporting rules:

- Return findings with a proposed risk grade, changed file and line, concrete trigger, consequence, and supporting code or requirement source. Trace surrounding code as needed, but anchor the finding in the reviewed change.
- Separate confirmed defects from design alternatives, unresolved intent, and unverifiable assumptions. A reasonable alternative alone is not a defect. A standards finding cites the exact rule and its source; skip style already enforced by the repo's formatter or linter.
- Report files and flows checked, requirement coverage relevant to the assignment, commands and results, and anything left unverified. Run only relevant repo-defined checks that fit the deadline and avoid shared infrastructure; record skips. Coordinate checks through the parent so reviewers can reuse results and avoid competing runs. The tests reviewer may run focused checks; static inspection and CI status alone do not establish a local test pass.
- Finish with `complete` or `partial`, explaining coverage gaps, unavailable evidence, or timeout. Use `None found` when no supported finding was found; never equate incomplete coverage with a clean bill of health.

## Consolidate and grade

Deduplicate findings by root cause, preserving distinct consequences and supporting evidence. Open the cited hunk and trace the trigger before accepting each finding. Drop unsupported claims; place unresolved intent, design choices, open review disagreements, and behavior needing unavailable runtime or domain evidence under human confirmation. If the reviewed revision or local files changed during review, mark the affected coverage stale and incomplete rather than applying old findings to new code.

Assign the final grade by concrete impact, reachability, blast radius, and reversibility. The review lens does not determine severity. Missing tests alone do not prove a production defect.

| Grade | Rule |
| --- | --- |
| critical | A demonstrated reachable path to catastrophic impact, such as widespread irreversible data loss, broad security compromise, or system-wide outage, with no effective containment or practical recovery. |
| high | A reachable defect causing serious impact, such as data corruption, an auth bypass, a broken critical flow, or incompatible API/schema behavior affecting existing consumers. Impact is substantial but does not meet critical scope or irreversibility. |
| medium | A reachable defect with limited impact, incomplete requirements, a concrete error-handling or performance gap, or missing meaningful coverage of changed behavior. State the affected case and consequence. |
| low | A minor issue with limited functional impact, such as misleading documentation, local maintainability problems, or a documented convention breach. Explain its concrete cost. |

Use the highest grade supported by evidence, not a hypothetical worst case. List `None found` for empty grades. Report coverage limits separately from risk severity.

## Report

Write in the user's language. Use plain Markdown and cite sources inline.

```markdown
# Code review: <target>

Scope: <base and head SHAs, local working-tree state when applicable>
Checks: <commands and results; CI state; skips and reasons>
Review coverage: <each subagent: complete | partial; timeout or other gaps>

## Problem and scope
<problem, requirements, explicit exclusions, inferred intent, issue and PR sources>

## Implementation coverage
<how the change delivers each requirement; missing or extra behavior; what is outside this implementation>

## Risks
### critical
- <file:line - defect - trigger - consequence - evidence>
### high
- ...
### medium
- ...
### low
- ...

## Needs human confirmation
- <intent | design choice | unverifiable | open thread> - <question, evidence, and why unresolved; alternatives and tradeoffs for design choices>

## Sources and limitations
<issue/PR links, rules, key code references, unverified paths, stale revisions, and incomplete assignments>
```
