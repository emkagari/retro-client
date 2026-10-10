/**
 * The sprite editor (proof of concept): a page in the browser, over the
 * repo's own files — src/timeline/…/*.json, src/assets/ (docs/SPRITES.md).
 *
 *   node tools/editor/editor.mjs [--port 4777]      then open http://localhost:4777
 *
 * The page draws sprites itself (SVG: the shapes of src/assets/shapes/ placed
 * by the sprite.json), so an edit shows at once. This server only does what a
 * page can't: list the library, read and write files under src/, check a
 * JSON with the build's own encoder before saving it, run the build.
 * Nothing to install: Node, as for the other tools.
 */
import { spawn } from "node:child_process";
import { existsSync, mkdirSync, readdirSync, readFileSync, renameSync, statSync, writeFileSync } from "node:fs";
import { createServer } from "node:http";
import { dirname, extname, join, normalize, sep } from "node:path";
import { ROOT, SRC, base, config } from "../lib.mjs";
import { assetFiles, exportName } from "../assets.mjs";
import { context, fileId, fileKind, formatJson, objectFiles, readObject, where, writeObject, writeSprite } from "../sprites.mjs";
import { parseSwf } from "../deob/src/swf.ts";
import { decode, readPool, readPush } from "../deob/src/avm1.ts";

const args = process.argv.slice(2);
const port = Number(args.includes("--port") ? args[args.indexOf("--port") + 1] : 4777);
const host = process.env.RETRO_EDITOR_HOST ?? "127.0.0.1";
// The game's texts (a server's lang_fr_….swf): what code puts in a label shows as the player reads it.
const langFile = args.includes("--lang") ? args[args.indexOf("--lang") + 1] : process.env.RETRO_LANG ?? config().lang;
const HERE = import.meta.dirname;

const cfg = config();
const b = base(cfg.version);
const baseSwf = parseSwf(readFileSync(b.loader));
const baseCtx = context(baseSwf);
const objects = objectFiles(baseSwf);
const definition = (id) => baseSwf.tags.find((t) => [39, 34, 37, 11, 33].includes(t.code) && t.data.readUInt16LE(0) === id);

/** Our new graphics and sprites (src/assets/new/), by export name. */
function fresh() {
  return assetFiles().filter((f) => f.startsWith("new/")).map((f) => {
    let name;
    try { name = exportName(f); } catch { name = null; }
    const ext = extname(f);
    return { file: `assets/${f}`, name, kind: ext === ".json" ? "sprite" : "graphic", ext };
  });
}

/** What the page lists: every sprite, button, text, shape, image of the base, and ours. */
function libraryIndex() {
  const out = { version: cfg.version, objects: [], shapes: [], images: [], fresh: fresh() };
  for (const [id, o] of objects) out.objects.push({ id, kind: o.kind, file: o.file, name: baseCtx.lib.names.get(id) ?? null });
  for (const f of assetFiles()) {
    if (f.startsWith("shapes/")) out.shapes.push({ id: Number(f.slice(7, -4)), file: `assets/${f}` });
    else if (f.startsWith("images/")) out.images.push({ id: Number(f.split("/")[1].split(".")[0]), file: `assets/${f}` });
  }
  out.shapes.sort((a, c) => a.id - c.id);
  // Every id's kind (what a placement may name) and every export's id.
  out.kinds = Object.fromEntries(baseCtx.lib.kinds);
  out.exports = Object.fromEntries(baseCtx.lib.byName);
  return out;
}

// --- What code draws: the gapi components (docs/EDITOR.md) -------------------

/** Every `.as` file under a folder. */
const asFiles = (dir) => readdirSync(dir, { recursive: true }).filter((f) => f.endsWith(".as")).map((f) => join(dir, f));

