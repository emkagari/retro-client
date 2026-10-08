/**
 * Makes decompiled sources recompile to the same accessors:
 *
 *   node tools/deob/src/source-accessors.ts <loader.swf> <classes dir>
 *
 * <classes dir>: the folder of the packages (FFDec's `__Packages`, the repo's `src/classes`).
 *
 * The compiler builds `addProperty("x", __get__x, __set__x)` from `get x()` /
 * `set x()`. Where the SWF registers a property with accessors of another name
 * (ids the deobfuscator leaves alone: `"\t\n"`…), FFDec prints them as plain
 * methods — `function §\t\n§()`, `function __set__x(v)` — and a recompiled
 * class would lose the property. Rewrites them as `function get x()` /
 * `function set x(v)`, and the setter's `return this["\t\n"]();` as
 * `return this.x;`.
 */
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseSwf, exportsOf } from "./swf.ts";
import { registrations } from "./rename.ts";

const [swfFile, srcDir] = process.argv.slice(2);
if (!swfFile || !srcDir) { console.error("usage: node source-accessors.ts <loader.swf> <classes dir>"); process.exit(2); }
const swf = parseSwf(readFileSync(swfFile));
const exported = exportsOf(swf);

/** How FFDec prints a name: as is if it's an identifier, else between §, escaped. */
const printed = (s: string) => /^[A-Za-z_$][\w$]*$/.test(s) ? s
  : "§" + s.replace(/\\/g, "\\\\").replace(/\t/g, "\\t").replace(/\n/g, "\\n").replace(/\r/g, "\\r") + "§";
const quoted = (s: string) => JSON.stringify(s);

let fixed = 0;
const missing: string[] = [];
for (const r of registrations(swf)) {
  const cls = r.spriteId !== null ? exported.get(r.spriteId)?.replace("__Packages.", "") : undefined;
  if (!cls || !/^[A-Za-z_$][\w$]*$/.test(r.prop)) continue;
  const file = join(srcDir, ...cls.split(".")) + ".as";
  if (!existsSync(file)) continue;
  let src = readFileSync(file, "utf8");
  const before = src;
  for (const [fn, kind] of [[r.getter, "get"], [r.setter, "set"]] as const) {
    if (fn === null) continue;
    const syntax = `function ${kind} ${r.prop}(`;
    if (src.includes(syntax)) continue;
    // The accessor as FFDec printed it: under its own name, or as an unrecognized __get__/__set__ method.
    const forms = [`function ${printed(fn)}(`, `function __${kind}__${r.prop}(`];
    const form = forms.find((f) => src.includes(f));
    if (!form) { missing.push(`${cls}: ${kind} ${r.prop} (${JSON.stringify(fn)})`); continue; }
    src = src.replace(form, syntax);
    if (kind === "get" && fn !== `__get__${r.prop}`) src = src.replaceAll(`return this[${quoted(fn)}]();`, `return this.${r.prop};`);
  }
  if (src !== before) { writeFileSync(file, src); fixed++; console.log(`${cls}: accessors of ${r.prop}`); }
}
console.log(`${fixed} classes rewritten${missing.length ? `; not found: ${missing.join(" | ")}` : ""}`);
