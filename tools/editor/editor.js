// The sprite editor's page (tools/editor/editor.mjs serves it). It draws a
// sprite as SVG from the repo's files — the shapes of src/assets/shapes/,
// placed as its sprite.json says — and edits that JSON. Each open file is a
// tab with its own changes, history, selection and view; nothing is written
// until it's saved (the server checks it with the build's encoder first).
// Unsaved tabs survive a reload (browser storage).

const SVG = "http://www.w3.org/2000/svg";
const REF = ["export", "shape", "sprite", "text", "button", "morph", "video"];
const MATRIX = ["x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix"];
// The key order the extraction writes (tools/sprites.mjs readPlace / readButton): an untouched line stays the same.
const PLACE_ORDER = ["depth", "move", ...REF, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "ratio", "name", "mask", "filters", "blend", "actions"];
const RECORD_ORDER = ["depth", "states", ...REF, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "filters", "blend"];
const BLENDS = { multiply: "multiply", screen: "screen", lighten: "lighten", darken: "darken", difference: "difference", overlay: "overlay", hardlight: "hard-light", add: "plus-lighter" };
const STORE = "retro-sprite-editor";

const $ = (id) => document.getElementById(id);
const el = (name, attrs = {}) => {
  const e = document.createElementNS(SVG, name);
  for (const [k, v] of Object.entries(attrs)) if (v !== undefined && v !== null) e.setAttribute(k, v);
  return e;
};
const html = (name, attrs = {}, text) => {
  const e = document.createElement(name);
  for (const [k, v] of Object.entries(attrs)) if (v !== undefined) e[k] = v;
  if (text !== undefined) e.textContent = text;
  return e;
};
const round20 = (v) => Math.round(v * 20) / 20;
const api = async (path, opts) => {
  const r = await fetch(path, opts);
  const j = await r.json().catch(() => ({ error: `HTTP ${r.status}` }));
  if (!r.ok) throw new Error(j.error ?? `HTTP ${r.status}`);
  return j;
};
const store = {
  get(k, d) { try { return JSON.parse(localStorage.getItem(`${STORE}:${k}`)) ?? d; } catch { return d; } },
  set(k, v) { try { localStorage.setItem(`${STORE}:${k}`, JSON.stringify(v)); } catch { /* private window: no memory */ } },
};

const S = {
  lib: null, byId: new Map(), freshByName: new Map(),
  tabs: [], active: -1, tab: "Interfaces",
};
// For the DevTools (and tests): the editor's state.
window.editorState = S;
/** The open tab: { file, kind, json, saved (text on disk, null: never saved), undo, redo, sel, frame, state, hidden, open, view, screen }. */
const D = () => S.tabs[S.active] ?? null;
const isDirty = (t) => t.saved === null || JSON.stringify(t.json) !== t.saved;

// --- Status and log ---------------------------------------------------------

function status(text, kind = "") {
  $("status").textContent = text;
  $("status").className = kind;
  $("status").title = text;
}
function log(content) {
  const l = $("log");
  l.textContent = "";
  if (!content) { l.classList.remove("open"); return; }
  const close = html("button", { className: "close", title: "Close" }, "✕");
  close.onclick = () => log(null);
  l.append(close, typeof content === "string" ? document.createTextNode(content) : content);
  l.classList.add("open");
}

// --- Library ----------------------------------------------------------------

async function loadLibrary() {
  S.lib = await api("/api/library");
  S.byId = new Map(S.lib.objects.map((o) => [o.id, o]));
  S.freshByName = new Map(S.lib.fresh.filter((f) => f.name).map((f) => [f.name, f]));
}

const TABS = {
  Interfaces: () => S.lib.objects.filter((o) => o.kind === "sprite" && o.name?.startsWith("UI_")),
  Sprites: () => S.lib.objects.filter((o) => o.kind === "sprite"),
  Ours: () => S.lib.fresh,
  Shapes: () => S.lib.shapes,
  Buttons: () => S.lib.objects.filter((o) => o.kind === "button"),
  Texts: () => S.lib.objects.filter((o) => o.kind === "text"),
};
/** What a library entry places: { export } when it has a name, else { shape | sprite | … : id }. */
function refFromEntry(e) {
  if (e.name && (e.kind === "sprite" || e.kind === "button" || e.kind === "graphic")) return { export: e.name };
  if (S.tab === "Shapes") return { shape: e.id };
  return { [e.kind]: e.id };
}
function renderTabs() {
  const t = $("tabs");
  t.textContent = "";
  for (const name of Object.keys(TABS)) {
    const b = html("button", { className: name === S.tab ? "on" : "" }, name);
    b.onclick = () => { S.tab = name; renderTabs(); renderList(); };
    t.append(b);
  }
}
function renderList() {
  const q = $("search").value.trim().toLowerCase();
  const list = $("list");
  list.textContent = "";
  const all = TABS[S.tab]();
  const hits = all.filter((e) => !q || String(e.id ?? "").includes(q) || (e.name ?? "").toLowerCase().includes(q) || (e.file ?? "").toLowerCase().includes(q));
  const shown = hits.slice(0, 400);
  list.className = S.tab === "Shapes" ? "grid" : "";
  if (S.tab === "Ours" && !all.length) list.append(html("div", { className: "hint" }, "Nothing in src/assets/new/ yet: add an .svg / .png there (then Reload files), or a new sprite (New sprite)."));
  for (const e of shown) {
    let node;
    if (S.tab === "Shapes") {
      node = html("div", { className: "thumb", title: `shape ${e.id} — click: where it's placed; drag it onto a sprite` });
      node.append(html("img", { src: `/src/${e.file}`, loading: "lazy", draggable: false }), html("span", {}, e.id));
      node.onclick = () => showWhere(e.id, `shape ${e.id}`);
    } else {
      node = html("div", { className: "item" + (D()?.file === e.file ? " on" : ""), title: e.file });
      node.append(html("span", {}, e.name ?? `${e.kind} ${e.id}`));
      if (e.name && e.id !== undefined) node.append(html("small", {}, e.id));
      if (S.tab === "Ours") node.append(html("small", {}, e.kind === "sprite" ? "sprite" : e.ext));
      node.onclick = () => (e.kind !== "graphic" ? open(e.file) : status(`${e.name}: drag it onto a sprite`));
    }
    node.draggable = true;
    node.ondragstart = (ev) => ev.dataTransfer.setData("application/x-ref", JSON.stringify(refFromEntry(e)));
    list.append(node);
  }
  if (hits.length > shown.length) list.append(html("div", { className: "hint" }, `… ${hits.length - shown.length} more: search`));
}

// --- Files ------------------------------------------------------------------

// Files read from disk; an open tab's own JSON wins (its unsaved changes show everywhere).
const diskJson = new Map();
const shapeText = new Map();
async function fileJson(file) {
  const t = S.tabs.find((x) => x.file === file);
  if (t) return t.json;
  if (!diskJson.has(file)) diskJson.set(file, fetch(`/src/${file}`).then((r) => (r.ok ? r.json() : null)).catch(() => null));
  return diskJson.get(file);
}
/** What's known now without waiting (the layers tree draws from it). */
const loaded = new Map();
async function fileJsonKnown(file) { const j = await fileJson(file); loaded.set(file, j); return j; }
const knownJson = (file) => S.tabs.find((x) => x.file === file)?.json ?? loaded.get(file);

// --- Drawing ----------------------------------------------------------------

/** a, b, c, d, tx, ty from a placement's fields (the formula of tools/sprites.mjs). */
function matrixOf(o) {
  const tx = o.x ?? 0, ty = o.y ?? 0;
  if (o.matrix) return [...o.matrix, tx, ty];
  const sx = o.scaleX ?? o.scale ?? 1, sy = o.scaleY ?? o.scale ?? 1, r = ((o.rotation ?? 0) * Math.PI) / 180;
  return [sx * Math.cos(r), sx * Math.sin(r), -sy * Math.sin(r), sy * Math.cos(r), tx, ty];
}
const transformOf = (o) => `matrix(${matrixOf(o).join(" ")})`;

