/**
 * Downloads an official loader.swf from Ankama's CDN: no installed client needed.
 *
 *   node tools/official-loader.mjs [<version>|<release>] [--out <file>]
 *
 * - nothing: the version the launcher installs now;
 * - a version (1.49.9): the current one, or the one before it as Ankama's
 *   launcher last saw it (zaap/repositories/repositories.json in the
 *   launcher's data folder keeps the CDN's list of releases from its last
 *   check: run it before a version is replaced, to get that version later);
 * - a release, as the CDN names it (6.0_1.49.9.5673.465-64394b4).
 *
 * Writes .tmp/official-<version>/loader.swf (or --out), checked against the
 * release's manifest (SHA-1). The CDN serves each release as a manifest
 * (FlatBuffers: fragments → files → chunks) and bundles holding the chunks,
 * read with HTTP ranges. The loader is the same on every platform: Linux's.
 */
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { ROOT } from "./lib.mjs";

const CDN = "https://cytrus.cdn.ankama.com";
const LOADER = "resources/app/retroclient/loader.swf";
// Ankama's launcher (Electron, "zaap") keeps its data in the platform's application data folder.
const application_data = { win32: process.env.APPDATA ?? join(homedir(), "AppData", "Roaming"), darwin: join(homedir(), "Library", "Application Support") }[process.platform]
  ?? process.env.XDG_CONFIG_HOME ?? join(homedir(), ".config");
const LAUNCHER_LIST = join(application_data, "zaap", "repositories", "repositories.json");

const args = process.argv.slice(2);
const out_option = args.includes("--out") ? args[args.indexOf("--out") + 1] : undefined;
const wanted = args.find((a, i) => !a.startsWith("--") && args[i - 1] !== "--out");

const fetch_bytes = async (url, headers = {}) => {
  const response = await fetch(url, { headers });
  if (!response.ok) throw new Error(`${url}: HTTP ${response.status}`);
  return Buffer.from(await response.arrayBuffer());
};
const version_of = (release) => /_(\d+(?:\.\d+)+)\.\d+\.\d+-/.exec(release)?.[1];
const linux_release = (list) => list?.games?.retro?.platforms?.linux?.main;

// The release: given, current, or the launcher's last known.
const current = linux_release(JSON.parse(await fetch_bytes(`${CDN}/cytrus.json`)));
// The launcher keeps each CDN's cytrus.json under its URL.
const launcher_known = existsSync(LAUNCHER_LIST) ? linux_release(JSON.parse(readFileSync(LAUNCHER_LIST, "utf8"))[CDN]) : undefined;
const release = !wanted ? current
  : version_of(wanted) ? wanted
  : [current, launcher_known].find((r) => r && version_of(r) === wanted);
if (!release) {
  console.error(`no release of ${wanted} known: the CDN has ${version_of(current)}${launcher_known ? `, the launcher last saw ${version_of(launcher_known)}` : ""}; pass the release name if you have it`);
  process.exit(1);
}
const version = version_of(release);
const out = out_option ?? join(ROOT, ".tmp", `official-${version}`, "loader.swf");

// The manifest, FlatBuffers: a table starts with the offset back to its vtable, which lists its fields' offsets.
const manifest = await fetch_bytes(`${CDN}/retro/releases/main/linux/${release}.manifest`);
const u32 = (position) => manifest.readUInt32LE(position);
const target = (position) => position + u32(position);
const field = (table, index) => {
  const vtable = table - manifest.readInt32LE(table);
  const offset = 4 + 2 * index < manifest.readUInt16LE(vtable) ? manifest.readUInt16LE(vtable + 4 + 2 * index) : 0;
  return offset ? table + offset : null;
};
const tables = (table, index) => {
  const position = field(table, index);
  if (position == null) return [];
  const vector = target(position);
  return Array.from({ length: u32(vector) }, (_, k) => target(vector + 4 + 4 * k));
};
const bytes = (table, index) => { const vector = target(field(table, index)); return manifest.subarray(vector + 4, vector + 4 + u32(vector)); };
const long = (table, index) => { const position = field(table, index); return position == null ? 0 : Number(manifest.readBigInt64LE(position)); };

for (const fragment of tables(target(0), 0)) {
  const file = tables(fragment, 1).find((f) => bytes(f, 0).toString() === LOADER);
  if (!file) continue;
  // Where each chunk is: a bundle, at an offset.
  const chunk_places = new Map();
  for (const bundle of tables(fragment, 2))
    for (const chunk of tables(bundle, 1))
      chunk_places.set(bytes(chunk, 0).toString("hex"), { bundle: bytes(bundle, 0).toString("hex"), offset: long(chunk, 2), size: long(chunk, 1) });
  const hash = bytes(file, 2).toString("hex");
  const chunks = tables(file, 3).map((chunk) => ({ hash: bytes(chunk, 0).toString("hex"), offset: long(chunk, 2) }));
  const loader = Buffer.alloc(long(file, 1));
  for (const chunk of chunks.length ? chunks : [{ hash, offset: 0 }]) {
    const place = chunk_places.get(chunk.hash);
    const range = `bytes=${place.offset}-${place.offset + place.size - 1}`;
    (await fetch_bytes(`${CDN}/retro/bundles/${place.bundle.slice(0, 2)}/${place.bundle}`, { Range: range })).copy(loader, chunk.offset);
  }
  const sha1 = createHash("sha1").update(loader).digest("hex");
  if (sha1 !== hash) throw new Error(`downloaded loader.swf: sha1 ${sha1}, the manifest says ${hash}`);
  mkdirSync(dirname(out), { recursive: true });
  writeFileSync(out, loader);
  console.log(`${out}: official ${version} (${release}), sha256 ${createHash("sha256").update(loader).digest("hex")}`);
  process.exit(0);
}
throw new Error(`${LOADER} isn't in ${release}'s manifest`);
