/**
 * Control-flow cleaning of obfuscated AVM1.
 *
 * The obfuscator buries real code under opaque predicates (`!true`,
 * `ord("x")`, `getTimer()+1` — constant once evaluated), jumps into the
 * middle of instructions, and dead code after `End`. A linear disassembly is
 * wrong; we follow the control flow from the entry like an x86 disassembler,
 * evaluate those predicates on a small local stack model, and re-emit only
 * the reachable code, in order, with recomputed jumps.
 */
import { OP, branchTarget, containerSizes, encodeAction, encodePush, readPush, withContainerSizes, type Action, type PushValue } from "./avm1.ts";

/** Abstract value: a known constant, "truthy but unknown" (getTimer()…), or unknown. */
type V = { k: "const"; v: string | number | boolean | null | undefined } | { k: "truthy" } | { k: "unknown" };
const UNKNOWN: V = { k: "unknown" };

const truthy = (v: V): boolean | null => {
  if (v.k === "truthy") return true;
  if (v.k === "unknown") return null;
  const x = v.v;
  if (typeof x === "string") return x.length > 0;   // AVM1 (SWF7+): non-empty string is true
  return Boolean(x);
};

const num = (v: V): number | null => {
  if (v.k !== "const") return null;
  const x = v.v;
  if (typeof x === "number") return x;
  if (typeof x === "boolean") return x ? 1 : 0;
  if (x === null || x === undefined) return 0;
  const n = Number(x);
  return Number.isNaN(n) ? null : n;
};

/** Binary operator on the stack model: constants are computed; a few identities hold on unknowns. */
function binary(code: number, x: V, y: V): V {
  const tx = truthy(x), ty = truthy(y);
  // Legacy logical ops (SWF4): numeric result 1/0.
  if (code === OP.And) return tx === false || ty === false ? { k: "const", v: false } : tx && ty ? { k: "const", v: true } : UNKNOWN;
  if (code === OP.Or) return tx === true || ty === true ? { k: "const", v: true } : tx === false && ty === false ? { k: "const", v: false } : UNKNOWN;
  // `v & v` / `v | v` of the same truthy unknown (PushDuplicate) stays truthy.
  if ((code === OP.BitAnd || code === OP.BitOr) && x === y && x.k === "truthy") return x;
  const a = num(x), b = num(y);
  if (a === null || b === null) return UNKNOWN;
  if (x.k === "const" && y.k === "const") {
    switch (code) {
      case OP.Add2: case OP.Add:
        return typeof x.v === "string" || typeof y.v === "string" ? (code === OP.Add2 ? { k: "const", v: String(x.v) + String(y.v) } : { k: "const", v: a + b }) : { k: "const", v: a + b };
      case OP.Subtract: return { k: "const", v: a - b };
      case OP.Multiply: return { k: "const", v: a * b };
      case OP.Modulo: return { k: "const", v: a % b };
      case OP.BitAnd: return { k: "const", v: (a & b) };
      case OP.BitOr: return { k: "const", v: (a | b) };
      case OP.BitXor: return { k: "const", v: (a ^ b) };
      case OP.BitLShift: return { k: "const", v: a << b };
      case OP.BitRShift: return { k: "const", v: a >> b };
      case OP.BitURShift: return { k: "const", v: a >>> b };
      case OP.Equals2: case OP.Equals: return { k: "const", v: x.v === y.v || a === b };
      case OP.StrictEquals: return { k: "const", v: x.v === y.v };
      case OP.Less2: case OP.Less: return { k: "const", v: a < b };
      case OP.Greater: return { k: "const", v: a > b };
    }
  }
  return UNKNOWN;
}

export interface CleanStats { folded: number; realBranches: number; overlaps: number; outside: number }

/** One decoded instruction at a given offset of the code buffer. */
function decodeAt(buf: Buffer, p: number): Action | null {
  if (p < 0 || p >= buf.length) return null;
  const c = buf[p]!;
  if (c < 0x80) return { offset: p, code: c, body: Buffer.alloc(0), size: 1 };
  if (p + 3 > buf.length) return null;
  const len = buf.readUInt16LE(p + 1);
  if (p + 3 + len > buf.length) return null;
  return { offset: p, code: c, body: buf.subarray(p + 3, p + 3 + len), size: 3 + len };
}

/** Emitted instruction before layout: jumps refer to other emitted items by key. */
type Item =
  | { kind: "raw"; code: number; body: Buffer; key?: number }
  | { kind: "jump"; op: number; to: number; key?: number }               // Jump / If to an original offset
  | { kind: "container"; code: number; head: Action; parts: Buffer[]; key?: number };

const pushValues = (a: Action): PushValue[] | null => { try { return readPush(a); } catch { return null; } };

