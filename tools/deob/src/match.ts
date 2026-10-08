/**
 * Recovers obfuscated names by matching the target against a readable
 * reference build of the same client family.
 *
 * 1. Classes are paired on what the obfuscator can't touch: string and
 *    number literals, surviving names (Flash API, dynamic properties) — and,
 *    after the first round, the names already recovered.
 * 2. In each pair, members are paired (initializer, parameters, body).
 * 3. Paired bodies are aligned by a diff where every identifier the target
 *    doesn't show in clear is a wildcard: an obfuscated name facing a real
 *    one is a vote.
 * Votes add up over the whole code base; rounds repeat with what was found.
 */
import { isObf, type Cls, type Member, type Tok } from "./as2.ts";

export interface Vote { name: string; votes: number; total: number }
export type Mapping = Map<string, Vote>;

const KEYWORDS = new Set(["this", "var", "function", "return", "if", "else", "new", "true", "false", "null", "undefined",
  "super", "for", "while", "do", "break", "continue", "switch", "case", "default", "in", "typeof", "instanceof", "delete",
  "with", "try", "catch", "finally", "throw", "void", "class", "extends", "static", "_global", "_root", "_level0"]);
const isLocal = (s: string) => /^_loc\d+_$/.test(s) || /^_arg\d+_$/.test(s);

/** What survives obfuscation, as weighted features. */
function anchors(toks: Tok[], map: (s: string) => string): string[] {
  const out: string[] = [];
  for (const t of toks) {
    if (t.t === "str") out.push("s:" + t.v);
    else if (t.t === "num") out.push("n:" + t.v);
    else if (t.t === "id") {
      const v = map(t.v);
      if (!isObf(v) && !KEYWORDS.has(v) && !isLocal(v)) out.push("i:" + v);
    }
  }
  return out;
}

/** Weighted Jaccard of two feature sets (weights = IDF). */
function similarity(a: Set<string>, b: Set<string>, idf: Map<string, number>): number {
  let inter = 0, union = 0;
  for (const x of a) { const w = idf.get(x) ?? 1; union += w; if (b.has(x)) inter += w; }
  for (const x of b) if (!a.has(x)) union += idf.get(x) ?? 1;
  return union ? inter / union : 0;
}

/** Myers diff on two shape streams; returns aligned index pairs (equal shapes). */
function align(a: string[], b: string[], maxD = 3000): [number, number][] | null {
  const n = a.length, m = b.length, max = n + m, off = max;
  const trace: Int32Array[] = [];
  let v = new Int32Array(2 * max + 2);
  for (let d = 0; d <= Math.min(max, maxD); d++) {
    trace.push(v.slice());
    for (let k = -d; k <= d; k += 2) {
      let x = k === -d || (k !== d && v[off + k - 1]! < v[off + k + 1]!) ? v[off + k + 1]! : v[off + k - 1]! + 1;
      let y = x - k;
      while (x < n && y < m && a[x] === b[y]) { x++; y++; }
      v[off + k] = x;
      if (x >= n && y >= m) {
        // Backtrack.
        const pairs: [number, number][] = [];
        let cx = n, cy = m;
        for (let dd = d; dd > 0; dd--) {
          const pv = trace[dd]!;
          const kk = cx - cy;
          const prevK = kk === -dd || (kk !== dd && pv[off + kk - 1]! < pv[off + kk + 1]!) ? kk + 1 : kk - 1;
          const px = pv[off + prevK]!, py = px - prevK;
          while (cx > px && cy > py) { cx--; cy--; pairs.push([cx, cy]); }
          cx = px; cy = py;
        }
        while (cx > 0 && cy > 0) { cx--; cy--; pairs.push([cx, cy]); }
        return pairs.reverse();
      }
    }
    v = v.slice();
  }
  return null;
}

/**
 * Parameters are renamed PER FUNCTION by the obfuscator (one string serves as
 * the first parameter of hundreds of functions): besides their global votes,
 * they get their own table, keyed by `paramKey`, which names each function's
 * header.
 */
export type ParamNames = Map<string, string[]>;
export const paramKey = (classPath: string[], member: string, arity: number) => JSON.stringify([classPath, member, arity]);

export interface MatchResult { mapping: Mapping; params: ParamNames; classes: Map<Cls, Cls>; rounds: { round: number; classes: number; resolved: number }[] }

