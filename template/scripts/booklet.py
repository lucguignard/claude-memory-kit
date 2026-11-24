#!/usr/bin/env python3
"""Imposes an A5 (or any size) PDF as a booklet on landscape A4, 2 pages per side, to fold.
Usage: booklet.py input.pdf output.pdf [--flip-backs] [--check]
 --flip-backs: rotates the back sides by 180° (duplex "long edge" on landscape sheets;
               without it: short edge).
 --check: also writes output.check.txt (page order on each side).
Blank pages are added to reach a multiple of 4. Needs pypdf."""
import sys
from pypdf import PdfReader, PdfWriter, PageObject, Transformation


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    opts = {a for a in sys.argv[1:] if a.startswith("--")}
    if len(args) != 2:
        sys.exit(__doc__)
    src, dst = args
    pages = list(PdfReader(src).pages)
    w0, h0 = float(pages[0].mediabox.width), float(pages[0].mediabox.height)
    n = -(-len(pages) // 4) * 4
    order = []  # (left, right, back?) ; 0-based indices
    for i in range(n // 4):
        order.append((n - 1 - 2 * i, 2 * i, False))
        order.append((2 * i + 1, n - 2 - 2 * i, True))
    out = PdfWriter()
    log = []
    for left, right, back in order:
        sheet = PageObject.create_blank_page(width=2 * w0, height=h0)
        for k, idx in enumerate((left, right)):
            if idx < len(pages):
                sheet.merge_transformed_page(pages[idx], Transformation().translate(k * w0, 0))
        if back and "--flip-backs" in opts:
            sheet.add_transformation(Transformation().rotate(180).translate(2 * w0, h0))
        out.add_page(sheet)
        lp = left + 1 if left < len(pages) else "blank"
        rp = right + 1 if right < len(pages) else "blank"
        log.append(f"{'back' if back else 'front'}: p.{lp} | p.{rp}")
    out.write(dst)
    if "--check" in opts:
        with open(dst.rsplit(".", 1)[0] + ".check.txt", "w") as fh:
            fh.write("\n".join(log) + "\n")
    print(f"{len(pages)} pages -> {len(order)} sides ({n // 4} sheets)")


if __name__ == "__main__":
    main()
