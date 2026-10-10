/**
 * Non-regression tests for the graphics (docs/ASSETS.md): base loader →
 * src/assets/ → final loader.
 *
 *   node tools/test-assets.mjs              every test (~1 min)
 *   node tools/test-assets.mjs --update     the same, and records the round trip as the expected one
 *
 * 1. inventory   src/assets/ is the base's graphics: one file per shape / image,
 *                the manifest's hashes, index.json as the base computes it, no stray file;
 * 2. identity    nothing edited: the loader keeps the base's bytes;
 * 3. isolation   one shape edited: only its tag changes;
 * 4. size        a drawing made bigger: its bounds follow;
 * 5. new         new/ui/deep/<Name>.svg and new/<Name>.png: exported by their path in
 *                lower case ("ui/deep/<name>", "<name>"), drawn as given; a path that
 *                can't be a name refused, two files of the same name too;
 * 6. round trip  every shape and image re-imported, rendered before / after,
 *                compared pixel by pixel. What isn't identical is recorded in
 *                tools/test-assets.json (with --update): the test fails on a
 *                graphic that comes back worse than recorded, or on a new one.
 *
 * Renders of what differs: .tmp/assets-test/<kind>/<id>.before|after.png.
 */
import { cpSync, existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { basename, extname, join } from "node:path";
import { deflateSync, inflateSync } from "node:zlib";
import { ROOT, base, config, ffdec } from "./lib.mjs";
import { ASSETS, applyAssets, assetFiles, assetHash, exportName, graphicsIndex } from "./assets.mjs";
import { exportsOf, parseSwf } from "./deob/src/swf.ts";

const SHAPE_TAGS = new Set([2, 22, 32, 83]);
const IMAGE_TAGS = new Set([6, 21, 35, 20, 36, 90]);
const EXPECTED = join(ROOT, "tools", "test-assets.json");
// A pixel differs when a channel moves by more than this (anti-aliasing rounds by a few levels).
const TOLERANCE = 8;
// "close": at most this share of the pixels differs (an edge's anti-aliasing).
const CLOSE = 0.01;

const update = process.argv.includes("--update");
const cfg = config();
const b = base(cfg.version);
const work = join(ROOT, ".tmp", "assets-test");
rmSync(work, { recursive: true, force: true, maxRetries: 5 });
mkdirSync(work, { recursive: true });

let failed = 0;
const results = [];
function test(name, fn) {
  const t = Date.now();
  try {
    const notes = fn() ?? [];
    results.push(name);
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

// --- PNG ------------------------------------------------------------------

/** A PNG's pixels as RGBA (8-bit, non-interlaced: what FFDec and most editors write). */
function readPng(file) {
  const buf = readFileSync(file);
  let p = 8, w, h, depth, type, interlace, palette, trns;
  const idat = [];
  while (p < buf.length) {
    const len = buf.readUInt32BE(p), kind = buf.toString("latin1", p + 4, p + 8), data = buf.subarray(p + 8, p + 8 + len);
    if (kind === "IHDR") [w, h, depth, type, interlace] = [data.readUInt32BE(0), data.readUInt32BE(4), data[8], data[9], data[12]];
    else if (kind === "PLTE") palette = data;
    else if (kind === "tRNS") trns = data;
    else if (kind === "IDAT") idat.push(data);
    p += 12 + len;
  }
  if (depth !== 8 || interlace) throw new Error(`${file}: PNG of depth ${depth}${interlace ? ", interlaced" : ""} not read`);
  const channels = { 0: 1, 2: 3, 3: 1, 4: 2, 6: 4 }[type];
  const raw = inflateSync(Buffer.concat(idat)), stride = w * channels;
  const px = Buffer.alloc(w * h * 4);
  let prev = Buffer.alloc(stride);
  for (let y = 0; y < h; y++) {
    const filter = raw[y * (stride + 1)], line = Buffer.from(raw.subarray(y * (stride + 1) + 1, (y + 1) * (stride + 1)));
    for (let i = 0; i < stride; i++) {
      const a = i >= channels ? line[i - channels] : 0, up = prev[i], c = i >= channels ? prev[i - channels] : 0;
      const pa = Math.abs(up - c), pb = Math.abs(a - c), pc = Math.abs(a + up - 2 * c);
      line[i] = (line[i] + [0, a, up, (a + up) >> 1, pa <= pb && pa <= pc ? a : pb <= pc ? up : c][filter]) & 0xff;
    }
    for (let x = 0; x < w; x++) {
      const o = (y * w + x) * 4, s = x * channels;
      if (type === 6) line.copy(px, o, s, s + 4);
      else if (type === 2) { line.copy(px, o, s, s + 3); px[o + 3] = 255; }
      else if (type === 0) { px.fill(line[s], o, o + 3); px[o + 3] = 255; }
      else if (type === 4) { px.fill(line[s], o, o + 3); px[o + 3] = line[s + 1]; }
      else { palette.copy(px, o, line[s] * 3, line[s] * 3 + 3); px[o + 3] = trns && line[s] < trns.length ? trns[line[s]] : 255; }
    }
    prev = line;
  }
  return { w, h, px };
}

/** An RGBA PNG. */
function writePng(file, w, h, px) {
  const crcTable = Array.from({ length: 256 }, (_, n) => { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1; return c >>> 0; });
  const crc = (b) => { let c = 0xffffffff; for (const x of b) c = crcTable[(c ^ x) & 0xff] ^ (c >>> 8); return (c ^ 0xffffffff) >>> 0; };
  const chunk = (kind, data) => {
    const head = Buffer.alloc(8); head.writeUInt32BE(data.length); head.write(kind, 4, "latin1");
    const tail = Buffer.alloc(4); tail.writeUInt32BE(crc(Buffer.concat([head.subarray(4), data])));
    return Buffer.concat([head, data, tail]);
  };
  const ihdr = Buffer.alloc(13); ihdr.writeUInt32BE(w); ihdr.writeUInt32BE(h, 4); ihdr[8] = 8; ihdr[9] = 6;
  const raw = Buffer.concat(Array.from({ length: h }, (_, y) => Buffer.concat([Buffer.from([0]), px.subarray(y * w * 4, (y + 1) * w * 4)])));
  writeFileSync(file, Buffer.concat([Buffer.from("\x89PNG\r\n\x1a\n", "latin1"), chunk("IHDR", ihdr), chunk("IDAT", deflateSync(raw)), chunk("IEND", Buffer.alloc(0))]));
}

/** How two renders compare: identical, close (anti-aliasing), different, or resized. */
function compare(fileA, fileB) {
  const a = readPng(fileA), b = readPng(fileB);
  if (a.w !== b.w || a.h !== b.h) return { status: "resized", detail: `${a.w}x${a.h} → ${b.w}x${b.h}` };
  let diff = 0, max = 0;
  for (let i = 0; i < a.px.length; i += 4) {
    // Fully transparent on both sides: the colour doesn't show.
    if (a.px[i + 3] === 0 && b.px[i + 3] === 0) continue;
    let d = 0;
    for (let c = 0; c < 4; c++) d = Math.max(d, Math.abs(a.px[i + c] - b.px[i + c]));
    max = Math.max(max, d);
    if (d > TOLERANCE) diff++;
  }
  const share = diff / (a.w * a.h);
  const status = max === 0 ? "identical" : diff === 0 || share <= CLOSE ? "close" : "different";
  return { status, detail: `${(share * 100).toFixed(2)} % of pixels, delta up to ${max}` };
}
const RANK = { identical: 0, close: 1, different: 2, resized: 3, missing: 4 };

// --- SWF helpers ----------------------------------------------------------

const tagsOf = (file) => parseSwf(readFileSync(file)).tags;
const idOf = (t) => (t.data.length >= 2 ? t.data.readUInt16LE(0) : -1);
const shapeTag = (tags, id) => tags.find((t) => SHAPE_TAGS.has(t.code) && idOf(t) === id);

/** A RECT's values in twips, from its first byte. */
function readRect(buf, at) {
  let bit = at * 8;
  const read = (n) => { let v = 0; for (let i = 0; i < n; i++, bit++) v = (v << 1) | ((buf[bit >> 3] >> (7 - (bit & 7))) & 1); return v; };
  const nbits = read(5);
  return [0, 0, 0, 0].map(() => { const v = read(nbits); return nbits && v & (1 << (nbits - 1)) ? v - (1 << nbits) : v; });
}
const bounds = (tag) => readRect(tag.data, 2);

/** FFDec's renders of a SWF's shapes and images (ids: only those). */
function render(swf, out, ids) {
  const sel = ids ? ["-selectid", ids.join(",")] : [];
  const r = ffdec(cfg, ["-onerror", "ignore", "-format", "shape:png,image:png", ...sel, "-export", "shape,image", out, swf]);
  if (!r.ok) throw new Error(`FFDec render: ${r.log.trim().split("\n").slice(-3).join(" ")}`);
}

/** A copy of src/assets/ to edit (shapes / images linked by path: only the edited files are copied). */
function scratchAssets(name) {
  const dir = join(work, name);
  for (const kind of ["shapes", "images", "new"]) mkdirSync(join(dir, kind), { recursive: true });
  return dir;
}

// --- Tests ----------------------------------------------------------------

const baseTags = tagsOf(b.loader);
const baseIds = { shapes: baseTags.filter((t) => SHAPE_TAGS.has(t.code)).map(idOf), images: baseTags.filter((t) => IMAGE_TAGS.has(t.code)).map(idOf) };

test("inventory: src/assets/ holds the base's graphics", () => {
  const files = assetFiles().filter((f) => !f.startsWith("new/"));
  const byKind = { shapes: [], images: [] };
  for (const f of files) byKind[f.split("/")[0]].push(f);
  const problems = [];
  for (const kind of ["shapes", "images"]) {
    const have = new Map(byKind[kind].map((f) => [Number(basename(f, extname(f))), f]));
    const stray = byKind[kind].filter((f) => !/^\d+$/.test(basename(f, extname(f))) || !baseIds[kind].includes(Number(basename(f, extname(f)))));
    for (const f of stray) problems.push(`stray file src/assets/${f} (no ${kind.slice(0, -1)} of this id in the base)`);
    for (const id of baseIds[kind]) if (!have.has(id)) problems.push(`${kind}/${id}: in the base, no file`);
  }
  const known = b.manifest.assets ?? {};
  const unrecorded = files.filter((f) => !(f in known));
  for (const f of unrecorded) problems.push(`src/assets/${f}: not in base/${cfg.version}/manifest.json (never re-imported by the build)`);
  for (const f of Object.keys(known)) if (!existsSync(join(ASSETS, f))) problems.push(`src/assets/${f}: in the manifest, missing`);
  const index = JSON.parse(readFileSync(join(ASSETS, "index.json"), "utf8"));
  if (JSON.stringify(index) !== JSON.stringify(graphicsIndex(b.loader))) problems.push("src/assets/index.json differs from the base's (node tools/assets.mjs extract)");
  check(!problems.length, problems.slice(0, 20).join("\n") + (problems.length > 20 ? `\n… ${problems.length - 20} more` : ""));
  const edited = files.filter((f) => f in known && known[f] !== assetHash(join(ASSETS, f)));
  return [`${byKind.shapes.length} shapes, ${byKind.images.length} images${edited.length ? `; edited: ${edited.join(", ")}` : ""}`];
});

test("identity: nothing edited, the base's bytes", () => {
  const out = join(work, "identity.swf");
  applyAssets(cfg, b.loader, out, [], join(work, "identity"));
  check(readFileSync(out).equals(readFileSync(b.loader)), "the loader differs from the base");
});

// A vector shape of the login screen: a colour changed, then made twice as big.
const SAMPLE = 871;
const sampleSvg = readFileSync(join(ASSETS, "shapes", `${SAMPLE}.svg`), "utf8");

test(`isolation: shapes/${SAMPLE}.svg recoloured, only its tag changes`, () => {
  const dir = scratchAssets("isolation");
  const colours = [...new Set(sampleSvg.match(/#[0-9a-f]{6}/gi) ?? [])];
  check(colours.length, `shapes/${SAMPLE}.svg has no colour to change`);
  writeFileSync(join(dir, "shapes", `${SAMPLE}.svg`), sampleSvg.split(colours[0]).join("#ff00ff"));
  const out = join(work, "isolation.swf");
  applyAssets(cfg, b.loader, out, [`shapes/${SAMPLE}.svg`], join(work, "isolation-work"), dir);
  const tags = tagsOf(out);
  check(tags.length === baseTags.length, `${baseTags.length} tags → ${tags.length}`);
  const changed = tags.map((t, i) => (t.code !== baseTags[i].code || !t.data.equals(baseTags[i].data) ? i : -1)).filter((i) => i >= 0);
  check(changed.length === 1 && SHAPE_TAGS.has(tags[changed[0]].code) && idOf(tags[changed[0]]) === SAMPLE,
    `changed tags: ${changed.map((i) => `#${i} (code ${tags[i].code}, id ${idOf(tags[i])})`).join(", ")}`);
  check(bounds(tags[changed[0]]).join() === bounds(shapeTag(baseTags, SAMPLE)).join(), "its bounds changed with its size unchanged");
  render(out, join(work, "isolation-render"), [SAMPLE]);
  render(b.loader, join(work, "isolation-base"), [SAMPLE]);
  const c = compare(join(work, "isolation-base", "shapes", `${SAMPLE}.png`), join(work, "isolation-render", "shapes", `${SAMPLE}.png`));
  check(c.status === "different", `the recoloured shape renders ${c.status} to the base's`);
  return [`${colours[0]} → #ff00ff: ${c.detail}`];
});

test(`size: shapes/${SAMPLE}.svg twice as big, its bounds follow`, () => {
  const dir = scratchAssets("size");
  const w = Number(/\swidth="([\d.]+)/.exec(sampleSvg)[1]), h = Number(/\sheight="([\d.]+)/.exec(sampleSvg)[1]);
  const bigger = sampleSvg
    .replace(/(\swidth=")[\d.]+/, `$1${w * 2}`)
    .replace(/(\sheight=")[\d.]+/, `$1${h * 2}`)
    .replace(/(<svg[^>]*>)/, '$1<g transform="scale(2)">')
    .replace(/<\/svg>\s*$/, "</g></svg>\n");
  writeFileSync(join(dir, "shapes", `${SAMPLE}.svg`), bigger);
  const out = join(work, "size.swf");
  applyAssets(cfg, b.loader, out, [`shapes/${SAMPLE}.svg`], join(work, "size-work"), dir);
  const [x0, x1, y0, y1] = bounds(shapeTag(baseTags, SAMPLE));
  const [nx0, nx1, ny0, ny1] = bounds(shapeTag(tagsOf(out), SAMPLE));
  check(nx0 === x0 && ny0 === y0, `origin moved: ${x0},${y0} → ${nx0},${ny0}`);
  check(Math.abs((nx1 - nx0) - 2 * (x1 - x0)) <= 20 && Math.abs((ny1 - ny0) - 2 * (y1 - y0)) <= 20,
    `bounds ${(x1 - x0) / 20}x${(y1 - y0) / 20} px → ${(nx1 - nx0) / 20}x${(ny1 - ny0) / 20} px, expected twice`);
  render(out, join(work, "size-render"), [SAMPLE]);
  const r = readPng(join(work, "size-render", "shapes", `${SAMPLE}.png`));
  check(Math.abs(r.w - 2 * w) <= 2 && Math.abs(r.h - 2 * h) <= 2, `rendered ${r.w}x${r.h}, expected ${w * 2}x${h * 2}`);
  return [`${w}x${h} → ${r.w}x${r.h} px`];
});

test("new: new/ui/deep/TestSvg.svg and new/TestPng.png, exported and drawn as given", () => {
  const dir = scratchAssets("new");
  // In folders: exported by its path in lower case, "ui/deep/testsvg".
  mkdirSync(join(dir, "new", "ui", "deep"), { recursive: true });
  writeFileSync(join(dir, "new", "ui", "deep", "TestSvg.svg"),
    '<svg xmlns="http://www.w3.org/2000/svg" width="40" height="20"><rect x="0" y="0" width="40" height="20" fill="#ff0000"/></svg>\n');
  // 8x4: a gradient, half transparent on its right half.
  const pw = 8, ph = 4, px = Buffer.alloc(pw * ph * 4);
  for (let y = 0; y < ph; y++) for (let x = 0; x < pw; x++) px.set([x * 32, y * 64, 200, x < 4 ? 255 : 128], (y * pw + x) * 4);
  writePng(join(dir, "new", "TestPng.png"), pw, ph, px);
  const out = join(work, "new.swf");
  const added = applyAssets(cfg, b.loader, out, ["new/TestPng.png", "new/ui/deep/TestSvg.svg"], join(work, "new-work"), dir);
  check(added.join() === "testpng,ui/deep/testsvg", `added: ${added.join(", ")}`);
  const swf = parseSwf(readFileSync(out));
  const exported = new Map([...exportsOf(swf)].map(([id, name]) => [name, id]));
  for (const n of added) check(exported.has(n), `${n} not exported`);
  // Each export is a clip placing one new shape.
  const placed = (clip) => {
    const t = swf.tags.find((t) => t.code === 39 && idOf(t) === clip);
    return t.data.readUInt16LE(4 + 2 + 1 + 2);       // sprite id, frames, PlaceObject2 header (short), flags, depth → character
  };
  const svgShape = placed(exported.get("ui/deep/testsvg")), pngShape = placed(exported.get("testpng"));
  render(out, join(work, "new-render"), [svgShape, pngShape]);
  const s = readPng(join(work, "new-render", "shapes", `${svgShape}.png`));
  check(s.w === 40 && s.h === 20, `TestSvg rendered ${s.w}x${s.h}, expected 40x20`);
  const centre = (s.h / 2 * s.w + s.w / 2) * 4;
  check(s.px[centre] === 255 && s.px[centre + 1] === 0 && s.px[centre + 2] === 0 && s.px[centre + 3] === 255, `TestSvg's centre: rgba(${[...s.px.subarray(centre, centre + 4)]})`);
  const p = readPng(join(work, "new-render", "shapes", `${pngShape}.png`));
  check(p.w === pw && p.h === ph, `TestPng rendered ${p.w}x${p.h}, expected ${pw}x${ph}`);
  let max = 0;
  for (let i = 0; i < px.length; i += 4) {
    // FFDec renders a half-transparent pixel premultiplied and back: a level or two off.
    for (let c = 0; c < 4; c++) max = Math.max(max, Math.abs(px[i + c] - p.px[i + c]));
  }
  check(max <= 2, `TestPng's pixels off by up to ${max}`);
  for (const bad of ["new/Test (copy).svg", "new/ui/été.svg", "new/a b/Test.svg"]) {
    let refused = false;
    try { exportName(bad); } catch { refused = true; }
    check(refused, `${bad}: taken as the name "${bad.slice(4, -4)}"`);
  }
  // Two files of the same name but for case: refused (where the file system tells them apart).
  const dup = scratchAssets("new-dup");
  const square = '<svg xmlns="http://www.w3.org/2000/svg" width="4" height="4"><rect width="4" height="4"/></svg>\n';
  writeFileSync(join(dup, "new", "Dup.svg"), square);
  writeFileSync(join(dup, "new", "dup.svg"), square);
  if (readdirSync(join(dup, "new")).length === 2) {
    let message = "";
    try { applyAssets(cfg, b.loader, join(work, "new-dup.swf"), ["new/Dup.svg", "new/dup.svg"], join(work, "new-dup-work"), dup); } catch (e) { message = e.message; }
    check(message.includes('both exported as "dup"'), `new/Dup.svg and new/dup.svg: ${message || "both accepted"}`);
  }
  return [`ui/deep/testsvg: shape ${svgShape}, testpng: shape ${pngShape}${max ? ` (pixels within ${max})` : ", pixels exact"}`];
});

test("round trip: every shape and image re-imported, rendered as before", () => {
  const all = assetFiles().filter((f) => !f.startsWith("new/"));
  const out = join(work, "roundtrip.swf");
  applyAssets(cfg, b.loader, out, all, join(work, "roundtrip-work"));
  render(b.loader, join(work, "before"));
  render(out, join(work, "after"));
  const tags = tagsOf(out);

  const found = {};
  for (const f of all) {
    const [kind, file] = f.split("/");
    const id = basename(file, extname(file));
    const before = join(work, "before", kind, `${id}.png`), after = join(work, "after", kind, `${id}.png`);
    let r;
    if (!existsSync(before)) {
      // Nothing to draw (a line 0 px high): its bounds must come back the same.
      if (kind === "shapes") {
        const was = bounds(shapeTag(baseTags, Number(id))).join(), is = shapeTag(tags, Number(id)) && bounds(shapeTag(tags, Number(id))).join();
        r = was === is ? { status: "identical", detail: "not rendered (empty), same bounds" } : { status: "different", detail: `not rendered (empty), bounds ${was} → ${is}` };
      } else r = { status: "missing", detail: "not rendered from the base" };
    } else if (!existsSync(after)) r = { status: "missing", detail: "not rendered after the round trip" };
    else r = compare(before, after);
    if (kind === "shapes" && r.status !== "missing") {
      const was = bounds(shapeTag(baseTags, Number(id))), is = bounds(shapeTag(tags, Number(id)));
      if (was.join() !== is.join()) r = { status: r.status === "identical" ? "close" : r.status, detail: `${r.detail}; bounds ${was.join()} → ${is.join()}` };
    }
    if (r.status !== "identical") {
      found[f] = r;
      mkdirSync(join(work, "diff", kind), { recursive: true });
      if (existsSync(before)) cpSync(before, join(work, "diff", kind, `${id}.before.png`));
      if (existsSync(after)) cpSync(after, join(work, "diff", kind, `${id}.after.png`));
    }
  }
  // Bitmaps FFDec added: an edited shape with a bitmap fill gets a copy of it.
  const extraImages = tags.filter((t) => IMAGE_TAGS.has(t.code)).length - baseIds.images.length;

  const counts = {};
  for (const f of all) { const s = found[f]?.status ?? "identical"; counts[s] = (counts[s] ?? 0) + 1; }
  const summary = Object.entries(counts).sort((x, y) => RANK[x[0]] - RANK[y[0]]).map(([s, n]) => `${n} ${s}`).join(", ");
  const notes = [`${all.length} graphics: ${summary}`];
  if (extraImages) notes.push(`${extraImages} bitmap(s) added by FFDec (shapes with a bitmap fill, re-imported: a copy each)`);

  const current = { base: cfg.version, tolerance: TOLERANCE, close: CLOSE, extraImages, graphics: Object.fromEntries(Object.entries(found).sort((x, y) => x[0].localeCompare(y[0], "en", { numeric: true }))) };
  if (update || !existsSync(EXPECTED)) {
    writeFileSync(EXPECTED, JSON.stringify(current, null, 1) + "\n");
    notes.push(`recorded in tools/test-assets.json`);
    return notes;
  }
  const expected = JSON.parse(readFileSync(EXPECTED, "utf8"));
  const worse = [];
  for (const f of all) {
    const now = found[f]?.status ?? "identical", was = expected.graphics[f]?.status ?? "identical";
    if (RANK[now] > RANK[was]) worse.push(`${f}: ${was} → ${now} (${found[f].detail})`);
  }
  if (extraImages > (expected.extraImages ?? 0)) worse.push(`bitmaps added: ${expected.extraImages ?? 0} → ${extraImages}`);
  const better = Object.keys(expected.graphics).filter((f) => RANK[found[f]?.status ?? "identical"] < RANK[expected.graphics[f].status]);
  if (better.length) notes.push(`better than recorded: ${better.join(", ")} (--update to record)`);
  check(!worse.length, `worse than tools/test-assets.json (renders: .tmp/assets-test/diff/):\n${worse.join("\n")}`);
  return notes;
});

console.log(failed ? `\n${failed} test(s) failed` : `\nall ${results.length} tests passed`);
process.exit(failed ? 1 : 0);
