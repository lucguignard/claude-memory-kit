#!/usr/bin/env python3
# Checks a .pptx without LibreOffice: shapes overflowing the slide, overlapping text boxes,
# text probably too long for its box (estimate). Usage: python3 scripts/pptx-check.py file.pptx
import sys
try:
    from pptx import Presentation
except ImportError:
    sys.exit("python-pptx missing: pip install --user python-pptx")
if len(sys.argv) != 2:
    sys.exit("Usage: pptx-check.py file.pptx")
p = Presentation(sys.argv[1])
W, H = p.slide_width, p.slide_height
n = 0


def say(i, m):
    global n
    n += 1
    print(f"slide {i}: {m}")


for i, s in enumerate(p.slides, 1):
    boxes = []
    for sh in s.shapes:
        if sh.left is None or sh.width is None:
            continue
        l, t, r, b = sh.left, sh.top, sh.left + sh.width, sh.top + sh.height
        name = sh.name
        if l < -5000 or t < -5000 or r > W + 5000 or b > H + 5000:
            say(i, f"'{name}' overflows the slide")
        if sh.has_text_frame and sh.text_frame.text.strip():
            txt = sh.text_frame.text
            size = None
            for para in sh.text_frame.paragraphs:
                for run in para.runs:
                    if run.font.size:
                        size = run.font.size.pt
                        break
                if size:
                    break
            size = size or 18
            wpt, hpt = sh.width / 12700, sh.height / 12700
            cpl = max(1, wpt / (size * 0.5))
            lines = sum(max(1, -(-len(x) // int(cpl))) for x in txt.split("\n"))
            if lines * size * 1.2 > hpt * 1.05 and not sh.text_frame.auto_size:
                say(i, f"'{name}': text probably too long for its box ({lines} estimated lines at {size:.0f} pt)")
            boxes.append((name, l, t, r, b))
    for a in range(len(boxes)):
        for c in range(a + 1, len(boxes)):
            x, y = boxes[a], boxes[c]
            ox = min(x[3], y[3]) - max(x[1], y[1])
            oy = min(x[4], y[4]) - max(x[2], y[2])
            if ox > 50000 and oy > 50000:
                say(i, f"'{x[0]}' and '{y[0]}' overlap (text boxes)")
print("OK: nothing to report" if n == 0 else f"{n} point(s) to check (estimate, not a real rendering)")
