# Graphics

The loader's graphics live in `src/assets/` as plain files, like its code:

| | |
|---|---|
| `shapes/<id>.svg` | every vector shape of the base loader (windows, buttons, icons…) |
| `images/<id>.png` | every bitmap (`.jpg` / `.gif` when the base has them so) |
| `new/<Name>.svg` / `.png` | a graphic of ours, exported by its path in lower case: `new/ui/<Name>.svg` → `ui/<name>` |
| `index.json` | for each shape / image: the exported symbols showing it |

## Editing a graphic

1. Find it: `index.json` lists, for each file, the symbols it appears in
   (`"shapes/913": ["CautionIcon", "UI_ChooseCharacter", …]`) — search it for
   the window or icon you want. FFDec (open `base/<version>/loader.swf`)
   shows the same ids.
2. Edit the file: an SVG in Inkscape, Illustrator or a text editor, a PNG in
   any image editor. Keep its name.
3. `node tools/build.mjs` (or let `node tools/dev.mjs` rebuild it): the
   graphic is in `build/loader.swf`, and in what `package`, `release` and the
   CI make from it. Restart the game to see it — graphics aren't hot reloaded.
4. `node tools/assets.mjs diff` renders each edited shape before and after in
   `.tmp/assets-diff/`: look at it before committing.

Only files that differ from the base (`base/<version>/manifest.json`) are
re-imported: every untouched graphic keeps the base's bytes exactly. An edited
SVG keeps its size (`width` / `height`) and its origin (the `translate` of its
first `<g>`): draw bigger and the shape is bigger.

What FFDec's SVG import may get wrong — the diff shows it: a radial gradient
with a mirrored transform or two stops at the same offset (1 shape in a
sample of 78 came back different). Fix it in the SVG (one stop per offset)
or keep that shape's original colours.

## A new graphic

Put `src/assets/new/MyIcon.svg` (with `width` and `height`, or a `viewBox`)
or `src/assets/new/MyIcon.png`: the build adds a shape (for a PNG: the image
and a rectangle showing it at 1:1), a clip showing it, and exports the clip
by its path in `new/`, without the extension, **in lower case**: `myicon`.
In folders (any depth), with its slashes: `new/ui/panel/Background.svg` is
exported as `ui/panel/background`.
From code:

```actionscript
this.attachMovie("myicon", "_mcIcon", this.getNextHighestDepth(), {_x: 10, _y: 10});
this.attachMovie("ui/panel/background", "_mcBg", 10);
```

The file is spelled as you like, the code always writes the name in lower
case (`attachMovie` is case sensitive: `"ui/panel/Background"` draws nothing).
A slash can't be in a file name, so two folders never give the same name
(`ui_panel` would: `new/ui/panel.svg` and `new/ui_panel.svg`); two files
differing only by case (`Icon.svg`, `icon.svg`) are refused by the build. A
path holds letters, digits, `_` and `-` only: the build refuses
`Icon (copy).svg`. Moving or renaming a file renames its export — and an
`attachMovie` of a name that doesn't exist draws nothing, silently.

A bitmap goes as a `.png`, not inside an SVG: FFDec imports an SVG `<image>`
only partly. An animation or a clip with several layers is beyond this: a SWF of its own
in `overlay/…/clips/` (loaded like the ornaments), or built by code.

## Tests

`./retro test-assets` (or `node tools/test-assets.mjs`, ~1 min) checks the
chain base loader → `src/assets/` → final loader: the files are the base's,
nothing edited keeps the base's bytes, one edited shape changes only its tag,
a bigger drawing gets bigger bounds, new graphics are exported and drawn as
given, and every shape and image re-imported renders as before.

What the round trip doesn't bring back identical is recorded in
`tools/test-assets.json`: the test fails when a graphic comes back worse than
recorded (an FFDec update, a change to tools/assets.mjs). Renders of what
differs: `.tmp/assets-test/diff/`. After a new base: `--update` records its
round trip.

## Upgrades

`tools/new-base.mjs` extracts the new base's graphics. A graphic edited for
the previous base is found in the new one by its original content (ids
change: 17 of 1 126 between 1.49.5 and 1.49.6) and its edit carried over;
`new/` is kept. One Ankama changed or removed is listed: redo it from
`.tmp/assets-kept/`.

`node tools/assets.mjs extract` re-extracts the current base's graphics
(it overwrites `src/assets/shapes` and `images`).
