/**
 * A character keeps its id from one base to the next (docs/UPGRADING.md).
 * Ankama's compiler numbers characters in order: one added near the start
 * shifts every id after it, and with them the files of src/assets/ and
 * src/timeline/ — 1.49.8 renamed 9 000 files that way. So a new base is
 * renumbered before anything is extracted from it: each character takes the
 * id it had in the previous base, found by
 *
 *   1. its export name;
 *   2. where a character found shows it (a sprite's frame and depth, a
 *      button's record, a text's font, a shape's bitmap), and so on down;
 *   3. its content, ids aside (unique among those left);
 *   4. its place among the definitions, between two characters found;
 *
 * and a new one takes an id no base used before. What refers to an id
 * (placements, bitmap fills, fonts, exports, #initclip…) follows; every other
 * byte stays.
 *
 *   node tools/ids.mjs <previous base loader> <loader> --out <renumbered.swf> [--map ids.json]
 *
 * ids.json: each id of <loader> (the runnable, the official client's) that
 * changed, and its id in the renumbered one.
 */
import { createHash } from "node:crypto";
import { readFileSync, writeFileSync } from "node:fs";
import { basename } from "node:path";
import { parseSwf, writeSwf } from "./deob/src/swf.ts";
import { BitReader, context, innerTags, mapRefs, readCxform, readFilters, readMatrix, readObject } from "./sprites.mjs";

// Definitions, their id first, by group: a character may change tag within its group (a shape drawn with more features).
const GROUP = {};
for (const c of [2, 22, 32, 83]) GROUP[c] = "shape";
for (const c of [46, 84]) GROUP[c] = "morph";
for (const c of [6, 21, 35, 90, 20, 36]) GROUP[c] = "image";
for (const c of [11, 33]) GROUP[c] = "static text";
GROUP[37] = "text field";
for (const c of [7, 34]) GROUP[c] = "button";
GROUP[39] = "sprite";
for (const c of [10, 48, 75, 91]) GROUP[c] = "font";
GROUP[14] = "sound";
GROUP[60] = "video";
GROUP[87] = "binary";
// Tags about a character, its id first: font info, align zones, font name, text settings, scaling grid,
// #initclip, button colours, video frame, sound start, place / remove (SWF 1).
const ABOUT = new Set([13, 62, 73, 88, 74, 78, 59, 23, 61, 15, 4, 5]);
// Tags holding ids this file doesn't read: refused rather than left pointing elsewhere.
const UNREAD = { 17: "DefineButtonSound", 57: "ImportAssets", 71: "ImportAssets2" };

const sha = (...parts) => { const h = createHash("sha256"); for (const p of parts) h.update(p); return h.digest("hex"); };
const skipRect = (d, p) => { const r = new BitReader(d, p); const n = r.u(5); for (let i = 0; i < 4; i++) r.u(n); return r.pos; };
const skipMatrix = (d, p) => { const r = new BitReader(d, p); readMatrix(r); return r.pos; };

// --- Where a tag holds ids ---------------------------------------------------

/** A fill style (morph: start and end), its bitmap's id noted. Returns where it ends. */
function fillStyle(d, p, version, morph, sites) {
  const type = d[p++];
  if (type === 0) return p + (morph ? 8 : version >= 3 ? 4 : 3);
  if (type === 0x10 || type === 0x12 || type === 0x13) {
    p = skipMatrix(d, p);
    if (morph) p = skipMatrix(d, p);
    const n = d[p++] & 0x0f;
    p += n * (morph ? 10 : version >= 3 ? 5 : 4);
    return p + (type === 0x13 ? (morph ? 4 : 2) : 0);
  }
  if (type >= 0x40 && type <= 0x43) {
    sites.push({ at: p, key: `bitmap ${sites.length}` });
    p = skipMatrix(d, p + 2);
    return morph ? skipMatrix(d, p) : p;
  }
  throw new Error(`fill style type ${type}`);
}

/** A shape's (or a morph's) fill and line styles. Returns where they end. */
function styles(d, p, version, morph, sites) {
  let n = d[p++];
  if (n === 0xff && (version >= 2 || morph)) { n = d.readUInt16LE(p); p += 2; }
  for (let i = 0; i < n; i++) p = fillStyle(d, p, version, morph, sites);
  n = d[p++];
  if (n === 0xff) { n = d.readUInt16LE(p); p += 2; }
  for (let i = 0; i < n; i++) {
    p += morph ? 4 : 2;                                   // width(s)
    if (version < 4) { p += morph ? 8 : version >= 3 ? 4 : 3; continue; }
    const join = (d[p] >> 4) & 3, fill = d[p] & 0x08;     // LINESTYLE2: caps, join, fill…
    p += 2 + (join === 2 ? 2 : 0);
    p = fill ? fillStyle(d, p, version, morph, sites) : p + (morph ? 8 : 4);
  }
  return p;
}

