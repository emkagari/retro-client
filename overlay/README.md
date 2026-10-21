Files copied over the official client when packaging (`tools/package.mjs`),
with the client folder's layout: `resources/app/retroclient/config.xml`
replaces the client's `config.xml`. Everything here is committed and shared.
Machine-specific files (a server address…) belong in the local overlay folder
set by `"overlay"` in `retro.local.json`.
