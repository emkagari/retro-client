/**
 * One entry point for the tools — the Docker image's (./retro, retro.cmd):
 *
 *   node tools/cli.mjs <command> [args…]
 *
 * Commands map to tools/*.mjs; run without one for the list.
 */
import { spawnSync } from "node:child_process";
import { join } from "node:path";
import { ROOT } from "./lib.mjs";

const COMMANDS = {
  build: ["build.mjs", "src/ → build/loader.swf  [--full] [--dev] [--out <file>]"],
  package: ["package.mjs", "official client + build → dist/<platform>/  [--platform linux|windows] [--no-build]"],
  dev: ["dev.mjs", "build with hot reload, watch src/  [--platform …] [--no-run] [--no-login]"],
  release: ["release.mjs", "prepare a release in dist/release/  <tag: v1.49.5-r1>"],
  "test-assets": ["test-assets.mjs", "non-regression tests of the graphics: base → src/assets/ → loader  [--update]"],
  manifest: ["manifest.mjs", "record src/ as the base's baseline  <version> [--upstream <official loader.swf>]"],
  "new-base": ["new-base.mjs", "install a new base (docs/UPGRADING.md)  <version> <runnable.swf> --upstream <loader.swf>"],
  deob: ["deob/src/deob.ts", "deobfuscate a client SWF (the swf-deobfuscate skill)  <target.swf> --ref <dir> --out <dir>"],
};

const [command, ...args] = process.argv.slice(2);
if (!command || command === "help" || !COMMANDS[command]) {
  if (command && command !== "help") console.error(`unknown command: ${command}\n`);
  console.log("commands:");
  for (const [name, [, what]] of Object.entries(COMMANDS)) console.log(`  ${name.padEnd(11)} ${what}`);
  process.exit(command && command !== "help" ? 2 : 0);
}
const r = spawnSync(process.execPath, [join(ROOT, "tools", COMMANDS[command][0]), ...args], { stdio: "inherit" });
process.exit(r.status ?? 1);
