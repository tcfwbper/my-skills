---
name: to-spec
description: "Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed."
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

## Where things are published

Default: GitHub Issues through the `gh` CLI, in the repo `git remote -v` points at. On a fork (an `upstream` remote beside `origin`) the tracker is the upstream repo: pass `--repo <owner>/<repo>` or run `gh repo set-default` once. When the user says "local", or there is no GitHub remote, write Markdown files under `.scratch/<slug>/` instead; add `.scratch/` to `.git/info/exclude` if it is not ignored yet, so nothing personal lands in the shared repo.

Anything published is written for the tracker's readers: the repo's documented prose style (plain Markdown, headings and lists, no bold labels, no emoji, ASCII punctuation is the safe default), no internal hostnames, private ticket IDs, or debugging trails they cannot follow.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's existing terminology (its `AGENTS.md`, docs, code) throughout the spec, and respect the design decisions its docs record.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it: a GitHub issue, or `.scratch/<slug>/spec.md` locally (see above). Report the issue URL or path.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Done When

The checkable end state `implement` and `implement-spec` work toward, as a short list: which user stories are live, what old behaviour or code is removed, which test commands are green, and anything that must be true in the tracker (tickets closed, PR open). This is the contract a build session restates before it starts.

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
