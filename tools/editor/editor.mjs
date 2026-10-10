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
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { createServer } from "node:http";
import { extname, join, normalize, sep } from "node:path";
import { ROOT, SRC, base, config } from "../lib.mjs";
import { assetFiles, exportName } from "../assets.mjs";
import { context, fileId, fileKind, formatJson, objectFiles, readObject, where, writeObject, writeSprite } from "../sprites.mjs";
import { parseSwf } from "../deob/src/swf.ts";

const args = process.argv.slice(2);
const port = Number(args.includes("--port") ? args[args.indexOf("--port") + 1] : 4777);
const host = process.env.RETRO_EDITOR_HOST ?? "127.0.0.1";
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
      writeFileSync(p, formatJson(kind, json));
      return send(res, 200, { ok: true });
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