/** Cleans the region [start, end) of `buf` (a whole code block, or a function body). */
/** How blocks are laid out: chains (LIFO or FIFO pending branches), or original address order. */
export type Layout = "lifo" | "fifo" | "address";

export function cleanRegion(buf: Buffer, start: number, end: number, stats: CleanStats, mode: Layout = "lifo"): Buffer {
  type Node = { a: Action; next: number | null; target: number | null; fold: "always" | "never" | null; parts?: Buffer[] };
  const nodes = new Map<number, Node>();
  const work: { at: number; stack: V[] }[] = [{ at: start, stack: [] }];

  while (work.length) {
    let { at, stack } = work.pop()!;
    stack = [...stack];
    for (;;) {
      if (at === end) break;                                  // falls off the region: implicit end
      if (at < start || at > end) { stats.outside++; break; }
      if (nodes.has(at)) break;
      const a = decodeAt(buf, at);
      if (!a || a.offset + a.size > end) { stats.outside++; break; }
      const node: Node = { a, next: at + a.size, target: null, fold: null };
      nodes.set(at, node);
      const pop = (): V => stack.pop() ?? UNKNOWN;
      switch (a.code) {
        case OP.Push: {
          const vals = pushValues(a);
          if (!vals) { stack = []; break; }
          for (const v of vals) {
            if (v.t === "str") stack.push({ k: "const", v: v.v });
            else if (v.t === "num") stack.push({ k: "const", v: v.v });
            else if (v.t === "bool") stack.push({ k: "const", v: v.v });
            else if (v.t === "null") stack.push({ k: "const", v: null });
            else if (v.t === "undef") stack.push({ k: "const", v: undefined });
            else stack.push(UNKNOWN);
          }
          break;
        }
        case OP.Not: { const t = truthy(pop()); stack.push(t === null ? UNKNOWN : { k: "const", v: !t }); break; }
        case OP.CharToAscii: case OP.MBCharToAscii: {
          const v = pop();
          stack.push(v.k === "const" && typeof v.v === "string" && v.v.length ? { k: "const", v: v.v.charCodeAt(0) } : UNKNOWN);
          break;
        }
        case OP.GetTime: stack.push({ k: "truthy" }); break;      // ms since start: never 0 in practice
        case OP.Increment: {
          const v = pop();
          stack.push(v.k === "truthy" ? v : v.k === "const" && typeof v.v === "number" ? { k: "const", v: v.v + 1 } : UNKNOWN);
          break;
        }
        case OP.And: case OP.Or: case OP.Add2: case OP.Add: case OP.Subtract: case OP.Multiply: case OP.Modulo:
        case OP.BitAnd: case OP.BitOr: case OP.BitXor: case OP.BitLShift: case OP.BitRShift: case OP.BitURShift:
        case OP.Equals2: case OP.Equals: case OP.StrictEquals: case OP.Less2: case OP.Less: case OP.Greater: {
          const b = pop(), x = pop();
          stack.push(binary(a.code, x, b));
          break;
        }
        case OP.ToNumber: case OP.ToInteger: case OP.Decrement: {
          const v = pop();
          if (v.k === "const" && typeof v.v === "number") stack.push({ k: "const", v: a.code === OP.Decrement ? v.v - 1 : a.code === OP.ToInteger ? Math.trunc(v.v) : v.v });
          else stack.push(a.code === OP.Decrement ? UNKNOWN : v.k === "truthy" ? v : UNKNOWN);
          break;
        }
        case OP.Pop: pop(); break;
        case OP.PushDuplicate: { const v = pop(); stack.push(v, v); break; }
        case OP.StackSwap: { const x = pop(), y = pop(); stack.push(x, y); break; }
        case OP.If: {
          node.target = branchTarget(a);
          const t = truthy(pop());
          if (t === true) { node.fold = "always"; node.next = null; stats.folded++; }
          else if (t === false) { node.fold = "never"; node.target = null; stats.folded++; }
          else { stats.realBranches++; work.push({ at: node.target, stack: [...stack] }); }
          break;
        }
        case OP.Jump: node.target = branchTarget(a); node.next = null; break;
        case OP.End: case OP.Return: case OP.Throw: node.next = null; break;
        case OP.DefineFunction: case OP.DefineFunction2: case OP.With: case OP.Try: {
          // Inline blocks follow the header: each is its own region.
          const sizes = containerSizes(a);
          let p = at + a.size;
          node.parts = sizes.map((n) => { const part = cleanRegion(buf, p, p + n, stats, mode); p += n; return part; });
          node.next = p;
          stack = [];
          break;
        }
        default: stack = [];                                     // effect not modelled: forget the stack
      }
      if (node.fold === "always") { at = node.target!; continue; }
      if (node.next === null) {
        if (node.target !== null) { at = node.target; continue; }
        break;
      }
      at = node.next;
    }
  }

  const order = [...nodes.keys()].sort((x, y) => x - y);
  for (let i = 1; i < order.length; i++) {
    const prev = nodes.get(order[i - 1]!)!;
    if (prev.a.offset + prev.a.size > order[i]!) stats.overlaps++;
  }

  // Emit by CHAINS: each instruction is followed by its successor whenever it
  // hasn't been placed yet — the scattered blocks come back in execution
  // order, and unconditional jumps vanish. Real branch targets wait their turn.
  const items: Item[] = [];
  const placed = new Set<number>();
  // Address order (fallback): the original distances, so jumps stay in range.
  const pending: number[] = mode === "address" ? [...order].reverse() : [start];
  const zero = (key: number): Item => ({ kind: "raw", code: -1, body: Buffer.alloc(0), key });
  while (pending.length) {
    let at: number | null = mode === "fifo" ? pending.shift()! : pending.pop()!;
    while (at !== null && !placed.has(at) && nodes.has(at)) {
      placed.add(at);
      const n = nodes.get(at)!, a = n.a;
      let succ: number | null = n.next;
      if (a.code === OP.If && n.fold) {
        items.push({ kind: "raw", code: OP.Pop, body: Buffer.alloc(0), key: at });
        succ = n.fold === "always" ? n.target! : n.next;
      } else if (a.code === OP.If) {
        items.push({ kind: "jump", op: OP.If, to: n.target!, key: at });
        pending.push(n.target!);
      } else if (a.code === OP.Jump) {
        items.push(zero(at));
        succ = n.target!;
      } else if (a.code === OP.End) {
        // An End inside the code would stop a decompiler: jump to the end instead.
        items.push({ kind: "jump", op: OP.Jump, to: end, key: at });
        succ = null;
      } else if (n.parts) items.push({ kind: "container", code: a.code, head: a, parts: n.parts, key: at });
      else items.push({ kind: "raw", code: a.code, body: a.body, key: at });
      if (succ === null) break;
      if (succ === end || placed.has(succ) || !nodes.has(succ)) {
        items.push({ kind: "jump", op: OP.Jump, to: succ });
        break;
      }
      at = succ;
    }
  }
  // Original offsets something jumps to: their instruction must keep a position.
  const targets = new Set(items.flatMap((it) => (it.kind === "jump" ? [it.to] : [])));
  return layout(peephole(items, targets), end);
}

