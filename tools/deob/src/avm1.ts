/**
 * AVM1 bytecode: decode to a flat list of actions (absolute offsets), and
 * re-encode after edits. Strings are kept as BYTE strings (latin1): obfuscated
 * names are often invalid UTF-8, and they must survive a round trip untouched.
 */

export const OP = {
  End: 0x00, NextFrame: 0x04, Play: 0x06, Stop: 0x07, Add: 0x0a, Subtract: 0x0b, Multiply: 0x0c, Divide: 0x0d,
  Equals: 0x0e, Less: 0x0f, And: 0x10, Or: 0x11, Not: 0x12, StringEquals: 0x13, StringLength: 0x14,
  StringExtract: 0x15, Pop: 0x17, ToInteger: 0x18, GetVariable: 0x1c, SetVariable: 0x1d, SetTarget2: 0x20,
  StringAdd: 0x21, GetProperty: 0x22, SetProperty: 0x23, CloneSprite: 0x24, RemoveSprite: 0x25, Trace: 0x26,
  StartDrag: 0x27, EndDrag: 0x28, StringLess: 0x29, Throw: 0x2a, CastOp: 0x2b, ImplementsOp: 0x2c,
  RandomNumber: 0x30, MBStringLength: 0x31, CharToAscii: 0x32, AsciiToChar: 0x33, GetTime: 0x34,
  MBStringExtract: 0x35, MBCharToAscii: 0x36, MBAsciiToChar: 0x37, Delete: 0x3a, Delete2: 0x3b,
  DefineLocal: 0x3c, CallFunction: 0x3d, Return: 0x3e, Modulo: 0x3f, NewObject: 0x40, DefineLocal2: 0x41,
  InitArray: 0x42, InitObject: 0x43, TypeOf: 0x44, TargetPath: 0x45, Enumerate: 0x46, Add2: 0x47, Less2: 0x48,
  Equals2: 0x49, ToNumber: 0x4a, ToString: 0x4b, PushDuplicate: 0x4c, StackSwap: 0x4d, GetMember: 0x4e,
  SetMember: 0x4f, Increment: 0x50, Decrement: 0x51, CallMethod: 0x52, NewMethod: 0x53, InstanceOf: 0x54,
  Enumerate2: 0x55, BitAnd: 0x60, BitOr: 0x61, BitXor: 0x62, BitLShift: 0x63, BitRShift: 0x64,
  BitURShift: 0x65, StrictEquals: 0x66, Greater: 0x67, StringGreater: 0x68, Extends: 0x69,
  GotoFrame: 0x81, GetURL: 0x83, StoreRegister: 0x87, ConstantPool: 0x88, WaitForFrame: 0x8a, SetTarget: 0x8b,
  GoToLabel: 0x8c, WaitForFrame2: 0x8d, DefineFunction2: 0x8e, Try: 0x8f, With: 0x94, Push: 0x96, Jump: 0x99,
  GetURL2: 0x9a, DefineFunction: 0x9b, If: 0x9d, Call: 0x9e, GotoFrame2: 0x9f,
} as const;

export const OP_NAME: Record<number, string> = Object.fromEntries(Object.entries(OP).map(([k, v]) => [v, k]));

export interface Action {
  /** Absolute offset of the action in the code buffer. */
  offset: number;
  code: number;
  /** Payload (for codes >= 0x80). */
  body: Buffer;
  /** Total encoded size (1 or 3 + body). */
  size: number;
}

/** Decodes a whole code buffer, function bodies included (they are inline in the stream). */
export function decode(code: Buffer): Action[] {
  const out: Action[] = [];
  let p = 0;
  while (p < code.length) {
    const c = code[p]!;
    if (c < 0x80) {
      out.push({ offset: p, code: c, body: Buffer.alloc(0), size: 1 });
      p += 1;
      if (c === 0) { /* End: keep going, obfuscators put code after it */ }
      continue;
    }
    if (p + 3 > code.length) break;
    const len = code.readUInt16LE(p + 1);
    out.push({ offset: p, code: c, body: code.subarray(p + 3, p + 3 + len), size: 3 + len });
    p += 3 + len;
  }
  return out;
}

export const branchTarget = (a: Action) => a.offset + a.size + a.body.readInt16LE(0);

// ——— Strings, constant pool, push ———

export const cstr = (b: Buffer, p: number): [string, number] => {
  const end = b.indexOf(0, p);
  const e = end < 0 ? b.length : end;
  return [b.toString("latin1", p, e), e + 1];
};

export function readPool(a: Action): string[] {
  const n = a.body.readUInt16LE(0);
  const out: string[] = [];
  let p = 2;
  for (let i = 0; i < n && p < a.body.length; i++) { const [s, q] = cstr(a.body, p); out.push(s); p = q; }
  return out;
}

export type PushValue =
  | { t: "str"; v: string } | { t: "num"; v: number } | { t: "bool"; v: boolean }
  | { t: "null" } | { t: "undef" } | { t: "reg"; v: number } | { t: "const"; v: number };

