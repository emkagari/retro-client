/**
 * Names the ids a run left unnamed from the previous sources, line by line:
 *
 *   node src/align.ts <run dir> --ref <previous sources: src/classes> [--out <run>/aligned.json]
 *
 * A line of the new export holding an unnamed id (`_o1b0302`) is looked up in
 * the same file of the previous sources: a line with the same tokens but at
 * the unnamed id's place gives the name there; failing that, the one line of
 * the same shape (every identifier blanked). Every such line must agree.
 * Most leftovers are names the previous version already had (by-role names,
 * setter parameters, clip names…).
 *
 * A name already present in the new code is dropped: the obfuscator reuses an
 * id for different members across classes, and taking that name would merge
 * two members into one. Those stay unnamed (or get a new name by role).
 * Writes an `--extra` file (`{ "_o1b0302": "nStringCourseLevel" }`) for
 * accessors.ts and rename-only.ts.
 */
import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";

const args = process.argv.slice(2);
const opt = (k: string) => (args.includes(k) ? args[args.indexOf(k) + 1] : undefined);
const run = args[0]!, ref = opt("--ref");
if (!run || !ref) { console.error("usage: node src/align.ts <run dir> --ref <previous src/classes> [--out <file>]"); process.exit(2); }
const out = opt("--out") ?? join(run, "aligned.json");
const scripts = join(run, "scripts", "scripts", "__Packages");

const walk = (d: string): string[] => readdirSync(d, { withFileTypes: true })
  .flatMap((e) => (e.isDirectory() ? walk(join(d, e.name)) : e.name.endsWith(".as") ? [join(d, e.name)] : []));
const read = (f: string) => readFileSync(f, "utf8").replace(/\r\n/g, "\n");
const TOKEN = /[A-Za-z_$][\w$]*|\S/g;
const ID = /^[A-Za-z_$][\w$]*$/;
const LEFTOVER = /^_o[0-9a-f]{2,}$/;
const shape = (tokens: string[]) => tokens.map((t) => (ID.test(t) ? "#" : t)).join(" ");

const present = new Set<string>();
const votes = new Map<string, Map<string, number>>();
const disagree = new Set<string>();
for (const file of walk(scripts)) {
  const text = read(file);
  for (const t of text.match(TOKEN) ?? []) if (ID.test(t) && !LEFTOVER.test(t)) present.add(t);
  if (!/\b_o[0-9a-f]{2,}\b/.test(text)) continue;
  const old = join(ref, relative(scripts, file));
  if (!existsSync(old)) continue;
  const byShape = new Map<string, string[][]>();
  for (const line of read(old).split("\n")) {
    const tokens = line.match(TOKEN) ?? [];
    const key = shape(tokens);
    if (!byShape.has(key)) byShape.set(key, []);
    byShape.get(key)!.push(tokens);
  }
  for (const line of text.split("\n")) {
    const tokens = line.match(TOKEN) ?? [];
    if (!tokens.some((t) => LEFTOVER.test(t))) continue;
    const sameShape = byShape.get(shape(tokens)) ?? [];
    // Same line but the unnamed ids; else the only line of that shape.
    const exact = sameShape.filter((c) => c.every((x, i) => LEFTOVER.test(tokens[i]!) || x === tokens[i]));
    const candidates = exact.length ? exact : sameShape.length === 1 ? sameShape : [];
    tokens.forEach((t, i) => {
      if (!LEFTOVER.test(t)) return;
      const names = new Set(candidates.map((c) => c[i]!).filter((n) => !LEFTOVER.test(n)));
      if (names.size > 1) { disagree.add(t); return; }
      const [name] = names;
      if (!name) return;
      const v = votes.get(t) ?? new Map<string, number>();
      v.set(name, (v.get(name) ?? 0) + 1);
      votes.set(t, v);
    });
  }
}

const aligned: Record<string, string> = {}, taken: Record<string, string> = {};
for (const [id, v] of votes) {
  if (disagree.has(id) || v.size !== 1) continue;
  const [name] = v.keys();
  if (present.has(name!)) taken[id] = name!;
  else aligned[id] = name!;
}
writeFileSync(out, JSON.stringify(aligned, null, 1));
console.log(`align: ${Object.keys(aligned).length} ids named from ${ref} → ${out}`);
if (Object.keys(taken).length)
  console.log(`  ${Object.keys(taken).length} left unnamed, their name is already in the code: ${Object.entries(taken).map(([k, n]) => `${k} (${n})`).join(", ")}`);
