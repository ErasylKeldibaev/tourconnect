# Production Notes

## Creative Upgrade

The scene is now aimed at a more finished commercial look:

- grounded asphalt base instead of a perfectly clean procedural floor;
- wet patches, dirt marks, curb lines, and imperfect parking lines;
- distant background buildings with warm windows;
- small object offsets and rotations so the city feels hand-placed;
- bevels and weighted normals for softer highlights;
- fog, night lighting, fireworks, and final branding.

## Technical Upgrade

- Collection names are ASCII and render-farm friendly.
- The main script is self-contained and does not require external assets.
- Randomness is seeded, so cloud renders stay deterministic.
- Console output is readable in English and safe for cloud logs.
- The final subtitle text is corrected to `Строим будущее сегодня`.

## Suggested Next Polish

- Replace procedural buildings with real architectural models if available.
- Add brand-specific textures for facade panels, road markings, and signage.
- Render a 10-frame preview first before a full animation render.
- For still posters, switch to Cycles with higher samples.
