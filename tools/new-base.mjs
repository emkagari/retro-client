/**
 * Installs a new base — a deobfuscated official loader — and its sources
 * (docs/UPGRADING.md, on the `upstream` branch):
 *
 *   node tools/new-base.mjs <version> <runnable.swf> --upstream <official loader.swf> [--names <dir>]
 *
 * 1. base/<version>/loader.swf ← runnable.swf (and names/ ← --names dir);
 * 2. FFDec export of it, line endings LF, accessors made recompilable
 *    (tools/deob/src/source-accessors.ts);
 * 3. the previous base's hand fixes carried over: the previous base is
 *    exported the same way, and wherever src/ differs from that export (a
 *    decompiler artifact fixed by hand), the change is merged into the new
 *    export (git merge-file); conflicts are listed;
 * 4. compiles every file to list what the decompiler got wrong;
 * 5. src/ ← the export, in the repo's layout (classes/, timeline/…);
 * 6. src/assets/ ← the new base's graphics (tools/assets.mjs); a graphic
 *    edited for the previous base is found in the new one by its original
 *    content (ids change between versions) and its edit carried over; new/
 *    graphics are kept; those not found are listed;
 * 7. retro.json → this version.
 *
 * Fix those files by hand (they're few: 2 for 1.49.5), until
 * `node tools/build.mjs --full` passes, then record the baseline:
 * `node tools/manifest.mjs <version> --upstream <official loader.swf>`.
 */
import { execFileSync, spawnSync } from "node:child_process";
import { copyFileSync, cpSync, existsSync, mkdirSync, readFileSync, renameSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, relative, sep } from "node:path";
import { ROOT, SRC, base, compileErrors, config, ffdec, fromFfdec, sourceFiles } from "./lib.mjs";
import { ASSETS, assetFiles, assetHash, changedAssets, exportGraphics, extract } from "./assets.mjs";

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

/** FFDec export of a base (its layout), LF, accessors made recompilable: what src/ starts from. */
function exportSources(loader, tmp) {
  rmSync(tmp, { recursive: true, force: true });
  const exp = ffdec(cfg, ["-export", "script", tmp, loader]);
  if (!exp.ok) { console.error(exp.log); process.exit(1); }
  const exported = join(tmp, "scripts");
  for (const f of sourceFiles(exported)) {
    const p = join(exported, f);
    const s = readFileSync(p, "utf8");
    if (s.includes("\r\n")) writeFileSync(p, s.replace(/\r\n/g, "\n"));
  }
  execFileSync(process.execPath, [join(ROOT, "tools/deob/src/source-accessors.ts"), loader, join(exported, "__Packages")], { stdio: "inherit" });
  return exported;
}

const tmp = join(ROOT, ".tmp", "export");
const exported = exportSources(join(dir, "loader.swf"), tmp);
const files = sourceFiles(exported);

// The previous base's hand fixes: src/ against that base's own export.
const previous = cfg.version;
const previousLoader = join(ROOT, "base", previous, "loader.swf");
const carried = [], conflicts = [], gone = [];
if (previous !== version && existsSync(previousLoader)) {
  const oldTmp = join(ROOT, ".tmp", "export-previous");
  const old = exportSources(previousLoader, oldTmp);
  for (const f of sourceFiles(old)) {
    const mine = join(SRC, fromFfdec(f));
    if (!existsSync(mine)) continue;
    const fixed = readFileSync(mine, "utf8").replace(/\r\n/g, "\n");
    if (fixed === readFileSync(join(old, f), "utf8")) continue;
    const target = join(exported, f);
    if (!existsSync(target)) { gone.push(fromFfdec(f)); continue; }
    const fixedCopy = join(oldTmp, "fixed.as");
    writeFileSync(fixedCopy, fixed);
    // Their side: the new export; base: the previous export; ours: the fix.
    const m = spawnSync("git", ["merge-file", "-L", `base ${version}`, "-L", `base ${previous}`, "-L", "hand fix", target, join(old, f), fixedCopy]);
    (m.status === 0 ? carried : conflicts).push(fromFfdec(f));
  }
  rmSync(oldTmp, { recursive: true, force: true });
  console.log(`hand fixes of base ${previous}: ${carried.length} carried over` +
    (conflicts.length ? `, ${conflicts.length} with conflicts (<<<<<<< markers) to resolve:\n${conflicts.map((f) => `  src/${f}`).join("\n")}` : "") +
    (gone.length ? `\n  files gone in ${version}: ${gone.join(", ")}` : ""));
}

