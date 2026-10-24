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
import { dirname, extname, join, normalize, relative, sep } from "node:path";
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
  return (uiCache = { styles, classes, ...paramKeys(classes) });
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
  // The instance names its class reaches (this._tiAccount): moved into another clip, it doesn't find them.
  let names = [];
  try { names = JSON.parse(readFileSync(srcPath(rel), "utf8")).frames.flatMap((f) => (f.place ?? []).map((o) => o.name)).filter(Boolean); } catch { /* not a sprite */ }
  const uses = [...new Set(names)].filter((n) => new RegExp(`\\b${n.replace(/\$/g, "\\$")}\\b`).test(code));
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
  return { texts, hidden, cls, uses };
}

/**
 * The parameters each component takes, as the base's interfaces set them
 * (every on(construct) of src/timeline/sprites/): { Button: { label: "",
 * styleName: "…" } } — each with its most frequent value, a default to start from;
 * `styleUse`: { style: { Button: n } }, which components each style is given to.
 */
function paramKeys(classes) {
  const seen = {}, styleUse = {};
  const dir = join(SRC, "timeline", "sprites");
  for (const sprite of readdirSync(dir)) for (const frame of readdirSync(join(dir, sprite)).filter((f) => /^frame_\d+$/.test(f))) {
    for (const place of readdirSync(join(dir, sprite, frame))) {
      const m = /^PlaceObject\d?_\d+_(.+)_\d+$/.exec(place);
      if (!m) continue;
      const cls = (classes[m[1]] ?? m[1]).split(".").pop(), at = join(dir, sprite, frame, place);
      for (const f of readdirSync(at).filter((x) => x.includes("construct"))) {
        for (const a of readFileSync(join(at, f), "utf8").matchAll(/^\s*(\w+) = (.+);\s*$/gm)) {
          // Values only (the decompiler leaves a few expressions: _loc3_ + 1).
          if (/^_loc\d+_$/.test(a[1]) || (typeof literal(a[2]) === "string" && !/^"/.test(a[2].trim()))) continue;
          if (a[1] === "styleName" && typeof literal(a[2]) === "string") { const u = (styleUse[literal(a[2])] ??= {}); u[cls] = (u[cls] ?? 0) + 1; }
          const counts = ((seen[cls] ??= {})[a[1]] ??= new Map());
          counts.set(a[2], (counts.get(a[2]) ?? 0) + 1);
        }
      }
    }
  }
  const out = {};
  for (const [cls, keys] of Object.entries(seen)) {
    out[cls] = {};
    for (const [k, counts] of Object.entries(keys)) out[cls][k] = literal([...counts].sort((a, b) => b[1] - a[1])[0][0]);
  }
  return { paramKeys: out, styleUse };
}

/**
 * Whether an on(construct) script only sets parameters to values (what a
 * line's "params" compiles to): then a line leaving its sprite takes them
 * along as its "params" — its script can't follow it.
 */
function plainConstruct(text) {
  const lines = text.replace(/\r\n/g, "\n").split("\n").map((l) => l.trim()).filter(Boolean);
  if (lines[0] !== "on(construct){" || lines.at(-1) !== "}") return false;
  return lines.slice(1, -1).every((l) => {
    // (A statement without effect the obfuscator left: 24901909 - 1;)
    if (/^[\d\s+*-]+;$/.test(l)) return true;
    const m = /^([A-Za-z_$][\w$]*) = (.+);$/.exec(l);
    if (!m || /^_loc\d+_$/.test(m[1])) return false;
    // A value JSON reads (not an expression the decompiler left, nor an escape it doesn't know).
    const v = literal(m[2]);
    return typeof v !== "string" || v !== m[2].trim();
  });
}

/**
 * A sprite's components' parameters, from its clip actions
 * (frame_N/PlaceObject2_<id>_<name>_<depth>/…on(construct).as):
 * { frame: { depth: { label: "…", styleName: "…" } } }; `plain`: { frame:
 * [depths] } whose clip actions only set them (plainConstruct).
 */
function placeParams(rel) {
  const out = {};
  const p = srcPath(rel);
  if (!p || !rel.startsWith("timeline/")) return out;
  const dir = dirname(p);
  if (!existsSync(dir)) return out;
  Object.assign(out, codeInfo(rel));
  // A removed line's folder left at a depth another line has now isn't that line's.
  let json = null;
  try { json = JSON.parse(readFileSync(p, "utf8")); } catch { /* none */ }
  const lineThere = (frame, depth, folder) => !json || (json.frames?.[frame - 1]?.place ?? []).some((o) => o.actions && o.depth === depth && (!o.export || folder.includes(`_${o.export}_`)));
  for (const frame of readdirSync(dir)) {
    const fm = /^frame_(\d+)$/.exec(frame);
    if (!fm) continue;
    for (const place of readdirSync(join(dir, frame))) {
      const pm = /^PlaceObject\d?_.*_(\d+)$/.exec(place);
      if (!pm || !statSync(join(dir, frame, place)).isDirectory() || !lineThere(Number(fm[1]), Number(pm[1]), place)) continue;
      const params = {}, files = readdirSync(join(dir, frame, place));
      for (const f of files.filter((x) => /construct|initialize/.test(x))) {
        for (const m of readFileSync(join(dir, frame, place, f), "utf8").matchAll(/^\s*(\w+) = (.+);\s*$/gm)) params[m[1]] = literal(m[2]);
      }
      if (Object.keys(params).length) ((out[fm[1]] ??= {})[pm[1]] = params);
      if (files.length === 1 && files[0] === "CLIPACTIONRECORD on(construct).as" && plainConstruct(readFileSync(join(dir, frame, place, files[0]), "utf8"))) ((out.plain ??= {})[fm[1]] ??= []).push(Number(pm[1]));
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
 * clipActions: same frame, same thing placed, then its instance name, its
 * depth, or the only one). What was renamed, "from → to".
 */
const REF = ["export", "shape", "sprite", "text", "button", "morph", "video"];
function planClipScripts(p, before, after) {
  const ref = (o) => REF.map((k) => o[k] ?? "").join("|");
  const plan = [];
  (after.frames ?? []).forEach((fr, i) => {
    const old = (before?.frames?.[i]?.place ?? []).filter((o) => o.actions), taken = new Set();
    const dir = join(dirname(p), `frame_${i + 1}`);
    for (const o of (fr.place ?? []).filter((x) => x.actions)) {
      const same = old.filter((x) => ref(x) === ref(o) && !taken.has(x));
      // As the build matches it (tools/sprites.mjs clipActions): its instance name first.
      const hit = (o.name !== undefined ? same.find((x) => x.name === o.name) : undefined) ?? same.find((x) => x.depth === o.depth) ?? (same.length === 1 ? same[0] : undefined);
      if (!hit) continue;
      taken.add(hit);
      if (hit.depth === o.depth || !existsSync(dir)) continue;
      // (Two folders at that depth — a removed line's left with another's: the one placing the same.)
      const at = readdirSync(dir).filter((n) => n.endsWith(`_${hit.depth}`) && /^PlaceObject\d?_/.test(n));
      const from = at.find((n) => (o.export ? n.includes(`_${o.export}_`) : n.includes(`_${o.sprite ?? o.button ?? o.shape ?? o.text}_`))) ?? at[0];
      if (from) plan.push({ dir, from, to: from.replace(/_\d+$/, `_${o.depth}`) });
    }
  });
  return plan;
}
/**
 * The renames done, in two steps (lines that swapped depths swap folders).
 * A folder already where one goes, and not moving itself, is a removed
 * line's (its script is dead — the build drops its clip actions with it):
 * put aside in .tmp/editor-removed/ first, or the rename would fail half
 * way. Any rename failing undoes those done: all or nothing.
 */
function moveClipScripts(plan) {
  const sources = new Set(plan.map((x) => join(x.dir, x.from)));
  const stale = plan.map((x) => join(x.dir, x.to)).filter((t) => existsSync(t) && !sources.has(t));
  const done = [];
  const move = (from, to) => { mkdirSync(dirname(to), { recursive: true }); renameSync(from, to); done.push([from, to]); };
  try {
    const aside = join(ROOT, ".tmp", "editor-removed", new Date().toISOString().replace(/[:.]/g, "-"));
    for (const t of stale) move(t, join(aside, relative(SRC, t)));
    for (const x of plan) move(join(x.dir, x.from), join(x.dir, `${x.from}.moving`));
    for (const x of plan) move(join(x.dir, `${x.from}.moving`), join(x.dir, x.to));
  } catch (e) {
    for (const [from, to] of done.reverse()) renameSync(to, from);
    throw new Error(`clip actions' folders not renamed (nothing changed): ${e.message}`);
  }
  return [
    ...plan.map((x) => `${x.from} → ${x.to}`),
    ...stale.map((t) => `${relative(SRC, t).split(sep).join("/")}: a removed line's, put aside in .tmp/editor-removed/`),
  ];
}
/** Folders an earlier save left half renamed (PlaceObject…_N.moving): their names say where each was. */
function halfMoved(p) {
  const dir = dirname(p);
  if (!existsSync(dir)) return [];
  return readdirSync(dir).filter((f) => /^frame_\d+$/.test(f)).flatMap((f) => readdirSync(join(dir, f)).filter((n) => n.endsWith(".moving")).map((n) => `${f}/${n}`));
}

/** A value as AS2 source (a parameter in on(construct)). */
function asLiteral(v) {
  if (typeof v === "string") return JSON.stringify(v);
  if (Array.isArray(v)) return `[${v.map(asLiteral).join(",")}]`;
  if (v && typeof v === "object") return `{${Object.entries(v).map(([k, x]) => `${/^[A-Za-z_$][\w$]*$/.test(k) ? k : JSON.stringify(k)}:${asLiteral(x)}`).join(",")}}`;
  return String(v);
}
/**
 * The script holding a line's on(construct) (its folder named for its depth
 * and what it places — PlaceObject2_121_TextInput_242 — after `plan`'s
 * renames), or null: never another line's (a removed Label's folder at the
 * same depth).
 */
function constructScript(p, frame, o, plan) {
  const dir = join(dirname(p), `frame_${frame}`);
  if (!existsSync(dir)) return null;
  const mine = (n) => n.endsWith(`_${o.depth}`) && (o.export ? n.includes(`_${o.export}_`) : true);
  const moved = plan.find((x) => x.dir === dir && mine(x.to));
  const here = readdirSync(dir).filter((n) => /^PlaceObject\d?_/.test(n) && mine(n) && !plan.some((x) => x.dir === dir && x.from === n));
  const folder = moved ? moved.from : here.length === 1 ? here[0] : null;
  if (!folder) return null;
  const file = readdirSync(join(dir, folder)).find((f) => f.includes("construct"));
  return file ? { before: join(dir, folder, file), after: join(dir, moved ? moved.to : folder, file) } : null;
}
/**
 * A line's parameters written into its on(construct) script: an assignment
 * changed where its value differs, added before the closing brace, removed
 * when gone — every other line as it was (the build recompiles it).
 */
function writeConstruct(file, params) {
  const lines = readFileSync(file, "utf8").replace(/\r\n/g, "\n").split("\n");
  const done = new Set();
  const out = lines.flatMap((line) => {
    const m = /^(\s*)(\w+) = (.+);\s*$/.exec(line);
    if (!m) return [line];
    if (!(m[2] in params)) return [];
    done.add(m[2]);
    return JSON.stringify(literal(m[3])) === JSON.stringify(params[m[2]]) ? [line] : [`${m[1]}${m[2]} = ${asLiteral(params[m[2]])};`];
  });
  const close = out.map((l) => /^\}\s*$/.test(l)).lastIndexOf(true);
  out.splice(close < 0 ? out.length : close, 0, ...Object.keys(params).filter((k) => !done.has(k)).map((k) => `   ${k} = ${asLiteral(params[k])};`));
  writeFileSync(file, out.join("\n"));
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
      // A base sprite's line with its own clip actions: its parameters go to its on(construct) script.
      const scripted = [];
      if (rel.startsWith("timeline/sprites/")) (json.frames ?? []).forEach((fr, i) => (fr?.place ?? []).forEach((o) => {
        if (o?.actions && o.params !== undefined) { scripted.push({ frame: i + 1, o: { depth: o.depth, export: o.export }, params: o.params, label: o.name ?? o.export ?? `depth ${o.depth}` }); delete o.params; }
      }));
      let kind;
      try { kind = check(rel, json); } catch (e) { return send(res, 422, { error: e.message }); }
      const left = halfMoved(p);
      if (left.length) return send(res, 409, { error: `an earlier save stopped half way renaming clip actions' folders — put them back first (src/${dirname(rel)}/):\n  ${left.join("\n  ")}` });
      const plan = kind === "sprite" && rel.startsWith("timeline/") && existsSync(p) ? planClipScripts(p, JSON.parse(readFileSync(p, "utf8")), json) : [];
      const scripts = scripted.map((x) => ({ ...x, file: constructScript(p, x.frame, x.o, plan) }));
      const lost = scripts.find((x) => !x.file);
      if (lost) return send(res, 422, { error: `${lost.label}: no on(construct) script in frame_${lost.frame}/PlaceObject…${lost.o.export ? `_${lost.o.export}` : ""}_${lost.o.depth}/ to set its parameters in` });
      mkdirSync(join(p, ".."), { recursive: true });
      let moved;
      try { moved = moveClipScripts(plan); } catch (e) { return send(res, 500, { error: e.message }); }
      for (const x of scripts) writeConstruct(x.file.after, x.params);
      writeFileSync(p, formatJson(kind, json));
      return send(res, 200, { ok: true, moved, scripts: scripts.map((x) => relative(SRC, x.file.after).split(sep).join("/")) });
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