export function readPush(a: Action): PushValue[] {
  const b = a.body, out: PushValue[] = [];
  let p = 0;
  while (p < b.length) {
    const type = b[p++]!;
    switch (type) {
      case 0: { const [s, q] = cstr(b, p); out.push({ t: "str", v: s }); p = q; break; }
      case 1: out.push({ t: "num", v: b.readFloatLE(p) }); p += 4; break;
      case 2: out.push({ t: "null" }); break;
      case 3: out.push({ t: "undef" }); break;
      case 4: out.push({ t: "reg", v: b[p]! }); p += 1; break;
      case 5: out.push({ t: "bool", v: b[p]! !== 0 }); p += 1; break;
      case 6: { // double, word-swapped
        const d = Buffer.from([b[p + 4]!, b[p + 5]!, b[p + 6]!, b[p + 7]!, b[p]!, b[p + 1]!, b[p + 2]!, b[p + 3]!]);
        out.push({ t: "num", v: d.readDoubleLE(0) }); p += 8; break;
      }
      case 7: out.push({ t: "num", v: b.readInt32LE(p) }); p += 4; break;
      case 8: out.push({ t: "const", v: b[p]! }); p += 1; break;
      case 9: out.push({ t: "const", v: b.readUInt16LE(p) }); p += 2; break;
      default: throw new Error(`bad push type ${type} at ${a.offset}`);
    }
  }
  return out;
}

export function encodePush(values: PushValue[]): Buffer {
  const parts: Buffer[] = [];
  for (const v of values) {
    switch (v.t) {
      case "str": parts.push(Buffer.from([0]), Buffer.from(v.v, "latin1"), Buffer.from([0])); break;
      case "num": {
        if (Number.isInteger(v.v) && v.v >= -0x80000000 && v.v <= 0x7fffffff && !Object.is(v.v, -0)) {
          const b = Buffer.alloc(5); b[0] = 7; b.writeInt32LE(v.v, 1); parts.push(b);
        } else {
          const d = Buffer.alloc(8); d.writeDoubleLE(v.v);
          parts.push(Buffer.from([6, d[4]!, d[5]!, d[6]!, d[7]!, d[0]!, d[1]!, d[2]!, d[3]!]));
        }
        break;
      }
      case "null": parts.push(Buffer.from([2])); break;
      case "undef": parts.push(Buffer.from([3])); break;
      case "reg": parts.push(Buffer.from([4, v.v])); break;
      case "bool": parts.push(Buffer.from([5, v.v ? 1 : 0])); break;
      case "const": parts.push(v.v < 256 ? Buffer.from([8, v.v]) : Buffer.from([9, v.v & 0xff, v.v >> 8])); break;
    }
  }
  return Buffer.concat(parts);
}

// ——— Containers: function bodies, with, try ———

/** Byte size of the inline block(s) that follow a container action. */
export function containerSizes(a: Action): number[] {
  const b = a.body;
  if (a.code === OP.DefineFunction) {
    let p = cstr(b, 0)[1];
    const n = b.readUInt16LE(p); p += 2;
    for (let i = 0; i < n; i++) p = cstr(b, p)[1];
    return [b.readUInt16LE(p)];
  }
  if (a.code === OP.DefineFunction2) {
    let p = cstr(b, 0)[1];
    const n = b.readUInt16LE(p); p += 2 + 1 + 2;
    for (let i = 0; i < n; i++) { p += 1; p = cstr(b, p)[1]; }
    return [b.readUInt16LE(p)];
  }
  if (a.code === OP.With) return [b.readUInt16LE(0)];
  if (a.code === OP.Try) return [b.readUInt16LE(1), b.readUInt16LE(3), b.readUInt16LE(5)];
  return [];
}

/** Rewrites the size fields of a container's body (same order as containerSizes). */
export function withContainerSizes(a: Action, sizes: number[]): Buffer {
  const b = Buffer.from(a.body);
  if (a.code === OP.DefineFunction) {
    let p = cstr(b, 0)[1];
    const n = b.readUInt16LE(p); p += 2;
    for (let i = 0; i < n; i++) p = cstr(b, p)[1];
    b.writeUInt16LE(sizes[0]!, p);
  } else if (a.code === OP.DefineFunction2) {
    let p = cstr(b, 0)[1];
    const n = b.readUInt16LE(p); p += 2 + 1 + 2;
    for (let i = 0; i < n; i++) { p += 1; p = cstr(b, p)[1]; }
    b.writeUInt16LE(sizes[0]!, p);
  } else if (a.code === OP.With) b.writeUInt16LE(sizes[0]!, 0);
  else if (a.code === OP.Try) { b.writeUInt16LE(sizes[0]!, 1); b.writeUInt16LE(sizes[1]!, 3); b.writeUInt16LE(sizes[2]!, 5); }
  return b;
}

/** Function name and parameter names (DefineFunction / DefineFunction2). */
export function functionInfo(a: Action): { name: string; params: string[] } {
  const b = a.body;
  let [name, p] = cstr(b, 0);
  const n = b.readUInt16LE(p); p += 2;
  const params: string[] = [];
  if (a.code === OP.DefineFunction2) p += 3;
  for (let i = 0; i < n; i++) {
    if (a.code === OP.DefineFunction2) p += 1;
    const [s, q] = cstr(b, p); params.push(s); p = q;
  }
  return { name, params };
}

export function encodeAction(code: number, body: Buffer): Buffer {
  if (code < 0x80) return Buffer.from([code]);
  const h = Buffer.alloc(3); h[0] = code; h.writeUInt16LE(body.length, 1);
  return Buffer.concat([h, body]);
}
