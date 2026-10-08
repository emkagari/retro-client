/**
 * Installs a new base — a deobfuscated official loader — and its sources
 * (docs/UPGRADING.md, on the `upstream` branch):
 *
 *   node tools/new-base.mjs <version> <runnable.swf> --upstream <official loader.swf> [--names <dir>]
 *
 * 1. base/<version>/loader.swf ← runnable.swf (and names/ ← --names dir);
 * 2. FFDec export of it, line endings LF, accessors made recompilable
 *    (tools/deob/src/source-accessors.ts);
 * 3. compiles every file to list what the decompiler got wrong;
 * 4. src/ ← the export, in the repo's layout (classes/, timeline/…);
 * 5. retro.json → this version.
 *
 * Fix those files by hand (they're few: 2 for 1.49.5), until
 * `node tools/build.mjs --full` passes, then record the baseline:
 * `node tools/manifest.mjs <version> --upstream <official loader.swf>`.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, cpSync, existsSync, mkdirSync, readFileSync, renameSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { ROOT, SRC, compileErrors, config, ffdec, fromFfdec, sourceFiles } from "./lib.mjs";

const args = process.argv.slice(2);
const opt = (k) => (args.includes(k) ? args[args.indexOf(k) + 1] : undefined);
const [version, runnable] = args;
const upstream = opt("--upstream");
if (!version || !runnable || !upstream) {
  console.error("usage: node tools/new-base.mjs <version> <runnable.swf> --upstream <official loader.swf> [--names <dir>]");
  process.exit(2);
}
const cfg = config();
const dir = join(ROOT, "base", version);
mkdirSync(dir, { recursive: true });
copyFileSync(runnable, join(dir, "loader.swf"));
if (opt("--names")) cpSync(opt("--names"), join(dir, "names"), { recursive: true });
console.log(`base/${version}/loader.swf installed`);

// Sources: FFDec export (its layout), LF, accessors made recompilable.
const tmp = join(ROOT, ".tmp", "export");
rmSync(tmp, { recursive: true, force: true });
const exp = ffdec(cfg, ["-export", "script", tmp, join(dir, "loader.swf")]);
if (!exp.ok) { console.error(exp.log); process.exit(1); }
const exported = join(tmp, "scripts");
const files = sourceFiles(exported);
for (const f of files) {
  const p = join(exported, f);
  const s = readFileSync(p, "utf8");
  if (s.includes("\r\n")) writeFileSync(p, s.replace(/\r\n/g, "\n"));
}
execFileSync(process.execPath, [join(ROOT, "tools/deob/src/source-accessors.ts"), join(dir, "loader.swf"), join(exported, "__Packages")], { stdio: "inherit" });

// What doesn't compile back: decompiler artifacts to fix by hand.
const out = join(ROOT, ".tmp", "full.swf");
const r = ffdec(cfg, ["-onerror", "ignore", "-importScript", join(dir, "loader.swf"), out, exported]);
const errors = compileErrors(r.log).map((e) => e.replace(/file: (.+)$/, (_, f) => `file: src/${fromFfdec(relative(exported, f).split(sep).join("/"))}`));
rmSync(out, { force: true });

// Into src/, in the repo's layout (tools/lib.mjs: classes/, timeline/…).
rmSync(SRC, { recursive: true, force: true });
for (const f of files) {
  const to = join(SRC, fromFfdec(f));
  mkdirSync(dirname(to), { recursive: true });
  renameSync(join(exported, f), to);
}
rmSync(tmp, { recursive: true, force: true });
console.log(`src/: ${files.length} files`);

const retro = JSON.parse(readFileSync(join(ROOT, "retro.json"), "utf8"));
writeFileSync(join(ROOT, "retro.json"), JSON.stringify({ ...retro, version }, null, 2) + "\n");

console.log(errors.length
  ? `\n${errors.length} file(s) to fix by hand, then run node tools/build.mjs --full:\n${errors.map((e) => `  ${e}`).join("\n")}`
  : "\neverything compiles");
console.log(`\nthen: node tools/manifest.mjs ${version} --upstream ${upstream}`);
if (!existsSync(upstream)) console.warn(`warning: ${upstream} doesn't exist`);
