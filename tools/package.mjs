/**
 * Builds a playable client: the official one (this machine's install, see
 * retro.local.json) with our loader and overlay files.
 *
 *   node tools/package.mjs [--platform linux|windows|mac] [--no-build] [--run]
 *
 * - dist/<platform>/ is a copy of the official client, made once (≈700 MB);
 *   later runs only replace what we change; on macOS it's the copied app,
 *   dist/mac/Dofus Retro.app;
 * - resources/app/retroclient/loader.swf ← build/loader.swf (built first,
 *   unless --no-build); the official one stays next to it as loader.original.swf;
 * - overlay/ (in git, shared) then the local overlay ("overlay" in
 *   retro.local.json) are copied over the client: same layout as the client
 *   folder (overlay/resources/app/retroclient/config.xml…), Contents/Resources/
 *   instead of resources/ on macOS;
 * - --run starts it.
 */
import { execFileSync, spawn } from "node:child_process";
import { copyFileSync, cpSync, existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { join, relative, sep } from "node:path";
import { ROOT, base, clientPath, config, distDir, hostPlatform, sha256, upstreamDir } from "./lib.mjs";

const args = process.argv.slice(2);
const opt = (k) => (args.includes(k) ? args[args.indexOf(k) + 1] : undefined);
const platform = opt("--platform") ?? hostPlatform();
const cfg = config();
const b = base(cfg.version);

const upstream = upstreamDir(cfg, platform);
const clientDir = (root) => join(root, clientPath(platform, "resources/app/retroclient"));
if (!upstream || !existsSync(join(clientDir(upstream), "loader.swf")))
  throw new Error(platform === "mac"
    ? `official mac client not found: set upstream.mac in retro.local.json to its app, e.g. /Applications/Ankama/Retro/Dofus Retro.app (now: ${upstream ?? "unset"})`
    : `official ${platform} client not found: set upstream.${platform} in retro.local.json to the folder holding resources/app/retroclient (now: ${upstream ?? "unset"})`);

// The official client must be the one the base was made from.
const upstreamLoader = sha256(join(clientDir(upstream), "loader.swf"));
if (b.manifest.upstreamLoader && upstreamLoader !== b.manifest.upstreamLoader)
  console.warn(`warning: this official client's loader.swf isn't the one base ${cfg.version} was made from — another version? (see docs/UPGRADING.md)`);

if (!args.includes("--no-build")) execFileSync(process.execPath, [join(ROOT, "tools/build.mjs")], { stdio: "inherit" });
const built = join(ROOT, "build", "loader.swf");
if (!existsSync(built)) throw new Error("no build/loader.swf: run node tools/build.mjs");

// The copy of the official client, made once per official client.
const dist = distDir(platform);
const stampFile = join(ROOT, "dist", platform, ".retro-package.json");
const stamp = existsSync(stampFile) ? JSON.parse(readFileSync(stampFile, "utf8")) : null;
if (stamp?.upstream !== upstream || stamp?.upstreamLoader !== upstreamLoader) {
  console.log(`copying the official client into dist/${platform} (once)…`);
  rmSync(join(ROOT, "dist", platform), { recursive: true, force: true });
  cpSync(upstream, dist, { recursive: true, verbatimSymlinks: true });
  writeFileSync(stampFile, JSON.stringify({ upstream, upstreamLoader }, null, 1));
}

const target = clientDir(dist);
copyFileSync(join(clientDir(upstream), "loader.swf"), join(target, "loader.original.swf"));
copyFileSync(built, join(target, "loader.swf"));

for (const overlay of [join(ROOT, "overlay"), cfg.overlay].filter((d) => d && existsSync(d))) {
  const files = readdirSync(overlay, { recursive: true, withFileTypes: true }).filter((e) => e.isFile() && e.name !== "README.md");
  for (const e of files) {
    const rel = relative(overlay, join(e.parentPath, e.name)).split(sep).join("/");
    const to = join(dist, clientPath(platform, rel));
    mkdirSync(join(to, ".."), { recursive: true });
    copyFileSync(join(overlay, rel), to);
  }
  if (files.length) console.log(`overlay ${overlay}: ${files.length} file${files.length > 1 ? "s" : ""}`);
}
console.log(`${relative(ROOT, dist).split(sep).join("/")} ready (loader ${sha256(built).slice(0, 12)})`);

if (args.includes("--run")) {
  const exe = cfg.executable?.[platform] ?? ({
    windows: () => readdirSync(dist).find((f) => f.toLowerCase().endsWith(".exe") && !/unins|crash/i.test(f)),
    // The app's executable, as its Info.plist names it: started directly, its output stays here.
    mac: () => `Contents/MacOS/${/<key>CFBundleExecutable<\/key>\s*<string>([^<]+)</.exec(readFileSync(join(dist, "Contents", "Info.plist"), "utf8"))?.[1] ?? "Dofus Retro"}`,
    linux: () => "dofus1electron",
  })[platform]();
  if (!exe || !existsSync(join(dist, exe))) throw new Error(`no executable in dist/${platform}: set executable.${platform} in retro.local.json`);
  console.log(`starting ${exe}…`);
  // Detached everywhere: on Windows, Node puts a child in a job object that
  // kills it when this process ends, which it does right after.
  spawn(join(dist, exe), [], { cwd: dist, stdio: platform === "windows" ? "ignore" : "inherit", detached: true }).unref();
}
