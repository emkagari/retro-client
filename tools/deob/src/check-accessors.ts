/**
 * Accessors consistent with their registration, so that recompiling the
 * sources gives the same class:
 *
 *   node src/check-accessors.ts <file.swf>
 *
 * Every `addProperty("x", getter, setter)` must use `__get__x` / `__set__x`
 * (or a dummy function). Otherwise the decompiled class shows accessors of
 * another name, and the compiler — which builds `addProperty` from them —
 * registers a different property. Lists every mismatch; exit code 1 if any.
 */
import { readFileSync } from "node:fs";
import { parseSwf, codeSites, exportsOf } from "./swf.ts";
import { decode, readPool, readPush, OP, type Action } from "./avm1.ts";

const swf = parseSwf(readFileSync(process.argv[2]!));
const exported = exportsOf(swf);
const bad: string[] = [];
let total = 0;
for (const site of codeSites(swf)) {
  const acts = decode(site.code);
  let pool: string[] = [];
  const strs = (a: Action) => {
    if (a.code !== OP.Push) return null;
    try { return readPush(a).map((v) => (v.t === "str" ? v.v : v.t === "const" ? pool[v.v] ?? null : null)); } catch { return null; }
  };
  const member = (j: number) => {
    if (j < 1 || acts[j]!.code !== OP.GetMember) return null;
    const s = strs(acts[j - 1]!);
    return s ? s[s.length - 1] ?? null : null;
  };
  const dummy = (j: number) => acts[j]!.code === OP.DefineFunction || acts[j]!.code === OP.DefineFunction2;
  for (let i = 0; i < acts.length; i++) {
    if (acts[i]!.code === OP.ConstantPool) { pool = readPool(acts[i]!); continue; }
    if (acts[i]!.code !== OP.CallMethod || i < 5) continue;
    const call = strs(acts[i - 1]!);
    if (!call || call[call.length - 1] !== "addProperty") continue;
    const prop = call[call.length - 4];
    if (!prop) continue;
    const getter = dummy(i - 2) ? null : member(i - 2);
    const setter = dummy(i - 2) ? member(i - 3) : getter !== null ? member(i - 4) : null;
    total++;
    const cls = (site.spriteId !== null ? exported.get(site.spriteId) : undefined)?.replace("__Packages.", "") ?? site.where;
    if (getter !== null && getter !== `__get__${prop}`) bad.push(`${cls}: property "${prop}" — getter "${getter}"`);
    if (setter !== null && setter !== `__set__${prop}`) bad.push(`${cls}: property "${prop}" — setter "${setter}"`);
  }
}
for (const b of bad) console.log(b);
console.log(`${total} properties, ${bad.length} accessors named differently`);
process.exit(bad.length ? 1 : 0);
