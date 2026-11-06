---
name: diagnose
description: Diagnosis of unknown issues, hard bugs, and performance regressions, ending in a root cause and a fix plan. Use when the user says "diagnose", "debug this", or "why is X failing", or hands over a bug report, a failing CI job, or something broken, throwing, flaky, or slow.
---

# Diagnose

Turn an unexplained symptom into a confirmed root cause and a fix plan: locate the area, stand up the smallest environment that reaches it, reproduce it with a **tight** loop that goes **red**, then prove one hypothesis and plan the fix.

End state: the diagnosis report below, written to `.scratch/<slug>/diagnosis.md` (add `.scratch/` to `.git/info/exclude` if it is not ignored) and summarised in chat in the user's language, with the root cause confirmed by the loop, the repro command, the environment recipe, and the fix plan. All tagged debug instrumentation is removed. The fix itself is applied only when the user asks for it in this session (see Phase 7); otherwise the plan hands off to an issue or an implementation session.

Stop and ask only when: you cannot build a loop (Phase 3), an environment step needs a destructive or shared-infrastructure action (see Boundaries), or the evidence points at two root causes the loop cannot separate.

## Redact

This skill has you show commands, outputs, and captured artifacts. Redact every secret first: write `<REDACTED>` in its place. Build loops against env vars, so the credential stays in the environment rather than in what you show. Captured artifacts carry auth headers: quote only the lines that carry the signal. If the redacted output is not enough to diagnose, say so and ask the user.

## Boundaries

Never delete a cluster, Helm release, worktree, secret, or artifact directory to make room for a repro without explicit confirmation; create a net-new one with a unique name instead. CI retries, manual jobs, and pipeline cancels are remote writes that need the user's go-ahead, named by project, ref, and job. "Fix CI" is not that go-ahead.

## Phase 1: Intake and locate

