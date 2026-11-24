---
name: print-pdf
description: Creates agency-quality print and PDF material — product catalogues, A5 flyers, brochures, product sheets, point-of-sale displays, posters, comparison boards, gift cards. Use whenever the user asks for a "nice" PDF, a catalogue, a flyer, a brochure, a POS display or any document meant for printing or for sending to partners.
allowed-tools: Bash(node .claude/skills/print-pdf/scripts/html2pdf.cjs *)
---

# Print PDF — catalogues, flyers, displays, brochures

Goal: a PDF the user can send to a printer or a partner without touch-ups, that looks designed by a studio, not generated.

## 1. Before drawing

- Read in memory/: preferences.md (visual taste, rules) and the brand note (palette hex codes, tone, forbidden words).
- Non-negotiable rules:
  - Never put confidential data (margins, cost prices, internal figures) in a document.
  - Catalogue or product supplied → reproduce it faithfully. **Never invent a reference, price, model name or product photo.** Missing info = a slot marked `[TO COMPLETE]`, not an invention.
  - Iterations: apply only the requested change, leave the approved rest untouched.
- If the request does not say: format, page count, use (pro print, office print, screen/email) → choose the most likely and announce it in one line rather than asking three questions.

## 2. Method: HTML → PDF

Build the layout in HTML/CSS, then render it to PDF with Chromium:

```bash
node .claude/skills/print-pdf/scripts/html2pdf.cjs page.html output.pdf
```

The script honours `@page` (exact size, printed background). If `playwright` is missing: `npm i playwright` in the skill folder, then `npx playwright install chromium`.

Page template:

```css
@page { size: 210mm 297mm; margin: 0; }          /* A4. A5 = 148×210, A3 = 297×420, square 210×210 */
html, body { margin: 0; }
.page { width: 210mm; height: 297mm; position: relative; overflow: hidden; break-after: page; }
.safe { position: absolute; inset: 10mm; }        /* safe area: no text outside it */
```

- **Pro print (printer)**: add 3 mm bleed on each side (A4 page = 216×303 mm), backgrounds and images running to the edge, text ≥ 3 mm + 5 mm from the trim. Tell the user the PDF is RGB: convert it to PDF/X (e.g. FOGRA39) with a preflight tool before sending.
- **Screen / email / office print**: no bleed, margins ≥ 10 mm.
- **Fonts**: embed free fonts with `@font-face` from local files, never the default system font. One or two families max, clean type scale.
- **Images**: only those supplied by the user (product photos, logos) or patterns drawn in CSS/SVG. ≥ 300 dpi at print size; flag any image that is too weak (`image-enhancer`).

## 3. Catalogue from data

When products come from a file (Excel, export, pasted list):
1. Read the file, normalise into a list (ref, name, retail price, features, photo).
2. Generate the HTML by script (one product card per ref, regular grid, automatic pagination), never by hand.
3. **Control**: count refs in the input and in the PDF, check each ref/price in the PDF against the source (`checker`). Announce the result.

## 4. Check before delivering

- Turn each page into an image and look at it: `pdftoppm -png -r 60 output.pdf preview` then read the PNGs (or `/check-render`).
- Look for: overflowing or overlapping text, elements outside the safe area, widows/orphans, weak contrast, empty page.
- Fix then re-check. Deliver the PDF (and the HTML source if the user wants to edit).
- For a booklet to fold from A4 sheets: `python3 scripts/booklet.py a5.pdf booklet.pdf`.

## 5. Layout good practice

- One strong idea per page or spread; let it breathe (white space is a choice).
- Strict grid (6 or 12 columns), consistent alignments, same margins everywhere.
- Hierarchy: product visual > model name > price > features.
- Prices always readable, in the user's local format.
- Cover and back cover cared for in a catalogue; table of contents beyond 12 pages.
