/**
 * SWF container: header, tags, nested sprite tags. Only what the deobfuscator
 * needs — action-carrying tags are located and can be replaced in place.
 */
import { deflateSync, inflateSync } from "node:zlib";

export interface Tag { code: number; data: Buffer }
export interface Swf { version: number; compressed: boolean; header: Buffer; tags: Tag[] }

export const TAG = { End: 0, ShowFrame: 1, DoAction: 12, DefineSprite: 39, DoInitAction: 59, ExportAssets: 56,
  PlaceObject2: 26, PlaceObject3: 70, DefineEditText: 37, FrameLabel: 43, DefineButton2: 34 } as const;

function readTags(b: Buffer, p: number, end: number): Tag[] {
  const tags: Tag[] = [];
  while (p + 2 <= end) {
    const h = b.readUInt16LE(p); p += 2;
    const code = h >> 6;
    let len = h & 0x3f;
    if (len === 0x3f) { len = b.readUInt32LE(p); p += 4; }
    tags.push({ code, data: b.subarray(p, p + len) });
    p += len;
    if (code === TAG.End) break;
  }
  return tags;
}

function writeTags(tags: Tag[]): Buffer {
  const parts: Buffer[] = [];
  for (const t of tags) {
    // Long form always for action tags: lengths change when code is rewritten.
    if (t.data.length < 0x3f && t.code !== TAG.DoAction && t.code !== TAG.DoInitAction) {
      const h = Buffer.alloc(2); h.writeUInt16LE((t.code << 6) | t.data.length); parts.push(h, t.data);
    } else {
      const h = Buffer.alloc(6); h.writeUInt16LE((t.code << 6) | 0x3f); h.writeUInt32LE(t.data.length, 2); parts.push(h, t.data);
    }
  }
  return Buffer.concat(parts);
}

export function parseSwf(raw: Buffer): Swf {
  const sig = raw.toString("latin1", 0, 3);
  if (sig !== "FWS" && sig !== "CWS") throw new Error(`unsupported SWF signature ${sig}`);
  const body = sig === "CWS" ? inflateSync(raw.subarray(8)) : raw.subarray(8);
  // RECT: 5 bits of size then 4 fields; then frame rate and count.
  const nbits = body[0]! >> 3;
  const rectBytes = Math.ceil((5 + 4 * nbits) / 8);
  const headerLen = rectBytes + 4;
  return { version: raw[3]!, compressed: sig === "CWS", header: Buffer.from(body.subarray(0, headerLen)), tags: readTags(body, headerLen, body.length) };
}

export function writeSwf(swf: Swf): Buffer {
  const body = Buffer.concat([swf.header, writeTags(swf.tags)]);
  const head = Buffer.alloc(8);
  head.write(swf.compressed ? "CWS" : "FWS", 0, "latin1");
  head[3] = swf.version;
  head.writeUInt32LE(body.length + 8, 4);
  return Buffer.concat([head, swf.compressed ? deflateSync(body, { level: 9 }) : body]);
}

/** A piece of AVM1 code inside the SWF, with a way to put new bytecode back. */
export interface CodeSite {
  /** "DoInitAction(sprite 123)", "DoAction(sprite 45, frame 2)"… */
  where: string;
  /** For DoInitAction: the sprite it initializes. */
  spriteId: number | null;
  code: Buffer;
  replace(code: Buffer): void;
}

/** Every DoAction / DoInitAction, at the root and inside sprites. */
export function codeSites(swf: Swf): CodeSite[] {
  const out: CodeSite[] = [];
  const visit = (tags: Tag[], owner: string, rebuild: () => void) => {
    let frame = 1;
    tags.forEach((t, i) => {
      if (t.code === TAG.ShowFrame) frame++;
      if (t.code === TAG.DoAction) {
        out.push({ where: `DoAction(${owner}, frame ${frame})`, spriteId: null, code: t.data,
          replace: (c) => { tags[i] = { code: t.code, data: c }; rebuild(); } });
      } else if (t.code === TAG.DoInitAction) {
        const id = t.data.readUInt16LE(0);
        out.push({ where: `DoInitAction(sprite ${id})`, spriteId: id, code: t.data.subarray(2),
          replace: (c) => { const h = Buffer.alloc(2); h.writeUInt16LE(id); tags[i] = { code: t.code, data: Buffer.concat([h, c]) }; rebuild(); } });
      } else if (t.code === TAG.DefineSprite) {
        const id = t.data.readUInt16LE(0);
        const inner = readTags(t.data, 4, t.data.length);
        const head = t.data.subarray(0, 4);
        visit(inner, `sprite ${id}`, () => { tags[i] = { code: t.code, data: Buffer.concat([head, writeTags(inner)]) }; rebuild(); });
      }
    });
  };
  visit(swf.tags, "root", () => {});
  return out;
}

/** Exported linkage names, by character id — as BYTES (latin1), like every name here. */
export function exportsOf(swf: Swf): Map<number, string> {
  const out = new Map<number, string>();
  for (const t of swf.tags) {
    if (t.code !== TAG.ExportAssets) continue;
    const n = t.data.readUInt16LE(0);
    let p = 2;
    for (let i = 0; i < n; i++) {
      const id = t.data.readUInt16LE(p); p += 2;
      const end = t.data.indexOf(0, p);
      out.set(id, t.data.toString("latin1", p, end)); p = end + 1;
    }
  }
  return out;
}

/** A tag that carries names or code outside DoAction/DoInitAction (instance names, text variables, frame labels, clip and button actions). */
export interface NamedTag { tag: Tag; replace(data: Buffer): void }

/** Every PlaceObject2/3, DefineEditText and FrameLabel, at the root and inside sprites. */
export function namedTags(swf: Swf): NamedTag[] {
  const out: NamedTag[] = [];
  const kinds: number[] = [TAG.PlaceObject2, TAG.PlaceObject3, TAG.DefineEditText, TAG.FrameLabel, TAG.DefineButton2];
  const visit = (tags: Tag[], rebuild: () => void) => {
    tags.forEach((t, i) => {
      if (kinds.includes(t.code)) out.push({ tag: t, replace: (d) => { tags[i] = { code: t.code, data: d }; rebuild(); } });
      else if (t.code === TAG.DefineSprite) {
        const inner = readTags(t.data, 4, t.data.length);
        const head = t.data.subarray(0, 4);
        visit(inner, () => { tags[i] = { code: t.code, data: Buffer.concat([head, writeTags(inner)]) }; rebuild(); });
      }
    });
  };
  visit(swf.tags, () => {});
  return out;
}
