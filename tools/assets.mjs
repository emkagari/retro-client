/**
 * The loader's graphics as files, like its code (docs/ASSETS.md):
 *
 *   src/assets/shapes/<id>.svg   every vector shape of the base loader
 *   src/assets/images/<id>.png   every bitmap (.jpg / .gif when the base has them so)
 *   src/assets/new/<Name>.svg    a new graphic, exported by its path in lower case:
 *                                new/Name.svg → "name", new/ui/Name.svg → "ui/name" (attachMovie("ui/name", …));
 *                                new/<path>.json: a new sprite (tools/sprites.mjs), the same way
 *   src/assets/index.json        for each shape / image: the exported symbols showing it
 *
 *   node tools/assets.mjs extract            src/assets/ ← the base loader (retro.json's version)
 *   node tools/assets.mjs diff               renders what changed, before / after: .tmp/assets-diff/
 *
 * The build (tools/build.mjs) re-imports only the files that differ from the
 * base (base/<version>/manifest.json, `assets`): an untouched shape keeps the
 * base's bytes exactly, only edited ones go through FFDec's SVG import.
 */
import { createHash } from "node:crypto";
import { deflateSync as zlibSync } from "node:zlib";
import { cpSync, existsSync, mkdirSync, readFileSync, readdirSync, renameSync, rmSync, unlinkSync, writeFileSync } from "node:fs";
import { basename, extname, join } from "node:path";
import { ROOT, SRC, base, config, ffdec } from "./lib.mjs";
import { exportsOf, parseSwf, writeSwf } from "./deob/src/swf.ts";

export const ASSETS = join(SRC, "assets");
const KINDS = ["shapes", "images"];
const SHAPE_TAGS = new Set([2, 22, 32, 83]);              // DefineShape 1-4
const IMAGE_TAGS = new Set([6, 21, 35, 20, 36, 90]);      // DefineBits*, DefineBitsLossless*
const u16 = (n) => { const b = Buffer.alloc(2); b.writeUInt16LE(n); return b; };

/** An asset's hash, line endings aside for SVG (git may check them out as CRLF on Windows). */
export function assetHash(file) {
  let data = readFileSync(file);
  if (extname(file) === ".svg") data = Buffer.from(data.toString("utf8").replace(/\r\n/g, "\n"));
  return createHash("sha256").update(data).digest("hex");
}

/** Every asset file, as "shapes/12.svg", "images/3.png", "new/Name.svg", "new/ui/Name.svg" (new/: its folders too). */
export function assetFiles() {
  const out = [];
  const walk = (dir, rel, deep) => {
    for (const e of readdirSync(dir, { withFileTypes: true }).sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0))) {
      if (e.name.startsWith(".")) continue;
      if (e.isDirectory() && deep) walk(join(dir, e.name), `${rel}/${e.name}`, deep);
      else out.push(`${rel}/${e.name}`);
    }
  };
  for (const kind of [...KINDS, "new"]) {
    const dir = join(ASSETS, kind);
    if (existsSync(dir)) walk(dir, kind, kind === "new");
  }
  return out;
}

/**
 * A new graphic's export name: its path in new/, without the extension, in
 * lower case ("new/ui/Name.svg" → "ui/name"): the code needn't know how the
 * file is spelled. "/" can't be in a file name; two paths differing only by
 * case ("Name.svg", "name.svg") are refused by applyAssets. Letters, digits,
 * _ and - only (a "Name (copy).svg" is a mistake). Folders: any depth.
 */
export function exportName(f) {
  const name = f.slice("new/".length, -extname(f).length || undefined).toLowerCase();
  if (!name.split("/").every((part) => /^[A-Za-z0-9_-]+$/.test(part))) {
    throw new Error(`src/assets/${f}: a new graphic's path is letters, digits, _ and - (it is its export name: "${name}")`);
  }
  return name;
}

/** An empty folder: files removed one by one (a recursive rm of a big folder fails on some mounts). */
function emptyDir(dir) {
  mkdirSync(dir, { recursive: true });
  for (const f of readdirSync(dir)) unlinkSync(join(dir, f));
}

