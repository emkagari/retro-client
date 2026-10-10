/**
 * Development loop with hot reload:
 *
 *   node tools/dev.mjs [--platform linux|windows] [--no-run] [--no-login]
 *
 * Builds with the hot reload class (build --dev), packages, starts the game,
 * then watches src/. A saved class is compiled into a patch (tools/hot.mjs),
 * written to the client's hot/ folder with hot/version.txt; the game loads it
 * within a second and says so in the chat (tools/dev/HotReload.as). The
 * loader is rebuilt behind, so a restarted game has every change too.
 *
 * With "dev": { "login", "password", "server", "character" } in
 * retro.local.json, the game logs in and enters the world by itself
 * (tools/dev/AutoLogin.as).
 *
 * Hot: method and get/set bodies, static functions, new classes. An open
 * interface shows its new createChildren once reopened. Not hot (restart):
 * what only runs at startup (DofusCore…), timeline scripts, symbols.json.
 */
import { execFileSync, spawn } from "node:child_process";
import { mkdirSync, rmSync, statSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, SRC, config, sourceFiles } from "./lib.mjs";
import { makePatch } from "./hot.mjs";
import { assetFiles } from "./assets.mjs";

const args = process.argv.slice(2);
const platform = args.includes("--platform") ? args[args.indexOf("--platform") + 1] : (process.platform === "win32" ? "windows" : "linux");
const cfg = config();
const node = (script, extra = []) => execFileSync(process.execPath, [join(ROOT, "tools", script), ...extra], { stdio: "inherit" });
const time = () => new Date().toTimeString().slice(0, 8);

node("build.mjs", ["--dev"]);
node("package.mjs", ["--no-build", "--platform", platform]);
const hot = join(ROOT, "dist", platform, "resources", "app", "retroclient", "hot");
rmSync(hot, { recursive: true, force: true });
mkdirSync(hot, { recursive: true });
let version = 0;
writeFileSync(join(hot, "version.txt"), `n=${version}&classes=`);
// Auto login (tools/dev/AutoLogin.as): retro.local.json's "dev", for this machine's client only (dist/ isn't in git).
const dev = args.includes("--no-login") ? {} : cfg.dev ?? {};
writeFileSync(join(hot, "dev.txt"), new URLSearchParams(Object.entries({
  login: dev.login ?? "", password: dev.password ?? "", server: dev.server ?? "", character: dev.character ?? "",
}).map(([k, v]) => [k, String(v)])).toString());
if (dev.login) console.log(`auto login: ${dev.login}${dev.character ? ` → ${dev.character}` : ""} (--no-login to type it yourself)`);
if (!args.includes("--no-run")) node("package.mjs", ["--no-build", "--platform", platform, "--run"]);

console.log(`\n[${time()}] watching src/ — save a class to hot reload it (Ctrl+C to stop)`);

// Changes are found by polling mtimes and sizes: editors that save by
// replacing the file (vim) lose fs.watch's per-file watch on Linux, and it
// behaves differently on each OS. ~70 ms per scan of src/.
const stamp = (f) => { try { const st = statSync(join(SRC, f)); return `${st.mtimeMs}:${st.size}`; } catch { return null; } };
// Sources and graphics (src/assets/: rebuilt into the loader, not hot).
const watched = () => [...sourceFiles(SRC), ...assetFiles().map((f) => `assets/${f}`)];
let known = new Map(watched().map((f) => [f, stamp(f)]));
let quietSince = 0;
const pending = new Set();
setInterval(() => {
  const now = new Map(watched().map((f) => [f, stamp(f)]));
  for (const [f, s] of now) if (known.get(f) !== s) { pending.add(f); quietSince = Date.now(); }
  known = now;
  // Saves come in bursts: wait for 300 ms of quiet.
  if (pending.size && Date.now() - quietSince >= 300) flush();
}, 500);

function flush() {
  const files = [...pending];
  pending.clear();
  for (const f of files) console.log(`[${time()}] changed ${f}`);
  const classes = files.filter((f) => f.startsWith("classes/"));
  for (const f of files.filter((f) => f.startsWith("timeline/"))) console.log(`[${time()}]   timeline script — restart the game to see it`);
  for (const f of files.filter((f) => f.startsWith("assets/"))) console.log(`[${time()}]   graphic — rebuilt into the loader: restart the game to see it`);
  if (classes.length) {
    const p = makePatch(cfg, classes);
    if (p.errors) {
      console.log(`[${time()}] compile errors:`);
      for (const e of p.errors) console.log(`  ${e}`);
    } else {
      version++;
      // The patch first: the game reads version.txt, then loads it.
      writeFileSync(join(hot, `${version}.swf`), p.swf);
      writeFileSync(join(hot, "version.txt"), `n=${version}&classes=${p.classes.join(",")}`);
      console.log(`[${time()}] patch ${version} sent: ${p.classes.join(", ")}`);
    }
  }
  rebuild();
}

// The loader too, in the background (patches never wait for it), so a restarted game keeps the changes.
let rebuilding = false, again = false;
function rebuild() {
  if (rebuilding) { again = true; return; }
  rebuilding = true;
  const run = (script, extra, next) => spawn(process.execPath, [join(ROOT, "tools", script), ...extra], { stdio: "ignore" })
    .on("exit", (code) => next(code === 0));
  run("build.mjs", ["--dev"], (ok) => {
    if (!ok) console.log(`[${time()}] loader rebuild failed — run node tools/build.mjs --dev to see why`);
    const done = () => { rebuilding = false; if (again) { again = false; rebuild(); } };
    if (ok) run("package.mjs", ["--no-build", "--platform", platform], done); else done();
  });
}
