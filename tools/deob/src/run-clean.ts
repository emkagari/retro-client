/** node src/run-clean.ts <in.swf> <out.swf> — control-flow cleaning of every code block. */
import { readFileSync, writeFileSync } from "node:fs";
import { parseSwf, writeSwf, codeSites } from "./swf.ts";
import { cleanCode, type CleanStats } from "./clean.ts";

const [input, output] = process.argv.slice(2);
const swf = parseSwf(readFileSync(input!));
const stats: CleanStats = { folded: 0, realBranches: 0, overlaps: 0, outside: 0 };
let before = 0, after = 0, failed = 0;
for (const site of codeSites(swf)) {
  try {
    const out = cleanCode(site.code, stats);
    before += site.code.length; after += out.length;
    site.replace(out);
  } catch (e) { failed++; console.error(`${site.where}: ${(e as Error).message}`); }
}
writeFileSync(output!, writeSwf(swf));
console.log(`code ${before} → ${after} bytes (${Math.round(100 * after / before)} %), predicates folded ${stats.folded}, real branches ${stats.realBranches}, overlapping reachable code ${stats.overlaps}, flow leaving its region ${stats.outside}, failed blocks ${failed}`);
