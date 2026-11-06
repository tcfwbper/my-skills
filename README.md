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
/grill-me  ->  /to-spec  ->  /to-tickets  ->  /implement (per ticket)  ->  PR  ->  /retro
                                           \->  /implement-spec (all at once)
```

Keep `grill-me`, `to-spec`, and `to-tickets` in one context window. Start a fresh window for each `/implement`. Small change: `grill-me` then `/implement` directly.

| Skill | You type it | Agent fires it | What it does |
| --- | --- | --- | --- |
| [grill-me](skills/grill-me/SKILL.md) | yes | | Interviews you in rounds until every design decision is settled. Facts it looks up itself; decisions are yours. |
| [to-spec](skills/to-spec/SKILL.md) | yes | | Turns the conversation into a spec (problem, stories, decisions, testing, done-when) and publishes it as a GitHub issue or `.scratch/<slug>/spec.md`. No re-interview. |
| [to-tickets](skills/to-tickets/SKILL.md) | yes | | Splits a spec into vertical-slice tickets with blocking edges; confirms the breakdown with you first. |
| [implement](skills/implement/SKILL.md) | yes | | Builds one ticket: states the task contract, drives `tdd`, runs the repo's own test commands, runs `code-review`, commits with the repo's convention, reports evidence. |
| [implement-spec](skills/implement-spec/SKILL.md) | yes | | Builds a whole spec: parallel implementer subagents in worktrees, evidence checked before each merge, one integration branch, final table. |
| [retro](skills/retro/SKILL.md) | yes | | After a session: what in the agent's environment (steering files, checks, tooling) should change so the next run goes better. |
| [handoff](skills/handoff/SKILL.md) | yes | | Compacts the session into a file another session can continue from, including the task contract and open checklist items. |
| [study-issue](skills/study-issue/SKILL.md) | yes | | Reads an issue, its thread, linked PRs, and the code it touches, then briefs you: problem, scale, approach, expected outcome, and status (Triage, In-progress, Done). |
| [study-issue-zh-tw](skills/study-issue-zh-tw/SKILL.md) | yes | | Same as `study-issue`, with the brief written in Traditional Chinese and technical terms kept in English. |
| [code-review-pr](skills/code-review-pr/SKILL.md) | yes | | Reviews a remote PR: studies its issue first, explains how the implementation solves it, grades risks (High, Medium, Low), and lists every point a human must confirm, including sound designs with equally good or better alternatives. Read-only. |
| [code-review-pr-zh-tw](skills/code-review-pr-zh-tw/SKILL.md) | yes | | Same as `code-review-pr`, with the brief written in Traditional Chinese and technical terms kept in English. |
| [tdd](skills/tdd/SKILL.md) | yes | yes | Red-green loop at pre-agreed seams, with the repo's own runner. What a good test is, what to mock. |
| [code-review](skills/code-review/SKILL.md) | yes | yes | Two parallel reviews of a diff (repo standards, spec fidelity); every finding cites file, line, hunk and is verified before it is reported. |
| [pr](skills/pr/SKILL.md) | yes | yes | Fills the repo's PR template: smallest visual summary, before/after evidence, tests run, merge danger. |
| [diagnosing-bugs](skills/diagnosing-bugs/SKILL.md) | yes | yes | Hard bugs: build a feedback loop that goes red first, then minimise, hypothesise, instrument, fix, regression-test. |
| [writing-for-agents](skills/writing-for-agents/SKILL.md) | yes | yes | How to write skills and steering files: task statements, no reasoning steering, progressive disclosure. Used by `retro`. |

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

Derived from Matt Pocock's skills (MIT). The `pr` skill's summary visuals come from Dex Horthy's `show-me` (see `skills/pr/CREDITS.md`).
