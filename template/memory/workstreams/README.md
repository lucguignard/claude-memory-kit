# Workstreams

A workstream is a task that lasts more than one session. Each one has its folder `workstreams/<short-name>/` with three files:

- **plan.md**: the goal in one sentence, then the steps to tick (`- [ ]` / `- [x]`), with the creation date.
- **findings.md**: what was learnt along the way (sources, decisions), dated.
- **progress.md**: one bullet per session: what was done, where we stopped, next step.

Rules for Claude:
- At the start of a task that looks like an active workstream, read its three files before acting.
- Update plan.md and progress.md as you go, so work can resume after a break or a compaction.
- Finished: note it at the top of plan.md ("Done on YYYY-MM-DD"), carry the durable decision to projects.md, move the folder to `workstreams/_done/`, and update the "Active workstreams" list of INDEX.md.
