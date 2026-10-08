# Adding an interface

How the client shows an interface: `this.api.ui.loadUIComponent("AskOk", "AskOk", { text: "…" })`
attaches the library clip **`UI_AskOk`**, and the class registered for that
clip (`Object.registerClass("UI_AskOk", dofus.graphics.gapi.ui.AskOk)` in
`dofus.DofusCore`) drives it. The properties passed (`{ text: "…" }`) go
through its setters; `gapi` and `instanceName` are set too.

Ankama's interfaces have their layout drawn in the library (`UI_AskOk`
holds a Window whose content is the clip `UI_AskOkContent`, with `_btnOk`,
`_txtText`… — see `src/timeline/sprites/<id>_UI_AskOk/`). A new interface
can't draw clips, but it doesn't need to: the library has every component —
`Window`, `Label`, `Button`, `TextInput`, `TextArea`, `List`, `ComboBox`,
`Container`… — and a class creates them with `attachMovie`.

## Steps (example: `Hello`, the `/hello` chat command — complete on branch `feat/hello-ui`)

1. **The class** — `src/classes/dofus/graphics/gapi/ui/Hello.as`, extending
   `dofus.graphics.gapi.core.DofusAdvancedComponent`. In `createChildren()`,
   attach the components:
   ```actionscript
   this.attachMovie("Window", "_winBackground", 10, {contentPath: "none", styleName: "LightBrownWindow", title: "Hello"});
   this._winBackground.setSize(320, 150);
   this.attachMovie("Button", "_btnOk", 30, {styleName: "OrangeButton", backgroundUp: "ButtonNormalUp", backgroundDown: "ButtonNormalDown", label: "OK"});
   this._btnOk.addEventListener("click", this);
   ```
   (`contentPath: "none"`: a window without a content clip). A Window centers
   itself on screen when sized: place the other components from its
   `_x`/`_y`, not the interface's. Events come to
   `click(oEvent)`, `change(oEvent)`…; `this.unloadThis()` closes it.
2. **The clip** — add `"UI_Hello": {}` to `src/symbols.json`: the build adds
   an empty clip exported as `UI_Hello` (tools/symbols.mjs). A new class gets
   its own clip automatically.
3. **The registration** — in `src/classes/dofus/DofusCore.as`, next to the
   others: `Object.registerClass("UI_Hello", dofus.graphics.gapi.ui.Hello);`
4. **Opening it** — `this.api.ui.loadUIComponent("Hello", "Hello", {text: "…"});`
   from wherever it belongs (here a chat command, in
   `dofus.utils.consoleParsers.ChatConsoleParser`).

`node tools/package.mjs --run`, then type `/hello` in the chat.

## Finding styles and components

Copy from an existing interface: its clip's scripts under
`src/timeline/sprites/<id>_UI_<Name>…/` list every component it places with
its settings (`styleName = "BrownLeftMediumLabel"`, `backgroundUp = …`) —
the same names work in `attachMovie`'s init object. Component classes are in
`src/classes/ank/gapi/controls/`.

## Real artwork

Pictures or a designed layout don't belong in the loader: make them a small
SWF of their own (any Flash tool, or images), ship it with the client through
`overlay/` (`overlay/resources/app/retroclient/clips/…`), and load it into a
`Loader` component (`attachMovie("Loader", …, {contentPath: "clips/…swf"})`).
