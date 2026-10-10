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

/** A def's id for what a placement shows (drawn once, used by every placement), or null. */
function ensureDef(ref, level) {
  if (!ref || level > 12) return Promise.resolve(null);
  const key = `${ref.kind}:${ref.file ?? ref.id ?? ref.label}`;
  if (!defCache.has(key)) defCache.set(key, makeDef(ref, level, `d${++defSeq}`).catch((e) => { console.warn(key, e); return null; }));
  return defCache.get(key);
}

async function makeDef(ref, level, id) {
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
    await drawList(g, childList(ref, json), level + 1, false);
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
      if (interactive) parent.append(el("g", { class: "item mask", "data-i": it.src ?? "" }));
      continue;
    }
    let node = nodes[i];
    if (interactive) {
      const w = el("g", { class: "item" + (D().hidden.has(it.depth) ? " hidden" : ""), "data-i": it.src ?? "", "data-depth": it.depth });
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

function drawSelection() {
  const ov = $("overlay");
  ov.textContent = "";
  const d = D();
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
    tabs: S.tabs.map((t) => ({ file: t.file, draft: isDirty(t) ? t.json : undefined, fresh: t.saved === null || undefined, view: t.view, screen: t.screen })),
  }), 300);
}
function snapshot(d = D()) { d.undo.push(JSON.stringify(d.json)); d.redo = []; }
/** Something changed in the open tab: what places it redraws too. */
function changed() { resetDefs(); setDirty(); draw(); renderInspector(); }

