/**
 * Non-regression tests for the sprites (docs/SPRITES.md): base loader →
 * src/timeline/sprites/…/sprite.json → final loader.
 *
 *   node tools/test-sprites.mjs        (~15 s)
 *
 * 1. inventory   one sprite.json per sprite of the base, as extracted from it,
 *                with the manifest's hash;
 * 2. codec       every sprite re-encoded: the base's bytes with its
 *                placements' kept, the same values encoded from scratch;
 * 3. identity    nothing edited: the loader keeps the base's bytes;
 * 4. move        the login logo moved: only its line's bytes change;
 * 5. new         new/<path>.json sprites placing a new graphic, a shape of the
 *                base and one another: exported, defined before use, drawn;
 * 6. errors      a typo, a wrong id, a cycle, two files of one name: refused, said where;
 * 7. new base    an edit carried over to a base whose ids changed: ids mapped,
 *                merged with Ankama's change, or a conflict when both change one line.
 */
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, SRC, base, config, ffdec } from "./lib.mjs";
import { applyAssets, assetHash } from "./assets.mjs";
import {
  SPRITES, applySprites, carrySprites, formatSprite, graphicHashes, library, readSprite, spriteFiles, spriteFolders,
  spriteHash, spriteIds, writeSprite,
} from "./sprites.mjs";
import { exportsOf, parseSwf, writeSwf } from "./deob/src/swf.ts";

const cfg = config();
const b = base(cfg.version);
const work = join(ROOT, ".tmp", "sprites-test");
rmSync(work, { recursive: true, force: true, maxRetries: 5 });
mkdirSync(work, { recursive: true });

let failed = 0, passed = 0;
function test(name, fn) {
  const t = Date.now();
  try {
    const notes = fn() ?? [];
    passed++;
    console.log(`ok    ${name} (${((Date.now() - t) / 1000).toFixed(1)} s)`);
    for (const n of notes) console.log(`        ${n}`);
  } catch (e) {
    failed++;
    console.log(`FAIL  ${name}\n        ${String(e.message ?? e).split("\n").join("\n        ")}`);
  }
}
function check(cond, msg) {
  if (!cond) throw new Error(msg);
}
function throws(fn, part, what) {
  let message = "";
  try { fn(); } catch (e) { message = e.message; }
  check(message.includes(part), `${what}: ${message ? `"${message}"` : "accepted"}, expected an error saying "${part}"`);
}

const baseSwf = parseSwf(readFileSync(b.loader));
const lib = library(baseSwf);
const spriteTag = (swf, id) => swf.tags.find((t) => t.code === 39 && t.data.readUInt16LE(0) === id);
const LOGIN = lib.byName.get("UI_Login");
const loginFile = `timeline/sprites/${spriteFolders(baseSwf).get(LOGIN)}/sprite.json`;

/** A copy of src/timeline/sprites/ (only the given files: applySprites reads those) to edit. */
function scratchSrc(name, files) {
  const dir = join(work, name);
  for (const f of files) { mkdirSync(join(dir, f, ".."), { recursive: true }); cpSync(join(SRC, f), join(dir, f)); }
  return dir;
}

test("inventory: one sprite.json per sprite, as extracted from the base", () => {
  const folders = spriteFolders(baseSwf);
  const files = new Set(spriteFiles());
  const problems = [];
  for (const [id, folder] of folders) {
    const f = `timeline/sprites/${folder}/sprite.json`;
    if (!files.has(f)) { problems.push(`sprite ${id}: no ${f}`); continue; }
    files.delete(f);
    if (readFileSync(join(SRC, f), "utf8").replace(/\r\n/g, "\n") !== formatSprite(readSprite(spriteTag(baseSwf, id).data, lib).json)) problems.push(`src/${f}: differs from the base (edited, or extracted by another version of tools/sprites.mjs)`);
    else if (b.manifest.sprites?.[f] !== spriteHash(join(SRC, f))) problems.push(`src/${f}: its hash isn't the manifest's (node tools/manifest.mjs ${cfg.version})`);
  }
  for (const f of files) problems.push(`src/${f}: no sprite of this id in the base`);
  check(!problems.length, problems.slice(0, 20).join("\n") + (problems.length > 20 ? `\n… ${problems.length - 20} more` : ""));
  return [`${folders.size} sprites`];
});