export function match(ref: Cls[], target: Cls[], rounds = 4): MatchResult {
  // Names the target shows in clear: the ref's other names are wildcards in shapes.
  const kept = new Set<string>();
  for (const c of target) for (const t of c.tokens) if (t.t === "id" && !isObf(t.v)) kept.add(t.v);

  let mapping: Mapping = new Map();
  let classes = new Map<Cls, Cls>();
  let params: ParamNames = new Map();
  const history: MatchResult["rounds"] = [];

  for (let round = 1; round <= rounds; round++) {
    const known = (s: string) => { const m = mapping.get(s); return m && m.votes >= 2 && m.votes / m.total >= 0.6 ? m.name : s; };
    // ——— 1. Classes ———
    const feat = (c: Cls, map: (s: string) => string) => new Set([
      ...anchors(c.tokens, map),
      `#m${c.members.length}`, `#f${c.members.filter((m) => m.kind.endsWith("function")).length}`,
      ...c.path.map((p, i) => `p${i}:${map(p)}`).filter((x) => !isObf(x.slice(x.indexOf(":") + 1))),
    ]);
    const rf = ref.map((c) => feat(c, (s) => s));
    const tf = target.map((c) => feat(c, known));
    const df = new Map<string, number>();
    for (const s of [...rf, ...tf]) for (const x of s) df.set(x, (df.get(x) ?? 0) + 1);
    const N = rf.length + tf.length;
    const idf = new Map([...df].map(([k, v]) => [k, Math.log(N / v)]));
    const pairs: [number, number, number][] = [];
    tf.forEach((t, j) => rf.forEach((r, i) => { const s = similarity(r, t, idf); if (s > 0.15) pairs.push([s, i, j]); }));
    pairs.sort((x, y) => y[0] - x[0]);
    const usedR = new Set<number>(), usedT = new Set<number>();
    classes = new Map();
    for (const [, i, j] of pairs) {
      if (usedR.has(i) || usedT.has(j)) continue;
      usedR.add(i); usedT.add(j);
      classes.set(target[j]!, ref[i]!);
    }

    // ——— 2-3. Members and bodies → votes ———
    const votes = new Map<string, Map<string, number>>();
    params = new Map();
    const vote = (obf: string, name: string, w = 1) => {
      if (!isObf(obf) || isObf(name) || KEYWORDS.has(name) || isLocal(name)) return;
      const m = votes.get(obf) ?? new Map<string, number>();
      m.set(name, (m.get(name) ?? 0) + w);
      votes.set(obf, m);
    };
    const shapeRef = (t: Tok) => (t.t === "id" ? (kept.has(t.v) || KEYWORDS.has(t.v) || isLocal(t.v) ? t.v : "§ID") : t.t === "p" ? t.v : t.t + ":" + t.v);
    const shapeTgt = (t: Tok) => { if (t.t !== "id") return t.t === "p" ? t.v : t.t + ":" + t.v; const v = known(t.v); return isObf(v) ? "§ID" : kept.has(v) || KEYWORDS.has(v) || isLocal(v) ? v : "§ID"; };

    for (const [tc, rc] of classes) {
      if (tc.path.length === rc.path.length) tc.path.forEach((p, i) => vote(p, rc.path[i]!, 3));
      if (tc.ext && rc.ext && tc.ext.length === rc.ext.length) tc.ext.forEach((p, i) => vote(p, rc.ext![i]!, 2));
      const memberFeat = (m: Member, map: (s: string) => string) => new Set([...anchors(m.body, map), `k:${m.kind}`, `a:${m.params.length}`,
        ...(isObf(map(m.name)) ? [] : [`name:${map(m.name)}`])]);
      const rm = rc.members.map((m) => memberFeat(m, (s) => s));
      const tm = tc.members.map((m) => memberFeat(m, known));
      const mp: [number, number, number][] = [];
      tm.forEach((t, j) => rm.forEach((r, i) => {
        if (rc.members[i]!.kind !== tc.members[j]!.kind) return;
        const s = similarity(r, t, idf);
        if (s > 0.2) mp.push([s, i, j]);
      }));
      mp.sort((x, y) => y[0] - x[0]);
      const uR = new Set<number>(), uT = new Set<number>();
      for (const [s, i, j] of mp) {
        if (uR.has(i) || uT.has(j)) continue;
        uR.add(i); uT.add(j);
        const r = rc.members[i]!, t = tc.members[j]!;
        vote(t.name, r.name, s > 0.5 ? 2 : 1);
        // Parameters also vote globally: old `DefineFunction` closures and
        // register-0 parameters are read BY NAME in the body, only the global
        // table reaches those strings. The per-function table below then
        // overrides the header of each paired `DefineFunction2`.
        if (r.params.length === t.params.length) t.params.forEach((p, k) => vote(p, r.params[k]!));
        if (t.kind.endsWith("function") && r.params.length === t.params.length && t.params.length) {
          // Readable reference names only; a parameter the target shows in clear stays.
          params.set(paramKey(tc.path, t.name, t.params.length),
            t.params.map((p, k) => (isObf(p) && !isObf(r.params[k]!) ? r.params[k]! : p)));
        }
        if (t.body.length && r.body.length) {
          const pairs = align(r.body.map(shapeRef), t.body.map(shapeTgt));
          if (pairs) for (const [x, y] of pairs) {
            const a = r.body[x]!, b = t.body[y]!;
            if (a.t === "id" && b.t === "id") vote(b.v, a.v);
          }
        }
      }
    }

    // ——— Resolve: best name per obfuscated id, then keep names unique ———
    const next: Mapping = new Map();
    const byName = new Map<string, string>();
    const ranked = [...votes].map(([obf, m]) => {
      const total = [...m.values()].reduce((s, x) => s + x, 0);
      const [name, n] = [...m].sort((x, y) => y[1] - x[1])[0]!;
      return { obf, name, votes: n, total };
    }).sort((x, y) => y.votes - x.votes);
    for (const r of ranked) {
      if (byName.has(r.name)) continue;            // a name already given to a better-supported id
      byName.set(r.name, r.obf);
      next.set(r.obf, { name: r.name, votes: r.votes, total: r.total });
    }
    mapping = next;
    history.push({ round, classes: classes.size, resolved: mapping.size });
  }
  return { mapping, params, classes, rounds: history };
}
