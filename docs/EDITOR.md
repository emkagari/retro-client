# Sprite editor (proof of concept)

A page in the browser to edit the sprites, buttons and texts of
docs/SPRITES.md with the mouse — over the repo's own files: what it saves is
the same `sprite.json` you'd write by hand, checked by the build's encoder.

```bash
./retro editor                      # Windows: retro editor
# or, with Node: node tools/editor/editor.mjs [--port 4777]
```

then open <http://localhost:4777>. Nothing to install: three files in
`tools/editor/` (the server, `index.html`, `editor.js`), no framework, no
build step.

## Using it

- **Left**: the library — `Interfaces` (the `UI_*` sprites), every sprite,
  `Ours` (`src/assets/new/`), the shapes (thumbnails), buttons, texts. Search
  by name or id; click to open; a shape's click lists where it's placed.
- **Centre**: the sprite, drawn from `src/assets/shapes/` as its sprite.json
  places them. Wheel: zoom; drag the background: pan; `F`: fit.
  Click a graphic to select it, drag it to move it; arrows nudge it by a
  pixel (`Shift`: 10). **Drag anything from the left onto it** to place it
  (over everything; the drawing's centre where it falls).
- **Right**: the layers, top first — ↑ ↓ swap depths, ✕ removes, 👁 hides
  one while you work (not saved); the inspector — depth, position, scale,
  rotation, alpha, instance name (`this._btnOk` in the class), a button
  record's states, or the line's JSON itself. `Open it` goes into a placed
  sprite (← comes back).
- **Save** (`Ctrl+S`): the server checks the JSON with the build's encoder —
  an unknown export, an id of the wrong kind… is shown, nothing is written —
  then writes it in the repo's format (a placement per line). **Undo** /
  **redo**: `Ctrl+Z` / `Ctrl+Y`.
- **Build** runs `tools/build.mjs` and shows its output; restart the game to
  see the result. **New sprite** creates `src/assets/new/<path>.json`
  (exported as `<path>`, docs/SPRITES.md).

## What it doesn't do (yet)

- Frames after the first are shown (`frame`), not edited: animated sprites'
  later frames are edited in their sprite.json.
- Texts are edited as JSON in the inspector; they're drawn with a system font
  (the game's are embedded in the loader), text fields as a dashed box.
- What code draws at runtime — a `Window`'s frame, a `Button`'s label, a
  component's skin — isn't there: the editor shows what the files place, as
  FFDec's renders do. Filters (glow, shadow) aren't drawn.
- Editing an SVG itself: use Inkscape (docs/ASSETS.md); the editor shows it
  once saved (reload the page).
