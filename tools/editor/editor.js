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
const PLACE_ORDER = ["depth", "move", ...REF, "x", "y", "scale", "scaleX", "scaleY", "rotation", "matrix", "alpha", "color", "ratio", "name", "mask", "filters", "blend", "actions", "params"];
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
  // Components drawn as their code draws them; every line's box and name over the drawing.
  ui: null, components: store.get("components", true), outlines: store.get("outlines", false),
  // Masks applied as in the game; each mask's shape shown (independent).
  masks: store.get("masks", true), maskShapes: store.get("maskShapes", false),
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
  S.ui = await api("/api/ui").catch(() => null);
  // What a parameter may name: a style, an export (a background, a content, an icon).
  const list = (id, values) => {
    const dl = $(id) ?? document.body.appendChild(html("datalist", { id }));
    dl.textContent = "";
    for (const v of values) dl.append(html("option", { value: v }));
  };
  list("dl-styles", Object.keys(S.ui?.styles ?? {}).sort());
  list("dl-exports", [...Object.keys(S.lib.exports), ...S.freshByName.keys()].sort());
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
const canHold = (ref) => (ref?.kind === "sprite" || ref?.kind === "freshSprite") && !!ref.file;
const ID = [1, 0, 0, 1, 0, 0];
const hasChildren = (ref) => ref && (ref.kind === "sprite" || ref.kind === "freshSprite" || ref.kind === "button") && ref.file;

/**
 * The display list at frame n: what each depth holds, with the frame-1 line
 * it comes from. A line placed where something already is, the player
 * ignores (the first one shows): listed after it, `ignored`, not drawn.
 */
