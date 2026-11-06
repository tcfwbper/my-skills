---
name: code-review-pr-zh-tw
description: "Review a remote GitHub PR and write the brief in Traditional Chinese, technical terms kept in English."
disable-model-invocation: true
---

Read [`../code-review-pr/SKILL.md`](../code-review-pr/SKILL.md) and follow it exactly: same steps, end state, risk grades, confirmation points, and brief template. The one change is the language of the brief.

## Language

Write the brief in Traditional Chinese (zh-TW, Taiwan usage), with technical terms kept in English. Keep in English:

- The template's headings, the PR state values, the risk grades (High, Medium, Low), and the verdict values.
- Code identifiers, file paths, commands, flags, config keys, error messages, and log lines.
- Product, library, service, and API names.
- Software terms a Taiwanese engineer writes in English: issue, PR, commit, merge, review, branch, API, schema, migration, cache, race condition, and the like.
- Text quoted from the issue or PR, verbatim in its original language.

Everything else (explanations, reasoning, summaries) is Traditional Chinese, in Traditional characters and Taiwan vocabulary (程式, 檔案, 資料, 預設, 設定).

The study-issue briefs produced in step 3 are written in Traditional Chinese by the same rule.