/** Shapes and images of a SWF into dir/shapes, dir/images (FFDec's own export). */
export function exportGraphics(cfg, loader, dir) {
  const tmp = `${dir}.export`;
  rmSync(tmp, { recursive: true, force: true, maxRetries: 5 });
  const r = ffdec(cfg, ["-format", "shape:svg,image:png_gif_jpeg", "-export", "shape,image", tmp, loader]);
  if (!r.ok) throw new Error(r.log);
  for (const kind of KINDS) {
    emptyDir(join(dir, kind));
    if (existsSync(join(tmp, kind))) for (const f of readdirSync(join(tmp, kind))) renameSync(join(tmp, kind, f), join(dir, kind, f));
  }
  rmSync(tmp, { recursive: true, force: true, maxRetries: 5 });
}

/** For each shape / image id: the exported symbols showing it, through nested sprites. */
export function graphicsIndex(loader) {
  const swf = parseSwf(readFileSync(loader));
  const names = exportsOf(swf);                          // id → export name
  const children = new Map();                            // sprite id → ids it places
  const kind = new Map();
  const placed = (data) => {                             // PlaceObject2: flags, depth, [character id]
    return data[0] & 0x02 ? data.readUInt16LE(3) : null;
  };
  const bitmapsOf = (data) => {                          // bitmap ids used by a shape's fills (any 16-bit match is fine for an index)
    const ids = [];
    for (let i = 0; i + 2 < data.length; i++) if (data[i] >= 0x40 && data[i] <= 0x43) ids.push(data.readUInt16LE(i + 1));
    return ids;
  };
  const shapeBitmaps = new Map();
  for (const t of swf.tags) {
    const id = t.data.length >= 2 ? t.data.readUInt16LE(0) : -1;
    if (SHAPE_TAGS.has(t.code)) { kind.set(id, "shape"); shapeBitmaps.set(id, bitmapsOf(t.data)); }
    else if (IMAGE_TAGS.has(t.code)) kind.set(id, "image");
    else if (t.code === 39) {
      const ids = [];
      let p = 4;
      while (p + 2 <= t.data.length) {
        const h = t.data.readUInt16LE(p); p += 2;
        let len = h & 0x3f;
        if (len === 0x3f) { len = t.data.readUInt32LE(p); p += 4; }
        const code = h >> 6;
        if (code === 26 || code === 70) {
          const body = t.data.subarray(p, p + len);
          const c = code === 26 ? placed(body) : (body[0] & 0x02 ? body.readUInt16LE(4) : null);
          if (c !== null) ids.push(c);
        }
        p += len;
        if (code === 0) break;
      }
      children.set(id, ids);
    }
  }
  const users = new Map();                               // graphic id → export names
  const visit = (sprite, name, seen) => {
    if (seen.has(sprite)) return;
    seen.add(sprite);
    for (const c of children.get(sprite) ?? []) {
      const k = kind.get(c);
      if (k) {
        if (!users.has(c)) users.set(c, new Set());
        users.get(c).add(name);
        for (const b of k === "shape" ? shapeBitmaps.get(c) ?? [] : []) if (kind.get(b) === "image") {
          if (!users.has(b)) users.set(b, new Set());
          users.get(b).add(name);
        }
      } else if (children.has(c)) visit(c, name, seen);
    }
  };
  for (const [id, name] of names) if (children.has(id)) visit(id, name, new Set());
  const index = {};
  for (const [id, k] of [...kind].sort((a, b) => a[0] - b[0])) {
    index[`${k}s/${id}`] = [...(users.get(id) ?? [])].sort();
  }
  return index;
}

/** src/assets/ ← the base loader: every shape and image, and the index. */
export function extract(cfg, loader) {
  exportGraphics(cfg, loader, ASSETS);
  writeFileSync(join(ASSETS, "index.json"), JSON.stringify(graphicsIndex(loader), null, 1) + "\n");
}

/** Asset files that differ from the base's (manifest.assets), and new ones. */
export function changedAssets(manifest) {
  const known = manifest.assets ?? {};
  return assetFiles().filter((f) => f.startsWith("new/") || (f in known && known[f] !== assetHash(join(ASSETS, f))));
}

/** A SWF RECT (twips), bit-packed. */
function rect(xmin, xmax, ymin, ymax) {
  const vals = [xmin, xmax, ymin, ymax];
  const nbits = Math.max(1, ...vals.map((v) => (v === 0 ? 0 : Math.abs(v).toString(2).length + 1)));
  let bits = nbits.toString(2).padStart(5, "0");
  for (const v of vals) bits += ((v < 0 ? (1 << nbits) + v : v) >>> 0).toString(2).padStart(nbits, "0");
  bits = bits.padEnd(Math.ceil(bits.length / 8) * 8, "0");
  return Buffer.from(bits.match(/.{8}/g).map((b) => parseInt(b, 2)));
}

