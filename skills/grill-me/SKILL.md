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

Word each question so "yes" accepts your recommended answer.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, the repo's `AGENTS.md`, existing code), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Its answer is a claim until you have checked the evidence it cites (the file, the command output); only then does the fact settle a prerequisite. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

Use the project's existing terminology (from its `AGENTS.md`, docs, and code) rather than inventing names. When the user's wording and the code disagree, say so and ask which is right.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding. The natural next step is `/to-spec`.
