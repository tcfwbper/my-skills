---
name: grill-me
description: A relentless interview to sharpen a plan or design before any code is written.
disable-model-invocation: true
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
Q1 - <question title>: <question body, might be multiple paragraphs, including multiple choices>

Recommended: <your recommended answer>

---

Q2 - <question title>: <question body>

Recommended: <your recommended answer>
```

Word each question so "yes" accepts your recommended answer. When the facts do not settle a recommendation, write `Recommended: none` followed by the analysis and the fact or preference that would decide it.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, the repo's `AGENTS.md`, existing code), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Its answer is a claim until you have checked the evidence it cites (the file, the command output); only then does the fact settle a prerequisite. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

Use the project's existing terminology (from its `AGENTS.md`, docs, and code) rather than inventing names. When the user's wording and the code disagree, say so and ask which is right.

## Quality impact

At the start, call the Skill tool with "code-quality" to load its rubric. Every question that offers options gives, for each option, the rubric categories it strains and the cost a future reader or operator pays, or one line saying it strains none. The recommendation weighs that cost alongside delivery cost.

Before settling a design that changes a shared file, trace its consumers to identify other affected features, including those outside the requested work. For each feature, establish the behavior to preserve and how to verify it before and after the change. This applies to shared code, configuration, and test files. Resolve compatibility decisions with the user and carry the affected features and regression checks into the agreed plan. This branch is settled when every affected feature has a preservation check or an explicit verification gap.

## Quality sweep

Before declaring the frontier empty, sweep the whole agreed design. Each item below produces numbered questions for the next round or the one line `<item>: nothing unclear`.

1. Existing mechanisms: wherever the work could build on an existing mechanism, inspect it for weaknesses (fragile mappings, single-case assumptions, missing validation) and put the choice to the user: reuse as is, reuse now and migrate later with the follow-up recorded, or replace first and migrate existing users. Give each path's cost and risk, and recommend from the evidence.
2. Each `code-quality` category the design decides, asked as that decision: which external access the work needs and whether a hermetic path exists, which failures stop the run and who sees a downgraded one, which new mechanism serves which requirement, which constraints the code must explain, and which fixtures and rule homes the tests use.

## Done

The session is done when the frontier is empty and the quality sweep has run: every branch of the design tree visited, every sweep item answered, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding. The natural next step is `/to-spec`.
