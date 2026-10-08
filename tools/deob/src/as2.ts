/**
 * Reads FFDec's AS2 class exports into classes, members and token streams.
 *
 * Obfuscated identifiers come out as `§\x1b\r\x04§` (declarations) or
 * `["\x1b\r\x04"]` (member access): both become identifier tokens holding the
 * RAW bytes (latin1 string), so they can be renamed in the bytecode later.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

export interface Tok { t: "id" | "str" | "num" | "p"; v: string }
export interface Member {
  kind: "var" | "static var" | "function" | "static function";
  name: string;
  params: string[];
  /** Initializer (vars) or body (functions). */
  body: Tok[];
}
export interface Cls { file: string; path: string[]; ext: string[] | null; members: Member[]; tokens: Tok[] }

const IDENT = /^[A-Za-z_$][A-Za-z0-9_$]*$/;
/** An identifier the obfuscator renamed (control characters, invalid UTF-8…), or a placeholder given to one. */
export const isObf = (s: string) => !IDENT.test(s) || PLACEHOLDER.test(s);
/** Names given by rename.ts to ids nobody recognized: `_o` + hex bytes. */
export const PLACEHOLDER = /^_o(?:[0-9a-f]{2}){1,8}$/;

/** FFDec escapes back to bytes: \xNN, \r, \n, \t, \b, \f, \\, \", \', {invalid_utf8=NNN}. */
export function unescapeFfdec(s: string): string {
  let out = "";
  for (let i = 0; i < s.length; i++) {
    const c = s[i]!;
    if (c === "{" && s.startsWith("{invalid_utf8=", i)) {
      const end = s.indexOf("}", i);
      out += String.fromCharCode(Number(s.slice(i + 14, end)));
      i = end;
      continue;
    }
    if (c !== "\\") {
      // A raw non-ASCII char of the file (UTF-8 decoded) back to its bytes.
      const code = c.charCodeAt(0);
      out += code < 0x80 ? c : Buffer.from(c, "utf8").toString("latin1");
      continue;
    }
    const n = s[++i]!;
    if (n === "x") { out += String.fromCharCode(parseInt(s.slice(i + 1, i + 3), 16)); i += 2; }
    else out += ({ r: "\r", n: "\n", t: "\t", b: "\b", f: "\f", v: "\v", "0": "\0" } as Record<string, string>)[n] ?? n;
  }
  return out;
}

export function tokenize(src: string): Tok[] {
  const toks: Tok[] = [];
  let i = 0;
  const n = src.length;
  while (i < n) {
    const c = src[i]!;
    if (c === " " || c === "\t" || c === "\r" || c === "\n") { i++; continue; }
    if (c === "/" && src[i + 1] === "/") { while (i < n && src[i] !== "\n") i++; continue; }
    if (c === "/" && src[i + 1] === "*") { const e = src.indexOf("*/", i + 2); i = e < 0 ? n : e + 2; continue; }
    if (c === "§") {                                   // §§push / §§pop, or §name§
      if (src[i + 1] === "§") { let j = i + 2; while (j < n && /[A-Za-z]/.test(src[j]!)) j++; toks.push({ t: "id", v: src.slice(i, j) }); i = j; continue; }
      let j = i + 1;
      while (j < n && src[j] !== "§") { if (src[j] === "\\") j++; j++; }
      toks.push({ t: "id", v: unescapeFfdec(src.slice(i + 1, j)) });
      i = j + 1;
      continue;
    }
    if (c === '"' || c === "'") {
      let j = i + 1;
      while (j < n && src[j] !== c) { if (src[j] === "\\") j++; j++; }
      toks.push({ t: "str", v: unescapeFfdec(src.slice(i + 1, j)) });
      i = j + 1;
      continue;
    }
    if (/[0-9]/.test(c) || (c === "." && /[0-9]/.test(src[i + 1] ?? ""))) {
      let j = i + 1;
      while (j < n && /[0-9A-Fa-fxX.eE]/.test(src[j]!)) j++;
      toks.push({ t: "num", v: src.slice(i, j) });
      i = j;
      continue;
    }
    if (/[A-Za-z_$]/.test(c)) {
      let j = i + 1;
      while (j < n && /[A-Za-z0-9_$]/.test(src[j]!)) j++;
      toks.push({ t: "id", v: src.slice(i, j) });
      i = j;
      continue;
    }
    const three = src.slice(i, i + 3), two = src.slice(i, i + 2);
    const op = ["===", "!==", ">>>", "<<=", ">>="].includes(three) ? three
      : ["==", "!=", "<=", ">=", "&&", "||", "++", "--", "+=", "-=", "*=", "/=", "<<", ">>", "|=", "&="].includes(two) ? two : c;
    toks.push({ t: "p", v: op });
    i += op.length;
  }
  // `x["\x1b\r"]` → `x . <id>` when the string is an obfuscated name: the same shape as `x.name`.
  const out: Tok[] = [];
  for (let k = 0; k < toks.length; k++) {
    const a = toks[k]!, b = toks[k + 1], d = toks[k + 2];
    if (a.t === "p" && a.v === "[" && b?.t === "str" && isObf(b.v) && b.v.length > 0 && d?.t === "p" && d.v === "]" && out.length) {
      out.push({ t: "p", v: "." }, { t: "id", v: b.v });
      k += 2;
      continue;
    }
    out.push(a);
  }
  return out;
}

