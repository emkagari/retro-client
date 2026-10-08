/**
 * Renames obfuscated identifiers everywhere they live in the bytecode:
 * constant pools, pushed strings, function names and parameters, class
 * export names (`__Packages.dofus.\x1b\r\x04`). Names change length, so every
 * jump offset and container size is recomputed (on cleaned code: a linear
 * decoding is exact there).
 */
import { OP, cstr, decode, encodeAction, encodePush, readPool, readPush, containerSizes, withContainerSizes, type Action } from "./avm1.ts";
import { codeSites, exportsOf, namedTags, TAG, type Swf } from "./swf.ts";
import { cleanCode } from "./clean.ts";

/**
 * The obfuscator's alphabet: short strings made ONLY of control characters
 * (every recognized id is). A printable character means text ("</b>\n",
 * ".\n", "\tlink:"), and so do text separators alone ("\n", "\r\n", "\t").
 */
export const looksObfuscated = (s: string) => s.length > 0 && s.length <= 8 && /^[\x01-\x1f]+$/.test(s) && !/^[\t\n\r]+$/.test(s);

/** Stable readable name for an id nobody recognized: `_o` + its bytes in hex. */
export const placeholder = (s: string) => "_o" + Buffer.from(s, "latin1").toString("hex");

export interface RenameStats { renamed: number; placeholders: number }

/** Every readable string the code already uses (pools, pushes, function names). */
export function plainNames(swf: Swf): Set<string> {
  const out = new Set<string>();
  const add = (s: string) => { if (!looksObfuscated(s)) out.add(s); };
  for (const site of codeSites(swf)) {
    for (const a of decode(site.code)) {
      if (a.code === OP.ConstantPool) readPool(a).forEach(add);
      else if (a.code === OP.Push) { try { for (const v of readPush(a)) if (v.t === "str") add(v.v); } catch { /* not a push */ } }
      else if (a.code === OP.DefineFunction || a.code === OP.DefineFunction2) add(cstr(a.body, 0)[0]);
    }
  }
  renameTimeline(swf, (s) => { add(s); return s; });   // instance names, labels… (read only)
  return out;
}

/** One `addProperty(prop, getter, setter)` of the code; null where a dummy function stands. */
export interface Registration { site: string; spriteId: number | null; prop: string; getter: string | null; setter: string | null }

/**
 * Every accessor registration (the compiler's `get x()` / `set x()`):
 *
 *   Push r1, "<setter>"  GetMember   (or a dummy function: no setter)
 *   Push r1, "<getter>"  GetMember   (or a dummy function: no getter)
 *   Push "x", 3, r1, "addProperty"  CallMethod
 */
export function registrations(swf: Swf): Registration[] {
  const out: Registration[] = [];
  for (const site of codeSites(swf)) {
    const acts = decode(site.code);
    let pool: string[] = [];
    const strs = (a: Action) => {
      if (a.code !== OP.Push) return null;
      try { return readPush(a).map((v) => (v.t === "str" ? v.v : v.t === "const" ? pool[v.v] ?? null : null)); } catch { return null; }
    };
    const member = (j: number) => {
      if (j < 1 || acts[j]!.code !== OP.GetMember) return null;
      const s = strs(acts[j - 1]!);
      return s ? s[s.length - 1] ?? null : null;
    };
    const dummy = (j: number) => acts[j]!.code === OP.DefineFunction || acts[j]!.code === OP.DefineFunction2;
    for (let i = 0; i < acts.length; i++) {
      if (acts[i]!.code === OP.ConstantPool) { pool = readPool(acts[i]!); continue; }
      if (acts[i]!.code !== OP.CallMethod || i < 5) continue;
      const call = strs(acts[i - 1]!);
      if (!call || call.length < 4 || call[call.length - 1] !== "addProperty") continue;
      const raw = readPush(acts[i - 1]!), count = raw[raw.length - 3];
      if (!count || !("v" in count) || Number(count.v) !== 3) continue;
      const prop = call[call.length - 4];
      if (!prop) continue;
      const getter = dummy(i - 2) ? null : member(i - 2);
      const setter = dummy(i - 2) ? member(i - 3) : getter !== null ? member(i - 4) : null;
      out.push({ site: site.where, spriteId: site.spriteId, prop, getter, setter });
    }
  }
  return out;
}

/**
 * Names safe to put in a SWF that must still RUN: the obfuscated id → name
 * pairs minus what isn't an id (text separators), and a name the code already
 * uses in clear (`enabled`, `data`…) gets a `_` suffix — two members merged
 * into one break the client.
 */
