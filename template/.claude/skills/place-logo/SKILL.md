---
name: place-logo
description: Places the REAL logo (transparent PNG) on an AI visual (box lid, bag, packaging, sign) at the right size, with blending and perspective, then produces a check zoom. Use whenever an AI-generated visual shows a logo (the AI always redraws it): first generate the surface WITHOUT logo or text, then place the logo with this skill.
---

# Place logo

Image generators always redraw logos. So the prompt asks for a surface **without logo or text**; the real logo is placed afterwards.

## Steps
1. Find the logo files (brand folder in memory/ or the user's assets): white on dark backgrounds, black on light ones.
2. Locate the 4 corners of the target area (pixels, in order: top-left, top-right, bottom-right, bottom-left). Open the visual (Read) to estimate; if needed draw a grid with Pillow. Respect the logo's aspect ratio.
3. Run:
   `python3 .claude/skills/place-logo/place_logo.py visual.png logo.png output.png x1,y1 x2,y2 x3,y3 x4,y4 --opacity 0.9 --blur 0.6`
   Flat visual (front view): 4 corners = rectangle. Lid in perspective: corners of the trapezoid.
4. Open `output_zoom.png` (×2 zoom) and check: sharp logo, centred, right way up, no overflow. Fix the corners and rerun if needed. Attach the zoom as proof.
5. If the background under the logo is not uniform (reflection, grain), lower the opacity (0.8) or raise the blur (1.0).

Limit: the script does not recreate shadows or embossing; for an engraved effect, tell the user it is a flat overlay.
