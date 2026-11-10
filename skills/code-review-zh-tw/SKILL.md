---
name: code-review-zh-tw
description: "Review code changes with five subagents and report in Traditional Chinese, keeping technical terms in English."
disable-model-invocation: true
---

Call the Skill tool with "code-review" and pass along the user's target and context. Follow [`../code-review/SKILL.md`](../code-review/SKILL.md) for the entire workflow. Apply the language rules below to the shared brief, subagent instructions and reports, and final report.

## Language

Write in Traditional Chinese (zh-TW, Taiwan usage), with technical terms kept in English. Keep in English:

- The template's headings, risk grades (`critical`, `high`, `medium`, `low`), review priorities (`High`, `Medium`, `Low`), coverage values (`complete`, `partial`).
- Code identifiers, file paths, commands, flags, config keys, error messages, and log lines.
- Product, library, service, and API names.
- Software terms a Taiwanese engineer writes in English, including issue, PR, commit, branch, review, Owns, Delegates, Must not do, Invariants, Edge Cases, and test pyramid.
- Quoted source text, verbatim in its original language.

Write explanations, reasoning, and summaries in Traditional characters and Taiwan vocabulary (程式, 檔案, 資料, 預設, 設定).
