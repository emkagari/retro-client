/**
 * node src/reclean.ts <in.swf> <out.swf> — a loader already deobfuscated (a
 * runnable.swf, a base) cleaned again by the current rules of clean.ts: when
 * a rule is added, an installed base needn't go through deob.ts again.
 *
 * Every block (DoAction, DoInitAction, clip and button actions) that comes
 * out shorter is replaced; the others keep their bytes — clean code cleaned
 * again may come out laid out in another order, the same code.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { parseSwf, writeSwf, codeSites, namedTags, TAG } from "./swf.ts";
import { cleanCode, type CleanStats } from "./clean.ts";
import { clipActionsAt, mapButtonActions, mapClipActions } from "./rename.ts";

const [input, output] = process.argv.slice(2);
if (!input || !output) { console.error("usage: node src/reclean.ts <in.swf> <out.swf>"); process.exit(2); }
const swf = parseSwf(readFileSync(input));
const stats: CleanStats = { folded: 0, realBranches: 0, overlaps: 0, outside: 0 };
let blocks = 0, saved = 0;
/** The block cleaned again when that makes it shorter, else as it was. */
const shorter = (code: Buffer) => {
  const out = cleanCode(code, stats);
  if (out.length >= code.length) return code;
  blocks++; saved += code.length - out.length;
  return out;
};

for (const site of codeSites(swf)) {
  const out = shorter(site.code);
  if (out !== site.code) site.replace(out);
}
// Clip and button actions: in the timeline, after the code (a sprite's tags are read again).
for (const { tag, replace } of namedTags(swf)) {
  if (tag.code === TAG.DefineButton2) {
    const d = mapButtonActions(tag.data, shorter);
    if (d && !d.equals(tag.data)) replace(d);
  } else {
    const at = clipActionsAt(tag);
    if (at < 0) continue;
    const actions = mapClipActions(tag.data.subarray(at), swf.version, shorter);
    if (!actions.equals(tag.data.subarray(at))) replace(Buffer.concat([tag.data.subarray(0, at), actions]));
  }
}
writeFileSync(output, writeSwf(swf));
console.log(`${blocks} block(s) cleaned again, ${saved} bytes of dead code removed`);
