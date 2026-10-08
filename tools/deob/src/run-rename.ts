/** node src/run-rename.ts <in.swf> <mapping.json> <out.swf> [minVotes=1] */
import { readFileSync, writeFileSync } from "node:fs";
import { parseSwf, writeSwf } from "./swf.ts";
import { renamer, renameSwf, type RenameStats } from "./rename.ts";

const [input, mapFile, output, min] = process.argv.slice(2);
const json = JSON.parse(readFileSync(mapFile!, "utf8")) as { names: Record<string, { name: string; votes: number; total: number }> };
// Keys were written escaped (JSON inside JSON): decode them back to raw bytes.
const mapping = new Map<string, string>();
for (const [k, v] of Object.entries(json.names)) if (v.votes >= Number(min ?? 1)) mapping.set(JSON.parse(`"${k}"`), v.name);
const swf = parseSwf(readFileSync(input!));
const stats: RenameStats = { renamed: 0, placeholders: 0 };
renameSwf(swf, renamer(mapping, stats));
writeFileSync(output!, writeSwf(swf));
console.log(`${mapping.size} names in the table — ${stats.renamed} strings renamed, ${stats.placeholders} given a placeholder`);