/** Dotted name starting at toks[i]: returns the parts and the index after. */
function dotted(toks: Tok[], i: number): [string[], number] {
  const parts: string[] = [];
  while (toks[i]?.t === "id") {
    parts.push(toks[i]!.v);
    if (toks[i + 1]?.t === "p" && toks[i + 1]!.v === ".") i += 2; else { i++; break; }
  }
  return [parts, i];
}

export function parseClass(file: string, src: string): Cls | null {
  const toks = tokenize(src);
  let i = toks.findIndex((t) => t.t === "id" && (t.v === "class" || t.v === "interface"));
  if (i < 0) return null;
  const [path, j] = dotted(toks, i + 1);
  i = j;
  let ext: string[] | null = null;
  if (toks[i]?.v === "extends") { [ext, i] = dotted(toks, i + 1); }
  while (toks[i] && toks[i]!.v !== "{") i++;
  i++;
  const members: Member[] = [];
  while (i < toks.length && toks[i]!.v !== "}") {
    let isStatic = false;
    while (["static", "private", "public"].includes(toks[i]?.v ?? "")) { if (toks[i]!.v === "static") isStatic = true; i++; }
    const kw = toks[i]?.v;
    if (kw === "var") {
      const name = toks[i + 1]!.v;
      i += 2;
      const body: Tok[] = [];
      if (toks[i]?.v === ":") i += 2;
      if (toks[i]?.v === "=") { i++; let depth = 0; while (i < toks.length && !(depth === 0 && toks[i]!.v === ";")) { const v = toks[i]!.v; if ("([{".includes(v)) depth++; if (")]}".includes(v)) depth--; body.push(toks[i]!); i++; } }
      while (toks[i] && toks[i]!.v !== ";") i++;
      i++;
      members.push({ kind: isStatic ? "static var" : "var", name, params: [], body });
    } else if (kw === "function") {
      i++;
      // get/set accessors: `function get name()`
      if ((toks[i]?.v === "get" || toks[i]?.v === "set") && toks[i + 1]?.t === "id" && toks[i + 2]?.v === "(") i++;
      const name = toks[i]!.v;
      i++;
      const params: string[] = [];
      if (toks[i]?.v === "(") {
        i++;
        while (toks[i] && toks[i]!.v !== ")") { if (toks[i]!.t === "id" && toks[i + 1]?.v !== ":") params.push(toks[i]!.v); else if (toks[i]!.t === "id" && toks[i + 1]?.v === ":") { params.push(toks[i]!.v); i += 2; continue; } i++; }
        i++;
      }
      if (toks[i]?.v === ":") i += 2;
      const body: Tok[] = [];
      if (toks[i]?.v === "{") {
        let depth = 0;
        do { const v = toks[i]!.v; if (v === "{") depth++; if (v === "}") depth--; body.push(toks[i]!); i++; } while (i < toks.length && depth > 0);
      } else if (toks[i]?.v === ";") i++;
      members.push({ kind: isStatic ? "static function" : "function", name, params, body });
    } else i++;
  }
  return { file, path, ext, members, tokens: toks };
}

/** Every class under a FFDec `scripts/__Packages` folder. */
export function readClasses(root: string): Cls[] {
  const out: Cls[] = [];
  const walk = (d: string) => {
    for (const e of readdirSync(d)) {
      const p = join(d, e);
      if (statSync(p).isDirectory()) walk(p);
      else if (e.endsWith(".as")) {
        const c = parseClass(relative(root, p), readFileSync(p, "utf8"));
        if (c) out.push(c);
      }
    }
  };
  walk(root);
  return out;
}
