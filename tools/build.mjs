/**
 * Builds the client's loader.swf from src/:
 *
 *   node tools/build.mjs [--full] [--dev] [--out build/loader.swf]
 *
 * Only the files that differ from the base (base/<version>/manifest.json) are
 * compiled, into a copy of the base loader: the others keep the base's
 * bytecode, exactly. `--full` compiles every file (slower at runtime: the
 * compiler keeps the decompiled `_locN_` variables as named variables).
 *
 * Graphics first: the shapes and images of src/assets/ that differ from the
 * base, and new ones (tools/assets.mjs); sprites: the sprite.json that differ,
 * and new ones (tools/sprites.mjs). Then library clips the sources
 * need: new classes, src/symbols.json (tools/symbols.mjs). `_root` is compiled by name (lib.mjs rootByName). Then
 * checks that no function preloads `_root`, and that every accessor still carries its property's name (the
 * compiler rebuilds `addProperty` from accessor names: a mismatch registers
 * another property) — tools/deob/src/check-accessors.ts.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, existsSync, mkdirSync, readFileSync, renameSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, relative, resolve, sep } from "node:path";
import { ROOT, SRC, base, compileErrors, config, ffdec, fromFfdec, rootByName, sha256, sourceFiles, sourceHash, toFfdec } from "./lib.mjs";
import { declaredSymbols, exportNames, withSymbols } from "./symbols.mjs";
import { applyAssets, changedAssets } from "./assets.mjs";
import { applySprites, changedSprites, fileKind } from "./sprites.mjs";

const args = process.argv.slice(2);
const full = args.includes("--full");
// --dev: plus the dev classes (tools/dev/: hot reload, auto login), for tools/dev.mjs — never in a normal build.
const dev = args.includes("--dev");
const DEV_FILES = {
  "classes/dofus/dev/HotReload.as": join(ROOT, "tools", "dev", "HotReload.as"),
  "classes/dofus/dev/AutoLogin.as": join(ROOT, "tools", "dev", "AutoLogin.as"),
};
const sourceOf = (f) => DEV_FILES[f] ?? join(SRC, f);
const out = resolve(args.includes("--out") ? args[args.indexOf("--out") + 1] : join(ROOT, "build", "loader.swf"));
const cfg = config();
// Each build has its own work files (dev.mjs rebuilds in the background while you may build by hand),
// and the output appears in one rename: never half-written, never removed by another build.
const work = join(ROOT, ".tmp", `build-${process.pid}`);
const tmpOut = join(work, "loader.swf");
mkdirSync(work, { recursive: true });
process.on("exit", () => rmSync(work, { recursive: true, force: true }));
const publish = () => { renameSync(tmpOut, out); console.log(`\n${out}\nsha256 ${sha256(out)}`); };
const b = base(cfg.version);

// What changed since the base.
const files = sourceFiles(SRC);
const changed = (full ? files : files.filter((f) => b.manifest.files[f] !== sourceHash(join(SRC, f))))
  .concat(dev ? Object.keys(DEV_FILES) : []);
const removed = Object.keys(b.manifest.files).filter((f) => !existsSync(join(SRC, f)));
for (const f of removed) console.warn(`warning: ${f} was deleted — a build can't remove code, the base's stays`);

mkdirSync(dirname(out), { recursive: true });
const symbols = declaredSymbols();
const graphics = changedAssets(b.manifest);
const sprites = changedSprites(b.manifest);
if (changed.length === 0 && symbols.length === 0 && graphics.length === 0 && sprites.length === 0) {
  copyFileSync(b.loader, tmpOut);
  renameSync(tmpOut, out);
  console.log(`no change since base ${cfg.version}: ${out} is the base loader`);
  process.exit(0);
}

// Graphics: edited shapes / images re-imported, new ones added (tools/assets.mjs).
let input = b.loader;
if (graphics.length) {
  const withGraphics = join(work, "base-with-assets.swf");
  try {
    const added = applyAssets(cfg, b.loader, withGraphics, graphics, work);
    const n = graphics.filter((f) => !f.endsWith(".json")).length;
    if (n) console.log(`graphics: ${n} file${n > 1 ? "s" : ""} from src/assets/${added.length ? ` (new: ${added.join(", ")})` : ""}`);
  } catch (e) {
    console.error(`\ngraphics: ${e.message}`);
    process.exit(1);
  }
  input = withGraphics;
}

// Sprites, buttons, texts: edited ones re-encoded, new sprites (src/assets/new/<path>.json) added (tools/sprites.mjs).
const newSprites = graphics.filter((f) => f.endsWith(".json"));
if (sprites.length || newSprites.length) {
  const withSprites = join(work, "base-with-sprites.swf");
  try {
    const added = applySprites(input, withSprites, sprites, newSprites, b.loader);
    const edited = ["sprite", "button", "text"].map((k) => [k, sprites.filter((f) => fileKind(f) === k).length]).filter(([, n]) => n).map(([k, n]) => `${n} ${k}${n > 1 ? "s" : ""}`);
    console.log(`timeline: ${[edited.length ? `${edited.join(", ")} edited` : "", added.length ? `new sprites: ${added.join(", ")}` : ""].filter(Boolean).join("; ")}`);
  } catch (e) {
    console.error(`
sprites: ${e.message}`);
    process.exit(1);
  }
  input = withSprites;
}

// Clips the sources need and the base lacks: new classes, src/symbols.json (tools/symbols.mjs).
const classPath = (f) => f.slice("classes/".length, -".as".length).split("/").join(".");
const baseNames = changed.some((f) => f.startsWith("classes/")) || symbols.length ? exportNames(b.loader) : new Set();
const newClasses = changed.filter((f) => f.startsWith("classes/")).map(classPath).filter((c) => !baseNames.has(`__Packages.${c}`));
const newSymbols = symbols.filter((s) => !baseNames.has(s));
for (const s of symbols.filter((s) => baseNames.has(s))) console.warn(`warning: symbol ${s} (src/symbols.json) already exists in the base`);
if (newClasses.length || newSymbols.length) {
  const withAssets = input;
  input = join(work, "base-with-symbols.swf");
  mkdirSync(dirname(input), { recursive: true });
  writeFileSync(input, withSymbols(withAssets, newClasses, newSymbols));
  for (const c of newClasses) console.log(`new class ${c}`);
  for (const s of newSymbols) console.log(`new symbol ${s}`);
}
if (changed.length === 0) {
  copyFileSync(input, tmpOut);
  publish();
  process.exit(0);
}

// FFDec compiles a whole folder into the SWF, in its own layout: the changed files only.
const stage = join(work, "src");
rmSync(stage, { recursive: true, force: true });
// `_root` by name in what's compiled (lib.mjs rootByName): src/ stays as written.
for (const f of changed) {
  const to = join(stage, toFfdec(f));
  mkdirSync(dirname(to), { recursive: true });
  writeFileSync(to, rootByName(readFileSync(sourceOf(f), "utf8")));
}

console.log(`compiling ${changed.length} file${changed.length > 1 ? "s" : ""} into base ${cfg.version}${full ? " (full)" : ""}:`);
for (const f of changed.slice(0, 30)) console.log(`  ${f}`);
if (changed.length > 30) console.log(`  … ${changed.length - 30} more`);

const r = ffdec(cfg, ["-importScript", input, tmpOut, stage]);
const errors = compileErrors(r.log);
if (!r.ok || errors.length || !existsSync(tmpOut)) {
  console.error("\ncompile errors:");
  // FFDec names the staged file: show the one in src/.
  const shown = (e) => e.replace(/file: (.+)$/, (_, f) => {
    const rel = fromFfdec(relative(stage, f).split(sep).join("/"));
    return `file: ${DEV_FILES[rel] ? relative(ROOT, DEV_FILES[rel]) : `src/${rel}`}`;
  });
  for (const e of errors.length ? errors : [r.log.trim().split("\n").slice(-5).join("\n")]) console.error(`  ${shown(e)}`);
  process.exit(1);
}

// Preloaded `_root` / `_parent` registers: never more than the base (tools/deob/src/check-preload.ts).
const preload = (swf) => JSON.parse(execFileSync(process.execPath, [join(ROOT, "tools/deob/src/check-preload.ts"), swf], { encoding: "utf8" }));
const [pb, po] = [preload(b.loader), preload(tmpOut)];
if (po.root > pb.root || po.parent > pb.parent) {
  console.error(`\nfunctions reading _root/_parent from a preloaded register: base ${pb.root}/${pb.parent}, build ${po.root}/${po.parent} — ` +
    "in the loader these are the preloader's: write them so they compile by name (see rootByName in tools/lib.mjs)");
  process.exit(1);
}

// Accessors: only mismatches the base didn't have.
const mismatches = (swf) => {
  try { execFileSync(process.execPath, [join(ROOT, "tools/deob/src/check-accessors.ts"), swf], { encoding: "utf8" }); return []; }
  catch (e) { return String(e.stdout).split("\n").filter((l) => l.includes(": property")); }
};
const before = new Set(mismatches(b.loader));
const added = mismatches(tmpOut).filter((l) => !before.has(l));
if (added.length) {
  console.error("\naccessors that no longer match their property (rename the get/set or the property in the source):");
  for (const l of added) console.error(`  ${l}`);
  process.exit(1);
}
publish();
