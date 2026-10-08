/**
 * Whole pipeline:  node src/deob.ts <target.swf> --ref <reference __Packages> --out <dir> [--ffdec <jar>] [--passes 2]
 *
 *  1. clean      control flow: opaque predicates folded, dead code dropped   → <out>/clean.swf
 *  2. decompile  FFDec export of clean.swf                                    → <out>/pass0/
 *  3. match      names recovered against the reference sources                → <out>/names.json
 *  4. rename     names (+ `_o<hex>` placeholders) put in the bytecode         → <out>/deob.swf
 *  5. pass 2     match again on the readable export, rename again (optional)
 *  6. decompile  final readable sources                                       → <out>/scripts/
 *
 * `--extra <names.json>`: names found by hand, `{ "_o1b0d04": "myName", … }` (placeholder or
 * escaped raw key), applied on top — they win over the matcher.
 */
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseSwf, writeSwf, codeSites } from "./swf.ts";
import { cleanCode, type CleanStats } from "./clean.ts";
import { readClasses, isObf, PLACEHOLDER } from "./as2.ts";
import { match, paramKey, type Mapping } from "./match.ts";
import { renamer, renameSwf, plainNames, registrations, runnable, type RenameStats } from "./rename.ts";

const args = process.argv.slice(2);
const opt = (k: string, d?: string) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1]! : d; };
const target = args[0]!, ref = opt("--ref")!, out = opt("--out", "deob-out")!;
const ffdec = opt("--ffdec", process.env.FFDEC ?? "ffdec.jar")!;
const passes = Number(opt("--passes", "2"));
const extraFile = opt("--extra");
if (!target || !ref || !existsSync(target) || !existsSync(ref)) {
  console.error("usage: node src/deob.ts <target.swf> --ref <reference __Packages dir> --out <dir> [--ffdec <jar>] [--passes 1|2]");
  process.exit(2);
}
mkdirSync(out, { recursive: true });
const log = (s: string) => console.log(`[${new Date().toISOString().slice(11, 19)}] ${s}`);
const t0 = Date.now();

const decompile = (swf: string, dir: string) => {
  rmSync(dir, { recursive: true, force: true });
  log(`decompiling ${swf} (FFDec, a few minutes)…`);
  execFileSync("java", ["-jar", ffdec, "-export", "script", dir, swf], { stdio: ["ignore", "ignore", "pipe"], maxBuffer: 1 << 28 });
  return join(dir, "scripts", "__Packages");
};

// 1. Clean.
const swf = parseSwf(readFileSync(target));
const cs: CleanStats = { folded: 0, realBranches: 0, overlaps: 0, outside: 0 };
let failed = 0;
for (const site of codeSites(swf)) {
  try { site.replace(cleanCode(site.code, cs)); } catch (e) { failed++; log(`  not cleaned: ${site.where}: ${(e as Error).message}`); }
}
const cleanFile = join(out, "clean.swf");
writeFileSync(cleanFile, writeSwf(swf));
log(`clean: ${cs.folded} opaque predicates folded, ${cs.realBranches} real branches kept, ${failed} blocks left as is`);

