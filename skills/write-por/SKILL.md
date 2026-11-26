---
name: write-por
description: "Draft a POR from agreed design decisions for your review and write it to Google Docs after approval."
disable-model-invocation: true
---

Turn the agreed discussion into a POR that lets a reader unfamiliar with the conversation quickly understand the problem, the proposed solution, and its architecture. This can follow `/grill-me`, but any discussion with enough agreed context is sufficient. Use those decisions directly; the user invokes the interview separately when needed.

## Task contract

A Google Doc write requires a destination link and the author's approval of the draft for that destination. Treat links supplied for templates or references as read-only. Preserve unrelated content and collaborators' changes. Ask for the destination link when needed for an approved write. Clarify link roles if the intended destination is ambiguous.

Drafting is complete when the author has the checked draft, any unresolved questions, and the local draft path. An approved write is complete when the POR is written to the target document, read back, and checked against the agreed scope and the writing criteria below. Report the clickable document link and any unresolved questions. Stop after the document work. Implementation and ticket creation are separate tasks.

While drafting, pause only when ambiguous edit scope, a missing decision, or unavailable source material prevents a coherent draft. Draft everything supported by the available context before asking about a blocker. If document tools cannot write, provide the complete draft in chat and report the access issue.

Keep the draft and a short completion checklist in `.scratch/<slug>/por.md` and `.scratch/<slug>/por-checklist.md`, or the harness scratch directory outside a repository. In a repository, ensure `.scratch/` is ignored via `.git/info/exclude` before writing. Track source review, drafting, content checks, and, for a Google Doc write, author approval, writing, and read-back. Extend the checklist when gaps appear.

## Process

1. Read the supplied template and target Google Doc, as applicable, through the available document tools before drafting. Identify the structure, language, relevant content, and section to update. Use the team's POR template when supplied or already present in the target. Scope edits in a populated document to this POR. Use the fallback outline for an unstructured draft when a template is unavailable. This step is complete when the draft structure and any content to preserve are clear.

2. Synthesize the current discussion, including decisions, rationale, constraints, and rejected alternatives from `grill-me` when present. Read the local spec from `/to-spec` when available and other relevant sources as needed to resolve factual gaps. Use the project's terminology and the author's own framing and rationale where available. Distinguish agreed decisions, proposals, and open questions. Never invent metrics, links, approvals, or commitments. This step is complete when the problem, proposed architecture, and agreed scope can be explained from the available evidence. Ask only for missing decisions that block that explanation. Record lesser gaps as open questions.

3. Draft for readers who have not seen the chat, using the writing criteria below. Match the user's requested language or the target document's language. Keep what the reader needs to assess the problem, solution, scope, risks, dependencies, and milestones. Refer back to the spec or discussion for detailed decisions such as schemas, retry thresholds, and test fixtures. Bring a detail into the POR when it changes a decision the reviewer needs to make. This step is complete when a reader can explain why the work matters, how the solution works, and what remains undecided.

4. Check that the draft represents the agreed scope and decisions accurately, links have real destinations, and the architecture explains interactions. Resolve contradictions and unsupported claims. Give the author the draft for review and flag any open questions that affect scope, rationale, or delivery. Stop at the draft for draft-only requests. For a Google Doc write, proceed once the author approves the draft for the named destination. An explicit request to write a specific draft the author has already reviewed counts as approval.

5. Re-read the affected document content before writing. If it changed, reconcile against the latest version. Return to author review if reconciliation requires a material change to the approved draft or a decision about conflicting edits. Apply the scoped update with native headings and clickable links where supported. Read back the result and verify content, section order, link targets, and preservation of unrelated material. If a write fails or its outcome is uncertain, inspect the document before retrying so successful content is not duplicated. Mark completion only for work verified in the document.

## Writing criteria

### Overview

Open with one narrative paragraph connecting motivation, the concrete problem and its impact, the direction of the solution, and the expected outcome. Explain how the work is done today, who is affected, and where the current approach falls short before developing the proposal. Expand unfamiliar acronyms using the supplied context. Retain POR without guessing its expansion when none is given.

### Architecture

Show how the proposal addresses the challenges. Describe the major components, responsibilities, interfaces, dependencies, and movement of control or data at the level needed to assess the design. Use a representative end-to-end flow when it helps readers follow the solution across component boundaries. Explain state ownership, failure handling, and compatibility constraints when they affect the design.

Distinguish existing components from new or changed ones, and connect the significant choices to the problem they solve. Prefer a diagram for relationships or flows that would require lengthy prose. When an architecture diagram clarifies the solution, Call the Skill tool with "draw-architecture-diagram". Include its verified export in a format the document can display. Use prose for the rationale and behavior the figure leaves implicit. If the document tools cannot embed it, link the artifact when a reader-accessible location is available. Otherwise, deliver the diagram alongside the document and report the embedding limitation.

### Narrative and evidence

Use connected paragraphs to explain causes, behavior, and tradeoffs. Reserve lists for parallel items such as scope boundaries, alternatives, risks, and open questions. Give each section a purpose evident from its heading and opening. Cut repetition and keep scope to the agreed work. Put alternatives, detailed tradeoffs, and open questions that require alignment in an appendix. Keep the conclusion and any risk or dependency that affects the plan visible in the main text.

Link PRs, tickets, design documents, and supporting evidence at the point they matter, with descriptive clickable text. Use supplied or verified URLs. Distinguish source-backed facts from expected benefits and unresolved assumptions.

## Fallback outline

Adapt these headings to the work and the document's template. Use plain Markdown in the local draft, with headings, paragraphs, and lists, ASCII punctuation, and no bold labels or emoji. Include conditional sections only when there is relevant content.

- Overview: the narrative paragraph described above.
- Problem and context: current behavior, who is affected, impact, and why the existing approach is insufficient.
- Goals and scope: the intended outcome and explicit boundaries.
- Proposed architecture: components, responsibilities, interfaces, and the representative flow described above.
- Delivery and validation, when discussed: milestones, migration or rollout, dependencies, and how success will be checked.
- Appendix, when relevant: alternatives considered, tradeoffs, and open questions that require alignment.

Keep references near the claims they support; add a references section only when it helps navigation.
