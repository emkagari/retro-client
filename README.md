# retro-client

The Dofus Retro client as readable ActionScript 2 sources, a build that turns
them back into the client's `loader.swf`, and packaging into the official
Electron app, for Linux, Windows and macOS. The client version in use is set in
`retro.json`.

## Layout

| path | content |
|---|---|
| `src/` | the sources, decompiled from the base: `classes/` (the AS2 classes) and `timeline/` (scripts attached to the SWF's timelines). **Changes go here.** |
| `base/<version>/` | `loader.swf`: the deobfuscated official loader the sources come from (code cleaned, names recovered); `manifest.json`: the hash of every source as exported, and of the official loader it was made from; `names/`: the names used to deobfuscate, reused for the next version. |
| `tools/build.mjs` | `src/` → `build/loader.swf` |
| `tools/package.mjs` | official client + `build/loader.swf` + `overlay/` → `dist/<platform>/`; `--run` starts it |
| `tools/manifest.mjs` | records `src/` as the new baseline of a base |
| `tools/deob/` | the deobfuscation toolkit, used to port a newer client ([docs/UPGRADING.md](docs/UPGRADING.md)) |
| `.claude/skills/swf-deobfuscate/` | the same procedure as a Claude Code skill, for deobfuscating or upgrading from this repository (paths are read from `retro.local.json`) |
| `overlay/` | files copied over the client when packaging, with the client folder's layout |
| `retro.json` | the client version in use |
| `retro.local.json` | machine-specific paths and settings (not in git) |

## Requirements

**With Docker** (Linux, macOS or Windows, nothing else to install): the
`retro` / `retro.cmd` scripts run every tool in an image holding Node, Java
and FFDec, built on first use. The game itself runs on the host.
On macOS, Docker Desktop shares only some folders with its containers:
add `/Applications` (Settings → Resources → File sharing) if the official
client is still there.

```bash
./retro build        # Windows: retro build
./retro play         # build, package from the official client, start the game
./retro dev          # the same, with hot reload and auto login
./retro help
```

`retro.local.json` (see [Configuration](#configuration)) is still needed for
`upstream` and `dev`; `ffdec` is not.

**Without Docker**:

- **Node 24**: runs the tools and the toolkit's TypeScript directly, no
  `npm install`.
- **Java 11+** and **FFDec** (JPEXS Free Flash Decompiler, 26 or later), which
  compiles the ActionScript. On Windows, `ffdec-cli.exe` works too.
- **The official Dofus Retro client** for the platform, installed by Ankama's
  launcher: the build reuses its Electron app, Flash plugin and assets. Its
  files are the same on every platform, the official `loader.swf` included;
  on macOS they're inside the app, `Dofus Retro.app/Contents/Resources/`
  instead of `resources/` (the tools map one to the other).

## Configuration

Copy `retro.local.example.json` to `retro.local.json` and set:

| key | |
|---|---|
| `ffdec` | path to `ffdec.jar` (not needed with Docker) |
| `upstream.linux` / `upstream.windows` | the official client's folder, the one holding `resources/app/retroclient` |
| `upstream.mac` | the official app, `/Applications/Ankama/Retro/Dofus Retro.app` by default (or the folder holding it) |
| `overlay` | optional: a folder of machine-specific files copied after `overlay/`, e.g. a `config.xml` pointing at another server |
| `executable` | optional: the client executable's name |
| `dev` | optional: auto login settings, see [Hot reload](#hot-reload) |

## Building and running

```bash
node tools/build.mjs                 # src/ → build/loader.swf
node tools/package.mjs --run         # build, copy into dist/<platform>/, start the game
```

The build compiles **only the files that differ from the base** into a copy
of the base loader; everything else keeps the base's bytecode exactly. A
change therefore touches only the edited classes, and a compile error points
at the source file: `Missing operand on line 74, file: src/classes/…`.
`--full` compiles every file; it works, but the decompiled `_locN_` locals
become named variables, so it is slower and meant for tests.

Two checks keep a recompiled class equivalent to the original:

- `_root` is compiled by name (`eval("_root")` in the staged copy; `src/` is
  not modified). FFDec would otherwise read it from a preloaded register,
  which in the loader (loaded by `preloader.swf`) is the preloader's root,
  and the client would stop at startup. The build refuses any function that
  still preloads `_root`.
- Every `get x()` / `set x()` must still match its property, since the
  compiler registers properties from accessor names.

`dist/<platform>/` is a full copy of the official client (on macOS the app,
`dist/mac/Dofus Retro.app`), made once; later
runs only replace the loader and the overlay files. Ankama's launcher must not
update it: start it with `--run` or its executable, not through the launcher.

## Hot reload

```bash
node tools/dev.mjs                   # build with hot reload, start the game, watch src/
```

When a class is saved, the running game picks up the new code within a second
or two and prints `hot reload: <class>` in the chat, with no restart and no
login. The new code is copied into the existing class, so objects already
created use it:

| change | applied live |
|---|---|
| method / `get` / `set` bodies, static functions, a new method or class | yes |
| static constants with UPPER_CASE names (`WIDTH`, `CLASS_NAME`) | yes |
| an interface's layout (`createChildren`…) | yes, once the interface is reopened |
| other static values (`_instance`, counters: the game's state) | no, kept on purpose |
| a function already handed out (`addToQueue`, `setInterval`, `onRelease = function…`) | not until its owner is recreated |
| a field's initial value, for objects already created | no (new objects get it) |
| startup code (`DofusCore`…), `src/timeline/`, `src/symbols.json` | no: restart the game |

The loader is rebuilt after each change, so changes survive a restart.

**Auto login**: with `"dev": { "login": "…", "password": "…", "server": 2,
"character": "…" }` in `retro.local.json`, the game started by `dev.mjs` logs
in, selects the server and enters the world on its own. `server` and
`character` are optional (the first one is used by default); `--no-login`
disables auto login. The credentials stay local: `retro.local.json` and
`dist/` are not in git. Hot reload and auto login live in `tools/dev/` and are
included only by `build.mjs --dev`, never in a normal build or package.

## Writing code

- Classes are AS2 (`class dofus.datacenter.Item extends Object { … }`), one per
  file under `src/classes/`, path = package
  (`src/classes/dofus/datacenter/Item.as`).
- `src/timeline/` holds the code attached to the SWF's graphics:
  - `main/frame_1/DoAction.as`: the main timeline's script;
  - `init/<Name>.as`: `Object.registerClass("<Name>", …)`, which class a
    library symbol (a button, a window…) uses;
  - `sprites/<id>[_<name>]/frame_<n>/`: a movie clip's scripts, `DoAction.as`
    (frame script) and `PlaceObject2_<char>_<Class>_<depth>/…as` (an
    instance's `on(construct)` / `onClipEvent` code: a component's initial
    settings, e.g. a label's text style);
  - `buttons/<id>/`: a button's `on(release)`… handlers.

  Folder and file names there must not change: they identify the SWF object
  the code belongs to (the build maps them to FFDec's layout, see
  `tools/lib.mjs`).
- The decompiled style stays: `_loc3_` locals, `return undefined;`. Rename
  locals in rewritten code only; leaving untouched code as is keeps diffs
  small and easier to review and port.
- New classes go under `src/classes/`. Deleting a file cannot remove code from
  the base (the build warns).
- Names ending in `_` (`enabled_`, `api_`) are recovered names that clashed
  with a name already used in the code. They are intentional, not typos.

## Further documentation

- [docs/NEW-UI.md](docs/NEW-UI.md): adding an interface (examples on the
  `example/*` branches)
- [docs/ASSETS.md](docs/ASSETS.md): graphics, every shape and image as SVG /
  PNG in `src/assets/`
- [docs/SPRITES.md](docs/SPRITES.md): sprites, buttons and texts as JSON
- [docs/RELEASES.md](docs/RELEASES.md): CI builds and releases
- [docs/WORKFLOW.md](docs/WORKFLOW.md): branches, reviews, the `upstream` branch
- [docs/UPGRADING.md](docs/UPGRADING.md): moving to a newer official client