/** DefineShape 1-4: its bitmap fills, in its styles and in the new styles of its records. */
function shapeSites(code, d, sites) {
  const version = { 2: 1, 22: 2, 32: 3, 83: 4 }[code];
  let p = skipRect(d, 2);
  if (version === 4) p = skipRect(d, p) + 1;              // edge bounds, flags
  p = styles(d, p, version, false, sites);
  let fillBits = d[p] >> 4, lineBits = d[p] & 15;
  let r = new BitReader(d, p + 1);
  for (;;) {
    if (r.u(1)) {                                         // an edge
      const straight = r.u(1), n = r.u(4) + 2;
      if (!straight) { r.u(n); r.u(n); r.u(n); r.u(n); } else if (r.u(1)) { r.u(n); r.u(n); } else { r.u(1); r.u(n); }
      continue;
    }
    const f = r.u(5);
    if (!f) break;
    if (f & 1) { const n = r.u(5); r.u(n); r.u(n); }
    if (f & 2) r.u(fillBits);
    if (f & 4) r.u(fillBits);
    if (f & 8) r.u(lineBits);
    if (f & 16) {                                         // new styles, byte-aligned
      p = styles(d, r.pos, version, false, sites);
      fillBits = d[p] >> 4; lineBits = d[p] & 15;
      r = new BitReader(d, p + 1);
    }
  }
  if (r.pos !== d.length) throw new Error(`${d.length - r.pos} bytes after the records`);
}

/** DefineMorphShape 1-2: bitmap fills, in its styles only (its records hold no new style). */
function morphSites(code, d, sites) {
  let p = skipRect(d, skipRect(d, 2));
  if (code === 84) p = skipRect(d, skipRect(d, p)) + 1;
  styles(d, p + 4, code === 84 ? 4 : 3, true, sites);
}

/** A sprite's placements: the id each places, by frame and depth (the n-th at that depth in that frame). */
function spriteSites(d, sites) {
  let frame = 1;
  const seen = new Map();
  for (const t of innerTags(d)) {
    const at = t.data.byteOffset - d.byteOffset;
    if (t.code === 1) { frame++; seen.clear(); continue; }
    if (t.code === 26 || t.code === 70) {
      const f = t.data[0], f2 = t.code === 70 ? t.data[1] : 0;
      if (f2 & 0x18) throw new Error("PlaceObject3 with a class name");
      if (!(f & 2)) continue;
      const head = t.code === 70 ? 2 : 1, depth = t.data.readUInt16LE(head);
      const n = (seen.get(depth) ?? 0) + 1;
      seen.set(depth, n);
      sites.push({ at: at + head + 2, key: `${frame}:${depth}:${n}` });
    } else if (t.code === 4 || t.code === 5 || t.code === 15) sites.push({ at, key: `${frame}:${t.code}:${sites.length}` });
    else if (UNREAD[t.code]) throw new Error(`${UNREAD[t.code]} in a sprite`);
  }
}

/** A button's records: what each shows. */
function buttonSites(code, d, sites) {
  let p = code === 34 ? 5 : 2;
  while (d[p]) {
    const f = d[p++];
    sites.push({ at: p, key: `record ${sites.length}` });
    p = skipMatrix(d, p + 4);
    if (code === 34) {
      const r = new BitReader(d, p); readCxform(r); p = r.pos;
      if (f & 0x10) p += readFilters(d, p).length;
      if (f & 0x20) p++;
    }
  }
}

/** A static text's runs: their fonts. */
function textSites(code, d, sites) {
  const r = new BitReader(d, skipRect(d, 2));
  readMatrix(r);
  let p = r.pos;
  const bits = d[p] + d[p + 1];
  p += 2;
  while (d[p]) {
    const f = d[p++];
    if (f & 0x08) { sites.push({ at: p, key: `font ${sites.length}` }); p += 2; }
    if (f & 0x04) p += code === 33 ? 4 : 3;
    if (f & 0x01) p += 2;
    if (f & 0x02) p += 2;
    if (f & 0x08) p += 2;
    p += 1 + Math.ceil((d[p] * bits) / 8);
  }
}

/**
 * Where a tag holds character ids: { def: its own id is at 0, sites: [{ at, key }] }
 * — each id it refers to (`at`: its offset in the tag's data; `key`: what
 * it is to the tag, the same from one version to the next: "3:225:1",
 * frame 3, depth 225).
 */