function displayList(frames, n) {
  const st = new Map(), ignored = [];
  for (let i = 0; i < Math.min(n, frames.length); i++) {
    const fr = frames[i] ?? {};
    for (const d of fr.remove ?? []) st.delete(d);
    (fr.place ?? []).forEach((o, k) => {
      if (!o.move && st.has(o.depth)) { ignored.push({ depth: o.depth, o: { ...o }, src: i === 0 ? k : null, frame: i + 1, ignored: true }); return; }
      if (!o.move) { st.set(o.depth, { o: { ...o }, src: i === 0 ? k : null, frame: i + 1 }); return; }
      const cur = st.get(o.depth);
      if (!cur) return;
      const m = { ...cur.o };
      const take = (keys) => { if (keys.some((r) => r in o)) { for (const r of keys) delete m[r]; for (const r of keys) if (r in o) m[r] = o[r]; } };
      take(REF); take(MATRIX); take(["alpha", "color"]);
      for (const r of ["name", "ratio", "mask", "filters", "blend"]) if (r in o) m[r] = o[r];
      st.set(o.depth, { o: m, src: i === 0 ? k : null, frame: cur.frame });
    });
  }
  const out = [...st.entries()].sort((a, b) => a[0] - b[0]).map(([depth, v]) => ({ depth, ...v }));
  for (const it of ignored) out.splice(out.findIndex((x) => x.depth === it.depth) + 1, 0, it);
  return out;
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
function resetDefs() { defCache.clear(); filterCache.clear(); measured.clear(); defs().textContent = ""; }

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
    await drawList(g, childList(ref, json), level + 1, false, path, ref.file);
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
async function drawItem(o, level, path, params) {
  const ref = refOf(o), comp = S.components && (await componentOf(ref));
  let u;
  if (comp) u = await drawComponent(o, comp, params ?? {}, level);
  else {
    const id = await ensureDef(ref, level, path);
    u = id ? el("use", { href: `#${id}` }) : el("g");
    if (!id) placeholder(u, describe(o));
    u.setAttribute("transform", transformOf(o));
  }
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
async function drawList(parent, list, level, interactive, path = "", file = null) {
  const hidden = D()?.hidden ?? new Set();
  const at = (it) => (path === null ? null : `${path}/${it.depth}`);
  const params = file ? await paramsOf(file) : {};
  // A component's parameters, and what its sprite's class puts in it (a text).
  const tab = file && S.tabs.find((x) => x.file === file);
  const paramsFor = (it) => {
    const p = it.o.params ?? params[it.frame ?? 1]?.[tab && it.frame === 1 ? savedDepth(tab, it.o) : it.depth], code = it.o.name && params.texts?.[it.o.name];
    return code ? { ...p, code } : p;
  };
  list = list.filter((it) => !it.ignored);
  const nodes = await Promise.all(list.map((it) => (it.o.mask || (!interactive && hidden.has(at(it))) ? null : drawItem(it.o, level, at(it), paramsFor(it)))));
  // What the class hides as it starts: faded (still there to be moved: a placer marks where code puts something).
  const codeHidden = (it) => S.components && !!it.o.name && !!params.hidden?.includes(it.o.name);
  list.forEach((it, i) => { if (nodes[i] && codeHidden(it)) nodes[i].setAttribute("opacity", Number(nodes[i].getAttribute("opacity") ?? 1) * 0.2); });
  let clip = null;
  const shapes = [];
  for (let i = 0; i < list.length; i++) {
    const it = list[i];
    if (clip && it.depth > clip.until) clip = null;
    if (!interactive && hidden.has(at(it)) && !it.o.mask) continue;
    if (it.o.mask) {
      // A mask isn't drawn: what's above it, up to its `mask` depth, shows only inside its shape —
      // its area, whatever it's drawn with (an SVG mask: a clip path can't hold a drawing of groups).
      // Hidden (👁) or Masks off: what it masks is drawn whole.
      const id = await ensureDef(refOf(it.o), level, at(it));
      const g = el("g");
      if (id && S.masks && !hidden.has(at(it))) {
        const m = el("mask", { id: `mask${++defSeq}`, maskUnits: "userSpaceOnUse", x: -1e5, y: -1e5, width: 2e5, height: 2e5, style: "mask-type: alpha" });
        m.append(el("use", { href: `#${id}`, transform: transformOf(it.o), filter: "url(#maskSolid)" }));
        defs().append(m);
        g.setAttribute("mask", `url(#${m.id})`);
      }
      parent.append(g);
      clip = { g, until: it.o.mask };
      if (interactive) parent.append(el("g", { class: "item mask", "data-i": it.src ?? "", "data-depth": it.depth }));
      if (id && S.maskShapes) shapes.push(el("use", { href: `#${id}`, transform: transformOf(it.o), filter: "url(#maskShape)", class: "maskshape", "pointer-events": "none" }));
      continue;
    }
    let node = nodes[i];
    if (interactive) {
      const w = el("g", { class: "item" + (hidden.has(at(it)) ? " hidden" : "") + (codeHidden(it) ? " codehidden" : ""), "data-i": it.src ?? "", "data-depth": it.depth });
      w.append(node);
      node = w;
    }
    (clip ? clip.g : parent).append(node);
  }
  // Mask shapes over the list they mask in.
  parent.append(...shapes);
}

// --- Components: what the gapi's code draws -----------------------------------
//
// A Button, a Label, a Window… is, in the loader, a transparent
// `boundingBox_mc` and parameters (its clip actions, on(construct)): its
// class draws it in the game. Drawn here as that code would, from the same
// parameters and styles (DofusStylePackage): ank/gapi/controls/*.as.

// The loader's embedded fonts (Font1: Verdana; Font2: Verdana bold…).
const FONTS = { Font1: ["Verdana", 0, 0], Font2: ["Verdana", 1, 0], Font3: ["monospace", 0, 0], Font4: ["Verdana", 0, 1], Font5: ["Verdana", 1, 1], Font6: ["'Pirata One', fantasy", 0, 0] };
const hex = (n) => (typeof n === "number" && n >= 0 ? `#${n.toString(16).padStart(6, "0")}` : typeof n === "string" && /^0x[0-9a-f]+$/i.test(n) ? `#${n.slice(2).padStart(6, "0")}` : null);
const tint = (n) => ({ mult: [0, 0, 0, 1], add: [(n >> 16) & 255, (n >> 8) & 255, n & 255, 0] });
/** A style by name ("default", "": the class's own). */
function styleOf(name, cls) {
  const st = S.ui?.styles ?? {};
  return (name && name !== "default" && name !== "none" && st[name]) || st[cls] || {};
}
const exportRef = (name) => (name ? refOf({ export: name }) : null);

/** Each placement's parameters in a sprite (its clip actions), by frame and depth. */
const paramCache = new Map();
function paramsOf(file) {
  if (!file.startsWith("timeline/")) return Promise.resolve({});
  if (!paramCache.has(file)) paramCache.set(file, api(`/api/params?file=${encodeURIComponent(file)}`).catch(() => ({})).then((p) => (paramsKnown.set(file, p), p)));
  return paramCache.get(file);
}
const paramsKnown = new Map();

/**
 * A frame-1 line's depth as saved (its scripts' folders are named for it;
 * moved and not saved yet, its depth differs): the saved line placing the
 * same thing with the same name.
 */
const savedCache = new Map();
function savedDepth(t, o) {
  if (!t.saved) return o.depth;
  if (!savedCache.has(t.saved)) { savedCache.clear(); savedCache.set(t.saved, JSON.parse(t.saved)); }
  const ref = (x) => REF.map((k) => x[k] ?? "").join("|");
  const same = (savedCache.get(t.saved).frames?.[0]?.place ?? []).filter((x) => x.actions && ref(x) === ref(o));
  return (same.find((x) => x.depth === o.depth && x.name === o.name) ?? same.find((x) => x.name === o.name) ?? (same.length === 1 ? same[0] : null))?.depth ?? o.depth;
}
/** A line's parameters: its own ("params"), else its on(construct) script's (a base sprite's, as saved). */
function lineParams(t, o) {
  if (o.params) return o.params;
  if (!o.actions || !t.file.startsWith("timeline/")) return {};
  return paramsKnown.get(t.file)?.[1]?.[savedDepth(t, o)] ?? {};
}
/** What a component's class is, when what `ref` shows is one (its first frame holds a boundingBox_mc); null, or undefined while loading. */
function componentClass(ref) {
  if (ref?.kind !== "sprite" || !ref.file) return null;
  const json = knownJson(ref.file);
  if (json === undefined) return undefined;
  if (!json?.frames?.[0]?.place?.some((o) => o.name === "boundingBox_mc")) return null;
  const name = S.byId.get(ref.id)?.name;
  return (S.ui?.classes[name] ?? "").split(".").pop() || name;
}

/** A drawing's box in its own coordinates (measured once per def). */
const measured = new Map();
async function measure(ref) {
  const id = await ensureDef(ref, 1);
  if (!id) return null;
  if (!measured.has(id)) {
    const w = el("g", { visibility: "hidden" });
    w.append(el("use", { href: `#${id}` }));
    $("svg").append(w);
    const b = w.getBBox();
    w.remove();
    measured.set(id, b.width || b.height ? { x: b.x, y: b.y, width: b.width, height: b.height } : null);
  }
  return measured.get(id);
}
function boxUnder(m, b) {
  const xs = [], ys = [];
  for (const [x, y] of [[b.x, b.y], [b.x + b.width, b.y], [b.x, b.y + b.height], [b.x + b.width, b.y + b.height]]) { xs.push(m[0] * x + m[2] * y + m[4]); ys.push(m[1] * x + m[3] * y + m[5]); }
  return { x: Math.min(...xs), y: Math.min(...ys), width: Math.max(...xs) - Math.min(...xs), height: Math.max(...ys) - Math.min(...ys) };
}

/** A component: a sprite of the base whose first frame holds a boundingBox_mc. */
async function componentOf(ref) {
  if (ref?.kind !== "sprite" || !ref.file || !S.ui) return null;
  const json = knownJson(ref.file) ?? (await fileJsonKnown(ref.file));
  const bb = json?.frames?.[0]?.place?.find((o) => o.name === "boundingBox_mc");
  if (!bb) return null;
  const name = S.byId.get(ref.id)?.name ?? `sprite ${ref.id}`;
  return { name, cls: (S.ui.classes[name] ?? "").split(".").pop() || name, bb };
}

/**
 * A component drawn: its size is its bounding box's on screen (the game then
 * puts its scale back to 100%: a label's text isn't stretched), what it
 * draws, in its own pixels.
 */
async function drawComponent(o, comp, p, level) {
  const m = matrixOf(o), sx = Math.hypot(m[0], m[1]) || 1, sy = Math.hypot(m[2], m[3]) || 1;
  const g = el("g", { transform: `matrix(${m[0] / sx} ${m[1] / sx} ${m[2] / sy} ${m[3] / sy} ${m[4]} ${m[5]})` });
  const b = await measure(refOf(comp.bb));
  const box = b ? boxUnder(matrixOf(comp.bb), b) : { x: 0, y: 0, width: 100, height: 100 };
  const c = { w: box.width * sx, h: box.height * sy, p, o, comp, level, name: o.name ?? comp.name };
  // What's under it shows through where it draws nothing; its own area stays clickable.
  g.append(el("rect", { width: c.w, height: c.h, fill: "transparent" }));
  await (COMPONENTS[comp.cls] ?? COMPONENTS[comp.name] ?? genericComponent)(g, c);
  return g;
}

/** Lines of a wrapped text field, measured in its font. */
const measureCtx = document.createElement("canvas").getContext("2d");
function wrapLines(text, width, font) {
  measureCtx.font = font;
  const out = [];
  for (const para of text.split(/\r?\n|\r/)) {
    let line = "";
    for (const word of para.split(" ")) {
      const next = line ? `${line} ${word}` : word;
      if (line && measureCtx.measureText(next).width > width) { out.push(line); line = word; } else line = next;
    }
    out.push(line);
  }
  return out;
}
/** A text field's text: its box, its style (font, size, colour, alignment); `wrap`: on several lines. */
function drawLabel(g, { x = 0, y = 0, w, h, text, font, size = 12, color = 0, align = "left", bold, italic, dim, wrap }) {
  if (!text || w <= 0 || h <= 0) return;
  const box = el("svg", { x, y, width: w, height: h, overflow: "hidden" });
  const [family, b, i] = FONTS[font] ?? [!font || font === "_sans" ? "Verdana, sans-serif" : `${font}, Verdana, sans-serif`, 0, 0];
  const weight = b || bold ? "bold" : null, style = i || italic ? "italic" : null;
  const anchor = { center: "middle", right: "end" }[align] ?? "start";
  let ax = anchor === "middle" ? w / 2 : anchor === "end" ? w - 2 : 2;
  const t = el("text", { x: ax, y: 2 + size, "font-family": family, "font-size": size, "font-weight": weight, "font-style": style, fill: hex(color) ?? "#000000", "text-anchor": anchor, opacity: dim ? 0.55 : null });
  const plain = String(text).replace(/<br\s*\/?>/gi, "\n").replace(/<[^>]*>/g, "").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&amp;/g, "&");
  const css = `${style ?? ""} ${weight ?? ""} ${size}px ${family}`;
  const lines = wrap ? wrapLines(plain, w - 4, css) : [plain.replace(/\s*[\r\n]+\s*/g, " ")];
  // Wider than its box: its start shows (as Flash cuts it), not its end.
  if (!wrap && anchor !== "start") { measureCtx.font = css; if (measureCtx.measureText(lines[0]).width > w - 4) { t.setAttribute("text-anchor", "start"); t.setAttribute("x", 2); ax = 2; } }
  lines.slice(0, Math.ceil(h / size) + 1).forEach((line, k) => {
    const span = el("tspan", { x: ax, dy: k ? size * 1.2 : 0 });
    span.textContent = line;
    t.append(span);
  });
  box.append(t);
  g.append(box);
}
/**
 * The text shown: its own; else what the class puts there (the game's text
 * with a lang file, else its key: ‹SELECT›); else the instance's name, dimmed.
 */
function placeholderText(c, text) {
  if (text) return { text };
  if (c.p.code?.text) return { text: c.p.code.text };
  return { text: `‹${c.p.code?.key ?? c.name}›`, dim: true };
}
function dashed(g, w, h, color = "#ffffff") {
  g.append(el("rect", { width: w, height: h, fill: "none", stroke: color, "stroke-opacity": 0.35, "stroke-dasharray": "3 2", "vector-effect": "non-scaling-stroke" }));
}
/** UIBasicComponent.drawBorder: a bevelled frame. */
function bevel(g, w, h) {
  const line = (d, c) => g.append(el("path", { d, fill: "none", stroke: c, "stroke-opacity": 0.5, "vector-effect": "non-scaling-stroke" }));
  line(`M0 0H${w}`, "#6f7777"); line(`M${w} 0V${h}`, "#919a99"); line(`M${w} ${h}H0`, "#d5dddd"); line(`M0 ${h}V0`, "#919a99");
  line(`M1 1H${w - 1}`, "#cacccc"); line(`M${w - 1} 1V${h - 1}`, "#d5dddd"); line(`M${w - 1} ${h - 1}H1`, "#eeeeee"); line(`M1 ${h - 1}V1`, "#d5dddd");
}
/** drawRoundRect: corners (a number or { tl, tr, br, bl }), a colour or a gradient (colours, alphas, ratios). */
function roundRect(g, x, y, w, h, r, color, alpha = 100, rot = 0, ratios) {
  if (w <= 0 || h <= 0 || color === undefined) return;
  const k = typeof r === "object" ? r : { tl: r ?? 0, tr: r ?? 0, br: r ?? 0, bl: r ?? 0 };
  const [tl, tr, br, bl] = [k.tl, k.tr, k.br, k.bl].map((v) => Math.max(0, Math.min(v ?? 0, w / 2, h / 2)));
  const d = `M${x + tl} ${y}H${x + w - tr}Q${x + w} ${y} ${x + w} ${y + tr}V${y + h - br}Q${x + w} ${y + h} ${x + w - br} ${y + h}H${x + bl}Q${x} ${y + h} ${x} ${y + h - bl}V${y + tl}Q${x} ${y} ${x + tl} ${y}Z`;
  let fill = hex(color), opacity = (typeof alpha === "number" ? alpha : 100) / 100;
  if (Array.isArray(color)) {
    const id = `grad${++defSeq}`, gr = el("linearGradient", { id, gradientTransform: `rotate(${rot || 90} .5 .5)` });
    color.forEach((c, i) => gr.append(el("stop", { offset: `${((ratios?.[i] ?? (i * 255) / Math.max(1, color.length - 1)) / 255) * 100}%`, "stop-color": hex(c), "stop-opacity": (Array.isArray(alpha) ? alpha[i] ?? 100 : 100) / 100 })));
    defs().append(gr);
    fill = `url(#${id})`; opacity = 1;
  }
  g.append(el("path", { d, fill: fill ?? "none", "fill-opacity": opacity }));
}

/** An export drawn in a box: "fit" (a Loader's scaleContent), "center" (its centre there), "middle" (an icon's box centred), "origin". */
async function drawExport(g, name, w, h, mode, level) {
  const ref = exportRef(name);
  if (!ref || ref.kind === "missing") return false;
  const id = await ensureDef(ref, level + 1);
  if (!id) return false;
  const b = await measure(ref);
  let t = "";
  if (b && mode === "fit") { const k = Math.min(w / b.width, h / b.height); t = `translate(${(w - b.width * k) / 2 - b.x * k} ${(h - b.height * k) / 2 - b.y * k}) scale(${k})`; }
  else if (b && mode === "middle") t = `translate(${(w - b.width) / 2 - b.x} ${(h - b.height) / 2 - b.y})`;
  else if (mode === "center") t = `translate(${w / 2} ${h / 2})`;
  else if (b && mode === "stretch") t = `translate(${-b.x * (w / b.width)} ${-b.y * (h / b.height)}) scale(${w / b.width} ${h / b.height})`;
  g.append(el("use", { href: `#${id}`, transform: t || null }));
  return true;
}

/**
 * A button's background (ButtonBackground.setSize): left_mc and right_mc as
 * high as the button, keeping their ratio, middle_mc stretched between; each
 * part's clips coloured by the style (bg_mc: bgcolor…). Another background:
 * as it is (it has no setSize).
 */
async function drawSkin(g, name, w, h, st, suffix, level) {
  const ref = exportRef(name);
  if (!ref?.file) return;
  if (!(S.ui.classes[name] ?? "").endsWith("ButtonBackground")) { await drawExport(g, name, w, h, "origin", level); return; }
  const place = (knownJson(ref.file) ?? (await fileJsonKnown(ref.file)))?.frames?.[0]?.place ?? [];
  const part = async (n) => { const o = place.find((x) => x.name === n); const b = o && (await measure(refOf(o))); return b ? { o, b, ys: h / b.height } : null; };
  const [L, M, R] = await Promise.all([part("left_mc"), part("middle_mc"), part("right_mc")]);
  const lw = L ? L.b.width * L.ys : 0, rw = R ? R.b.width * R.ys : 0;
  const slice = async (pt, x, xs) => {
    if (!pt) return;
    const sg = el("g", { transform: `translate(${x} 0) scale(${xs} ${pt.ys})` });
    const r = refOf(pt.o), json = hasChildren(r) && (knownJson(r.file) ?? (await fileJsonKnown(r.file)));
    if (!json) { const id = await ensureDef(r, level + 1); if (id) sg.append(el("use", { href: `#${id}` })); }
    else await drawList(sg, childList(r, json).map((it) => {
      // Color.setRGB: the clip in that colour (-1: hidden).
      const col = st[`${(it.o.name ?? "").split("_")[0]}${suffix}`];
      return typeof col !== "number" ? it : { ...it, o: col === -1 ? { ...it.o, alpha: 0 } : { ...it.o, color: tint(col) } };
    }), level + 2, false, null, r.file);
    g.append(sg);
  };
  await slice(L, 0, (lw + 0.5) / (L?.b.width || 1));
  await slice(M, lw, (w - lw - rw + 0.5) / (M?.b.width || 1));
  await slice(R, w - rw, R?.ys ?? 1);
}

const labelStyle = (st, c, text, box) => ({ ...box, ...placeholderText(c, text), font: st.labelfont, size: st.labelsize, color: st.labelcolor, align: st.labelalign, bold: st.labelbold, italic: st.labelitalic });
const COMPONENTS = {
  async Button(g, c) {
    const st = styleOf(c.p.styleName, "Button");
    const bg = c.p.backgroundUp ?? "ButtonNormalUp";
    if (bg !== "none") await drawSkin(g, bg, c.w, c.h, st, "color", c.level);
    if (c.p.icon) await drawExport(g, c.p.icon, c.w, c.h, "middle", c.level);
    if (c.p.label || c.p.code) {
      const ls = styleOf(st.labelupstyle, "Label"), th = (ls.labelsize ?? 12) * 1.15;
      drawLabel(g, labelStyle(ls, c, c.p.code && !c.p.code.code ? null : c.p.label, { y: (c.h - th) / 2 - 4, w: c.w, h: th + 6 }));
    }
  },
  Label(g, c) {
    drawLabel(g, labelStyle(styleOf(c.p.styleName, "Label"), c, c.p.text, { y: 1, w: c.w, h: c.h - 1, wrap: c.p.multiline || c.p.wordWrap }));
  },
  TextInput(g, c) {
    dashed(g, c.w, c.h);
    drawLabel(g, labelStyle(styleOf(c.p.styleName, "TextInput"), c, c.p.text, { y: 1, w: c.w, h: c.h - 1 }));
  },
  TextArea(g, c) {
    const st = styleOf(c.p.styleName, "TextArea");
    if (c.p.border) bevel(g, c.w, c.h); else dashed(g, c.w, c.h);
    drawLabel(g, { x: 1, y: 1, w: c.w - 2, h: c.h - 2, ...placeholderText(c, c.p.text), font: st.font, size: st.size, color: st.color ?? 0, align: st.align, bold: st.bold, italic: st.italic, wrap: c.p.wordWrap !== false });
  },
  Window(g, c) {
    const st = styleOf(c.p.styleName, "Window"), bw = st.borderwidth ?? 0, r = st.cornerradius ?? 0;
    const inner = typeof r === "object" ? { tl: r.tl - bw, tr: r.tr - bw, br: r.bl - bw, bl: r.bl - bw } : r - bw;
    roundRect(g, 0, 0, c.w, c.h, r, st.bordercolor);
    roundRect(g, bw, bw, c.w - 2 * bw, c.h - 2 * bw, inner, st.backgroundcolor, st.backgroundalpha ?? 100, st.backgroundrotation, st.backgroundratio);
    if (st.displaytitle !== false) {
      roundRect(g, bw, bw, c.w - 2 * bw, st.titleheight ?? 0, typeof r === "object" ? { tl: r.tl - bw, tr: r.tr - bw, br: 0, bl: 0 } : { tl: r - bw, tr: r - bw, br: 0, bl: 0 }, st.titlecolor);
      drawLabel(g, labelStyle(styleOf(st.titlestyle, "Label"), c, c.p.title, { x: 5, y: 5, w: c.w - 5, h: 25 }));
    }
    if (c.p.contentPath && c.p.contentPath !== "none") return drawExport(g, c.p.contentPath, c.w, c.h, "origin", c.level);
  },
  async Container(g, c) {
    const bg = c.p.backgroundRenderer || "DefaultBackground";
    if (bg === "DefaultBackground") bevel(g, c.w, c.h); else await drawExport(g, bg, c.w, c.h, "stretch", c.level);
    const m = c.p.margin ?? 2, inner = el("g", { transform: `translate(${m} ${m})` });
    g.append(inner);
    if (c.p.contentPath) await drawExport(inner, c.p.contentPath, c.w - 2 * m, c.h - 2 * m, "fit", c.level);
  },
  async ContainerGrid(g, c) {
    const st = styleOf(c.p.styleName, "ContainerGrid"), cols = c.p.visibleColumnCount || 1, rows = c.p.visibleRowCount || 1;
    const cw = c.w / cols, ch = c.h / rows, bg = st.containerbackground ?? "DefaultBackground";
    for (let i = 0; i < rows; i++) for (let j = 0; j < cols; j++) {
      const cell = el("g", { transform: `translate(${j * cw} ${i * ch})` });
      if (bg === "DefaultBackground" || !(await drawExport(cell, bg, cw, ch, "stretch", c.level))) bevel(cell, cw, ch);
      g.append(cell);
    }
  },
  async Loader(g, c) {
    const path = c.p.contentPath;
    if (path && (await drawExport(g, path, c.w, c.h, c.p.scaleContent ? "fit" : c.p.centerContent ? "center" : "origin", c.level))) return;
    dashed(g, c.w, c.h, "#8ad");
    drawLabel(g, { w: c.w, h: Math.min(c.h, 16), size: 9, color: 0x88aadd, align: "center", text: path ? path.split("/").pop() : `‹${c.name}›`, dim: true });
  },
  List(g, c) {
    const st = styleOf(c.p.styleName, "List"), rh = c.p.rowHeight || 20, cols = [].concat(st.cellbgcolor ?? []);
    for (let y = 0, i = 0; y < c.h; y += rh, i++) if (cols.length && cols[i % cols.length] >= 0) roundRect(g, 0, y, c.w, Math.min(rh, c.h - y), 0, cols[i % cols.length]);
    dashed(g, c.w, c.h);
  },
  /** ComboBox.arrange: its background (a ButtonBackground) at its size, its open button (a Button), its label between. */
  async ComboBox(g, c) {
    const st = styleOf(c.p.styleName, "ComboBox"), bw = c.p.buttonWidth ?? 20, left = !!c.p.isButtonLeft;
    await drawSkin(g, c.p.background || "ComboBoxNormal", c.w, c.h, st, "color", c.level);
    const btn = el("g", { transform: `translate(${left ? 0 : c.w - bw} 0)` });
    g.append(btn);
    await COMPONENTS.Button(btn, { ...c, w: bw, h: c.h, p: { styleName: st.buttonstyle, icon: c.p.buttonIcon ?? "", backgroundUp: c.p.buttonBackgroundUp ?? "ButtonNormalUp" } });
    const lm = c.p.labelLeftMargin ?? 4, rm = c.p.labelRightMargin ?? 0, tm = c.p.labelTopMargin ?? 0;
    drawLabel(g, labelStyle(styleOf(st.labelstyle, "Label"), c, null, { x: (left ? bw : 0) + lm, y: tm, w: Math.max(c.w - bw - lm - rm, 0), h: c.h - tm - (c.p.labelBottomMargin ?? 0) }));
  },
  /** A title bar (titleHeight, titlebgcolor), then rows in its list's colours. */
  DataGrid(g, c) {
    const st = styleOf(c.p.styleName, "DataGrid"), th = c.p.titleHeight ?? 20;
    if (hex(st.titlebgcolor)) roundRect(g, 0, 0, c.w, th, 0, typeof st.titlebgcolor === "string" ? parseInt(st.titlebgcolor, 16) : st.titlebgcolor);
    const rows = el("g", { transform: `translate(0 ${th})` });
    g.append(rows);
    COMPONENTS.List(rows, { ...c, h: c.h - th, p: { ...c.p, styleName: st.liststyle } });
  },
  ProgressBar(g, c) {
    const st = styleOf(c.p.styleName, "ProgressBar"), min = c.p.minimum ?? 0, max = c.p.maximum ?? 100;
    const k = max > min ? Math.max(0, Math.min(1, ((c.p.value ?? (min + max) / 2) - min) / (max - min))) : 0.5;
    roundRect(g, 0, 0, c.w, c.h, 0, st.bgcolor ?? 0x514a3c);
    roundRect(g, 0, 0, c.w * (k || 0.5), c.h, 0, st.upcolor ?? 0xff6600);
  },
  BackgroundHidder(g, c) {
    const st = styleOf(c.p.styleName, "BackgroundHidder");
    roundRect(g, 0, 0, c.w, c.h, 0, st.backgroundcolor ?? 0, st.backgroundalpha ?? 10);
  },
  StylizedRectangle(g, c) {
    const st = styleOf(c.p.styleName, "StylizedRectangle");
    roundRect(g, 0, 0, c.w, c.h, st.cornerradius ?? 0, st.bgcolor ?? 0xffffff, st.alpha ?? 100);
  },
};
COMPONENTS.SpriteLoader = COMPONENTS.Loader;
/** Any other component: its box and its class. */
function genericComponent(g, c) {
  dashed(g, c.w, c.h, "#e0c080");
  drawLabel(g, { w: c.w, h: Math.min(c.h, 16), size: 9, color: 0xe0c080, text: `${c.comp.cls} ‹${c.name}›`, dim: true });
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
  else if (d) await drawList(fresh, currentList(), 0, true, "", d.file);
  if (seq !== drawSeq) return;
  $("content").replaceWith(fresh);
  fresh.id = "content";
  $("empty").hidden = !!d;
  const twice = d && d.kind === "sprite" ? currentList().filter((it) => it.ignored) : [];
  if (twice.length) status(`depth ${[...new Set(twice.map((it) => it.depth))].join(", ")}: two lines — the game shows the first, ignores the other (red in the layers): move or remove one (it can't be saved so)`, "bad");
  // An SVG element has no .hidden property: the attribute itself.
  $("screenFrame").toggleAttribute("hidden", !d?.screen);
  $("screenBg").toggleAttribute("hidden", !d?.screen);
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
  return d?.nested ? lineAt(d.nested, d) : null;
}
/** Any line of the tree by its path ("/65" on the first level: `owner` null, `tab` the open one). */
function lineAt(path, d = D()) {
  const depths = path.split("/").slice(1).map(Number);
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
  if (!owner) {
    const o = it.src === null ? it.o : items(d)[it.src];
    return { key: path, it, o, chain, owner, tab: d, editable: it.src !== null && !!o && editable() };
  }
  const tab = S.tabs.find((t) => t.file === owner.file);
  if (!tab) return null;
  const o = it.src === null ? it.o : items(tab)[it.src];
  return { key: path, it, o, chain, owner, tab, editable: it.src !== null && !!o };
}

/**
 * The selection: the line in the inspector (`sel`: a first-level line's
 * index, or `nested`: a path) and the others picked with it (`more`: paths,
 * Ctrl/Shift+click). Paths, the inspector's line first.
 */
function selKeys(d = D()) {
  if (!d) return [];
  const main = d.nested ?? (d.sel !== null && items(d)?.[d.sel] ? `/${items(d)[d.sel].depth}` : null);
  return [...new Set([main, ...(d.more ?? [])].filter(Boolean))];
}
/**
 * The lines selected, each once: what's inside another one selected moves
 * with it, and one definition seen through two placements is one line.
 */
function selLines(d = D()) {
  const keys = selKeys(d), seen = new Set();
  return keys.filter((k) => !keys.some((p) => k.startsWith(`${p}/`))).map((k) => lineAt(k, d)).filter((L) => L && !seen.has(L.o) && seen.add(L.o));
}
/** The selection set (without drawing it): paths, `main` in the inspector (the last picked). */
function assignSel(d, keys, main = keys.at(-1)) {
  d.sel = null; d.nested = null;
  d.more = keys.filter((k) => k !== main);
  if (main?.lastIndexOf("/") === 0) d.sel = currentList().find((x) => `/${x.depth}` === main)?.src ?? null;
  else if (main) d.nested = main;
  for (const k of keys) openTo(d, k);
}
function setSelection(d, keys, main) {
  assignSel(d, keys, main);
  drawSelection(); renderLayers(); renderInspector();
}
/** Ctrl+click: a line added to the selection, or taken out of it. */
async function toggleSel(key, ownerFile) {
  const d = D();
  if (ownerFile) await tabFor(ownerFile);
  const keys = selKeys(d);
  setSelection(d, keys.includes(key) ? keys.filter((k) => k !== key) : [...keys, key]);
}
/** Shift+click in the layers: the lines of one list from the inspector's line to this one, added. */
async function rangeTo(key, ownerFile) {
  const d = D(), main = selKeys(d)[0], up = (k) => k.slice(0, k.lastIndexOf("/"));
  if (!main || up(main) !== up(key)) return toggleSel(key, ownerFile);
  if (ownerFile) await tabFor(ownerFile);
  const list = [...$("layers").querySelectorAll(".layer")].map((r) => r.dataset.key).filter((k) => up(k) === up(key));
  const [a, b] = [list.indexOf(main), list.indexOf(key)].sort((m, n) => m - n);
  setSelection(d, [...selKeys(d), ...list.slice(a, b + 1)], main);
}
/** Ctrl+A: every line of the list the inspector's line is in (the first level's if none). */
function selectAll() {
  const d = D();
  if (!d || d.kind === "text") return;
  const main = selKeys(d)[0], up = main && main.lastIndexOf("/") > 0 ? main.slice(0, main.lastIndexOf("/")) : "";
  const at = along(up).at(-1), json = up ? knownJson(at.file) : null;
  const list = up ? (json ? childList({ kind: kindOf(at.file) }, json) : []) : currentList();
  const keys = list.filter((it) => it.src !== null).map((it) => `${up}/${it.depth}`);
  if (keys.length) setSelection(d, keys, keys.includes(main) ? main : keys.at(-1));
}
async function selectNested(path, ownerFile) {
  const d = D();
  await tabFor(ownerFile);
  d.sel = null; d.nested = path; d.more = [];
  openTo(d, path);
  drawSelection(); renderLayers(); renderInspector();
  $("layers").querySelector(".layer.main")?.scrollIntoView({ block: "nearest" });
}
/** Escape: the inspector's line alone, then what holds it (one level up), then nothing. */
function selectUp() {
  const d = D();
  if (!d) return;
  if (d.more?.length) { setSelection(d, selKeys(d).slice(0, 1)); return; }
  if (!d.nested) { select(null); return; }
  const up = d.nested.slice(0, d.nested.lastIndexOf("/"));
  if (up.lastIndexOf("/") === 0) {
    const it = currentList().find((x) => `/${x.depth}` === up);
    select(it?.src ?? null);
  } else selectNested(up, along(up.slice(0, up.lastIndexOf("/"))).at(-1).file);
}
/** The tree unfolded down to `path` ("/65/13": 65 opens). */
function openTo(d, path) {
  const parts = path.split("/");
  for (let k = 2; k < parts.length; k++) d.open.add(parts.slice(0, k).join("/"));
}
/** Where a line is drawn (`chain`: its list's place on screen), in the sprite's coordinates; null if empty. */
async function boxOf(o, chain, path) {
  const id = await ensureDef(refOf(o), 1, path);
  if (!id) return null;
  const wrap = el("g", { visibility: "hidden" }), g = el("g", { transform: `matrix(${chain.join(" ")})` });
  g.append(el("use", { href: `#${id}`, transform: transformOf(o) }));
  wrap.append(g); $("overlay").append(wrap);
  const bb = wrap.getBBox();
  wrap.remove();
  return bb.width || bb.height ? bb : null;
}
/**
 * The lines under point `p`, from the first level's (depth `depth`: the
 * graphic clicked) down: in each placed sprite, the smallest box holding
 * `p` (boxes: an approximation, good enough to pick a line).
 */
async function linesAt(p, depth, area = Infinity) {
  const d = D(), top = currentList().find((it) => it.depth === depth);
  if (!top || top.o.mask) return [];
  const out = [{ path: `/${depth}`, it: top, chain: ID, owner: null, area }];
  while (out.length < 12) {
    const cur = out[out.length - 1], ref = refOf(cur.it.o);
    if (!hasChildren(ref)) break;
    const json = knownJson(ref.file) ?? (await fileJsonKnown(ref.file));
    if (!json) break;
    const chain = multiply(cur.chain, matrixOf(cur.it.o));
    let best = null;
    for (const it of childList(ref, json)) {
      const path = `${cur.path}/${it.depth}`;
      if (it.o.mask || d.hidden.has(path)) continue;
      const bb = await boxOf(it.o, chain, path);
      if (bb && p.x >= bb.x && p.x <= bb.x + bb.width && p.y >= bb.y && p.y <= bb.y + bb.height && (!best || bb.width * bb.height < best.area)) best = { it, path, area: bb.width * bb.height };
    }
    if (!best) break;
    out.push({ path: best.path, it: best.it, chain, owner: ref.file, area: best.area });
  }
  return out;
}
/**
 * The first level's graphics under the pointer, top first (the layers'
 * order) — what code hides or uses as a mask after the rest (faded: a
 * placer, `_mcMask`), so it doesn't catch clicks meant for what shows.
 */
function graphicsAt(e) {
  const seen = new Set();
  const under = document.elementsFromPoint(e.clientX, e.clientY).map((n) => n.closest?.("#content .item")).filter((n) => n && n.dataset.i !== "" && !seen.has(n) && seen.add(n));
  const hid = (n) => n.classList.contains("codehidden");
  return [...under.filter((n) => !hid(n)), ...under.filter(hid)];
}
/**
 * Selects a line under the pointer: the deepest (`deepest`: of every graphic
 * there, the smallest — not a transparent text area over it), or one level
 * below what's selected.
 */
async function selectAt(e, deepest) {
  const d = D(), h = await hitAt(e, deepest);
  if (D() !== d || !h) return null;
  if (!h.owner) { if (h.it.src !== null) select(h.it.src); return null; }
  await selectNested(h.path, h.owner);
  return nestedInfo();
}
/** The line `selectAt` picks: its path, the definition it's in (`owner`, null on the first level). */
async function hitAt(e, deepest) {
  const d = D(), p = toSprite(e), under = graphicsAt(e);
  if (!under.length) return null;
  const cur = d.nested ?? (d.sel !== null && items()?.[d.sel] ? `/${items()[d.sel].depth}` : null);
  let h;
  if (deepest) {
    for (const g of under) {
      const bb = g.getBBox(), hits = await linesAt(p, Number(g.dataset.depth), bb.width * bb.height);
      const last = hits[hits.length - 1];
      if (last && (!h || last.area < h.area)) h = last;
    }
  } else {
    const g = under.find((x) => cur?.startsWith(`/${x.dataset.depth}/`) || cur === `/${x.dataset.depth}`) ?? under[0];
    const hits = await linesAt(p, Number(g.dataset.depth));
    h = hits[Math.min(hits.findIndex((x) => x.path === cur) + 1, hits.length - 1)];
  }
  return D() === d ? h ?? null : null;
}
/** A move on screen (dx, dy) in the coordinates the nested line is placed in. */
function toParent(n, dx, dy) {
  const [a, b, c, dd] = invert(n.chain);
  return [a * dx + c * dy, b * dx + dd * dy];
}


/**
 * Outlines: every line's box and name (its instance name, or what it
 * places) — the first level's, and the lines next to a nested one selected.
 */
let outlineSeq = 0;
async function drawOutlines() {
  const seq = ++outlineSeq, d = D(), g = el("g", { id: "outlineLayer", "pointer-events": "none" });
  if (S.outlines && d && d.kind !== "text") {
    const boxes = [];
    for (const node of $("content").querySelectorAll(":scope > .item, :scope > g > .item")) {
      if (node.classList.contains("mask") || node.classList.contains("hidden")) continue;
      const it = currentList().find((x) => String(x.depth) === node.dataset.depth);
      const bb = it && node.getBBox();
      if (bb && (bb.width || bb.height)) boxes.push([bb, it.o]);
    }
    if (d.nested) {
      const up = d.nested.slice(0, d.nested.lastIndexOf("/")), at = along(up).at(-1), json = knownJson(at.file);
      if (json) for (const it of childList({ kind: kindOf(at.file) }, json)) {
        const bb = !it.o.mask && (await boxOf(it.o, at.chain, `${up}/${it.depth}`));
        if (bb) boxes.push([bb, it.o, true]);
      }
    }
    if (seq !== outlineSeq) return;
    const k = 1 / view.k;
    for (const [bb, o, inner] of boxes) {
      const color = inner ? "#e0a040" : "#5fc8e0";
      g.append(el("rect", { x: bb.x, y: bb.y, width: bb.width, height: bb.height, fill: "none", stroke: color, "stroke-opacity": 0.8, "stroke-width": 1, "vector-effect": "non-scaling-stroke" }));
      const t = el("text", { x: bb.x + 2 * k, y: bb.y + 10 * k, "font-size": 10 * k, "font-family": "Verdana, sans-serif", fill: color, stroke: "#000", "stroke-width": 2.5 * k, "paint-order": "stroke", "stroke-opacity": 0.8 });
      t.textContent = o.name ?? describe(o);
      g.append(t);
    }
  }
  if (seq === outlineSeq) $("outlineLayer").replaceWith(g);
}

/**
 * Each line selected: its box (dashed: inside a placed sprite, measured
 * through its parents' placements) and its origin. The boxes are kept
 * (`boxes`): dragging inside one moves the selection.
 */
let selSeq = 0;
function drawSelection() {
  drawOutlines();
  const ov = $("overlay");
  ov.textContent = "";
  const d = D();
  if (!d) return;
  const seq = ++selSeq;
  d.boxes = [];
  selKeys(d).forEach(async (key, k) => {
    const L = lineAt(key, d);
    if (!L) return;
    let bb = null;
    // A mask's box: its shape's (it isn't drawn). Measured boxes are dragged by their area (`byBox`).
    const mask = !!L.o.mask;
    if (!L.owner && !mask) {
      const node = L.it.src !== null && $("content").querySelector(`.item[data-i="${L.it.src}"]`);
      if (node) bb = node.getBBox();
    } else {
      bb = await boxOf(L.o, L.chain, key);
      if (seq !== selSeq || D() !== d) return;
    }
    if (bb) {
      d.boxes.push({ key, bb, byBox: !!L.owner || mask });
      ov.append(el("rect", { x: bb.x, y: bb.y, width: bb.width, height: bb.height, fill: "none", stroke: mask ? "#ff4fd8" : "#e0a040", "stroke-width": k ? 1 : 1.5, "stroke-dasharray": L.owner || mask ? "5 3" : undefined, "vector-effect": "non-scaling-stroke" }));
    }
    // A mask selected: its shape, even with Mask shapes off.
    if (mask && !S.maskShapes) {
      const id = await ensureDef(refOf(L.o), 1, key);
      if (id && seq === selSeq && D() === d) ov.append(el("use", { href: `#${id}`, transform: `matrix(${multiply(L.chain, matrixOf(L.o)).join(" ")})`, filter: "url(#maskShape)" }));
    }
    const [, , , , x, y] = multiply(L.chain, matrixOf(L.o)), r = 6 / view.k;
    ov.append(el("path", { d: `M${x - r} ${y}H${x + r}M${x} ${y - r}V${y + r}`, stroke: "#6aa8e8", "stroke-width": 1.5, "vector-effect": "non-scaling-stroke" }));
  });
}
const inBox = (p, b) => p.x >= b.x && p.x <= b.x + b.width && p.y >= b.y && p.y <= b.y + b.height;

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
/**
 * Before a change to tabs `ts` (the open one, definitions edited from it):
 * one step of undo, in the open tab, takes them all back.
 */
function snapshot(...ts) {
  D().undo.push(undoEntry(ts));
  D().redo = [];
}
/** Tabs `ts` as they are (none: the open one), and the selection: one step of undo. */
function undoEntry(ts) {
  if (!ts.length) ts = [D()];
  return { list: [...new Set(ts)].map((t) => ({ file: t.file, json: JSON.stringify(t.json) })), at: { sel: D().sel, nested: D().nested, more: D().more } };
}
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
    undo: [], redo: [], sel: null, more: [], frame: 1, state: "up", hidden: new Set(), open: new Set(),
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
  if (select !== undefined) { D().sel = select; D().more = []; D().nested = null; drawSelection(); renderLayers(); renderInspector(); }
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
  const d = D(), keys = selKeys(d), many = keys.length > 1;
  $("up").disabled = $("down").disabled = !d || d.sel === null || many || !editable();
  $("remove").disabled = !d || !selLines(d).some((L) => L.editable);
  $("group").disabled = !d || !keys.length || keys.some((k) => k.lastIndexOf("/") > 0) || d.sel === null || !editable() || d.kind !== "sprite";
  const selRef = d && d.sel !== null ? refOf(items()?.[d.sel] ?? {}) : null;
  $("ungroup").disabled = $("group").disabled || many || !(selRef?.kind === "sprite" || selRef?.kind === "freshSprite");
  rowLocs.clear();
  if (!d || d.kind === "text") { box.append(html("div", { className: "hint" }, d ? "A text: edit it in the inspector." : "")); return; }
  // Top first, as drawn; a placed sprite or button unfolds into its own list (its definition: shared by every placement).
  const top0 = (level) => level === 0;
  // Each row knows its list: whose lines (`file`, `kind`) and where that list is on screen (`chain`).
  const rows = (list, level, path, owner, chain) => {
    const loc0File = top0(level) ? d.file : owner.file;
    if (!paramsKnown.has(loc0File) && loc0File.startsWith("timeline/")) paramsOf(loc0File).then(() => renderLayers());
    // Which mask covers each line (a mask: the depths above it, up to its `mask`).
    const maskOf = new Map(), masks = new Map();
    let cur = null;
    for (const it of list) {
      if (cur && it.depth > cur.o.mask) cur = null;
      if (it.o.mask) { cur = it; masks.set(it, []); continue; }
      if (cur) { maskOf.set(it, cur); masks.get(cur).push(it); }
    }
    for (const it of list.slice().reverse()) {
      const key = `${path}/${it.depth}`;
      const ref = refOf(it.o);
      const kids = hasChildren(ref);
      const top = level === 0;
      const row = html("div", { className: "layer" + (top ? "" : " child") + (it.ignored ? " ignored" : "") + (key === keys[0] && (!top || it.src === d.sel) ? " on main" : keys.includes(key) && it.src !== null ? " on" : "") });
      if (it.ignored) row.title = `Depth ${it.depth} already holds something: the game ignores this line (not drawn) — drag it elsewhere, ↑ ↓, or remove one of them`;
      if (maskOf.has(it)) { row.classList.add("masked"); row.title = `Masked by depth ${maskOf.get(it).depth} (${describe(maskOf.get(it).o)}): shows only inside its shape`; }
      row.style.paddingLeft = `${6 + level * 14}px`;
      row.dataset.key = key;
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
      if (it.o.mask) {
        const under = masks.get(it) ?? [];
        row.append(html("span", { className: "mask", title: `A mask: not drawn — the lines above it up to depth ${it.o.mask} show only inside its shape (${under.map((x) => x.o.name ?? describe(x.o)).join(", ") || "none now"}). "mask" in its JSON is that last depth; 👁 here: drawn unmasked while you work.` }, `◩ ${under.length ? (under.length > 1 ? `${under[0].depth}–${under.at(-1).depth}` : under[0].depth) : "∅"}`));
      }
      const code = paramsKnown.get(loc0File);
      const said = it.o.name && code?.texts?.[it.o.name];
      if (said && !said.code) row.append(html("span", { className: "said", title: `Set by code: ${said.key}` }, `«${said.text ?? said.key}»`));
      if (it.o.name && code?.hidden?.includes(it.o.name)) row.append(html("span", { className: "codehid", title: "Hidden by its class as it starts (_visible = false): drawn faded" }, "⊘"));
      if (it.o.name) row.append(html("span", { className: "name" }, it.o.name));
      const movable = it.src !== null && (!top || editable());
      const loc = { key, it, ref, top, chain, movable, file: top ? d.file : owner.file, kind: top ? d.kind : owner.kind, label: top ? d.title : owner.label };
      rowLocs.set(key, loc);
      // Ctrl+click: added to the selection (or taken out); Shift+click: the lines between, in one list.
      row.onclick = (e) => {
        if (it.src === null) return;
        if (e.ctrlKey || e.metaKey) toggleSel(key, top ? null : owner.file);
        else if (e.shiftKey) rangeTo(key, top ? null : owner.file);
        else if (top) select(it.src);
        else selectNested(key, owner.file);
      };
      if (!top) {
        row.title = `In ${owner.label}'s definition: click to select it here (drag it anywhere in the tree), double-click to open it there`;
        row.ondblclick = (e) => { if (!e.ctrlKey && !e.metaKey && !e.shiftKey) open(owner.file, { select: it.src ?? undefined }); };
      }
      dragRow(row, loc, movable);
      box.append(row);
      if (kids && d.open.has(key)) {
        const json = knownJson(ref.file);
        if (json) rows(childList(ref, json), level + 1, key, { file: ref.file, kind: ref.kind === "button" ? "button" : "sprite", label: describe(it.o) }, multiply(chain, matrixOf(it.o)));
        else box.append(html("div", { className: "hint" }, "…"));
      }
    }
  };
  rows(currentList(), 0, "", null, ID);
}

