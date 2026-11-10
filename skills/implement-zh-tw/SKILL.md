---
name: implement-zh-tw
description: "Implement a piece of work based on a spec or set of tickets, reporting in Traditional Chinese with technical terms kept in English."
disable-model-invocation: true
---

Read [`../implement/SKILL.md`](../implement/SKILL.md) and follow it exactly. The one change is the language of what you write for the user: the task contract, progress messages, the final message, and every `code-review` report in the review loop. Pass the language rules below to each `code-review` call so its report follows them.

## Language

Write in Traditional Chinese (zh-TW, Taiwan usage), with technical terms kept in English. Keep in English:

- The contract labels (`Task`, `End state`, `Stop conditions`, `Checklist file`), the review report's headings, risk grades (`critical`, `high`, `medium`, `low`), review priorities (`High`, `Medium`, `Low`), coverage values (`complete`, `partial`).
- Code identifiers, file paths, commands, flags, config keys, error messages, log lines, and test output.
- Product, library, service, and API names.
- Software terms a Taiwanese engineer writes in English: issue, PR, commit, branch, review, seam, fixture, refactor, Owns, Delegates, Must not do, Invariants, Edge Cases, and the like.
- Text quoted from the spec, ticket, or tracker, verbatim in its original language.

Everything else (explanations, reasoning, progress, the review content) is Traditional Chinese, in Traditional characters and Taiwan vocabulary (程式, 檔案, 資料, 預設, 設定).

What lands in the repo stays in the repo's language and convention: code, code comments, test names, and commit messages.
