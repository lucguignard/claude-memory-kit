---
name: check-render
description: Visual check of a deliverable (PDF, HTML page, exported deck, web or mobile mock-up) in an isolated context — page-by-page screenshots with Playwright, list of defects (cut text, overflow, overlap, missing image, blank page, mobile rendering). Run /check-render <file or URL> before telling the user a visual deliverable is ready.
context: fork
disable-model-invocation: true
---

# Check the rendering of a deliverable

Argument: `$ARGUMENTS` (path to a PDF/HTML file, or a URL).

1. Open the deliverable with Playwright (`require('playwright')`, Chromium).
   - PDF: turn each page into an image (`pdftoppm -r 80 -png`), or open it in Chromium.
   - HTML / URL: full-page screenshot at 1440 px wide, then at 390 px (phone) if it is a web page.
2. Look at **every** screenshot (Read tool on the image). Conclude nothing without having seen it.
3. List defects page by page: cut or overflowing text, overlapping elements, missing or distorted image, blank or nearly empty page, fallback font, off-brand colours (see the brand notes in memory/ if any), readability on phone.
4. Answer in under 15 lines: "OK" or the list of defects with page and proposed fix, plus the screenshot path (in `/tmp/check-render/`). Modify no file of the deliverable.
