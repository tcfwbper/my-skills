# Re-review

This mode comes from a caller running a review loop, such as `implement`.

The caller passes the round number, the previous round's findings with the action taken on each (fixed, rejected with reason, left open), and the base of the fix diff: the revision the previous round reviewed.

- Preparation: also read the fix diff from that base and list the code paths it affects. Reuse the previous round's requirements brief and rules unless the fixes changed scope.
- Dispatch: all five reviewers run, each scoped to the fix diff and the code paths it affects, through its own lens.
- Deadline: the parent sets one deadline for the round from the fix diff: up to 3 minutes for a small local fix, up to 5 for fixes across several functions or files, the full 8 for fixes that change a flow or an interface.
- Each reviewer's report adds, for every previous finding in its lens: fixed, not fixed, or fixed with a new problem, with evidence.
- The report fills the "Previous findings" section.
