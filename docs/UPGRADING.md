# Moving to a newer official client

When Ankama ships a new Retro version, its `loader.swf` is obfuscated again,
with new ids. The toolkit (`tools/deob/`) recovers the names by matching the
new code against **our current sources**: unchanged code gets exactly the same
names, so `git merge` then shows only what Ankama changed — and conflicts only
where our changes meet theirs.

Commands below for version `1.50.0`; `$OFFICIAL` = the new official
`resources/app/retroclient/loader.swf`, `$FFDEC` = your ffdec.jar.

## 1. Deobfuscate (≈10 min)

From the `upstream` branch, so the reference is the pristine sources:

```bash
git switch upstream
node tools/deob/src/deob.ts $OFFICIAL --ref src/classes --out .tmp/deob-1.50.0 --ffdec $FFDEC
node tools/deob/src/accessors.ts .tmp/deob-1.50.0
```

`deob.ts` cleans the control flow, matches names, writes `runnable.swf` and
checks it. `accessors.ts` names getters/setters from their registrations.

## 2. Name what's left (optional, recommended)

`node tools/deob/src/leftovers.ts .tmp/deob-1.50.0/scripts/scripts/__Packages`
lists the ids still unnamed (mostly code that's new in this version). Name
them by role in `.tmp/deob-1.50.0/by-role.json` (`{ "_o1b1812": "_nLoadingCount" }`)
— the rules are in the `swf-deobfuscate` skill, § 5 (no clash with an existing
name, never a property or an accessor: `accessors.ts` names those). Then:

```bash
node tools/deob/src/rename-only.ts .tmp/deob-1.50.0 --ref src/classes \
  --extra .tmp/deob-1.50.0/accessors.json,.tmp/deob-1.50.0/by-role.json \
  --out .tmp/deob-1.50.0/runnable.swf --runnable --ffdec $FFDEC
```

It must end with four `ok` (check-runnable). Then
`node tools/deob/src/check-accessors.ts .tmp/deob-1.50.0/runnable.swf` should
list only accessors whose id is made of blanks (`"\t\n"`): step 3 handles those.

## 3. Install the base and its sources

```bash
mkdir -p .tmp/names && cp .tmp/deob-1.50.0/{names,accessors,by-role}.json .tmp/names/
node tools/new-base.mjs 1.50.0 .tmp/deob-1.50.0/runnable.swf --upstream $OFFICIAL --names .tmp/names
```

It replaces `src/` with the new export, makes accessors recompilable, sets
`retro.json` to 1.50.0 and lists the files that don't compile back
(decompiler artifacts: a missing parenthesis, a labeled `break`…). Fix them —
same meaning, compilable form — until `node tools/build.mjs --full` passes.
Then:

```bash
node tools/manifest.mjs 1.50.0 --upstream $OFFICIAL
node tools/package.mjs --run            # the base alone: must play like the official client
git add -A && git commit -m "Upstream 1.50.0"
```

Keep `base/1.49.5/` until main is merged and tested; remove it after.

## 4. Merge into main

```bash
git switch main
git merge upstream
```

Conflicts are places where Ankama changed code we changed too: resolve them in
`src/` as usual. Then `node tools/build.mjs`, test in game, commit.

Diff noise to expect: FFDec doesn't always print member declarations
(`var api;`) in the same order — harmless.
