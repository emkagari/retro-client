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

## What code draws

Most of an interface is **components** — `Button`, `Label`, `Window`,
`Container`, `TextArea`… (ank's gapi, `src/classes/ank/gapi/controls/`). In
the loader a component is only a transparent box (`boundingBox_mc`) and
its parameters, its clip actions (`frame_1/PlaceObject2_48_Button_95/…
on(construct).as`: `backgroundUp = "BtnChooseServerUp"`, `styleName`…):
its class draws it in the game. **Components** (on by default) draws them
as that code would, from the same parameters and styles
(`DofusStylePackage`): a button's background stretched to its size and
coloured by its style, its label and icon; a label's text in its font,
size, colour and alignment; a window's frame and title; a loader's
content; a grid's cells… Its size is its box's on screen, as the game
measures it. Off: what the files hold.

- **Texts** the class puts in them
  (`this._btnSelect.label = this.api.lang.getText("SELECT")`) show as
  their key, `‹SELECT›` — or as the player reads them, «Sélectionner»,
  with the game's texts: a server's `lang_fr_….swf`, given as `lang` in
  `retro.local.json` (or `--lang <file>`, `RETRO_LANG`). The layers show
  them too. An empty text the code fills otherwise shows the instance's
  name, dimmed (`‹_lblLevel›`).
- **Hidden by code**: what the class hides as it starts
  (`this._mcPlacer._visible = false` in `createChildren` or `init`: a
  placer marking where code attaches something, a panel shown later) is
  drawn faded, ⊘ in the layers.
- **Outlines** (`O`): every line's box and name over the drawing — the
  first level's, and those next to a nested line selected.

It's an approximation: no hover or pressed states, scrollbars, list
contents, or what code attaches at runtime (`attachMovie`); a lang file's
texts keep their `%1`.

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
  move it; arrows nudge it by a pixel (`Shift`: 10). **Inside a placed
  sprite**: double-click goes one level deeper under the pointer (again:
  deeper still), `Ctrl+click` straight to the deepest line there (and drags
  it), `Escape` one level up. A component showing only its `boundingBox_mc`
  (a TextArea, a Label: the game hides it at once) lets clicks through to
  what's under it. **Drag anything from
  the left onto it** to place it (over everything; the drawing's centre
  where it falls).
- **Right**: the layers — the sprite's own display list, top first, its
  depths and instance names as in the SWF. A placed sprite or button
  unfolds (▸) into what it holds: that's its definition, shared by every
  placement (`ChooseServerSprite`, placed 5 times, is one sprite).
  Click a line inside to select it **in place**: its box shows where it is
  on screen; drag it (inside its box), nudge it, remove it, edit it in the
  inspector — that edits the definition, so every placement changes (its tab
  appears, ●, written when saved; `Ctrl+Z` here takes it back). Double-click
  opens the definition in its own tab. ↑ ↓ swap
  depths, ✕ removes, 👁 hides a line while you work — at any level, in that
  instance only (hiding `Bonhomme` in `_css4` leaves the 4 others); not saved. The
  inspector: depth, position, scale, rotation, alpha, instance name
  (`this._btnOk` in the class), a button record's states, and the line's
  JSON — applied as you type, as soon as it parses (undo takes it back).
- **Hierarchy**: drag a layer onto another, **at any level of the tree** —
  its top or bottom edge puts it above or below that line, in its list (the
  depths are given out again in that order; later frames follow); its
  middle puts it **inside** a sprite (it becomes its child: drag the
  sprite, it follows) or, two first-level lines, **groups** them. A line
  inside a sprite dragged onto a first-level one comes out of it; dragged
  into another sprite, it goes there. One `Ctrl+Z` takes the whole move
  back.
  **Group** (`Ctrl+G`) wraps the selection in a new sprite,
  `src/assets/new/<this one>/group-N.json`, placed where it was;
  **Ungroup** (`Ctrl+Shift+G`) puts what a placed sprite holds in its place.
  Nothing moves on screen: positions are recomputed. Moving into or out of
  a sprite of the base changes its definition — the editor says how many
  times it's placed first; a button's records stay in their button; an instance name (`_btnOk`) moved inside another clip is
  reached by code through it (`this._group._btnOk`): the editor asks first.
  The sprites changed or created open as tabs, written when saved.
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
- Components are drawn from their parameters and styles (above), not by
  running their code: states, scrollbars, list contents aren't there.
  Filters (glow, shadow) aren't drawn.
- Editing an SVG itself: use Inkscape (docs/ASSETS.md), then Reload files.
- What code builds at runtime (`attachMovie` in a class) isn't in the
  layers: they show the files' hierarchy, not the running game's.