/** A literal of the decompiled code (a style, a parameter) as JSON, or the text itself. */
function literal(text) {
  const t = text.trim();
  try { return JSON.parse(t.replace(/([{,]\s*)([A-Za-z_]\w*)\s*:/g, '$1"$2":')); } catch { return t; }
}

/**
 * What the components need to be drawn as the game draws them: the styles
 * (ank's defaults, then Dofus's, as DofusCore loads them) and each export's
 * class (Object.registerClass).
 */
let uiCache = null;
function uiInfo() {
  if (uiCache) return uiCache;
  const styles = {}, classes = {};
  for (const f of ["ank/gapi/styles/DefaultStylePackage.as", "dofus/graphics/gapi/styles/DofusStylePackage.as"]) {
    const p = join(SRC, "classes", f);
    if (!existsSync(p)) continue;
    for (const m of readFileSync(p, "utf8").matchAll(/^\s*static var (\w+) = (\{.*\});\s*$/gm)) {
      const v = literal(m[2]);
      if (typeof v === "object") styles[m[1]] = v;
    }
  }
  for (const f of asFiles(join(SRC, "classes"))) {
    const text = readFileSync(f, "utf8");
    if (text.includes("registerClass")) for (const m of text.matchAll(/registerClass\("([^"]+)",\s*([\w.]+)\)/g)) classes[m[1]] ??= m[2];
  }
  return (uiCache = { styles, classes });
}

/** A lang_xx.swf's texts: { KEY: "text" } (each one a variable its actions set). */
let langCache = null;
function langTexts() {
  if (langCache) return langCache;
  langCache = {};
  if (!langFile || !existsSync(langFile)) return langCache;
  const utf8 = (v) => Buffer.from(v, "latin1").toString("utf8");
  for (const t of parseSwf(readFileSync(langFile)).tags) if (t.code === 12) {
    let pool = [], stack = [];
    for (const a of decode(t.data)) {
      if (a.code === 0x88) pool = readPool(a).map(utf8);
      else if (a.code === 0x96) for (const v of readPush(a)) stack.push(v.t === "const" ? pool[v.v] : v.t === "str" ? utf8(v.v) : v.v ?? null);
      else if (a.code === 0x1d) { const value = stack.pop(), key = stack.pop(); if (typeof key === "string" && typeof value === "string") langCache[key] = value; }
      else if (a.code === 0x4f) { stack.pop(); stack.pop(); stack.pop(); }
      else if (a.code === 0x1c) { stack.pop(); stack.push(null); }
      else if (a.code === 0x4e) { stack.pop(); stack.pop(); stack.push(null); }
      else if (a.code === 0x17) stack.pop();
    }
  }
  console.log(`texts: ${Object.keys(langCache).length} from ${langFile}`);
  return langCache;
}

/**
 * What a sprite's class does to its lines: the texts it puts in its
 * components (`this._btnSelect.label = this.api.lang.getText("SELECT")`):
 * `texts`, { _btnSelect: { key, text } } — `code` when it's something else
 * (a name, a number…); what it hides as it starts (`_visible = false` in
 * its constructor, createChildren or init: a placer, a panel shown later) or uses as a mask
 * (setMask): `hidden`.
 */
function codeInfo(rel) {
  const id = fileId(rel), name = id !== undefined ? baseCtx.lib.names.get(id) : null, cls = name && uiInfo().classes[name];
  const file = cls && join(SRC, "classes", ...cls.split(".")) + ".as";
  const texts = {}, hidden = [];
  if (!file || !existsSync(file)) return { texts, hidden };
  const lang = langTexts(), code = readFileSync(file, "utf8");
  for (const m of code.matchAll(/this\.(_\w+)\.(label|text|title|htmlText) = ([^;\n]+)/g)) {
    if (texts[m[1]]?.key) continue;
    const key = /^this\.api\.lang\.getText\("(\w+)"/.exec(m[3])?.[1];
    texts[m[1]] = key ? { key, text: lang[key] } : { code: true };
  }
  // Statements of the method itself (not in an if): its body's indentation.
  const ctor = cls.split(".").pop();
  for (const m of code.matchAll(new RegExp(`^   function (?:createChildren|init|${ctor})\\(\\)\\n   \\{\\n([\\s\\S]*?)\\n   \\}$`, "gm"))) {
    for (const v of m[1].matchAll(/^      this\.(_\w+)\._visible = false;$/gm)) hidden.push(v[1]);
  }
  // A clip used as a mask by code (setMask) doesn't show either.
  for (const m of code.matchAll(/\.setMask\(this\.(_\w+)\)/g)) if (!hidden.includes(m[1])) hidden.push(m[1]);
  return { texts, hidden };
}

/**
 * A sprite's components' parameters, from its clip actions
 * (frame_N/PlaceObject2_<id>_<name>_<depth>/…on(construct).as):
 * { frame: { depth: { label: "…", styleName: "…" } } }.
 */
function placeParams(rel) {
  const out = {};
  const p = srcPath(rel);
  if (!p || !rel.startsWith("timeline/")) return out;
  const dir = dirname(p);
  if (!existsSync(dir)) return out;
  Object.assign(out, codeInfo(rel));
  for (const frame of readdirSync(dir)) {
    const fm = /^frame_(\d+)$/.exec(frame);
    if (!fm) continue;
    for (const place of readdirSync(join(dir, frame))) {
      const pm = /^PlaceObject\d?_.*_(\d+)$/.exec(place);
      if (!pm || !statSync(join(dir, frame, place)).isDirectory()) continue;
      const params = {};
      for (const f of readdirSync(join(dir, frame, place)).filter((x) => /construct|initialize/.test(x))) {
        for (const m of readFileSync(join(dir, frame, place, f), "utf8").matchAll(/^\s*(\w+) = (.+);\s*$/gm)) params[m[1]] = literal(m[2]);
      }
      if (Object.keys(params).length) ((out[fm[1]] ??= {})[pm[1]] = params);
    }
  }
  return out;
}

/** A path under src/, or null (nothing outside it is served or written). */
function srcPath(rel) {
  if (!rel) return null;
  const p = normalize(join(SRC, rel));
  return p.startsWith(SRC + sep) ? p : null;
}

/**
 * A JSON checked by the build's encoder, as the build will read it: errors
 * are the build's own. New graphics and sprites count as exported.
 */
function check(rel, json) {
  const ctx = context(baseSwf);
  let next = 60000;
  for (const f of fresh()) if (f.name) { ctx.lib.kinds.set(next, "sprite"); ctx.lib.names.set(next, f.name); ctx.lib.byName.set(f.name, next++); }
  if (rel.startsWith("assets/new/")) {
    if (!rel.endsWith(".json")) throw new Error("only a new sprite (.json) is written here");
    exportName(rel.slice("assets/".length));
    writeSprite(1, json, ctx.lib, null, `src/${rel}`);
    return "sprite";
  }
  const id = fileId(rel), kind = fileKind(rel);
  const tag = definition(id);
  if (!kind || !tag) throw new Error(`src/${rel}: no ${kind ?? "sprite, button or text"} ${id} in the base`);
  writeObject(tag.code, id, json, ctx, readObject(tag, baseCtx), `src/${rel}`);
  return kind;
}

/**
 * A sprite's clip actions follow their lines to new depths: their scripts'
 * folders (frame_N/PlaceObject2_<id>_<name>_<depth>/) renamed, each line
 * matched as the build matches its clip actions (tools/sprites.mjs
 * clipActions: same frame, same thing placed, then its depth, its instance
 * name, or the only one). What was renamed, "from → to".
 */
const REF = ["export", "shape", "sprite", "text", "button", "morph", "video"];
function moveClipScripts(p, before, after) {
  const ref = (o) => REF.map((k) => o[k] ?? "").join("|");
  const plan = [];
  (after.frames ?? []).forEach((fr, i) => {
    const old = (before?.frames?.[i]?.place ?? []).filter((o) => o.actions), taken = new Set();
    const dir = join(dirname(p), `frame_${i + 1}`);
    for (const o of (fr.place ?? []).filter((x) => x.actions)) {
      const same = old.filter((x) => ref(x) === ref(o) && !taken.has(x));
      const hit = same.find((x) => x.depth === o.depth) ?? (o.name !== undefined ? same.find((x) => x.name === o.name) : undefined) ?? (same.length === 1 ? same[0] : undefined);
      if (!hit) continue;
      taken.add(hit);
      if (hit.depth === o.depth || !existsSync(dir)) continue;
      const from = readdirSync(dir).find((n) => n.startsWith("PlaceObject") && n.endsWith(`_${hit.depth}`) && /^PlaceObject\d?_/.test(n));
      if (from) plan.push({ dir, from, to: from.replace(/_\d+$/, `_${o.depth}`) });
    }
  });
  // In two steps: lines that swapped depths swap folders.
  for (const x of plan) renameSync(join(x.dir, x.from), join(x.dir, `${x.from}.moving`));
  for (const x of plan) renameSync(join(x.dir, `${x.from}.moving`), join(x.dir, x.to));
  return plan.map((x) => `${x.from} → ${x.to}`);
}

const TYPES = { ".html": "text/html; charset=utf-8", ".js": "text/javascript; charset=utf-8", ".css": "text/css; charset=utf-8", ".json": "application/json; charset=utf-8", ".svg": "image/svg+xml", ".png": "image/png", ".jpg": "image/jpeg", ".gif": "image/gif" };
const send = (res, status, body, type = "application/json; charset=utf-8") => {
  res.writeHead(status, { "content-type": type, "cache-control": "no-store" });
  res.end(typeof body === "string" || Buffer.isBuffer(body) ? body : JSON.stringify(body));
};
const body = (req) => new Promise((ok, ko) => { const parts = []; req.on("data", (c) => parts.push(c)); req.on("end", () => ok(Buffer.concat(parts).toString("utf8"))); req.on("error", ko); });

let building = null;
const server = createServer(async (req, res) => {
  const url = new URL(req.url, "http://x");
  try {
    if (req.method === "GET" && (url.pathname === "/" || /^\/[\w.-]+\.(html|js|css)$/.test(url.pathname))) {
      const f = join(HERE, url.pathname === "/" ? "index.html" : url.pathname.slice(1));
      return existsSync(f) ? send(res, 200, readFileSync(f), TYPES[extname(f)]) : send(res, 404, "not found", "text/plain");
    }
    if (req.method === "GET" && url.pathname === "/api/library") return send(res, 200, libraryIndex());
    if (req.method === "GET" && url.pathname === "/api/ui") return send(res, 200, uiInfo());
    if (req.method === "GET" && url.pathname === "/api/params") return send(res, 200, placeParams(url.searchParams.get("file") ?? ""));
    // Files under src/ as they are on disk (edited shapes and sprites show as they are now).
    if (req.method === "GET" && url.pathname.startsWith("/src/")) {
      const p = srcPath(decodeURIComponent(url.pathname.slice(5)));
      if (!p || !existsSync(p) || !statSync(p).isFile()) return send(res, 404, "not found", "text/plain");
      return send(res, 200, readFileSync(p), TYPES[extname(p)] ?? "application/octet-stream");
    }
    if (req.method === "GET" && url.pathname === "/api/where") {
      const id = Number(url.searchParams.get("id"));
      return send(res, 200, where(baseSwf, id));
    }
    // Save: checked by the build's encoder, written in the repo's format.
    if (req.method === "PUT" && url.pathname === "/api/save") {
      const rel = url.searchParams.get("path"), p = srcPath(rel);
      if (!p) return send(res, 400, { error: "a path under src/" });
      let json;
      try { json = JSON.parse(await body(req)); } catch (e) { return send(res, 400, { error: `not JSON: ${e.message}` }); }
      let kind;
      try { kind = check(rel, json); } catch (e) { return send(res, 422, { error: e.message }); }
      mkdirSync(join(p, ".."), { recursive: true });
      const moved = kind === "sprite" && rel.startsWith("timeline/") && existsSync(p) ? moveClipScripts(p, JSON.parse(readFileSync(p, "utf8")), json) : [];
      writeFileSync(p, formatJson(kind, json));
      return send(res, 200, { ok: true, moved });
    }
    if (req.method === "POST" && url.pathname === "/api/build") {
      if (building) return send(res, 409, { error: "a build is running" });
      building = new Promise((ok) => {
        const child = spawn(process.execPath, [join(ROOT, "tools", "build.mjs")], { cwd: ROOT });
        let log = "";
        child.stdout.on("data", (d) => (log += d));
        child.stderr.on("data", (d) => (log += d));
        child.on("close", (code) => ok({ ok: code === 0, log }));
      });
      const r = await building;
      building = null;
      return send(res, 200, r);
    }
    send(res, 404, { error: "not found" });
  } catch (e) {
    send(res, 500, { error: e.stack ?? String(e) });
  }
});
server.listen(port, host, () => console.log(`sprite editor: http://localhost:${port}  (base ${cfg.version}, ${objects.size} sprites / buttons / texts)`));