/** A RECT's values and byte length, from its first byte. */
function readRect(buf, at) {
  let bit = at * 8;
  const read = (n) => { let v = 0; for (let i = 0; i < n; i++, bit++) v = (v << 1) | ((buf[bit >> 3] >> (7 - (bit & 7))) & 1); return v; };
  const nbits = read(5);
  const vals = [0, 0, 0, 0].map(() => { const v = read(nbits); return nbits && v & (1 << (nbits - 1)) ? v - (1 << nbits) : v; });
  return { vals, length: Math.ceil(bit / 8) - at };
}

/**
 * FFDec fits an imported SVG into the shape's bounds: an edited shape gets
 * bounds of its SVG's size, from the same origin (the export's translate),
 * so a drawing made bigger stays bigger. Unchanged size: the same bounds.
 */
function resizeShape(tag, file) {
  const id = tag.data.subarray(0, 2);
  const bounds = readRect(tag.data, 2);
  const [w, h] = svgSize(file);
  const [xmin, , ymin] = bounds.vals;
  const fresh = rect(xmin, xmin + Math.round(w * 20), ymin, ymin + Math.round(h * 20));
  let rest = tag.data.subarray(2 + bounds.length);
  if (tag.code === 83) rest = Buffer.concat([fresh, rest.subarray(readRect(rest, 0).length)]);   // DefineShape4: edge bounds too
  tag.data = Buffer.concat([id, fresh, rest]);
}

/** An SVG's size in pixels: width / height, else its viewBox. FFDec fits the drawing into the shape's bounds. */
function svgSize(file) {
  const head = readFileSync(file, "utf8").slice(0, 2000);
  // A line is 0 high or wide (shapes/1964.svg: height="0.0px"): 0 is a size.
  const attr = (n) => { const m = new RegExp(`\\s${n}="([\\d.]+)`).exec(head); return m ? Number(m[1]) : NaN; };
  const box = /viewBox="[\d.\s-]+?([\d.]+)\s+([\d.]+)"/.exec(head);
  const w = Number.isNaN(attr("width")) ? Number(box?.[1]) : attr("width");
  const h = Number.isNaN(attr("height")) ? Number(box?.[2]) : attr("height");
  if (!(w >= 0 && h >= 0)) throw new Error(`${file}: no width/height or viewBox`);
  return [w, h];
}

/** Bits, written most significant first. */
class Bits {
  constructor() { this.bits = ""; }
  u(n, v) { this.bits += (v >>> 0).toString(2).padStart(n, "0").slice(-n); return this; }
  s(n, v) { return this.u(n, v < 0 ? (1 << n) + v : v); }
  bytes() { return Buffer.from(this.bits.padEnd(Math.ceil(this.bits.length / 8) * 8, "0").match(/.{8}/g).map((b) => parseInt(b, 2))); }
}
const signedBits = (...vals) => Math.max(2, ...vals.map((v) => Math.abs(v).toString(2).length + 1));

/** A PNG's size, from its IHDR. */
function pngSize(file) {
  const b = readFileSync(file);
  if (b.toString("latin1", 1, 4) !== "PNG") throw new Error(`${file}: not a PNG`);
  return [b.readUInt32BE(16), b.readUInt32BE(20)];
}

/**
 * DefineShape3: a w×h px rectangle filled with bitmap `image` at 1:1
 * (clipped bitmap fill, matrix scale 20: one pixel is 20 twips).
 */
