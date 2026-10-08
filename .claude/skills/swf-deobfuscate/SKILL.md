---
name: swf-deobfuscate
description: Deobfuscate a Dofus 1.x (AS2/AVM1) client SWF — the Retro loader.swf, or loader.swf / core.swf of a custom or emulator client — back into readable AS2 sources with recovered class, member and parameter names, by cleaning its control flow and matching it against a readable reference build; and install a new official Retro version as this repo's base. Use when asked to deobfuscate, de-obfuscate, understand or explore an obfuscated Flash/Dofus client, to port/upgrade the repo to a newer Retro client, or to recover names from code that shows control-character names (\x1b\r\x04), §§push/§§pop, or junk like `true or true` / `getTimer()` conditions.
---

# Deobfuscating an AS2 client SWF

Everything is in this repository (paths below are relative to its root):
the toolkit in `tools/deob/` (its `README.md` explains the design), the
repo tools in `tools/`. Node 24 runs the TypeScript directly — no install.

**Machine-specific settings come from `retro.local.json`** (not in git; copy
`retro.local.example.json`): `ffdec` (FFDec ≥ 26, a .jar run with `java`, or
`ffdec-cli.exe`), `upstream.<platform>` (the official client). Read it before
running anything; pass FFDec as `--ffdec "$FFDEC"` with
`FFDEC=$(node -p "require('./retro.local.json').ffdec")`. Ask the user for a
path that isn't there — never guess one from another machine.

Work on COPIES of client files (`.tmp/` is ignored by git); never write into
an installed client or a server folder. Runs go to `.tmp/deob-<version>/`.

Two situations:

- **A newer official Retro client** → the goal is a new base for this repo:
  follow `docs/UPGRADING.md` (it runs §§ 3–5 below with the repo's own
  sources as reference, then `tools/new-base.mjs`). Names carry over: same
  code, same names.
- **Another client** (emulator build, older version) → §§ 1–5, then § 7 to
  try it in game.

## 1. Find the code and confirm it's obfuscated

- Retro and StarLoco-style clients keep the code in `retroclient/loader.swf`;
  Ankama-style 1.43 builds in `modules/core.swf` + `loader.swf`. The biggest
  SWF is usually it.
- `node tools/deob/src/stats.ts <file.swf>` — signs of this obfuscator:
  thousands of *branches into the middle of an action*, *actions after an
  End*, and repeated patterns before `If` (`Push(bool) Not`, `Push(str)
  CharToAscii`, `GetTime Increment`). A clean build shows zeros there.

## 2. Pick the reference

A FOLDER of readable AS2 sources (FFDec `scripts/__Packages` layout) of the
closest client version:

- a Retro version → this repo's `src/classes` (on the `upstream` branch:
  pristine);
- anything else → ask the user for the readable build closest in version
  (a 1.43.7 build works well for 1.3x–1.4x clients). A readable SWF works:
  `java -jar "$FFDEC" -export script <dir> <file.swf>`, then `<dir>/scripts/__Packages`.

## 3. Run the pipeline

```bash
node tools/deob/src/deob.ts <target.swf> --ref <reference __Packages> --out .tmp/deob-<v> --ffdec "$FFDEC"
```

~10 minutes for 3 MB of code (FFDec runs three times: run it in the
background and report progress). Two kinds of names are recovered differently:

- **classes, packages, members** — the obfuscator maps one real name to one
  string everywhere: one global table (`names.json`), names kept unique;
- **parameters** — renamed PER FUNCTION by the obfuscator. Each paired method
  gets the reference's parameter names (class + member + arity), in that
  function's header only — safe: `DefineFunction2` keeps parameters in registers.

It writes `clean.swf` (control flow only), `deob.swf` (renamed, for READING
only), `runnable.swf` (for a client, § 7), `names.json` (with votes) and the
sources in `scripts/scripts/__Packages`, then checks `runnable.swf`.

To redo only the renaming (new names, new rules) — ~1 min, no new matching:

```bash
node tools/deob/src/rename-only.ts .tmp/deob-<v> --ref <ref> [--extra a.json,b.json] [--out .tmp/deob-<v>/runnable.swf --runnable] --ffdec "$FFDEC"
```

## 4. Judge the result

```bash
node tools/deob/src/quality.ts .tmp/deob-<v>/scripts/scripts/__Packages <reference __Packages>
```

Expect nearly every file to be a real `class`, `§§push/pop` near 0 and, in the
same client family, most files at the reference's path with many identical
lines (StarLoco 1.39.8 vs 1.43.7: 569/569 classes, 84 %). Spot-check classes
against the reference; votes/total close to 1 with several votes = reliable.

## 5. Name what's left

Two passes, both `--extra` files for `rename-only.ts` (hand names win and stay
unique):

1. **Accessors, mechanically** — `node tools/deob/src/accessors.ts .tmp/deob-<v>`
   reads every `addProperty("x", getter, setter)` and names the obfuscated
   accessors `__get__x` / `__set__x`, an unnamed PROPERTY from its accessors,
   and CORRECTS the matcher (it names accessors after their property:
   `function classID(n)` is `set classID`). Retro 1.49.5: 1 024 unnamed ids →
   116, 500 matcher names corrected.
