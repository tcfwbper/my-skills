# Crit publishing

Crit is a VS Code extension that shows review comments inline. Its MCP tools (`listDiffComments`, `addDiffComment`, `replyToDiffComment`, `resolveDiffComment`) take a `code`:

- A project code `crit:v1;<session>;<project>` addresses the editor window and project. The extension's "Ask AI to Review Changes" request puts one in the invoking text.
- A thread code `crit:v1;<session>;<project>;<thread>` addresses one comment thread. `listDiffComments` returns one per thread, and `addDiffComment` returns the new thread's code. Any Crit diagnostic in the editor's Problems view carries one too.

Pass a code unchanged. Codes from a reloaded window are rejected as stale; when that happens, ask the user for a fresh one.

## Getting the code

Use the code from the invoking text or the caller. When the user invoked this skill directly without one, ask once before dispatch for a code (any Crit diagnostic code or the review request's project code) and keep working while waiting. The full findings go in the chat report when no code has arrived by the report, when Crit tools are unavailable, or when a calling skill passed none.

## Publishing

After the report is consolidated, write it into the editor:

1. List existing comments. Skip a finding or stop that already has a comment. For a comment from an earlier review whose finding is now verified fixed, reply with one line on the fix and resolve it, using that thread's code.
2. For each human review order stop, add one comment at its first line: `Review <k>/<N> - <High|Medium|Low>: <what this stop does and what to verify>`.
3. For each confirmed finding, add one comment at its line or range: `<grade> - <lens>: <defect> - <trigger> - <consequence>. Fix: <smallest fix>`. For each human-confirmation item: `confirm - <question and evidence>`.

Comment text is in the user's language, one finding per comment. A comment that fails to post goes into the chat report in full. Done when every stop, finding, and confirmation item has a comment or appears in full in the chat report.