Read every source the user hands over, in full: the issue or bug report and its thread (`gh issue view <n> --comments`, or the tracker's MCP tool when the report lives elsewhere), the CI job log, the attached logs, stack traces, and core dumps.

Pin down:

- The exact symptom, quoted: error message, wrong output, timing, exit code.
- Where it happens: version or commit, configuration, platform, hardware, and whether it is always, sometimes, or since a known change.
- The suspected area: the component and entry point the symptom passes through, found from stack traces, log prefixes, and `git log` of that area since the last known-good state.

Reading code here is for locating where the symptom lives, never for deciding why. Done when the symptom is quoted verbatim, the environment is named, and you can point at a component and entry point. When the sources disagree about the symptom, ask the user which one is the bug.

## Phase 2: Prepare a minimal environment

Stand up the smallest environment that runs the suspected code path, preferring the first that reaches it:

1. The repo's own test harness (unit or integration target).
2. A local process or CLI run with fixture input.
3. A container from the image or toolchain the failing environment uses.
4. A local cluster or service stack (kind, compose) with only the components on the path.
5. A single node of the target platform or hardware, when the bug depends on it.

Match the failing environment's versions on everything the code path touches; leave out everything it does not.

Write the recipe to `.scratch/<slug>/env.md`: every command to build it from scratch, image tags, versions, config, and the resource names you created. Done when the environment boots from the recipe and another engineer could rebuild it from the file alone.

## Phase 3: Build a feedback loop

This is the skill. With a tight pass/fail signal that goes red on this bug, bisection, hypothesis testing, and instrumentation all just consume it. Without one, reading code will not find the cause. Spend disproportionate effort here.

Ways to construct one, roughly in this order:

1. Failing test at whatever seam reaches the bug: unit, integration, e2e.
2. Curl or HTTP script against a running service.
3. CLI invocation with fixture input, diffing stdout against a known-good snapshot.
4. Headless browser script that asserts on DOM, console, or network.
5. Replay of a captured trace, payload, or event log through the code path in isolation.
6. Throwaway harness: one service, mocked dependencies, the bug path behind one call.
7. Property or fuzz loop for "sometimes wrong output": run many random inputs and look for the failure mode.
8. Bisection harness when the bug appeared between two known states, so `git bisect run` can drive it.
9. Differential loop: same input through old and new version, or two configs, and diff the outputs.
10. Human-in-the-loop script as the last resort, driven by [`scripts/hitl-loop.template.sh`](scripts/hitl-loop.template.sh) so the loop stays structured.

Tighten it: faster (cache setup, narrow scope), sharper (assert the specific symptom, not "did not crash"), more deterministic (pin time, seed randomness, isolate the filesystem and network). For non-deterministic bugs the goal is a higher reproduction rate: loop the trigger, parallelise, add stress, narrow timing windows, until the rate is high enough to debug against.

Done when you can name one command you have already run (show it and its redacted output) that is:

- [ ] Red-capable: drives the bug code path and asserts the user's exact symptom from Phase 1.
- [ ] Deterministic: same verdict every run, or a pinned high reproduction rate.
- [ ] Fast: seconds, not minutes.
- [ ] Agent-runnable: unattended, or human-in-the-loop only through the template script.

When you cannot build one, stop and say so: list what you tried, and ask for access to an environment that reproduces it, a redacted captured artifact, or permission to add temporary instrumentation where it occurs. No red loop, no Phase 4.

## Phase 4: Reproduce and minimise

Run the loop and watch it go red. Confirm the failure is the one the user described, not a nearby one, and that it reproduces across runs.

Then shrink the scenario: cut inputs, callers, config, data, and steps one at a time, re-running the loop after each cut. Done when every remaining element is load-bearing: removing any one turns the loop green.

## Phase 5: Hypothesise and instrument

Write 3 to 5 ranked, falsifiable hypotheses before testing any: "If X is the cause, then changing Y makes the bug disappear and changing Z makes it worse." A hypothesis without a prediction is discarded or sharpened. Show the ranked list to the user, and carry on with your ranking without waiting for a reply.

Each probe maps to one prediction; change one variable at a time. Prefer a debugger or REPL, then targeted logs at the boundaries that separate hypotheses. Tag every debug log with a unique prefix such as `[DEBUG-a4f2]` so cleanup is one grep. For performance regressions, measure a baseline first (timing harness, profiler, query plan), then bisect.

Done when one hypothesis has its predictions confirmed by the loop and the others are falsified. That hypothesis is the root cause.

## Phase 6: Fix plan and report

Decide where the regression test belongs: a seam that exercises the real bug pattern as it occurs at the call site. When the only available seam is too shallow to reproduce the chain that triggers the bug, record that as a finding.

Remove all `[DEBUG-...]` instrumentation (grep the prefix). List the environments and resources you created and ask before deleting any of them.

Write the report:

```markdown
# Diagnosis: <symptom in one line>

## Symptom
<exact symptom quoted, where and when it occurs, sources>

## Root cause
<the confirmed hypothesis, the code path (file and function), and why it produces the symptom>

## Evidence
<the loop command and its red output; the probes that confirmed the cause and falsified the alternatives>

## Reproduce
<the minimised repro command; pointer to .scratch/<slug>/env.md for the environment>

## Fix plan
<the change, the files or modules it lands in, alternatives considered and why not, risk and blast radius>

## Regression test
<the seam and what the test asserts, or why no correct seam exists>

## Open questions
<anything the loop could not settle; "None" if settled>
```

## Phase 7: Fix (only when asked)

When the user asks for the fix in this session:

1. Turn the minimised repro into a failing test at the chosen seam and watch it fail. If you forced the red by mutating code or a fixture, diff against a pristine copy to prove the mutation landed.
2. Apply the fix and watch the test pass.
3. Re-run the Phase 3 loop against the original, un-minimised scenario.
4. State the confirmed hypothesis in the commit message, so the next debugger learns from it.
