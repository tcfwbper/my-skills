Personal agent skills, distilled from mattpocock/skills (MIT, see LICENSE). One flat `skills/<name>/SKILL.md` per skill in the Agent Skills format, usable from Claude Code, Codex, and any harness that reads `SKILL.md`. No plugin manifest, no docs tree, no changesets. `CLAUDE.md` here is only `@AGENTS.md`; edit this file.

Rules for editing:

- Every skill is either user-invoked (reachable only by typing `/<name>`: `disable-model-invocation: true` in the frontmatter for Claude Code plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml` for Codex, with a human-facing one-line description) or model-invoked (model-facing description with trigger phrases, so the agent can fire it and other skills can call it with the Skill tool). Keep the two harness flags in sync. A user-invoked skill can call model-invoked ones, never another user-invoked one.
- Every skill carries `agents/openai.yaml` with `interface.display_name` and `interface.short_description` for the Codex skill picker.
- Skills call each other with "Call the Skill tool with \"<name>\"", one skill per call. Shared reference lives inside the skill that owns it.
- Nothing here assumes a project-level convention beyond `AGENTS.md`/`CLAUDE.md`, `gh`, and `.scratch/` excluded via `.git/info/exclude`. Personal operating rules live in `operating-rules.md`, installed into the harness's global steering file, never in a shared repo.
- Templates that get published (issues, PR bodies, specs) stay plain Markdown: headings and lists, no bold labels, no emoji, ASCII punctuation.
- No em-dashes in prose. Model-neutral wording: no model names, no "think step by step" or other reasoning steering; state the task, the end state, and the stop conditions instead (see `skills/writing-for-agents`).
- After adding, removing, or renaming a skill: update the table in `README.md` and run `./link.sh`.
