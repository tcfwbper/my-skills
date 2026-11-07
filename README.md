# my-skills

Agent skills for shipping code in a shared repo, distilled from [mattpocock/skills](https://github.com/mattpocock/skills). They follow the [Agent Skills](https://agentskills.io) format, so they work in Claude Code, Codex, and any harness that reads `SKILL.md`, with any current frontier model. The tuning: every build states its end state, stop conditions, and checklist up front; subagent reports are checked against evidence; nothing personal is written into the shared repo.

## Install

```bash
# 1. operating rules, applied to every project (one line per harness you use)
cat operating-rules.md >> ~/.claude/CLAUDE.md     # Claude Code
cat operating-rules.md >> ~/.codex/AGENTS.md      # Codex

# 2. link the skills into each installed harness: ~/.claude/skills if `claude` is found,
#    ~/.agents/skills if `codex` is found (each is independent; a missing one is skipped)
#    (re-run after git pull if skills were added or renamed)
./link.sh

# 3. if the upstream plugin is still installed in Claude Code, remove it to avoid duplicates
claude plugin uninstall mattpocock-skills
```

Skills are invoked the same way in every harness: type `/<name>`, or let the agent reach for a model-invoked one when the task fits. Depth of reasoning is a harness setting (effort, reasoning level), not something the skills ask for.

## The flow

```
/grill-me  ->  /to-spec  ->  /write-issue  ->  /implement (per sub-issue)  ->  /code-review  ->  push, PR
/study-issue  ->  /diagnose (unknown cause)
/code-review   (local changes or a PR)
```

Start a fresh window for each `/implement`. `implement` calls `tdd` and `code-review` on its own.

| Skill | You type it | Agent fires it | What it does |
| --- | --- | --- | --- |
| [grill-me](skills/grill-me/SKILL.md) | yes | | Interviews you in rounds over a design tree until every decision is settled, with a recommended answer for each question. Writes nothing. |
| [grill-me-zh-tw](skills/grill-me-zh-tw/SKILL.md) | yes | | Same as `grill-me`, with the interview in Traditional Chinese and technical terms kept in English. |
| [to-spec](skills/to-spec/SKILL.md) | yes | | Synthesizes the conversation into a spec (problem, user stories, decisions, testing seams, done-when) and publishes it as a GitHub issue. No interview. |
| [write-issue](skills/write-issue/SKILL.md) | yes | | Splits a plan into tracer-bullet tickets and publishes them in the repo's own issue structure: one main issue for the plan, one sub-issue per ticket, blocking edges set. A single ticket is a single issue. |
| [study-issue](skills/study-issue/SKILL.md) | yes | | Reads an issue, its thread, linked PRs, and the code it touches, then briefs you: problem, scale, approach, expected outcome, and status (Triage, In-progress, Done). |
| [study-issue-zh-tw](skills/study-issue-zh-tw/SKILL.md) | yes | | Same as `study-issue`, with the brief written in Traditional Chinese and technical terms kept in English. |
| [code-review](skills/code-review/SKILL.md) | yes | yes | Reviews local changes or a PR after reading its issue and PR context. Four subagents cover correctness, boundaries, system invariants, and tests, each within six minutes. Reports verified risks as critical, high, medium, or low. Edits nothing. |
| [code-review-zh-tw](skills/code-review-zh-tw/SKILL.md) | yes | | Same as `code-review`, with the report written in Traditional Chinese and technical terms kept in English. |
| [diagnose](skills/diagnose/SKILL.md) | yes | yes | Unknown issues: locate, stand up a minimal environment, build a loop that goes red, minimise, prove one hypothesis, and report the root cause with a fix plan. Fixes only when asked. |
| [diagnose-zh-tw](skills/diagnose-zh-tw/SKILL.md) | yes | | Same as `diagnose`, reporting in Traditional Chinese with technical terms kept in English. |
| [implement](skills/implement/SKILL.md) | yes | | Builds one ticket: states the task contract, drives `tdd`, runs the repo's own test commands, runs `code-review`, commits with the repo's convention, reports evidence. |
| [tdd](skills/tdd/SKILL.md) | yes | yes | Red-green loop at seams taken from the issue (or confirmed with you), with the repo's own runner. What a good test is, what to mock. |
| [handoff](skills/handoff/SKILL.md) | yes | | Compacts the session into a file another session can continue from, including the task contract and open checklist items. |
| [writing-for-agents](skills/writing-for-agents/SKILL.md) | yes | yes | How to write skills and steering files: task statements, no reasoning steering, progressive disclosure. |

## Conventions the skills assume

- The repo's `AGENTS.md` / `CLAUDE.md` is the authority for commit format, sign-off, test commands, PR template, prose style. Skills read it; they never edit it.
- GitHub via `gh`. On a fork, the upstream repo is the tracker (`gh repo set-default <owner>/<repo>`).
- Personal scratch (specs, tickets, checklists) lives in `.scratch/`, excluded per clone with `.git/info/exclude`.
- Everything published is plain Markdown: headings and lists, no bold labels, no emoji, ASCII.

## Uninstall

`./unlink.sh` removes this repo's skill symlinks from `~/.claude/skills` and `~/.agents/skills`. It only touches links that point into this repo.

## Maintaining this repo

See `AGENTS.md`. Add a skill: create `skills/<name>/SKILL.md` and `skills/<name>/agents/openai.yaml`, add a row above, run `./link.sh`.

## Credits

Derived from Matt Pocock's skills (MIT).
