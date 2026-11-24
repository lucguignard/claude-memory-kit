---
name: resume
description: Pick up ongoing work without rereading the whole memory. Use when the user writes "let's pick up…", "where were we", or /resume <topic>.
argument-hint: [topic]
disable-model-invocation: true
allowed-tools: Bash(bash scripts/resume.sh *)
---

The user picks up work on: $ARGUMENTS

Context already loaded (journal, workstream progress, git status):

!`bash scripts/resume.sh $ARGUMENTS || true`

Instructions: summarise in 3 lines max where the work stands and suggest the next step. Open `plan.md` or a note only if the progress above is not enough.
