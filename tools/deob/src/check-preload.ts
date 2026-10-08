/**
 * Functions that read `_root` / `_parent` from a preloaded register:
 *
 *   node tools/deob/src/check-preload.ts <file.swf>     → {"root":0,"parent":4,"global":0,"functions":11630}
 *
 * A DefineFunction2 can ask the player to preload `_root` into a register.
 * That register ignores `_lockroot`: in a SWF loaded by another one (the
 * Retro loader, loaded by preloader.swf) it's the OTHER movie's root, where
 * reading `_root` by name gives the loader's. Ankama's compiler never
 * preloads `_root`; FFDec's does — the build rewrites `_root` so it doesn't,
 * and compares these counts with the base's.
 */
import { readFileSync } from "node:fs";
import { parseSwf, codeSites } from "./swf.ts";
import { decode, OP, cstr } from "./avm1.ts";

const counts = { root: 0, parent: 0, global: 0, functions: 0 };
for (const site of codeSites(parseSwf(readFileSync(process.argv[2]!)))) {
  for (const a of decode(site.code)) {
    if (a.code !== OP.DefineFunction2) continue;
    counts.functions++;
    const p = cstr(a.body, 0)[1] + 3;                 // after the name, numParams (2) and registerCount (1)
    const hi = a.body[p]!, lo = a.body[p + 1]!;       // PreloadParent 0x80, PreloadRoot 0x40 | PreloadGlobal 0x01
    if (hi & 0x40) counts.root++;
    if (hi & 0x80) counts.parent++;
    if (lo & 0x01) counts.global++;
  }
}
console.log(JSON.stringify(counts));