function bitmapShape(shape, image, w, h) {
  const W = w * 20, H = h * 20;
  const scale = 20 * 65536, sb = signedBits(scale);
  const matrix = new Bits().u(1, 1).u(5, sb).s(sb, scale).s(sb, scale).u(1, 0).u(5, 0).bytes();
  const fill = Buffer.concat([Buffer.from([1, 0x41]), u16(image), matrix]);         // 1 fill style: clipped bitmap
  const r = new Bits();
  r.u(1, 0).u(1, 0).u(1, 0).u(1, 1).u(1, 0).u(1, 1).u(5, 1).s(1, 0).s(1, 0).u(1, 1); // move to 0,0; fill style 1
  const edge = (dx, dy) => {
    const n = signedBits(dx || dy);
    r.u(1, 1).u(1, 1).u(4, n - 2).u(1, 0).u(1, dx === 0 ? 1 : 0).s(n, dx || dy);
  };
  edge(W, 0); edge(0, H); edge(-W, 0); edge(0, -H);
  r.u(1, 0).u(5, 0);                                                              // end
  return Buffer.concat([u16(shape), rect(0, W, 0, H), fill, Buffer.from([0]), Buffer.from([0x10]), r.bytes()]);
}

/** A tag's bytes: short header when it fits. */
const tagBytes = (code, data) => Buffer.concat([
  data.length < 0x3f ? u16((code << 6) | data.length) : Buffer.concat([u16((code << 6) | 0x3f), (() => { const b = Buffer.alloc(4); b.writeUInt32LE(data.length); return b; })()]),
  data,
]);

/**
 * The SWF with the changed assets: edited shapes and images re-imported by
 * FFDec (by id), and each new/<Name>.svg as a new shape in a clip exported
 * by its path in lower case (new/ui/<Name>.svg: "ui/<name>", exportName). Returns the names added. `dir`: where the files are (src/assets/).
 */
export function applyAssets(cfg, input, output, changed, work, dir = ASSETS) {
  const swf = parseSwf(readFileSync(input));
  const stage = join(work, "assets");
  rmSync(stage, { recursive: true, force: true, maxRetries: 5 });
  for (const kind of KINDS) mkdirSync(join(stage, kind), { recursive: true });

  // Every name new/ exports, graphics and sprites (new/<path>.json, tools/sprites.mjs): one each.
  const taken = new Set(exportsOf(swf).values());
  const ours = new Map();                                // export name → file
  for (const f of changed.filter((f) => f.startsWith("new/"))) {
    const name = exportName(f);
    if (taken.has(name)) throw new Error(`src/assets/${f}: the base already exports ${name} — edit it instead`);
    if (ours.has(name)) throw new Error(`src/assets/${ours.get(name)} and src/assets/${f}: both exported as "${name}" (names are in lower case) — rename one`);
    ours.set(name, f);
  }

  // New graphics: an empty shape (FFDec imports into an existing id), a clip placing it, its export.
  const added = [];
  const fresh = changed.filter((f) => f.startsWith("new/") && extname(f) !== ".json");
  if (fresh.length) {
    let next = 0;
    for (const t of swf.tags) if (t.data.length >= 2 && (SHAPE_TAGS.has(t.code) || IMAGE_TAGS.has(t.code) || t.code === 39 || [7, 10, 11, 34, 37, 46, 48, 75, 84, 91].includes(t.code))) next = Math.max(next, t.data.readUInt16LE(0));
    const tags = [];
    for (const f of fresh) {
      const ext = extname(f);
      if (ext !== ".svg" && ext !== ".png") throw new Error(`src/assets/${f}: what new/ holds is an .svg, a .png (graphics) or a .json (sprites)`);
      const name = exportName(f);
      const image = ext === ".png" ? ++next : 0, shape = ++next, clip = ++next;
      if (ext === ".png") {
        // A placeholder bitmap (FFDec imports the PNG into it) and a rectangle showing it at 1:1.
        const [w, h] = pngSize(join(dir, f));
        tags.push({ code: 36, data: Buffer.concat([u16(image), Buffer.from([5]), u16(1), u16(1), zlibSync(Buffer.alloc(4))]) });
        tags.push({ code: 32, data: bitmapShape(shape, image, w, h) });
        cpSync(join(dir, f), join(stage, "images", `${image}.png`));
      } else {
        // DefineShape3: id, the SVG's bounds (FFDec fits the drawing into them), no style, end record.
        const [w, h] = svgSize(join(dir, f));
        tags.push({ code: 32, data: Buffer.concat([u16(shape), rect(0, Math.round(w * 20), 0, Math.round(h * 20)), Buffer.from([0, 0, 0, 0])]) });
        cpSync(join(dir, f), join(stage, "shapes", `${shape}.svg`));
      }
      // A one-frame clip placing it (PlaceObject2: character, depth 1).
      const inner = Buffer.concat([tagBytes(26, Buffer.from([0x02, 1, 0, shape & 0xff, shape >> 8])), tagBytes(1, Buffer.alloc(0)), tagBytes(0, Buffer.alloc(0))]);
      tags.push({ code: 39, data: Buffer.concat([u16(clip), u16(1), inner]) });
      tags.push({ code: 56, data: Buffer.concat([u16(1), u16(clip), Buffer.from(name + "\0", "latin1")]) });
      added.push(name);
    }
    // First of all definitions: they need nothing, and any sprite may place them (a sprite.json of the base too).
    const at = swf.tags.findIndex((t) => ![69, 9, 24, 77, 58, 64, 65].includes(t.code));
    swf.tags.splice(at, 0, ...tags);
  }
  for (const f of changed.filter((f) => !f.startsWith("new/"))) {
    cpSync(join(dir, f), join(stage, f));
    if (f.startsWith("shapes/")) {
      const id = Number(basename(f, ".svg"));
      const tag = swf.tags.find((t) => SHAPE_TAGS.has(t.code) && t.data.readUInt16LE(0) === id);
      if (!tag) throw new Error(`src/assets/${f}: no shape ${id} in the base`);
      resizeShape(tag, join(dir, f));
    }
  }

  let current = join(work, "assets-0.swf");
  writeFileSync(current, writeSwf(swf));
  const step = (args, label) => {
    const next = join(work, `assets-${label}.swf`);
    const r = ffdec(cfg, [...args.slice(0, 1), current, next, ...args.slice(1)]);
    if (!r.ok || !existsSync(next)) throw new Error(`FFDec ${args[0]}: ${r.log.trim().split("\n").slice(-3).join(" ")}`);
    current = next;
  };
  if (readdirSync(join(stage, "shapes")).length) step(["-importShapes", join(stage, "shapes")], "shapes");
  if (readdirSync(join(stage, "images")).length) step(["-importImages", join(stage, "images")], "images");
  cpSync(current, output);
  return added;
}

