# Builds and releases

GitHub Actions (`.github/workflows/ci.yml`) builds the client on every push
and pull request, and publishes a release only when you push a version tag.
It runs the tools in the Dockerfile's image (Node, Java, FFDec — the same as
`./retro` / `retro.cmd` locally) and needs nothing from Ankama: the base
loader and `src/` are in the repository.

## Every push, every pull request

The loader is built and checked (compile errors, accessors, `_root`), and
kept as an artifact for 14 days (Actions → the run → *Artifacts*): enough to
try a branch. No release is created.

## A release

```bash
git switch main && git pull
git tag v1.49.5-r1
git push origin v1.49.5-r1
```

The CI builds that commit and publishes the release `v1.49.5-r1` with
`retro-client-v1.49.5-r1.zip` and notes listing the pull requests and
commits since the previous tag.

**Tags**: `v<official Dofus Retro version>-r<n>`

| tag | meaning |
|---|---|
| `v1.49.5-r1`, `v1.49.5-r2`… | our releases for the official 1.49.5 client |
| `v1.49.5-r3-rc1`, `-beta1` | a prerelease: to test, not the current version |
| `v1.50.0-r1` | the first one after moving to 1.50.0 (docs/UPGRADING.md) |

The official version comes first: a player knows which Ankama client a
release fits. The CI refuses a tag whose version isn't `retro.json`'s.

## What a release holds

Not a whole client — Ankama's files aren't ours to publish:

```
retro-client-v1.49.5-r1/
  resources/app/retroclient/loader.swf   our loader
  …                                      overlay/ files
  retro-release.json                     versions, commit, the official loader it replaces (sha256)
  README.txt                             how to install it
```

A player copies their official client folder, copies the archive's content
over the copy, and starts the copy with its executable (not Ankama's
launcher: it would restore the official files).

`node tools/release.mjs v1.49.5-r1` prepares the same folder locally
(`dist/release/`), to check it before tagging.