/** What a placement shows: { kind, id, file } of the base, ours (fresh), or missing. */
function refOf(o) {
  if (o.export !== undefined) {
    const id = S.lib.exports[o.export];
    if (id !== undefined) return { kind: S.lib.kinds[id], id, file: S.byId.get(id)?.file };
    const tab = S.tabs.find((t) => t.name === o.export && t.file.startsWith("assets/new/"));
    const f = S.freshByName.get(o.export) ?? (tab && { kind: "sprite", file: tab.file });
    if (f) return { kind: f.kind === "sprite" ? "freshSprite" : "freshGraphic", f, file: f.file };
    return { kind: "missing", label: o.export };
  }
  for (const k of REF.slice(1)) if (k in o) return { kind: k, id: o[k], file: S.byId.get(o[k])?.file };
  return null;
}
const describe = (o) => o.export ?? REF.slice(1).filter((k) => k in o).map((k) => `${k} ${o[k]}`)[0] ?? (o.move ? "(move)" : "?");
const hasChildren = (ref) => ref && (ref.kind === "sprite" || ref.kind === "freshSprite" || ref.kind === "button") && ref.file;

/** The display list at frame n: what each depth holds, with the frame-1 line it comes from. */
function displayList(frames, n) {
  const st = new Map();
  for (let i = 0; i < Math.min(n, frames.length); i++) {
    const fr = frames[i] ?? {};
    for (const d of fr.remove ?? []) st.delete(d);
    (fr.place ?? []).forEach((o, k) => {
      if (!o.move) { st.set(o.depth, { o: { ...o }, src: i === 0 ? k : null }); return; }
      const cur = st.get(o.depth);
      if (!cur) return;
      const m = { ...cur.o };
      const take = (keys) => { if (keys.some((r) => r in o)) { for (const r of keys) delete m[r]; for (const r of keys) if (r in o) m[r] = o[r]; } };
      take(REF); take(MATRIX); take(["alpha", "color"]);
      for (const r of ["name", "ratio", "mask", "filters", "blend"]) if (r in o) m[r] = o[r];
      st.set(o.depth, { o: m, src: i === 0 ? k : null });
    });
  }
  return [...st.entries()].sort((a, b) => a[0] - b[0]).map(([depth, v]) => ({ depth, ...v }));
}
/** What a sprite or button shows (frame 1, "up"), for nesting and the layers tree. */
function childList(ref, json) {
  if (!json) return [];
  if (ref.kind === "button") return (json.records ?? []).map((o, k) => ({ depth: o.depth, o, src: k })).filter((it) => it.o.states?.includes("up")).sort((a, b) => a.depth - b.depth);
  return displayList(json.frames ?? [], 1);
}

const defs = () => $("defs");
const defCache = new Map();
let defSeq = 0;
function resetDefs() { defCache.clear(); filterCache.clear(); defs().textContent = ""; }

/**
 * A def's id for what a placement shows, or null. Drawn once and used by
 * every placement — but an instance with something hidden inside (`path`:
 * its depths from the top, "/65/13") gets its own drawing.
 */
function ensureDef(ref, level, path = "") {
  if (!ref || level > 12) return Promise.resolve(null);
  const own = [...(D()?.hidden ?? [])].some((h) => h.startsWith(`${path}/`));
  const key = `${ref.kind}:${ref.file ?? ref.id ?? ref.label}${own ? `@${path}` : ""}`;
  if (!defCache.has(key)) defCache.set(key, makeDef(ref, level, `d${++defSeq}`, own ? path : null).catch((e) => { console.warn(key, e); return null; }));
  return defCache.get(key);
}

async function makeDef(ref, level, id, path) {
  const g = el("g", { id });
  defs().append(g);
  if (ref.kind === "shape") {
    if (!shapeText.has(ref.id)) shapeText.set(ref.id, fetch(`/src/assets/shapes/${ref.id}.svg`).then((r) => (r.ok ? r.text() : null)));
    let text = await shapeText.get(ref.id);
    if (!text) return placeholder(g, `shape ${ref.id}`);
    // Ids are FFDec's ("gradient0"): one set per shape.
    const p = `s${ref.id}-`;
    text = text.replace(/\sid="([^"]+)"/g, ` id="${p}$1"`).replace(/url\(#([^)]+)\)/g, `url(#${p}$1)`).replace(/href="#([^"]+)"/g, `href="#${p}$1"`);
    const svg = new DOMParser().parseFromString(text, "image/svg+xml").documentElement;
    let first = true;
    for (const child of [...svg.children]) {
      const c = document.importNode(child, true);
      // The export moves the shape into view: its own coordinates are under that translate.
      if (first && c.tagName === "g") { c.removeAttribute("transform"); first = false; }
      g.append(c);
    }
  } else if (hasChildren(ref)) {
    const json = await fileJsonKnown(ref.file);
    if (!json) return placeholder(g, `${ref.kind} ${ref.id ?? ref.file}`);
    await drawList(g, childList(ref, json), level + 1, false, path);
  } else if (ref.kind === "text") {
    const json = ref.file && (await fileJsonKnown(ref.file));
    if (!json) return placeholder(g, `text ${ref.id}`);
    drawText(g, json);
  } else if (ref.kind === "freshGraphic") {
    const src = `/src/${ref.f.file}`;
    const size = await new Promise((ok) => { const i = new Image(); i.onload = () => ok([i.naturalWidth, i.naturalHeight]); i.onerror = () => ok([20, 20]); i.src = src; });
    g.append(el("image", { href: src, x: 0, y: 0, width: size[0], height: size[1] }));
  } else placeholder(g, ref.label ?? `${ref.kind} ${ref.id}`);
  return id;
}

function placeholder(g, label) {
  g.append(el("rect", { x: -10, y: -10, width: 20, height: 20, fill: "#e0605033", stroke: "#e06050", "vector-effect": "non-scaling-stroke" }));
  g.append(el("title")).textContent = label;
  return g.id;
}

function drawText(g, t) {
  const family = "Verdana, Tahoma, sans-serif";
  if (t.records) {
    // A static text: its runs, each character at its advance.
    const run = el("g", { transform: transformOf(t.transform ?? {}) });
    let x = 0, y = 0, size = 12, color = "#000000";
    for (const r of t.records) {
      if ("x" in r) x = r.x;
      if ("y" in r) y = r.y;
      size = r.size ?? size; color = r.color ?? color;
      const chars = r.text !== undefined ? [...r.text] : (r.glyphs ?? []).map(() => "?");
      const xs = [];
      let cx = x;
      for (let i = 0; i < chars.length; i++) { xs.push(round20(cx)); cx += r.advances?.[i] ?? 0; }
      const tx = el("text", { x: xs.join(" "), y, "font-size": size, "font-family": family, fill: color, opacity: r.alpha });
      tx.textContent = chars.join("");
      run.append(tx);
      x = cx;
    }
    g.append(run);
    return;
  }
  // A text field: its box, and its text (or what fills it).
  g.append(el("rect", { x: t.x, y: t.y, width: t.width, height: t.height, fill: "none", stroke: "#ffffff50", "stroke-dasharray": "3 2", "vector-effect": "non-scaling-stroke" }));
  const content = t.text !== undefined ? (t.html ? t.text.replace(/<[^>]*>/g, "") : t.text) : `‹${t.variable ?? "text"}›`;
  const anchor = { center: "middle", right: "end" }[t.align] ?? "start";
  const ax = anchor === "middle" ? t.x + t.width / 2 : anchor === "end" ? t.x + t.width - 2 : t.x + 2;
  const tx = el("text", { x: ax, y: t.y + (t.size ?? 12) + 1, "font-size": t.size ?? 12, "font-family": family, fill: t.color ?? "#000", "text-anchor": anchor, opacity: t.text === undefined ? 0.45 : t.alpha });
  tx.textContent = content;
  g.append(tx);
}

/** A colour transform as an SVG filter (mult and add per channel); its id. */
const filterCache = new Map();
function colorFilter(color) {
  const key = JSON.stringify(color);
  if (!filterCache.has(key)) {
    const id = `cx${++defSeq}`;
    const m = color.mult ?? [1, 1, 1, 1], a = (color.add ?? [0, 0, 0, 0]).map((v) => v / 255);
    const f = el("filter", { id, "color-interpolation-filters": "sRGB", x: "-10%", y: "-10%", width: "120%", height: "120%" });
    f.append(el("feColorMatrix", { type: "matrix", values: `${m[0]} 0 0 0 ${a[0]}  0 ${m[1]} 0 0 ${a[1]}  0 0 ${m[2]} 0 ${a[2]}  0 0 0 ${m[3]} ${a[3]}` }));
    defs().append(f);
    filterCache.set(key, id);
  }
  return filterCache.get(key);
}

