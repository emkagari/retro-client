/**
 * Prepares a release: the loader that replaces a player's official one.
 *
 *   node tools/release.mjs <tag>        e.g. v1.49.5-r1 (from retro.json's version)
 *
 * The tag must be v<official version>-r<n>[-rcN|-betaN]: the client version
 * the release is for, then ours. A new official version starts again at -r1.
 *
 * Builds (tools/build.mjs), then writes dist/release/<tag>/: loader.swf, the
 * release's only file (the official client holds the same loader on Linux,
 * Windows and macOS, so it fits all three), and notes.md, the line the
 * release opens with. No other Ankama file is published.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, mkdirSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, config } from "./lib.mjs";

const tag = process.argv[2];
const cfg = config();
const m = /^v(\d+(?:\.\d+)*)-r(\d+)(?:-(rc|beta)(\d+))?$/.exec(tag ?? "");
if (!m) { console.error("usage: node tools/release.mjs v<official version>-r<n>[-rcN|-betaN]   e.g. v1.49.5-r1"); process.exit(2); }
if (m[1] !== cfg.version) { console.error(`tag ${tag} is for ${m[1]}, but retro.json says ${cfg.version}`); process.exit(1); }

execFileSync(process.execPath, [join(ROOT, "tools", "build.mjs")], { stdio: "inherit" });

const git = (...a) => { try { return execFileSync("git", a, { cwd: ROOT, encoding: "utf8" }).trim(); } catch { return ""; } };
// overlay/ is for packaging (tools/package.mjs): a release holds the loader only.
const overlay = git("ls-files", "overlay").split("\n").filter((f) => f && !f.endsWith("README.md"));
if (overlay.length) console.warn(`warning: overlay/ files aren't released, only the loader: ${overlay.join(", ")}`);

const out = join(ROOT, "dist", "release", tag);
rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });
copyFileSync(join(ROOT, "build", "loader.swf"), join(out, "loader.swf"));

writeFileSync(join(out, "notes.md"), `Deobfuscated \`loader.swf\` of the official Dofus Retro **${cfg.version}** client (Linux, Windows, macOS).\n`);
console.log(`\n${out}/loader.swf\n${out}/notes.md`);
