---
name: write-issue
description: "Turn a plan, spec, or the current conversation into GitHub issues: one main issue for the whole plan and one sub-issue per tracer-bullet ticket, written in the repo's own issue structure."
disable-model-invocation: true
---

# Write Issue

Break a plan, spec, or conversation into **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it. Publish them to the repo's GitHub tracker as one **main issue** (the whole plan) with one **sub-issue** per ticket.

End state: the main issue exists on the tracker, every approved ticket is a sub-issue of it, blocking edges are set, and the main issue lists its sub-issues. Report every issue URL. Stop and report, publishing nothing, when there is no GitHub remote, the plan is a single ticket and its main issue already exists (say so explicitly), `gh` is not authenticated, or the user has not approved the breakdown.

## Where things are published

GitHub Issues through the `gh` CLI, in the repo `git remote -v` points at. On a fork (an `upstream` remote beside `origin`) the tracker is the upstream repo: pass `--repo <owner>/<repo>` to every `gh` call.

Anything published is written for the tracker's readers: no internal hostnames, private ticket IDs, or debugging trails they cannot follow, and the repo's documented prose style. Write every published issue in English, whatever language the conversation or the repo's older issues use. Apply labels, assignees, and milestones only when the user names them or the repo's issue convention requires them; on a repo you do not administer, creating labels is not yours to do.

## Process

### 1. Gather context

Work from whatever is already in the conversation. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions use the project's existing terminology and respect the design decisions its docs record.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Find the issue structure

Find how this repo writes issues, in this order, and stop at the first source that answers:

1. Documented rules: `.github/ISSUE_TEMPLATE/` (templates and `config.yml`), `.github/ISSUE_TEMPLATE.md`, the issue section of `CONTRIBUTING.md`, `AGENTS.md` / `CLAUDE.md`, and the repo's docs.
2. Observed practice: `gh issue list --repo <r> --state all --limit 30 --json number,title,labels,body`, then read the bodies. Take the structure most of them share: heading names and order, title style (prefixes, tags, case), labels, whether acceptance criteria are a checklist, and how blockers and parents are referenced. Ignore outliers, bot-written issues, and pull requests.

Record the result as one short template for the main issue and one for sub-issues (they may be the same). When neither source yields a structure (empty tracker, no rules), use the fallback templates at the end. Tell the user which source the structure came from.

### 4. Find or plan the main issue

Look on the remote tracker for an existing main issue for this work: the one the user passed, the spec issue this conversation produced, or an open issue whose title or body matches the plan (`gh issue list --repo <r> --state open --search "<keywords>"`). Treat a match as a candidate and confirm it with the user in step 6.

- Existing main issue: tickets become its sub-issues. Never edit its title or body, except to add the sub-issue list when it lacks one and the user agrees.
- No main issue: create one from the whole plan (problem, approach, scope, the ticket list), in the structure from step 3.
- Only one ticket and no existing main issue: publish a single issue, no sub-issues. Its body carries the whole plan and the ticket's acceptance criteria.
- Only one ticket and a main issue already exists: that ticket IS the main issue, not a sub-issue of it. Publish nothing. Tell the user plainly that the existing issue (give its URL) already covers the single ticket, and stop.

### 5. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a column, retype a shared symbol) whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand-contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket; green is promised only there.

### 6. Quiz the user

Present the plan in one message:

- The structure source from step 3.
- The main issue: the existing one found, or the title of the one to create, or "single issue, no main issue". For a single ticket with an existing main issue, say that nothing will be published and stop here.
- A numbered ticket list. For each ticket: title, blocked by, and what it delivers (the end-to-end behaviour it makes work).

Ask the user:

- Is the main issue right (existing one confirmed, or create a new one)?
- Does the granularity feel right (too coarse / too fine)?
- Does each ticket depend only on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown. Publish nothing before that.

### 7. Publish

Publish in dependency order (blockers first), so every reference points at a real issue number.

1. Main issue, when one is to be created: `gh issue create --repo <r> --title ... --body-file ...`. Write bodies to a file under the scratchpad or `.scratch/` rather than inline.
2. Each ticket as an issue in the structure from step 3, with `Part of #<main>` where the structure has no parent field.
3. Link each ticket to the main issue as a native sub-issue. `gh api` needs the numeric issue id, not the number:

   ```bash
   id=$(gh api repos/<o>/<r>/issues/<ticket> --jq .id)
   gh api -X POST repos/<o>/<r>/issues/<main>/sub_issues -F sub_issue_id=$id
   ```

4. Set blocking edges natively, ticket blocked by blocker, the same way:

   ```bash
   gh api -X POST repos/<o>/<r>/issues/<ticket>/dependencies/blocked_by -F issue_id=<blocker numeric id>
   ```

5. If either API is unavailable (404, a server without the feature), fall back in the body: add a task list of `- [ ] #<n>` lines to the main issue, `Part of #<main>` to each ticket, and a "Blocked by" list of issue references to each ticket. Say in the report which fallback was used.
6. Verify: `gh issue view <main> --repo <r> --json subIssues` lists every ticket. Fix gaps before reporting.

Do NOT close, relabel, or retitle an existing main issue or any issue not created in this run.

In every body, avoid specific file paths or code snippets: they go stale fast. Exception: a snippet that encodes a decision more precisely than prose can (state machine, schema, type shape) may be inlined, trimmed to the decision-rich part.

## Fallback templates

Used only when step 3 finds no structure. Plain Markdown: headings and lists, no bold labels, no emoji, ASCII punctuation.

<main-issue-template>

## Problem

What is broken or missing, and who it affects.

## Plan

The approach for the whole change and what is out of scope.

## Tickets

- [ ] #<n> <ticket title>

</main-issue-template>

<ticket-template>

## Parent

Part of #<main>

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None (can start immediately)". Omit this section when blockers were set as native edges.

</ticket-template>