/**
 * A layer dragged onto another, at any level of the tree: its top or bottom
 * edge puts it above or below (in that line's list), its middle inside (a
 * sprite) or grouped with it (anything else, both on the first level).
 */
let dragged = null;
/** The rows drawn, by path: what a drag of the selection carries. */
const rowLocs = new Map();
function dragRow(row, loc, movable) {
  if (movable) {
    row.draggable = true;
    row.ondragstart = (e) => {
      // A row of the selection carries the whole selection (what can move of it); any other, itself.
      const keys = selKeys();
      dragged = keys.length > 1 && keys.includes(loc.key) ? keys.map((k) => rowLocs.get(k)).filter((l) => l?.movable) : [loc];
      for (const l of dragged) $("layers").querySelector(`.layer[data-key="${l.key}"]`)?.classList.add("dragging");
      e.dataTransfer.setData("application/x-layer", loc.key); e.dataTransfer.effectAllowed = "move";
    };
    row.ondragend = () => { dragged = null; for (const r of $("layers").querySelectorAll(".dragging")) r.classList.remove("dragging"); };
  }
  const zone = (e) => {
    const r = row.getBoundingClientRect(), y = (e.clientY - r.top) / r.height;
    return y < 0.3 ? "above" : y > 0.7 ? "below" : "into";
  };
  const clear = () => row.classList.remove("above", "below", "into");
  row.ondragover = (e) => {
    if (!dragged || dragged.some((A) => A.key === loc.key || loc.key.startsWith(`${A.key}/`))) return;
    e.preventDefault();
    clear();
    row.classList.add(zone(e));
    row.title = { above: "above it", below: "below it", into: canHold(loc.ref) ? `into ${describe(loc.it.o)}` : `grouped with ${describe(loc.it.o)}` }[zone(e)];
  };
  row.ondragleave = clear;
  row.ondrop = (e) => {
    e.preventDefault();
    clear();
    const from = dragged;
    dragged = null;
    if (from?.length && !from.some((A) => A.key === loc.key)) dropLines(from, loc, zone(e)).catch((err) => status(err.message, "bad"));
  };
}

