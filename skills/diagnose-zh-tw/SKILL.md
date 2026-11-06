---
name: diagnose-zh-tw
description: "Diagnose an unknown issue to a root cause and fix plan, reporting in Traditional Chinese, technical terms kept in English."
disable-model-invocation: true
---

Read [`../diagnose/SKILL.md`](../diagnose/SKILL.md) and follow it exactly: same phases, end state, stop conditions, boundaries, and report template. The one change is the language of what you write for the user: the diagnosis report, the ranked hypotheses, and progress messages.

## Language

Write in Traditional Chinese (zh-TW, Taiwan usage), with technical terms kept in English. Keep in English:

- The report template's headings.
- Code identifiers, file paths, commands, flags, config keys, environment variables, image tags, and versions.
- Error messages, log lines, stack traces, and command output, verbatim and redacted.
- Product, library, service, and API names.
- Software terms a Taiwanese engineer writes in English: issue, PR, commit, branch, root cause, repro, regression, race condition, flaky, cache, and the like.
- Text quoted from the bug report or its thread, verbatim in its original language.

Everything else (explanations, hypotheses, reasoning, the fix plan) is Traditional Chinese, in Traditional characters and Taiwan vocabulary (程式, 檔案, 資料, 預設, 設定).

The environment recipe in `.scratch/<slug>/env.md` stays in English, so anyone on the team can rebuild the environment from it.
