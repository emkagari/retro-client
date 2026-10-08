/**
 * Records the state of the sources that matches a base exactly:
 *
 *   node tools/manifest.mjs <version> [--upstream <official loader.swf>]
 *
 * Writes base/<version>/manifest.json: the hash of every file of src/ (the
 * build recompiles only files that differ from it — the others keep the
 * base's bytecode), the base loader's hash and the official loader's hash
 * (which client the base was made from).
 *
 * Only files tracked by git count (run it on main or upstream, not on a
 * feature branch). Run it right after src/ was exported from the base (and the decompiler
 * artifacts fixed): from then on, any change in src/ is a change to build.
 */
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, SRC, sha256, sourceFiles, sourceHash } from "./lib.mjs";

const args = process.argv.slice(2);
const version = args[0];
if (!version) { console.error("usage: node tools/manifest.mjs <version> [--upstream <official loader.swf>]"); process.exit(2); }
const dir = join(ROOT, "base", version);
const loader = join(dir, "loader.swf");
const file = join(dir, "manifest.json");
const previous = existsSync(file) ? JSON.parse(readFileSync(file, "utf8")) : {};
const upstreamArg = args.includes("--upstream") ? args[args.indexOf("--upstream") + 1] : null;

// Sources tracked by git only: files being written (untracked) or from a feature branch aren't the base's.
const tracked = new Set(execFileSync("git", ["ls-files", "src"], { cwd: ROOT, encoding: "utf8" }).split("\n").map((f) => f.slice("src/".length)));
const files = Object.fromEntries(sourceFiles(SRC).filter((f) => tracked.has(f)).map((f) => [f, sourceHash(join(SRC, f))]));
const manifest = {
  version,
  loader: sha256(loader),
  upstreamLoader: upstreamArg ? sha256(upstreamArg) : previous.upstreamLoader ?? null,
  files,
};
writeFileSync(file, JSON.stringify(manifest, null, 1) + "\n");
console.log(`base/${version}/manifest.json: ${Object.keys(files).length} sources`);
