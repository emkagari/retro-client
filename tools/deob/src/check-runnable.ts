/**
 * Checks a renamed SWF before it goes into a client:
 *
 *   node src/check-runnable.ts <run dir> [<renamed.swf>]   (default <run>/runnable.swf)
 *
 * - every id of names.json is renamed EVERYWHERE: code (pools, pushes) and
 *   timeline (instance names, text variables, labels, clip actions) — one
 *   place left obfuscated and the code no longer finds what it names;
 * - no text renamed: the strings that aren't ids ("\n", ".\n"…) are the same
 *   number of times in clean.swf and in the renamed SWF;
 * - no merged names: no new name equals a name the clean SWF already uses in clear.
 *
 * Exit code 1 if a check fails. It doesn't replace a test in game.
 */
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { parseSwf, codeSites, type Swf } from "./swf.ts";
import { looksObfuscated, plainNames, renameTimeline } from "./rename.ts";
import { decode, readPool, readPush, OP } from "./avm1.ts";

const run = process.argv[2]!, file = process.argv[3] ?? join(run, "runnable.swf");
// The mapping the renamer applied (`<file>.names.json`, extra names included), else names.json.
const applied = file.replace(/\.swf$/, ".names.json");
const json = JSON.parse(readFileSync(existsSync(applied) ? applied : join(run, "names.json"), "utf8")) as Record<string, unknown>;
const ids = new Set(Object.keys(json).map((k) => JSON.parse(`"${k}"`) as string).filter(looksObfuscated));

/** Every string of the code and of the timeline, with its count. */
function strings(swf: Swf) {
  const code = new Map<string, number>(), timeline = new Map<string, number>();
  const add = (m: Map<string, number>, s: string) => m.set(s, (m.get(s) ?? 0) + 1);
  for (const site of codeSites(swf)) for (const a of decode(site.code)) {
    if (a.code === OP.ConstantPool) readPool(a).forEach((s) => add(code, s));
    else if (a.code === OP.Push) { try { for (const v of readPush(a)) if (v.t === "str") add(code, v.v); } catch { /* not a push */ } }
  }
  renameTimeline(swf, (s) => { add(timeline, s); return s; });
  return { code, timeline };
}

const clean = parseSwf(readFileSync(join(run, "clean.swf")));
const plain = plainNames(clean);
const before = strings(parseSwf(readFileSync(join(run, "clean.swf"))));
const after = strings(parseSwf(readFileSync(file)));
let failed = false;
const fail = (s: string) => { failed = true; console.log(`FAIL ${s}`); };

for (const [where, m] of [["code", after.code], ["timeline", after.timeline]] as const) {
  const left = [...m].filter(([s]) => ids.has(s));
  if (left.length) fail(`${where}: ${left.length} recognized ids left obfuscated, e.g. ${left.slice(0, 5).map(([s]) => JSON.stringify(s)).join(" ")}`);
  else console.log(`ok   ${where}: every recognized id renamed`);
}

// Text: strings that aren't ids must not move (the same count before and after).
const text = (m: Map<string, number>) => [...m].filter(([s]) => /[\x01-\x1f]/.test(s) && !ids.has(s) && !looksObfuscated(s));
const moved = text(before.code).filter(([s, n]) => (after.code.get(s) ?? 0) !== n);
if (moved.length) fail(`text renamed: ${moved.slice(0, 8).map(([s]) => JSON.stringify(s)).join(" ")}`);
else console.log(`ok   text strings with control characters untouched (${text(before.code).length})`);

// Merged names: a name the clean SWF already used in clear that now appears MORE often (an id was renamed into it).
const count = (x: { code: Map<string, number>; timeline: Map<string, number> }, s: string) => (x.code.get(s) ?? 0) + (x.timeline.get(s) ?? 0);
// Accessors excepted: `__get__value` in two classes are the same getter of two classes (or an override).
const merged = [...plain].filter((s) => !/^__(get|set)__/.test(s) && count(after, s) > count(before, s));
if (merged.length) fail(`${merged.length} ids renamed into a name already used in clear: ${merged.slice(0, 8).join(" ")}`);
else console.log(`ok   no new name collides with one used in clear`);

const total = (m: Map<string, number>) => [...m].reduce((n, [s, c]) => n + (looksObfuscated(s) ? c : 0), 0);
console.log(`     obfuscated strings in code: ${total(before.code)} → ${total(after.code)} (unknown ids keep their bytes)`);
process.exit(failed ? 1 : 0);
