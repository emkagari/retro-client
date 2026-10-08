/** Shared by the tools: configuration, paths, hashing, FFDec. */
import { spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join, relative, resolve, sep } from "node:path";

export const ROOT = resolve(import.meta.dirname, "..");
export const SRC = join(ROOT, "src");

/** retro.json (shared, in git) + retro.local.json (this machine's paths, not in git). */
export function config() {
  const shared = JSON.parse(readFileSync(join(ROOT, "retro.json"), "utf8"));
  const localFile = join(ROOT, "retro.local.json");
  const local = existsSync(localFile) ? JSON.parse(readFileSync(localFile, "utf8")) : {};
  return { ...shared, ...local, upstream: { ...shared.upstream, ...local.upstream } };
}

/** The base of a client version: the deobfuscated loader the sources come from. */
export function base(version) {
  const dir = join(ROOT, "base", version);
  if (!existsSync(join(dir, "loader.swf"))) throw new Error(`no base for ${version} (base/${version}/loader.swf)`);
  const manifest = JSON.parse(readFileSync(join(dir, "manifest.json"), "utf8"));
  return { dir, loader: join(dir, "loader.swf"), manifest };
}

export const sha256 = (file) => createHash("sha256").update(readFileSync(file)).digest("hex");

/** A source's hash, line endings aside (git may check them out as CRLF on Windows). */
export const sourceHash = (file) => createHash("sha256").update(readFileSync(file, "utf8").replace(/\r\n/g, "\n")).digest("hex");

/**
 * src/ layout ↔ the layout FFDec exports and imports. Ours keeps the root
 * readable; the build stages files in FFDec's layout to compile them.
 *
 *   classes/<pkg>/<Class>.as          __Packages/<pkg>/<Class>.as
 *   timeline/main/frame_N/…           frame_N/…                    (main timeline)
 *   timeline/init/<Export>.as         <Export>.as                  (#initclip of exported symbols)
 *   timeline/sprites/<id>[_<name>]/…  DefineSprite_<id>[_<name>]/…
 *   timeline/buttons/<id>/…           DefineButton2_<id>/…
 *   timeline/other/…                  anything else, as is
 */
const KINDS = [["sprites", "DefineSprite_"], ["buttons", "DefineButton2_"]];
export function toFfdec(rel) {
  if (rel.startsWith("classes/")) return "__Packages/" + rel.slice("classes/".length);
  for (const dir of ["timeline/main/", "timeline/init/", "timeline/other/"]) if (rel.startsWith(dir)) return rel.slice(dir.length);
  for (const [dir, prefix] of KINDS) if (rel.startsWith(`timeline/${dir}/`)) return prefix + rel.slice(`timeline/${dir}/`.length);
  return rel;
}
export function fromFfdec(rel) {
  if (rel.startsWith("__Packages/")) return "classes/" + rel.slice("__Packages/".length);
  for (const [dir, prefix] of KINDS) if (rel.startsWith(prefix)) return `timeline/${dir}/` + rel.slice(prefix.length);
  if (/^frame_\d+\//.test(rel)) return "timeline/main/" + rel;
  if (!rel.includes("/")) return "timeline/init/" + rel;
  return "timeline/other/" + rel;
}

/** Every source file, as a path relative to src/ with forward slashes. */
export function sourceFiles(dir = SRC) {
  const out = [];
  const walk = (d) => {
    for (const e of readdirSync(d, { withFileTypes: true })) {
      const p = join(d, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith(".as")) out.push(relative(dir, p).split(sep).join("/"));
    }
  };
  walk(dir);
  return out.sort();
}

/** Runs FFDec (`ffdec` in the config: a .jar, run with java, or an executable such as ffdec-cli.exe). */
export function ffdec(cfg, args) {
  const tool = cfg.ffdec;
  if (!tool || !existsSync(tool)) throw new Error(`FFDec not found: set "ffdec" in retro.local.json (now: ${tool ?? "unset"})`);
  const [cmd, pre] = tool.endsWith(".jar") ? [cfg.java ?? "java", ["-jar", tool]] : [tool, []];
  // Both streams: FFDec logs compile errors on stderr, even when it exits 0 (-onerror ignore).
  const r = spawnSync(cmd, [...pre, ...args], { encoding: "utf8", maxBuffer: 1 << 28, stdio: ["ignore", "pipe", "pipe"] });
  return { ok: r.status === 0, log: `${r.stdout ?? ""}${r.stderr ?? ""}${r.error ? String(r.error) : ""}` };
}

/** FFDec's compile errors, one line each ("<message>, file: <path>"). */
export const compileErrors = (log) =>
  log.split("\n").filter((l) => l.includes("SEVERE:")).map((l) => l.replace(/.*SEVERE:\s*/, ""));