function select(i) {
  D().sel = i ?? null;
  D().nested = null;
  D().more = [];
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
  const many = selKeys(d).length;
  if (many > 1) box.append(html("div", { className: "hint many" }, `${many} lines selected: dragging one, the arrows, Del and a drag in the layers act on all of them (Ctrl+G groups first-level ones). Below: ${o.name ?? describe(o)}, the last picked — Esc keeps it alone.`));
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
  // Its depth: applied when entered (not as typed: "14" isn't 1 first), refused when taken.
  {
    const row = html("div", { className: "row" });
    const input = html("input", { type: "number", value: o.depth, disabled: ro, step: 1, min: 1, max: 65535, title: "Enter: applied (later frames follow); a depth another line has is refused — ↑ ↓ or drag in the layers move it among them" });
    input.onchange = () => {
      const v = Number(input.value);
      if (!Number.isInteger(v) || v < 1 || v > 65535 || v === o.depth) { input.value = o.depth; return; }
      if (usedDepths(owner).has(v)) {
        const other = (owner.kind === "button" ? owner.json.records : owner.json.frames.flatMap((f) => f.place ?? [])).find((x) => x.depth === v);
        status(`depth ${v} is taken${other ? ` by ${other.name ?? describe(other)}` : " (a later frame)"}: ↑ ↓ or drag it in the layers`, "bad");
        input.value = o.depth;
        return;
      }
      snapshot(owner);
      const was = o.depth, masks = (items(owner) ?? []).filter((m) => m.mask && was > m.depth && was <= m.mask && m.mask === was);
      if (owner.kind === "sprite") remapDepths(owner.json, new Map([[was, v]])); else o.depth = v;
      // A mask whose clip ended at it ends at the line under it now.
      for (const m of masks) m.mask = Math.max(m.depth, ...(items(owner) ?? []).filter((x) => x !== o && x.depth > m.depth && x.depth < was).map((x) => x.depth));
      changed();
    };
    row.append(html("label", {}, "depth"), input);
    box.append(row);
  }
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
  paramsSection(box, owner, o, ro);
  const actions = html("div", { className: "actions" });
  if (hasChildren(ref) || (ref?.kind === "text" && ref.file)) { const b = html("button", {}, "Open it"); b.onclick = () => open(ref.file); actions.append(b); }
  if (ref?.id !== undefined) { const b = html("button", {}, "Where else"); b.onclick = () => showWhere(ref.id, describe(o)); actions.append(b); }
  box.append(actions);
  if (!ro) box.append(liveJson(JSON.stringify(o), (j) => { items(owner)[n ? n.it.src : d.sel] = j; }, { tab: owner }));
  if (o.actions || o.name) box.append(html("div", { className: "hint" }, `${o.name ? `Code may reach it as this.${o.name}. ` : ""}${o.actions ? "It has clip actions (frame_1/PlaceObject2_….as)." : ""}`));
}

