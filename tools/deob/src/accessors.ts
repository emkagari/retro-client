/**
 * Names AS2 accessors from their registration, not from a reference:
 *
 *   node src/accessors.ts <run dir> [--out <run>/accessors.json]
 *
 * The compiler turns `get value()` / `set value(v)` into two methods,
 * `__get__value` / `__set__value`, and registers them at the end of the class:
 *
 *   Push r1, "<setter>"  GetMember   (or a dummy function: no setter)
 *   Push r1, "<getter>"  GetMember   (or a dummy function: no getter)
 *   Push "value", 3, r1, "addProperty"  CallMethod
 *
 * The property name stays readable (other files read it), so each obfuscated
 * getter/setter gets its real name. Writes an `--extra` file (escaped raw
 * keys), including CORRECTIONS of matcher names that contradict it
 * (`__set__data` named `data`).
 */
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseSwf, codeSites } from "./swf.ts";
import { decode, readPool, readPush, OP, type Action } from "./avm1.ts";
import { looksObfuscated } from "./rename.ts";

const run = process.argv[2]!;
const args = process.argv.slice(3);
const out = args.includes("--out") ? args[args.indexOf("--out") + 1]! : join(run, "accessors.json");
const json = JSON.parse(readFileSync(join(run, "names.json"), "utf8")) as Record<string, { name: string }>;
const known = new Map(Object.entries(json).map(([k, v]) => [JSON.parse(`"${k}"`) as string, v.name]));
const swf = parseSwf(readFileSync(join(run, "clean.swf")));

/** obfuscated string → every name the registrations give it (accessor, or property). */
const seen = new Map<string, Set<string>>();
const note = (raw: string, name: string) => {
  if (!looksObfuscated(raw)) return;
  (seen.get(raw) ?? seen.set(raw, new Set()).get(raw)!).add(name);
};

for (const site of codeSites(swf)) {
  const acts = decode(site.code);
  let pool: string[] = [];
  /** Strings pushed by an action (constants resolved), or null. */
  const strs = (a: Action): (string | null)[] | null => {
    if (a.code !== OP.Push) return null;
    try { return readPush(a).map((v) => (v.t === "str" ? v.v : v.t === "const" ? pool[v.v] ?? null : null)); } catch { return null; }
  };
  for (let i = 0; i < acts.length; i++) {
    const a = acts[i]!;
    if (a.code === OP.ConstantPool) { pool = readPool(a); continue; }
    if (a.code !== OP.CallMethod || i < 5) continue;
    const call = strs(acts[i - 1]!);
    if (!call || call.length < 4 || call[call.length - 1] !== "addProperty") continue;
    // The arguments: name, 3 — the rest of this push (obj, "addProperty") is the call.
    const raw = readPush(acts[i - 1]!);
    const count = raw[raw.length - 3];
    if (!count || !("v" in count) || Number(count.v) !== 3) continue;
    let prop = call[call.length - 4];
    if (!prop) continue;
    // Getter: `Push r, "<getter>"` `GetMember` just before; setter: the pair before that.
    const member = (j: number) => {
      if (j < 1 || acts[j]!.code !== OP.GetMember) return null;
      const s = strs(acts[j - 1]!);
      return s ? s[s.length - 1] ?? null : null;
    };
    // Write-only property: a dummy function stands for the getter, the setter is right above it.
    const dummy = (j: number) => acts[j]!.code === OP.DefineFunction || acts[j]!.code === OP.DefineFunction2;
    const getter = dummy(i - 2) ? null : member(i - 2);
    const setter = dummy(i - 2) ? member(i - 3) : getter !== null ? member(i - 4) : null;
    if (looksObfuscated(prop)) {
      // An obfuscated property whose getter or setter stayed readable (`__get__renderer`) names it.
      const readable = [getter, setter].map((x) => (x && !looksObfuscated(x) ? /^__[gs]et__(.+)$/.exec(x)?.[1] : undefined)).find(Boolean);
      // Else the matcher may have named an accessor after its property (`function classID(n)` is `set classID`).
      const fromMatcher = [getter, setter].map((x) => (x && looksObfuscated(x) ? known.get(x) : undefined))
        .find((n) => n !== undefined && !/^__[gs]et__/.test(n));
      const inferred = readable ?? (known.has(prop) ? undefined : fromMatcher);
      const name = inferred ?? known.get(prop);
      if (!name) continue;
      if (inferred) note(prop, inferred);
      prop = name;
    }
    if (getter) note(getter, `__get__${prop}`);
    if (setter) note(setter, `__set__${prop}`);
  }
}

const esc = (s: string) => JSON.stringify(s).slice(1, -1);
const extra: Record<string, string> = {};
let fresh = 0, fixed = 0, same = 0, ambiguous = 0;
for (const [raw, set] of seen) {
  if (set.size !== 1) { ambiguous++; continue; }       // the obfuscator maps one name to one string: never happens
  const name = [...set][0]!;
  const had = known.get(raw);
  if (had === name) { same++; continue; }
  if (had) fixed++; else fresh++;
  extra[esc(raw)] = name;
}
writeFileSync(out, JSON.stringify(extra, null, 1));
console.log(`accessors: ${seen.size} obfuscated getters/setters — ${fresh} newly named, ${fixed} matcher names corrected, ${same} already right, ${ambiguous} ambiguous → ${out}`);
