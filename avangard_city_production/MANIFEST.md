# Project Manifest

Use this folder as the final packaged project:

```text
avangard_city_production/
  README.md
  MANIFEST.md
  .gitignore
  render_local.bat
  config/
    render_cloud.json
  docs/
    production_notes.md
  renders/
    .gitkeep
  scripts/
    main.py
    cloud_realism_addon.py
```

Main entry point:

```text
scripts/main.py
```

Render output:

```text
renders/avangard_city_####.mp4
```

The generated `__pycache__` folder is ignored and is not part of the delivery.
