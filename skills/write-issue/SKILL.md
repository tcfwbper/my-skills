---
name: write-issue
description: "Turn a local spec or agreed plan into tickets and publish them to the repo's GitHub issue tracker."
disable-model-invocation: true
---

# Write Issue

Break a plan, spec, or conversation into **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it. Publish them to the repo's GitHub tracker as one **main issue** (the whole plan) with one **sub-issue** per ticket.

End state: the whole plan is covered by tracker issues, with a main issue and sub-issues for multiple tickets or one issue for a single ticket. Blocking edges are recorded, and a local ticket map records coverage and every issue URL. Stop before publishing when the tracker cannot be identified, `gh` is not authenticated, or unresolved decisions prevent a faithful breakdown. Report the specific blocker and keep the local drafts.

## Where things are published

GitHub Issues through the `gh` CLI, in the repo `git remote -v` points at. On a fork (an `upstream` remote beside `origin`) the tracker is the upstream repo: pass `--repo <owner>/<repo>` to every `gh` call.

Anything published is written for the tracker's readers: no internal hostnames, private ticket IDs, or debugging trails they cannot follow, and the repo's documented prose style. Write every published issue in English, whatever language the conversation or the repo's older issues use. Apply labels, assignees, and milestones only when the user names them or the repo's issue convention requires them; on a repo you do not administer, creating labels is not yours to do.

## Process

### 1. Gather context

Use the local spec produced by `/to-spec` as the source of truth when available. Read the path the user supplies or the spec explicitly identified in this conversation in full. If neither is given, inspect `.scratch/` for a matching spec; ask which one only when the choice is ambiguous. An explicit agreed plan or conversation can also serve as input. For an issue reference, fetch its full body and comments.

Carry forward every section of the source plan: requirements, decisions, implementation steps, testing decisions, completion criteria, and out-of-scope boundaries. A step the plan marks follow-up becomes its own ticket. Resolve contradictions or scope-changing open questions with the user before publishing affected work. Keep the source spec intact; store drafts and the ticket map in `.scratch/<slug>/tickets.md`, beside the spec when it uses that directory. Ensure `.scratch/` is locally excluded via `.git/info/exclude`.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions use the project's existing terminology and respect the design decisions its docs record.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Find the issue structure

Find how this repo writes issues, in this order, and stop at the first source that answers:

1. Documented rules: `.github/ISSUE_TEMPLATE/` (templates and `config.yml`), `.github/ISSUE_TEMPLATE.md`, the issue section of `CONTRIBUTING.md`, `AGENTS.md` / `CLAUDE.md`, and the repo's docs.
2. Observed practice: `gh issue list --repo <r> --state all --limit 30 --json number,title,labels,body`, then read the bodies. Take the structure most of them share: heading names and order, title style (prefixes, tags, case), labels, whether acceptance criteria are a checklist, and how blockers and parents are referenced. Ignore outliers, bot-written issues, and pull requests.

Record the result as one short template for the main issue and one for sub-issues (they may be the same). When neither source yields a structure (empty tracker, no rules), use the fallback templates at the end. Tell the user which source the structure came from.

### 4. Find or plan the main issue

Look on the remote tracker for an existing main issue for this work: the one the user passed, one recorded in the local ticket map, or an open issue whose title or body matches the plan (`gh issue list --repo <r> --state open --search "<keywords>"`). Read candidate issues to establish whether they cover this plan; ask the user only when the match is ambiguous. Reuse existing tickets that already cover planned work.

- Existing main issue with multiple tickets: tickets become its sub-issues. Preserve its title and body; obtain authorization for any body edit needed to add the ticket list or missing plan coverage.
- No main issue: create one from the whole plan (problem, approach, scope, the ticket list), in the structure from step 3.
- Only one ticket and no existing main issue: publish a single issue, no sub-issues. Its body carries the whole plan and the ticket's acceptance criteria.
- Only one ticket and a main issue already exists: use that issue as the ticket. Verify its body covers the whole plan and acceptance criteria. If it does, record its URL without creating a duplicate. If it does not, draft the missing content and obtain authorization to update the existing body.

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

### 6. Check coverage and present the breakdown

Present the plan in one message:

- The structure source from step 3.
- The main issue: the existing one found, or the title of the one to create, or "single issue, no sub-issues".
- A numbered ticket list. For each ticket: title, blocked by, and what it delivers (the end-to-end behaviour it makes work).

In `tickets.md`, map every requirement, implementation step, and completion criterion from the source plan to the ticket that covers it. Draft the full issue bodies before publishing. Each ticket must be usable in a fresh implementation session: carry the relevant decisions, test seams, and acceptance criteria into its body, since tracker readers cannot access a local spec path. Verify that dependencies have no cycles and only represent actual prerequisites.

Invoking this skill authorizes creating the tickets for the agreed plan. Present the breakdown and proceed to publication unless the user requested draft-only work or a review before publishing. Ask only for an unresolved scope decision, an ambiguous existing issue, or an existing-body edit requiring authorization. Do not add a separate approval round for a straightforward breakdown.

### 7. Publish

Publish in dependency order (blockers first), so every reference points at a real issue number.

Confirm the target repository from its remotes and pass it explicitly to every `gh` command. Record each issue URL in `tickets.md` immediately after creation. On a partial failure, inspect the tracker and resume the missing work rather than recreating successful issues.

For a single ticket, create or reuse just one issue carrying the whole plan and acceptance criteria, then proceed to verification in step 6 below. Parent links and sub-issues apply only to multiple tickets. Reuse issues already verified in step 4 instead of creating them again. When a fallback requires editing a reused issue body, obtain authorization for that edit first.

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
6. Verify the created or reused issues and their coverage against `tickets.md`. When native links were used, read back the sub-issue list and blocking edges through `gh api`; when body references were used, read back those bodies instead. For a single issue, verify its body covers the whole plan. Fix gaps before reporting every issue URL and the local ticket map path. If a failure prevents completion, report the issues already created and the work still missing.

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

## Implementation and testing decisions

The decisions from every spec section that bear on this ticket, including test seams and verification steps. Include enough context to implement this ticket independently of the local conversation.

## Blocked by

- A reference to each blocking ticket, or "None (can start immediately)". Omit this section when blockers were set as native edges.

</ticket-template>
