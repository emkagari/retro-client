/**
 * Prints one setting of retro.local.json, for the Docker wrappers (retro,
 * retro.cmd): node tools/local.mjs upstream.windows
 * Nothing when unset; an explained error when the file can't be read.
 */
import { config } from "./lib.mjs";

try {
  const value = process.argv[2].split(".").reduce((o, k) => o?.[k], config());
  if (typeof value === "string") process.stdout.write(value);
} catch (e) {
  console.error(e.message);
  process.exit(1);
}
