/**
 * The loader's sprites, buttons and texts as files (docs/SPRITES.md).
 *
 *   src/timeline/sprites/<id>[_<Export>]/sprite.json   every sprite of the base loader: what it places, frame by frame
 *   src/timeline/buttons/<id>[_<Export>]/button.json   every button: what it shows in each state
 *   src/timeline/texts/<id>.json                       every text: a field's settings, a static text's runs
 *   src/assets/new/<path>.json                         a new sprite, exported by its path in
 *                                                      lower case (like new graphics: "ui/panel")
 *
 *   node tools/sprites.mjs extract        src/timeline/… ← the base loader
 *   node tools/sprites.mjs where <what>   where a shape, sprite… is placed: 901, shapes/901, UI_Login
 *
 * A sprite.json lists its frames; each frame what it removes (depths), its
 * label, and what it places or moves:
 *
 *   { "frames": [
 *     { "place": [
 *       { "depth": 225, "shape": 901, "x": 341.4, "y": 234.2, "scale": 0.59999 },
 *       { "depth": 249, "export": "TextInput", "name": "_tiAccount", "x": 60, "y": 238, "actions": true }
 *     ] },
 *     { "label": "open", "remove": [7], "place": [{ "depth": 3, "move": true, "x": 120 }] }
 *   ] }
 *
 * What is placed: "export" (an exported symbol, by name) or "shape" / "sprite"
 * / "text" / "button" / "morph" / "video" with the base's id. Numbers come
 * back exact: a scale is written with the digits that give its 16.16 value
 * back. Frame scripts and clip actions ("actions": true) are compiled from
 * the frame_N/ scripts next to it, as before.
 *
 * The build re-encodes only the sprite.json that differ from the base
 * (base/<version>/manifest.json, `sprites`); in those, a placement left as it
 * was keeps its bytes.
 */
import { spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, SRC, base, config } from "./lib.mjs";
import { ASSETS, assetFiles, exportName } from "./assets.mjs";
import { exportsOf, parseSwf, writeSwf } from "./deob/src/swf.ts";

export const SPRITES = join(SRC, "timeline", "sprites");
export const SPRITE_FILE = "sprite.json";