export function runnable(mapping: Map<string, string>, plain: Set<string>, regs: Registration[] = []): { mapping: Map<string, string>; suffixed: number } {
  const out = new Map<string, string>();
  const used = new Set(plain);
  let suffixed = 0;
  for (const [k, v] of mapping) {
    if (!looksObfuscated(k)) continue;
    let name = v;
    // Accessors are never suffixed on their own: they follow their property (below).
    const accessor = /^__(get|set)__/.test(name);
    if (used.has(name) && !accessor) { suffixed++; do name += "_"; while (used.has(name)); }
    used.add(name);
    out.set(k, name);
  }
  // Each renamed accessor takes its property's final name (the compiler rebuilds
  // `addProperty` from accessor names: `right` became `right_` → `__get__right_`).
  const final = (s: string) => out.get(s) ?? s;
  for (const r of regs) {
    const prop = final(r.prop);
    if (looksObfuscated(prop)) continue;                 // a property with no name names nothing
    for (const [fn, kind] of [[r.getter, "get"], [r.setter, "set"]] as const) {
      // Renamed accessors, and obfuscated ones nobody named (they're ids all the same).
      if (fn === null || !(out.has(fn) || looksObfuscated(fn))) continue;
      out.set(fn, `__${kind}__${prop}`);
    }
  }
  return { mapping: out, suffixed };
}

/** `placeholders` false: unknown ids keep their bytes (some "ids" are text — ".\n" — and a SWF that must run can't risk it). */
export function renamer(mapping: Map<string, string>, stats: RenameStats, placeholders = true) {
  return (s: string): string => {
    const m = mapping.get(s);
    if (m) { stats.renamed++; return m; }
    if (placeholders && looksObfuscated(s)) { stats.placeholders++; return placeholder(s); }
    return s;
  };
}

const zstr = (s: string) => Buffer.concat([Buffer.from(s, "latin1"), Buffer.from([0])]);

/** New body of one action with its names renamed (null: unchanged). `params`: names for this function's parameters. */
function renameBody(a: Action, rn: (s: string) => string, params: string[] | null = null): Buffer | null {
  if (a.code === OP.ConstantPool) {
    const pool = readPool(a).map(rn);
    const n = Buffer.alloc(2); n.writeUInt16LE(pool.length);
    return Buffer.concat([n, ...pool.map(zstr)]);
  }
  if (a.code === OP.Push) {
    const vals = readPush(a);
    if (!vals.some((v) => v.t === "str")) return null;
    return encodePush(vals.map((v) => (v.t === "str" ? { t: "str", v: rn(v.v) } : v)));
  }
  if (a.code === OP.DefineFunction || a.code === OP.DefineFunction2) {
    const b = a.body;
    let [name, p] = cstr(b, 0);
    const parts: Buffer[] = [zstr(rn(name))];
    const n = b.readUInt16LE(p);
    if (a.code === OP.DefineFunction) {
      parts.push(b.subarray(p, p + 2)); p += 2;
      for (let i = 0; i < n; i++) { const [s, q] = cstr(b, p); parts.push(zstr(rn(s))); p = q; }
    } else {
      parts.push(b.subarray(p, p + 5)); p += 5;                      // numParams, registerCount, flags
      for (let i = 0; i < n; i++) {
        const reg = b[p]!;
        parts.push(b.subarray(p, p + 1)); p += 1;
        const [s, q] = cstr(b, p);
        // In a register, the name lives only here: a per-function name is safe.
        parts.push(zstr(reg !== 0 && params?.[i] ? params[i]! : rn(s))); p = q;
      }
    }
    parts.push(b.subarray(p));                                         // codeSize
    return Buffer.concat(parts);
  }
  return null;
}

/**
 * Per-function parameter names, looked up as `paramFor(member, arity)`; the
 * member is the last string pushed before the function (`proto.name = function…`).
 */
export type ParamLookup = (member: string, arity: number) => string[] | null;

