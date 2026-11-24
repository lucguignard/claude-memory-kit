#!/usr/bin/env python3
"""Place a real logo (transparent PNG) on a quadrilateral area of a visual.
Usage: place_logo.py visual logo output x1,y1 x2,y2 x3,y3 x4,y4 [--opacity 0.9] [--blur 0.6]
Corners in order: top-left, top-right, bottom-right, bottom-left (pixels of the visual).
Also writes <output>_zoom.png (x2 crop around the logo) for checking. Needs Pillow."""
import argparse, sys
from PIL import Image, ImageFilter


def point(s):
    x, y = s.split(",")
    return float(x), float(y)


def perspective_coeffs(dst, src):
    # PERSPECTIVE coefficients: for each output point (dst) -> source point (src), solved by Gauss-Jordan.
    rows, vals = [], []
    for (x, y), (u, v) in zip(dst, src):
        rows.append([x, y, 1, 0, 0, 0, -u * x, -u * y]); vals.append(u)
        rows.append([0, 0, 0, x, y, 1, -v * x, -v * y]); vals.append(v)
    n = 8
    A = [r[:] + [b] for r, b in zip(rows, vals)]
    for i in range(n):
        p = max(range(i, n), key=lambda r: abs(A[r][i])); A[i], A[p] = A[p], A[i]
        if abs(A[i][i]) < 1e-12:
            sys.exit("Invalid corners (degenerate area)")
        for r in range(n):
            if r != i:
                f = A[r][i] / A[i][i]
                A[r] = [a - f * b for a, b in zip(A[r], A[i])]
    return [A[i][n] / A[i][i] for i in range(n)]


def main():
    a = argparse.ArgumentParser()
    a.add_argument("visual"); a.add_argument("logo"); a.add_argument("output")
    a.add_argument("corners", nargs=4, type=point)
    a.add_argument("--opacity", type=float, default=0.9)
    a.add_argument("--blur", type=float, default=0.6)
    o = a.parse_args()
    base = Image.open(o.visual).convert("RGBA")
    logo = Image.open(o.logo).convert("RGBA")
    W, H = base.size; w, h = logo.size
    c = perspective_coeffs(o.corners, [(0, 0), (w, 0), (w, h), (0, h)])
    warped = logo.transform((W, H), Image.PERSPECTIVE, c, Image.BICUBIC)
    if o.blur > 0:
        warped = warped.filter(ImageFilter.GaussianBlur(o.blur))
    warped.putalpha(warped.getchannel("A").point(lambda p: int(p * o.opacity)))
    out = Image.alpha_composite(base, warped)
    out.convert("RGB").save(o.output, quality=95)
    xs = [p[0] for p in o.corners]; ys = [p[1] for p in o.corners]
    m = 0.15 * max(max(xs) - min(xs), max(ys) - min(ys))
    box = (int(max(0, min(xs) - m)), int(max(0, min(ys) - m)), int(min(W, max(xs) + m)), int(min(H, max(ys) + m)))
    z = out.crop(box).convert("RGB"); z = z.resize((z.width * 2, z.height * 2), Image.LANCZOS)
    zp = o.output.rsplit(".", 1)[0] + "_zoom.png"; z.save(zp)
    print("OK", o.output, zp)


if __name__ == "__main__":
    main()
