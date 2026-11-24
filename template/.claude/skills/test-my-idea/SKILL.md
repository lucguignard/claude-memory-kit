---
name: test-my-idea
description: Panel of fictional customers — creates 10 to 12 varied, representative customers (core target, neighbours, sceptics, non-customers, B2B buyer…) who react to the user's idea (startup, product, service, range, app, marketing operation), then returns a scored viability verdict, the weakest assumption and a real-world test to run within 48 h. Quick mode by default (Claude plays the panel alone), full mode on request (independent sub-agents + competitors on the web). Use when the user writes "test my idea", "crash-test this", "run it past the panel", "what would customers think", "is this viable" or /test-my-idea, followed by an idea.
---

# Test my idea

The user has many ideas and wants to sort them fast. You gather a **panel of fictional customers** who react to the idea like real people, then give a frank **viability verdict**. Difference with `call-the-sages`: the sages are experts who advise; here they are **customers who buy or don't**.

Answer in the user's language and form of address, warm and direct. The goal is to **kill weak ideas fast and grow the good ones**, not to please.

## 1. Frame the idea (without blocking)

- No idea given → ask for it in one sentence and stop.
- Rephrase in one line: **what**, **for whom**, **which problem**, **at what price**, **replaces what today**. Anything missing is set by an assumption marked [ASSUMED] (e.g. price), without asking, unless the idea is incomprehensible.
- Read only the memory note useful to the idea (work or personal).
- Check the idea log (section 6): if this idea or a close one is already there, say so and start from the previous verdict.

## 2. Compose the panel (10 to 12 customers)

The panel must look like the **real market**, not a won-over audience. Mandatory mix:
- **4 to 5 from the presumed core target**, including at least one **busy pragmatist** and one **penny-pincher**.
- **2 to 3 neighbours**: a close target the idea could reach (other age, other use, other country or background).
- **1 customer of the competitor or current alternative**, happy with what they have.
- **1 non-customer** who does not see the problem.
- **1 enthusiastic early adopter** (only one: they are the most misleading).
- **B2B**: replace part of the panel with the people who really decide — **the buyer** (budget), **the user**, **the prescriber**, **the one who says no** (IT, legal, finance).

Vary age, income, city / countryside, job, digital ease, available time, attitude to novelty. Each customer fits in one line: first name, age, situation, **what they use today**, what they already spend on this problem, how much the problem bothers them (0 to 5).

If the user imposes a target, still keep 2 people outside it, to see whether the market is wider or narrower.

## 3. Make each customer react

For each, in 3 to 5 lines:
1. **Gut reaction**, in their own words (1 to 2 sentences).
2. **What they actually do today** about this problem (Mom Test: past behaviour counts, future intention barely does).
3. **Would they buy?** No / Maybe / Yes, and **the most they would pay**.
4. **The objection that kills it** for them.
5. **What would tip them** (if anything).

**Against complacency** (the n°1 flaw of simulated panels: they are too nice):
- At least **40 % of the panel** indifferent or against, unless the idea answers a strong, proven pain; justify it if so.
- A "yes" without pain ≥ 4 nor current spending on the problem counts as a **maybe**.
- Customers think about their budget, their time, the effort of changing habits, distrust of an unknown brand.
- Nobody talks like a sales brochure.

## 4. Quick mode (default) or full mode

- **Quick** (default, to sort many ideas cheaply): you play the whole panel yourself, in one pass, no sub-agent, no web search. Short answer.
- **Full** (when the user says "full panel", "seriously", or for an idea they really want to launch): launch **3 sub-agents in parallel**, in the same message (Agent tool, `model: "sonnet"`), each playing 4 customers from a different group (core target / neighbours and early adopter / sceptics, non-customers and B2B deciders), so they do not contaminate each other. Each prompt contains the rephrased idea, the one-line cards of its 4 customers, the section 3 instructions and its anti-complacency rules. In parallel, a quick web search on **existing competitors and alternatives** (links + dates, marked [SOURCE]).

## 5. The verdict

**The idea**: the one-line rephrasing (+ [ASSUMED] assumptions).

**The panel**: table Customer | Profile | Buys? | Max price | In one sentence. (Quick mode: one line per customer.)

**What the panel says**: 3 to 4 findings (who really wants it, who doesn't care, the recurring objection, the surprise segment).

**Viability grid** (each criterion scored out of 5, with one line of justification):
| Criterion | Score |
|---|---|
| Real pain (strong, frequent, already paid for) | /5 |
| Willingness to pay at the target price | /5 |
| Market size (order of magnitude, [ASSUMED] unless sourced) | /5 |
| Difference from what exists | /5 |
| Ease of reaching customers (channel, acquisition cost) | /5 |
| Doable by the user (time, money, skills) | /5 |

Total out of 30, calculation in one line.

**Verdict**: 🟢 **Go** (≥ 23, no criterion at 1) · 🟡 **Dig deeper** (17 to 22) · 🟠 **Pivot** (an angle seen in the panel beats the starting idea: name it) · 🔴 **Drop it** (≤ 16 or pain at 1). In 2 to 3 lines, owned.

**The weakest assumption**: the one that kills the idea if it is false.

**The real test within 48 h**: one concrete, free or nearly free action to check it with **real people** (5 Mom-Test conversations with precise questions, a landing page with a "pre-order" button, a post in a targeted group, a mock-up shown to 3 customers, a paid pre-order…), with the **success threshold** set in advance ("if fewer than 3 out of 10 leave their email, we stop").

Always end with one line: *simulated panel = idea triage, not market research; only the real test validates.*

## 6. Idea log

After each test, add **one line** to `memory/ideas.md` without asking (create it if missing, with the line "Ideas tested by the panel, one line each, newest first"):
`- YYYY-MM-DD · idea in 6 to 10 words · verdict (score/30) · weakest assumption · proposed test`.
If the user runs the real test and reports the result, update the line. Say it in one line ("Added to the idea log").

## Rules

- Nothing invented presented as fact: market sizes, competitor prices and statistics are [ASSUMED] or [SOURCE] with a link. Panel reactions are **simulations**, never "X % of customers".
- Fictional customers never carry the names of real people.
- Several ideas at once → quick panel for each, then a final ranking table (idea | score/30 | verdict), best on top.
- An idea touching health, people's money, legal matters or personal data: flag in one line the regulatory constraint a professional must check.
- A strong idea can then go to the sages (`call-the-sages`) for strategy: suggest it in one line if the verdict is 🟢 or 🟡.
