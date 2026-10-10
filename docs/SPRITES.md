# Sprites, buttons, texts

A sprite (a window, a panel, an icon…) is a clip: on each of its frames, it
places shapes, texts and other sprites, at a depth, a position, a scale. Where
a graphic shows on screen isn't in the code: it's there. Each sprite of the
loader has it as a file, next to its frame scripts:

```
src/timeline/sprites/969_UI_Login/sprite.json
src/timeline/sprites/969_UI_Login/frame_1/…     its scripts, as before
```

(the folder is `<id>` or `<id>_<export name>`; `__Packages.*` clips are the
classes', in `src/classes/`).

## What a sprite.json holds

```json
{
 "frames": [
  {
    "place": [
      { "depth": 225, "shape": 901, "x": 341.4, "y": 234.2, "scale": 0.59999 },
      { "depth": 18, "export": "UI_LoginAdvencedBack", "x": 72.7, "y": 281, "name": "_mcAdvancedBackground" }
    ]
  },
  { "label": "open", "remove": [7], "place": [{ "depth": 3, "move": true, "x": 120 }] }
 ]
}
```

A frame: what it `remove`s (depths), its `label` (`gotoAndPlay("open")`),
and what it `place`s — one per line:

| key | |
|---|---|
| `depth` | its layer: a higher depth is drawn over a lower one (1 to 65535) |
| `shape`, `sprite`, `text`, `button`, `morph`, `video` | what it places, by its id in the base (`shapes/<id>.svg` for a shape) |
| `export` | what it places, by export name: a symbol of the base (`"Button"`) or ours (`"panneau/fond"`, docs/ASSETS.md) |
| `move` | `true`: changes what is at that depth already (an animation's next frame) |
| `name` | its instance name: the class reaches it as `this._mcBanner` |
| `x`, `y` | its position, in pixels (in 1/20 px steps) |
| `scale` / `scaleX`, `scaleY`, `rotation` | its size (1: as drawn) and angle (degrees) |
| `matrix` | `[a, b, c, d]` instead, for a skewed one |
| `alpha` / `color` | transparency (0 to 1) / a colour transform `{ "mult": [r, g, b, a], "add": [r, g, b, a] }` |
| `mask` | it masks what's above it, up to that depth |
| `ratio` | a morph's progress (0 to 65535) |
| `filters`, `blend` | `dropShadow`, `blur`, `glow`, `bevel`, `colorMatrix`; `multiply`, `screen`, `add`… |
| `actions` | `true`: clip actions, compiled from `frame_N/PlaceObject2_….as` (leave it) |

Numbers are exact: `0.59999` is the scale Ankama's tool stored (39321/65536),
written with the digits that give it back.

## Moving, resizing, adding

Where is a graphic placed?

```bash
node tools/sprites.mjs where 901          # or shapes/901, or an export name (buttons showing it too)
# shape 901: placed 1 time
#   src/timeline/sprites/969_UI_Login/sprite.json  frame 1, depth 225: {"shape":901,"x":341.4,"y":234.2,"scale":0.59999}
```

Edit that line — `"x": 391.4` moves the logo 50 px right; `"scale": 0.8`
makes it bigger — and build (`node tools/build.mjs`, or `dev.mjs`); restart
the game to see it. Only the sprite.json that differ from the base
(`base/<version>/manifest.json`, `sprites`) are re-encoded, and in them only
the lines you changed: everything else keeps the base's bytes.

Add a line to place something more — a graphic of ours included:

```json
{ "depth": 226, "export": "login/badge", "x": 600, "y": 120 },
```

(`src/assets/new/login/badge.svg`, docs/ASSETS.md). Pick a free depth; its
place among the others decides what it's drawn over.

Remove a line and it's gone. A placement with `"actions": true` or a `name`
may be used by code (`this._mcBanner`): look for it in the class first.

## A new sprite

Put it in `src/assets/new/`, like a new graphic: `new/panneau/fenetre.json`,
the same format, is exported as `panneau/fenetre` (the path, in lower case).
It may place graphics of ours, the base's shapes and symbols, other new
sprites:

```json
{
 "frames": [
  {
    "place": [
      { "depth": 1, "export": "panneau/fond", "x": 0, "y": 0 },
      { "depth": 2, "export": "Button", "x": 100, "y": 160, "name": "_btnClose" }
    ]
  }
 ]
}
```

From code: `attachMovie("panneau/fenetre", "_mcWindow", 10)`. A new sprite
has no frame scripts: give it a class (`Object.registerClass`, docs/NEW-UI.md).
`new/panneau/fenetre.json` and `new/panneau/fenetre.svg` would both be
`panneau/fenetre`: the build refuses them.

What the build refuses, and says where: an unknown key (`"scal"`), an id of
another kind (`"shape": 969`), an export that doesn't exist, two things placed
on one line, sprites placing each other in a loop.

## Texts

Every text of the loader is a file too, `src/timeline/texts/<id>.json` (its
id is what a sprite places: `"text": 878`).

A **text field** (dynamic, input or HTML — 92 of them) holds its box and its
settings, under the AS2 TextField's names:

```json
{
 "x": -2, "y": -2, "width": 94.35, "height": 16.05,
 "variable": "…", "text": "…",
 "font": 6, "size": 10, "color": "#514a3c",
 "align": "right", "marginLeft": 0, "marginRight": 0, "indent": 0, "leading": 2,
 "maxLength": 9, "wordWrap": true, "multiline": true, "password": true,
 "readOnly": true, "autoSize": true, "selectable": false, "border": true,
 "html": true, "embedFonts": true
}
```

(only what the field has is written: most have no `text` — the code fills
them). `font` is a font's id in the loader.

A **static text** (5 of them, like the login's "News") holds its runs: font,
size, colour, offset, the characters and each one's width:

```json
{ "font": 6, "size": 10, "color": "#ffffff", "y": 10, "text": "News", "advances": [8.45, 6.65, 9.8, 5.95] }
```

Change `text` and give one width per character (`advances`, in pixels): the
fonts embed only the characters they need — one the font lacks is refused,
with the list of those it has.

## Buttons

`src/timeline/buttons/<folder>/button.json`, next to its scripts (its
actions, `BUTTONCONDACTION on(…).as`):

```json
{
 "records": [
  { "depth": 1, "states": ["up", "over", "down", "hit"], "shape": 124, "x": 0, "y": 0 },
  { "depth": 2, "states": ["over"], "shape": 126, "x": 0, "y": 0, "alpha": 0.5 }
 ],
 "actions": true
}
```

Each record shows something in some of its states — `up`, `over` (hovered),
`down` (pressed) — or makes `hit` the area that reacts. A record takes the
same keys as a placement (position, scale, colour, filters, blend).

## A new base

`tools/new-base.mjs` extracts the new base's sprites, buttons and texts and
carries yours over: each edited one is found in the new base by what it
holds (ids change between versions) or by its export name, its ids are mapped to the new
base's, and your edits are merged into Ankama's version (`git merge-file`).
Both changing the same line: a conflict to resolve (`<<<<<<<` markers); a
sprite Ankama removed or changed beyond recognition is listed, kept in
`.tmp/sprites-kept/`.

## Tests

`./retro test-sprites` (or `node tools/test-sprites.mjs`, a few seconds):
one JSON per sprite, button and text as extracted from the base; every one
re-encoded to its exact bytes; nothing edited keeps the loader's bytes; a
moved placement changes only its line; new sprites are exported, defined
before use and drawn; texts and buttons edited; mistakes are refused; an
edit is carried over to a base whose ids changed.

`node tools/sprites.mjs extract` re-extracts the current base's sprites,
buttons and texts (it overwrites every one).