/** Re-encodes a code block with new action bodies; jumps and container sizes follow. */
export function renameCode(code: Buffer, rn: (s: string) => string, paramFor: ParamLookup | null = null): Buffer {
  const acts = decode(code);
  let pool: string[] = [], last: string | null = null;
  const bodies = acts.map((a) => {
    if (a.code === OP.ConstantPool) pool = readPool(a);
    if (a.code === OP.Push) {
      try {
        for (const v of readPush(a)) {
          if (v.t === "str") last = v.v;
          else if (v.t === "const") last = pool[v.v] ?? last;
        }
      } catch { /* not a valid push: ignore */ }
    }
    let params: string[] | null = null;
    if (paramFor && a.code === OP.DefineFunction2 && last !== null) {
      const n = a.body.readUInt16LE(cstr(a.body, 0)[1]);
      params = paramFor(last, n);
    }
    return renameBody(a, rn, params) ?? a.body;
  });
  const newSize = acts.map((a, i) => (a.code < 0x80 ? 1 : 3 + bodies[i]!.length));
  const newOff = new Map<number, number>();
  let p = 0;
  acts.forEach((a, i) => { newOff.set(a.offset, p); p += newSize[i]!; });
  newOff.set(code.length, p);
  const at = (old: number) => {
    const v = newOff.get(old);
    if (v === undefined) throw new Error(`jump into the middle of an action at ${old}`);
    return v;
  };
  const out: Buffer[] = [];
  acts.forEach((a, i) => {
    let body = bodies[i]!;
    const start = newOff.get(a.offset)!, end = start + newSize[i]!;
    if (a.code === OP.Jump || a.code === OP.If) {
      body = Buffer.alloc(2);
      body.writeInt16LE(at(a.offset + a.size + a.body.readInt16LE(0)) - end);
    } else if (containerSizes(a).length) {
      let q = a.offset + a.size, qNew = end;
      const sizes = containerSizes(a).map((n) => { const e = at(q + n); const s = e - qNew; q += n; qNew = e; return s; });
      body = withContainerSizes({ ...a, body }, sizes);
    }
    out.push(encodeAction(a.code, body));
  });
  return Buffer.concat(out);
}

/**
 * Renames in every code block and in the class export names. `params` gets
 * the class path (raw parts, from the block's export name) and finds the
 * names of one function's parameters.
 */
export function renameSwf(swf: Swf, rn: (s: string) => string,
                          params: ((classPath: string[], member: string, arity: number) => string[] | null) | null = null) {
  const exported = exportsOf(swf);
  for (const site of codeSites(swf)) {
    const name = site.spriteId !== null ? exported.get(site.spriteId) : undefined;
    const path = name?.startsWith("__Packages.") ? name.slice(11).split(".") : null;
    site.replace(renameCode(site.code, rn, params && path ? (m, n) => params(path, m, n) : null));
  }
  swf.tags.forEach((t, i) => {
    if (t.code !== TAG.ExportAssets) return;
    const n = t.data.readUInt16LE(0);
    const parts: Buffer[] = [t.data.subarray(0, 2)];
    let p = 2;
    for (let k = 0; k < n; k++) {
      parts.push(t.data.subarray(p, p + 2)); p += 2;
      const [s, q] = cstr(t.data, p); p = q;
      parts.push(zstr(s.split(".").map(rn).join(".")));
    }
    swf.tags[i] = { code: t.code, data: Buffer.concat(parts) };
  });
  return renameTimeline(swf, rn);
}

/** Bit reader over a buffer, from byte `p`. */
function bits(b: Buffer, p: number) {
  let bit = p * 8;
  const u = (n: number) => { let v = 0; for (let i = 0; i < n; i++) { v = v * 2 + ((b[bit >> 3]! >> (7 - (bit & 7))) & 1); bit++; } return v; };
  return { u, end: () => Math.ceil(bit / 8) };
}
const skipMatrix = (b: Buffer, p: number) => {
  const r = bits(b, p);
  if (r.u(1)) { const n = r.u(5); r.u(n); r.u(n); }
  if (r.u(1)) { const n = r.u(5); r.u(n); r.u(n); }
  const n = r.u(5); r.u(n); r.u(n);
  return r.end();
};
const skipCxformAlpha = (b: Buffer, p: number) => {
  const r = bits(b, p);
  const add = r.u(1), mult = r.u(1), n = r.u(4);
  if (mult) for (let k = 0; k < 4; k++) r.u(n);
  if (add) for (let k = 0; k < 4; k++) r.u(n);
  return r.end();
};

/** Clip actions (`onClipEvent`) with their code renamed; sizes follow. */
function renameClipActions(b: Buffer, version: number, rn: (s: string) => string): Buffer {
  const fl = version >= 6 ? 4 : 2;
  const parts: Buffer[] = [b.subarray(0, 2 + fl)];
  let p = 2 + fl;
  for (;;) {
    const flags = b.subarray(p, p + fl); p += fl;
    parts.push(flags);
    if (flags.every((x) => x === 0)) break;
    const size = b.readUInt32LE(p); p += 4;
    const keyPress = fl === 4 && (flags[2]! & 0x02) !== 0;
    const key = keyPress ? b.subarray(p, p + 1) : Buffer.alloc(0);
    // Clip actions are obfuscated too, and the clean step only sees DoAction/DoInitAction.
    const raw = b.subarray(p + key.length, p + size);
    const code = renameCode(cleanCode(raw, { folded: 0, realBranches: 0, overlaps: 0, outside: 0 }), rn);
    p += size;
    const n = Buffer.alloc(4); n.writeUInt32LE(key.length + code.length);
    parts.push(n, key, code);
  }
  return Buffer.concat(parts);
}

