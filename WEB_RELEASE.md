# Shadow Run — Web release

The project is configured for Godot Web export using the **Compatibility** renderer and a **non-threaded** web build. The export target is:

`docs/index.html`

This makes the generated build easy to publish with GitHub Pages from the repository's `docs/` folder.

## First local export

1. Open the project in the same Godot 4.7.x editor used for development.
2. Open **Editor → Manage Export Templates** and install the Web export templates if Godot says they are missing.
3. Open **Project → Export**.
4. Select **Web**.
5. Keep **Thread Support disabled**.
6. Click **Export Project**. The preset already points to `docs/index.html`.
7. Test the exported game through a web server, not by double-clicking `index.html`.

## Publish with GitHub Pages

After the export creates the `docs/` folder:

```bash
git add docs
git commit -m "Publish Shadow Run web build"
git push
```

Then in GitHub:

**Repository → Settings → Pages → Build and deployment → Deploy from a branch**

Choose:

- Branch: `main`
- Folder: `/docs`

Save. GitHub will show the public Pages URL after deployment.

## Publish on itch.io

Export the same Web preset, then zip **the contents of the `docs/` folder** so `index.html` is at the root of the ZIP. On itch.io create an HTML game, upload the ZIP, and choose **This file will be played in the browser**.

## Release checks

Before sharing the link, test:

- menu, Story, Memories, Characters and Level Select
- Levels 1–6
- audio after the first user interaction
- save/progression after a page refresh
- fullscreen/window resizing
- Safari and Chrome if possible

The web preset intentionally has thread support disabled so it works on ordinary HTTPS hosting such as GitHub Pages without special cross-origin isolation headers.
