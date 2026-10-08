import { readFileSync } from "node:fs";
import { parseSwf, codeSites } from "./swf.ts";
import { decode, OP, OP_NAME, branchTarget, readPush } from "./avm1.ts";

for (const file of process.argv.slice(2)) {
  const swf = parseSwf(readFileSync(file));
  const sites = codeSites(swf);
  const hist = new Map<string, number>(), preIf = new Map<string, number>();
  let actions = 0, branches = 0, intoMiddle = 0, outside = 0, afterEnd = 0, bytes = 0;
  for (const s of sites) {
    const acts = decode(s.code);
    bytes += s.code.length; actions += acts.length;
    const starts = new Set(acts.map((a) => a.offset));
    let seenEnd = false;
    acts.forEach((a, i) => {
      const n = OP_NAME[a.code] ?? `0x${a.code.toString(16)}`;
      hist.set(n, (hist.get(n) ?? 0) + 1);
      if (seenEnd) afterEnd++;
      if (a.code === 0 && i < acts.length - 1) seenEnd = true;
      if (a.code === OP.Jump || a.code === OP.If) {
        branches++;
        const t = branchTarget(a);
        if (t < 0 || t > s.code.length) outside++;
        else if (!starts.has(t) && t !== s.code.length) intoMiddle++;
      }
      if (a.code === OP.If && i >= 2) {
        const pat = acts.slice(Math.max(0, i - 3), i).map((x) => {
          const nm = OP_NAME[x.code] ?? "?";
          if (x.code === OP.Push) { try { return "Push(" + readPush(x).map((v) => v.t).join(",") + ")"; } catch { return "Push(?)"; } }
          return nm;
        }).join(" ");
        preIf.set(pat, (preIf.get(pat) ?? 0) + 1);
      }
    });
  }
  console.log(`\n== ${file}: ${sites.length} code blocks, ${bytes} bytes, ${actions} actions, ${branches} branches`);
  console.log(`   branch into the middle of an action: ${intoMiddle}, outside the block: ${outside}, actions after an End: ${afterEnd}`);
  console.log("   top ops:", [...hist].sort((a, b) => b[1] - a[1]).slice(0, 14).map(([k, v]) => `${k} ${v}`).join(", "));
  console.log("   before If:", [...preIf].sort((a, b) => b[1] - a[1]).slice(0, 10).map(([k, v]) => `[${k}] ${v}`).join("\n              "));
}
