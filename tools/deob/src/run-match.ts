/** node src/run-match.ts <ref __Packages> <target __Packages> <out mapping.json> */
import { writeFileSync } from "node:fs";
import { readClasses, isObf } from "./as2.ts";
import { match } from "./match.ts";

const [refDir, tgtDir, out] = process.argv.slice(2);
const t0 = Date.now();
const ref = readClasses(refDir!), target = readClasses(tgtDir!);
const r = match(ref, target);
const obfIds = new Map<string, number>();
for (const c of target) for (const t of c.tokens) if (t.t === "id" && isObf(t.v)) obfIds.set(t.v, (obfIds.get(t.v) ?? 0) + 1);
const occ = [...obfIds].reduce((s, [, n]) => s + n, 0);
const occResolved = [...obfIds].filter(([k]) => r.mapping.has(k)).reduce((s, [, n]) => s + n, 0);
const confident = [...r.mapping.values()].filter((v) => v.votes >= 2 && v.votes / v.total >= 0.6).length;
console.log(r.rounds.map((x) => `round ${x.round}: ${x.classes} classes paired, ${x.resolved} names`).join("\n"));
console.log(`obfuscated ids: ${obfIds.size} distinct, ${occ} occurrences — named ${r.mapping.size} (${Math.round(100 * r.mapping.size / obfIds.size)} %), ${Math.round(100 * occResolved / occ)} % of occurrences; confident ${confident}`);
console.log(`classes: ${target.length} target, ${r.classes.size} paired — ${((Date.now() - t0) / 1000).toFixed(1)} s`);
const esc = (s: string) => JSON.stringify(s).slice(1, -1);
writeFileSync(out!, JSON.stringify({
  classes: [...r.classes].map(([t, rc]) => ({ target: t.path.map(esc).join("."), ref: rc.path.join(".") })),
  names: Object.fromEntries([...r.mapping].sort((a, b) => b[1].votes - a[1].votes).map(([k, v]) => [esc(k), v])),
}, null, 1));
