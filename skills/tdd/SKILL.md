---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

TDD is the red → green loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle: consult them before and during the loop, not after.

Run tests with the repo's own runner and the scoped target from the nearest `AGENTS.md` or `CONTRIBUTING.md` (`bazel test //pkg/... --test_output=streamed`, `go test ./...`, `cargo test`, `pnpm test <file>`), never a runner you assume. The nearest `AGENTS.md` may also require a particular test kind for the area (a Gherkin behaviour suite for CLI or install workflows, a contract test for an API surface); that kind is a seam too, and a slice that touches the area is not green until it is covered there.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Seams: where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Before writing any test, write down the seams under test, each with a one-line note on what it catches and what it misses. You can't test everything, so agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Take the seams from the issue or sub-issue being built when it states its testing approach or acceptance criteria, and from the calling skill's brief; those seams are already agreed. Only when neither settles them, ask the user: "What's the public interface, and which seams should we test?" No test is written at a seam that is neither stated nor confirmed.

When the shape of that interface is itself in question, prefer the deeper module: a small interface hiding a lot of behaviour, placed at a seam something actually varies across. Match the surrounding package's naming, structure, and error handling rather than introducing a new pattern.

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological**: the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Pin-coupled**: the assertion hard-codes a value that is really configuration (an image tag, a chart version, a dependency pin), so every unrelated pin bump breaks the test and the diff hides the real change. Unless that literal is the behaviour under test, read the expected value from its source of truth at test time, or delete the assertion.
- **Horizontal slicing**: writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead: one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Refactoring is not part of the loop.** It belongs to the review stage (see the `code-review` skill), not the red → green implementation cycle.