const PURE_BINARY = new Set<number>([OP.And, OP.Or, OP.BitAnd, OP.BitOr, OP.BitXor, OP.Equals2, OP.StrictEquals, OP.Less2, OP.Greater]);

/** Removes what the folded predicates leave behind: values pushed only to be popped. */
function peephole(items: Item[], jumpedTo: Set<number>): Item[] {
  let changed = true;
  let out = items;
  const isRaw = (x: Item | undefined, code: number): x is Item & { kind: "raw" } => !!x && x.kind === "raw" && x.code === code;
  while (changed) {
    changed = false;
    // Position markers nobody jumps to only get in the way of the patterns below.
    out = out.filter((it) => !(it.kind === "raw" && it.code === -1 && !(it.key !== undefined && jumpedTo.has(it.key))));
    const res: Item[] = [];
    for (let i = 0; i < out.length; i++) {
      const x = out[i]!, y = out[i + 1], z = out[i + 2];
      // An item someone jumps to can't be merged away (its key must survive).
      const target = (it: Item | undefined) => it?.key !== undefined && jumpedTo.has(it.key);
      // `<pure producer> Pop` → nothing (or the producer's other pushes).
      if (x.kind === "raw" && x.code === OP.Push && isRaw(y, OP.Pop) && !target(y)) {
        const vals = (() => { try { return readPush({ offset: 0, code: OP.Push, body: x.body, size: 0 }); } catch { return null; } })();
        if (vals && vals.length) {
          vals.pop();
          if (vals.length) res.push({ ...x, body: encodePush(vals) });
          else if (x.key !== undefined) res.push({ kind: "raw", code: -1, body: Buffer.alloc(0), key: x.key });
          i++; changed = true; continue;
        }
      }
      // `<unary pure op> Pop` → `Pop` (the op's input is dropped instead).
      if (x.kind === "raw" && [OP.Not, OP.CharToAscii, OP.MBCharToAscii, OP.Increment, OP.ToNumber, OP.ToInteger].includes(x.code as never) && isRaw(y, OP.Pop) && !target(y)) {
        res.push({ kind: "raw", code: OP.Pop, body: Buffer.alloc(0), key: x.key }); i++; changed = true; continue;
      }
      // `<binary pure op> Pop` → `Pop Pop` (both operands dropped); `PushDuplicate Pop` → nothing.
      if (x.kind === "raw" && PURE_BINARY.has(x.code) && isRaw(y, OP.Pop) && !target(y)) {
        res.push({ kind: "raw", code: OP.Pop, body: Buffer.alloc(0), key: x.key }, { kind: "raw", code: OP.Pop, body: Buffer.alloc(0) });
        i++; changed = true; continue;
      }
      if (isRaw(x, OP.PushDuplicate) && isRaw(y, OP.Pop) && !target(y)) {
        if (x.key !== undefined) res.push({ kind: "raw", code: -1, body: Buffer.alloc(0), key: x.key });
        i++; changed = true; continue;
      }
      // `GetTime Pop` → nothing.
      if (isRaw(x, OP.GetTime) && isRaw(y, OP.Pop) && !target(y)) {
        if (x.key !== undefined) res.push({ kind: "raw", code: -1, body: Buffer.alloc(0), key: x.key });
        i++; changed = true; continue;
      }
      void z;
      res.push(x);
    }
    out = res;
  }
  return out;
}

