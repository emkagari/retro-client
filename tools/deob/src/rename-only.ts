/**
 * Re-renames an existing run without redoing it: parameters (per function)
 * on top of the run's names.json.
 *
 *   node src/rename-only.ts <run dir> --ref <reference __Packages> [--out <run dir>/deob.swf] [--ffdec <jar>] [--no-decompile] [--runnable] [--extra <names.json>[,…]]
 *
 * Needs <run>/clean.swf, <run>/names.json and <run>/pass0 (the raw export:
 * its names are the raw bytes the parameter keys need). Decompiles the result
 * into <run>/scripts.
 */
import { execFileSync } from "node:child_process";
import { readFileSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseSwf, writeSwf } from "./swf.ts";
import { readClasses, isObf } from "./as2.ts";
import { match, paramKey } from "./match.ts";
import { renamer, renameSwf, plainNames, registrations, runnable, type RenameStats } from "./rename.ts";

const args = process.argv.slice(2);
const opt = (k: string, d?: string) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1]! : d; };
const run = args[0]!, ref = opt("--ref")!;
const out = opt("--out", join(run, "deob.swf"))!;
const ffdec = opt("--ffdec", process.env.FFDEC ?? "ffdec.jar")!;
const log = (s: string) => console.log(`[${new Date().toISOString().slice(11, 19)}] ${s}`);

const json = JSON.parse(readFileSync(join(run, "names.json"), "utf8")) as Record<string, { name: string }>;
const names = new Map(Object.entries(json).map(([k, v]) => [JSON.parse(`"${k}"`) as string, v.name]));
// --extra <file>[,<file>…]: names given by hand or by accessors.ts; they win, and stay unique.
for (const file of (opt("--extra") ?? "").split(",").filter(Boolean)) {
  const extra = JSON.parse(readFileSync(file, "utf8")) as Record<string, string>;
  for (const [k, name] of Object.entries(extra)) {
    const raw = /^_o[0-9a-f]+$/.test(k) ? Buffer.from(k.slice(2), "hex").toString("latin1") : JSON.parse(`"${k}"`) as string;
    for (const [o, v] of names) if (v === name && o !== raw) names.delete(o);
    names.set(raw, name);
  }
  log(`${Object.keys(extra).length} names from ${file}`);
}
log(`${names.size} names from ${join(run, "names.json")}; matching the raw export for parameters…`);
const r = match(readClasses(ref), readClasses(join(run, "pass0", "scripts", "__Packages")));
// The matcher pairs a class's members by their bodies, names unknown: look-alike
// members (setters of one line, `this._x = v`) get paired by chance, and one's
// parameters named after another's. A member whose final name its reference
// class has (same kind, same arity) takes that member's parameters instead
// (an accessor named __set__x here is `function set x` in the reference).
let by_name = 0;
for (const [target_class, reference_class] of r.classes) for (const member of target_class.members) {
  if (!member.kind.endsWith("function") || !member.params.length) continue;
  const name = (names.get(member.name) ?? member.name).replace(/^__[gs]et__/, "");
  const same = reference_class.members.filter((m) => m.kind === member.kind && m.name === name && m.params.length === member.params.length);
  if (same.length !== 1) continue;
  const key = paramKey(target_class.path, member.name, member.params.length);
  const list = member.params.map((p, k) => (isObf(p) && !isObf(same[0]!.params[k]!) ? same[0]!.params[k]! : p));
  if (JSON.stringify(r.params.get(key)) !== JSON.stringify(list)) by_name++;
  r.params.set(key, list);
}
log(`parameters of ${r.params.size} functions (${by_name} taken from the reference member of the same name)`);

const swf = parseSwf(readFileSync(join(run, "clean.swf")));
// --runnable: a loader that must still run (see `runnable`); unknown ids keep their bytes.
const run_ = args.includes("--runnable");
const safe = run_ ? runnable(names, plainNames(swf), registrations(swf)) : { mapping: names, suffixed: 0 };
// The mapping really applied (extra names included): check-runnable.ts checks against it.
writeFileSync(out.replace(/\.swf$/, ".names.json"), JSON.stringify(Object.fromEntries([...safe.mapping].map(([k, v]) => [JSON.stringify(k).slice(1, -1), v])), null, 1));
if (run_) log(`${names.size - safe.mapping.size} non-ids dropped, ${safe.suffixed} names already used in clear suffixed with "_"`);
const rs: RenameStats = { renamed: 0, placeholders: 0 };
let hits = 0, named = 0;
const tl = renameSwf(swf, renamer(safe.mapping, rs, !run_), (path, member, arity) => {
  const list = r.params.get(paramKey(path, member, arity)) ?? null;
  if (!list) return null;
  hits++;
  return list.map((p) => (isObf(p) ? "" : (named++, p)));
});
writeFileSync(out, writeSwf(swf));
log(`timeline: ${tl.renamed} tags renamed (instance names, text variables, labels, clip actions), ${tl.skipped} skipped`);
log(`rename: ${rs.renamed} strings renamed, ${rs.placeholders} placeholders, ${named} parameters named in ${hits} functions → ${out}`);

if (run_) {
  try { execFileSync("node", [join(import.meta.dirname, "check-runnable.ts"), run, out], { stdio: "inherit" }); }
  catch { log(`${out} FAILS its checks — don't put it in a client`); process.exit(1); }
}
if (run_ || args.includes("--no-decompile")) process.exit(0);
const dir = join(run, "scripts");
rmSync(dir, { recursive: true, force: true });
log("decompiling (FFDec, a few minutes)…");
execFileSync("java", ["-jar", ffdec, "-export", "script", dir, out], { stdio: ["ignore", "ignore", "pipe"], maxBuffer: 1 << 28 });
log(`done — readable sources in ${dir}`);