test("codec: every sprite re-encoded, the same bytes and values", () => {
  const ids = spriteIds(baseSwf);
  let scratchBytes = 0;
  const problems = [];
  for (const id of ids) {
    const tag = spriteTag(baseSwf, id);
    const was = readSprite(tag.data, lib);
    const json = JSON.parse(formatSprite(was.json));
    if (!writeSprite(id, json, lib, was, `sprite ${id}`).equals(tag.data)) problems.push(`sprite ${id}: re-encoded with its placements' bytes kept, differs`);
    // From scratch: no placement's bytes kept (clip actions still are: they're compiled code).
    const blank = { scripts: was.scripts, raws: was.raws.map((fr) => fr.map((r) => ({ ...r, o: { ...r.o, unmatched: true } }))) };
    const fresh = writeSprite(id, json, lib, blank, `sprite ${id}`);
    if (fresh.equals(tag.data)) scratchBytes++;
    if (JSON.stringify(readSprite(fresh, lib).json) !== JSON.stringify(was.json)) problems.push(`sprite ${id}: encoded from scratch, reads back different`);
  }
  check(!problems.length, problems.slice(0, 20).join("\n"));
  return [`${ids.length} sprites: all exact; ${scratchBytes} byte for byte even encoded from scratch (the rest: the same values, written in fewer bits)`];
});

test("identity: nothing edited, the base's bytes", () => {
  const out = join(work, "identity.swf");
  applySprites(b.loader, out, [], [], b.loader);
  check(readFileSync(out).equals(readFileSync(b.loader)), "the loader differs from the base");
});

test("move: the login logo 50 px to the right, only its line changes", () => {
  const src = scratchSrc("move", [loginFile]);
  const text = readFileSync(join(src, loginFile), "utf8");
  const line = text.split("\n").find((l) => l.includes('"shape": 901'));
  check(line, `${loginFile}: no placement of shape 901`);
  const x = JSON.parse(line.trim().replace(/,$/, "")).x;
  writeFileSync(join(src, loginFile), text.replace(line, line.replace(`"x": ${x},`, `"x": ${x + 50},`)));
  const out = join(work, "move.swf");
  applySprites(b.loader, out, [loginFile], [], b.loader, { src });
  const swf = parseSwf(readFileSync(out));
  const changed = swf.tags.map((t, i) => (t.data.equals(baseSwf.tags[i].data) ? -1 : i)).filter((i) => i >= 0);
  check(changed.length === 1 && swf.tags[changed[0]].code === 39 && swf.tags[changed[0]].data.readUInt16LE(0) === LOGIN, `changed tags: ${changed.join(", ")}`);
  const now = readSprite(swf.tags[changed[0]].data, lib), was = readSprite(spriteTag(baseSwf, LOGIN).data, lib);
  const logo = now.json.frames[0].place.find((o) => o.shape === 901);
  check(logo.x === x + 50, `logo at x ${logo.x}, expected ${x + 50}`);
  const others = now.raws[0].filter((r) => r.o.shape !== 901).map((r) => r.raw.toString("hex")).join();
  check(others === was.raws[0].filter((r) => r.o.shape !== 901).map((r) => r.raw.toString("hex")).join(), "other placements' bytes changed");
  return [`x ${x} → ${logo.x}`];
});