function renderTabbar() {
  const bar = $("tabbar");
  bar.textContent = "";
  if (!S.tabs.length) { bar.append(html("span", { className: "none" }, "No tab open")); return; }
  S.tabs.forEach((t, i) => {
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
  $("up").disabled = $("down").disabled = $("remove").disabled = !d || d.sel === null || !editable();
  if (!d || d.kind === "text") { box.append(html("div", { className: "hint" }, d ? "A text: edit it in the inspector." : "")); return; }
  // Top first, as drawn; a placed sprite or button unfolds into its own list (its definition: shared by every placement).
  const rows = (list, level, path, owner) => {
    for (const it of list.slice().reverse()) {
      const key = `${path}/${it.depth}`;
      const ref = refOf(it.o);
      const kids = hasChildren(ref);
      const top = level === 0;
      const row = html("div", { className: "layer" + (top ? "" : " child") + (top && it.src !== null && it.src === d.sel ? " on" : "") });
      row.style.paddingLeft = `${6 + level * 14}px`;
      const tw = html("span", { className: "tw" + (kids ? " can" : ""), title: kids ? "What it holds (its definition, shared by every placement)" : "" }, kids ? (d.open.has(key) ? "▾" : "▸") : "");
      tw.onclick = (e) => {
        e.stopPropagation();
        if (!kids) return;
        d.open.has(key) ? d.open.delete(key) : d.open.add(key);
        if (knownJson(ref.file) === undefined) fileJsonKnown(ref.file).then(renderLayers); else renderLayers();
      };
      row.append(tw, html("span", { className: "d" }, it.depth));
      if (top) {
        const eye = html("span", { className: "eye" + (d.hidden.has(it.depth) ? " off" : ""), title: "Hide while working (not saved)" }, "👁");
        eye.onclick = (e) => { e.stopPropagation(); d.hidden.has(it.depth) ? d.hidden.delete(it.depth) : d.hidden.add(it.depth); draw(); };
        row.append(eye);
      }
      row.append(html("span", { className: "what" }, (it.o.mask ? "mask: " : "") + describe(it.o)));
      if (it.o.name) row.append(html("span", { className: "name" }, it.o.name));
      if (top) row.onclick = () => select(it.src);
      else {
        row.title = `In ${owner.label}: double-click to edit it there`;
        row.onclick = () => status(`${describe(it.o)}: in ${owner.label}'s definition (double-click: edit it there — every placement of ${owner.label} changes)`);
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

function select(i) {
  D().sel = i ?? null;
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
function liveJson(value, apply, { height } = {}) {
  const ta = html("textarea", { value, spellcheck: false });
  if (height) ta.style.height = height;
  let fresh = true;
  ta.onfocus = () => { fresh = true; };
  ta.oninput = () => {
    let j;
    try { j = JSON.parse(ta.value); } catch { ta.classList.add("invalid"); ta.title = "Not JSON yet: not applied"; return; }
    if (!j || typeof j !== "object") return;
    ta.classList.remove("invalid"); ta.title = "";
    if (fresh) { snapshot(); fresh = false; }
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
  const o = items()?.[d.sel];
  if (d.sel === null || !o) {
    box.append(html("div", { className: "hint" }, editable() ? "Select a layer, or drag something from the left onto the sprite." : "Frames after the first are shown, not edited here: edit them in the sprite.json."));
    return;
  }
  const ro = !editable();
  const field = (label, value, set, type = "number") => {
    const row = html("div", { className: "row" });
    const input = html("input", { type, value: value ?? "", disabled: ro, step: "any" });
    let fresh = true;
    input.onfocus = () => { fresh = true; };
    input.oninput = () => {
      const v = type === "number" ? (input.value === "" ? undefined : Number(input.value)) : input.value;
      if (type === "number" && v !== undefined && !Number.isFinite(v)) return;
      if (fresh) { snapshot(); fresh = false; }
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
  if (d.kind === "sprite") field("name", o.name ?? "", (v) => { if (v) o.name = v; else delete o.name; }, "text");
  if (d.kind === "button") {
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
  if (hasChildren(ref) || (ref?.kind === "text" && ref.file)) { const b = html("button", {}, "Open it"); b.onclick = () => open(ref.file); actions.append(b); }
  if (ref?.id !== undefined) { const b = html("button", {}, "Where else"); b.onclick = () => showWhere(ref.id, describe(o)); actions.append(b); }
  box.append(actions);
  if (!ro) box.append(liveJson(JSON.stringify(o), (j) => { items()[d.sel] = j; }));
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
    if (e.button === 0 && i !== null && editable()) {
      select(i);
      const o = items()[i];
      drag = { kind: "move", start: toSprite(e), x: o.x ?? 0, y: o.y ?? 0, node: item.firstChild, moved: false, before: JSON.stringify(D().json) };
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
    } else {
      const p = toSprite(e), o = items()[D().sel];
      o.x = round20(drag.x + p.x - drag.start.x); o.y = round20(drag.y + p.y - drag.start.y);
      drag.moved = true;
      drag.node?.setAttribute("transform", transformOf(o));
      drawSelection();
    }
  });
  const end = () => {
    if (drag?.kind === "move" && drag.moved) { D().undo.push(drag.before); D().redo = []; changed(); }
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
  to.push(JSON.stringify(d.json));
  d.json = JSON.parse(from.pop());
  if (d.sel !== null && !items()?.[d.sel]) d.sel = null;
  changed();
}
function nudge(dx, dy) {
  const o = items()?.[D()?.sel];
  if (!o || !editable()) return;
  snapshot();
  o.x = round20((o.x ?? 0) + dx); o.y = round20((o.y ?? 0) + dy);
  changed();
}
function removeSel() {
  const d = D();
  if (!d || d.sel === null || !editable()) return;
  snapshot();
  items().splice(d.sel, 1);
  d.sel = null;
  changed();
}
/** Swaps depths with the next layer up (dir 1) or down (-1). */
function restack(dir) {
  const d = D(), o = items()?.[d?.sel];
  if (!o || !editable()) return;
  const list = currentList().filter((it) => it.src !== null);
  const at = list.findIndex((it) => it.src === d.sel);
  const other = list[at + dir];
  if (!other) return;
  snapshot();
  const p = items()[other.src];
  [o.depth, p.depth] = [p.depth, o.depth];
  changed();
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
    if (mod && e.key.toLowerCase() === "z") { e.preventDefault(); undo(e.shiftKey); }
    else if (mod && e.key.toLowerCase() === "y") { e.preventDefault(); undo(true); }
    else if (e.key.startsWith("Arrow")) {
      e.preventDefault();
      const n = e.shiftKey ? 10 : 1;
      nudge(e.key === "ArrowLeft" ? -n : e.key === "ArrowRight" ? n : 0, e.key === "ArrowUp" ? -n : e.key === "ArrowDown" ? n : 0);
    } else if (e.key === "Delete" || e.key === "Backspace") removeSel();
    else if (e.key === "Escape") select(null);
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
