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
 * Library clips the sources need first: new classes, src/symbols.json
 * (tools/symbols.mjs). `_root` is compiled by name (lib.mjs rootByName). Then
 * checks that no function preloads `_root`, and that every accessor still carries its property's name (the
 * compiler rebuilds `addProperty` from accessor names: a mismatch registers
 * another property) — tools/deob/src/check-accessors.ts.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, relative, resolve, sep } from "node:path";
import { ROOT, SRC, base, compileErrors, config, ffdec, fromFfdec, rootByName, sha256, sourceFiles, sourceHash, toFfdec } from "./lib.mjs";
import { declaredSymbols, exportNames, withSymbols } from "./symbols.mjs";

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
const b = base(cfg.version);

// What changed since the base.
const files = sourceFiles(SRC);
const changed = (full ? files : files.filter((f) => b.manifest.files[f] !== sourceHash(join(SRC, f))))
  .concat(dev ? Object.keys(DEV_FILES) : []);
const removed = Object.keys(b.manifest.files).filter((f) => !existsSync(join(SRC, f)));
for (const f of removed) console.warn(`warning: ${f} was deleted — a build can't remove code, the base's stays`);

mkdirSync(dirname(out), { recursive: true });
const symbols = declaredSymbols();
if (changed.length === 0 && symbols.length === 0) {
  copyFileSync(b.loader, out);
  console.log(`no change since base ${cfg.version}: ${out} is the base loader`);
  process.exit(0);
}

// Clips the sources need and the base lacks: new classes, src/symbols.json (tools/symbols.mjs).
let input = b.loader;
const classPath = (f) => f.slice("classes/".length, -".as".length).split("/").join(".");
const baseNames = changed.some((f) => f.startsWith("classes/")) || symbols.length ? exportNames(b.loader) : new Set();
const newClasses = changed.filter((f) => f.startsWith("classes/")).map(classPath).filter((c) => !baseNames.has(`__Packages.${c}`));
const newSymbols = symbols.filter((s) => !baseNames.has(s));
for (const s of symbols.filter((s) => baseNames.has(s))) console.warn(`warning: symbol ${s} (src/symbols.json) already exists in the base`);
if (newClasses.length || newSymbols.length) {
  input = join(ROOT, ".tmp", "base-with-symbols.swf");
  mkdirSync(dirname(input), { recursive: true });
  writeFileSync(input, withSymbols(b.loader, newClasses, newSymbols));
  for (const c of newClasses) console.log(`new class ${c}`);
  for (const s of newSymbols) console.log(`new symbol ${s}`);
}
if (changed.length === 0) {
  copyFileSync(input, out);
  console.log(`\n${out}\nsha256 ${sha256(out)}`);
  process.exit(0);
}

// FFDec compiles a whole folder into the SWF, in its own layout: the changed files only.
const stage = join(ROOT, ".tmp", "build-src");
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

rmSync(out, { force: true });
const r = ffdec(cfg, ["-importScript", input, out, stage]);
const errors = compileErrors(r.log);
if (!r.ok || errors.length || !existsSync(out)) {
  console.error("\ncompile errors:");
  // FFDec names the staged file: show the one in src/.
  const shown = (e) => e.replace(/file: (.+)$/, (_, f) => {
    const rel = fromFfdec(relative(stage, f).split(sep).join("/"));
    return `file: ${DEV_FILES[rel] ? relative(ROOT, DEV_FILES[rel]) : `src/${rel}`}`;
  });
  for (const e of errors.length ? errors : [r.log.trim().split("\n").slice(-5).join("\n")]) console.error(`  ${shown(e)}`);
  rmSync(out, { force: true });
  process.exit(1);
}

// Preloaded `_root` / `_parent` registers: never more than the base (tools/deob/src/check-preload.ts).
const preload = (swf) => JSON.parse(execFileSync(process.execPath, [join(ROOT, "tools/deob/src/check-preload.ts"), swf], { encoding: "utf8" }));
const [pb, po] = [preload(b.loader), preload(out)];
if (po.root > pb.root || po.parent > pb.parent) {
  console.error(`\nfunctions reading _root/_parent from a preloaded register: base ${pb.root}/${pb.parent}, build ${po.root}/${po.parent} — ` +
    "in the loader these are the preloader's: write them so they compile by name (see rootByName in tools/lib.mjs)");
  rmSync(out, { force: true });
  process.exit(1);
}

// Accessors: only mismatches the base didn't have.
const mismatches = (swf) => {
  try { execFileSync(process.execPath, [join(ROOT, "tools/deob/src/check-accessors.ts"), swf], { encoding: "utf8" }); return []; }
  catch (e) { return String(e.stdout).split("\n").filter((l) => l.includes(": property")); }
};
const before = new Set(mismatches(b.loader));
const added = mismatches(out).filter((l) => !before.has(l));
if (added.length) {
  console.error("\naccessors that no longer match their property (rename the get/set or the property in the source):");
  for (const l of added) console.error(`  ${l}`);
  rmSync(out, { force: true });
  process.exit(1);
}
console.log(`\n${out}\nsha256 ${sha256(out)}`);