/**
 * A button's actions (`on(release)`…: DefineButton2's BUTTONCONDACTIONs),
 * cleaned then renamed; record sizes follow. Null: no actions.
 *
 *   ButtonId u16, flags u8, ActionOffset u16 (from this field to the first
 *   record; 0: none), characters…, then records: CondActionSize u16 (from
 *   this field to the next record; 0: last), conditions u16, actions…End.
 */
function renameButtonActions(d: Buffer, rn: (s: string) => string): Buffer | null {
  const offset = d.readUInt16LE(3);
  if (offset === 0) return null;
  let p = 3 + offset;
  const records: Buffer[] = [];
  for (;;) {
    const size = d.readUInt16LE(p);
    const end = size === 0 ? d.length : p + size;
    const cond = d.subarray(p + 2, p + 4);
    const code = renameCode(cleanCode(d.subarray(p + 4, end), { folded: 0, realBranches: 0, overlaps: 0, outside: 0 }), rn);
    records.push(Buffer.concat([cond, code]));
    if (size === 0) break;
    p = end;
  }
  const out: Buffer[] = [d.subarray(0, 3 + offset)];
  records.forEach((r, i) => {
    const n = Buffer.alloc(2);
    n.writeUInt16LE(i === records.length - 1 ? 0 : 2 + r.length);
    out.push(n, r);
  });
  return Buffer.concat(out);
}

/**
 * Names outside the code: instance names (PlaceObject), text field variables,
 * frame labels and clip-action code. The obfuscator renamed them with the
 * code, and the code finds a clip by its instance name.
 */
export function renameTimeline(swf: Swf, rn: (s: string) => string): { renamed: number; skipped: number } {
  let renamed = 0, skipped = 0;
  for (const { tag, replace } of namedTags(swf)) {
    const d = tag.data;
    try {
      if (tag.code === TAG.DefineButton2) {
        const actions = renameButtonActions(d, rn);
        if (actions && !actions.equals(d)) { replace(actions); renamed++; }
      } else if (tag.code === TAG.FrameLabel) {
        const [s, q] = cstr(d, 0);
        const n = rn(s);
        if (n !== s) { replace(Buffer.concat([zstr(n), d.subarray(q)])); renamed++; }
      } else if (tag.code === TAG.DefineEditText) {
        let p = 2;
        p += Math.ceil((5 + 4 * (d[p]! >> 3)) / 8);
        const f1 = d[p]!, f2 = d[p + 1]!; p += 2;
        if (f1 & 0x01) p += 2;                       // font id
        if (f2 & 0x80) p = cstr(d, p)[1];            // font class
        if (f1 & 0x01) p += 2;                       // font height
        if (f1 & 0x04) p += 4;                       // color
        if (f1 & 0x02) p += 2;                       // max length
        if (f2 & 0x20) p += 9;                       // layout
        const [s, q] = cstr(d, p);
        const n = rn(s);
        if (n !== s) { replace(Buffer.concat([d.subarray(0, p), zstr(n), d.subarray(q)])); renamed++; }
      } else {
        const po3 = tag.code === TAG.PlaceObject3;
        const f = d[0]!, f2 = po3 ? d[1]! : 0;
        let p = po3 ? 4 : 3;
        if (po3 && ((f2 & 0x08) || ((f2 & 0x10) && (f & 0x02)))) p = cstr(d, p)[1];
        if (f & 0x02) p += 2;
        if (f & 0x04) p = skipMatrix(d, p);
        if (f & 0x08) p = skipCxformAlpha(d, p);
        if (f & 0x10) p += 2;
        let name: Buffer | null = null, after = p;
        if (f & 0x20) { const [s, q] = cstr(d, p); const n = rn(s); if (n !== s) name = zstr(n); after = q; }
        let tail = d.subarray(after);
        let changed = name !== null;
        if (f & 0x80) {
          if (po3) skipped++;                        // filters before the actions: not handled (none seen)
          else {
            const cd = f & 0x40 ? 2 : 0;
            const actions = renameClipActions(tail.subarray(cd), swf.version, rn);
            if (!actions.equals(tail.subarray(cd))) { tail = Buffer.concat([tail.subarray(0, cd), actions]); changed = true; }
          }
        }
        if (changed) { replace(Buffer.concat([d.subarray(0, p), name ?? d.subarray(p, after), tail])); renamed++; }
      }
    } catch (e) { skipped++; if (process.env.DEOB_DEBUG && skipped <= 5) console.error(tag.code, (e as Error).message, d.subarray(0, 24).toString("hex")); }
  }
  return { renamed, skipped };
}
