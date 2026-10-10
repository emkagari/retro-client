/**
 * The loader's sprites as files: what each one places, frame by frame
 * (docs/SPRITES.md).
 *
 *   src/timeline/sprites/<id>[_<Export>]/sprite.json   every sprite of the base loader
 *   src/assets/new/<path>.json                         a new sprite, exported by its path in
 *                                                      lower case (like new graphics: "ui/panel")
 *
 *   node tools/sprites.mjs extract        src/timeline/sprites/…/sprite.json ← the base loader
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

// --- Files ------------------------------------------------------------------

/** A sprite.json's text: a frame per block, a placement per line (diffs and merges stay readable). */
export function formatSprite(json) {
  const one = (v) => (Array.isArray(v) ? `[${v.map(one).join(", ")}]` : v && typeof v === "object" ? `{ ${Object.entries(v).map(([k, x]) => `${JSON.stringify(k)}: ${one(x)}`).join(", ")} }` : JSON.stringify(v));
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

/** Sprites with a sprite.json: not the classes' clips (__Packages.*: their code is in classes/). */
export function spriteIds(swf) {
  const names = exportsOf(swf);
  return swf.tags.filter((t) => t.code === 39).map((t) => t.data.readUInt16LE(0)).filter((id) => !names.get(id)?.startsWith("__Packages."));
}

/** Each sprite's folder in src/timeline/sprites/: the one already there (frame scripts), else <id>[_<Export>]. */
export function spriteFolders(swf, dir = SPRITES) {
  const names = exportsOf(swf);
  const existing = new Map();
  if (existsSync(dir)) for (const d of readdirSync(dir)) { const m = /^(\d+)(_|$)/.exec(d); if (m) existing.set(Number(m[1]), d); }
  return new Map(spriteIds(swf).map((id) => [id, existing.get(id) ?? (names.has(id) ? `${id}_${names.get(id)}` : `${id}`)]));
}

/** Every sprite.json, as "timeline/sprites/<folder>/sprite.json". */
export function spriteFiles() {
  if (!existsSync(SPRITES)) return [];
  return readdirSync(SPRITES).filter((d) => existsSync(join(SPRITES, d, SPRITE_FILE))).sort().map((d) => `timeline/sprites/${d}/${SPRITE_FILE}`);
}

/** src/timeline/sprites/…/sprite.json ← the base loader. */
export function extractSprites(loader, to = SPRITES) {
  const swf = parseSwf(readFileSync(loader));
  const lib = library(swf);
  const folders = spriteFolders(swf, to);
  for (const t of swf.tags) if (t.code === 39 && folders.has(t.data.readUInt16LE(0))) {
    const id = t.data.readUInt16LE(0);
    let json;
    try { ({ json } = readSprite(t.data, lib)); } catch (e) { throw new Error(`sprite ${id}: ${e.message}`); }
    const dir = join(to, folders.get(id));
    mkdirSync(dir, { recursive: true });
    writeFileSync(join(dir, SPRITE_FILE), formatSprite(json));
  }
  return folders.size;
}

/** sprite.json files that differ from the base's (manifest.sprites). */
export function changedSprites(manifest) {
  const known = manifest.sprites ?? {};
  return spriteFiles().filter((f) => f in known && known[f] !== spriteHash(join(SRC, f)));
}

const idOfFile = (f) => Number(/^timeline\/sprites\/(\d+)/.exec(f)[1]);
const parseJson = (file, label) => {
  try { return JSON.parse(readFileSync(file, "utf8")); } catch (e) { throw new Error(`${label}: ${e.message}`); }
};

/**
 * The SWF with its edited sprites re-encoded (`edited`: sprite.json paths,
 * from src/) and the new ones (`fresh`: new/<path>.json, from `assets`) added
 * and exported by their path in lower case. Returns the names added.
 */
export function applySprites(input, output, edited, fresh, base, { src = SRC, assets = ASSETS } = {}) {
  const swf = parseSwf(readFileSync(input));
  const baseSwf = parseSwf(readFileSync(base));
  const baseLib = library(baseSwf);
  const baseTags = new Map(baseSwf.tags.filter((t) => t.code === 39).map((t) => [t.data.readUInt16LE(0), t]));
  const lib = library(swf);

  // New sprites: ids and names first (they may place one another).
  let next = 0;
  for (const t of swf.tags) if (KIND[t.code] && t.data.length >= 2) next = Math.max(next, t.data.readUInt16LE(0));
  const added = fresh.map((f) => ({ f, name: exportName(f), id: ++next, json: parseJson(join(assets, f), `src/assets/${f}`) }));
  for (const a of added) {
    if (lib.byName.has(a.name)) throw new Error(`src/assets/${a.f}: "${a.name}" is already exported`);
    lib.kinds.set(a.id, "sprite"); lib.names.set(a.id, a.name); lib.byName.set(a.name, a.id);
  }

  for (const f of edited) {
    const id = idOfFile(f);
    const tag = swf.tags.find((t) => t.code === 39 && t.data.readUInt16LE(0) === id);
    if (!tag || !baseTags.has(id)) throw new Error(`src/${f}: no sprite ${id} in the base`);
    const was = readSprite(baseTags.get(id).data, baseLib);
    tag.data = writeSprite(id, parseJson(join(src, f), `src/${f}`), lib, was, `src/${f}`);
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
/** A sprite's JSON with each placed id replaced by `map(id)` (exported symbols keep their name). */
function mapRefs(json, map) {
  return { ...json, frames: json.frames.map((fr) => (fr.place ? { ...fr, place: fr.place.map((o) => {
    const k = REF_KEYS.find((r) => r !== "export" && r in o);
    return k ? { ...o, [k]: map(o[k]) } : o;
  }) } : fr)) };
}

/**
 * Each character's fingerprint: what it is, not its id, which changes from a
 * version to the next. Shapes and images: their file's hash (`graphics`);
 * sprites: what they place, by fingerprint; the rest: their bytes.
 */
export function fingerprints(swf, graphics) {
  const lib = library(swf);
  const tags = new Map();
  for (const t of swf.tags) if (KIND[t.code] && t.data.length >= 2) tags.set(t.data.readUInt16LE(0), t);
  const fps = new Map(), busy = new Set();
  const fp = (id) => {
    if (fps.has(id)) return fps.get(id);
    const t = tags.get(id);
    if (!t) return `none:${id}`;
    if (busy.has(id)) return `cycle:${id}`;
    busy.add(id);
    let h;
    if (graphics.has(id)) h = graphics.get(id);
    // What it places (not its scripts: their bytecode changes with every version).
    else if (t.code === 39) { try { h = sha(JSON.stringify(mapRefs(readSprite(t.data, lib).json, fp))); } catch { h = sha(t.data.subarray(2)); } }
    else h = sha(Buffer.concat([u16(t.code), t.data.subarray(2)]));
    busy.delete(id);
    fps.set(id, h);
    return h;
  };
  for (const id of tags.keys()) fp(id);
  return fps;
}

/**
 * sprite.json edited for the previous base, carried over to the new one
 * (already extracted in src/): each found by its original's fingerprint
 * (or its export name), its ids mapped to the new base's, its edits merged
 * into the new base's sprite.json (git merge-file).
 * `edited`: [{ file, text }] (paths of the previous base, the edited text);
 * `dir`: the new base's sprites (src/timeline/sprites).
 */
export function carrySprites(edited, previous, current, previousGraphics, currentGraphics, dir = SPRITES) {
  const prevSwf = parseSwf(readFileSync(previous)), newSwf = parseSwf(readFileSync(current));
  const prevLib = library(prevSwf), newLib = library(newSwf);
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
  const prevTags = new Map(prevSwf.tags.filter((t) => t.code === 39).map((t) => [t.data.readUInt16LE(0), t]));
  const folders = spriteFolders(newSwf, dir);
  const result = { carried: [], conflicts: [], lost: [] };
  for (const { file, text } of edited) {
    const prevId = idOfFile(file);
    const name = prevLib.names.get(prevId);
    const newId = name && newLib.byName.has(name) ? newLib.byName.get(name) : counterpart(prevId);
    if (!prevTags.has(prevId) || newId === undefined || !folders.has(newId)) { result.lost.push({ file, why: `not found in the new base` }); continue; }
    let mine;
    try { mine = JSON.parse(text); } catch (e) { result.lost.push({ file, why: e.message }); continue; }
    unmapped.clear();
    const ours = formatSprite(mapRefs(mine, map));
    const was = formatSprite(mapRefs(readSprite(prevTags.get(prevId).data, prevLib).json, map));
    const target = join(dir, folders.get(newId), SPRITE_FILE);
    const to = `timeline/sprites/${folders.get(newId)}/${SPRITE_FILE}`;
    const note = unmapped.size ? ` (ids not found in the new base, kept: ${[...unmapped].join(", ")})` : "";
    if (was === readFileSync(target, "utf8")) { writeFileSync(target, ours); result.carried.push({ file, to, note }); continue; }
    // Ankama changed it too: their side, the previous original as base, ours.
    const tmp = join(ROOT, ".tmp", "sprite-merge");
    mkdirSync(tmp, { recursive: true });
    writeFileSync(join(tmp, "was.json"), was);
    writeFileSync(join(tmp, "ours.json"), ours);
    const m = spawnSync("git", ["merge-file", "-L", "new base", "-L", "previous base", "-L", "edit", target, join(tmp, "was.json"), join(tmp, "ours.json")]);
    (m.status === 0 ? result.carried : result.conflicts).push({ file, to, note });
  }
  return result;
}

/** Where a character is placed: [{ sprite, folder, frame, depth, fields }]. */
export function where(swf, id) {
  const lib = library(swf);
  const folders = spriteFolders(swf);
  const out = [];
  for (const t of swf.tags) if (t.code === 39) {
    const sid = t.data.readUInt16LE(0);
    let frame = 1;
    for (const it of innerTags(t.data)) {
      if (it.code === 1) frame++;
      if ((it.code === 26 || it.code === 70) && it.data[0] & 2 && it.data.readUInt16LE(it.code === 70 ? 4 : 3) === id) {
        out.push({ sprite: sid, name: lib.names.get(sid), folder: folders.get(sid), frame, place: readPlace(it.code, it.data, lib).o });
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
    console.log(`src/timeline/sprites/: ${n} sprite.json (base ${cfg.version}); then: node tools/manifest.mjs ${cfg.version}`);
  } else if (cmd === "where" && arg) {
    const swf = parseSwf(readFileSync(base(cfg.version).loader));
    const lib = library(swf);
    const id = /^\d+$/.test(arg) ? Number(arg) : /^[a-z]+s\/\d+$/.test(arg) ? Number(arg.split("/")[1]) : lib.byName.get(arg);
    if (id === undefined) { console.error(`no symbol exported as "${arg}"`); process.exit(1); }
    const found = where(swf, id);
    console.log(`${lib.kinds.get(id) ?? "?"} ${id}${lib.names.has(id) ? ` (${lib.names.get(id)})` : ""}: placed ${found.length} time${found.length === 1 ? "" : "s"}`);
    for (const w of found) {
      const { depth, ...rest } = w.place;
      console.log(`  src/timeline/sprites/${w.folder}/sprite.json  frame ${w.frame}, depth ${depth}: ${JSON.stringify(rest)}`);
    }
  } else { console.error("usage: node tools/sprites.mjs extract | where <id | shapes/<id> | Export>"); process.exit(2); }
}
