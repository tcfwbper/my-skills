---
name: to-spec
description: "Turn the current conversation into a local spec recording the agreed decisions and implementation plan."
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

## Where the spec is saved

Always write the spec locally to `.scratch/<slug>/spec.md`. Add `.scratch/` to `.git/info/exclude` if it is not ignored yet, so nothing personal lands in the shared repo. When the user provides a local output path, use that instead. Reuse the same spec when revising the same plan; preserve unrelated specs.

The spec records the decisions already made during `grill-me` or the current discussion, including their rationale and rejected alternatives where discussed. Record unresolved points explicitly rather than inventing decisions. Use plain Markdown: headings and lists, no bold labels, no emoji, ASCII punctuation.

This skill always writes a local spec file. Never create or modify tracker issues, publish the spec remotely, or invoke a publishing workflow from this skill. This applies even when the repo has an issue tracker configured. Publishing tickets belongs to `/write-issue`, which the user invokes separately with the spec path. No issue tracker or authentication is needed here.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's existing terminology (its `AGENTS.md`, docs, code) throughout the spec, and respect the design decisions its docs record.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Reuse seams already agreed during the discussion. If they have not been agreed, check with the user that the proposed seams match their expectations.

3. Write the spec using the template below. Capture the whole agreed scope and an ordered implementation plan that a fresh session can use without rereading the conversation. Verify that every agreed requirement and decision is represented. Report the local path and any unresolved points. Stop after saving the spec; do not create tickets or start implementation.

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

## Implementation Plan

An ordered checklist of the work needed to deliver the agreed solution. For each step, record what it delivers, prerequisites, and how completion can be verified. Include agreed migration, rollout, or cleanup work when applicable. This is the execution plan for the whole spec; ticket boundaries are decided by `/write-issue`.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Done When

The checkable end state `implement` works toward, as a short list: which user stories are live, what old behaviour or code is removed, which test commands are green, and any agreed rollout requirements. This is the contract a build session restates before it starts.

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature, including unresolved points and assumptions that still need confirmation. Keep these separate from agreed decisions.

</spec-template>
