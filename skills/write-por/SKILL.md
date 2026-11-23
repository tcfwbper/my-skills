---
name: write-por
description: "Write a POR in a Google Doc from the decisions in the current discussion."
disable-model-invocation: true
---

Turn the agreed discussion into a POR that lets a reader unfamiliar with the conversation quickly understand the problem, the proposed solution, and its architecture. This can follow `/grill-me`, but any discussion with enough agreed context is sufficient. Use those decisions directly; the user invokes the interview separately when needed.

## Task contract

The required input is a Google Doc link identifying the document to write. Invoking this skill with that link authorizes writing the POR there, unless the user requests a draft or review first. Preserve unrelated content and collaborators' changes. Ask for the link if none was supplied; clarify its role if the user supplied several documents without identifying the destination.

Done means the POR is written to the target document, read back, and checked against the agreed scope and the writing criteria below. Report the clickable document link and any unresolved questions. Stop after the document work; implementation and ticket creation are separate tasks.

Pause only when the destination or edit scope is ambiguous, a missing decision prevents a coherent problem or architecture description, or document access prevents completion. Draft everything supported by the available context before asking about a blocker. If document tools cannot write, provide the complete draft in chat and state that the Google Doc remains unchanged.

Keep the draft and a short completion checklist in `.scratch/<slug>/por.md` and `.scratch/<slug>/por-checklist.md`, or the harness scratch directory outside a repository. In a repository, ensure `.scratch/` is ignored via `.git/info/exclude` before writing. Track source review, drafting, content checks, writing, and read-back; extend the checklist when gaps appear.

## Process

1. Read the target Google Doc through the available document tools before drafting. Identify its existing template, language, relevant content, and the section to update. Follow its structure where useful. A blank document can use the outline below; a populated document needs edits scoped to this POR. This step is complete when the destination and content to preserve are clear.

2. Synthesize the current discussion, including decisions, rationale, constraints, and rejected alternatives from `grill-me` when present. Read supplied specs and relevant linked sources as needed to resolve factual gaps. Use the project's terminology. Separate agreed decisions from proposals and open questions; never invent metrics, links, approvals, or commitments. This step is complete when the problem, proposed architecture, and agreed scope can be explained from the available evidence. Ask only for missing decisions that block that explanation; record lesser gaps as open questions.

3. Draft for readers who have not seen the chat, using the writing criteria below. Match the target document's language, or the user's requested language. Cover every agreed requirement and architecture decision at the level needed to assess the solution; keep execution details only when they explain a design choice, risk, or dependency. This step is complete when a reader can explain why the work matters, how the solution works, and what remains undecided.

4. Check the draft against the discussion and sources: scope and decisions are represented accurately, links have real destinations, and the architecture explains interactions rather than merely naming components. Resolve contradictions and unsupported claims before writing. Respect a draft-only or review-first request by delivering the draft and stopping at the requested boundary.

5. Re-read the affected document content before writing. If it changed, reconcile against the latest version; ask only when concurrent edits create a conflict requiring a human decision. Apply the scoped update with native headings and clickable links where supported. Read back the result and verify content, section order, link targets, and preservation of unrelated material. If a write fails or its outcome is uncertain, inspect the document before retrying so successful content is not duplicated. Mark completion only for work verified in the document.

## Writing criteria

### Overview

Open with one narrative paragraph connecting motivation, the concrete problem and its impact, the proposed solution, and the expected outcome. Give readers the central argument before the details. Expand unfamiliar acronyms using the supplied context; retain POR without guessing its expansion when none is given.

### Architecture

Provide an actual architectural overview: the current behavior and what changes, the major components and their responsibilities, their interfaces and dependencies, and how control or data moves between them. Walk through a representative end-to-end flow so the reader can follow the solution across component boundaries. Explain relevant state ownership, failure handling, and compatibility constraints when these affect the design.

Distinguish existing components from new or changed ones, and connect the significant choices to the problem they solve. When an architecture diagram clarifies the solution, Call the Skill tool with "draw-architecture-diagram". Include its verified export in a format the document can display, with prose explaining the interactions. If the document tools cannot embed it, link the artifact when a reader-accessible location is available; otherwise deliver the diagram alongside the document and report the embedding limitation. A component inventory or implementation checklist alone is insufficient.

### Narrative and evidence

Use connected paragraphs to explain causes, behavior, and tradeoffs. Reserve lists for parallel items such as scope boundaries, alternatives, risks, and open questions; headings should not all lead into lists. Keep the document concise enough to scan without removing the explanation needed to understand the design.

Link PRs, tickets, design documents, and supporting evidence at the point they matter, with descriptive clickable text. Use supplied or verified URLs. Distinguish source-backed facts from expected benefits and unresolved assumptions.

## Fallback outline

Adapt these headings to the work and the document's template. Use plain Markdown in the local draft, with headings, paragraphs, and lists, ASCII punctuation, and no bold labels or emoji. Include conditional sections only when there is relevant content.

- Overview: the narrative paragraph described above.
- Problem and context: current behavior, who is affected, impact, and why the existing approach is insufficient.
- Goals and scope: the intended outcome and explicit boundaries.
- Proposed architecture: components, responsibilities, interfaces, and the representative flow described above.
- Design rationale: significant choices and alternatives actually considered, with their tradeoffs.
- Delivery and validation, when discussed: migration or rollout, dependencies, and how success will be checked.
- Risks and open questions, when present: known limitations, unresolved decisions, and their impact.

Keep references near the claims they support; add a references section only when it helps navigation.
