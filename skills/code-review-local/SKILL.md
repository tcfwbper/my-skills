---
name: code-review-local
description: Review local changes before pushing or opening a PR: study the issue they solve, explain how the change solves it, check the repo's standards, grade risks, list points needing a human decision. Use when the user asks to review their branch, their local diff, or work in progress, or when an implementation finishes and needs review.
---

The **review brief** for a remote PR, applied to the local branch: how the change solves the problem, what could go wrong ranked by risk, where it breaks the repo's documented standards, and every point a human must confirm. This skill reads and runs checks; it edits no file, commits nothing, and pushes nothing. When another skill called it, that skill decides which findings to fix.

End state: the brief below is filled in, every finding backed by a file and line in the diff you have opened and confirmed, and every standards finding citing the rule it breaks. Stop and report only when the diff is empty or the base cannot be resolved.

## Steps

1. Pin the base. Use the base the user or calling skill names; otherwise the merge-base with the repo's default branch (on a fork, the upstream remote's default branch): `git merge-base HEAD <remote>/<default>`. The change under review is `git diff <merge-base>` (committed plus uncommitted), the commit list is `git log --oneline <merge-base>..HEAD`, and untracked files come from `git status --porcelain`. Done when the base resolves and the diff is non-empty.

2. Study the issue first. Take the issue the user or calling skill names; otherwise the issue number in the branch name, or `#<n>` and closing keywords in the commit messages. For each, read [`../study-issue/SKILL.md`](../study-issue/SKILL.md) and follow it to produce its brief (that file is read, not invoked as a skill). When no issue is found, derive the intent from the commits and say so in the brief.

3. Collect the standards sources: `CODING_STANDARDS.md` and `CONTRIBUTING.md` when present, the root `AGENTS.md` (or `CLAUDE.md` when it is not an `@AGENTS.md` stub), and the nearest nested `AGENTS.md` to each changed path. Done when you have the list and have read the rules that bear on the changed files. Skip anything a linter or formatter the repo runs already enforces.

4. Read the implementation: the full diff, every untracked file, and for every changed file enough of the surrounding local code to know what the change interacts with (callers, consumers, config, schema, tests). Done when you can say, for each hunk, what it does and why it is there.

5. Run the repo's own checks for the touched packages, using the commands its `AGENTS.md`, `CONTRIBUTING.md`, or build config names: scoped tests, lint, typecheck. Record each command and its result. Skip a check that needs shared infrastructure and say so.

6. Compare the change with the issue's expected outcome: does each requirement have a hunk that delivers it, and does any hunk deliver something the issue never asked for? Note whether the change adds or updates tests for the behaviour.

7. Grade risks with the Risk grades in [`../code-review-pr/SKILL.md`](../code-review-pr/SKILL.md), and collect the points under its Human confirmation points section, with the same rules. A breach of a documented standard is a risk too, graded by its impact, tagged `standards`, and citing the source file and rule.

8. Check every finding before it goes in the brief: open the hunk it names and confirm it says what the finding claims. Drop findings that do not hold.

## Brief

Write it in the user's language. Keep each field to a few lines; cite sources inline.

```markdown
# Local review: <branch> (base <base-ref> @ <short-sha>)

State: <n> commits, <uncommitted: yes | no>, size: <files>, +<add>/-<del> - checks: <command: pass | fail | skipped (why)>

## Problem
<per issue, the study-issue brief condensed to problem, scale, expected outcome; or the intent derived from the commits when no issue is found>

## How the change solves it
<the mechanism in plain terms: what is added, changed, removed, and how that produces the expected outcome. Use the smallest visual that makes it clear (call tree, file tree, or pseudocode). Map each requirement to the hunk that delivers it; flag requirements with no hunk and hunks with no requirement>

## Risks
### High
- <file:line - what can go wrong - trigger>
### Medium
- ...
### Low
- <file:line - standards - rule (source file) - what breaks it>

## Needs human confirmation
- <type: intent | design choice | unverifiable> - <question> - <why open; for a design choice: the alternative, the trade, your lean>

## Verdict
<one of: ready to push | push after confirming the points above | needs changes> - <one-line reason>

## Sources
<issue URLs, standards files read, check commands run, files read>
```