// 2-5. Decompile, match, rename (twice by default: the second match sees readable code).
const refClasses = readClasses(ref);
const esc = (s: string) => JSON.stringify(s).slice(1, -1);
const names: Mapping = new Map();
/** Per-function parameter names, keyed on RAW class path + member (paramKey). */
const paramTable = new Map<string, string[]>();
let dir = decompile(cleanFile, join(out, "pass0"));
const deobFile = join(out, "deob.swf");
for (let pass = 1; pass <= passes; pass++) {
  const target = readClasses(dir);
  const r = match(refClasses, target);
  const taken = new Set([...names.values()].map((v) => v.name));
  let added = 0;
  for (const [k, v] of r.mapping) {
    // Placeholders of the previous pass stand for raw obfuscated bytes.
    const raw = PLACEHOLDER.test(k) ? Buffer.from(k.slice(2), "hex").toString("latin1") : k;
    if (!isObf(k) || names.has(raw) || taken.has(v.name)) continue;
    names.set(raw, v); taken.add(v.name); added++;
  }
  // The export matched may already be renamed (pass 2+): back to raw bytes for the keys.
  const inverse = new Map([...names].map(([raw, v]) => [v.name, raw]));
  const toRaw = (s: string) => PLACEHOLDER.test(s) ? Buffer.from(s.slice(2), "hex").toString("latin1") : inverse.get(s) ?? s;
  for (const [k, list] of r.params) {
    const [path, member, arity] = JSON.parse(k) as [string[], string, number];
    paramTable.set(paramKey(path.map(toRaw), toRaw(member), arity), list);
  }
  log(`match pass ${pass}: ${r.classes.size}/${target.length} classes paired, +${added} names (${names.size} in all), parameters of ${paramTable.size} functions`);
  if (extraFile) {
    for (const [k, name] of Object.entries(JSON.parse(readFileSync(extraFile, "utf8")) as Record<string, string>)) {
      const raw = PLACEHOLDER.test(k) ? Buffer.from(k.slice(2), "hex").toString("latin1") : JSON.parse(`"${k}"`) as string;
      for (const [o, v] of names) if (v.name === name && o !== raw) names.delete(o);   // a hand-given name is unique too
      names.set(raw, { name, votes: Infinity, total: Infinity });
    }
  }
  const fresh = parseSwf(readFileSync(cleanFile));
  const rs: RenameStats = { renamed: 0, placeholders: 0 };
  let paramHits = 0;
  renameSwf(fresh, renamer(new Map([...names].map(([k, v]) => [k, v.name])), rs), (path, member, arity) => {
    const list = paramTable.get(paramKey(path, member, arity)) ?? null;
    // A name still obfuscated (or a placeholder) in the list: leave that one to the global renamer.
    if (list) paramHits++;
    return list ? list.map((p) => (isObf(p) ? "" : p)) : null;
  });
  writeFileSync(deobFile, writeSwf(fresh));
  log(`rename: ${rs.renamed} strings renamed, ${rs.placeholders} placeholders, parameters named in ${paramHits} functions`);
  dir = decompile(deobFile, pass === passes ? join(out, "scripts") : join(out, `pass${pass}`));
}
// 7. A loader that still RUNS: no merged members, no renamed text (see `runnable`).
{
  const swf = parseSwf(readFileSync(cleanFile));
  const safe = runnable(new Map([...names].map(([k, v]) => [k, v.name])), plainNames(swf), registrations(swf));
  const rs: RenameStats = { renamed: 0, placeholders: 0 };
  renameSwf(swf, renamer(safe.mapping, rs, false), (path, member, arity) => {
    const list = paramTable.get(paramKey(path, member, arity)) ?? null;
    return list ? list.map((p) => (isObf(p) ? "" : p)) : null;
  });
  writeFileSync(join(out, "runnable.swf"), writeSwf(swf));
  log(`runnable: ${rs.renamed} strings renamed, ${safe.suffixed} names suffixed with "_", unknown ids kept → ${join(out, "runnable.swf")}`);
}
writeFileSync(join(out, "names.json"), JSON.stringify(Object.fromEntries(
  [...names].sort((a, b) => b[1].votes - a[1].votes).map(([k, v]) => [esc(k), v])), null, 1));
// 8. Static checks of runnable.swf (names.json must be written first).
try {
  execFileSync("node", [join(import.meta.dirname, "check-runnable.ts"), out], { stdio: "inherit" });
} catch { log("runnable.swf FAILS its checks — don't put it in a client (see above)"); }
log(`done in ${Math.round((Date.now() - t0) / 1000)} s — readable sources in ${join(out, "scripts")}, names in ${join(out, "names.json")}`);
