---
name: interview-me
description: Frames a vague request through an interview, one question at a time, before any creation. Use when the request lacks the goal, the audience, the success criterion or the main constraint ("make me a flyer", "a visual for…"), or when the user writes "interview me", "ask me questions", "are we sure?". Adapted from addyosmani/agent-skills (MIT).
---

# Interview me — frame before creating

What the user asks for and what they really want often differ (a deliverable redone 4 times because the real goal arrived message after message). This skill fixes that BEFORE v1. It comes before `project-lead`: the interview produces the confirmed intent, the project lead splits it and produces.

## When to use it
- The **for whom**, **why**, **success criterion** or main **constraint** is missing; the request is generic ("a flyer") without details.
- The user asks: "interview me", "ask me questions".
- Do NOT use it: clear request, one-line fix, information question, mechanical operation, the user wants speed. First read the memory notes and open workstream: never ask what the memory already says.
- **Never in an autonomous context** (night jobs, loops, scheduled tasks): report the gap as blocking instead of guessing.

## Flow
1. **Hypothesis + confidence**: one sentence on what the user wants, an honest percentage. Below ~70 %, add what is missing.
   `HYPOTHESIS: … / CONFIDENCE: ~30 % — missing: audience, product, success`
2. **One question at a time**, with my assumed answer:
   `Q: … / ASSUMED: … (why)`
   Wait for the reaction. Never two questions in one message. Accept being wrong, and sometimes assume in the direction the user will contradict.
3. **Listen for "want" vs "should want"**: answers of principle ("modern", "premium", "as usual") without detail → ask: "If you had to justify it to nobody, what would you really want?"
4. **Rephrase** in 5 to 8 lines, with the user's own words:
   - Outcome · For whom · Why now · Success · Constraint · **Out of scope** (mandatory)
   then "Yes / no / adjust?"
5. **Explicit yes required**. "Whatever you think", "fine", "OK let's go" are not a yes: offer two concrete options or ask "what would you adjust?".
6. **Stop**: once the yes is in, deliver the confirmed intent, suggest the next step (project-lead, or save it in the relevant workstream) and **stop there**, without starting production in the same turn.

## Stop rule (≈95 %)
Done when I can predict the user's reaction to the next three questions. If after several rounds that is not the case, say it: "something fundamental is missing, shall we step back?"

## Guardrails
- 4 to 6 questions are usually enough; do not drag it out.
- No password, cost price or sensitive data in the saved rephrasing.
- Save the intent (in `memory/workstreams/<name>/`) only with the user's agreement.