test("new: new/test/*.json sprites, exported, defined before use, drawn", () => {
  const assets = join(work, "new-assets");
  mkdirSync(join(assets, "new", "test"), { recursive: true });
  writeFileSync(join(assets, "new", "test", "Fond.svg"), '<svg xmlns="http://www.w3.org/2000/svg" width="60" height="40"><rect width="60" height="40" fill="#3366cc"/></svg>\n');
  // cadre places fenetre, written after it: the build orders them.
  writeFileSync(join(assets, "new", "test", "cadre.json"), formatSprite({ frames: [{ place: [{ depth: 1, export: "test/fenetre", x: 10, y: 10, scale: 2 }] }] }));
  writeFileSync(join(assets, "new", "test", "fenetre.json"), formatSprite({ frames: [{ place: [
    { depth: 1, export: "test/fond", x: 0, y: 0 },
    { depth: 2, shape: 901, x: 70, y: 0, scale: 0.25, alpha: 0.5 },
  ] }] }));
  const files = ["new/test/Fond.svg", "new/test/cadre.json", "new/test/fenetre.json"];
  const withGraphics = join(work, "new-graphics.swf"), out = join(work, "new.swf");
  applyAssets(cfg, b.loader, withGraphics, files, join(work, "new-work"), assets);
  const added = applySprites(withGraphics, out, [], files.filter((f) => f.endsWith(".json")), b.loader, { assets });
  check(added.join() === "test/cadre,test/fenetre", `added: ${added.join(", ")}`);
  const swf = parseSwf(readFileSync(out));
  const ids = new Map([...exportsOf(swf)].map(([id, n]) => [n, id]));
  for (const n of ["test/fond", "test/fenetre", "test/cadre"]) check(ids.has(n), `${n} not exported`);
  // Defined before use: each placed id is defined earlier in the file.
  const DEFINES = [2, 22, 32, 83, 46, 84, 11, 33, 37, 7, 34, 39, 60];
  const pos = new Map(swf.tags.filter((t) => DEFINES.includes(t.code)).map((t) => [t.data.readUInt16LE(0), swf.tags.indexOf(t)]));
  const lib2 = library(swf);
  for (const n of ["test/fenetre", "test/cadre"]) {
    for (const o of readSprite(spriteTag(swf, ids.get(n)).data, lib2).json.frames[0].place) {
      const ref = o.export ? ids.get(o.export) : o.shape;
      check(pos.get(ref) < pos.get(ids.get(n)), `${n} places ${o.export ?? o.shape}, defined after it`);
    }
  }
  const r = ffdec(cfg, ["-format", "sprite:png", "-selectid", String(ids.get("test/cadre")), "-export", "sprite", join(work, "new-render"), out]);
  // FFDec names the folder after the export, "/" as %2F.
  const png = join(work, "new-render", `DefineSprite_${ids.get("test/cadre")}_test%2Fcadre`, "1.png");
  check(r.ok && existsSync(png), `test/cadre not rendered by FFDec${existsSync(join(work, "new-render")) ? "" : ` (${r.log.trim().split("\n").pop()})`}`);
  return ["test/cadre places test/fenetre (test/fond + shape 901): rendered by FFDec"];
});

test("errors: refused, and said where", () => {
  const was = readSprite(spriteTag(baseSwf, LOGIN).data, lib);
  const json = (o) => ({ frames: [{ place: [{ depth: 1, ...o }] }] });
  throws(() => writeSprite(LOGIN, json({ shape: 901, scal: 2 }), lib, was, "f.json"), 'f.json, frame 1, place #1: unknown key "scal"', "a typo");
  throws(() => writeSprite(LOGIN, json({ shape: LOGIN }), lib, was, "f.json"), `${LOGIN} is a sprite, not a shape`, "a sprite's id as a shape");
  throws(() => writeSprite(LOGIN, json({ export: "Nope" }), lib, was, "f.json"), 'no symbol exported as "Nope"', "an unknown export");
  throws(() => writeSprite(LOGIN, json({ export: "Button", shape: 901 }), lib, was, "f.json"), "one of export, shape", "two things placed");
  throws(() => writeSprite(LOGIN, { frames: [{ place: [{ depth: 1, shape: 901, actions: true }] }] }, lib, null, "f.json"), "clip actions are compiled", "clip actions added");
  const assets = join(work, "errors-assets");
  mkdirSync(join(assets, "new"), { recursive: true });
  writeFileSync(join(assets, "new", "a.json"), formatSprite(json({ export: "b" })));
  writeFileSync(join(assets, "new", "b.json"), formatSprite(json({ export: "a" })));
  throws(() => applySprites(b.loader, join(work, "errors.swf"), [], ["new/a.json", "new/b.json"], b.loader, { assets }), "places itself", "a cycle");
  writeFileSync(join(assets, "new", "a.svg"), '<svg xmlns="http://www.w3.org/2000/svg" width="4" height="4"/>\n');
  throws(() => applyAssets(cfg, b.loader, join(work, "errors2.swf"), ["new/a.json", "new/a.svg"], join(work, "errors-work"), assets), 'both exported as "a"', "a.json and a.svg");
});

