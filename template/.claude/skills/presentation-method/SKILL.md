---
name: presentation-method
description: Method for effective, good-looking business presentations — new products for management, range review, marketing plan, trade show, sales training. Use together with the pptx skill (or a slides artifact type) whenever a deck, slides or a presentation is needed.
---

# Presentation method

This skill gives the substance and the method; building the file goes through the `pptx` skill (or a slides artifact type when available and the user did not ask for a .pptx).

## 1. Frame in one minute

- For whom (management, sales team, partners, trade show) and for which decision or action?
- Read in memory/: preferences.md, the relevant project or brand note (palette, tone, positioning), and the open workstream if any.
- Rules: no confidential figures the user's notes forbid; never invent a reference, a price or a figure. An estimated figure is labelled as such.

## 2. Structure that convinces

1. **One slide = one message.** The title is a sentence that states the conclusion ("The women's line grew [X] % in 12 months", with the real figure), not a topic ("Sales").
2. Order: context → figures → proposal → what it takes / next steps. End with the decision expected.
3. 10–15 slides for a meeting; detail goes to the appendix.
4. New products: a features × figures matrix with visuals, one slide per family, then a range summary.

## 3. Design

- 16:9, the brand palette, one or two fonts, plenty of white space.
- Large, sharp product visuals; no clip-art or decorative icons.
- Charts: one message per chart, the key data in colour, the rest in grey.
- No walls of text: 3 bullets max, 6–8 words each; the speech goes in the speaker notes.
- For an off-brand theme, suggest `theme-factory`.

## 4. Check before delivering

Convert to PDF then to images and look at every slide (overflow, overlap, contrast, title consistency). Fix before sending. **Never "ready" without this visual pass**, including for a slides artifact or a web page (`check-render`). Offer a PDF version for email.

## 5. Character budget before filling a template
Before generating a pptx: give the table zone / font size / max characters (title, number, caption…), write the copy within that budget, then measure with `python3 scripts/pptx-check.py <file.pptx>` before delivering.