const KIND = {};
for (const c of [2, 22, 32, 83]) KIND[c] = "shape";
for (const c of [46, 84]) KIND[c] = "morph";
for (const c of [11, 33, 37]) KIND[c] = "text";
for (const c of [7, 34]) KIND[c] = "button";
for (const c of [6, 21, 35, 20, 36, 90]) KIND[c] = "image";
KIND[39] = "sprite";
for (const c of [10, 48, 75]) KIND[c] = "font";
KIND[60] = "video";
const REF_KEYS = ["export", "shape", "sprite", "text", "button", "morph", "video"];
const BLEND = [null, "normal", "layer", "multiply", "screen", "lighten", "darken", "difference", "add", "subtract", "invert", "alpha", "erase", "overlay", "hardlight"];
const FILTERS = ["dropShadow", "blur", "glow", "bevel", null, null, "colorMatrix"];
const PLACE_KEYS = new Set(["depth", "move", ...REF_KEYS, "name", "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "ratio", "mask", "blend", "filters", "actions"]);
const FRAME_KEYS = new Set(["label", "anchor", "remove", "place"]);

/** A sprite.json's hash, line endings aside. */
export const spriteHash = (file) => createHash("sha256").update(readFileSync(file, "utf8").replace(/\r\n/g, "\n")).digest("hex");

// --- Bits -------------------------------------------------------------------

class BitReader {
  constructor(buf, at) { this.buf = buf; this.bit = at * 8; }
  u(n) { let v = 0; for (let i = 0; i < n; i++, this.bit++) v = v * 2 + ((this.buf[this.bit >> 3] >> (7 - (this.bit & 7))) & 1); return v; }
  s(n) { const v = this.u(n); return n && v >= 2 ** (n - 1) ? v - 2 ** n : v; }
  get pos() { return Math.ceil(this.bit / 8); }
}
class BitWriter {
  constructor() { this.bits = []; }
  u(n, v) { for (let i = n - 1; i >= 0; i--) this.bits.push(Math.floor(v / 2 ** i) & 1); return this; }
  s(n, v) { return this.u(n, v < 0 ? 2 ** n + v : v); }
  bytes() {
    const out = Buffer.alloc(Math.ceil(this.bits.length / 8));
    this.bits.forEach((b, i) => { if (b) out[i >> 3] |= 0x80 >> (i & 7); });
    return out;
  }
}
/** Bits a signed value needs (0: none). */
const sbits = (...vals) => Math.max(0, ...vals.map((v) => (v === 0 ? 0 : v > 0 ? v.toString(2).length + 1 : v === -1 ? 1 : (-v - 1).toString(2).length + 1)));

// --- Exact decimals ---------------------------------------------------------

/** The shortest decimal that gives `v` back once multiplied by `unit` and rounded. */
function exact(v, unit) {
  for (let p = 1; p <= 17; p++) {
    const n = Number((v / unit).toPrecision(p));
    if (Math.round(n * unit) === v) return n;
  }
  return v / unit;
}
const fixed = (v) => exact(v, 65536);       // 16.16
const fixed8 = (v) => exact(v, 256);        // 8.8
const byteUnit = (v) => exact(v, 255);      // 0-255 as 0-1
/** The shortest decimal that gives a float32 back. */
function float32(v) {
  for (let p = 1; p <= 9; p++) { const n = Number(v.toPrecision(p)); if (Math.fround(n) === v) return n; }
  return v;
}
const hex2 = (n) => n.toString(16).padStart(2, "0");

// --- Matrix -----------------------------------------------------------------

function readMatrix(r) {
  const m = { a: 65536, b: 0, c: 0, d: 65536 };
  if (r.u(1)) { const n = r.u(5); m.a = r.s(n); m.d = r.s(n); }
  if (r.u(1)) { const n = r.u(5); m.b = r.s(n); m.c = r.s(n); }
  const n = r.u(5); m.tx = r.s(n); m.ty = r.s(n);
  return m;
}
function writeMatrix(m) {
  const w = new BitWriter();
  if (m.a !== 65536 || m.d !== 65536) { const n = sbits(m.a, m.d); w.u(1, 1).u(5, n).s(n, m.a).s(n, m.d); } else w.u(1, 0);
  if (m.b || m.c) { const n = sbits(m.b, m.c); w.u(1, 1).u(5, n).s(n, m.b).s(n, m.c); } else w.u(1, 0);
  const n = sbits(m.tx, m.ty);
  w.u(5, n).s(n, m.tx).s(n, m.ty);
  return w.bytes();
}
const DEG = Math.PI / 180;
/** a, b, c, d from a scale and a rotation (degrees): the one formula both ways. */
const rotated = (sx, sy, deg) => ({
  a: Math.round(sx * Math.cos(deg * DEG) * 65536), b: Math.round(sx * Math.sin(deg * DEG) * 65536),
  c: Math.round(-sy * Math.sin(deg * DEG) * 65536), d: Math.round(sy * Math.cos(deg * DEG) * 65536),
});
/** A matrix as JSON fields: x, y, then scale / scaleX + scaleY, rotation, or the raw matrix. */
function matrixFields(m) {
  const o = { x: m.tx / 20, y: m.ty / 20 };
  if (!m.b && !m.c) {
    if (m.a === m.d) { if (m.a !== 65536) o.scale = fixed(m.a); } else { o.scaleX = fixed(m.a); o.scaleY = fixed(m.d); }
    return o;
  }
  // A rotation (with a flip or not): the fewest decimals that give the matrix back.
  const sx = Math.hypot(m.a, m.b) / 65536, sy = (m.a * m.d - m.b * m.c) / 65536 / 65536 / sx, deg = Math.atan2(m.b, m.a) / DEG;
  for (let p = 1; p <= 8; p++) {
    const X = Number(sx.toFixed(p)), Y = Number(sy.toFixed(p)), R = Number(deg.toFixed(p));
    const r = rotated(X, Y, R);
    if (r.a === m.a && r.b === m.b && r.c === m.c && r.d === m.d) {
      if (X === Y) { if (X !== 1) o.scale = X; } else { o.scaleX = X; o.scaleY = Y; }
      o.rotation = R;
      return o;
    }
  }
  o.matrix = [fixed(m.a), fixed(m.b), fixed(m.c), fixed(m.d)];
  return o;
}
function fieldsMatrix(o, where) {
  const m = { tx: Math.round((o.x ?? 0) * 20), ty: Math.round((o.y ?? 0) * 20) };
  if (o.matrix) {
    if (!Array.isArray(o.matrix) || o.matrix.length !== 4) throw new Error(`${where}: "matrix" is [a, b, c, d]`);
    [m.a, m.b, m.c, m.d] = o.matrix.map((v) => Math.round(v * 65536));
    return m;
  }
  const sx = o.scaleX ?? o.scale ?? 1, sy = o.scaleY ?? o.scale ?? 1;
  if (o.rotation) return { ...m, ...rotated(sx, sy, o.rotation) };
  return { ...m, a: Math.round(sx * 65536), b: 0, c: 0, d: Math.round(sy * 65536) };
}
const hasMatrix = (o) => ["x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix"].some((k) => k in o);

// --- Colour transform -------------------------------------------------------

function readCxform(r) {
  const hasAdd = r.u(1), hasMult = r.u(1), n = r.u(4);
  const cx = {};
  if (hasMult) cx.mult = [r.s(n), r.s(n), r.s(n), r.s(n)];
  if (hasAdd) cx.add = [r.s(n), r.s(n), r.s(n), r.s(n)];
  return cx;
}
function writeCxform(cx) {
  const vals = [...(cx.mult ?? []), ...(cx.add ?? [])];
  const n = Math.max(1, sbits(...vals));
  const w = new BitWriter().u(1, cx.add ? 1 : 0).u(1, cx.mult ? 1 : 0).u(4, n);
  for (const v of vals) w.s(n, v);
  return w.bytes();
}
function cxformFields(cx) {
  if (cx.mult && !cx.add && cx.mult[0] === 256 && cx.mult[1] === 256 && cx.mult[2] === 256) return { alpha: fixed8(cx.mult[3]) };
  const color = {};
  if (cx.mult) color.mult = cx.mult.map(fixed8);
  if (cx.add) color.add = cx.add;
  return { color };
}
function fieldsCxform(o, where) {
  if ("alpha" in o) return { mult: [256, 256, 256, Math.round(o.alpha * 256)] };
  const cx = {};
  for (const k of Object.keys(o.color)) if (k !== "mult" && k !== "add") throw new Error(`${where}: "color" has "mult" and / or "add", not "${k}"`);
  if (o.color.mult) cx.mult = o.color.mult.map((v) => Math.round(v * 256));
  if (o.color.add) cx.add = o.color.add.map((v) => Math.round(v));
  return cx;
}

// --- Filters ----------------------------------------------------------------

const rgba = (b, at) => ({ color: `#${hex2(b[at])}${hex2(b[at + 1])}${hex2(b[at + 2])}`, alpha: byteUnit(b[at + 3]) });
function putRgba(f, prefix = "") {
  const c = f[prefix ? `${prefix}Color` : "color"], a = f[prefix ? `${prefix}Alpha` : "alpha"] ?? 1;
  if (!/^#[0-9a-f]{6}$/i.test(c ?? "")) throw new Error(`filter ${f.type}: "${prefix ? `${prefix}Color` : "color"}" is "#rrggbb"`);
  return Buffer.from([parseInt(c.slice(1, 3), 16), parseInt(c.slice(3, 5), 16), parseInt(c.slice(5, 7), 16), Math.round(a * 255)]);
}
const i32 = (v) => { const b = Buffer.alloc(4); b.writeInt32LE(v); return b; };
const i16 = (v) => { const b = Buffer.alloc(2); b.writeInt16LE(v); return b; };
/** Inner / knockout / composite / (onTop) / passes, as JSON fields. */
function flagFields(byte, onTop) {
  const o = {};
  if (byte & 0x80) o.inner = true;
  if (byte & 0x40) o.knockout = true;
  if (byte & 0x20) o.composite = true;
  if (onTop && byte & 0x10) o.onTop = true;
  o.passes = byte & (onTop ? 0x0f : 0x1f);
  return o;
}
const flagByte = (f, onTop) => (f.inner ? 0x80 : 0) | (f.knockout ? 0x40 : 0) | (f.composite ? 0x20 : 0) | (onTop && f.onTop ? 0x10 : 0) | ((f.passes ?? 1) & (onTop ? 0x0f : 0x1f));

/** A FILTERLIST: the filters and the bytes read. */
function readFilters(b, at) {
  const filters = [];
  let p = at + 1;
  for (let i = 0; i < b[at]; i++) {
    const type = FILTERS[b[p]];
    const fx = (o) => fixed(b.readInt32LE(o));
    if (type === "dropShadow") {
      const { color, alpha } = rgba(b, p + 1);
      filters.push({ type, color, alpha, blurX: fx(p + 5), blurY: fx(p + 9), angle: fx(p + 13), distance: fx(p + 17), strength: fixed8(b.readInt16LE(p + 21)), ...flagFields(b[p + 23]) });
      p += 24;
    } else if (type === "blur") {
      const f = { type, blurX: fx(p + 1), blurY: fx(p + 5), passes: b[p + 9] >> 3 };
      if (b[p + 9] & 7) f.reserved = b[p + 9] & 7;
      filters.push(f);
      p += 10;
    } else if (type === "glow") {
      const { color, alpha } = rgba(b, p + 1);
      filters.push({ type, color, alpha, blurX: fx(p + 5), blurY: fx(p + 9), strength: fixed8(b.readInt16LE(p + 13)), ...flagFields(b[p + 15]) });
      p += 16;
    } else if (type === "bevel") {
      const s = rgba(b, p + 1), h = rgba(b, p + 5);
      filters.push({ type, shadowColor: s.color, shadowAlpha: s.alpha, highlightColor: h.color, highlightAlpha: h.alpha, blurX: fx(p + 9), blurY: fx(p + 13), angle: fx(p + 17), distance: fx(p + 21), strength: fixed8(b.readInt16LE(p + 25)), ...flagFields(b[p + 27], true) });
      p += 28;
    } else if (type === "colorMatrix") {
      filters.push({ type, matrix: Array.from({ length: 20 }, (_, k) => float32(b.readFloatLE(p + 1 + 4 * k))) });
      p += 81;
    } else throw new Error(`filter type ${b[p]} not supported`);
  }
  return { filters, length: p - at };
}
function writeFilters(filters, where) {
  const parts = [Buffer.from([filters.length])];
  const fx = (v) => i32(Math.round(v * 65536));
  for (const f of filters) {
    const t = FILTERS.indexOf(f.type);
    if (t < 0) throw new Error(`${where}: filter type "${f.type}" (one of ${FILTERS.filter(Boolean).join(", ")})`);
    parts.push(Buffer.from([t]));
    if (f.type === "dropShadow") parts.push(putRgba(f), fx(f.blurX ?? 4), fx(f.blurY ?? 4), fx(f.angle ?? 0.785398), fx(f.distance ?? 4), i16(Math.round((f.strength ?? 1) * 256)), Buffer.from([flagByte(f)]));
    else if (f.type === "blur") parts.push(fx(f.blurX ?? 4), fx(f.blurY ?? 4), Buffer.from([((f.passes ?? 1) << 3) | (f.reserved ?? 0)]));
    else if (f.type === "glow") parts.push(putRgba(f), fx(f.blurX ?? 6), fx(f.blurY ?? 6), i16(Math.round((f.strength ?? 2) * 256)), Buffer.from([flagByte(f)]));
    else if (f.type === "bevel") parts.push(putRgba(f, "shadow"), putRgba(f, "highlight"), fx(f.blurX ?? 4), fx(f.blurY ?? 4), fx(f.angle ?? 0.785398), fx(f.distance ?? 4), i16(Math.round((f.strength ?? 1) * 256)), Buffer.from([flagByte(f, true)]));
    else if (f.type === "colorMatrix") {
      if (!Array.isArray(f.matrix) || f.matrix.length !== 20) throw new Error(`${where}: colorMatrix's "matrix" holds 20 numbers`);
      const m = Buffer.alloc(80);
      f.matrix.forEach((v, k) => m.writeFloatLE(v, 4 * k));
      parts.push(m);
    }
  }
  return Buffer.concat(parts);
}

// --- Tags -------------------------------------------------------------------

const u16 = (n) => { const b = Buffer.alloc(2); b.writeUInt16LE(n); return b; };
/** A tag's bytes: short header when it fits. */
export const tagBytes = (code, data) => Buffer.concat([
  data.length < 0x3f ? u16((code << 6) | data.length) : Buffer.concat([u16((code << 6) | 0x3f), (() => { const b = Buffer.alloc(4); b.writeUInt32LE(data.length); return b; })()]),
  data,
]);
/** The tags inside a DefineSprite: { code, data, raw } (raw: with its header). */
function innerTags(data) {
  const out = [];
  let p = 4;
  while (p + 2 <= data.length) {
    const start = p, h = data.readUInt16LE(p); p += 2;
    let len = h & 0x3f;
    if (len === 0x3f) { len = data.readUInt32LE(p); p += 4; }
    out.push({ code: h >> 6, data: data.subarray(p, p + len), raw: data.subarray(start, p + len) });
    p += len;
    if (h >> 6 === 0) break;
  }
  return out;
}

/** The library: each id's kind and export name, and each name's id. */
export function library(swf) {
  const kinds = new Map(), byName = new Map(), names = exportsOf(swf);
  for (const t of swf.tags) if (KIND[t.code] && t.data.length >= 2) kinds.set(t.data.readUInt16LE(0), KIND[t.code]);
  for (const [id, name] of names) byName.set(name, id);
  return { kinds, names, byName };
}

/** A PlaceObject2 / 3 as JSON, and its clip actions' bytes. */
function readPlace(code, b, lib) {
  const f = b[0], f2 = code === 70 ? b[1] : 0;
  if (f2 & ~3) throw new Error(`PlaceObject3 flags ${f2.toString(16)} not supported`);
  let p = code === 70 ? 2 : 1;
  const o = { depth: b.readUInt16LE(p) };
  p += 2;
  if (f & 1) o.move = true;
  if (f & 2) {
    const id = b.readUInt16LE(p); p += 2;
    if (lib.names.has(id)) o.export = lib.names.get(id);
    else o[lib.kinds.get(id) ?? "sprite"] = id;
  }
  if (f & 4) { const r = new BitReader(b, p); Object.assign(o, matrixFields(readMatrix(r))); p = r.pos; }
  if (f & 8) { const r = new BitReader(b, p); Object.assign(o, cxformFields(readCxform(r))); p = r.pos; }
  if (f & 16) { o.ratio = b.readUInt16LE(p); p += 2; }
  if (f & 32) { const z = b.indexOf(0, p); o.name = b.toString("utf8", p, z); p = z + 1; }
  if (f & 64) { o.mask = b.readUInt16LE(p); p += 2; }
  if (f2 & 1) { const r = readFilters(b, p); o.filters = r.filters; p += r.length; }
  if (f2 & 2) { o.blend = BLEND[b[p]] ?? b[p]; p++; }
  let actions = null;
  if (f & 128) { o.actions = true; actions = b.subarray(p); }
  return { o, actions };
}

/** A placement's id, from its JSON. */
function refId(o, lib, where) {
  const keys = REF_KEYS.filter((k) => k in o);
  if (keys.length > 1) throw new Error(`${where}: one of ${keys.join(", ")}, not both`);
  if (!keys.length) return null;
  const k = keys[0], v = o[k];
  if (k === "export") {
    if (!lib.byName.has(v)) throw new Error(`${where}: no symbol exported as "${v}"`);
    return lib.byName.get(v);
  }
  if (lib.kinds.get(v) !== k) throw new Error(`${where}: ${lib.kinds.has(v) ? `${v} is a ${lib.kinds.get(v)}, not a ${k}` : `no ${k} ${v}`}`);
  return v;
}

/** A PlaceObject2 / 3 tag from its JSON (clip actions: their bytes). */
function writePlace(o, lib, actions, where) {
  for (const k of Object.keys(o)) if (!PLACE_KEYS.has(k)) throw new Error(`${where}: unknown key "${k}"`);
  if (!Number.isInteger(o.depth) || o.depth < 1 || o.depth > 65535) throw new Error(`${where}: "depth" is a whole number, 1 to 65535`);
  const id = refId(o, lib, where);
  if (id === null && !o.move) throw new Error(`${where}: what it places ("export", "shape", "sprite"…), or "move": true`);
  const po3 = o.filters || o.blend !== undefined;
  const parts = [];
  let f = 0, f2 = 0;
  if (o.move) f |= 1;
  if (id !== null) { f |= 2; parts.push(u16(id)); }
  if (hasMatrix(o)) { f |= 4; parts.push(writeMatrix(fieldsMatrix(o, where))); }
  if ("alpha" in o || o.color) { f |= 8; parts.push(writeCxform(fieldsCxform(o, where))); }
  if ("ratio" in o) { f |= 16; parts.push(u16(o.ratio)); }
  if ("name" in o) { f |= 32; parts.push(Buffer.from(`${o.name}\0`, "utf8")); }
  if ("mask" in o) { f |= 64; parts.push(u16(o.mask)); }
  if (o.filters) { f2 |= 1; parts.push(writeFilters(o.filters, where)); }
  if (o.blend !== undefined) {
    const v = typeof o.blend === "number" ? o.blend : BLEND.indexOf(o.blend);
    if (v < 0) throw new Error(`${where}: blend "${o.blend}" (one of ${BLEND.filter(Boolean).join(", ")})`);
    f2 |= 2; parts.push(Buffer.from([v]));
  }
  if (o.actions) {
    if (!actions) throw new Error(`${where}: "actions": true on a placement that had none — clip actions are compiled from frame scripts, not added here`);
    f |= 128; parts.push(actions);
  }
  const head = po3 ? Buffer.concat([Buffer.from([f, f2]), u16(o.depth)]) : Buffer.concat([Buffer.from([f]), u16(o.depth)]);
  return tagBytes(po3 ? 70 : 26, Buffer.concat([head, ...parts]));
}

/**
 * A DefineSprite as JSON ({ frames }), with what re-encoding it needs: each
 * frame's script bytes and its placements' bytes.
 */
export function readSprite(data, lib) {
  const frames = [], scripts = [], raws = [];
  const frameCount = data.readUInt16LE(2);
  let frame = {}, script = null, raw = [], stage = 0;   // stage: the order of a frame's tags (remove, script, label, place)
  for (const t of innerTags(data)) {
    const order = { 28: 0, 12: 1, 43: 2, 26: 3, 70: 3 }[t.code];
    if (order !== undefined) {
      if (order < stage || (order === stage && order !== 0 && order !== 3)) throw new Error(`frame ${frames.length + 1}: tags out of the usual order`);
      stage = order;
    }
    if (t.code === 28) (frame.remove ??= []).push(t.data.readUInt16LE(0));
    else if (t.code === 12) script = t.raw;
    else if (t.code === 43) {
      const z = t.data.indexOf(0);
      frame.label = t.data.toString("utf8", 0, z);
      if (t.data.length > z + 1) frame.anchor = true;
    } else if (t.code === 26 || t.code === 70) {
      const { o, actions } = readPlace(t.code, t.data, lib);
      (frame.place ??= []).push(o);
      raw.push({ o, raw: t.raw, actions });
    } else if (t.code === 1) {
      frames.push(frame); scripts.push(script); raws.push(raw);
      frame = {}; script = null; raw = []; stage = 0;
    } else if (t.code === 0) {
      if (Object.keys(frame).length || script) throw new Error("tags after the last frame");
    } else throw new Error(`tag ${t.code} in a sprite not supported`);
  }
  const json = { frames };
  if (frameCount !== frames.length) json.frameCount = frameCount;
  return { json, scripts, raws };
}

/**
 * A DefineSprite's data from its JSON. `was` (readSprite of the base's): its
 * frame scripts stay on their frames, and a placement left as it was keeps
 * its bytes (and its clip actions).
 */
export function writeSprite(id, json, lib, was, where) {
  if (!json || !Array.isArray(json.frames)) throw new Error(`${where}: { "frames": [ … ] }`);
  for (const k of Object.keys(json)) if (k !== "frames" && k !== "frameCount") throw new Error(`${where}: unknown key "${k}"`);
  const parts = [u16(id), u16(json.frameCount ?? json.frames.length)];
  const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);
  json.frames.forEach((fr, i) => {
    const at = `${where}, frame ${i + 1}`;
    if (!fr || typeof fr !== "object") throw new Error(`${at}: a frame is { … }`);
    for (const k of Object.keys(fr)) if (!FRAME_KEYS.has(k)) throw new Error(`${at}: unknown key "${k}"`);
    for (const d of fr.remove ?? []) parts.push(tagBytes(28, u16(d)));
    if (was?.scripts[i]) parts.push(was.scripts[i]);
    if ("label" in fr) parts.push(tagBytes(43, Buffer.concat([Buffer.from(`${fr.label}\0`, "utf8"), fr.anchor ? Buffer.from([1]) : Buffer.alloc(0)])));
    const old = [...(was?.raws[i] ?? [])];
    (fr.place ?? []).forEach((o, k) => {
      const pat = `${at}, place #${k + 1}`;
      const kept = old.findIndex((r) => same(r.o, o));
      if (kept >= 0) { parts.push(old[kept].raw); old.splice(kept, 1); return; }
      // Clip actions follow their placement (same depth on this frame).
      const actions = o.actions ? was?.raws[i]?.find((r) => r.o.depth === o.depth && r.actions)?.actions : null;
      parts.push(writePlace(o, lib, actions, pat));
    });
    parts.push(tagBytes(1, Buffer.alloc(0)));
  });
  parts.push(tagBytes(0, Buffer.alloc(0)));
  return Buffer.concat(parts);
}

// --- Texts ------------------------------------------------------------------

function readRect(r) {
  const n = r.u(5);
  const [xmin, xmax, ymin, ymax] = [r.s(n), r.s(n), r.s(n), r.s(n)];
  return { xmin, xmax, ymin, ymax };
}
function writeRect(xmin, xmax, ymin, ymax) {
  const n = sbits(xmin, xmax, ymin, ymax);
  return new BitWriter().u(5, n).s(n, xmin).s(n, xmax).s(n, ymin).s(n, ymax).bytes();
}
const boundsFields = (b) => ({ x: b.xmin / 20, y: b.ymin / 20, width: (b.xmax - b.xmin) / 20, height: (b.ymax - b.ymin) / 20 });
function fieldsBounds(o, where) {
  for (const k of ["x", "y", "width", "height"]) if (typeof o[k] !== "number") throw new Error(`${where}: "${k}" (its box, in pixels)`);
  const xmin = Math.round(o.x * 20), ymin = Math.round(o.y * 20);
  return writeRect(xmin, xmin + Math.round(o.width * 20), ymin, ymin + Math.round(o.height * 20));
}
const colorText = (b, at) => `#${hex2(b[at])}${hex2(b[at + 1])}${hex2(b[at + 2])}`;
function putColor(c, where, key = "color") {
  if (!/^#[0-9a-f]{6}$/i.test(c ?? "")) throw new Error(`${where}: "${key}" is "#rrggbb"`);
  return Buffer.from([parseInt(c.slice(1, 3), 16), parseInt(c.slice(3, 5), 16), parseInt(c.slice(5, 7), 16)]);
}
const cstring = (b, p) => { const z = b.indexOf(0, p); return [b.toString("utf8", p, z), z + 1]; };

/** Each font's glyph codes (glyph index → character code), by font id. */
export function fontTable(swf) {
  const fonts = new Map();
  for (const t of swf.tags) if (t.code === 48 || t.code === 75) {
    const d = t.data, flags = d[2];
    let p = 5 + d[4];
    const n = d.readUInt16LE(p); p += 2;
    const codes = [];
    if (n) {
      const wideOffsets = flags & 0x08, wideCodes = flags & 0x04;
      let q = p + (wideOffsets ? d.readUInt32LE(p + 4 * n) : d.readUInt16LE(p + 2 * n));
      for (let i = 0; i < n; i++, q += wideCodes ? 2 : 1) codes.push(wideCodes ? d.readUInt16LE(q) : d[q]);
    }
    const byChar = new Map();
    codes.forEach((c, i) => { if (!byChar.has(c)) byChar.set(c, i); });
    fonts.set(d.readUInt16LE(0), { codes, byChar, name: d.toString("utf8", 5, 5 + d[4]).replace(/\0+$/, "") });
  }
  return fonts;
}

const ALIGN = ["left", "right", "center", "justify"];
// DefineEditText's flags, as the AS2 TextField's properties where there is one.
const EDIT_FLAGS = [
  [0x4000, "wordWrap"], [0x2000, "multiline"], [0x1000, "password"], [0x0800, "readOnly"],
  [0x0040, "autoSize"], [0x0010, "selectable", false], [0x0008, "border"], [0x0004, "wasStatic"], [0x0002, "html"], [0x0001, "embedFonts"],
];
const EDIT_KEYS = new Set(["x", "y", "width", "height", "variable", "text", "font", "size", "color", "alpha", "align", "marginLeft", "marginRight", "indent", "leading", "maxLength", ...EDIT_FLAGS.map((f) => f[1])]);

/** A DefineEditText (a text field: dynamic, input or HTML) as JSON. */
export function readEditText(d) {
  const r = new BitReader(d, 2);
  const o = boundsFields(readRect(r));
  let p = r.pos;
  const f = d.readUInt16BE(p); p += 2;
  if (f & 0x0080) throw new Error("a font class (SWF 9+) not supported");
  let font, size, color, maxLength, layout;
  if (f & 0x0100) { font = d.readUInt16LE(p); size = d.readUInt16LE(p + 2) / 20; p += 4; }
  if (f & 0x0400) { color = { color: colorText(d, p), alpha: d[p + 3] }; p += 4; }
  if (f & 0x0200) { maxLength = d.readUInt16LE(p); p += 2; }
  if (f & 0x0020) { layout = { align: ALIGN[d[p]] ?? d[p], marginLeft: d.readUInt16LE(p + 1) / 20, marginRight: d.readUInt16LE(p + 3) / 20, indent: d.readUInt16LE(p + 5) / 20, leading: d.readInt16LE(p + 7) / 20 }; p += 9; }
  let variable, text;
  [variable, p] = cstring(d, p);
  if (variable) o.variable = variable;
  if (f & 0x8000) [text] = cstring(d, p);
  if (text !== undefined) o.text = text;
  if (font !== undefined) Object.assign(o, { font, size });
  if (color) { o.color = color.color; if (color.alpha !== 255) o.alpha = byteUnit(color.alpha); }
  if (layout) Object.assign(o, layout);
  if (maxLength !== undefined) o.maxLength = maxLength;
  for (const [bit, key, set = true] of EDIT_FLAGS) if (f & bit) o[key] = set;     // NoSelect: "selectable": false
  return { json: o };
}
export function writeEditText(id, o, where) {
  for (const k of Object.keys(o)) if (!EDIT_KEYS.has(k)) throw new Error(`${where}: unknown key "${k}"`);
  let f = 0;
  const parts = [];
  if ("font" in o) { f |= 0x0100; parts.push(u16(o.font), u16(Math.round((o.size ?? 12) * 20))); }
  if ("color" in o) { f |= 0x0400; parts.push(putColor(o.color, where), Buffer.from([Math.round((o.alpha ?? 1) * 255)])); }
  if ("maxLength" in o) { f |= 0x0200; parts.push(u16(o.maxLength)); }
  if (["align", "marginLeft", "marginRight", "indent", "leading"].some((k) => k in o)) {
    const a = ALIGN.indexOf(o.align ?? "left");
    if (a < 0 && typeof o.align !== "number") throw new Error(`${where}: "align" is one of ${ALIGN.join(", ")}`);
    f |= 0x0020;
    const l = Buffer.alloc(9);
    l[0] = a < 0 ? o.align : a;
    l.writeUInt16LE(Math.round((o.marginLeft ?? 0) * 20), 1); l.writeUInt16LE(Math.round((o.marginRight ?? 0) * 20), 3);
    l.writeUInt16LE(Math.round((o.indent ?? 0) * 20), 5); l.writeInt16LE(Math.round((o.leading ?? 0) * 20), 7);
    parts.push(l);
  }
  parts.push(Buffer.from(`${o.variable ?? ""}\0`, "utf8"));
  if ("text" in o) { f |= 0x8000; parts.push(Buffer.from(`${o.text}\0`, "utf8")); }
  for (const [bit, key, set = true] of EDIT_FLAGS) if (o[key] === set) f |= bit;
  const flags = Buffer.alloc(2);
  flags.writeUInt16BE(f);
  return Buffer.concat([u16(id), fieldsBounds(o, where), flags, ...parts]);
}

const STATIC_KEYS = new Set(["x", "y", "width", "height", "transform", "records"]);
const RECORD_KEYS = new Set(["font", "size", "color", "alpha", "x", "y", "text", "glyphs", "advances"]);

/**
 * A DefineText / DefineText2 (static text) as JSON: its box, its transform,
 * and its runs — each a font, size, colour, offset, its characters (by the
 * font's glyph codes) and their advances.
 */
export function readStaticText(code, d, ctx) {
  let r = new BitReader(d, 2);
  const o = boundsFields(readRect(r));
  r = new BitReader(d, r.pos);
  o.transform = matrixFields(readMatrix(r));
  let p = r.pos;
  const glyphBits = d[p], advanceBits = d[p + 1];
  p += 2;
  o.records = [];
  let font;
  while (d[p]) {
    const f = d[p++], rec = {};
    if (f & 0x08) { font = d.readUInt16LE(p); rec.font = font; p += 2; }
    if (f & 0x04) {
      rec.color = colorText(d, p);
      if (code === 33) { if (d[p + 3] !== 255) rec.alpha = byteUnit(d[p + 3]); p += 4; } else p += 3;
    }
    if (f & 0x01) { rec.x = d.readInt16LE(p) / 20; p += 2; }
    if (f & 0x02) { rec.y = d.readInt16LE(p) / 20; p += 2; }
    if (f & 0x08) { rec.size = d.readUInt16LE(p) / 20; p += 2; }
    const n = d[p++];
    const g = new BitReader(d, p), glyphs = [], advances = [];
    for (let i = 0; i < n; i++) { glyphs.push(g.u(glyphBits)); advances.push(g.s(advanceBits) / 20); }
    p = g.pos;
    // Characters when the font gives each glyph back from its character; glyph indices otherwise.
    const fnt = ctx.fonts.get(font);
    if (fnt && glyphs.every((i) => fnt.byChar.get(fnt.codes[i]) === i)) rec.text = glyphs.map((i) => String.fromCharCode(fnt.codes[i])).join("");
    else rec.glyphs = glyphs;
    rec.advances = advances;
    o.records.push(Object.fromEntries(["font", "size", "color", "alpha", "x", "y", "text", "glyphs", "advances"].filter((k) => k in rec).map((k) => [k, rec[k]])));
  }
  return { json: o };
}
export function writeStaticText(code, id, o, ctx, where) {
  for (const k of Object.keys(o)) if (!STATIC_KEYS.has(k)) throw new Error(`${where}: unknown key "${k}"`);
  if (!Array.isArray(o.records)) throw new Error(`${where}: "records": [ … ]`);
  let font;
  const runs = o.records.map((rec, k) => {
    const at = `${where}, record #${k + 1}`;
    for (const key of Object.keys(rec)) if (!RECORD_KEYS.has(key)) throw new Error(`${at}: unknown key "${key}"`);
    if ("font" in rec) font = rec.font;
    let glyphs = rec.glyphs;
    if (rec.text !== undefined) {
      const fnt = ctx.fonts.get(font);
      if (!fnt) throw new Error(`${at}: no font ${font}`);
      glyphs = [...rec.text].map((ch) => {
        if (!fnt.byChar.has(ch.charCodeAt(0))) throw new Error(`${at}: font ${font} (${fnt.name}) has no "${ch}" (it holds: ${fnt.codes.map((c) => String.fromCharCode(c)).join("")})`);
        return fnt.byChar.get(ch.charCodeAt(0));
      });
    }
    if (!Array.isArray(glyphs)) throw new Error(`${at}: "text" (or "glyphs")`);
    if (!Array.isArray(rec.advances) || rec.advances.length !== glyphs.length) throw new Error(`${at}: "advances" holds one width per character, in pixels (${glyphs.length})`);
    return { rec, glyphs, advances: rec.advances.map((a) => Math.round(a * 20)) };
  });
  const glyphBits = Math.max(0, ...runs.flatMap((r) => r.glyphs).map((g) => g.toString(2).length));
  const advanceBits = sbits(...runs.flatMap((r) => r.advances));
  const parts = [u16(id), fieldsBounds(o, where), writeMatrix(fieldsMatrix(o.transform ?? {}, where)), Buffer.from([glyphBits, advanceBits])];
  for (const { rec, glyphs, advances } of runs) {
    const hasFont = "font" in rec;
    parts.push(Buffer.from([0x80 | (hasFont ? 0x08 : 0) | ("color" in rec ? 0x04 : 0) | ("y" in rec ? 0x02 : 0) | ("x" in rec ? 0x01 : 0)]));
    if (hasFont) parts.push(u16(rec.font));
    if ("color" in rec) parts.push(putColor(rec.color, where), code === 33 ? Buffer.from([Math.round((rec.alpha ?? 1) * 255)]) : Buffer.alloc(0));
    if ("x" in rec) parts.push(i16(Math.round(rec.x * 20)));
    if ("y" in rec) parts.push(i16(Math.round(rec.y * 20)));
    if (hasFont) parts.push(u16(Math.round(rec.size * 20)));
    const w = new BitWriter();
    glyphs.forEach((g, i) => w.u(glyphBits, g).s(advanceBits, advances[i]));
    parts.push(Buffer.from([glyphs.length]), w.bytes());
  }
  parts.push(Buffer.from([0]));
  return Buffer.concat(parts);
}

// --- Buttons ----------------------------------------------------------------

const STATES = [[0x01, "up"], [0x02, "over"], [0x04, "down"], [0x08, "hit"]];
const BUTTON_KEYS = new Set(["menu", "records", "actions"]);
const BUTTON_RECORD_KEYS = new Set(["depth", "states", ...REF_KEYS, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "filters", "blend"]);

/**
 * A DefineButton2 as JSON: what it shows in each state (up, over, down; hit:
 * where it reacts), and whether it has actions (compiled from its scripts in
 * src/timeline/buttons/…). Its records' and actions' bytes come along.
 */
export function readButton(d, ctx) {
  if (d[2] & 0xfe) throw new Error(`button flags ${d[2]} not supported`);
  const offset = d.readUInt16LE(3);
  const json = {};
  if (d[2] & 1) json.menu = true;
  json.records = [];
  const raws = [];
  let p = 5;
  while (d[p]) {
    const start = p, f = d[p++];
    if (f & 0xc0) throw new Error(`button record flags ${f} not supported`);
    const id = d.readUInt16LE(p), o = { depth: d.readUInt16LE(p + 2), states: STATES.filter(([bit]) => f & bit).map(([, s]) => s) };
    p += 4;
    if (ctx.lib.names.has(id)) o.export = ctx.lib.names.get(id); else o[ctx.lib.kinds.get(id) ?? "sprite"] = id;
    let r = new BitReader(d, p);
    Object.assign(o, matrixFields(readMatrix(r)));
    r = new BitReader(d, r.pos);
    const cx = readCxform(r);
    if (cx.mult || cx.add) Object.assign(o, cxformFields(cx));
    p = r.pos;
    if (f & 0x10) { const fl = readFilters(d, p); o.filters = fl.filters; p += fl.length; }
    if (f & 0x20) { o.blend = BLEND[d[p]] ?? d[p]; p++; }
    json.records.push(o);
    raws.push({ o, raw: d.subarray(start, p) });
  }
  p++;
  if (offset && 3 + offset !== p) throw new Error("bytes between the records and the actions");
  const actions = offset ? d.subarray(p) : null;
  if (actions) json.actions = true;
  return { json, raws, actions };
}
export function writeButton(id, json, ctx, was, where) {
  for (const k of Object.keys(json)) if (!BUTTON_KEYS.has(k)) throw new Error(`${where}: unknown key "${k}"`);
  if (!Array.isArray(json.records)) throw new Error(`${where}: "records": [ … ]`);
  const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);
  const old = [...(was?.raws ?? [])];
  const records = json.records.map((o, k) => {
    const at = `${where}, record #${k + 1}`;
    const kept = old.findIndex((r) => same(r.o, o));
    if (kept >= 0) return old.splice(kept, 1)[0].raw;
    for (const key of Object.keys(o)) if (!BUTTON_RECORD_KEYS.has(key)) throw new Error(`${at}: unknown key "${key}"`);
    const states = o.states ?? [];
    for (const s of states) if (!STATES.some(([, n]) => n === s)) throw new Error(`${at}: a state is one of ${STATES.map(([, n]) => n).join(", ")}`);
    const ref = refId(o, ctx.lib, at);
    if (ref === null) throw new Error(`${at}: what it shows ("export", "shape", "sprite"…)`);
    if (!Number.isInteger(o.depth) || o.depth < 1) throw new Error(`${at}: "depth" is a whole number from 1`);
    let f = STATES.filter(([, n]) => states.includes(n)).reduce((a, [bit]) => a | bit, 0);
    const parts = [u16(ref), u16(o.depth), writeMatrix(fieldsMatrix(o, at)), writeCxform("alpha" in o || o.color ? fieldsCxform(o, at) : {})];
    if (o.filters) { f |= 0x10; parts.push(writeFilters(o.filters, at)); }
    if (o.blend !== undefined) {
      const v = typeof o.blend === "number" ? o.blend : BLEND.indexOf(o.blend);
      if (v < 0) throw new Error(`${at}: blend "${o.blend}" (one of ${BLEND.filter(Boolean).join(", ")})`);
      f |= 0x20; parts.push(Buffer.from([v]));
    }
    return Buffer.concat([Buffer.from([f]), ...parts]);
  });
  const body = Buffer.concat([...records, Buffer.from([0])]);
  if (json.actions && !was?.actions) throw new Error(`${where}: "actions": true on a button that had none — its actions are compiled from its scripts, not added here`);
  const actions = json.actions ? was.actions : Buffer.alloc(0);
  return Buffer.concat([u16(id), Buffer.from([json.menu ? 1 : 0]), u16(actions.length ? 2 + body.length : 0), body, actions]);
}

// --- Any of them ------------------------------------------------------------

const TEXT_TAGS = new Set([11, 33, 37]);
/** What a definition tag is, as a file: sprite, button, text — or nothing. */
const objectKind = (code) => (code === 39 ? "sprite" : code === 34 ? "button" : TEXT_TAGS.has(code) ? "text" : null);

/** What decoding and encoding need of a SWF: its library and its fonts. */
export const context = (swf) => ({ lib: library(swf), fonts: fontTable(swf) });

/** A sprite, button or text tag as JSON ({ json, … what re-encoding it needs }). */
export function readObject(tag, ctx) {
  const r = tag.code === 39 ? readSprite(tag.data, ctx.lib)
    : tag.code === 34 ? readButton(tag.data, ctx)
    : tag.code === 37 ? readEditText(tag.data)
    : readStaticText(tag.code, tag.data, ctx);
  return { ...r, data: tag.data };
}
/** A sprite, button or text tag's data from its JSON (`was`: readObject of the base's — left as it was, its bytes). */
export function writeObject(code, id, json, ctx, was, where) {
  if (!json || typeof json !== "object") throw new Error(`${where}: { … }`);
  if (was?.data && JSON.stringify(json) === JSON.stringify(was.json)) return was.data;
  if (code === 39) return writeSprite(id, json, ctx.lib, was, where);
  if (code === 34) return writeButton(id, json, ctx, was, where);
  if (code === 37) return writeEditText(id, json, where);
  return writeStaticText(code, id, json, ctx, where);
}

const one = (v) => (Array.isArray(v) ? `[${v.map(one).join(", ")}]` : v && typeof v === "object" ? `{ ${Object.entries(v).map(([k, x]) => `${JSON.stringify(k)}: ${one(x)}`).join(", ")} }` : JSON.stringify(v));

/** A sprite.json's text: a frame per block, a placement per line (diffs and merges stay readable). */
export function formatSprite(json) {
  const frame = (fr) => {
    const keys = Object.keys(fr);
    if (!keys.length) return "  {}";
    const lines = keys.filter((k) => k !== "place").map((k) => `    ${JSON.stringify(k)}: ${one(fr[k])}`);
    if (fr.place) lines.push(`    "place": [\n${fr.place.map((o) => `      ${one(o)}`).join(",\n")}\n    ]`);
    return `  {\n${lines.join(",\n")}\n  }`;
  };
  const head = "frameCount" in json ? `"frameCount": ${json.frameCount},\n ` : "";
  return `{\n ${head}"frames": [\n${json.frames.map(frame).join(",\n")}\n ]\n}\n`;
}
/** A button's or a text's JSON: a key per line, a record per line. */
export function formatObject(json) {
  const lines = Object.entries(json).map(([k, v]) => (Array.isArray(v) && v.length && v.every((x) => x && typeof x === "object")
    ? ` ${JSON.stringify(k)}: [\n${v.map((o) => `  ${one(o)}`).join(",\n")}\n ]`
    : ` ${JSON.stringify(k)}: ${one(v)}`));
  return `{\n${lines.join(",\n")}\n}\n`;
}
export const formatJson = (kind, json) => (kind === "sprite" ? formatSprite(json) : formatObject(json));

// --- Files ------------------------------------------------------------------

/** Sprites with a sprite.json: not the classes' clips (__Packages.*: their code is in classes/). */
export function spriteIds(swf) {
  const names = exportsOf(swf);
  return swf.tags.filter((t) => t.code === 39).map((t) => t.data.readUInt16LE(0)).filter((id) => !names.get(id)?.startsWith("__Packages."));
}

/** Folders by id in a timeline/ folder: the one already there (scripts), else <id>[_<Export>]. */
function folders(dir, ids, names) {
  const existing = new Map();
  if (existsSync(dir)) for (const d of readdirSync(dir)) { const m = /^(\d+)(_|$)/.exec(d); if (m) existing.set(Number(m[1]), d); }
  return new Map(ids.map((id) => [id, existing.get(id) ?? (names.has(id) ? `${id}_${names.get(id)}` : `${id}`)]));
}
/** Each sprite's folder in src/timeline/sprites/. */
export const spriteFolders = (swf, dir = SPRITES) => folders(dir, spriteIds(swf), exportsOf(swf));

/**
 * Each sprite, button and text of a SWF, by id: { kind, code, file } (file:
 * from src/ — timeline/sprites/<folder>/sprite.json,
 * timeline/buttons/<folder>/button.json, timeline/texts/<id>.json).
 */
export function objectFiles(swf, src = SRC) {
  const names = exportsOf(swf);
  const out = new Map();
  for (const [id, d] of folders(join(src, "timeline", "sprites"), spriteIds(swf), names)) out.set(id, { kind: "sprite", code: 39, file: `timeline/sprites/${d}/${SPRITE_FILE}` });
  const buttons = swf.tags.filter((t) => t.code === 34).map((t) => t.data.readUInt16LE(0));
  for (const [id, d] of folders(join(src, "timeline", "buttons"), buttons, names)) out.set(id, { kind: "button", code: 34, file: `timeline/buttons/${d}/button.json` });
  for (const t of swf.tags) if (TEXT_TAGS.has(t.code)) out.set(t.data.readUInt16LE(0), { kind: "text", code: t.code, file: `timeline/texts/${t.data.readUInt16LE(0)}.json` });
  return out;
}

/** Every sprite.json, button.json and text JSON in src/. */
export function spriteFiles(src = SRC) {
  const out = [];
  const t = join(src, "timeline");
  for (const [dir, file] of [["sprites", SPRITE_FILE], ["buttons", "button.json"]]) {
    if (existsSync(join(t, dir))) for (const d of readdirSync(join(t, dir)).sort()) if (existsSync(join(t, dir, d, file))) out.push(`timeline/${dir}/${d}/${file}`);
  }
  if (existsSync(join(t, "texts"))) for (const f of readdirSync(join(t, "texts")).sort()) if (f.endsWith(".json")) out.push(`timeline/texts/${f}`);
  return out;
}
/** A file's id (timeline/sprites/969_UI_Login/sprite.json → 969) and kind. */
export const fileId = (f) => Number(/^timeline\/(?:sprites|buttons|texts)\/(\d+)/.exec(f)?.[1]);
export const fileKind = (f) => ({ sprites: "sprite", buttons: "button", texts: "text" })[f.split("/")[1]];

/** src/timeline/… ← the base loader: every sprite, button and text. Returns how many of each. */
export function extractSprites(loader, src = SRC) {
  const swf = parseSwf(readFileSync(loader));
  const ctx = context(swf);
  const files = objectFiles(swf, src);
  const counts = { sprite: 0, button: 0, text: 0 };
  for (const t of swf.tags) {
    const f = t.data.length >= 2 && objectKind(t.code) ? files.get(t.data.readUInt16LE(0)) : undefined;
    if (!f) continue;
    let json;
    try { ({ json } = readObject(t, ctx)); } catch (e) { throw new Error(`${f.kind} ${t.data.readUInt16LE(0)}: ${e.message}`); }
    mkdirSync(join(src, f.file, ".."), { recursive: true });
    writeFileSync(join(src, f.file), formatJson(f.kind, json));
    counts[f.kind]++;
  }
  return counts;
}

/** Files that differ from the base's (manifest.sprites: sprites, buttons and texts). */
export function changedSprites(manifest) {
  const known = manifest.sprites ?? {};
  return spriteFiles().filter((f) => f in known && known[f] !== spriteHash(join(SRC, f)));
}

const parseJson = (file, label) => {
  try { return JSON.parse(readFileSync(file, "utf8")); } catch (e) { throw new Error(`${label}: ${e.message}`); }
};
const definition = (swf, id, kind) => swf.tags.find((t) => objectKind(t.code) === kind && t.data.readUInt16LE(0) === id);

/**
 * The SWF with its edited sprites, buttons and texts re-encoded (`edited`:
 * paths from src/) and the new sprites (`fresh`: new/<path>.json, from
 * `assets`) added and exported by their path in lower case. Returns the names added.
 */
export function applySprites(input, output, edited, fresh, base, { src = SRC, assets = ASSETS } = {}) {
  const swf = parseSwf(readFileSync(input));
  const baseSwf = parseSwf(readFileSync(base));
  const baseCtx = context(baseSwf);
  const ctx = context(swf);
  const lib = ctx.lib;

  // New sprites: ids and names first (they may place one another).
  let next = 0;
  for (const t of swf.tags) if (KIND[t.code] && t.data.length >= 2) next = Math.max(next, t.data.readUInt16LE(0));
  const added = fresh.map((f) => ({ f, name: exportName(f), id: ++next, json: parseJson(join(assets, f), `src/assets/${f}`) }));
  for (const a of added) {
    if (lib.byName.has(a.name)) throw new Error(`src/assets/${a.f}: "${a.name}" is already exported`);
    lib.kinds.set(a.id, "sprite"); lib.names.set(a.id, a.name); lib.byName.set(a.name, a.id);
  }

  for (const f of edited) {
    const id = fileId(f), kind = fileKind(f);
    const tag = definition(swf, id, kind), was = definition(baseSwf, id, kind);
    if (!tag || !was) throw new Error(`src/${f}: no ${kind} ${id} in the base`);
    tag.data = writeObject(tag.code, id, parseJson(join(src, f), `src/${f}`), ctx, readObject(was, baseCtx), `src/${f}`);
  }

  if (added.length) {
    // In the order they need one another, before the first frame ends.
    const byId = new Map(added.map((a) => [a.id, a])), done = new Set(), order = [];
    const visit = (a, path) => {
      if (done.has(a.id)) return;
      if (path.includes(a.id)) throw new Error(`src/assets/${a.f}: places itself, through ${path.map((i) => byId.get(i).name).join(" → ")}`);
      for (const fr of a.json.frames ?? []) for (const o of fr.place ?? []) if (o.export && byId.has(lib.byName.get(o.export))) visit(byId.get(lib.byName.get(o.export)), [...path, a.id]);
      done.add(a.id); order.push(a);
    };
    for (const a of added) visit(a, []);
    const tags = [];
    for (const a of order) {
      tags.push({ code: 39, data: writeSprite(a.id, a.json, lib, null, `src/assets/${a.f}`) });
      tags.push({ code: 56, data: Buffer.concat([u16(1), u16(a.id), Buffer.from(`${a.name}\0`, "latin1")]) });
    }
    swf.tags.splice(swf.tags.findIndex((t) => t.code === 1), 0, ...tags);
  }
  writeFileSync(output, writeSwf(swf));
  return added.map((a) => a.name);
}

// --- A new base -------------------------------------------------------------

/** Each shape / image's hash, by id, from a folder of graphics (shapes/<id>.svg, images/<id>.png…). */
export function graphicHashes(dir, hash) {
  const out = new Map();
  for (const kind of ["shapes", "images"]) {
    if (!existsSync(join(dir, kind))) continue;
    for (const f of readdirSync(join(dir, kind))) { const id = Number(f.split(".")[0]); if (id) out.set(id, hash(join(dir, kind, f))); }
  }
  return out;
}

const sha = (s) => createHash("sha256").update(s).digest("hex");
/** A JSON with each id it refers to (what is placed, a font) replaced by `map(id)` (exported symbols keep their name). */
function mapRefs(v, map) {
  if (Array.isArray(v)) return v.map((x) => mapRefs(x, map));
  if (v && typeof v === "object") {
    return Object.fromEntries(Object.entries(v).map(([k, x]) => [k, typeof x === "number" && ((REF_KEYS.includes(k) && k !== "export") || k === "font") ? map(x) : mapRefs(x, map)]));
  }
  return v;
}

/**
 * Each character's fingerprint: what it is, not its id, which changes from a
 * version to the next. Shapes and images: their file's hash (`graphics`);
 * sprites, buttons, texts: their JSON, ids by fingerprint (not their
 * scripts: their bytecode changes with every version); the rest: their bytes.
 */
export function fingerprints(swf, graphics) {
  const ctx = context(swf);
  const tags = new Map();
  for (const t of swf.tags) if ((KIND[t.code] || [10, 48, 75].includes(t.code)) && t.data.length >= 2) tags.set(t.data.readUInt16LE(0), t);
  const fps = new Map(), busy = new Set();
  const fp = (id) => {
    if (fps.has(id)) return fps.get(id);
    const t = tags.get(id);
    if (!t) return `none:${id}`;
    if (busy.has(id)) return `cycle:${id}`;
    busy.add(id);
    let h;
    if (graphics.has(id)) h = graphics.get(id);
    else if (objectKind(t.code)) { try { h = sha(JSON.stringify(mapRefs(readObject(t, ctx).json, fp))); } catch { h = sha(t.data.subarray(2)); } }
    else h = sha(Buffer.concat([u16(t.code), t.data.subarray(2)]));
    busy.delete(id);
    fps.set(id, h);
    return h;
  };
  for (const id of tags.keys()) fp(id);
  return fps;
}

/**
 * Sprites, buttons and texts edited for the previous base, carried over to the
 * new one (already extracted in `src`): each found by its original's
 * fingerprint (or its export name), its ids mapped to the new base's, its
 * edits merged into the new base's file (git merge-file).
 * `edited`: [{ file, text }] (paths of the previous base, the edited text).
 */
export function carrySprites(edited, previous, current, previousGraphics, currentGraphics, src = SRC) {
  const prevSwf = parseSwf(readFileSync(previous)), newSwf = parseSwf(readFileSync(current));
  const prevCtx = context(prevSwf), newLib = library(newSwf);
  const prevFp = fingerprints(prevSwf, previousGraphics), newFp = fingerprints(newSwf, currentGraphics);
  const byFp = new Map();
  for (const [id, h] of newFp) byFp.set(h, [...(byFp.get(h) ?? []), id]);
  // Its id if it still holds the same thing, else the nearest id holding it (alike clips are many: empty ones…).
  const counterpart = (id) => {
    const h = prevFp.get(id);
    if (newFp.get(id) === h) return id;
    const ids = byFp.get(h);
    return ids ? ids.reduce((a, b) => (Math.abs(b - id) < Math.abs(a - id) ? b : a)) : undefined;
  };
  const unmapped = new Set();
  const map = (id) => { const n = counterpart(id); if (n === undefined) { unmapped.add(id); return id; } return n; };
  const files = objectFiles(newSwf, src);
  const result = { carried: [], conflicts: [], lost: [] };
  for (const { file, text } of edited) {
    const prevId = fileId(file), kind = fileKind(file);
    const was = definition(prevSwf, prevId, kind);
    const name = prevCtx.lib.names.get(prevId);
    const newId = name && newLib.byName.has(name) ? newLib.byName.get(name) : counterpart(prevId);
    const target = files.get(newId);
    if (!was || !target || target.kind !== kind) { result.lost.push({ file, why: "not found in the new base" }); continue; }
    let mine;
    try { mine = JSON.parse(text); } catch (e) { result.lost.push({ file, why: e.message }); continue; }
    unmapped.clear();
    const ours = formatJson(kind, mapRefs(mine, map));
    const original = formatJson(kind, mapRefs(readObject(was, prevCtx).json, map));
    const path = join(src, target.file);
    const note = unmapped.size ? ` (ids not found in the new base, kept: ${[...unmapped].join(", ")})` : "";
    if (original === readFileSync(path, "utf8")) { writeFileSync(path, ours); result.carried.push({ file, to: target.file, note }); continue; }
    // Ankama changed it too: their side, the previous original as base, ours.
    const tmp = join(ROOT, ".tmp", "sprite-merge");
    mkdirSync(tmp, { recursive: true });
    writeFileSync(join(tmp, "was.json"), original);
    writeFileSync(join(tmp, "ours.json"), ours);
    const m = spawnSync("git", ["merge-file", "-L", "new base", "-L", "previous base", "-L", "edit", path, join(tmp, "was.json"), join(tmp, "ours.json")]);
    (m.status === 0 ? result.carried : result.conflicts).push({ file, to: target.file, note });
  }
  return result;
}

/** Where a character is placed or shown: [{ file, where, fields }], by sprites (frame, depth) and buttons. */
export function where(swf, id) {
  const ctx = context(swf);
  const files = objectFiles(swf);
  const out = [];
  for (const t of swf.tags) {
    if (t.code === 39) {
      const sid = t.data.readUInt16LE(0);
      let frame = 1;
      for (const it of innerTags(t.data)) {
        if (it.code === 1) frame++;
        if ((it.code === 26 || it.code === 70) && it.data[0] & 2 && it.data.readUInt16LE(it.code === 70 ? 4 : 3) === id) {
          const { depth, ...rest } = readPlace(it.code, it.data, ctx.lib).o;
          out.push({ file: files.get(sid)?.file ?? `sprite ${sid}`, where: `frame ${frame}, depth ${depth}`, fields: rest });
        }
      }
    } else if (t.code === 34) {
      const bid = t.data.readUInt16LE(0);
      for (const { depth, ...rest } of readButton(t.data, ctx).json.records) {
        const ref = rest.export ? ctx.lib.byName.get(rest.export) : REF_KEYS.map((k) => rest[k]).find((v) => typeof v === "number");
        if (ref === id) out.push({ file: files.get(bid).file, where: `depth ${depth}`, fields: rest });
      }
    }
  }
  return out;
}

if (process.argv[1] && import.meta.url.endsWith(process.argv[1].split(/[\\/]/).pop())) {
  const cfg = config();
  const [cmd, arg] = process.argv.slice(2);
  if (cmd === "extract") {
    const n = extractSprites(base(cfg.version).loader);
    console.log(`src/timeline/: ${n.sprite} sprite.json, ${n.button} button.json, ${n.text} texts (base ${cfg.version}); then: node tools/manifest.mjs ${cfg.version}`);
  } else if (cmd === "where" && arg) {
    const swf = parseSwf(readFileSync(base(cfg.version).loader));
    const lib = library(swf);
    const id = /^\d+$/.test(arg) ? Number(arg) : /^[a-z]+s\/\d+$/.test(arg) ? Number(arg.split("/")[1]) : lib.byName.get(arg);
    if (id === undefined) { console.error(`no symbol exported as "${arg}"`); process.exit(1); }
    const found = where(swf, id);
    console.log(`${lib.kinds.get(id) ?? "?"} ${id}${lib.names.has(id) ? ` (${lib.names.get(id)})` : ""}: placed ${found.length} time${found.length === 1 ? "" : "s"}`);
    for (const w of found) console.log(`  src/${w.file}  ${w.where}: ${JSON.stringify(w.fields)}`);
  } else { console.error("usage: node tools/sprites.mjs extract | where <id | shapes/<id> | Export>"); process.exit(2); }
}