2. **By role, by hand** — `node tools/deob/src/leftovers.ts .tmp/deob-<v>/scripts/scripts/__Packages`
   lists the `_o<hex>` placeholders; read the code around each and name it by
   what it does (`{ "_o1b1812": "_nLoadingCount" }`). Rules:
   - **never name a property or an accessor** here — `accessors.ts` owns them,
     and an accessor that doesn't carry its property's name changes the class
     when it's recompiled (`check-accessors.ts` lists mismatches); name an
     unnamed property only, its accessors follow;
   - **no clash**: a hand name evicts the id that had it — check against
     `names.json` + `accessors.json` first; parameters clash most (`nID`,
     `sData`): pick a contextual variant;
   - **never a Flash built-in** for a member called on a built-in object
     (`this._so.<id>(…)`): the original calls nothing there, the renamed one
     would call the real method.

Placeholders that decode to printable text (`_o3c2f623e0a` = `"</b>\n"`) are
text, not ids. Say which names are yours and which come from the reference.

## 6. When cleaning falls short

Symptoms: many `§§push`/`§§pop`, odd `while(true)` / `if(!(true and true))`,
"blocks left as is" in the log.

- `node tools/deob/src/dump.ts .tmp/deob-<v>/clean.swf "sprite <id>" 80` shows
  the p-code of one block.
- A new opaque predicate = a constant computation the stack model doesn't
  know: teach it in `tools/deob/src/clean.ts`, rerun `run-clean.ts` +
  `stats.ts` until *into the middle* and *after an End* are 0.
- Cleaning a readable build must change (almost) nothing: regression check
  `node tools/deob/src/run-clean.ts <readable.swf> .tmp/x.swf`.

## 7. Putting a deobfuscated loader in a client

A SWF that decompiles well can still break the game at the first screen
(Retro 1.49.5: the whole UI). Renaming is safe only if it stays CONSISTENT and
changes nothing but ids:

| trap | what breaks | rule |
|---|---|---|
| ids outside the code: instance names (PlaceObject), text variables, frame labels, `onClipEvent` code, BUTTON actions (DefineButton2 `on(release)`) | the code looks for `_btnClose`, the clip is still `\x18\x1c\x06` → every UI | the TIMELINE is renamed with the code (`renameTimeline`); clip and button actions are cleaned first (a missed button: Retro's fight Ready button did nothing) |
| text that looks like an id: `"\n"`, `"\r\n"`, `".\n"` | text splitting, HTML, chat | ids are control characters only, separators alone never; unknown ids keep their bytes |
| a recovered name that exists in clear (`enabled`, `data`…) | two members merged | suffix it (`enabled_`); accessors follow their property's suffix |
| a name used by OTHER files (`core.swf` instance names, lang keys) | lookups from outside | readable names from outside are never ids: don't rename INTO them |
| accessors named unlike their property | a recompiled class registers another property | `check-accessors.ts`; `source-accessors.ts` fixes the sources |
| FFDec compiles a bare `_root` in a function to a PRELOADED register (Ankama's compiler never does) | that register ignores `_lockroot`: in a loader loaded by another SWF it's the other root → DofusCore attaches its clips there, the client stops at startup | compile `eval("_root")` (the repo's build does it: `rootByName`); `check-preload.ts` must show no more preloaded `_root`/`_parent` than the base |

1. Use `runnable.swf`, never `deob.swf`.
2. `node tools/deob/src/check-runnable.ts .tmp/deob-<v> [<file.swf>]` must say
   `ok` four times; `check-accessors.ts <file.swf>` should list only accessors
   whose id is blanks (`"\t\n"`).
3. In this repo, install it as a base (`tools/new-base.mjs`, docs/UPGRADING.md)
   and try it with `node tools/package.mjs --run`: it plays from a copy of the
   official client, never the install itself. Outside the repo: copy the WHOLE
   client, replace `loader.swf` there, keep `loader.original.swf` and
   `clean.swf` next to it.
4. If it breaks, have the user try `clean.swf` too: clean works → a renaming
   trap (find the new kind of named place, extend `renameTimeline` /
   `check-runnable.ts`); clean fails → cleaning (§ 6). Ask how far it gets
   (loading, login, server list, character, game).
5. Report the share of renamed ids (`check-runnable.ts`: obfuscated strings
   before → after; Retro 1.49.5: 25 793 → 2 004 with the reference only, → 5
   after § 5).

When a new trap shows up: add it to the table AND a check to
`check-runnable.ts`, so the next run catches it before the game does.

## Limits to state in the answer

- `deob.swf` is for reading; `runnable.swf` (or the repo's build) for a client.
  Say whether it was tested in game — the checks are static.
- Names come from the reference version: new code keeps placeholders or a
  reference name that may be slightly off. In `runnable.swf`, unknown ids stay
  obfuscated and clashing names carry a `_`.
