# Crit reading notes

These notes help a human understand and verify the change with little surrounding context, including logic with no defect found. Use the user's language for prose and keep code identifiers unchanged.

## Scope and order

- Cover changed production logic and deletions of shared logic or documentation content. For shared deletions, explain the removed contract or guidance, affected consumers, and replacement or evidence that it is obsolete. Identify uncertain intent as a question.
- Cover additions, edits, deletions, and renames of agent operating instructions, including `AGENT.md`, `AGENTS.md`, `CLAUDE.md`, `SKILL.md`, and other files that guide agent behavior. Explain the changed rule, its scope or trigger, and the resulting effect on agent actions, permissions, or workflow.
- Exclude tests from all Crit notes, including test helpers and fixtures. Continue reviewing them and reporting their findings and place in the human review order in chat.
- Use one note per changed function. Split a long function at logical stages, branches, or failure paths so each note has a distinct verification focus. For logic outside functions, agent instructions, and documentation deletions, use one note per coherent block or section. Purely mechanical and generated changes stay in the report's skim stop.
- Follow the human review order, omitting stops outside this note scope. Number the resulting notes `1 / N` through `N / N`; the numbers indicate reading order, not line numbers. Reuse each stop's review priority in uppercase (`HIGH`, `MEDIUM`, `LOW`), separately from defect severity.

## Content

Start with `<order> / <total> - <PRIORITY>: <logic description>`. Name the function or section and explain the trigger or inputs, what changes from the previous behavior, and the resulting output or side effect. Include the caller, contract, or invariant needed to judge this block without reconstructing the surrounding flow. Focus each note on its own stage when a function has several notes.

Follow with `Decisions:` and bullets describing consequential branches, assumptions, tradeoffs, and failure behavior. Distinguish decisions supported by code or requirements from questions for the human; explain what to verify rather than inventing author intent. Link relevant confirmed findings when present. Use concrete behavior rather than a line-by-line paraphrase.

```markdown
2 / 5 - HIGH: persistOrder now writes the order and its items in one transaction. checkout calls it after validation; it returns an order ID only after commit, preventing a failed item write from leaving an empty order.

Decisions:
- An item-write failure rolls back the order and propagates to checkout. Verify that every write uses the same transaction.
- Payment remains outside this transaction. Confirm that checkout's existing retry path cannot charge the same order twice.
```

## Publish and verify

1. Discover the available Crit tools and use the project code supplied in the request or an existing thread code verified to belong to the reviewed project. If tools or a usable code are unavailable, finish the review, report the delivery gap, and request the missing code when needed to publish. Never guess a project code.
2. Verify that Crit's project files match the reviewed revision and working-tree state. Use `listDiffComments` to inspect existing notes and avoid duplicating equivalent notes for the same revision. Preserve human comments and unrelated threads.
3. Use `addDiffComment` with the project code, file, one-based line, optional end line, and note text. Anchor each note to the function or stage it explains. For deleted content, use a surviving changed declaration, replacement, or affected caller and identify the deleted symbol or section and its base-revision path in the note. If no accurate anchor exists, put the note in the report with its base-revision location and mark it undelivered; never attach old line numbers to unrelated current code.
4. Check tool results and use `listDiffComments` to confirm the intended notes and anchors. Delivery is complete when every in-scope stop has a note or an explicit delivery gap, numbering and priorities match the planned route, and no note is attached to tests. Report failures or revision mismatches without claiming publication succeeded.
