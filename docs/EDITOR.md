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

- **Tabs**: each sprite, button or text opens in its own tab, with its own
  changes, undo history, selection and view. **Nothing is written until you
  save**: `Ctrl+S` saves the tab, **Save all** (`Ctrl+Shift+S`) every tab
  with changes (●). The server checks each with the build's encoder first —
  an unknown export, an id of the wrong kind… is shown, nothing is written —
  then writes it in the repo's format. A tab's unsaved changes already show
  in the others (edit a sprite, see every interface placing it change), and
  survive a reload of the page. `Ctrl+W` closes a tab, `Ctrl+PageUp/Down`
  goes from one to the next.
- **Left**: the library — `Interfaces` (the `UI_*` sprites), every sprite,
  `Ours` (`src/assets/new/`), the shapes (thumbnails), buttons, texts. Search
  by name or id; click to open; a shape's click lists where it's placed.
  Drag the panels' edges to widen them.
- **Centre**: the sprite, drawn from `src/assets/shapes/` as its sprite.json
  places them. Wheel: zoom; drag the background: pan; `F`: fit. **Screen**
  shows the game's screen, 742×556 (the map: 742×432, the banner below): an
  interface (`UI_*`, on by default) is attached at its top left, so what's
  inside is what the player sees. Click a graphic to select it, drag it to
  move it; arrows nudge it by a pixel (`Shift`: 10). **Drag anything from
  the left onto it** to place it (over everything; the drawing's centre
  where it falls).
- **Right**: the layers — the sprite's own display list, top first, its
  depths and instance names as in the SWF. A placed sprite or button
  unfolds (▸) into what it holds: that's its definition, shared by every
  placement (`ChooseServerSprite`, placed 5 times, is one sprite);
  double-click a line inside to edit it there, in its own tab. ↑ ↓ swap
  depths, ✕ removes, 👁 hides a line while you work — at any level, in that
  instance only (hiding `Bonhomme` in `_css4` leaves the 4 others); not saved. The
  inspector: depth, position, scale, rotation, alpha, instance name
  (`this._btnOk` in the class), a button record's states, and the line's
  JSON — applied as you type, as soon as it parses (undo takes it back).
- **Build** runs `tools/build.mjs` on what's saved and shows its output;
  restart the game to see it. **New sprite** opens a tab for
  `src/assets/new/<path>.json` (exported as `<path>`, docs/SPRITES.md),
  written when saved. **Reload files** reads the files again (an SVG edited
  in Inkscape), keeping unsaved changes.

## What it doesn't do (yet)

- Frames after the first are shown (`frame`), not edited: animated sprites'
  later frames are edited in their sprite.json.
- Texts are edited as JSON in the inspector; they're drawn with a system font
  (the game's are embedded in the loader), text fields as a dashed box.
- What code draws at runtime — a `Window`'s frame, a `Button`'s label, a
  component's skin — isn't there: the editor shows what the files place, as
  FFDec's renders do. Filters (glow, shadow) aren't drawn.
- Editing an SVG itself: use Inkscape (docs/ASSETS.md), then Reload files.
- What code builds at runtime (`attachMovie` in a class) isn't in the
  layers: they show the files' hierarchy, not the running game's.
