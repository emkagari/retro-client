# Moving to a newer official client

When Ankama ships a new Retro version, its `loader.swf` is obfuscated again,
with new ids. The toolkit (`tools/deob/`) recovers the names by matching the
new code against **our current sources**: unchanged code gets the same names,
so `git merge` then shows mostly what Ankama changed — and conflicts only
where our changes meet theirs.

Commands below for version `1.50.0`; `$OFFICIAL` = a **copy** of the new
official `resources/app/retroclient/loader.swf` (the launcher may update the
installed one while you work), `$FFDEC` = your ffdec.jar. Each step runs from
the repo root; a separate worktree keeps your own branch untouched:
`git worktree add ../retro-client-upgrade upstream`.

## 0. Start from up-to-date tools

`upstream` must have the current `tools/`, `base/` and build fixes, which are
usually committed on `main`. When `main` holds no feature (features live on
their own branches until merged), bring them over first:

```bash
git switch upstream
git merge --ff-only main      # else: cherry-pick main's tooling commits
```

## 1. Deobfuscate (≈5–10 min)

```bash
node tools/deob/src/deob.ts $OFFICIAL --ref src/classes --out .tmp/deob-1.50.0 --ffdec $FFDEC
```

`deob.ts` cleans the control flow, matches names, writes `runnable.swf` and
checks it (four `ok`). Check the version the code states — it names the base,
whatever the launcher says:

```bash
grep -E 'static var (SUB|SUBSUB)?VERSION' .tmp/deob-1.50.0/scripts/scripts/__Packages/dofus/Constants.as
```

## 2. Name accessors and what's left

```bash
node tools/deob/src/accessors.ts .tmp/deob-1.50.0
node tools/deob/src/rename-only.ts .tmp/deob-1.50.0 --ref src/classes \
  --extra .tmp/deob-1.50.0/accessors.json --ffdec $FFDEC     # decompiles with accessors named
node tools/deob/src/align.ts .tmp/deob-1.50.0 --ref src/classes --out .tmp/deob-1.50.0/by-role.json
node tools/deob/src/leftovers.ts .tmp/deob-1.50.0/scripts/scripts/__Packages
```

`accessors.ts` names getters/setters from their registrations; `align.ts`
names leftovers from the same lines of the previous sources (most are names
the previous version had: by-role names, setter parameters, clip names). What
`leftovers.ts` still lists is mostly new code: add names by role to
`by-role.json` (`{ "_o1b1812": "_nLoadingCount" }`). Rules (also in the
`swf-deobfuscate` skill, § 5):

- **never a name already present in the code** (`grep -rw <name>` in
  `.tmp/deob-1.50.0/scripts`): the obfuscator reuses an id for different
  members across classes, so the same name on two ids would merge two members;
  `align.ts` drops those itself;
- name a **property** rather than its getter/setter: `accessors.ts --extra`
  then names its accessors.

Then, with every name:

```bash
node tools/deob/src/accessors.ts .tmp/deob-1.50.0 --extra .tmp/deob-1.50.0/by-role.json
node tools/deob/src/rename-only.ts .tmp/deob-1.50.0 --ref src/classes \
  --extra .tmp/deob-1.50.0/accessors.json,.tmp/deob-1.50.0/by-role.json \
  --out .tmp/deob-1.50.0/runnable.swf --runnable --ffdec $FFDEC
node tools/deob/src/check-accessors.ts .tmp/deob-1.50.0/runnable.swf
```

`rename-only` must end with four `ok`; `check-accessors` should list only
accessors whose id is made of blanks (`"\t\n"`): step 3 handles those. One
with another id belongs to a property still unnamed: name the property.

## 3. Install the base and its sources

```bash
mkdir -p .tmp/names && cp .tmp/deob-1.50.0/{names,accessors,by-role}.json .tmp/names/
node tools/new-base.mjs 1.50.0 .tmp/deob-1.50.0/runnable.swf --upstream $OFFICIAL --names .tmp/names
```

It replaces `src/` with the new export, makes accessors recompilable, and
**carries over the previous base's hand fixes**: wherever `src/` differed from
that base's own export (decompiler artifacts fixed by hand), the change is
merged into the new export; conflicts are listed (`<<<<<<<` markers). It sets
`retro.json` to 1.50.0 and lists what doesn't compile back. Fix those — same
meaning, compilable form. Then:

```bash
node tools/manifest.mjs 1.50.0 --upstream $OFFICIAL     # build.mjs needs it
node tools/build.mjs --full                              # every file compiles
node tools/package.mjs --run            # the base alone: must play like the official client
git add -A && git commit -m "Upstream 1.50.0"
```

Keep `base/<previous>/` until main is merged and tested; remove it after.

## 4. Merge into main

```bash
git switch main
git merge upstream
```

Conflicts are places where Ankama changed code we changed too: resolve them in
`src/` as usual. Then `node tools/build.mjs`, test in game, commit.

**Names can move between versions.** Private members (`_nGuild`, `_bRadio`…)
are named by a vote across classes, and the obfuscator reuses ids: a member
may come back under another name even where Ankama changed nothing. Git
applies that rename to their lines, not to ours, so code of ours that uses
the old name breaks silently. After the merge, check that every member our
changes use still exists — for each feature's diff, the `this._x` / `.x` it
reads or writes must still be declared or assigned somewhere in the new
sources.

Diff noise to expect: such renames, and FFDec printing member declarations
(`var api;`) in another order — harmless.
