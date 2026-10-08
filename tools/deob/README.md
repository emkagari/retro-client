# deob — AS2 client deobfuscation (POC)

Turns an obfuscated Dofus 1.x client SWF back into readable AS2 sources, using
a readable build of the same client family as the reference.

First target: StarLoco 1.39.8 (`retroclient/loader.swf`, 2.9 MB of code),
reference: the 1.43.7 sources (`stack_1.43/.sources/kit-1.43.7/swf-patch/scripts/__Packages`).

```bash
node src/deob.ts target/loader.swf \
  --ref ../stack_1.43/.sources/kit-1.43.7/swf-patch/scripts/__Packages \
  --out run1                      # ~9 min, most of it FFDec
node src/quality.ts run1/scripts/scripts/__Packages <ref>   # how readable
node src/leftovers.ts run1/scripts/scripts/__Packages      # what's still unnamed
```

Node 24 runs the TypeScript directly (no build). FFDec: `--ffdec <jar>`, else
the `FFDEC` environment variable (the repo's `retro.local.json` has the path).

## Result on StarLoco 1.39.8

| | FFDec's own deobfuscation | this pipeline |
|---|---|---|
| classes rebuilt as `class` | 568 / 569 | 569 / 569 |
| `§§push` / `§§pop` (decompiler failures) | 39 | 2 |
| obfuscated names left | 215 682 | 17 (+ 3 037 `_o<hex>` placeholders, 1 198 distinct) |
| files at the reference's path | 6 | 566 |
| lines identical to the 1.43.7 reference | 48 % | 84 % |

7 495 of 8 629 obfuscated names recovered (pass 1 + pass 2). Spot-checked
by hand: `dofus.SaveTheWorld`, `_srvId`, `_xSocket`, `TCP_HOST`,
`autorisedCommand`, `datacenter`… all right.

## What the obfuscator does (this family)

- **Opaque predicates** before nearly every `If`, ~2 000 times each pattern:
  `!true`, `ord("x")` (never 0), `getTimer()+1` (never 0), `true && true`,
  `x & x` on a big constant, `!!x` around them.
- **Jumps into the middle of instructions** (1 779) and **dead code after
  `End`** (363 000 of 648 000 actions): a linear disassembly is wrong.
- **Identifiers** (classes, packages, members, parameters) renamed to 1-3
  control characters (`\x1b\r\x04`), sometimes invalid UTF-8 — consistently:
  one real name ↔ one obfuscated string everywhere. Names the player needs
  (Flash API, events, dynamic/string-accessed properties) survive in clear:
  they are the anchors.

## How it works

| Step | File | |
|---|---|---|
| SWF / tags / code sites | `src/swf.ts` | DoAction + DoInitAction, root and inside sprites |
| AVM1 decode/encode | `src/avm1.ts` | strings kept as BYTES (latin1) — invalid UTF-8 survives |
| control-flow cleaning | `src/clean.ts` | recursive descent from the entry (not linear), a small stack model folds predicates (constants, `getTimer` truthy, `x op x`…), only reachable code is re-emitted, blocks chained in execution order, relay jumps when a branch exceeds 32 KB, peephole removes the leftovers (`Push c; Not; Pop`…) |
| AS2 parsing | `src/as2.ts` | FFDec class exports → classes, members, tokens; `§…§` and `["\x…"]` → raw identifier tokens |
| name recovery | `src/match.ts` | classes paired on literals + surviving names (IDF-weighted Jaccard), members paired, bodies aligned by a Myers diff where unknown names are wildcards → votes; 4 rounds, names kept unique |
| renaming | `src/rename.ts` | constant pools, pushed strings, function names/params, class export names; jumps and container sizes recomputed. Parameters: per function (see below) |
| orchestration | `src/deob.ts` | clean → decompile → match → rename → (pass 2) → decompile |
| re-rename a run | `src/rename-only.ts` | parameters + names.json on an existing run's clean.swf, one decompile |
| diagnostics | `src/stats.ts`, `src/dump.ts`, `src/quality.ts`, `src/leftovers.ts` | opcode/pattern stats, readable p-code of one block, readability metrics, unnamed ids |

## Parameters: per function, not global

The obfuscator renames classes and members consistently (one real name ↔ one
string) but parameters per function: in StarLoco 1.39.8, 5 646 obfuscated
parameters use only 1 320 strings, one of them for 858 functions. A global
table can't name them alone. They still vote there (old `DefineFunction`
closures and register-0 parameters are read by name in the body — only the
global table reaches those strings; dropping these votes cost 1 150 names),
and on top of that the matcher records, for each paired method with the same arity, the reference's
parameter names under `[class path, member, arity]`; the renamer finds each
`DefineFunction2` by its block's class export name and the member name pushed
just before it, and rewrites that header only. 6 226 of 6 265 parameters live
in registers — their name exists nowhere else, the rename can't break code.

## Limits

- Names are recovered only where the reference has the same code; what the
  server added (anti-bot, custom UI…) keeps `_o<hex>` placeholders — name
  those by reading, then `--extra names.json` (`{ "_o1b0d04": "myName" }`).
- Parameters read by name (register 0: 39 in 1.39.8) and those of old
  `DefineFunction` closures aren't renamed per function.
- AS2 getters/setters (`__get__x`/`addProperty`) aren't paired yet: several
  frequent leftovers are accessors shared by many UI controls.
- The output is for READING. The cleaned/renamed SWF decompiles fine, but it
  wasn't run in the client, and recompiling the sources is another job.
- New obfuscator patterns: `node src/stats.ts file.swf` (top "before If"
  patterns) and `node src/dump.ts file.swf "sprite N"` show them; teach the
  stack model in `clean.ts` (`binary`, the unary cases) and rerun.

## Running the result in a client

`deob.swf` is for reading; `runnable.swf` is the one to put in a client
(recognized ids only, timeline included, clashing names suffixed `_`, text
untouched). `node src/check-runnable.ts <run>` checks it statically; the
pipeline runs it at the end. The traps and the test protocol are in the
`swf-deobfuscate` skill, § 7. Retro 1.49.5: tested in game, works.
