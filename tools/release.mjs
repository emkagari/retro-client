/**
 * Prepares a release: what goes onto a player's official client.
 *
 *   node tools/release.mjs <tag>        e.g. v1.49.5-r1 (from retro.json's version)
 *
 * The tag must be v<official version>-r<n>[-rcN|-betaN]: the client version
 * the release is for, then ours. A new official version starts again at -r1.
 *
 * Builds (tools/build.mjs), then fills dist/release/<name>/ with the client
 * folder's layout — resources/app/retroclient/loader.swf, the overlay/ files —
 * and retro-release.json (versions, hashes: which official client it fits).
 * No Ankama file is in it but the loader we build: players apply it to
 * their own install.
 */
import { execFileSync } from "node:child_process";
import { copyFileSync, cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { ROOT, base, config, sha256 } from "./lib.mjs";

const tag = process.argv[2];
const cfg = config();
const m = /^v(\d+(?:\.\d+)*)-r(\d+)(?:-(rc|beta)(\d+))?$/.exec(tag ?? "");
if (!m) { console.error("usage: node tools/release.mjs v<official version>-r<n>[-rcN|-betaN]   e.g. v1.49.5-r1"); process.exit(2); }
if (m[1] !== cfg.version) { console.error(`tag ${tag} is for ${m[1]}, but retro.json says ${cfg.version}`); process.exit(1); }

execFileSync(process.execPath, [join(ROOT, "tools", "build.mjs")], { stdio: "inherit" });

const name = `retro-client-${tag}`;
const out = join(ROOT, "dist", "release", name);
rmSync(out, { recursive: true, force: true });
const client = join(out, "resources", "app", "retroclient");
mkdirSync(client, { recursive: true });
copyFileSync(join(ROOT, "build", "loader.swf"), join(client, "loader.swf"));
if (existsSync(join(ROOT, "overlay"))) cpSync(join(ROOT, "overlay"), out, { recursive: true, filter: (p) => !p.endsWith("README.md") });

const b = base(cfg.version);
writeFileSync(join(out, "retro-release.json"), JSON.stringify({
  release: tag,
  officialVersion: cfg.version,
  prerelease: Boolean(m[3]),
  // The official loader this one replaces: another one means another official version.
  officialLoaderSha256: b.manifest.upstreamLoader,
  loaderSha256: sha256(join(client, "loader.swf")),
  commit: (() => { try { return execFileSync("git", ["rev-parse", "HEAD"], { cwd: ROOT, encoding: "utf8" }).trim(); } catch { return null; } })(),
}, null, 2) + "\n");
writeFileSync(join(out, "README.txt"), [
  `Retro client ${tag} — for the official Dofus Retro ${cfg.version} client.`,
  "",
  "Copy the official client folder first, then copy this archive's content",
  "over the copy (resources/app/retroclient/loader.swf is replaced).",
  "Start the copy with its executable, not through Ankama's launcher (it would",
  "restore the official files). Play on your own server only.",
  "",
].join("\n"));
console.log(`\n${out}\n${readFileSync(join(out, "retro-release.json"), "utf8")}`);
