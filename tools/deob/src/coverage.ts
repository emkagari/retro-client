/** node src/coverage.ts <run dir> — share of obfuscated names recovered (distinct and by occurrence). */
import { readClasses, isObf, PLACEHOLDER } from "./as2.ts";
import { join } from "node:path";
const run = process.argv[2]!;
const count = (dir: string, pred: (s: string) => boolean) => {
  const m = new Map<string, number>();
  for (const c of readClasses(dir)) for (const t of c.tokens) if (t.t === "id" && pred(t.v)) m.set(t.v, (m.get(t.v) ?? 0) + 1);
  return m;
};
const raw = count(join(run, "pass0/scripts/__Packages"), (s) => isObf(s));
const left = count(join(run, "scripts/scripts/__Packages"), (s) => PLACEHOLDER.test(s) || (isObf(s) && !s.startsWith("§§")));
const sum = (m: Map<string, number>) => [...m.values()].reduce((a, b) => a + b, 0);
const [d0, o0, d1, o1] = [raw.size, sum(raw), left.size, sum(left)];
console.log(`obfuscated at start: ${d0} distinct names, ${o0} occurrences`);
console.log(`still unnamed:      ${d1} distinct, ${o1} occurrences`);
console.log(`recovered:          ${(100 * (1 - d1 / d0)).toFixed(1)} % of distinct names, ${(100 * (1 - o1 / o0)).toFixed(1)} % of occurrences`);
