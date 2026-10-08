/** node src/quality.ts <scripts __Packages> [<ref __Packages>] — how readable a decompiled export is. */
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
const [dir, refDir] = process.argv.slice(2);
const files: string[] = [];
const walk = (d: string) => { for (const e of readdirSync(d)) { const p = join(d, e); statSync(p).isDirectory() ? walk(p) : e.endsWith(".as") && files.push(p); } };
walk(dir!);
let cls = 0, stack = 0, ph = 0, invalid = 0, lines = 0, same = 0, compared = 0;
for (const f of files) {
  const s = readFileSync(f, "utf8").replace(/\r/g, "");
  if (/^\s*(class|interface) /m.test(s)) cls++;
  stack += (s.match(/§§(push|pop)/g) ?? []).length;
  ph += (s.match(/\b_o[0-9a-f]{2,16}\b/g) ?? []).length;
  invalid += (s.match(/\\x[01][0-9a-f]|§[^§\n]{1,8}§/g) ?? []).length;
  if (refDir) {
    const r = join(refDir, relative(dir!, f));
    if (existsSync(r)) {
      compared++;
      const a = s.split("\n").map((x) => x.trim()).filter(Boolean), b = new Set(readFileSync(r, "utf8").replace(/\r/g, "").split("\n").map((x) => x.trim()));
      lines += a.length; same += a.filter((x) => b.has(x)).length;
    }
  }
}
console.log(`${files.length} files, ${cls} real classes, §§push/pop ${stack}, placeholder names ${ph}, still-obfuscated names ${invalid}` +
  (refDir ? ` | ${compared} files found at the same path in the reference, ${Math.round(100 * same / lines)} % of their lines identical to it` : ""));
