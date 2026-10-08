/** node src/dump.ts <swf> <match: substring of the site, e.g. "sprite 1234"> [maxActions] — readable p-code. */
import { readFileSync } from "node:fs";
import { parseSwf, codeSites } from "./swf.ts";
import { decode, OP, OP_NAME, branchTarget, readPush, readPool, functionInfo } from "./avm1.ts";
const [file, what, max] = process.argv.slice(2);
const show = (s: string) => JSON.stringify(s);
for (const s of codeSites(parseSwf(readFileSync(file!)))) {
  if (!s.where.includes(what!)) continue;
  console.log("##", s.where, s.code.length, "bytes");
  for (const a of decode(s.code).slice(0, Number(max ?? 60))) {
    let arg = "";
    if (a.code === OP.Push) arg = readPush(a).map((v) => v.t === "str" ? show(v.v) : v.t === "const" ? `c${v.v}` : v.t === "reg" ? `r${v.v}` : "v" in v ? String(v.v) : v.t).join(", ");
    else if (a.code === OP.Jump || a.code === OP.If) arg = "→ " + branchTarget(a);
    else if (a.code === OP.ConstantPool) arg = `${readPool(a).length} strings`;
    else if (a.code === OP.DefineFunction || a.code === OP.DefineFunction2) { const f = functionInfo(a); arg = `${show(f.name)}(${f.params.map(show).join(", ")})`; }
    console.log(String(a.offset).padStart(6), (OP_NAME[a.code] ?? a.code.toString(16)).padEnd(14), arg);
  }
  break;
}
