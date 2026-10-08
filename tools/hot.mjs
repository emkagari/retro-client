/**
 * Hot reload patches: a few classes compiled into a SWF of their own, which
 * the running client loads (tools/dev/HotReload.as).
 *
 * The patch is a minimal one-frame SWF holding, for each class, the clip
 * exported as `__Packages.<class>` with its DoInitAction — what defines a
 * class when the SWF is loaded. FFDec compiles the sources into it, `_root`
 * by name as in the build.
 */
import { mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { ROOT, SRC, compileErrors, ffdec, fromFfdec, rootByName, toFfdec } from "./lib.mjs";
import { withSymbols } from "./symbols.mjs";
import { writeSwf } from "./deob/src/swf.ts";

const TMP = join(ROOT, ".tmp", "hot");
const classPath = (f) => f.slice("classes/".length, -".as".length).split("/").join(".");

/** An empty SWF 8: RECT 0×0 (one byte), 24 fps, 1 frame; ShowFrame, End. */
function emptySwf() {
  return writeSwf({
    version: 8,
    compressed: true,
    header: Buffer.from([0x00, 0x00, 0x18, 0x01, 0x00]),
    tags: [{ code: 1, data: Buffer.alloc(0) }, { code: 0, data: Buffer.alloc(0) }],
  });
}

/**
 * Compiles these sources (paths under src/, classes only) into a patch.
 * Returns { classes, swf } or { errors }.
 */
export function makePatch(cfg, files) {
  rmSync(TMP, { recursive: true, force: true });
  mkdirSync(TMP, { recursive: true });
  const classes = files.map(classPath);
  const empty = join(TMP, "empty.swf"), holders = join(TMP, "holders.swf"), out = join(TMP, "patch.swf");
  writeFileSync(empty, emptySwf());
  writeFileSync(holders, withSymbols(empty, classes, []));

  const stage = join(TMP, "src");
  for (const f of files) {
    const to = join(stage, toFfdec(f));
    mkdirSync(dirname(to), { recursive: true });
    writeFileSync(to, rootByName(readFileSync(join(SRC, f), "utf8")));
  }
  const r = ffdec(cfg, ["-importScript", holders, out, stage]);
  const errors = compileErrors(r.log)
    .map((e) => e.replace(/file: (.+)$/, (_, p) => `file: src/${fromFfdec(relative(stage, p).split(sep).join("/"))}`));
  if (!r.ok || errors.length) return { errors: errors.length ? errors : [r.log.trim().split("\n").slice(-3).join(" ")] };
  return { classes, swf: readFileSync(out) };
}
