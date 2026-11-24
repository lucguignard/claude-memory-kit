---
name: image-enhancer
description: Checks and improves sharpness and resolution of images (AI visuals received as .webp/.png, screenshots) before layout or PDF, with Pillow. Use before putting visuals in a PDF, a deck or a post.
---

# Image enhancer

No AI upscaler: only Pillow (Lanczos resampling + light sharpening). The gain is modest; for a blurry product photo, asking for the visual again beats fixing it.

## 1. Check (always first)
For each image: format, size, mode, weight. Compare to the intended use:
- screen / post: ≥ 1080 px wide; PDF for partners: ≥ 1600 px; print: ≈ 300 dpi at final size.
- flag any visual below the threshold, blurry, with compression artefacts or distorted text (logo, labels).
```
python3 -I -c "from PIL import Image;import sys;[print(p,Image.open(p).size,Image.open(p).mode) for p in sys.argv[1:]]" *.webp
```

## 2. Improve (if useful)
Never overwrite the original: write `<name>-sharp.png` next to it.
```
python3 -I - <<'PY'
from PIL import Image, ImageFilter
src, target_width = "input.webp", 1600
im = Image.open(src).convert("RGB")
if im.width < target_width:
    h = round(im.height * target_width / im.width)
    im = im.resize((target_width, h), Image.LANCZOS)
im = im.filter(ImageFilter.UnsharpMask(radius=1.2, percent=80, threshold=3))
im.save("input-sharp.png")
PY
```
- Upscaling: never beyond ×2 (the image turns soft).
- Sharpening: `percent` 60-100; lower it if halos or grain appear.
- Convert .webp to .png/.jpg if the layout tool does not read webp.

## 3. Verify
Look at the result (100 % crop on the detail that matters, preview ≤ 800 px wide) and say what changed. An image whose text is unreadable: flag it, do not "repair" it.

## Rules
- No retouching that changes the product (colours, shapes, logo).
- HD photos and heavy exports stay out of the memory repo.
