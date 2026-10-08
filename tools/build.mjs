/**
 * Builds the client's loader.swf from src/:
 *
 *   node tools/build.mjs [--full] [--out build/loader.swf]
 *
 * Only the files that differ from the base (base/<version>/manifest.json) are
 * compiled, into a copy of the base loader: the others keep the base's
 * bytecode, exactly. `--full` compiles every file (slower at runtime: the
 * compiler keeps the decompiled `_locN_` variables as named variables).
 *
 * Then checks that every accessor still carries its property's name (the
 * compiler rebuilds `addProperty` from accessor names: a mismatch registers
 * another property) — tools/deob/src/check-accessors.ts.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, existsSync, mkdirSync, rmSync } from "node:fs";
import { dirname, join, relative, resolve, sep } from "node:path";
import { ROOT, SRC, base, compileErrors, config, ffdec, fromFfdec, sha256, sourceFiles, sourceHash, toFfdec } from "./lib.mjs";

const args = process.argv.slice(2);
const full = args.includes("--full");
const out = resolve(args.includes("--out") ? args[args.indexOf("--out") + 1] : join(ROOT, "build", "loader.swf"));
const cfg = config();
const b = base(cfg.version);

// What changed since the base.
const files = sourceFiles(SRC);
const changed = full ? files : files.filter((f) => b.manifest.files[f] !== sourceHash(join(SRC, f)));
const removed = Object.keys(b.manifest.files).filter((f) => !existsSync(join(SRC, f)));
for (const f of removed) console.warn(`warning: ${f} was deleted — a build can't remove code, the base's stays`);

mkdirSync(dirname(out), { recursive: true });
if (changed.length === 0) {
  copyFileSync(b.loader, out);
  console.log(`no change since base ${cfg.version}: ${out} is the base loader`);
  process.exit(0);
}

// FFDec compiles a whole folder into the SWF, in its own layout: the changed files only.
const stage = join(ROOT, ".tmp", "build-src");
rmSync(stage, { recursive: true, force: true });
for (const f of changed) {
  const to = join(stage, toFfdec(f));
  mkdirSync(dirname(to), { recursive: true });
  copyFileSync(join(SRC, f), to);
}

console.log(`compiling ${changed.length} file${changed.length > 1 ? "s" : ""} into base ${cfg.version}${full ? " (full)" : ""}:`);
for (const f of changed.slice(0, 30)) console.log(`  ${f}`);
if (changed.length > 30) console.log(`  … ${changed.length - 30} more`);

rmSync(out, { force: true });
const r = ffdec(cfg, ["-importScript", b.loader, out, stage]);
const errors = compileErrors(r.log);
if (!r.ok || errors.length || !existsSync(out)) {
  console.error("\ncompile errors:");
  // FFDec names the staged file: show the one in src/.
  const shown = (e) => e.replace(/file: (.+)$/, (_, f) => `file: src/${fromFfdec(relative(stage, f).split(sep).join("/"))}`);
  for (const e of errors.length ? errors : [r.log.trim().split("\n").slice(-5).join("\n")]) console.error(`  ${shown(e)}`);
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
