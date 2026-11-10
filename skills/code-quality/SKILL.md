---
name: code-quality
description: "Code quality rubric shared by planning, building, and review. Use when weighing a design option's maintenance cost, before calling an implementation done, or when reviewing code quality."
---

The rubric judges how an agreed design is carried out. Apply every category to the code or design in scope; a category with nothing to report gets the one line `<category>: nothing found`. A finding names its category, the location, the concrete cost to a reader or operator, and the smallest change that fixes it, plus the evidence the category asks for.

Design choices settled during planning (reusing or replacing an existing mechanism, what the work covers) are accepted here. A weakness in an accepted mechanism that the plan did not record goes to the human as a question, not as a quality finding.

## Categories

### 1. Explained constraints

Every branch that exists because of a system limit, a workaround, tech debt, or upstream behaviour carries a comment stating the constraint, its source (issue, upstream bug, decision), and when it can go. Exclusions, skip lists, special-cased inputs, and ordering requirements are the usual places. A reader who cannot see why a guard exists will remove it or copy it as design.
Evidence: the unexplained branch and the constraint it encodes, found from history, the issue, or surrounding code.

### 2. Hermetic by default

Build, test, and CI paths are hermetic where a hermetic path exists that adds no tech debt: vendored or fixture data, a local stub at an existing seam, an artifact already in the repo. Where the surrounding system already assumes external access (it pulls charts, images, or packages from registries throughout), following that assumption is acceptable; a comment at the access point names the assumption and the failure mode, and review surfaces it to the human.
Evidence: the external access, whether a hermetic alternative without new tech debt exists, and the system assumption it follows.

### 3. Fail loudly

A failure propagates to the caller or stops the run. Downgrading an error to a log line, a warning, or a skipped item is a stated decision: the code says why, and the downgraded outcome lands where someone will see it (a summary, an annotation, a counted result) rather than only in verbose logs. A check that quietly stops checking is the defect this catches.
Evidence: the downgraded failure, who needs to notice it, and where it ends up today.

### 4. YAGNI

Every mechanism, option, and abstraction serves a caller or requirement in the current work. A generalisation with one use stays inline until the second use arrives, unless the spec asks for it.
Evidence: the mechanism, its actual users in the change and the repo, and the simpler form that serves them.

### 5. Readable logic

A function does the one job its name states. Logic with several independent checks or stages is split into named steps, each readable in one pass. Each rule that accepts or rejects input carries a short worked example, in a comment or a test name: a case it catches and why that case is wrong.
Evidence: the function, the distinct jobs inside it, and the split or examples that make each job checkable.

### 6. Single source of truth for rules

Special cases, exceptions, and classification rules live in one home (a table, a helper, a config file the code reads), and every caller and test consults it.
Evidence: each copy of the rule and the home that should hold it.

### 7. Fixtures over real artifacts

Tests run on fixtures built for the case under test. A test reads the repo's real artifacts (its actual charts, configs, catalogs) only when the behaviour under test is a property of those artifacts. Rule expectations in tests come from the rule's single source of truth, so a test exercises the rule through a fixture instead of restating it.
Evidence: the real artifact or restated rule in the test, and the fixture or shared rule that replaces it.

### 8. Fit with the codebase

Naming, error handling, structure, and helpers match the surrounding package, and existing helpers are reused.
Evidence: the new pattern and the existing one it duplicates or diverges from.