test("new base: an edit carried over, ids mapped, merged or in conflict", () => {
  // A "next base": shape 901 renumbered (as ids change between versions), and
  // Ankama moving another placement of UI_Login.
  const next = parseSwf(readFileSync(b.loader));
  const NEW_ID = 30001;
  check(!library(next).kinds.has(NEW_ID), `id ${NEW_ID} taken`);
  next.tags.find((t) => [2, 22, 32, 83].includes(t.code) && t.data.readUInt16LE(0) === 901).data.writeUInt16LE(NEW_ID, 0);
  const login = spriteTag(next, LOGIN);
  const original = readSprite(login.data, lib), theirs = original.json;
  const moved = theirs.frames[0].place.find((o) => o.depth === 5);
  moved.x += 3;
  for (const o of theirs.frames[0].place) if (o.shape === 901) o.shape = NEW_ID;
  const nextLib = library(next);
  nextLib.kinds.set(NEW_ID, "shape");
  login.data = writeSprite(LOGIN, theirs, nextLib, original, "next base");
  const nextFile = join(work, "next.swf");
  writeFileSync(nextFile, writeSwf(next));
  const graphics = graphicHashes(join(SRC, "assets"), assetHash);
  const nextGraphics = new Map(graphics);
  nextGraphics.set(NEW_ID, graphics.get(901));
  nextGraphics.delete(901);

  const run = (edit, name) => {
    const dir = join(work, name);
    const folder = spriteFolders(next, dir).get(LOGIN);
    mkdirSync(join(dir, folder), { recursive: true });
    writeFileSync(join(dir, folder, "sprite.json"), formatSprite(theirs));
    const mine = readSprite(spriteTag(baseSwf, LOGIN).data, lib).json;
    edit(mine.frames[0].place);
    const r = carrySprites([{ file: loginFile, text: formatSprite(mine) }], b.loader, nextFile, graphics, nextGraphics, dir);
    return { r, text: readFileSync(join(dir, folder, "sprite.json"), "utf8") };
  };
  // The logo moved: carried over, with its new id, and Ankama's own move kept.
  const a = run((p) => { p.find((o) => o.shape === 901).x += 50; }, "carry");
  check(a.r.carried.length === 1, `not carried: ${JSON.stringify(a.r)}`);
  const logo = JSON.parse(a.text).frames[0].place.find((o) => o.depth === 225);
  check(logo.shape === NEW_ID, `the logo places shape ${logo.shape}, expected ${NEW_ID} (its id in the next base)`);
  check(JSON.parse(a.text).frames[0].place.find((o) => o.depth === 5).x === moved.x, "Ankama's change lost");
  // Both moved depth 5: a conflict, with markers.
  const c = run((p) => { p.find((o) => o.depth === 5).x += 9; }, "conflict");
  check(c.r.conflicts.length === 1 && c.text.includes("<<<<<<< new base"), `no conflict: ${JSON.stringify(c.r)}`);
  return [`shape 901 → ${NEW_ID}; merged with Ankama's change; a conflict when both change the same placement`];
});

console.log(failed ? `\n${failed} test(s) failed` : `\nall ${passed} tests passed`);
process.exit(failed ? 1 : 0);
