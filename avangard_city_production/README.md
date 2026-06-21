# AVANGARD CITY Production

Production-ready Blender scene package for a cinematic real estate promo.

## Files

- `scripts/main.py` - full Blender scene generator with render settings, camera animation, buildings, city details, fireworks, realism polish, and cloud-safe collection organization.
- `scripts/cloud_realism_addon.py` - standalone realism/cloud organization add-on block.
- `config/render_cloud.json` - recommended cloud/render-farm settings.
- `render_local.bat` - Windows helper for rendering from Blender in background mode.
- `renders/` - output folder for local renders.
- `docs/production_notes.md` - creative and technical notes.

## Run In Blender

1. Open Blender 4.2 or newer.
2. Go to `Scripting`.
3. Open `scripts/main.py`.
4. Press `Run Script`.
5. Render animation with `Ctrl+F12`.

## Run From Command Line

Edit `render_local.bat` if your Blender path is different, then run:

```bat
render_local.bat
```

The script creates the scene from zero, applies production polish, and writes renders to `renders/`.

## Cloud Notes

The project avoids emoji and Cyrillic in collection names for render-farm compatibility. Visible title text remains intentional: `AVANGARD CITY` and `Строим будущее сегодня`.
