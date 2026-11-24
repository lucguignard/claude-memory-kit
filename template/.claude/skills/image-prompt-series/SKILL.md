---
name: image-prompt-series
description: Writes a series of consistent image prompts (same style base, same format) for one or several products. Use when the user asks for image prompts, a series of AI visuals or variants for an image generator.
argument-hint: "<product(s) or reference(s)> [number of variants]"
---

# Image prompt series

Requested product(s): $ARGUMENTS

## Method
1. If the product has a note in memory/, take colours, materials and shapes from it; invent nothing.
2. For each product, write ONE prompt: `[precise subject], [staging], ` + STYLE BASE (identical word for word).
3. Return a table: product | full prompt | format. Prompts in English, surrounding text in the user's language.
4. If the user asks, generate with the connected image tool, keeping the style base unchanged.
5. Ask for surfaces **without logo or text**: generators always redraw logos. Place the real logo afterwards with `place-logo`.

## STYLE BASE (default — have the user validate it, then save their version here)
soft diffused studio light, clean neutral light-grey background, product centered, macro 3/4 angle, shallow depth of field, sharp details, realistic reflections, high-end catalogue photography, no text, no logo, 4:5 vertical

## Rules
- Never change the style base of a running series; a style variant = a new series.
