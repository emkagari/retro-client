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
- **Parameters**: a component selected, the inspector lists its
  parameters (`title`, `styleName`, `label`, `backgroundUp`,
  `contentPath`…) — change one, it's drawn at once; **+ parameter** adds
  one this component takes in the base's interfaces, with its usual value
  (styles and exports offered as you type). A base sprite's line keeps
  them in its script: saving rewrites
  `frame_N/PlaceObject…/on(construct).as` (only the lines changed; the
  build recompiles it). Any other line — in a new sprite, or placed in a
  base sprite from the library — keeps them in its `"params"`, compiled
  into its clip actions by the build (docs/SPRITES.md).
- **Outlines** (`O`): every line's box and name over the drawing — the
  first level's, and those next to a nested line selected.
- **Masks**: a mask line (`"mask": 36` in its JSON: `mask: shape 883 ◩
  29–36` in the layers) isn't drawn — the lines above it, up to that depth,
  show only inside its shape, whatever its colours (UI_Login's banner, cut
  by shape 883's rounded corner). Two toggles, independent: **Masks**
  applies them as the game does (off: what they mask is drawn whole);
  **Mask shapes** (`M`) shows each mask's shape where it is, pink, over what
  it masks. A masked line has a pink edge in the layers; a mask selected
  shows its shape and box (drag it, nudge it like any line); 👁 on a mask:
  what it masks is drawn whole while you work. Change its shape in its SVG
  (`src/assets/shapes/883.svg`), what it covers in its `"mask"`. Masks
  nest, as in the game: a mask among what another masks (UI_Login's banner
  under 883 and its mirror) — what's inside both shows where both shapes
  meet.

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
  shows the game's screen, 742×556 (the map: 742×432, the banner below),
  black as in the game: an interface (`UI_*`, on by default) is attached at
  its top left, so what's inside is what the player sees. Click a graphic to select it, drag it to
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
  inspector: depth (applied on Enter; a depth another line holds is
  refused), position, scale, rotation, alpha, instance name
  (`this._btnOk` in the class), a button record's states, and the line's
  JSON — applied as you type, as soon as it parses (undo takes it back).
- **Snap** (on by default): dragging on the canvas, the selection's box —
  its edges and centre — snaps to what's within 6 px on screen: the game
  screen's edges, centre and map line (Screen on), the lines of its list
  and the line holding it. Within reach, the screen first, then what holds
  it, then a named line, then any other. A guide shows where, the line
  aligned on (its dashed box) and its name and edge (`_btnOK · centre`).
  Hold `Ctrl` while dragging: no snapping (Photoshop's key); `Shift`: only
  horizontally or vertically. **Grid** (`G`, its size beside it): drawn
  faintly over the drawing; with Snap, the box's top left goes to it where
  no guide is in reach. The arrows aren't snapped (a pixel is a pixel).
- **Several at once**: `Ctrl+click` a layer to add it to the selection (or
  take it out), `Shift+click` for the lines between it and the one selected,
  in one list; on the canvas `Shift+click` adds a graphic (`Shift+Ctrl`: the
  deepest line there); `Ctrl+A` selects every line of the list the selected
  one is in. Lines of any level mix: dragging one of them on the canvas, the
  arrows, `Del` act on all of them (each moved in its own parent's
  coordinates, one `Ctrl+Z`), and dragging one of their rows in the layers
  carries them all — above, below or into a line, side by side in their
  order. `Ctrl+G` groups them (first-level lines). The inspector shows the
  last one picked; `Escape` keeps it alone.
- **Hierarchy**: drag a layer onto another, **at any level of the tree** —
  its top or bottom edge puts it above or below that line, in its list
  (it takes a free depth between them; with none free, the fewest lines
  move up or down by one — later frames follow, a mask keeps masking what
  it masked); its
  middle puts it **inside** a sprite (it becomes its child: drag the
  sprite, it follows) or, two first-level lines, **groups** them. A line
  inside a sprite dragged onto a first-level one comes out of it; dragged
  into another sprite, it goes there. One `Ctrl+Z` takes the whole move
  back.
  **Group** (`Ctrl+G`) wraps the selection in a new sprite,
  `src/assets/new/<this one>/group-N.json`, placed where it was (written
  with the sprite placing it, even with `Ctrl+S`);
  **Ungroup** (`Ctrl+Shift+G`) puts what a placed sprite holds in its place.
  Nothing moves on screen: positions are recomputed. Moving into or out of
  a sprite of the base changes its definition — the editor says how many
  times it's placed first; a button's records stay in their button.
  **Code**: an instance name the sprite's class uses (`this._tiAccount` in
  `Login`) isn't where the class looks once moved into another clip — the
  editor asks first, naming them: in the game, what the class does with
  them (texts, events, values) is lost until the class changes. Group what
  only shows (a logo's shapes), not what code drives (fields, buttons). A
  line's clip actions are its sprite's scripts and stay there: what they
  set (`on(construct)`: `styleName`, `maxChars`…) goes along as its
  `"params"`, compiled the same; one whose clip actions do more
  (`onClipEvent`, code) doesn't leave its sprite.
  The sprites changed or created open as tabs, written when saved.
- **Build** runs `tools/build.mjs` on what's saved and shows its output;
  restart the game to see it. **New sprite** opens a tab for
  `src/assets/new/<path>.json` (exported as `<path>`, docs/SPRITES.md),
  written when saved. **Reload files** reads the files again (an SVG edited
  in Inkscape), keeping unsaved changes.

**Depths and clip actions.** One depth holds one thing: two lines at the
same depth, the game shows the first and ignores the other — the layers
show it red, and it isn't saved so (the build refuses it too). A line
with clip actions (`"actions": true`, its script in
`frame_N/PlaceObject2_<id>_<name>_<depth>/`) keeps them when it moves to
another depth: saving renames that folder with it, and the build matches
the clip by its instance name, then its depth, or what it places. A
removed line's folder stays; when another line's lands on its name, it's
put aside in `.tmp/editor-removed/` (the build drops a removed line's
clip actions with it). The renames are all or nothing: one failing, none
is done and nothing is written.

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
