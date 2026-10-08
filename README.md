# retro-client

The Dofus Retro client (1.49.5) as readable ActionScript 2 sources, a build
that turns them back into the client's `loader.swf`, and packaging into the
official Electron app — for Linux and Windows.

> The code is Ankama's. Keep this repository **private**, and play the result
> only on your own servers: a modified client breaks Ankama's terms.

## Layout

| path | what |
|---|---|
| `src/` | the sources, decompiled from the base: `classes/` (the AS2 classes) and `timeline/` (scripts attached to the SWF's timelines). **This is what you edit.** |
| `base/<version>/` | `loader.swf`: the deobfuscated official loader the sources come from (code cleaned, names recovered); `manifest.json`: the hash of every source as exported, and of the official loader it was made from; `names/`: the names used to deobfuscate (reused for the next version). |
| `tools/build.mjs` | `src/` → `build/loader.swf` |
| `tools/package.mjs` | official client + `build/loader.swf` + `overlay/` → `dist/<platform>/`, `--run` starts it |
| `tools/manifest.mjs` | records `src/` as the new baseline of a base |
| `tools/deob/` | the deobfuscation toolkit, to port a newer client (docs/UPGRADING.md) |
| `.claude/skills/swf-deobfuscate/` | the same know-how as a Claude Code skill: opened in this repo, Claude Code uses it to deobfuscate or upgrade (it reads your paths from `retro.local.json`) |
| `overlay/` | files copied over the client when packaging (same layout as the client folder) |
| `retro.json` | the client version in use · `retro.local.json`: this machine's paths (not in git) |

## Setup

- **Node 24** (runs the tools and the toolkit's TypeScript directly, no `npm install`).
- **Java 11+** and **FFDec** (JPEXS Free Flash Decompiler, ≥ 26): it compiles
  the ActionScript. Windows: `ffdec-cli.exe` works too.
- **The official Dofus Retro client** of your platform, installed by Ankama's
  launcher — the build reuses its Electron app, Flash plugin and assets.

Copy `retro.local.example.json` to `retro.local.json` and set your paths:
`ffdec`, `upstream.linux` / `upstream.windows` (the folder that holds
`resources/app/retroclient`), optionally `overlay` (your machine-specific
files, e.g. a `config.xml` pointing at your server) and `executable`.

## Everyday use

```bash
node tools/build.mjs                 # src/ → build/loader.swf
node tools/package.mjs --run         # build, put it in dist/<platform>/, start the game
```

The build compiles **only the files that differ from the base** into a copy
of the base loader; everything else keeps the base's bytecode exactly. So a
change touches only the classes you edited — and a compile error points at
your file: `Missing operand on line 74, file: src/classes/…`. `--full`
compiles every file (works, but the decompiled `_locN_` locals become named
variables: slower; for tests).

Two fixes and checks keep a recompiled class equal to the original:
- `_root` is compiled by name (`eval("_root")` in the staged copy, src/ isn't
  touched): FFDec would read it from a preloaded register, which in the loader
  (loaded by preloader.swf) is the preloader's root — the client stops at
  startup. The build refuses any function that still preloads `_root`.
- every `get x()` / `set x()` must still match its property (the compiler
  registers properties from accessor names).

`dist/<platform>/` is a full copy of the official client (made once, then only
the loader and overlay are replaced). Ankama's launcher must not update it —
start it with `--run` or its executable, not through the launcher.

## Hot reload

```bash
node tools/dev.mjs                   # build (with hot reload), start the game, watch src/
```

Save a class: within a second or two the running game takes the new code
and says `hot reload: <class>` in the chat — no restart, no login. It copies
the new code into the existing class, so objects already created use it:

| change | hot? |
|---|---|
| method / `get` / `set` bodies, static functions, a new method or class | yes |
| static constants — UPPER_CASE names (`WIDTH`, `CLASS_NAME`) | yes |
| an interface's layout (`createChildren`…) | yes, once the interface is reopened |
| other static values (`_instance`, counters: the game's state) | no, kept on purpose |
| a function already handed out (`addToQueue`, `setInterval`, `onRelease = function…`) | not until its owner is recreated |
| a field's initial value, for objects already created | no (new ones yes) |
| startup code (`DofusCore`…), `src/timeline/`, `src/symbols.json` | no: restart the game |

The loader is rebuilt behind each change, so restarting the game keeps them.

**Auto login**: with `"dev": { "login": "…", "password": "…", "server": 2,
"character": "…" }` in retro.local.json, the game started by dev.mjs logs in,
picks the server and enters the world by itself (`server` and `character`
are optional: the first one then). `--no-login` to type it yourself. The
password stays on your machine (retro.local.json and dist/ aren't in git).
Hot reload and auto login live in `tools/dev/`, added by `build.mjs --dev`
only: a normal build or package never contains it.

## Writing code

- Classes are AS2 (`class dofus.datacenter.Item extends Object { … }`), one per
  file under `src/classes/`, path = package (`src/classes/dofus/datacenter/Item.as`).
- `src/timeline/` holds the code attached to the SWF's graphics:
  - `main/frame_1/DoAction.as` — the main timeline's script;
  - `init/<Name>.as` — `Object.registerClass("<Name>", …)`: which class a
    library symbol (a button, a window…) is;
  - `sprites/<id>[_<name>]/frame_<n>/` — a movie clip's scripts:
    `DoAction.as` (frame script), `PlaceObject2_<char>_<Class>_<depth>/…as`
    (an instance's `on(construct)` / `onClipEvent` code: a component's
    initial settings, e.g. a label's text style);
  - `buttons/<id>/` — a button's `on(release)`… handlers.

  Folder and file names there must stay as they are: they say which SWF
  object the code goes to (the build maps them to FFDec's layout, tools/lib.mjs).
- Decompiled style stays: `_loc3_` locals, `return undefined;`. Rename locals
  in code you rewrite; there's no need to clean what you don't touch (a
  smaller diff is easier to review and to port).
- A class you add: put it under `src/classes/`; a deleted file can't remove
  code from the base (the build warns).
- Names ending in `_` (`enabled_`, `api_`) are recovered names that clashed
  with a name the code already used: keep them, they're not typos.

New interfaces: docs/NEW-UI.md (the `/hello` window, on branch `feat/hello-ui`, is the template).

See docs/WORKFLOW.md for git (branches, reviews, the `upstream` branch) and
docs/UPGRADING.md to move to a newer official client.