/** One placement drawn: a <use> of its def, moved, coloured. */
async function drawItem(o, level, path) {
  const id = await ensureDef(refOf(o), level, path);
  const u = id ? el("use", { href: `#${id}` }) : el("g");
  if (!id) placeholder(u, describe(o));
  u.setAttribute("transform", transformOf(o));
  if ("alpha" in o) u.setAttribute("opacity", o.alpha);
  if (o.color) u.setAttribute("filter", `url(#${colorFilter(o.color)})`);
  if (o.blend && BLENDS[o.blend]) u.style.mixBlendMode = BLENDS[o.blend];
  return u;
}

/**
 * A display list into `parent`, by depth; a mask clips the depths above it,
 * up to its own `mask`. `path`: where this list is, from the top (null: a
 * shared drawing, nothing hidden inside); a hidden line isn't drawn.
 */
async function drawList(parent, list, level, interactive, path = "") {
  const hidden = D()?.hidden ?? new Set();
  const at = (it) => (path === null ? null : `${path}/${it.depth}`);
  const nodes = await Promise.all(list.map((it) => (it.o.mask || (!interactive && hidden.has(at(it))) ? null : drawItem(it.o, level, at(it)))));
  let clip = null;
  for (let i = 0; i < list.length; i++) {
    const it = list[i];
    if (clip && it.depth > clip.until) clip = null;
    if (!interactive && hidden.has(at(it))) continue;
    if (it.o.mask) {
      const id = await ensureDef(refOf(it.o), level, at(it));
      const cp = el("clipPath", { id: `clip${++defSeq}` });
      if (id) cp.append(el("use", { href: `#${id}`, transform: transformOf(it.o) }));
      defs().append(cp);
      const g = el("g", { "clip-path": `url(#${cp.id})` });
      parent.append(g);
      clip = { g, until: it.o.mask };
      if (interactive) parent.append(el("g", { class: "item mask", "data-i": it.src ?? "" }));
      continue;
    }
    let node = nodes[i];
    if (interactive) {
      const w = el("g", { class: "item" + (hidden.has(at(it)) ? " hidden" : ""), "data-i": it.src ?? "", "data-depth": it.depth });
      w.append(node);
      node = w;
    }
    (clip ? clip.g : parent).append(node);
  }
}

// --- The open tab -----------------------------------------------------------

/** The editable lines: a sprite's frame-1 placements, a button's records; none for a text. */
function items(d = D()) {
  if (!d) return null;
  if (d.kind === "sprite") { d.json.frames ??= [{}]; if (!d.json.frames.length) d.json.frames.push({}); return (d.json.frames[0].place ??= []); }
  if (d.kind === "button") return (d.json.records ??= []);
  return null;
}
const editable = () => { const d = D(); return d && d.kind !== "text" && (d.kind === "button" || d.frame === 1); };

function currentList() {
  const d = D();
  if (d.kind === "sprite") return displayList(d.json.frames ?? [], d.frame);
  if (d.kind === "button") return (d.json.records ?? []).map((o, k) => ({ depth: o.depth, o, src: k })).filter((it) => it.o.states?.includes(d.state)).sort((a, b) => a.depth - b.depth);
  return [];
}

let drawSeq = 0;
async function draw() {
  const seq = ++drawSeq;
  const d = D();
  const fresh = el("g");
  if (d?.kind === "text") drawText(fresh, d.json);
  else if (d) await drawList(fresh, currentList(), 0, true);
  if (seq !== drawSeq) return;
  $("content").replaceWith(fresh);
  fresh.id = "content";
  $("empty").hidden = !!d;
  // An SVG element has no .hidden property: the attribute itself.
  $("screenFrame").toggleAttribute("hidden", !d?.screen);
  $("screen").classList.toggle("on", !!d?.screen);
  drawSelection();
  renderLayers();
}

/**
 * A line inside a placed sprite (`path`: its depths from the top, "/65/13"):
 * the line itself (`o`, in its definition's tab), what places it on screen
 * (`chain`: its parents' matrices), whose definition it's in (`owner`).
 */
function nestedInfo(d = D()) {
  if (!d?.nested) return null;
  const depths = d.nested.split("/").slice(1).map(Number);
  let list = currentList(), chain = [1, 0, 0, 1, 0, 0], owner = null, it = null;
  for (let k = 0; k < depths.length; k++) {
    it = list.find((x) => x.depth === depths[k]);
    if (!it) return null;
    if (k === depths.length - 1) break;
    chain = multiply(chain, matrixOf(it.o));
    const ref = refOf(it.o), json = hasChildren(ref) && knownJson(ref.file);
    if (!json) return null;
    owner = { file: ref.file, kind: ref.kind, label: describe(it.o), id: ref.id };
    list = childList(ref, json);
  }
  const tab = owner && S.tabs.find((t) => t.file === owner.file);
  if (!tab) return null;
  const o = it.src === null ? it.o : items(tab)[it.src];
  return { it, o, chain, owner, tab, editable: it.src !== null && !!o };
}
async function selectNested(path, ownerFile) {
  const d = D();
  await tabFor(ownerFile);
  d.sel = null; d.nested = path;
  drawSelection(); renderLayers(); renderInspector();
}
/** A move on screen (dx, dy) in the coordinates the nested line is placed in. */
function toParent(n, dx, dy) {
  const [a, b, c, dd] = invert(n.chain);
  return [a * dx + c * dy, b * dx + dd * dy];
}

