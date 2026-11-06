---
name: study-issue
description: "Study a GitHub issue and brief the user: problem, scale, approach, expected outcome, status."
disable-model-invocation: true
---

The user hands you one issue (a number, a URL, or `<owner>/<repo>#<n>`) and wants a **brief**: a one-screen report that lets them understand the issue without reading its thread. This skill is read-only: it reads the tracker, the linked PRs, and the code, and its only output is the brief in chat.

End state: the brief below is filled in, every field backed by a cited source (issue body, comment author and date, PR number, file path). Stop and report only when the issue cannot be fetched (not found, no access, `gh` not authenticated).

## Steps

1. Resolve the repo. A bare number means the repo `git remote -v` points at; on a fork (an `upstream` remote beside `origin`) it means the upstream repo. Pass `--repo <owner>/<repo>` to every `gh` call.

2. Read the whole issue: `gh issue view <n> --repo <r> --json number,title,url,state,stateReason,closedAt,author,labels,assignees,milestone,body,comments,closedByPullRequestsReferences,parent,subIssues`. Done when you have read the body and every comment, since decisions and scope changes often land late in the thread.

3. Collect every linked PR. Union of three sources, deduplicated:
   - `closedByPullRequestsReferences` from step 2.
   - Cross-references in the timeline: `gh api repos/<r>/issues/<n>/timeline --paginate --jq '.[] | select(.event=="cross-referenced" and .source.issue.pull_request) | .source.issue | {number, title, state, html_url, repo: .repository.full_name}'`.
   - `gh pr list --repo <r> --state all --search "<n> in:body,title" --json number,title,state,isDraft,url`, keeping only PRs that actually reference this issue.

   For each PR: `gh pr view <pr> --repo <r> --json number,title,state,isDraft,mergedAt,reviewDecision,body,files,additions,deletions`. Done when every linked PR has its state and diff size.

4. Read the code the issue touches. Locate the files, modules, or APIs the issue names (or the PRs change), using the project's own terminology. When the issue's repo is not the current checkout, read the code through `gh api repos/<r>/contents/<path>` or the PR diff (`gh pr diff`). Done when you can name the concrete places a fix lands.

5. Decide the status with the rules below, then write the brief.

## Status

| Status | Rule |
| --- | --- |
| Done | The issue is closed. Add the reason: fixed by PR #x, or `stateReason` (completed, not planned, duplicate). |
| In-progress | The issue is open and at least one linked PR is open (drafts count). Name the PR and its review state. |
| Triage | The issue is open and no linked PR is open. |

Edge cases, stated in the brief beside the status: an open issue whose PR is already merged is In-progress with the note "PR merged, issue still open"; closed-unmerged PRs leave the status at Triage and are listed as prior attempts.

## Scale

Grade the change by what the fix touches, from the PR diff when one exists, from your reading of the code otherwise:

- Small: one function or file, local behaviour change, no interface change.
- Medium: several files within one module or package, or a change to an internal interface.
- Large: crosses modules or services, changes a public API, schema, config format, or data, or needs a migration.

Always back the grade with the concrete files or modules and, when a PR exists, its `+additions/-deletions` and file count.

## Brief

Write it in the user's language. Keep each field to a few lines; cite sources inline.

```markdown
# <title> (<owner>/<repo>#<n>)

Status: <Triage | In-progress | Done> - <one-line reason, PR link if any>

## Problem
<what is broken or missing, who it affects, how it shows up; one reproduction or example if the issue gives one>

## Scale
<Small | Medium | Large> - <files/modules touched; PR diff size if any>

## Approach
<the approach: the PR's when one exists, else the one agreed in the thread, else your proposal labelled "Proposed (not discussed in the issue)">

## Expected outcome
<observable behaviour after the fix; acceptance criteria from the issue if stated>

## Open questions
<unresolved decisions or disagreements in the thread; "None" if settled>

## Sources
<issue URL, PR URLs, key comments (author, date), files read>
```
