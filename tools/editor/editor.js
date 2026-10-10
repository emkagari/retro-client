// The sprite editor's page (tools/editor/editor.mjs serves it). It draws a
// sprite as SVG from the repo's files — the shapes of src/assets/shapes/,
// placed as its sprite.json says — and edits that JSON: what is placed,
// where, at what depth. Saving sends it to the server, which checks it with
// the build's own encoder before writing it.

const SVG = "http://www.w3.org/2000/svg";
const REF = ["export", "shape", "sprite", "text", "button", "morph", "video"];
const MATRIX = ["x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix"];
// The key order the extraction writes (tools/sprites.mjs readPlace / readButton): an untouched line stays the same.
const PLACE_ORDER = ["depth", "move", ...REF, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "ratio", "name", "mask", "filters", "blend", "actions"];
const RECORD_ORDER = ["depth", "states", ...REF, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "filters", "blend"];
const BLENDS = { multiply: "multiply", screen: "screen", lighten: "lighten", darken: "darken", difference: "difference", overlay: "overlay", hardlight: "hard-light", add: "plus-lighter" };

const $ = (id) => document.getElementById(id);
const el = (name, attrs = {}, ns = SVG) => {
  const e = document.createElementNS(ns, name);
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

const S = {
  lib: null, byId: new Map(), freshByName: new Map(),
  doc: null,            // { file, kind, json, saved, undo, redo, title }
  frame: 1, state: "up", sel: null, hidden: new Set(), back: [],
  view: { x: 0, y: 0, k: 1 }, tab: "Interfaces",
};
// For the DevTools (and tests): the editor's state.
window.editorState = S;

// --- Status and log ---------------------------------------------------------

function status(text, kind = "") {
  $("status").textContent = text;
  $("status").className = kind;
}
function log(text, open = true) {
  const l = $("log");
  if (typeof text === "string") l.textContent = text; else { l.textContent = ""; l.append(text); }
  l.classList.toggle("open", open);
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
  if (S.tab === "Ours" && !all.length) list.append(html("div", { className: "hint" }, "Nothing in src/assets/new/ yet: add an .svg / .png there, or a new sprite (New sprite)."));
  for (const e of shown) {
    let node;
    if (S.tab === "Shapes") {
      node = html("div", { className: "thumb", title: `shape ${e.id} — click: where it's placed` });
      node.append(html("img", { src: `/src/${e.file}`, loading: "lazy", draggable: false }), html("span", {}, e.id));
      node.onclick = () => showWhere(e.id, `shape ${e.id}`);
    } else {
      node = html("div", { className: "item" + (S.doc?.file === e.file ? " on" : ""), title: e.file });
      node.append(html("span", {}, e.name ?? `${e.kind} ${e.id}`));
      if (e.name && e.id !== undefined) node.append(html("small", {}, e.id));
      if (S.tab === "Ours") node.append(html("small", {}, e.kind === "sprite" ? "sprite" : e.ext));
      const openable = e.kind !== "graphic";
      node.onclick = () => openable ? open(e.file) : status(`${e.name}: drag it onto a sprite`);
    }
    node.draggable = true;
    node.ondragstart = (ev) => ev.dataTransfer.setData("application/x-ref", JSON.stringify(refFromEntry(e)));
    list.append(node);
  }
  if (hits.length > shown.length) list.append(html("div", { className: "hint" }, `… ${hits.length - shown.length} more: search`));
}

// --- Files ------------------------------------------------------------------

const jsonCache = new Map();
async function getJson(file) {
  if (!jsonCache.has(file)) jsonCache.set(file, fetch(`/src/${file}`).then((r) => (r.ok ? r.json() : null)));
  return jsonCache.get(file);
}

// --- Drawing ----------------------------------------------------------------

/** a, b, c, d, tx, ty from a placement's fields (the formula of tools/sprites.mjs). */
function matrixOf(o) {
  const tx = o.x ?? 0, ty = o.y ?? 0;
  if (o.matrix) return [...o.matrix, tx, ty];
  const sx = o.scaleX ?? o.scale ?? 1, sy = o.scaleY ?? o.scale ?? 1, r = ((o.rotation ?? 0) * Math.PI) / 180;
  return [sx * Math.cos(r), sx * Math.sin(r), -sy * Math.sin(r), sy * Math.cos(r), tx, ty];
}
const transformOf = (o) => `matrix(${matrixOf(o).join(" ")})`;

/** What a placement shows: { kind, id } of the base, ours (fresh), or missing. */
function refOf(o) {
  if (o.export !== undefined) {
    const id = S.lib.exports[o.export];
    if (id !== undefined) return { kind: S.lib.kinds[id], id };
    const f = S.freshByName.get(o.export);
    if (f) return { kind: f.kind === "sprite" ? "freshSprite" : "freshGraphic", f };
    return { kind: "missing", label: o.export };
  }
  for (const k of REF.slice(1)) if (k in o) return { kind: k, id: o[k] };
  return null;
}
const describe = (o) => o.export ?? REF.slice(1).filter((k) => k in o).map((k) => `${k} ${o[k]}`)[0] ?? (o.move ? "(move)" : "?");

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

const defs = () => $("defs");
const defCache = new Map();
let defSeq = 0;
function resetDefs() { defCache.clear(); defs().textContent = ""; }

/** A def's id for what a placement shows (drawn once, used by every placement), or null. */
function ensureDef(ref, level) {
  if (!ref || level > 12) return Promise.resolve(null);
  const key = ref.kind === "freshSprite" || ref.kind === "freshGraphic" ? `${ref.kind}:${ref.f.file}` : `${ref.kind}:${ref.id ?? ref.label}`;
  if (!defCache.has(key)) defCache.set(key, makeDef(ref, level, `d${++defSeq}`).catch((e) => { console.warn(key, e); return null; }));
  return defCache.get(key);
}

async function makeDef(ref, level, id) {
  const g = el("g", { id });
  defs().append(g);
  if (ref.kind === "shape") {
    let text = await fetch(`/src/assets/shapes/${ref.id}.svg`).then((r) => (r.ok ? r.text() : null));
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
  } else if (ref.kind === "sprite" || ref.kind === "freshSprite") {
    const file = ref.kind === "sprite" ? S.byId.get(ref.id)?.file : ref.f.file;
    const json = file && (await getJson(file));
    if (!json) return placeholder(g, `sprite ${ref.id}`);
    await drawList(g, displayList(json.frames ?? [], 1), level + 1, false);
  } else if (ref.kind === "button") {
    const json = await getJson(S.byId.get(ref.id)?.file);
    if (!json) return placeholder(g, `button ${ref.id}`);
    await drawList(g, json.records.filter((r) => r.states.includes("up")).map((o) => ({ depth: o.depth, o })), level + 1, false);
  } else if (ref.kind === "text") {
    const json = await getJson(S.byId.get(ref.id)?.file);
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
      const chars = r.text !== undefined ? [...r.text] : r.glyphs.map(() => "?");
      const xs = [];
      let cx = x;
      for (let i = 0; i < chars.length; i++) { xs.push(round20(cx)); cx += r.advances[i] ?? 0; }
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
    const id = `cx${filterCache.size}`;
    const m = color.mult ?? [1, 1, 1, 1], a = (color.add ?? [0, 0, 0, 0]).map((v) => v / 255);
    const f = el("filter", { id, "color-interpolation-filters": "sRGB", x: "-10%", y: "-10%", width: "120%", height: "120%" });
    f.append(el("feColorMatrix", { type: "matrix", values: `${m[0]} 0 0 0 ${a[0]}  0 ${m[1]} 0 0 ${a[1]}  0 0 ${m[2]} 0 ${a[2]}  0 0 0 ${m[3]} ${a[3]}` }));
    $("svg").querySelector("defs").append(f);
    filterCache.set(key, id);
  }
  return filterCache.get(key);
}

/** One placement drawn: a <use> of its def, moved, coloured. */
async function drawItem(o, level) {
  const id = await ensureDef(refOf(o), level);
  const u = id ? el("use", { href: `#${id}` }) : el("g");
  if (!id) placeholder(u, describe(o));
  u.setAttribute("transform", transformOf(o));
  if ("alpha" in o) u.setAttribute("opacity", o.alpha);
  if (o.color) u.setAttribute("filter", `url(#${colorFilter(o.color)})`);
  if (o.blend && BLENDS[o.blend]) u.style.mixBlendMode = BLENDS[o.blend];
  return u;
}

/** A display list into `parent`, by depth; a mask clips the depths above it, up to its own `mask`. */
async function drawList(parent, list, level, interactive) {
  const nodes = await Promise.all(list.map((it) => (it.o.mask ? null : drawItem(it.o, level))));
  let clip = null;
  for (let i = 0; i < list.length; i++) {
    const it = list[i];
    if (clip && it.depth > clip.until) clip = null;
    if (it.o.mask) {
      const id = await ensureDef(refOf(it.o), level);
      const cp = el("clipPath", { id: `clip${++defSeq}` });
      if (id) cp.append(el("use", { href: `#${id}`, transform: transformOf(it.o) }));
      defs().append(cp);
      const g = el("g", { "clip-path": `url(#${cp.id})` });
      parent.append(g);
      clip = { g, until: it.o.mask };
      if (interactive) { const ghost = el("g", { class: "item mask", "data-i": it.src ?? "" }); parent.append(ghost); }
      continue;
    }
    let node = nodes[i];
    if (interactive) {
      const w = el("g", { class: "item" + (S.hidden.has(it.depth) ? " hidden" : ""), "data-i": it.src ?? "", "data-depth": it.depth });
      w.append(node);
      node = w;
    }
    (clip ? clip.g : parent).append(node);
  }
}

// --- The open document ------------------------------------------------------

/** The editable lines: a sprite's frame-1 placements, a button's records; none for a text. */
function items() {
  const d = S.doc;
  if (!d) return null;
  if (d.kind === "sprite") { d.json.frames ??= [{}]; if (!d.json.frames.length) d.json.frames.push({}); return (d.json.frames[0].place ??= []); }
  if (d.kind === "button") return d.json.records;
  return null;
}
const editable = () => S.doc && S.doc.kind !== "text" && (S.doc.kind === "button" || S.frame === 1);

function currentList() {
  const d = S.doc;
  if (d.kind === "sprite") return displayList(d.json.frames ?? [], S.frame);
  if (d.kind === "button") return d.json.records.map((o, k) => ({ depth: o.depth, o, src: k })).filter((it) => it.o.states?.includes(S.state)).sort((a, b) => a.depth - b.depth);
  return [];
}

let drawSeq = 0;
async function draw() {
  const seq = ++drawSeq;
  const content = $("content");
  const fresh = el("g");
  const d = S.doc;
  if (d?.kind === "text") drawText(fresh, d.json);
  else if (d) await drawList(fresh, currentList(), 0, true);
  if (seq !== drawSeq) return;
  content.replaceWith(fresh);
  fresh.id = "content";
  $("empty").hidden = !!d;
  drawSelection();
  renderLayers();
}

function drawSelection() {
  const ov = $("overlay");
  ov.textContent = "";
  if (S.sel === null) return;
  const node = $("content").querySelector(`.item[data-i="${S.sel}"]`);
  const o = items()?.[S.sel];
  if (!o) return;
  if (node && !node.classList.contains("mask")) {
    const bb = node.getBBox();
    ov.append(el("rect", { x: bb.x, y: bb.y, width: bb.width, height: bb.height, fill: "none", stroke: "#e0a040", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
  }
  const k = 6 / S.view.k, x = o.x ?? 0, y = o.y ?? 0;
  ov.append(el("path", { d: `M${x - k} ${y}H${x + k}M${x} ${y - k}V${y + k}`, stroke: "#6aa8e8", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
}

function setDirty() {
  const d = S.doc;
  const dirty = d && JSON.stringify(d.json) !== d.saved;
  $("doc").classList.toggle("dirty", !!dirty);
  $("save").disabled = !dirty;
  $("undo").disabled = !d?.undo.length;
  $("redo").disabled = !d?.redo.length;
  $("back").disabled = !S.back.length;
}
function snapshot() { S.doc.undo.push(JSON.stringify(S.doc.json)); S.doc.redo = []; }
function changed() { setDirty(); draw(); renderInspector(); }

async function open(file, { remember = true } = {}) {
  if (S.doc && S.doc.file !== file && JSON.stringify(S.doc.json) !== S.doc.saved && !confirm(`${S.doc.file} has unsaved changes: leave it?`)) return;
  const json = await fetch(`/src/${file}`).then((r) => (r.ok ? r.json() : null));
  if (!json) { status(`can't read src/${file}`, "bad"); return; }
  if (remember && S.doc && S.doc.file !== file) S.back.push(S.doc.file);
  const kind = file.startsWith("timeline/texts/") ? "text" : file.startsWith("timeline/buttons/") ? "button" : "sprite";
  S.doc = { file, kind, json, saved: JSON.stringify(json), undo: [], redo: [] };
  S.sel = null; S.frame = 1; S.hidden.clear();
  const id = Number(/\/(\d+)/.exec(file)?.[1]);
  const entry = S.byId.get(id);
  $("doc").textContent = `src/${file}${entry?.name ? `  (${entry.name})` : ""}`;
  $("whereUsed").disabled = !(id || file.startsWith("assets/new/"));
  const frames = kind === "sprite" ? json.frames?.length ?? 1 : 1;
  $("frames").hidden = !(frames > 1 || kind === "button");
  $("frame").hidden = kind !== "sprite"; $("frameCount").hidden = kind !== "sprite";
  $("frame").max = frames; $("frame").value = 1; $("frameCount").textContent = `/ ${frames}${frames > 1 ? " (editing: frame 1)" : ""}`;
  $("state").hidden = kind !== "button"; $("state").value = S.state;
  location.hash = file;
  setDirty();
  await draw();
  fit();
  renderInspector();
  renderList();
  status(`${kind} opened`);
}

// --- Layers and inspector ---------------------------------------------------

function renderLayers() {
  const box = $("layers");
  box.textContent = "";
  if (!S.doc || S.doc.kind === "text") { box.append(html("div", { className: "hint" }, S.doc ? "A text: edit it in the inspector." : "")); return; }
  const list = currentList().slice().reverse();
  for (const it of list) {
    const row = html("div", { className: "layer" + (it.src !== null && it.src === S.sel ? " on" : "") });
    const eye = html("span", { className: "eye" + (S.hidden.has(it.depth) ? " off" : ""), title: "Hide here (not saved)" }, "👁");
    eye.onclick = (e) => { e.stopPropagation(); S.hidden.has(it.depth) ? S.hidden.delete(it.depth) : S.hidden.add(it.depth); draw(); };
    row.append(html("span", { className: "d" }, it.depth), eye, html("span", { className: "what" }, (it.o.mask ? "mask: " : "") + describe(it.o)));
    if (it.o.name) row.append(html("span", { className: "name" }, it.o.name));
    row.onclick = () => select(it.src);
    box.append(row);
  }
  $("up").disabled = $("down").disabled = $("remove").disabled = S.sel === null || !editable();
}

function select(i) {
  S.sel = i ?? null;
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

function renderInspector() {
  const box = $("inspector");
  box.textContent = "";
  const d = S.doc;
  if (!d) return;
  if (d.kind === "text") {
    box.append(html("div", { className: "hint" }, d.json.records ? "A static text: change \"text\" and give one width per character (\"advances\", px)." : "A text field: its box and settings (docs/SPRITES.md)."));
    const ta = html("textarea", { value: JSON.stringify(d.json, null, 1) });
    ta.style.height = "60vh";
    const apply = html("button", {}, "Apply");
    apply.onclick = () => { try { const j = JSON.parse(ta.value); snapshot(); d.json = j; changed(); } catch (e) { status(e.message, "bad"); } };
    box.append(ta, html("div", { className: "actions" }), apply);
    return;
  }
  const o = items()?.[S.sel];
  if (S.sel === null || !o) {
    box.append(html("div", { className: "hint" }, editable() ? "Select a layer, or drag something from the left onto the sprite." : "Frames after the first are shown, not edited here: edit them in the sprite.json."));
    return;
  }
  const ro = !editable();
  const field = (label, value, set, type = "number") => {
    const row = html("div", { className: "row" });
    const input = html("input", { type, value: value ?? "", disabled: ro, step: "any" });
    input.onchange = () => { snapshot(); set(type === "number" ? (input.value === "" ? undefined : Number(input.value)) : input.value); changed(); };
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
    const sx = o.scaleX ?? o.scale ?? 1, sy = o.scaleY ?? o.scale ?? 1;
    field("scale x", sx, (v) => setScale(o, v ?? 1, o.scaleY ?? o.scale ?? 1));
    field("scale y", sy, (v) => setScale(o, o.scaleX ?? o.scale ?? 1, v ?? 1));
    field("rotation", o.rotation ?? 0, (v) => { if (v) o.rotation = v; else delete o.rotation; });
  }
  if (!o.color) field("alpha", o.alpha ?? 1, (v) => { if (v === undefined || v === 1) delete o.alpha; else o.alpha = v; });
  if (S.doc.kind === "sprite") field("name", o.name ?? "", (v) => { if (v) o.name = v; else delete o.name; }, "text");
  if (S.doc.kind === "button") {
    const row = html("div", { className: "row" });
    const boxes = html("span");
    for (const s of ["up", "over", "down", "hit"]) {
      const c = html("input", { type: "checkbox", checked: o.states.includes(s), disabled: ro });
      c.onchange = () => { snapshot(); o.states = ["up", "over", "down", "hit"].filter((x) => (x === s ? c.checked : o.states.includes(x))); changed(); };
      const l = html("label", {});
      l.append(c, ` ${s} `);
      boxes.append(l);
    }
    row.append(html("label", {}, "states"), boxes);
    box.append(row);
  }
  const actions = html("div", { className: "actions" });
  const target = ref?.kind === "sprite" || ref?.kind === "button" || ref?.kind === "text" ? S.byId.get(ref.id)?.file : ref?.kind === "freshSprite" ? ref.f.file : null;
  if (target) { const b = html("button", {}, "Open it"); b.onclick = () => open(target); actions.append(b); }
  if (ref?.id !== undefined) { const b = html("button", {}, "Where else"); b.onclick = () => showWhere(ref.id, describe(o)); actions.append(b); }
  box.append(actions);
  const ta = html("textarea", { value: JSON.stringify(o), disabled: ro, title: "The line itself (docs/SPRITES.md)" });
  const apply = html("button", { disabled: ro }, "Apply JSON");
  apply.onclick = () => {
    try { const j = JSON.parse(ta.value); snapshot(); items()[S.sel] = j; changed(); } catch (e) { status(e.message, "bad"); }
  };
  box.append(ta, html("div", { className: "actions" }), apply);
  if (o.actions || o.name) box.append(html("div", { className: "hint" }, `${o.name ? `Code may reach it as this.${o.name}. ` : ""}${o.actions ? "It has clip actions (frame_1/PlaceObject2_….as)." : ""}`));
}

async function showWhere(id, label) {
  const found = await api(`/api/where?id=${id}`);
  const out = document.createElement("div");
  out.append(`${label}: placed ${found.length} time${found.length === 1 ? "" : "s"}\n`);
  for (const w of found) {
    const a = html("a", {}, `src/${w.file}`);
    a.onclick = () => open(w.file);
    out.append("  ", a, `  ${w.where}: ${JSON.stringify(w.fields)}\n`);
  }
  log(out);
}

// --- Stage: view, selection, dragging, dropping -----------------------------

function applyView() {
  const v = S.view;
  $("view").setAttribute("transform", `translate(${v.x} ${v.y}) scale(${v.k})`);
  $("zoomInfo").textContent = `${Math.round(v.k * 100)}%`;
  drawSelection();
}
function fit() {
  const box = $("stage").getBoundingClientRect();
  let bb;
  try { bb = $("content").getBBox(); } catch { bb = null; }
  if (!bb || !bb.width || !bb.height) { S.view = { x: box.width / 2, y: box.height / 2, k: 1 }; applyView(); return; }
  const k = Math.min(box.width / bb.width, box.height / bb.height, 8) * 0.9;
  S.view = { k, x: box.width / 2 - (bb.x + bb.width / 2) * k, y: box.height / 2 - (bb.y + bb.height / 2) * k };
  applyView();
}
/** A pointer's position in the sprite's coordinates. */
function toSprite(e) {
  const r = $("stage").getBoundingClientRect(), v = S.view;
  return { x: (e.clientX - r.left - v.x) / v.k, y: (e.clientY - r.top - v.y) / v.k };
}

function setupStage() {
  const stage = $("stage");
  let drag = null;
  stage.addEventListener("pointerdown", (e) => {
    const item = e.target.closest?.("#content .item");
    const i = item && item.dataset.i !== "" ? Number(item.dataset.i) : null;
    if (e.button === 0 && i !== null && editable()) {
      select(i);
      const o = items()[i];
      drag = { kind: "move", start: toSprite(e), x: o.x ?? 0, y: o.y ?? 0, node: item.firstChild, moved: false, before: JSON.stringify(S.doc.json) };
    } else {
      if (i !== null) select(i);
      drag = { kind: "pan", sx: e.clientX, sy: e.clientY, vx: S.view.x, vy: S.view.y, moved: false, deselect: i === null };
    }
    stage.setPointerCapture(e.pointerId);
  });
  stage.addEventListener("pointermove", (e) => {
    if (!drag) return;
    if (drag.kind === "pan") {
      S.view.x = drag.vx + e.clientX - drag.sx; S.view.y = drag.vy + e.clientY - drag.sy;
      drag.moved ||= Math.abs(e.clientX - drag.sx) + Math.abs(e.clientY - drag.sy) > 3;
      applyView();
    } else {
      const p = toSprite(e), o = items()[S.sel];
      o.x = round20(drag.x + p.x - drag.start.x); o.y = round20(drag.y + p.y - drag.start.y);
      drag.moved = true;
      drag.node?.setAttribute("transform", transformOf(o));
      drawSelection();
    }
  });
  const end = () => {
    if (drag?.kind === "move" && drag.moved) { S.doc.undo.push(drag.before); S.doc.redo = []; changed(); }
    if (drag?.kind === "pan" && !drag.moved && drag.deselect) select(null);
    drag = null;
  };
  stage.addEventListener("pointerup", end);
  stage.addEventListener("pointercancel", end);
  stage.addEventListener("wheel", (e) => {
    e.preventDefault();
    const r = stage.getBoundingClientRect(), v = S.view;
    const k = Math.min(32, Math.max(0.05, v.k * Math.exp(-e.deltaY * 0.0015)));
    const px = e.clientX - r.left, py = e.clientY - r.top;
    S.view = { k, x: px - ((px - v.x) * k) / v.k, y: py - ((py - v.y) * k) / v.k };
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
    const ref = JSON.parse(raw), p = toSprite(e), list = items();
    const used = S.doc.kind === "sprite" ? S.doc.json.frames.flatMap((f) => (f.place ?? []).map((o) => o.depth)) : list.map((o) => o.depth);
    const depth = Math.max(0, ...used) + 1;
    snapshot();
    const o = S.doc.kind === "button" ? { depth, states: ["up", "over", "down"], ...ref, x: round20(p.x), y: round20(p.y) } : { depth, ...ref, x: round20(p.x), y: round20(p.y) };
    list.push(o);
    S.sel = list.length - 1;
    setDirty();
    // The drawing's centre where it falls (its origin may be far from it: the login logo's is).
    await draw();
    const node = $("content").querySelector(`.item[data-i="${S.sel}"]`);
    const bb = node?.getBBox();
    if (bb?.width) { o.x = round20(o.x + p.x - (bb.x + bb.width / 2)); o.y = round20(o.y + p.y - (bb.y + bb.height / 2)); }
    changed();
    status(`placed ${describe(o)} at depth ${depth}`);
  });
}

// --- Commands ---------------------------------------------------------------

function undo(redo = false) {
  const d = S.doc;
  const from = redo ? d.redo : d.undo, to = redo ? d.undo : d.redo;
  if (!from.length) return;
  to.push(JSON.stringify(d.json));
  d.json = JSON.parse(from.pop());
  if (S.sel !== null && !items()?.[S.sel]) S.sel = null;
  changed();
}
function nudge(dx, dy) {
  const o = items()?.[S.sel];
  if (!o || !editable()) return;
  snapshot();
  o.x = round20((o.x ?? 0) + dx); o.y = round20((o.y ?? 0) + dy);
  changed();
}
function removeSel() {
  if (S.sel === null || !editable()) return;
  snapshot();
  items().splice(S.sel, 1);
  S.sel = null;
  changed();
}
/** Swaps depths with the next layer up (dir 1) or down (-1). */
function restack(dir) {
  const o = items()?.[S.sel];
  if (!o || !editable()) return;
  const list = currentList().filter((it) => it.src !== null);
  const at = list.findIndex((it) => it.src === S.sel);
  const other = list[at + dir];
  if (!other) return;
  snapshot();
  const p = items()[other.src];
  [o.depth, p.depth] = [p.depth, o.depth];
  changed();
}

async function save() {
  const d = S.doc;
  if (!d) return;
  const order = d.kind === "button" ? RECORD_ORDER : PLACE_ORDER;
  if (d.kind === "sprite") for (const f of d.json.frames ?? []) if (f.place) f.place = f.place.map((o) => ordered(o, order));
  if (d.kind === "button") d.json.records = d.json.records.map((o) => ordered(o, order));
  status("saving…");
  try {
    await api(`/api/save?path=${encodeURIComponent(d.file)}`, { method: "PUT", body: JSON.stringify(d.json) });
    d.saved = JSON.stringify(d.json);
    jsonCache.delete(d.file);
    resetDefs(); filterCache.clear();
    setDirty();
    await draw();
    status(`saved src/${d.file}`, "good");
    log("", false);
  } catch (e) {
    status("not saved: see below", "bad");
    log(e.message);
  }
}

async function build() {
  $("build").disabled = true;
  status("building…");
  log("building…");
  try {
    const r = await api("/api/build", { method: "POST" });
    log(r.log);
    status(r.ok ? "built: build/loader.swf" : "build failed: see below", r.ok ? "good" : "bad");
  } catch (e) { log(e.message); status("build failed", "bad"); }
  $("build").disabled = false;
}

async function newSprite() {
  const path = prompt("New sprite, in src/assets/new/ — its path is its export name, in lower case (letters, digits, _ and -; / for folders):", "ui/my-panel");
  if (!path) return;
  const file = `assets/new/${path.replace(/^\/+|\.json$/g, "")}.json`;
  try {
    await api(`/api/save?path=${encodeURIComponent(file)}`, { method: "PUT", body: JSON.stringify({ frames: [{}] }) });
  } catch (e) { status("not created: see below", "bad"); log(e.message); return; }
  await loadLibrary();
  S.tab = "Ours"; renderTabs(); renderList();
  await open(file);
  status(`created src/${file}: attachMovie("${path.toLowerCase()}", …)`, "good");
}

function setupCommands() {
  $("undo").onclick = () => undo();
  $("redo").onclick = () => undo(true);
  $("save").onclick = save;
  $("build").onclick = build;
  $("newSprite").onclick = newSprite;
  $("fit").onclick = fit;
  $("back").onclick = () => { const f = S.back.pop(); if (f) open(f, { remember: false }); };
  $("whereUsed").onclick = () => {
    const d = S.doc, id = Number(/\/(\d+)/.exec(d.file)?.[1]);
    if (id) return showWhere(id, `src/${d.file}`);
    const name = S.lib.fresh.find((f) => f.file === d.file)?.name;
    status(`${name}: placed where you put it (search the sprite.json files for "export": "${name}")`);
  };
  $("up").onclick = () => restack(1);
  $("down").onclick = () => restack(-1);
  $("remove").onclick = removeSel;
  $("search").oninput = renderList;
  $("frame").onchange = () => { S.frame = Math.max(1, Number($("frame").value) || 1); S.sel = null; draw(); renderInspector(); };
  $("state").onchange = () => { S.state = $("state").value; draw(); };
  window.addEventListener("keydown", (e) => {
    const typing = /INPUT|TEXTAREA|SELECT/.test(document.activeElement?.tagName);
    const mod = e.ctrlKey || e.metaKey;
    if (mod && e.key === "s") { e.preventDefault(); save(); return; }
    if (typing) return;
    if (mod && e.key === "z") { e.preventDefault(); undo(e.shiftKey); }
    else if (mod && e.key === "y") { e.preventDefault(); undo(true); }
    else if (e.altKey && e.key === "ArrowLeft") $("back").click();
    else if (e.key.startsWith("Arrow")) {
      e.preventDefault();
      const n = e.shiftKey ? 10 : 1;
      nudge(e.key === "ArrowLeft" ? -n : e.key === "ArrowRight" ? n : 0, e.key === "ArrowUp" ? -n : e.key === "ArrowDown" ? n : 0);
    } else if (e.key === "Delete" || e.key === "Backspace") removeSel();
    else if (e.key === "Escape") select(null);
    else if (e.key === "f" || e.key === "F") fit();
  });
  window.addEventListener("beforeunload", (e) => { if (S.doc && JSON.stringify(S.doc.json) !== S.doc.saved) e.preventDefault(); });
  window.addEventListener("resize", applyView);
}

// --- Start ------------------------------------------------------------------

(async () => {
  try {
    await loadLibrary();
  } catch (e) { status(`can't reach the editor's server: ${e.message}`, "bad"); return; }
  renderTabs();
  renderList();
  setupStage();
  setupCommands();
  applyView();
  status(`base ${S.lib.version}: ${S.lib.objects.length} sprites, buttons, texts · ${S.lib.shapes.length} shapes`);
  const file = decodeURIComponent(location.hash.slice(1));
  if (file) open(file, { remember: false });
})();
