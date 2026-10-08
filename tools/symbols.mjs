/**
 * What the build adds to the base before compiling: library symbols the
 * sources need and the SWF doesn't have.
 *
 * - **New classes.** A class lives in the SWF as an empty clip exported as
 *   `__Packages.<pkg>.<Class>`, whose DoInitAction holds its code. A file of
 *   `src/classes/` the base doesn't have gets such a clip (empty code: the
 *   compiler fills it), placed after the base's classes — its superclasses
 *   are defined by then.
 * - **Symbols** listed in `src/symbols.json`: `{ "UI_Hello": {} }` adds an
 *   empty clip exported as `UI_Hello` — what `loadUIComponent("Hello", …)`
 *   attaches (`"UI_" + name`); the class registered for it
 *   (`Object.registerClass` in DofusCore) builds its content by code.
 */
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { SRC } from "./lib.mjs";
import { parseSwf, writeSwf, exportsOf } from "./deob/src/swf.ts";

const TAG = { ShowFrame: 1, DefineSprite: 39, ExportAssets: 56, DoInitAction: 59 };
/** Tags whose data starts with a character id. */
const DEFINES = new Set([2, 6, 7, 10, 11, 14, 20, 21, 22, 32, 33, 34, 35, 36, 37, 39, 46, 48, 60, 75, 83, 84, 90, 91]);

/** src/symbols.json, or none. */
export function declaredSymbols() {
  const file = join(SRC, "symbols.json");
  return existsSync(file) ? Object.keys(JSON.parse(readFileSync(file, "utf8"))) : [];
}

/** Every export name of a SWF. */
export function exportNames(swfFile) {
  return new Set(exportsOf(parseSwf(readFileSync(swfFile))).values());
}

/**
 * The base with clips for these new classes (`dofus.graphics.gapi.ui.Hello`)
 * and symbols (`UI_Hello`). Returns the new SWF's bytes.
 */
export function withSymbols(baseFile, classes, symbols) {
  const swf = parseSwf(readFileSync(baseFile));
  const exported = new Set(exportsOf(swf).values());
  for (const name of [...classes.map((c) => `__Packages.${c}`), ...symbols])
    if (exported.has(name)) throw new Error(`${name} already exists in the base`);

  let nextId = 0;
  for (const t of swf.tags) if (DEFINES.has(t.code)) nextId = Math.max(nextId, t.data.readUInt16LE(0));
  const u16 = (n) => { const b = Buffer.alloc(2); b.writeUInt16LE(n); return b; };
  /** An empty one-frame clip, as the compiler writes class holders: id, 1 frame, End. */
  const sprite = (id) => ({ code: TAG.DefineSprite, data: Buffer.concat([u16(id), u16(1), u16(0)]) });
  const exportTag = (id, name) => ({ code: TAG.ExportAssets, data: Buffer.concat([u16(1), u16(id), Buffer.from(name + "\0", "latin1")]) });

  const added = [];
  for (const c of classes) {
    const id = ++nextId;
    added.push(sprite(id), exportTag(id, `__Packages.${c}`), { code: TAG.DoInitAction, data: Buffer.concat([u16(id), Buffer.from([0])]) });
  }
  for (const s of symbols) {
    const id = ++nextId;
    added.push(sprite(id), exportTag(id, s));
  }

  // After the base's last class: superclasses and the symbols' neighbours are defined.
  let at = -1;
  const names = exportsOf(swf);
  swf.tags.forEach((t, i) => {
    if (t.code === TAG.DoInitAction && names.get(t.data.readUInt16LE(0))?.startsWith("__Packages.")) at = i;
  });
  if (at < 0) at = swf.tags.findIndex((t) => t.code === TAG.ShowFrame) - 1;
  swf.tags.splice(at + 1, 0, ...added);
  return writeSwf(swf);
}
