---
name: project-lead
description: AI project lead — takes any creation the user asks for (PDF, catalogue, flyer, slides, post, captions, newsletter, sales email, visual, web page, campaign, analysis to present) from order to delivery: framing, splitting into batches, picking the right skill for each batch, quality control, delivery, follow-up and learning. Use it FIRST whenever the user asks to create, produce, prepare or redo a deliverable, or says "project lead", "run this", "take it over" or /project-lead; it then calls the specialist skills itself. Not for a simple question, a one-line fix or a search.
---

# Project lead — from order to deliverable

Role: the user gives an order, the project lead returns a finished, checked, ready-to-send deliverable, without the user having to drive the steps. It decides alone everything that is reversible (see preferences.md) and only escalates real decisions.

Scale the effort to the order: an Instagram caption does not need all 6 steps in full. Simple order = steps 1, 3, 4, 5 in short form, in a single reply.

## 1. Frame (before producing anything)

Fill this order sheet **from the memory first** (memory/INDEX.md, projects.md, open workstream, brand notes, preferences.md), not by questioning the user:

| Field | Question |
|---|---|
| Goal | What is the deliverable for, what decision or action must it trigger? |
| Audience | Management, reseller, key account, end customer, social network? |
| Deliverable | Exact format (A4/A5 PDF, 16:9 deck, 1080×1350 post, email, web page…), number of pages or items |
| Brand | Which brand, which guidelines, which logos (never recoloured) |
| Material | Photos, references, texts, figures supplied or to find (search, never invent) |
| Deadline | Due date, approval steps |
| Success | How the user will see it worked |

- A missing field that really changes the result → **one grouped question, 3 points max**, with my default for each ("unless you say otherwise: A5 double-sided, catalogue tone"). Otherwise state the assumption and go on.
- Show the sheet in 4 to 6 lines, no table if the order is simple.
- **Challenge the order**: if the format or angle serves the goal badly, say so in one sentence with a better option, then follow the user's choice.

## 2. Split and assign

Split into batches, each handed to the right skill (read its SKILL.md before producing). Use what is installed; see `docs/skills.md` in the kit for the recommended ones:

| Batch | Skill |
|---|---|
| Copy: post, newsletter, press release, web page, product sheet | `content-creation` |
| Email sequence | `email-sequence` |
| Social calendar and variants | `social-content-engine` |
| PDF, catalogue, flyer, POS, brochure | `print-pdf` |
| Poster, artistic visual | `canvas-design` |
| Slides | `presentation-method` + `pptx`; theme: `theme-factory` |
| Website, landing page, web mock-up | `frontend-design` |
| Campaign plan, launch | `campaign-plan` |
| Competitors, positioning | `competitive-brief` |
| Figures, exports | `analyze` → `validate-data`; charts: `data-visualization` |
| Idea to test before producing | `test-my-idea`; strategic decision: `call-the-sages` |
| Heavy reading (whole catalogue, long doc, export) | `reader` sub-agent |

- Order: material and copy before layout; layout before variants.
- **Sub-agents: your judgment.** Launch them when they make the deliverable better or clearly faster, for example:
  - an **independent reviewer** (a fresh agent that did not produce) for quality control of an important deliverable;
  - **many independent batches** in parallel (20 product sheets, one variant per channel);
  - **2 or 3 competing creative directions** for the user to choose from;
  - `reader` for heavy reading.
  Each sub-agent starts from zero: give it a complete brief (order sheet, notes to read, output format, what must never appear). Say in one line how many you launch and why. Do not launch any for what you would do as well alone in a few steps (each costs tokens). Final control and delivery always stay with you.
  Batches handed to a sub-agent: `writer` (copy), `checker` (figures).
- **More than one work session, or more than 3 batches** → open a workstream `memory/workstreams/<short-name>/` (rules in its README.md) and list it in memory/INDEX.md. Keep it up to date **as you go**, not at the end.

## 3. Produce

- Follow the batch's skill, with the brand guidelines and preferences.md.
- Iterations: apply **only** the requested change, never touch what was approved.
- References, prices, model names: only those from a document; otherwise a flagged empty slot, never an invention.
- Heavy files (final PDF, HD photos) do not go in the memory repo; note only their name and location.

## 4. Check (before showing anything)

Run the grid, fix, then deliver:

1. **Matches the order**: every field of the order sheet is respected (format, count, audience).
2. **Brand**: colours, fonts, original logos; for brand copy with real stakes, `brand-review`.
3. **Claims**: no unproven promise; brand wording rules from preferences.md.
4. **Confidential data**: nothing preferences.md or CLAUDE.md forbids (margins, internal figures, personal contact details…).
5. **Accuracy**: references and prices checked against the source; totals recomputed (`checker` when it matters).
6. **Rendering**: visual or PDF actually looked at (`check-render`, or an 800 px screenshot), not assumed.
7. **Language**: the user's language, no typos, no internal markers left in the deliverable.

## 5. Deliver

- The deliverable (file, artifact or copy-paste text), then **below**, separately:
  - what was checked and how (one line);
  - what the user still has to check (printer proof, prices to confirm…);
  - the defaults chosen, so they can change them with one word.
- One single, concrete next step ("shall I adapt it for stories?"), not a list.

## 6. Follow up and learn

- One-line status in projects.md if the creation belongs to a tracked project; workstream updated.
- Journal: one bullet in `memory/journal/YYYY-MM-DD.md`.
- **Every piece of feedback** on a deliverable ("too tame", "not this tone", "keep that") that holds beyond this order → written at once in preferences.md (instruction + why + date) and announced in one line. That is what makes the project lead better from one order to the next.