/** Renders each changed asset before (the base) and after (src/assets): .tmp/assets-diff/<file>.before|after.png. */
function diff(cfg) {
  const b = base(cfg.version);
  const changed = changedAssets(b.manifest);
  const out = join(ROOT, ".tmp", "assets-diff");
  rmSync(out, { recursive: true, force: true, maxRetries: 5 });
  mkdirSync(out, { recursive: true });
  if (!changed.length) { console.log("no asset differs from the base"); return; }
  const work = join(ROOT, ".tmp", `assets-${process.pid}`);
  mkdirSync(work, { recursive: true });
  try {
    const after = join(work, "after.swf");
    applyAssets(cfg, b.loader, after, changed, work);
    // Only the changed shapes (rendering all of them takes long).
    const ids = changed.filter((f) => f.startsWith("shapes/")).map((f) => basename(f, ".svg"));
    const render = (swf, to) => ids.length && ffdec(cfg, ["-format", "shape:png", "-selectid", ids.join(","), "-export", "shape", to, swf]);
    render(b.loader, join(work, "before"));
    render(after, join(work, "after"));
    const find = (dir, name) => {
      if (!existsSync(dir)) return null;
      for (const e of readdirSync(dir, { withFileTypes: true })) {
        const p = join(dir, e.name);
        if (e.isDirectory()) { const r = find(p, name); if (r) return r; } else if (e.name === name) return p;
      }
      return null;
    };
    for (const id of ids) for (const side of ["before", "after"]) {
      const png = find(join(work, side), `${id}.png`);
      if (png) cpSync(png, join(out, `${id}.${side}.png`));
    }
    console.log(`${changed.length} changed asset(s); renders in ${out}`);
  } finally {
    rmSync(work, { recursive: true, force: true, maxRetries: 5 });
  }
}

if (process.argv[1] && import.meta.url.endsWith(basename(process.argv[1]))) {
  const cfg = config();
  const cmd = process.argv[2];
  if (cmd === "extract") {
    extract(cfg, base(cfg.version).loader);
    const n = assetFiles().length;
    console.log(`src/assets/: ${n} files (base ${cfg.version}); then: node tools/manifest.mjs ${cfg.version}`);
  } else if (cmd === "diff") diff(cfg);
  else { console.error("usage: node tools/assets.mjs extract | diff"); process.exit(2); }
}