export function idSites(tag) {
  const d = tag.data, sites = [];
  if (UNREAD[tag.code]) throw new Error(`${UNREAD[tag.code]} (tag ${tag.code}) holds ids this tool doesn't read`);
  if (ABOUT.has(tag.code)) return { def: false, sites: [{ at: 0, key: "of" }] };
  if (tag.code === 56) {                                  // ExportAssets: count, (id, name)…
    let p = 2;
    for (let i = 0; i < d.readUInt16LE(0); i++) { sites.push({ at: p, key: `export ${i}` }); p = d.indexOf(0, p + 2) + 1; }
    return { def: false, sites };
  }
  const group = GROUP[tag.code];
  if (!group) return { def: false, sites };
  try {
    if (group === "shape") shapeSites(tag.code, d, sites);
    else if (group === "morph") morphSites(tag.code, d, sites);
    else if (group === "sprite") spriteSites(d, sites);
    else if (group === "button") buttonSites(tag.code, d, sites);
    else if (group === "static text") textSites(tag.code, d, sites);
    else if (group === "text field") {
      const p = skipRect(d, 2), f = d.readUInt16BE(p);
      if (f & 0x0080) throw new Error("a font class (SWF 9+)");
      if (f & 0x0100) sites.push({ at: p + 2, key: "font" });
    }
  } catch (e) {
    throw new Error(`${group} ${d.readUInt16LE(0)}: ${e.message}`);
  }
  return { def: true, sites };
}

// --- Renumbering ---------------------------------------------------------------

/** The SWF with each id `map` holds changed (a definition's and every reference to it); the other bytes as they were. */
export function renumber(swf, map) {
  const ids = new Set();
  const tags = swf.tags.map((t) => {
    const { def, sites } = idSites(t);
    if (!def && !sites.length) return t;
    const data = Buffer.from(t.data);
    const set = (at) => { const id = data.readUInt16LE(at); if (map.has(id)) data.writeUInt16LE(map.get(id), at); };
    if (def) {
      set(0);
      if (ids.has(data.readUInt16LE(0))) throw new Error(`two characters numbered ${data.readUInt16LE(0)}`);
      ids.add(data.readUInt16LE(0));
    }
    for (const s of sites) set(s.at);
    return { code: t.code, data };
  });
  return { ...swf, tags };
}

// --- Finding each character in the previous base ------------------------------

/** A SWF's characters: id → { group, sites, index (its place among the definitions) }, and their order. */
function characters(swf) {
  const chars = new Map(), order = [];
  for (const t of swf.tags) {
    const { def, sites } = idSites(t);
    if (!def) continue;
    const id = t.data.readUInt16LE(0);
    chars.set(id, { tag: t, group: GROUP[t.code], sites: sites.map((s) => ({ ...s, id: t.data.readUInt16LE(s.at) })), index: order.length });
    order.push(id);
  }
  return { chars, order };
}

/**
 * Each character's fingerprint: what it is, ids aside. Shapes, images, fonts…:
 * their bytes, each id they refer to replaced by its fingerprint; sprites,
 * buttons, texts: their JSON (tools/sprites.mjs) the same way, not their
 * scripts (their bytecode changes with every version).
 */
function fingerprints(swf, chars) {
  const ctx = context(swf);
  const fps = new Map(), busy = new Set();
  const fp = (id) => {
    if (fps.has(id)) return fps.get(id);
    const c = chars.get(id);
    if (!c) return `none:${id}`;
    if (busy.has(id)) return `cycle:${id}`;
    busy.add(id);
    let h;
    if (["sprite", "button", "static text", "text field"].includes(c.group)) {
      try { h = sha(c.group, JSON.stringify(mapRefs(readObject(c.tag, ctx).json, fp))); } catch { /* bytes */ }
    }
    if (!h) {
      const data = Buffer.from(c.tag.data);
      data.writeUInt16LE(0, 0);
      for (const s of c.sites) data.writeUInt16LE(0, s.at);
      h = sha(c.group, data, ...c.sites.map((s) => fp(s.id)));
    }
    busy.delete(id);
    fps.set(id, h);
    return h;
  };
  for (const id of chars.keys()) fp(id);
  return fps;
}

/**
 * Each character of `swf` (a new base) → its id in `previous` (the previous
 * base), or a new id: one above any `previous` holds. Returns { map, found
 * (how many by each way), added, removed }.
 */
