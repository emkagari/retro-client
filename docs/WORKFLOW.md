# Working together

## Branches

- **`upstream`** — the official client only: `base/<version>/` and `src/` exactly
  as exported from it (plus the fixes that make the export compile, see
  UPGRADING.md). One commit per official version, never our changes. It's what
  the next version is compared with.
- **`main`** — `upstream` + our changes. Always builds.
- **feature branches** — one per change (`feat/chat-commands`, `fix/craft-popup`),
  from `main`, merged back through a pull request.

```
upstream:  1.49.5 ───────────────── 1.50.0
              \                        \
main:          ●──●──●──(merge)──●──●──●(merge)──●
                  \      /
feat/x:            ●──●─┘
```

## A change

```bash
git switch main && git pull
git switch -c feat/my-change
# edit src/…
node tools/package.mjs --run          # try it
git add src && git commit -m "Chat: /tp command"
git push -u origin feat/my-change     # open a pull request
```

A review reads `.as` diffs like any code. Keep pull requests to one subject,
and don't reformat what you don't change: the next version's merge is easier.

`build/`, `dist/` and `retro.local.json` are not in git — each machine builds
its own client from its own official install.

## Before merging

- `node tools/build.mjs` succeeds (no compile error, accessor check passes);
- the game starts and the changed feature works (say how you tested it);
- `base/` and `tools/deob/` don't change in a feature pull request (they move
  with an upgrade, on `upstream`).
