---
name: code-review-pr
description: "Review a remote GitHub PR: study its issue, explain how the implementation solves it, grade risks, list every point needing a human decision."
disable-model-invocation: true
---

The user hands you one remote PR (a number, a URL, or `<owner>/<repo>#<n>`) and wants a **review brief**: how the PR solves the problem, what could go wrong ranked by risk, and every point a human must confirm. This skill is read-only: it reads the tracker, the PR, and the code, and its only output is the brief in chat. It posts no comments and changes nothing.

End state: the brief below is filled in, every claim backed by a cited source (file and line in the PR diff, comment author and date, issue or PR number). Stop and report only when the PR cannot be fetched (not found, no access, `gh` not authenticated).

## Steps

1. Resolve the repo as in [`../study-issue/SKILL.md`](../study-issue/SKILL.md) step 1, and pass `--repo <owner>/<repo>` to every `gh` call.

2. Read the PR: `gh pr view <n> --repo <r> --json number,title,url,state,isDraft,author,baseRefName,headRefName,body,files,additions,deletions,reviewDecision,reviews,comments,closingIssuesReferences,statusCheckRollup`, then the inline review comments (`gh api repos/<r>/pulls/<n>/comments --paginate`). Done when you have read the body, every comment, and every review thread, since decisions and objections often live there.

3. Study the issue first. Take the issues from `closingIssuesReferences` plus any `#<n>` or issue URL in the PR body. For each, read [`../study-issue/SKILL.md`](../study-issue/SKILL.md) and follow it exactly to produce its brief (that file is read, not invoked as a skill). Keep each brief for the Problem section below. When the PR links no issue, derive the problem from the PR body and thread, and say so.

4. Read the implementation, not just the summary: `gh pr diff <n> --repo <r>` in full. For every changed file, read enough of the surrounding code (`gh api repos/<r>/contents/<path>?ref=<base>`, or the local checkout when it is the same repo and branch) to know what the change interacts with: callers, consumers, config, schema, tests. Done when you can say, for each hunk, what it does and why it is there.

5. Compare the implementation with the issue's expected outcome: does each stated requirement have a hunk that delivers it, and does any hunk deliver something the issue never asked for? Note CI state from `statusCheckRollup` and whether the PR changes or adds tests for the behaviour.

6. Grade risks with the rules below, collect the human-confirmation points, then write the brief.

## Risk grades

Grade each risk by impact if it is wrong and how hard it is to undo.

| Grade | Rule |
| --- | --- |
| High | Data loss or corruption, security or auth, public API or schema or config-format break, migration, concurrency or ordering, behaviour change for existing consumers, anything one-way. |
| Medium | Wrong or incomplete behaviour in a reachable path, missing or weak tests for changed logic, error handling gaps, performance on a hot path, scope beyond the issue. |
| Low | Naming, style, local readability, small cleanups, dead code, docs gaps. |

Every risk names the file and line, what can go wrong, and the concrete trigger. A risk you cannot tie to code is dropped, not softened. Say "None found" for an empty grade; do not pad.

## Human confirmation points

List every place where the reviewer should decide rather than trust the PR, each with the question and why it is open:

- Intent: the diff does something the issue does not state, or skips something it does.
- Design choice: the solution is sound but another approach is also good or possibly better. Name the alternative, what it would trade (simplicity, performance, compatibility, blast radius), and which one you lean toward and why.
- Unverifiable: behaviour that needs running the code, a deployment, production data, or domain knowledge you lack.
- Open review threads, disagreements, or unresolved comments.

A design choice is not a defect: it goes here, never in the risk grades.

## Brief

Write it in the user's language. Keep each field to a few lines; cite sources inline.

```markdown
# <PR title> (<owner>/<repo>#<n>)

State: <open | draft | merged | closed> - CI: <passing | failing: which | none>, review: <reviewDecision>, size: <files>, +<add>/-<del>

## Problem
<per linked issue, the study-issue brief condensed to problem, scale, expected outcome; or the PR's own stated problem when no issue is linked>

## How the PR solves it
<the mechanism in plain terms: what is added, changed, removed, and how that produces the expected outcome. Use the smallest visual that makes it clear (call tree, file tree, or pseudocode). Map each requirement to the hunk that delivers it; flag requirements with no hunk and hunks with no requirement>

## Risks
### High
- <file:line - what can go wrong - trigger>
### Medium
- ...
### Low
- ...

## Needs human confirmation
- <type: intent | design choice | unverifiable | open thread> - <question> - <why open; for a design choice: the alternative, the trade, your lean>

## Verdict
<one of: ready to merge | merge after confirming the points above | needs changes> - <one-line reason>

## Sources
<PR URL, issue URLs, key comments (author, date), files read>
```
