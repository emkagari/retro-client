/** node src/leftovers.ts <scripts __Packages> [top=40] — unnamed ids (`_o<hex>`) by frequency, with where they live. */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
const [dir, top] = process.argv.slice(2);
const count = new Map<string, { n: number; files: Set<string>; kinds: Set<string> }>();
const walk = (d: string) => {
  for (const e of readdirSync(d)) {
    const p = join(d, e);
    if (statSync(p).isDirectory()) { walk(p); continue; }
    if (!e.endsWith(".as")) continue;
    const src = readFileSync(p, "utf8");
    for (const m of src.matchAll(/(function |var |\.)?\b(_o(?:[0-9a-f]{2}){1,8})\b(\()?/g)) {
      const k = m[2]!;
      const c = count.get(k) ?? { n: 0, files: new Set(), kinds: new Set() };
      c.n++; c.files.add(relative(dir!, p));
      c.kinds.add(m[1] === "function " ? "method" : m[1] === "var " ? "field/var" : m[3] ? "call" : m[1] === "." ? "member" : "name");
      count.set(k, c);
    }
  }
};
walk(dir!);
const all = [...count].sort((a, b) => b[1].n - a[1].n);
console.log(`${all.length} unnamed ids, ${all.reduce((s, [, c]) => s + c.n, 0)} occurrences; files with the most:`);
const perFile = new Map<string, number>();
for (const [, c] of all) for (const f of c.files) perFile.set(f, (perFile.get(f) ?? 0) + 1);
console.log("  " + [...perFile].sort((a, b) => b[1] - a[1]).slice(0, 10).map(([f, n]) => `${f} (${n})`).join("\n  "));
console.log("most used:");
for (const [k, c] of all.slice(0, Number(top ?? 40))) console.log(`  ${k.padEnd(14)} ×${String(c.n).padEnd(4)} ${[...c.kinds].join("/").padEnd(18)} ${[...c.files].slice(0, 3).join(", ")}${c.files.size > 3 ? ", …" : ""}`);