async function drawNested() {
  const d = D(), n = nestedInfo(), ov = $("overlay");
  if (!n) return;
  const path = d.nested;
  const id = await ensureDef(refOf(n.o), 1, path);
  if (D() !== d || d.nested !== path) return;
  // Measured where it is: its parents' placements, then its own.
  const wrap = el("g", { visibility: "hidden" }), g = el("g", { transform: `matrix(${n.chain.join(" ")})` });
  if (id) g.append(el("use", { href: `#${id}`, transform: transformOf(n.o) }));
  wrap.append(g); ov.append(wrap);
  const bb = wrap.getBBox();
  wrap.remove();
  d.nestedBox = bb.width || bb.height ? bb : null;
  if (d.nestedBox) ov.append(el("rect", { x: bb.x, y: bb.y, width: bb.width, height: bb.height, fill: "none", stroke: "#e0a040", "stroke-width": 1.5, "stroke-dasharray": "5 3", "vector-effect": "non-scaling-stroke" }));
  const [, , , , x, y] = multiply(n.chain, matrixOf(n.o)), k = 6 / view.k;
  ov.append(el("path", { d: `M${x - k} ${y}H${x + k}M${x} ${y - k}V${y + k}`, stroke: "#6aa8e8", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
}

function drawSelection() {
  const ov = $("overlay");
  ov.textContent = "";
  const d = D();
  if (d?.nested) { drawNested(); return; }
  if (!d || d.sel === null) return;
  const node = $("content").querySelector(`.item[data-i="${d.sel}"]`);
  const o = items()?.[d.sel];
  if (!o) return;
  if (node && !node.classList.contains("mask")) {
    const bb = node.getBBox();
    ov.append(el("rect", { x: bb.x, y: bb.y, width: bb.width, height: bb.height, fill: "none", stroke: "#e0a040", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
  }
  const k = 6 / view.k, x = o.x ?? 0, y = o.y ?? 0;
  ov.append(el("path", { d: `M${x - k} ${y}H${x + k}M${x} ${y - k}V${y + k}`, stroke: "#6aa8e8", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
}

/** After any change: buttons, tab marks, the session kept for a reload. */
function setDirty() {
  const d = D();
  $("save").disabled = !d || !isDirty(d);
  $("saveAll").disabled = !S.tabs.some(isDirty);
  $("undo").disabled = !d?.undo.length;
  $("redo").disabled = !d?.redo.length;
  $("whereUsed").disabled = !d;
  renderTabbar();
  remember();
}
let rememberTimer = null;
function remember() {
  clearTimeout(rememberTimer);
  rememberTimer = setTimeout(() => store.set("session", {
    active: S.active,
    tabs: S.tabs.filter((t) => !t.background || isDirty(t)).map((t) => ({ file: t.file, draft: isDirty(t) ? t.json : undefined, fresh: t.saved === null || undefined, view: t.view, screen: t.screen })),
  }), 300);
}
/** Before a change to tab `t` (the open one, or a definition edited from it): undo, in the open tab, takes it back. */
function snapshot(t = D()) { D().undo.push({ file: t.file, json: JSON.stringify(t.json) }); D().redo = []; }
/** Something changed in the open tab: what places it redraws too. */
function changed() { resetDefs(); setDirty(); draw(); renderInspector(); }

function renderTabbar() {
  const bar = $("tabbar");
  bar.textContent = "";
  if (!S.tabs.length) { bar.append(html("span", { className: "none" }, "No tab open")); return; }
  S.tabs.forEach((t, i) => {
    if (t.background && !isDirty(t) && i !== S.active) return;
    const tab = html("div", { className: "tab" + (i === S.active ? " on" : ""), title: `src/${t.file}` });
    tab.append(html("span", { className: "label" }, t.title));
    if (isDirty(t)) tab.append(html("span", { className: "dot", title: "Unsaved changes" }, "●"));
    const x = html("button", { className: "x", title: "Close (Ctrl+W)" }, "✕");
    x.onclick = (e) => { e.stopPropagation(); closeTab(i); };
    tab.append(x);
    tab.onclick = () => activate(i);
    tab.onauxclick = (e) => { if (e.button === 1) closeTab(i); };
    bar.append(tab);
  });
}

const kindOf = (file) => (file.startsWith("timeline/texts/") ? "text" : file.startsWith("timeline/buttons/") ? "button" : "sprite");
function newTab(file, json, saved) {
  const id = file.startsWith("assets/new/") ? undefined : Number(/\/(\d+)/.exec(file)?.[1]);
  const entry = S.byId.get(id);
  const name = file.startsWith("assets/new/") ? file.slice("assets/new/".length, -".json".length).toLowerCase() : entry?.name;
  const kind = kindOf(file);
  return {
    file, kind, json, saved, name, id,
    title: name ?? `${kind} ${id}`,
    undo: [], redo: [], sel: null, frame: 1, state: "up", hidden: new Set(), open: new Set(),
    view: null, screen: !!name?.startsWith("UI_"),
  };
}

/** Opens a file in a tab (or goes to its tab); `select`: the line to select. */
async function open(file, { select } = {}) {
  let i = S.tabs.findIndex((t) => t.file === file);
  if (i < 0) {
    const json = await fetch(`/src/${file}`).then((r) => (r.ok ? r.json() : null)).catch(() => null);
    if (!json) { status(`can't read src/${file}`, "bad"); return; }
    S.tabs.push(newTab(file, json, JSON.stringify(json)));
    i = S.tabs.length - 1;
  }
  await activate(i);
  if (select !== undefined) { D().sel = select; drawSelection(); renderLayers(); renderInspector(); }
}

async function activate(i) {
  S.active = i;
  const d = D();
  if (d) d.background = false;
  resetDefs();
  setDirty();
  if (!d) { await draw(); renderInspector(); renderList(); return; }
  const frames = d.kind === "sprite" ? d.json.frames?.length ?? 1 : 1;
  $("frames").hidden = !(frames > 1 || d.kind === "button");
  $("frameBox").hidden = d.kind !== "sprite";
  $("frame").max = frames; $("frame").value = d.frame;
  $("frameCount").textContent = `/ ${frames}${frames > 1 ? " (frame 1 is edited)" : ""}`;
  $("state").hidden = d.kind !== "button"; $("state").value = d.state;
  history.replaceState(null, "", `#${d.file}`);
  await draw();
  if (d.view) { Object.assign(view, d.view); applyView(); } else fit();
  renderInspector();
  renderList();
}

function closeTab(i) {
  const t = S.tabs[i];
  if (isDirty(t) && !confirm(`${t.title} has unsaved changes. Close it and lose them?`)) return;
  S.tabs.splice(i, 1);
  if (i < S.active || S.active >= S.tabs.length) S.active--;
  activate(Math.max(S.active, S.tabs.length ? 0 : -1));
}

// --- Layers (a tree) and inspector ------------------------------------------

function renderLayers() {
  const box = $("layers");
  box.textContent = "";
  const d = D();
  $("up").disabled = $("down").disabled = !d || d.sel === null || !editable();
  $("remove").disabled = !d || (d.sel === null || !editable()) && !nestedInfo(d)?.editable;
  $("group").disabled = !d || d.sel === null || !editable() || d.kind !== "sprite";
  const selRef = d && d.sel !== null ? refOf(items()?.[d.sel] ?? {}) : null;
  $("ungroup").disabled = $("group").disabled || !(selRef?.kind === "sprite" || selRef?.kind === "freshSprite");
  if (!d || d.kind === "text") { box.append(html("div", { className: "hint" }, d ? "A text: edit it in the inspector." : "")); return; }
  // Top first, as drawn; a placed sprite or button unfolds into its own list (its definition: shared by every placement).
  const rows = (list, level, path, owner) => {
    for (const it of list.slice().reverse()) {
      const key = `${path}/${it.depth}`;
      const ref = refOf(it.o);
      const kids = hasChildren(ref);
      const top = level === 0;
      const row = html("div", { className: "layer" + (top ? "" : " child") + ((top && it.src !== null && it.src === d.sel) || d.nested === key ? " on" : "") });
      row.style.paddingLeft = `${6 + level * 14}px`;
      const tw = html("span", { className: "tw" + (kids ? " can" : ""), title: kids ? "What it holds (its definition, shared by every placement)" : "" }, kids ? (d.open.has(key) ? "▾" : "▸") : "");
      tw.onclick = (e) => {
        e.stopPropagation();
        if (!kids) return;
        d.open.has(key) ? d.open.delete(key) : d.open.add(key);
        if (knownJson(ref.file) === undefined) fileJsonKnown(ref.file).then(renderLayers); else renderLayers();
      };
      row.append(tw, html("span", { className: "d" }, it.depth));
      // Hidden here only (this instance, not the definition's other placements), while you work: not saved.
      const off = d.hidden.has(key), under = [...d.hidden].some((h) => key.startsWith(`${h}/`));
      const eye = html("span", { className: "eye" + (off ? " off" : ""), title: under ? "Hidden with what holds it" : "Hide here while working (this instance only; not saved)" }, "👁");
      if (under) eye.style.opacity = ".3";
      eye.onclick = (e) => { e.stopPropagation(); off ? d.hidden.delete(key) : d.hidden.add(key); resetDefs(); draw(); };
      row.append(eye);
      row.append(html("span", { className: "what" }, (it.o.mask ? "mask: " : "") + describe(it.o)));
      if (it.o.name) row.append(html("span", { className: "name" }, it.o.name));
      if (top) {
        row.onclick = () => select(it.src);
        if (it.src !== null && editable()) dragRow(row, it, ref);
      } else {
        row.title = `In ${owner.label}'s definition: click to select it here, double-click to open it there`;
        row.onclick = () => selectNested(key, owner.file);
        row.ondblclick = () => open(owner.file, { select: it.src ?? undefined });
      }
      box.append(row);
      if (kids && d.open.has(key)) {
        const json = knownJson(ref.file);
        if (json) rows(childList(ref, json), level + 1, key, { file: ref.file, label: describe(it.o) });
        else box.append(html("div", { className: "hint" }, "…"));
      }
    }
  };
  rows(currentList(), 0, "", null);
}

/**
 * A layer dragged onto another: its top or bottom edge puts it above or
 * below; its middle, inside (a sprite) or grouped with it (anything else).
 */
let dragged = null;
function dragRow(row, it, ref) {
  row.draggable = true;
  row.ondragstart = (e) => { dragged = it.src; row.classList.add("dragging"); e.dataTransfer.setData("application/x-layer", String(it.src)); e.dataTransfer.effectAllowed = "move"; };
  row.ondragend = () => { dragged = null; row.classList.remove("dragging"); };
  const zone = (e) => {
    const r = row.getBoundingClientRect(), y = (e.clientY - r.top) / r.height;
    return y < 0.3 ? "above" : y > 0.7 ? "below" : "into";
  };
  const clear = () => row.classList.remove("above", "below", "into");
  row.ondragover = (e) => {
    if (dragged === null || dragged === it.src) return;
    e.preventDefault();
    clear();
    row.classList.add(zone(e));
    row.title = { above: "above it", below: "below it", into: hasChildren(ref) && ref.kind !== "button" ? `into ${describe(it.o)}` : `grouped with ${describe(it.o)}` }[zone(e)];
  };
  row.ondragleave = clear;
  row.ondrop = (e) => {
    e.preventDefault();
    clear();
    const from = dragged;
    dragged = null;
    if (from === null || from === it.src) return;
    const z = zone(e);
    if (z !== "into") moveNextTo(from, it.src, z === "above");
    else if ((ref?.kind === "sprite" || ref?.kind === "freshSprite") && ref.file) moveInto(from, it.src);
    else group([it.src, from], it.src);
  };
}

function select(i) {
  D().sel = i ?? null;
  D().nested = null;
  drawSelection(); renderLayers(); renderInspector();
}

/** A placement's keys in the extraction's order (an untouched line stays the same). */
function ordered(o, order) {
  const out = {};
  for (const k of order) if (k in o) out[k] = o[k];
  for (const k of Object.keys(o)) if (!(k in out)) out[k] = o[k];
  return out;
}
function setScale(o, sx, sy) {
  delete o.scale; delete o.scaleX; delete o.scaleY;
  if (sx === sy) { if (sx !== 1) o.scale = sx; } else { o.scaleX = sx; o.scaleY = sy; }
}

/**
 * A JSON box applied as you type, as soon as it parses: a change like any
 * other (undo takes it back; only saving writes it).
 */
function liveJson(value, apply, { height, tab } = {}) {
  const ta = html("textarea", { value, spellcheck: false });
  if (height) ta.style.height = height;
  let fresh = true;
  ta.onfocus = () => { fresh = true; };
  ta.oninput = () => {
    let j;
    try { j = JSON.parse(ta.value); } catch { ta.classList.add("invalid"); ta.title = "Not JSON yet: not applied"; return; }
    if (!j || typeof j !== "object") return;
    ta.classList.remove("invalid"); ta.title = "";
    if (fresh) { snapshot(tab); fresh = false; }
    apply(j);
    resetDefs(); setDirty(); draw();
  };
  ta.onblur = () => setTimeout(renderInspector);
  return ta;
}

function renderInspector() {
  const box = $("inspector");
  if (box.contains(document.activeElement) && /TEXTAREA|INPUT/.test(document.activeElement.tagName) && document.activeElement.type !== "checkbox") return;
  box.textContent = "";
  const d = D();
  if (!d) return;
  if (d.kind === "text") {
    box.append(html("div", { className: "hint" }, d.json.records ? "A static text: change \"text\" and give one width per character (\"advances\", px). Applied as you type." : "A text field: its box and settings (docs/SPRITES.md). Applied as you type."));
    box.append(liveJson(JSON.stringify(d.json, null, 1), (j) => { d.json = j; }, { height: "60vh" }));
    return;
  }
  const n = nestedInfo();
  const o = n ? n.o : items()?.[d.sel];
  if (!o || (!n && d.sel === null)) {
    box.append(html("div", { className: "hint" }, editable() ? "Select a layer, or drag something from the left onto the sprite." : "Frames after the first are shown, not edited here: edit them in the sprite.json."));
    return;
  }
  // A nested line is edited in its definition (its own tab): every placement of it changes.
  const owner = n ? n.tab : d;
  const ro = n ? !n.editable : !editable();
  if (n) {
    const where = html("div", { className: "hint" }, `In ${n.owner.label}'s definition (src/${n.owner.file}): every placement of ${n.owner.label} changes.${ro ? " A later frame's line: shown, not edited." : ""}`);
    const go = html("button", {}, `Open ${n.owner.label}`);
    go.onclick = () => open(n.owner.file, { select: n.it.src ?? undefined });
    box.append(where, html("div", { className: "actions" }), go);
  }
  const field = (label, value, set, type = "number") => {
    const row = html("div", { className: "row" });
    const input = html("input", { type, value: value ?? "", disabled: ro, step: "any" });
    let fresh = true;
    input.onfocus = () => { fresh = true; };
    input.oninput = () => {
      const v = type === "number" ? (input.value === "" ? undefined : Number(input.value)) : input.value;
      if (type === "number" && v !== undefined && !Number.isFinite(v)) return;
      if (fresh) { snapshot(owner); fresh = false; }
      set(v);
      resetDefs(); setDirty(); draw();
    };
    input.onblur = () => setTimeout(renderInspector);
    row.append(html("label", {}, label), input);
    box.append(row);
  };
  const ref = refOf(o);
  const what = html("div", { className: "row" });
  what.append(html("label", {}, "shows"), html("span", {}, describe(o)));
  box.append(what);
  field("depth", o.depth, (v) => { if (Number.isInteger(v)) o.depth = v; });
  field("x", o.x ?? 0, (v) => { o.x = round20(v ?? 0); });
  field("y", o.y ?? 0, (v) => { o.y = round20(v ?? 0); });
  if (o.matrix) {
    ["a", "b", "c", "d"].forEach((n, i) => field(n, o.matrix[i], (v) => { o.matrix[i] = v ?? 0; }));
  } else {
    field("scale x", o.scaleX ?? o.scale ?? 1, (v) => setScale(o, v ?? 1, o.scaleY ?? o.scale ?? 1));
    field("scale y", o.scaleY ?? o.scale ?? 1, (v) => setScale(o, o.scaleX ?? o.scale ?? 1, v ?? 1));
    field("rotation", o.rotation ?? 0, (v) => { if (v) o.rotation = v; else delete o.rotation; });
  }
  if (!o.color) field("alpha", o.alpha ?? 1, (v) => { if (v === undefined || v === 1) delete o.alpha; else o.alpha = v; });
  if (owner.kind === "sprite") field("name", o.name ?? "", (v) => { if (v) o.name = v; else delete o.name; }, "text");
  if (owner.kind === "button") {
    const row = html("div", { className: "row" });
    const boxes = html("span");
    for (const s of ["up", "over", "down", "hit"]) {
      const c = html("input", { type: "checkbox", checked: o.states.includes(s), disabled: ro });
      c.onchange = () => { snapshot(owner); o.states = ["up", "over", "down", "hit"].filter((x) => (x === s ? c.checked : o.states.includes(x))); changed(); };
      const l = html("label", {});
      l.append(c, ` ${s} `);
      boxes.append(l);
    }
    row.append(html("label", {}, "states"), boxes);
    box.append(row);
  }
  const actions = html("div", { className: "actions" });
  if (hasChildren(ref) || (ref?.kind === "text" && ref.file)) { const b = html("button", {}, "Open it"); b.onclick = () => open(ref.file); actions.append(b); }
  if (ref?.id !== undefined) { const b = html("button", {}, "Where else"); b.onclick = () => showWhere(ref.id, describe(o)); actions.append(b); }
  box.append(actions);
  if (!ro) box.append(liveJson(JSON.stringify(o), (j) => { items(owner)[n ? n.it.src : d.sel] = j; }, { tab: owner }));
  if (o.actions || o.name) box.append(html("div", { className: "hint" }, `${o.name ? `Code may reach it as this.${o.name}. ` : ""}${o.actions ? "It has clip actions (frame_1/PlaceObject2_….as)." : ""}`));
}

async function showWhere(id, label) {
  const found = await api(`/api/where?id=${id}`);
  const out = document.createElement("div");
  out.append(`${label}: placed ${found.length} time${found.length === 1 ? "" : "s"} (as saved)\n`);
  for (const w of found) {
    const a = html("a", {}, `src/${w.file}`);
    a.onclick = () => open(w.file);
    out.append("  ", a, `  ${w.where}: ${JSON.stringify(w.fields)}\n`);
  }
  log(out);
}

// --- Stage: view, selection, dragging, dropping -----------------------------

const view = { x: 0, y: 0, k: 1 };
function applyView() {
  $("view").setAttribute("transform", `translate(${view.x} ${view.y}) scale(${view.k})`);
  $("zoomInfo").textContent = `${Math.round(view.k * 100)}%`;
  if (D()) D().view = { ...view };
  drawSelection();
  remember();
}
function fit() {
  const box = $("stage").getBoundingClientRect();
  let bb;
  try { bb = $("content").getBBox(); } catch { bb = null; }
  if (bb && !bb.width && !bb.height) bb = null;
  if (D()?.screen) bb = bb ? union(bb, { x: 0, y: 0, width: 742, height: 556 }) : { x: 0, y: 0, width: 742, height: 556 };
  if (!bb) Object.assign(view, { x: box.width / 2, y: box.height / 2, k: 1 });
  else {
    const k = Math.min(box.width / Math.max(bb.width, 1), box.height / Math.max(bb.height, 1), 8) * 0.9;
    Object.assign(view, { k, x: box.width / 2 - (bb.x + bb.width / 2) * k, y: box.height / 2 - (bb.y + bb.height / 2) * k });
  }
  applyView();
}
function union(a, b) {
  const x = Math.min(a.x, b.x), y = Math.min(a.y, b.y);
  return { x, y, width: Math.max(a.x + a.width, b.x + b.width) - x, height: Math.max(a.y + a.height, b.y + b.height) - y };
}
/** A pointer's position in the sprite's coordinates. */
function toSprite(e) {
  const r = $("stage").getBoundingClientRect();
  return { x: (e.clientX - r.left - view.x) / view.k, y: (e.clientY - r.top - view.y) / view.k };
}

function setupStage() {
  const stage = $("stage");
  let drag = null;
  stage.addEventListener("pointerdown", (e) => {
    if (!D()) return;
    const item = e.target.closest?.("#content .item");
    const i = item && item.dataset.i !== "" ? Number(item.dataset.i) : null;
    // A nested line selected: dragging inside its box moves it (in its definition).
    const n = e.button === 0 && nestedInfo(), b = D().nestedBox, p0 = toSprite(e);
    if (n?.editable && b && p0.x >= b.x && p0.x <= b.x + b.width && p0.y >= b.y && p0.y <= b.y + b.height) {
      drag = { kind: "nested", n, start: p0, x: n.o.x ?? 0, y: n.o.y ?? 0, moved: false, before: { file: n.tab.file, json: JSON.stringify(n.tab.json) } };
    } else if (e.button === 0 && i !== null && editable()) {
      select(i);
      const o = items()[i];
      drag = { kind: "move", start: toSprite(e), x: o.x ?? 0, y: o.y ?? 0, node: item.firstChild, moved: false, before: { file: D().file, json: JSON.stringify(D().json) } };
    } else {
      if (i !== null) select(i);
      drag = { kind: "pan", sx: e.clientX, sy: e.clientY, vx: view.x, vy: view.y, moved: false, deselect: i === null };
    }
    stage.setPointerCapture(e.pointerId);
  });
  stage.addEventListener("pointermove", (e) => {
    if (!drag) return;
    if (drag.kind === "pan") {
      view.x = drag.vx + e.clientX - drag.sx; view.y = drag.vy + e.clientY - drag.sy;
      drag.moved ||= Math.abs(e.clientX - drag.sx) + Math.abs(e.clientY - drag.sy) > 3;
      applyView();
    } else if (drag.kind === "nested") {
      const p = toSprite(e), dx = p.x - drag.start.x, dy = p.y - drag.start.y;
      const [lx, ly] = toParent(drag.n, dx, dy);
      drag.n.o.x = round20(drag.x + lx); drag.n.o.y = round20(drag.y + ly);
      drag.moved = true;
      // Its box follows; the drawing, on release.
      $("overlay").setAttribute("transform", `translate(${dx} ${dy})`);
    } else {
      const p = toSprite(e), o = items()[D().sel];
      o.x = round20(drag.x + p.x - drag.start.x); o.y = round20(drag.y + p.y - drag.start.y);
      drag.moved = true;
      drag.node?.setAttribute("transform", transformOf(o));
      drawSelection();
    }
  });
  const end = () => {
    if ((drag?.kind === "move" || drag?.kind === "nested") && drag.moved) { D().undo.push(drag.before); D().redo = []; $("overlay").removeAttribute("transform"); changed(); }
    if (drag?.kind === "pan" && !drag.moved && drag.deselect) select(null);
    drag = null;
  };
  stage.addEventListener("pointerup", end);
  stage.addEventListener("pointercancel", end);
  stage.addEventListener("wheel", (e) => {
    e.preventDefault();
    const r = stage.getBoundingClientRect();
    const k = Math.min(32, Math.max(0.05, view.k * Math.exp(-e.deltaY * 0.0015)));
    const px = e.clientX - r.left, py = e.clientY - r.top;
    Object.assign(view, { k, x: px - ((px - view.x) * k) / view.k, y: py - ((py - view.y) * k) / view.k });
    applyView();
  }, { passive: false });
  // Dropping a library entry places it where it falls, over everything.
  stage.addEventListener("dragover", (e) => { if (editable()) { e.preventDefault(); stage.classList.add("drop"); } });
  stage.addEventListener("dragleave", () => stage.classList.remove("drop"));
  stage.addEventListener("drop", async (e) => {
    stage.classList.remove("drop");
    const raw = e.dataTransfer.getData("application/x-ref");
    if (!raw || !editable()) return;
    e.preventDefault();
    const d = D(), ref = JSON.parse(raw), p = toSprite(e), list = items();
    const used = d.kind === "sprite" ? d.json.frames.flatMap((f) => (f.place ?? []).map((o) => o.depth)) : list.map((o) => o.depth);
    const depth = Math.max(0, ...used) + 1;
    snapshot();
    const o = d.kind === "button" ? { depth, states: ["up", "over", "down"], ...ref, x: round20(p.x), y: round20(p.y) } : { depth, ...ref, x: round20(p.x), y: round20(p.y) };
    list.push(o);
    d.sel = list.length - 1;
    // The drawing's centre where it falls (its origin may be far from it: the login logo's is).
    await draw();
    const bb = $("content").querySelector(`.item[data-i="${d.sel}"]`)?.getBBox();
    if (bb?.width) { o.x = round20(o.x + p.x - (bb.x + bb.width / 2)); o.y = round20(o.y + p.y - (bb.y + bb.height / 2)); }
    changed();
    status(`placed ${describe(o)} at depth ${depth}`);
  });
}

/** The side panels' widths, dragged (and kept). */
function setupSplitters() {
  for (const s of document.querySelectorAll(".splitter")) {
    const name = s.dataset.var, dir = Number(s.dataset.dir);
    const saved = store.get(name);
    if (saved) document.documentElement.style.setProperty(name, `${saved}px`);
    s.addEventListener("pointerdown", (e) => {
      e.preventDefault();
      const start = e.clientX, width = s.parentElement.getBoundingClientRect().width;
      s.setPointerCapture(e.pointerId);
      s.classList.add("drag");
      const move = (ev) => {
        const w = Math.max(170, Math.min(window.innerWidth * 0.45, width + (ev.clientX - start) * dir));
        document.documentElement.style.setProperty(name, `${w}px`);
        store.set(name, Math.round(w));
      };
      const up = () => { s.classList.remove("drag"); s.removeEventListener("pointermove", move); s.removeEventListener("pointerup", up); applyView(); };
      s.addEventListener("pointermove", move);
      s.addEventListener("pointerup", up);
    });
  }
}

// --- Commands ---------------------------------------------------------------

function undo(redo = false) {
  const d = D();
  if (!d) return;
  const from = redo ? d.redo : d.undo, to = redo ? d.undo : d.redo;
  if (!from.length) return;
  const e = from.pop(), t = S.tabs.find((x) => x.file === e.file);
  if (!t) return undo(redo);
  to.push({ file: e.file, json: JSON.stringify(t.json) });
  t.json = JSON.parse(e.json);
  if (d.sel !== null && !items()?.[d.sel]) d.sel = null;
  if (d.nested && !nestedInfo()) d.nested = null;
  changed();
}
function nudge(dx, dy) {
  const n = nestedInfo();
  if (n) {
    if (!n.editable) return;
    snapshot(n.tab);
    const [lx, ly] = toParent(n, dx, dy);
    n.o.x = round20((n.o.x ?? 0) + lx); n.o.y = round20((n.o.y ?? 0) + ly);
    changed();
    return;
  }
  const o = items()?.[D()?.sel];
  if (!o || !editable()) return;
  snapshot();
  o.x = round20((o.x ?? 0) + dx); o.y = round20((o.y ?? 0) + dy);
  changed();
}
function removeSel() {
  const d = D(), n = nestedInfo();
  if (n) {
    if (!n.editable) return;
    snapshot(n.tab);
    items(n.tab).splice(n.it.src, 1);
    d.nested = null;
    changed();
    status(`removed from ${n.owner.label}'s definition (every placement)`);
    return;
  }
  if (!d || d.sel === null || !editable()) return;
  snapshot();
  items().splice(d.sel, 1);
  d.sel = null;
  changed();
}
// --- Hierarchy: order, nesting, groups --------------------------------------

/** a b c d tx ty products: m1 applied after m2 (a child placed by m2 inside a parent placed by m1). */
function multiply([a1, b1, c1, d1, x1, y1], [a2, b2, c2, d2, x2, y2]) {
  return [a1 * a2 + c1 * b2, b1 * a2 + d1 * b2, a1 * c2 + c1 * d2, b1 * c2 + d1 * d2, a1 * x2 + c1 * y2 + x1, b1 * x2 + d1 * y2 + y1];
}
function invert([a, b, c, d, x, y]) {
  const k = a * d - b * c;
  return [d / k, -b / k, -c / k, a / k, (c * y - d * x) / k, (b * x - a * y) / k];
}
/** A placement's matrix fields from a b c d tx ty (scale / rotation when it's one, the matrix otherwise). */
function setMatrix(o, [a, b, c, d, tx, ty]) {
  for (const k of MATRIX) delete o[k];
  const r5 = (v) => Math.round(v * 1e5) / 1e5;
  o.x = round20(tx); o.y = round20(ty);
  if (Math.abs(b) < 1e-6 && Math.abs(c) < 1e-6) { setScale(o, r5(a), r5(d)); return o; }
  const sx = Math.hypot(a, b), rot = Math.atan2(b, a), sy = (a * d - b * c) / sx;
  if (Math.abs(-sy * Math.sin(rot) - c) < 1e-4 && Math.abs(sy * Math.cos(rot) - d) < 1e-4) {
    setScale(o, r5(sx), r5(sy));
    o.rotation = r5((rot * 180) / Math.PI);
  } else o.matrix = [a, b, c, d].map(r5);
  return o;
}
/** Every depth of a sprite renamed (frame 1's lines and what later frames move or remove there). */
function remapDepths(json, map) {
  for (const f of json.frames ?? []) {
    for (const o of f.place ?? []) if (map.has(o.depth)) o.depth = map.get(o.depth);
    if (f.remove) f.remove = f.remove.map((dd) => map.get(dd) ?? dd);
  }
}
/** Depths that later frames still move or remove: their line can't leave frame 1 alone. */
function animatedDepths(json) {
  const out = new Set();
  (json.frames ?? []).slice(1).forEach((f) => { for (const o of f.place ?? []) if (o.move) out.add(o.depth); for (const dd of f.remove ?? []) out.add(dd); });
  return out;
}
const freeDepth = (json) => Math.max(0, ...(json.frames ?? []).flatMap((f) => (f.place ?? []).map((o) => o.depth)), ...(json.records ?? []).map((o) => o.depth)) + 1;

/**
 * Frame 1's lines in a new order (bottom first): the depths they had, given
 * out again in that order — later frames follow them.
 */
function reorder(order) {
  const d = D(), list = items();
  const depths = order.map((i) => list[i].depth).sort((a, b) => a - b);
  const map = new Map(order.map((i, k) => [list[i].depth, depths[k]]));
  if (d.kind === "sprite") remapDepths(d.json, map); else for (const o of list) if (map.has(o.depth)) o.depth = map.get(o.depth);
}
/** The line `i` just above (`above`) or below the line `j`, among frame 1's. */
function moveNextTo(i, j, above) {
  const list = currentList().filter((it) => it.src !== null).map((it) => it.src);
  const order = list.filter((k) => k !== i);
  order.splice(order.indexOf(j) + (above ? 1 : 0), 0, i);
  snapshot();
  reorder(order);
  changed();
}
function restack(dir) {
  const d = D();
  if (!d || d.sel === null || !editable()) return;
  const list = currentList().filter((it) => it.src !== null).map((it) => it.src);
  const at = list.indexOf(d.sel), other = list[at + dir];
  if (other === undefined) return;
  moveNextTo(d.sel, other, dir > 0);
}

/** A tab for a file, opened behind the current one if it isn't (a change made there waits for its save). */
async function tabFor(file, fresh) {
  let t = S.tabs.find((x) => x.file === file);
  if (!t) {
    const json = fresh ?? (await fetch(`/src/${file}`).then((r) => (r.ok ? r.json() : null)).catch(() => null));
    if (!json) throw new Error(`can't read src/${file}`);
    t = newTab(file, json, fresh ? null : JSON.stringify(json));
    t.background = true;
    S.tabs.push(t);
  }
  return t;
}

/** What code may lose when lines move into another clip: their instance names' paths. */
function codeWarning(lines, into) {
  const named = lines.filter((o) => o.name || o.actions);
  if (!named.length) return true;
  return confirm(`${named.map((o) => o.name ?? describe(o)).join(", ")}: code reaches ${named.length > 1 ? "them" : "it"} as this.${named[0].name ?? "…"} — inside ${into} it becomes this.<${into}'s instance name>.${named[0].name ?? "…"}. Move ${named.length > 1 ? "them" : "it"} anyway?`);
}
function checkMovable(d, idx) {
  if (d.kind !== "sprite" || !editable()) return "only a sprite's frame-1 lines move into others";
  const moving = animatedDepths(d.json);
  const bad = idx.map((i) => items()[i]).find((o) => moving.has(o.depth) || o.mask);
  return bad ? `${describe(bad)}: ${bad.mask ? "a mask" : "later frames move it"} — not moved` : null;
}

/** The line `i` into the sprite placed by line `j`: same place on screen; that sprite's definition changes. */
async function moveInto(i, j) {
  const d = D(), list = items(), o = list[i], host = list[j], ref = refOf(host);
  const why = checkMovable(d, [i]);
  if (why) { status(why, "bad"); return; }
  if (!(ref?.kind === "sprite" || ref?.kind === "freshSprite") || !ref.file) { status(`${describe(host)} can't hold anything: drop on its top or bottom edge, or Group`, "bad"); return; }
  if (!codeWarning([o], describe(host))) return;
  if (ref.kind === "sprite") {
    const where = await api(`/api/where?id=${ref.id}`).catch(() => []);
    if (where.length > 1 && !confirm(`${describe(host)} is placed ${where.length} times: ${describe(o)} will show in every one. Go on?`)) return;
  }
  const t = await tabFor(ref.file);
  if (t.file === d.file) { status("a sprite can't hold itself", "bad"); return; }
  snapshot(); snapshot(t);
  const inner = setMatrix({ ...o }, multiply(invert(matrixOf(host)), matrixOf(o)));
  inner.depth = freeDepth(t.json);
  items(t).push(inner);
  list.splice(i, 1);
  d.sel = list.indexOf(host);
  d.open.add(`/${host.depth}`);
  changed();
  status(`${describe(o)} is in ${describe(host)} now (its tab: unsaved, Save all writes both)`, "good");
}

/** Lines `idx` wrapped in a new sprite (src/assets/new/<this one>/group-N.json), placed where the first was. */
async function group(idx, anchor = idx[0]) {
  const d = D(), list = items();
  const why = checkMovable(d, idx);
  if (why) { status(why, "bad"); return; }
  const lines = idx.map((i) => list[i]).sort((a, b) => a.depth - b.depth);
  if (!codeWarning(lines, "the group")) return;
  const owner = (d.name ?? `sprite-${d.id}`).toLowerCase().replace(/[^a-z0-9_/-]/g, "-");
  const taken = (n) => S.lib.exports[n] !== undefined || S.freshByName.has(n) || S.tabs.some((t) => t.name === n);
  let n = 1;
  while (taken(`${owner}/group-${n}`)) n++;
  const name = `${owner}/group-${n}`;
  const at = matrixOf(list[anchor]);
  const origin = [1, 0, 0, 1, at[4], at[5]];
  const json = { frames: [{ place: lines.map((o, k) => setMatrix({ ...o, depth: k + 1 }, multiply(invert(origin), matrixOf(o)))) }] };
  snapshot();
  const placed = { depth: Math.min(...lines.map((o) => o.depth)), export: name, x: round20(at[4]), y: round20(at[5]) };
  for (const i of [...idx].sort((a, b) => b - a)) list.splice(i, 1);
  list.push(placed);
  d.sel = list.length - 1;
  await tabFor(`assets/new/${name}.json`, json);
  d.open.add(`/${placed.depth}`);
  changed();
  status(`grouped into "${name}" (src/assets/new/${name}.json, written when saved): drag it, everything inside follows`, "good");
}

/** What the placed sprite `i` holds, put in its place (positions composed); its definition stays as it is. */
async function ungroup(i) {
  const d = D(), list = items(), host = list[i], ref = refOf(host);
  if (!editable() || d.kind !== "sprite") return;
  if (!(ref?.kind === "sprite" || ref?.kind === "freshSprite")) { status(`${describe(host)} holds nothing to ungroup`, "bad"); return; }
  if (host.color || host.filters || host.blend || host.mask || animatedDepths(d.json).has(host.depth)) { status(`${describe(host)}: coloured, filtered, a mask or animated — not ungrouped`, "bad"); return; }
  const json = await fileJson(ref.file);
  if ((json?.frames?.length ?? 0) > 1) { status(`${describe(host)} is animated (${json.frames.length} frames): not ungrouped`, "bad"); return; }
  const kids = childList(ref, json).filter((it) => !it.o.mask);
  if (!kids.length) { status(`${describe(host)} is empty`, "bad"); return; }
  snapshot();
  // Room for them at its depth: the lines above move up.
  const shift = kids.length - 1, map = new Map();
  for (const f of d.json.frames) for (const o of f.place ?? []) if (o.depth > host.depth) map.set(o.depth, o.depth + shift);
  remapDepths(d.json, map);
  const m = matrixOf(host), base = host.depth;
  const out = kids.map((it, k) => {
    const o = setMatrix({ ...it.o, depth: base + k }, multiply(m, matrixOf(it.o)));
    if ("alpha" in host) { o.alpha = Math.round((o.alpha ?? 1) * host.alpha * 1e5) / 1e5; if (o.alpha === 1) delete o.alpha; }
    return o;
  });
  list.splice(i, 1, ...out);
  d.sel = i;
  changed();
  status(`${describe(host)}: its ${kids.length} line${kids.length > 1 ? "s" : ""} put in its place`, "good");
}

/** Saves a tab: checked by the server (the build's encoder), then written. */
async function saveTab(t) {
  const order = t.kind === "button" ? RECORD_ORDER : PLACE_ORDER;
  if (t.kind === "sprite") for (const f of t.json.frames ?? []) if (f.place) f.place = f.place.map((o) => ordered(o, order));
  if (t.kind === "button") t.json.records = t.json.records.map((o) => ordered(o, order));
  await api(`/api/save?path=${encodeURIComponent(t.file)}`, { method: "PUT", body: JSON.stringify(t.json) });
  const created = t.saved === null;
  t.saved = JSON.stringify(t.json);
  diskJson.delete(t.file);
  return created;
}
async function save(all = false) {
  const todo = all ? S.tabs.filter(isDirty) : D() && isDirty(D()) ? [D()] : [];
  if (!todo.length) return;
  status("saving…");
  const errors = [];
  let created = false;
  // Ours first: what the others place must exist to be checked.
  for (const t of todo.sort((a, b) => b.file.startsWith("assets/") - a.file.startsWith("assets/"))) {
    try { created = (await saveTab(t)) || created; } catch (e) { errors.push(`${t.title} (src/${t.file}):\n  ${e.message}`); }
  }
  if (created) { await loadLibrary(); renderList(); }
  setDirty();
  resetDefs();
  await draw();
  if (errors.length) { status(`${errors.length} not saved: see below`, "bad"); log(errors.join("\n\n")); }
  else { status(todo.length > 1 ? `saved ${todo.length} files` : `saved src/${todo[0].file}`, "good"); log(null); }
}

async function build() {
  $("build").disabled = true;
  const unsaved = S.tabs.filter(isDirty).length;
  status("building…");
  log(`building${unsaved ? ` what's saved (${unsaved} tab${unsaved > 1 ? "s" : ""} with unsaved changes left out)` : ""}…`);
  try {
    const r = await api("/api/build", { method: "POST" });
    log(r.log);
    status(r.ok ? "built: build/loader.swf" : "build failed: see below", r.ok ? "good" : "bad");
  } catch (e) { log(e.message); status("build failed", "bad"); }
  $("build").disabled = false;
}

function newSprite() {
  const path = prompt("New sprite, in src/assets/new/ — its path is its export name, in lower case (letters, digits, _ and -; / for folders):", "ui/my-panel");
  if (!path) return;
  const clean = path.replace(/^\/+|\.json$/g, "");
  if (!clean.split("/").every((p) => /^[A-Za-z0-9_-]+$/.test(p))) { status(`"${path}": letters, digits, _ and - only, / between folders`, "bad"); return; }
  const name = clean.toLowerCase(), file = `assets/new/${clean}.json`;
  if (S.lib.fresh.some((f) => f.name === name) || S.lib.exports[name] !== undefined || S.tabs.some((t) => t.name === name)) { status(`"${name}" is exported already`, "bad"); return; }
  // A tab like any other: written when saved.
  S.tabs.push(newTab(file, { frames: [{}] }, null));
  activate(S.tabs.length - 1);
  status(`new sprite "${name}": written to src/${file} when you save`, "good");
}

async function reloadFiles() {
  diskJson.clear(); loaded.clear(); shapeText.clear();
  await loadLibrary();
  renderList();
  resetDefs();
  await draw();
  status("files read again (unsaved changes kept)", "good");
}

function setupCommands() {
  $("undo").onclick = () => undo();
  $("redo").onclick = () => undo(true);
  $("save").onclick = () => save();
  $("saveAll").onclick = () => save(true);
  $("build").onclick = build;
  $("newSprite").onclick = newSprite;
  $("fit").onclick = fit;
  $("reload").onclick = reloadFiles;
  $("screen").onclick = () => { const d = D(); if (!d) return; d.screen = !d.screen; draw(); remember(); };
  $("whereUsed").onclick = () => {
    const d = D();
    if (d.id) return showWhere(d.id, `src/${d.file}`);
    status(`${d.name}: placed where you put it (search the sprite.json files for "export": "${d.name}")`);
  };
  $("up").onclick = () => restack(1);
  $("down").onclick = () => restack(-1);
  $("remove").onclick = removeSel;
  $("group").onclick = () => { const d = D(); if (d?.sel !== null) group([d.sel]); };
  $("ungroup").onclick = () => { const d = D(); if (d?.sel !== null) ungroup(d.sel); };
  $("search").oninput = renderList;
  $("frame").onchange = () => { const d = D(); d.frame = Math.max(1, Number($("frame").value) || 1); d.sel = null; draw(); renderInspector(); };
  $("state").onchange = () => { D().state = $("state").value; draw(); };
  window.addEventListener("keydown", (e) => {
    const typing = /INPUT|TEXTAREA|SELECT/.test(document.activeElement?.tagName);
    const mod = e.ctrlKey || e.metaKey;
    if (mod && e.key.toLowerCase() === "s") { e.preventDefault(); save(e.shiftKey); return; }
    if (mod && e.key.toLowerCase() === "w") { e.preventDefault(); if (S.active >= 0) closeTab(S.active); return; }
    if (mod && (e.key === "PageDown" || e.key === "PageUp") && S.tabs.length) { e.preventDefault(); activate((S.active + (e.key === "PageDown" ? 1 : -1) + S.tabs.length) % S.tabs.length); return; }
    if (typing) return;
    if (mod && e.key.toLowerCase() === "g") { e.preventDefault(); if (D()?.sel != null) (e.shiftKey ? ungroup : (i) => group([i]))(D().sel); }
    else if (mod && e.key.toLowerCase() === "z") { e.preventDefault(); undo(e.shiftKey); }
    else if (mod && e.key.toLowerCase() === "y") { e.preventDefault(); undo(true); }
    else if (e.key.startsWith("Arrow")) {
      e.preventDefault();
      const n = e.shiftKey ? 10 : 1;
      nudge(e.key === "ArrowLeft" ? -n : e.key === "ArrowRight" ? n : 0, e.key === "ArrowUp" ? -n : e.key === "ArrowDown" ? n : 0);
    } else if (e.key === "Delete" || e.key === "Backspace") removeSel();
    else if (e.key === "Escape") { if (D()) select(null); }
    else if (e.key === "f" || e.key === "F") fit();
  });
  window.addEventListener("beforeunload", (e) => { if (S.tabs.some(isDirty)) e.preventDefault(); });
  window.addEventListener("resize", applyView);
}

/** The tabs of the last visit, with their unsaved changes. */
async function restore() {
  const s = store.get("session", null);
  for (const t of s?.tabs ?? []) {
    const disk = await fetch(`/src/${t.file}`).then((r) => (r.ok ? r.json() : null)).catch(() => null);
    if (!disk && !t.draft) continue;
    const tab = newTab(t.file, t.draft ?? disk, disk ? JSON.stringify(disk) : null);
    tab.view = t.view ?? null;
    if (t.screen !== undefined) tab.screen = t.screen;
    S.tabs.push(tab);
  }
  const hash = decodeURIComponent(location.hash.slice(1));
  const i = hash ? S.tabs.findIndex((t) => t.file === hash) : -1;
  if (hash && i < 0) return open(hash);
  if (S.tabs.length) await activate(i >= 0 ? i : Math.min(Math.max(s?.active ?? 0, 0), S.tabs.length - 1));
  const drafts = S.tabs.filter(isDirty).length;
  if (drafts) status(`${drafts} tab${drafts > 1 ? "s" : ""} with unsaved changes, as you left them`);
}

// --- Start ------------------------------------------------------------------

(async () => {
  try {
    await loadLibrary();
  } catch (e) { status(`can't reach the editor's server: ${e.message}`, "bad"); return; }
  renderTabs();
  renderList();
  setupStage();
  setupSplitters();
  setupCommands();
  applyView();
  status(`base ${S.lib.version}: ${S.lib.objects.length} sprites, buttons, texts · ${S.lib.shapes.length} shapes`);
  setDirty();
  await restore();
})();