// What doesn't compile back: decompiler artifacts to fix by hand.
const out = join(ROOT, ".tmp", "full.swf");
const r = ffdec(cfg, ["-onerror", "ignore", "-importScript", join(dir, "loader.swf"), out, exported]);
const errors = compileErrors(r.log).map((e) => e.replace(/file: (.+)$/, (_, f) => `file: src/${fromFfdec(relative(exported, f).split(sep).join("/"))}`));
rmSync(out, { force: true });

// Graphics edited for the previous base (and new ones): kept aside, src/ is replaced.
const keptAssets = join(ROOT, ".tmp", "assets-kept");
rmSync(keptAssets, { recursive: true, force: true });
const editedAssets = [];
if (existsSync(ASSETS) && existsSync(join(ROOT, "base", previous, "manifest.json"))) {
  for (const f of changedAssets(base(previous).manifest)) {
    mkdirSync(dirname(join(keptAssets, f)), { recursive: true });
    copyFileSync(join(ASSETS, f), join(keptAssets, f));
    if (!f.startsWith("new/")) editedAssets.push(f);
  }
}

// Into src/, in the repo's layout (tools/lib.mjs: classes/, timeline/…).
rmSync(SRC, { recursive: true, force: true, maxRetries: 5 });
for (const f of files) {
  const to = join(SRC, fromFfdec(f));
  mkdirSync(dirname(to), { recursive: true });
  renameSync(join(exported, f), to);
}
rmSync(tmp, { recursive: true, force: true });
console.log(`src/: ${files.length} files`);

// The new base's graphics, and the edits carried over by original content.
extract(cfg, join(dir, "loader.swf"));
const lostAssets = [];
if (existsSync(keptAssets)) {
  if (existsSync(join(keptAssets, "new"))) cpSync(join(keptAssets, "new"), join(ASSETS, "new"), { recursive: true });
  if (editedAssets.length) {
    const original = join(ROOT, ".tmp", "assets-previous");
    exportGraphics(cfg, previousLoader, original);
    const byContent = new Map(assetFiles().filter((f) => !f.startsWith("new/")).map((f) => [assetHash(join(ASSETS, f)), f]));
    for (const f of editedAssets) {
      const target = existsSync(join(original, f)) ? byContent.get(assetHash(join(original, f))) : undefined;
      if (target) copyFileSync(join(keptAssets, f), join(ASSETS, target));
      else lostAssets.push(f);
    }
    rmSync(original, { recursive: true, force: true, maxRetries: 5 });
    console.log(`graphics edited for base ${previous}: ${editedAssets.length - lostAssets.length} carried over` +
      (lostAssets.length ? `, ${lostAssets.length} not found in ${version} (changed or removed by Ankama): redo them from .tmp/assets-kept/:\n${lostAssets.map((f) => `  ${f}`).join("\n")}` : ""));
  }
}
console.log(`src/assets/: ${assetFiles().length} files`);

const retro = JSON.parse(readFileSync(join(ROOT, "retro.json"), "utf8"));
writeFileSync(join(ROOT, "retro.json"), JSON.stringify({ ...retro, version }, null, 2) + "\n");

if (conflicts.length) console.log(`\n${conflicts.length} carried-over fix(es) in conflict: resolve the <<<<<<< markers in ${conflicts.map((f) => `src/${f}`).join(", ")}`);
console.log(errors.length
  ? `\n${errors.length} file(s) to fix by hand, then run node tools/build.mjs --full:\n${errors.map((e) => `  ${e}`).join("\n")}`
  : "\neverything compiles");
console.log(`\nthen: node tools/manifest.mjs ${version} --upstream ${upstream}`);
if (!existsSync(upstream)) console.warn(`warning: ${upstream} doesn't exist`);