/**
 * A component's parameters (what on(construct) sets before its class builds
 * it: a window's title, a button's label and background, a style…), edited
 * here and drawn at once. A base sprite's line keeps them in its script
 * (frame_N/PlaceObject…/on(construct).as, rewritten when saved); any other
 * line, in its "params" (the build compiles them into its clip actions).
 */
function paramsSection(box, owner, o, ro) {
  const ref = refOf(o), cls = componentClass(ref);
  if (cls === undefined) { fileJsonKnown(ref.file).then(renderInspector); return; }
  if (!cls || owner.kind !== "sprite") return;
  if (o.actions && !o.params && owner.file.startsWith("timeline/") && !paramsKnown.has(owner.file)) { paramsOf(owner.file).then(renderInspector); return; }
  const cur = lineParams(owner, o), known = S.ui?.paramKeys?.[cls] ?? {};
  box.append(html("h4", { className: "params" }, `${cls} parameters`));
  box.append(html("div", { className: "hint" }, o.actions
    ? `Its on(construct) script (frame_1/PlaceObject…_${savedDepth(owner, o)}/), rewritten when saved.`
    : `Compiled into its clip actions when built ("params"). Code may set more (its class: ${cls}).`));
  let fresh = true;
  const set = (key, value, redraw) => {
    if (fresh) { snapshot(owner); fresh = false; }
    const next = { ...lineParams(owner, o) };
    if (value === undefined) delete next[key]; else next[key] = value;
    if (!o.actions && !Object.keys(next).length) delete o.params; else o.params = next;
    resetDefs(); setDirty(); draw();
    // (The inspector isn't redrawn under a field being typed in.)
    if (redraw) { document.activeElement?.blur?.(); renderInspector(); }
  };
  const listFor = (key) => (key === "styleName" ? "dl-styles" : /path$|^background|icon$|renderer$/i.test(key) ? "dl-exports" : undefined);
  for (const [key, value] of Object.entries(cur)) {
    const row = html("div", { className: "row p" });
    let input;
    if (typeof value === "boolean") {
      input = html("input", { type: "checkbox", checked: value, disabled: ro });
      input.onchange = () => set(key, input.checked);
    } else if (typeof value === "number") {
      input = html("input", { type: "number", value, step: "any", disabled: ro });
      input.oninput = () => { if (input.value !== "" && Number.isFinite(Number(input.value))) set(key, Number(input.value)); };
    } else if (typeof value === "string") {
      input = html("input", { type: "text", value, disabled: ro });
      if (listFor(key)) input.setAttribute("list", listFor(key));
      input.oninput = () => set(key, input.value);
    } else {
      input = html("input", { type: "text", value: JSON.stringify(value), disabled: ro, title: "JSON: applied when it parses" });
      input.oninput = () => { try { set(key, JSON.parse(input.value)); input.classList.remove("bad"); } catch { input.classList.add("bad"); } };
    }
    input.onblur = () => { fresh = true; };
    const rm = html("button", { className: "x", title: `Remove ${key}`, disabled: ro }, "✕");
    rm.onclick = () => set(key, undefined, true);
    row.append(html("label", { title: key }, key), input, rm);
    box.append(row);
  }
  if (ro) return;
  // Another parameter: those this component takes in the base's interfaces, with their usual value.
  const add = html("select", {});
  add.append(html("option", { value: "" }, "+ parameter…"));
  for (const k of Object.keys(known).filter((k) => !(k in cur)).sort()) add.append(html("option", { value: k }, `${k} (${JSON.stringify(known[k])})`));
  add.append(html("option", { value: "*" }, "other…"));
  add.onchange = () => {
    const k = add.value === "*" ? prompt("Parameter name (a property of the component's class):") : add.value;
    if (k && /^[A-Za-z_$][\w$]*$/.test(k)) set(k, k in known ? known[k] : "", true);
    else add.value = "";
  };
  const row = html("div", { className: "row" });
  row.append(html("label", {}, ""), add);
  box.append(row);
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
  /** The lines selected that can move, dragged from `p0` (screen moves turned into each one's parent's coordinates). */
  const linesDrag = (p0, reduce = null) => {
    const d = D(), lines = selLines(d).filter((L) => L.editable);
    if (!lines.length) return null;
    return {
      kind: "lines", start: p0, moved: false, reduce, before: undoEntry(lines.map((L) => L.tab)),
      lines: lines.map((L) => ({ L, x: L.o.x ?? 0, y: L.o.y ?? 0, node: L.owner ? null : $("content").querySelector(`.item[data-i="${L.it.src}"]`) })),
    };
  };
  stage.addEventListener("pointerdown", (e) => {
    const d = D();
    if (!d) return;
    const item = graphicsAt(e)[0] ?? null;
    const i = item && item.dataset.i !== "" ? Number(item.dataset.i) : null;
    const p0 = toSprite(e);
    // Shift+click: the graphic added to the selection, or taken out (Shift+Ctrl: the deepest line there).
    if (e.button === 0 && e.shiftKey) {
      if ((e.ctrlKey || e.metaKey) && item?.dataset.depth) hitAt(e, true).then((h) => h && h.it.src !== null && toggleSel(h.path, h.owner));
      else if (i !== null) toggleSel(`/${item.dataset.depth}`);
      return;
    }
    // Ctrl+click: the deepest line under the pointer, dragged at once.
    if (e.button === 0 && (e.ctrlKey || e.metaKey) && item?.dataset.depth) {
      const wait = { kind: "wait" };
      drag = wait;
      stage.setPointerCapture(e.pointerId);
      selectAt(e, true).then(() => { if (drag === wait) drag = linesDrag(p0); });
      return;
    }
    // On what's selected (a first-level graphic, or inside a nested line's box): all of it moves.
    // (A click without a move on one of several: that one alone.)
    const many = selKeys(d).length > 1;
    const onTop = i !== null && selLines(d).some((L) => !L.owner && L.it.src === i);
    const onNested = d.boxes?.some((b) => b.byBox && inBox(p0, b.bb));
    const sel = e.button === 0 && (onTop || onNested) && linesDrag(p0, onTop && many ? i : null);
    if (sel) drag = sel;
    else if (e.button === 0 && i !== null && editable()) { select(i); drag = linesDrag(p0); }
    else {
      if (i !== null) select(i);
      drag = { kind: "pan", sx: e.clientX, sy: e.clientY, vx: view.x, vy: view.y, moved: false, deselect: i === null };
    }
    stage.setPointerCapture(e.pointerId);
  });
  stage.addEventListener("pointermove", (e) => {
    if (!drag || drag.kind === "wait") return;
    if (drag.kind === "pan") {
      view.x = drag.vx + e.clientX - drag.sx; view.y = drag.vy + e.clientY - drag.sy;
      drag.moved ||= Math.abs(e.clientX - drag.sx) + Math.abs(e.clientY - drag.sy) > 3;
      applyView();
      return;
    }
    const p = toSprite(e), dx = p.x - drag.start.x, dy = p.y - drag.start.y;
    if (!drag.moved && Math.hypot(dx, dy) * view.k < 2) return;
    drag.moved = true;
    for (const m of drag.lines) {
      const [lx, ly] = toParent(m.L, dx, dy);
      m.L.o.x = round20(m.x + lx); m.L.o.y = round20(m.y + ly);
      // A first-level line moves as a whole (a component's drawing has its own transform); the rest, on release.
      m.node?.setAttribute("transform", `translate(${m.L.o.x - m.x} ${m.L.o.y - m.y})`);
    }
    // The boxes follow.
    $("overlay").setAttribute("transform", `translate(${dx} ${dy})`);
  });
  const end = () => {
    if (drag?.kind === "lines" && drag.moved) { D().undo.push(drag.before); D().redo = []; $("overlay").removeAttribute("transform"); changed(); }
    if (drag?.kind === "lines" && !drag.moved && drag.reduce !== null) select(drag.reduce);
    if (drag?.kind === "pan" && !drag.moved && drag.deselect) select(null);
    drag = null;
  };
  stage.addEventListener("pointerup", end);
  // Double-click: one level deeper, under the pointer (inside the sprite selected).
  // (The pointer's captured: what's under it, not the event's target.)
  stage.addEventListener("dblclick", (e) => { if (D()) selectAt(e, false); });
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
    assignSel(d, []);
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
  const e = from.pop(), tab = (f) => S.tabs.find((x) => x.file === f);
  const list = (e.list ?? [e]).filter((x) => tab(x.file));
  if (!list.length) return undo(redo);
  to.push({ list: list.map((x) => ({ file: x.file, json: JSON.stringify(tab(x.file).json) })), at: { sel: d.sel, nested: d.nested, more: d.more } });
  for (const x of list) tab(x.file).json = JSON.parse(x.json);
  // The selection as it was (a line moved elsewhere is selected where it's back).
  if (e.at) { d.sel = e.at.sel; d.nested = e.at.nested; d.more = e.at.more ?? []; }
  if (d.sel !== null && !items()?.[d.sel]) d.sel = null;
  if (d.nested && !nestedInfo()) d.nested = null;
  d.more = d.more.filter((k) => lineAt(k, d));
  changed();
}
/** Every line selected moved on screen by (dx, dy): each in its parent's coordinates. */
function nudge(dx, dy) {
  const lines = selLines().filter((L) => L.editable);
  if (!lines.length) return;
  snapshot(...lines.map((L) => L.tab));
  for (const L of lines) {
    const [lx, ly] = toParent(L, dx, dy);
    L.o.x = round20((L.o.x ?? 0) + lx); L.o.y = round20((L.o.y ?? 0) + ly);
  }
  changed();
}
function removeSel() {
  const d = D(), lines = selLines(d).filter((L) => L.editable);
  if (!lines.length) return;
  snapshot(...lines.map((L) => L.tab));
  for (const L of lines) { const list = items(L.tab), k = list.indexOf(L.o); if (k >= 0) list.splice(k, 1); }
  assignSel(d, []);
  changed();
  const defs = [...new Set(lines.filter((L) => L.owner).map((L) => L.owner.label))];
  if (defs.length) status(`removed${lines.length > 1 ? ` ${lines.length} lines` : ""} — from ${defs.join(", ")}'s definition${defs.length > 1 ? "s" : ""} (every placement)`);
  else if (lines.length > 1) status(`removed ${lines.length} lines`);
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

/** Every depth a sprite's frames use (placed or removed), or a button's records. */
function usedDepths(t, except) {
  const out = new Set();
  if (t.kind === "button") { for (const o of t.json.records ?? []) if (o !== except) out.add(o.depth); }
  else for (const f of t.json.frames ?? []) { for (const o of f.place ?? []) if (o !== except) out.add(o.depth); for (const dd of f.remove ?? []) out.add(dd); }
  return out;
}

/**
 * Line `x` put between lines `below` and `above` of tab `t` (indices in its
 * list; null: the bottom, the top), changing as few depths as it can: a
 * free depth between them if there's one; else the fewest lines moved up
 * from `above` (or down from `below`) to the next free depth — fewer moved
 * lines, fewer scripts' folders renamed when saved. Later frames follow;
 * a mask keeps masking what it masked (and masks `x` if it lands among
 * it). An error message, or null.
 */
function placeBetween(t, x, below, above) {
  const list = items(t), X = list[x];
  if (X.mask) return `${describe(X)} is a mask: move what it masks`;
  const order = lineOrder(t).filter((k) => k !== x);
  // (Another line at its depth — the one the player ignores — keeps it.)
  const used = usedDepths(t, X);
  const lo = below === null ? 0 : list[below].depth, hi = above === null ? 65536 : list[above].depth;
  const map = new Map();
  let d = X.depth > lo && X.depth < hi && !used.has(X.depth) ? X.depth : null;
  for (let k = lo + 1; d === null && k < hi; k++) if (!used.has(k)) d = k;
  if (d === null) {
    // No room between: the lines from `above` up (or from `below` down) to the next free depth make some.
    const at = new Map(order.map((k) => [list[k].depth, k]));
    const shift = (dir) => {
      if ((dir > 0 ? above : below) === null) return null;
      const moved = [];
      let f = dir > 0 ? hi : lo;
      for (; f > 0 && f < 65536 && used.has(f); f += dir) if (at.has(f)) moved.push(at.get(f));
      if (f <= 0 || f >= 65536) return null;
      const slots = [...moved.map((k) => list[k].depth), f].sort((m, n) => m - n);
      const lines = moved.sort((m, n) => list[m].depth - list[n].depth);
      return dir > 0
        ? { d: slots[0], pairs: lines.map((k, i) => [list[k].depth, slots[i + 1]]), cost: [moved.length, moved.filter((k) => list[k].actions).length] }
        : { d: slots.at(-1), pairs: lines.map((k, i) => [list[k].depth, slots[i]]), cost: [moved.length, moved.filter((k) => list[k].actions).length] };
    };
    const best = [shift(1), shift(-1)].filter(Boolean).sort((m, n) => m.cost[0] - n.cost[0] || m.cost[1] - n.cost[1])[0];
    if (!best) return "no free depth left for it";
    d = best.d;
    for (const [from, to] of best.pairs) map.set(from, to);
  }
  // Its own depth (not through remapDepths: the line it shared a depth with stays).
  const own = d !== X.depth ? d : null;
  if (!map.size && own === null) return null;
  // What each mask masked (depths over it, up to its clip), before.
  const masks = order.filter((k) => list[k].mask).map((k) => ({ o: list[k], kept: order.filter((j) => j !== k && list[j].depth > list[k].depth && list[j].depth <= list[k].mask).map((j) => list[j]) }));
  const later = own !== null && t.kind === "sprite" && !usedDepths({ kind: t.kind, json: { frames: [t.json.frames[0]] } }, X).has(X.depth) ? X.depth : null;
  if (t.kind === "sprite") remapDepths(t.json, map); else for (const o of list) if (map.has(o.depth)) o.depth = map.get(o.depth);
  if (own !== null) {
    // Later frames moving or removing it follow it (unless the depth was shared: they meant the other one).
    if (later !== null) for (const f of t.json.frames.slice(1)) { for (const o of f.place ?? []) if (o.move && o.depth === later) o.depth = own; if (f.remove) f.remove = f.remove.map((dd) => (dd === later ? own : dd)); }
    X.depth = own;
  }
  for (const m of masks) if (m.kept.length) m.o.mask = Math.max(...m.kept.map((o) => o.depth)); else if (map.has(m.o.mask)) m.o.mask = map.get(m.o.mask);
  return null;
}
/** Line `i` next to line `j` of tab `t`: just above it (`above`) or just below. */
function moveNextTo(i, j, above, t = D()) {
  const order = lineOrder(t).filter((k) => k !== i), at = order.indexOf(j);
  return above ? placeBetween(t, i, j, order[at + 1] ?? null) : placeBetween(t, i, order[at - 1] ?? null, j);
}
/** Tab `t`'s editable lines, bottom first (the open tab's as shown, another's frame 1 or "up"). */
function lineOrder(t) {
  const list = t === D() ? currentList() : childList({ kind: t.kind }, t.json);
  return list.filter((it) => it.src !== null).map((it) => it.src);
}
function restack(dir) {
  const d = D();
  if (!d || d.sel === null || !editable()) return;
  const list = currentList().filter((it) => it.src !== null).map((it) => it.src);
  const at = list.indexOf(d.sel), other = list[at + dir];
  if (other === undefined || d.more.length) return;
  snapshot();
  const why = moveNextTo(d.sel, other, dir > 0);
  if (why) { d.undo.pop(); status(why, "bad"); return; }
  changed();
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

/**
 * What code loses when lines of `src` move into another clip: the instance
 * names its class reaches (this._tiAccount) aren't where it looks any more.
 * Names its class doesn't use go without a word; a sprite without a class
 * of its own (its parent's code may reach inside it), asked about all.
 */
async function codeWarning(src, lines, into) {
  const code = src.file.startsWith("timeline/") ? await paramsOf(src.file) : null;
  const named = lines.filter((o) => o.name && (!code?.uses || code.uses.includes(o.name)));
  if (!named.length) return true;
  const names = named.map((o) => o.name), many = names.length > 1;
  const who = code?.cls ? `${code.cls.split(".").pop()} (its class) uses` : "code may use";
  const them = many ? "them" : "it";
  return confirm(`${who} ${names.map((n) => `this.${n}`).join(", ")}: moved into ${into}, ${many ? "they're" : "it's"} no longer where it looks for ${them} — in the game, what it does with ${them} (texts, events, values set by code) is lost until the class changes.\n\nMove ${them} anyway?`);
}
/**
 * Lines of `src` leaving it: their clip actions are its scripts and can't
 * follow; what they set (on(construct)) goes along as their "params",
 * compiled the same by the build. An error when one does more (onClipEvent,
 * code): it stays.
 */
async function carryCheck(src, lines) {
  const scripted = lines.filter((o) => o.actions);
  if (!scripted.length) return null;
  const p = src.file.startsWith("timeline/") ? await paramsOf(src.file) : {};
  const bad = scripted.find((o) => !p.plain?.[1]?.includes(savedDepth(src, o)));
  return bad ? `${bad.name ?? describe(bad)}: its clip actions do more than set its parameters (src/${src.file.replace(/[^/]+$/, "")}frame_1/PlaceObject…_${savedDepth(src, bad)}/) — they can't leave ${src.title}, so it stays` : null;
}
/** A copy of line `o` of `src` for another sprite: its clip actions' parameters as its own "params". */
function carried(src, o) {
  const out = { ...o };
  if (o.actions) { delete out.actions; out.params = structuredClone(lineParams(src, o)); }
  return out;
}
function checkMovable(d, idx) {
  if (d.kind !== "sprite" || !editable()) return "only a sprite's frame-1 lines move into others";
  const moving = animatedDepths(d.json);
  const bad = idx.map((i) => items()[i]).find((o) => moving.has(o.depth) || o.mask);
  return bad ? `${describe(bad)}: ${bad.mask ? "a mask" : "later frames move it"} — not moved` : null;
}

/** Whether what `ref` shows places `file`, at any depth (as far as it's loaded). */
function holds(ref, file, seen = new Set()) {
  if (!ref?.file || seen.has(ref.file)) return false;
  if (ref.file === file) return true;
  seen.add(ref.file);
  const json = knownJson(ref.file);
  const lines = json ? [...(json.frames ?? []).flatMap((f) => f.place ?? []), ...(json.records ?? [])] : [];
  return lines.some((o) => holds(refOf(o), file, seen));
}
/** The lists along a path of the tree, from the open tab's down: each one's file and place on screen. */
function along(path) {
  const out = [{ file: D().file, chain: ID }];
  let list = currentList(), chain = ID;
  for (const depth of path.split("/").slice(1).map(Number)) {
    const it = list.find((x) => x.depth === depth), ref = it && refOf(it.o), json = hasChildren(ref) && knownJson(ref.file);
    if (!json) break;
    chain = multiply(chain, matrixOf(it.o));
    out.push({ file: ref.file, chain });
    list = childList(ref, json);
  }
  return out;
}
/** How many times a sprite of the base is placed (1 for the open tab or ours). */
async function placements(t) {
  if (t === D() || t.kind !== "sprite" || t.id === undefined) return 1;
  return (await api(`/api/where?id=${t.id}`).catch(() => [])).length;
}

/**
 * The lines of rows `As` dropped on row `B` (rows of the layers tree, at any
 * level): above or below B, in B's list, or into the sprite B places — in
 * the order the tree shows them, next to each other. Each stays where it is
 * on screen (its matrix is recomputed for its new list); a definition a line
 * leaves or joins changes for every placement (its tab, ●). One undo step.
 */
async function dropLines(As, B, zone) {
  const d = D();
  // What's inside a line that moves moves with it.
  As = As.filter((A) => !As.some((P) => P !== A && A.key.startsWith(`${P.key}/`)));
  if (As.some((A) => B.key === A.key || B.key.startsWith(`${A.key}/`))) { status("a line can't go inside itself", "bad"); return; }
  if (zone === "into" && !canHold(B.ref)) {
    if (B.top && As.every((A) => A.top) && editable()) return group([B.it.src, ...As.map((A) => A.it.src)], B.it.src);
    status(`${describe(B.it.o)} can't hold anything: drop on its top or bottom edge`, "bad");
    return;
  }
  const into = zone === "into";
  const dest = into
    ? { file: B.ref.file, chain: multiply(B.chain, matrixOf(B.it.o)), path: B.key, label: describe(B.it.o) }
    : { file: B.file, chain: B.chain, path: B.key.slice(0, B.key.lastIndexOf("/")), label: B.label };
  if ((As.some((A) => A.top) || dest.file === d.file) && !editable()) { status("frames after the first aren't edited here", "bad"); return; }
  const dst = await tabFor(dest.file), seen = new Set(), lines = [];
  for (const A of As) {
    const src = await tabFor(A.file), o = items(src)[A.it.src];
    if (o && !seen.has(o)) { seen.add(o); lines.push({ A, src, o }); }
  }
  if (!lines.length) return;
  const leaving = lines.filter((l) => l.src !== dst);
  if (leaving.length) {
    if (dst.kind === "button" || leaving.some((l) => l.src.kind === "button")) { status("a button's records stay in their button (reorder them there)", "bad"); return; }
    for (const { A, src, o } of leaving) {
      if (holds(A.ref, dst.file)) { status(`${describe(o)} would hold itself`, "bad"); return; }
      if (o.mask || animatedDepths(src.json).has(o.depth)) { status(`${describe(o)}: ${o.mask ? "a mask" : "later frames move it"} — not moved`, "bad"); return; }
    }
    for (const [src, ls] of new Map(leaving.map((l) => [l.src, leaving.filter((x) => x.src === l.src).map((x) => x.o)]))) {
      const why = await carryCheck(src, ls);
      if (why) { status(why, "bad"); return; }
      if (!(await codeWarning(src, ls, dest.label))) return;
    }
    const srcs = [...new Map(leaving.map((l) => [l.src, l.A.label])).entries()];
    const counts = await Promise.all([dst, ...srcs.map(([t]) => t)].map(placements));
    const shared = [...srcs.map(([, label], k) => counts[k + 1] > 1 && `leaving ${label}, placed ${counts[k + 1]} times`), counts[0] > 1 && `joining ${dest.label}, placed ${counts[0]} times`].filter(Boolean);
    const what = lines.length > 1 ? `${lines.length} lines` : describe(lines[0].o);
    if (shared.length && !confirm(`${what}: ${shared.join("; ")} — every placement changes. Go on?`)) return;
  }
  // As the tree shows them: bottom first, each above the last (below: top first, each under the last).
  const order = [...$("layers").querySelectorAll(".layer")].map((r) => r.dataset.key);
  lines.sort((m, n) => order.indexOf(n.A.key) - order.indexOf(m.A.key));
  if (zone === "below") lines.reverse();
  snapshot(dst, ...lines.map((l) => l.src));
  const fail = (why) => { undo(); d.redo.pop(); status(why, "bad"); };
  let anchor = into ? null : items(dst)[B.it.src];
  for (const l of lines) {
    const list = items(dst);
    let why;
    if (l.src === dst) {
      // The same list (one definition, maybe seen through another placement): only the order changes.
      const i = list.indexOf(l.o);
      why = anchor ? moveNextTo(i, list.indexOf(anchor), zone === "above", dst) : placeBetween(dst, i, lineOrder(dst).filter((k) => k !== i).at(-1) ?? null, null);
      l.moved = l.o;
    } else {
      // One definition seen through two placements (out of _css3, into what _css4 holds): measured through the same one.
      let from = l.A.chain, to = dest.chain;
      const viaDest = along(dest.path).find((x) => x.file === l.A.file), viaSrc = along(l.A.key.slice(0, l.A.key.lastIndexOf("/"))).find((x) => x.file === dest.file);
      if (viaDest) from = viaDest.chain; else if (viaSrc) to = viaSrc.chain;
      l.moved = setMatrix(carried(l.src, l.o), multiply(invert(to), multiply(from, matrixOf(l.o))));
      l.moved.depth = freeDepth(dst.json);
      items(l.src).splice(items(l.src).indexOf(l.o), 1);
      list.push(l.moved);
      why = anchor && moveNextTo(list.length - 1, list.indexOf(anchor), zone === "above", dst);
    }
    if (why) { fail(why); return; }
    if (!into) anchor = l.moved;
  }
  // Selected where they are now (the first in the tree in the inspector).
  assignSel(d, lines.map((l) => `${dest.path}/${l.moved.depth}`), `${dest.path}/${(zone === "below" ? lines[0] : lines.at(-1)).moved.depth}`);
  changed();
  const files = new Set([dest.file, ...lines.map((l) => l.A.file)]).size;
  const what = lines.length > 1 ? `${lines.length} lines` : describe(lines[0].moved);
  status(!leaving.length ? (lines.length > 1 ? `${what}: depths ${lines.map((l) => l.moved.depth).sort((m, n) => m - n).join(", ")}` : `${what}: depth ${lines[0].moved.depth}`) : `${what} ${lines.length > 1 ? "are" : "is"} in ${dest.label} now (unsaved: Save all writes ${files > 1 ? `the ${files} files` : "it"})`, "good");
}

/** Lines `idx` wrapped in a new sprite (src/assets/new/<this one>/group-N.json), placed where the first was. */
async function group(idx, anchor = idx[0]) {
  const d = D(), list = items();
  const why = checkMovable(d, idx);
  if (why) { status(why, "bad"); return; }
  const lines = idx.map((i) => list[i]).sort((a, b) => a.depth - b.depth);
  const cant = await carryCheck(d, lines);
  if (cant) { status(cant, "bad"); return; }
  if (!(await codeWarning(d, lines, "the group"))) return;
  const owner = (d.name ?? `sprite-${d.id}`).toLowerCase().replace(/[^a-z0-9_/-]/g, "-");
  const taken = (n) => S.lib.exports[n] !== undefined || S.freshByName.has(n) || S.tabs.some((t) => t.name === n);
  let n = 1;
  while (taken(`${owner}/group-${n}`)) n++;
  const name = `${owner}/group-${n}`;
  const at = matrixOf(list[anchor]);
  const origin = [1, 0, 0, 1, at[4], at[5]];
  const json = { frames: [{ place: lines.map((o, k) => setMatrix({ ...carried(d, o), depth: k + 1 }, multiply(invert(origin), matrixOf(o)))) }] };
  snapshot();
  const placed = { depth: Math.min(...lines.map((o) => o.depth)), export: name, x: round20(at[4]), y: round20(at[5]) };
  for (const i of [...idx].sort((a, b) => b - a)) list.splice(i, 1);
  list.push(placed);
  assignSel(d, []);
  d.sel = list.length - 1;
  await tabFor(`assets/new/${name}.json`, json);
  d.open.add(`/${placed.depth}`);
  changed();
  status(`grouped into "${name}" (src/assets/new/${name}.json, written with ${d.title} when saved): drag it, everything inside follows`, "good");
}

/** Ctrl+G: the first-level lines selected, grouped. */
function groupSel() {
  const d = D();
  if (!d || d.sel === null) return;
  const lines = selLines(d);
  if (lines.some((L) => L.owner)) { status("Group: first-level lines only — to group lines inside a sprite, open it (double-click its row) and group them there", "bad"); return; }
  group([d.sel, ...lines.map((L) => L.it.src).filter((k) => k !== null && k !== d.sel)]);
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
  // Its lines' clip actions stay in its definition: their parameters come along.
  const def = S.tabs.find((t) => t.file === ref.file) ?? { file: ref.file, title: describe(host), saved: JSON.stringify(json) };
  const cant = await carryCheck(def, kids.map((it) => it.o));
  if (cant) { status(cant, "bad"); return; }
  snapshot();
  // Room for them at its depth: the lines above move up.
  const shift = kids.length - 1, map = new Map();
  for (const f of d.json.frames) for (const o of f.place ?? []) if (o.depth > host.depth) map.set(o.depth, o.depth + shift);
  remapDepths(d.json, map);
  const m = matrixOf(host), base = host.depth;
  const out = kids.map((it, k) => {
    const o = setMatrix({ ...carried(def, it.o), depth: base + k }, multiply(m, matrixOf(it.o)));
    if ("alpha" in host) { o.alpha = Math.round((o.alpha ?? 1) * host.alpha * 1e5) / 1e5; if (o.alpha === 1) delete o.alpha; }
    return o;
  });
  list.splice(i, 1, ...out);
  assignSel(d, []);
  d.sel = i;
  changed();
  status(`${describe(host)}: its ${kids.length} line${kids.length > 1 ? "s" : ""} put in its place`, "good");
}

/** Saves a tab: checked by the server (the build's encoder), then written. */
async function saveTab(t) {
  const order = t.kind === "button" ? RECORD_ORDER : PLACE_ORDER;
  if (t.kind === "sprite") for (const f of t.json.frames ?? []) if (f.place) f.place = f.place.map((o) => ordered(o, order));
  if (t.kind === "button") t.json.records = t.json.records.map((o) => ordered(o, order));
  const r = await api(`/api/save?path=${encodeURIComponent(t.file)}`, { method: "PUT", body: JSON.stringify(t.json) });
  const created = t.saved === null;
  t.saved = JSON.stringify(t.json);
  diskJson.delete(t.file);
  // Parameters of lines with their own scripts went into them: read back from there.
  if (r.scripts?.length) { for (const f of t.json.frames ?? []) for (const o of f.place ?? []) if (o.actions) delete o.params; t.saved = JSON.stringify(t.json); }
  // Lines moved to other depths: their clip actions' scripts were renamed with them.
  if (r.moved?.length || r.scripts?.length) {
    paramCache.delete(t.file); paramsKnown.delete(t.file); resetDefs(); draw();
    saveNotes.push(...[r.moved?.length && `${t.title}: clip actions moved with their lines\n  ${r.moved.join("\n  ")}`, r.scripts?.length && `${t.title}: parameters written in\n  ${r.scripts.map((f) => `src/${f}`).join("\n  ")}`].filter(Boolean));
  }
  return created;
}
/** What saving did besides writing the files (scripts renamed, parameters written): shown once saved. */
const saveNotes = [];
/**
 * Tabs `todo` and the new sprites they place that were never written (a
 * group just made): the server checks a placement against what's exported,
 * so those are written too (first).
 */
function withNewSprites(todo) {
  const seen = new Set(todo), first = [];
  const unwritten = new Map(S.tabs.filter((t) => t.saved === null && t.name).map((t) => [t.name, t]));
  // What a sprite places before it (a group in a group: the inner one first).
  const visit = (t) => {
    const lines = [...(t.json.frames ?? []).flatMap((f) => f.place ?? []), ...(t.json.records ?? [])];
    for (const o of lines) {
      const n = typeof o.export === "string" && unwritten.get(o.export.toLowerCase());
      if (n && !seen.has(n)) { seen.add(n); visit(n); first.push(n); }
    }
  };
  todo.forEach(visit);
  return [...first, ...todo];
}
async function save(all = false) {
  const asked = all ? S.tabs.filter(isDirty) : D() && isDirty(D()) ? [D()] : [];
  if (!asked.length) return;
  const todo = withNewSprites(asked);
  saveNotes.length = 0;
  status("saving…");
  const errors = [];
  let created = false;
  const failed = [];
  // Ours first: what the others place must exist to be checked.
  for (const t of todo.sort((a, b) => b.file.startsWith("assets/") - a.file.startsWith("assets/"))) {
    try { created = (await saveTab(t)) || created; } catch (e) {
      // What places a new sprite that couldn't be written fails with it: said so.
      const why = failed.filter((n) => e.message.includes(`"${n}"`)).map((n) => `\n  (${n} wasn't written: see why above)`).join("");
      errors.push(`${t.title} (src/${t.file}):\n  ${e.message}${why}`);
      if (t.name && t.saved === null) failed.push(t.name);
    }
  }
  if (created) { await loadLibrary(); renderList(); }
  setDirty();
  resetDefs();
  await draw();
  if (errors.length) { status(`${errors.length} not saved: see below`, "bad"); log(errors.join("\n\n")); }
  else {
    const extra = todo.filter((t) => !asked.includes(t));
    status(todo.length > 1 ? `saved ${todo.length} files${extra.length && !all ? ` (with ${extra.map((t) => t.name).join(", ")}, which ${asked[0].title} places)` : ""}` : `saved src/${todo[0].file}`, "good");
    log(saveNotes.length ? saveNotes.join("\n") : null);
  }
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
  diskJson.clear(); loaded.clear(); shapeText.clear(); paramCache.clear();
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
  const toggles = () => { for (const k of ["components", "outlines", "masks", "maskShapes"]) $(k).classList.toggle("on", S[k]); };
  for (const k of ["masks", "maskShapes"]) $(k).onclick = () => { S[k] = !S[k]; store.set(k, S[k]); toggles(); resetDefs(); draw(); };
  $("components").onclick = () => { S.components = !S.components; store.set("components", S.components); toggles(); resetDefs(); draw(); };
  $("outlines").onclick = () => { S.outlines = !S.outlines; store.set("outlines", S.outlines); toggles(); drawSelection(); };
  toggles();
  $("whereUsed").onclick = () => {
    const d = D();
    if (d.id) return showWhere(d.id, `src/${d.file}`);
    status(`${d.name}: placed where you put it (search the sprite.json files for "export": "${d.name}")`);
  };
  $("up").onclick = () => restack(1);
  $("down").onclick = () => restack(-1);
  $("remove").onclick = removeSel;
  $("group").onclick = groupSel;
  $("ungroup").onclick = () => { const d = D(); if (d?.sel !== null) ungroup(d.sel); };
  $("search").oninput = renderList;
  $("frame").onchange = () => { const d = D(); d.frame = Math.max(1, Number($("frame").value) || 1); assignSel(d, []); draw(); renderInspector(); };
  $("state").onchange = () => { D().state = $("state").value; draw(); };
  window.addEventListener("keydown", (e) => {
    const typing = /INPUT|TEXTAREA|SELECT/.test(document.activeElement?.tagName);
    const mod = e.ctrlKey || e.metaKey;
    if (mod && e.key.toLowerCase() === "s") { e.preventDefault(); save(e.shiftKey); return; }
    if (mod && e.key.toLowerCase() === "w") { e.preventDefault(); if (S.active >= 0) closeTab(S.active); return; }
    if (mod && (e.key === "PageDown" || e.key === "PageUp") && S.tabs.length) { e.preventDefault(); activate((S.active + (e.key === "PageDown" ? 1 : -1) + S.tabs.length) % S.tabs.length); return; }
    if (typing) return;
    if (mod && e.key.toLowerCase() === "g") { e.preventDefault(); if (e.shiftKey) { if (D()?.sel != null && !D().more.length) ungroup(D().sel); } else groupSel(); }
    else if (mod && e.key.toLowerCase() === "a") { e.preventDefault(); selectAll(); }
    else if (mod && e.key.toLowerCase() === "z") { e.preventDefault(); undo(e.shiftKey); }
    else if (mod && e.key.toLowerCase() === "y") { e.preventDefault(); undo(true); }
    else if (e.key.startsWith("Arrow")) {
      e.preventDefault();
      const n = e.shiftKey ? 10 : 1;
      nudge(e.key === "ArrowLeft" ? -n : e.key === "ArrowRight" ? n : 0, e.key === "ArrowUp" ? -n : e.key === "ArrowDown" ? n : 0);
    } else if (e.key === "Delete" || e.key === "Backspace") removeSel();
    else if (e.key === "Escape") selectUp();
    else if (e.key === "f" || e.key === "F") fit();
    else if (e.key === "o" || e.key === "O") $("outlines").click();
    else if (e.key === "m" || e.key === "M") $("maskShapes").click();
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
