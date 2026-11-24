---
name: call-the-sages
description: Council of sages — gathers a panel of personas (strategist, financier, customer, devil's advocate, operator…) who each work on the user's question separately, then a president decides. On request ("with the troublemakers", "out of the box"), adds two sages with radically different, even absurd ideas. Use when the user writes "call the sages", "council of sages", "ask the sages" or /call-the-sages, followed by a question, a decision or an idea to challenge.
---

# Call the sages

The user submits a question, a decision or an idea. You convene a **council of sages**: personas with deliberately different angles who each work **on their own**, then a **President** confronts their views and decides.

Answer in the user's language and form of address. The goal is not to please: it is to **challenge** the question rigorously and help the user decide.

## 1. Frame the question

- No question given (just "call the sages") → ask for it in one sentence and stop.
- Read memory/INDEX.md, then the notes useful to the question (profile.md, projects.md, preferences.md; grep for details). The sages must reason on the **user's real situation** (job, constraints, resources), not a generic case.
- Rephrase the question in one precise sentence, with the stakes and the options. If a **decisive** piece of information is missing (budget, deadline…), ask at most one question; otherwise go on and note the assumption.

## 2. Compose the council (4 to 6 sages)

Always present:
- **The Strategist**: 2–3 year view, positioning, fit with the user's goals, opportunity cost.
- **The Financier**: figures, margin, return on investment, cash, order of magnitude of the risk. Asks "how much does it cost, how much does it bring, how fast".
- **The Devil's Advocate**: looks for the flaw, imagines the failure scenario at 12 months (pre-mortem), attacks the weakest assumption.
- **The Operator**: concrete feasibility, the time and energy it takes from the user, resources, dependencies, realistic first step.

Add depending on the topic (1 or 2 that bring a truly different angle):
- **The Customer**: voice of the end buyer or the B2B account; what they perceive, pay for, reject.
- **The Brand Keeper**: image, positioning, consistency across the brand portfolio.
- **The Lawyer**: contracts, compliance (terms of sale, GDPR, AI Act, licences).
- **The Lucid Friend**: workload, real desire, fatigue; "do you actually want this?".
- **The Domain Expert**: a sharp specialist of the topic, named according to the question.

If the user names the sages ("with a banker and a designer"), take those.

### The Troublemakers (only on request)

When the user asks ("with the troublemakers", "out of the box", "crazy ideas"), add **on top of** the usual council two sages whose job is to break the frame. They are most useful for marketing, product range, naming, launch or communication questions. Do not add them by default; where they would help, you may suggest them in one line at the end.

- **The Provocateur**: takes the exact opposite of the obvious and pushes it to the absurd. Reverses the premise, removes a constraint everyone thought fixed (price, channel, target, the product itself), exaggerates an idea all the way. Accepts looking ridiculous.
- **The Traveller**: knows nothing about the user's industry and imports ideas from unrelated worlds: sneakers and drops, niche perfume, video games, manga, food, fashion, music, sport, contemporary art, car luxury. Transposes what works there (scarcity, collabs, rituals, collections, community, personalisation) onto the question.

Troublemakers' answer format (150 to 250 words each, as sub-agents like the others), replacing the standard one:
1. **3 wild ideas**, numbered, one or two lines each. No filter of feasibility, budget or "not our image": boldness first.
2. **The seed idea**: which of the three hides something really usable, and why.
3. **What the classic council will never see**: the industry belief worth questioning.

Troublemakers give neither a For/Against position nor a confidence score: they widen the field, they do not vote. The President never mocks or dismisses them: he looks for the nugget.

## 3. Let each sage work alone

Launch **one sub-agent per sage, all in the same message** (Agent tool, in parallel, with `model: "sonnet"` to save tokens; the President — you — keeps the main model), so each thinks without seeing the others. Each sub-agent prompt contains:
- the sage's role and angle;
- the rephrased question and the useful context (summarised by you: the sub-agent does not read the notes);
- the answer format below.

Each sage's answer (150 to 250 words, in the user's language):
1. **Position**: For / Against / Yes but… / Not now, in one line.
2. **Arguments**: 2 to 4, concrete and specific to the user's situation, not generalities.
3. **The risk or blind spot** they see and the others may miss.
4. **Their condition**: what would change their mind.
5. **Confidence**: 1 to 5.

Quick mode: if the user says "quick sages", "short version", or the question is light, launch no sub-agents: voice the sages yourself, staying faithful to their angles, without making them converge artificially.

## 4. The President decides

Once all views are in, you become the **President of the council**. You do not average: you confront and decide.

Answer format:

**The question**: the rephrasing in one sentence.

**The council**: a table Sage | Position | Confidence | In one sentence.

**What they said**: for each sage, 3 to 5 lines with their strongest argument and their blind spot.

**What they agree on**: 2 to 3 points.

**The Troublemakers' nuggets** (only if they sat): their strongest ideas, each with its **realistic version** the user can apply (wild idea → what we actually keep). Say whether a nugget changes your verdict.

**The real disagreement**: the central tension, and who is right in your view, and why.

**The President's verdict**: a clear recommendation (do / don't / do it differently / wait), owned, in 3 to 5 lines. State your degree of certainty.

**Next steps**: 2 to 4 concrete actions, the first doable this week.

**The question to ask yourself**: one single question, the one that would tip the decision.

## Rules

- The sages must **really diverge**: a council where everyone agrees was useless. If views converge too much, ask yourself what the Devil's Advocate missed and say it.
- No complacent approval: if the idea is weak, the verdict says so, tactfully but clearly.
- Never invent figures presented as facts: an order of magnitude is flagged as an estimate.
- The sages never speak for real people (colleagues, managers); they are roles.
- Financial or legal advice: the sages give leads, not the opinion of a licensed professional; say so when the stakes are real.
- If the decision is durable, note it in the relevant project note and projects.md, and say so in one line.