/** Assigns offsets, resolves jump targets (original offsets → new), encodes. */
function layout(items: Item[], end: number): Buffer {
  const size = (it: Item) => it.kind === "jump" ? 5
    : it.kind === "container" ? 3 + withContainerSizes(it.head, it.parts.map((p) => p.length)).length + it.parts.reduce((s, p) => s + p.length, 0)
    : it.code === -1 ? 0 : it.code < 0x80 ? 1 : 3 + it.body.length;
  /** Items after which execution never falls through: a relay jump can sit there. */
  const barrier = (it: Item) => (it.kind === "jump" && it.op === OP.Jump) || (it.kind === "raw" && (it.code === OP.Return || it.code === OP.Throw));
  const MAX = 32767;
  let relays = -1;
  for (let round = 0; ; round++) {
    const at = new Map<number, number>();
    const pos: number[] = [];
    let p = 0;
    for (const it of items) { pos.push(p); if (it.key !== undefined && !at.has(it.key)) at.set(it.key, p); p += size(it); }
    const total = p;
    const resolve = (orig: number) => (orig === end ? total : at.get(orig) ?? total);
    // A jump out of range: retarget it to a relay placed after a barrier, between it and its target.
    const far = items.findIndex((it, i) => it.kind === "jump" && Math.abs(resolve(it.to) - (pos[i]! + 5)) > MAX);
    if (far >= 0) {
      if (round > 500) throw new RangeError("relay jumps don't converge");
      const j = items[far] as Item & { kind: "jump" };
      const from = pos[far]! + 5, to = resolve(j.to), mid = (from + to) / 2;
      let best = -1;
      items.forEach((it, i) => {
        if (!barrier(it) || i === far) return;
        const q = pos[i]! + size(it);
        if (Math.abs(q - from) > MAX - 16 || Math.abs(to - (q + 5)) > MAX - 16) return;
        if (best < 0 || Math.abs(q - mid) < Math.abs(pos[best]! + size(items[best]!) - mid)) best = i;
      });
      if (best < 0) throw new RangeError("no place for a relay jump");
      const key = relays--;
      items.splice(best + 1, 0, { kind: "jump", op: OP.Jump, to: j.to, key });
      j.to = key;
      continue;
    }
    const parts: Buffer[] = [];
    items.forEach((it, i) => {
      if (it.kind === "jump") {
        const b = Buffer.alloc(2); b.writeInt16LE(resolve(it.to) - (pos[i]! + 5)); parts.push(encodeAction(it.op, b));
      } else if (it.kind === "container") {
        parts.push(encodeAction(it.code, withContainerSizes(it.head, it.parts.map((x) => x.length))), ...it.parts);
      } else if (it.code !== -1) parts.push(encodeAction(it.code, it.body));
    });
    return Buffer.concat(parts);
  }
}

/** A whole DoAction / DoInitAction body. */
export function cleanCode(code: Buffer, stats: CleanStats): Buffer {
  // A jump over 32 KB can't be encoded: try another layout.
  for (const mode of ["lifo", "fifo", "address"] as const) {
    const st: CleanStats = { folded: 0, realBranches: 0, overlaps: 0, outside: 0 };
    try {
      const out = cleanRegion(code, 0, code.length, st, mode);
      for (const k of Object.keys(st) as (keyof CleanStats)[]) stats[k] += st[k];
      return Buffer.concat([out, Buffer.from([OP.End])]);
    } catch (e) { if (!(e instanceof RangeError)) throw e; }
  }
  throw new Error("no layout keeps every jump within 32 KB");
}
