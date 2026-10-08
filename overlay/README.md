Files copied over the official client when packaging (`tools/package.mjs`),
with the client folder's layout: `resources/app/retroclient/config.xml`
replaces the client's config.xml. Shared by everyone — machine-specific files
(a server address…) go in the local overlay (`"overlay"` in retro.local.json).