export function keepIds(previous, swf) {
  const P = characters(previous), N = characters(swf);
  const pairs = new Map(), taken = new Set();            // new id → previous id; previous ids paired
  const found = { name: 0, place: 0, content: 0, order: 0 };
  const queue = [];
  const pair = (n, p, how) => {
    if (pairs.has(n) || taken.has(p)) return false;
    const a = N.chars.get(n), b = P.chars.get(p);
    if (!a || !b || a.group !== b.group) return false;
    pairs.set(n, p); taken.add(p); found[how]++; queue.push(n);
    return true;
  };
  // Down from each character found: what it shows, by its key there.
  const descend = () => {
    while (queue.length) {
      const n = queue.shift(), p = pairs.get(n);
      const theirs = new Map(P.chars.get(p).sites.map((s) => [s.key, s.id]));
      for (const s of N.chars.get(n).sites) if (theirs.has(s.key)) pair(s.id, theirs.get(s.key), "place");
    }
  };

  // 1. Export names.
  const exported = (swf) => {
    const out = new Map();
    for (const t of swf.tags) if (t.code === 56) for (const s of idSites(t).sites) out.set(t.data.toString("latin1", s.at + 2, t.data.indexOf(0, s.at + 2)), t.data.readUInt16LE(s.at));
    return out;
  };
  const before = exported(previous);
  for (const [name, n] of exported(swf)) if (before.has(name)) pair(n, before.get(name), "name");
  descend();

  for (let progress = true; progress;) {
    progress = false;
    // 3. Content, among those left: a fingerprint only one of each side holds.
    const left = (side, paired) => [...side.chars.keys()].filter((id) => !paired.has(id));
    const fpN = fingerprints(swf, N.chars), fpP = fingerprints(previous, P.chars);
    const unique = (ids, fps) => {
      const by = new Map();
      for (const id of ids) by.set(fps.get(id), by.has(fps.get(id)) ? null : id);
      return by;
    };
    const uN = unique(left(N, pairs), fpN), uP = unique(left(P, taken), fpP);
    for (const [h, n] of uN) if (n !== null && uP.get(h) != null && pair(n, uP.get(h), "content")) progress = true;
    descend();
    // 4. Order: a run of characters left between two found, as many on each side, of the same groups, in the same order.
    const at = (side, i) => side.order[i];
    let i = 0;
    while (i < N.order.length) {
      if (pairs.has(at(N, i))) { i++; continue; }
      let j = i;
      while (j < N.order.length && !pairs.has(at(N, j))) j++;
      const lo = i > 0 ? P.chars.get(pairs.get(at(N, i - 1))).index : -1;
      const hi = j < N.order.length ? P.chars.get(pairs.get(at(N, j))).index : P.order.length;
      const run = N.order.slice(i, j), theirs = P.order.slice(lo + 1, Math.max(lo + 1, hi)).filter((id) => !taken.has(id));
      if (lo < hi && run.length === theirs.length && run.every((n, k) => N.chars.get(n).group === P.chars.get(theirs[k]).group)) {
        run.forEach((n, k) => { if (pair(n, theirs[k], "order")) progress = true; });
      }
      i = j;
    }
    descend();
  }

  // New characters: ids no base held (the previous base's ids include every earlier base's kept ones).
  let next = Math.max(0, ...P.chars.keys());
  const map = new Map(), added = [];
  for (const n of N.order) {
    if (pairs.has(n)) map.set(n, pairs.get(n));
    else { map.set(n, ++next); added.push(next); }
  }
  if (next > 65535) throw new Error("no id left: more than 65535 characters");
  const removed = P.order.filter((p) => !taken.has(p));
  return { map, found, added, removed };
}

/** ids.json: the ids that changed, the loader's → the base's. */
export const idsJson = (map) => JSON.stringify(Object.fromEntries([...map].filter(([a, b]) => a !== b).sort((x, y) => x[0] - y[0])), null, 1) + "\n";

/** What keepIds found, in a line. */
export const describe = (r) =>
  `ids: ${[...r.map.values()].length - r.added.length} kept (${Object.entries(r.found).map(([k, v]) => `${v} by ${k}`).join(", ")}), ` +
  `${r.added.length} new${r.added.length ? ` (${r.added.join(", ")})` : ""}, ${r.removed.length} gone${r.removed.length ? ` (${r.removed.join(", ")})` : ""}`;

if (process.argv[1] && import.meta.url.endsWith(basename(process.argv[1]))) {
  const args = process.argv.slice(2);
  const opt = (k) => (args.includes(k) ? args[args.indexOf(k) + 1] : undefined);
  const [previous, loader] = args;
  if (!previous || !loader || !opt("--out")) {
    console.error("usage: node tools/ids.mjs <previous base loader> <loader> --out <renumbered.swf> [--map ids.json]");
    process.exit(2);
  }
  const swf = parseSwf(readFileSync(loader));
  const r = keepIds(parseSwf(readFileSync(previous)), swf);
  writeFileSync(opt("--out"), writeSwf(renumber(swf, r.map)));
  if (opt("--map")) writeFileSync(opt("--map"), idsJson(r.map));
  console.log(describe(r));
}
