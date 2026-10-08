/**
 * Template for a new interface, built entirely by code: a window, a text and
 * an OK button, from the client's own components (Window, Label, Button).
 *
 * Open it from anywhere: this.api.ui.loadUIComponent("Hello", "Hello", {text: "…"});
 * (in game: the /hello chat command). What it needs besides this class:
 * - "UI_Hello" in src/symbols.json: the library clip loadUIComponent attaches;
 * - Object.registerClass("UI_Hello", dofus.graphics.gapi.ui.Hello) in dofus.DofusCore.
 */
class dofus.graphics.gapi.ui.Hello extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   static var CLASS_NAME = "Hello";
   static var WIDTH = 200;
   static var HEIGHT = 115;
   static var PADDING = 15;
   static var BUTTON_WIDTH = 100;
   var _winBackground;
   var _lblText;
   var _btnOk;
   var _sText = "";
   var api;
   var gapi;
   var attachMovie;
   var unloadThis;
   function Hello()
   {
      super();
   }
   function set text(sText)
   {
      this._sText = sText;
      this._lblText.text = sText;
   }
   function get text()
   {
      return this._sText;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Hello.CLASS_NAME);
   }
   function createChildren()
   {
      var w = dofus.graphics.gapi.ui.Hello.WIDTH;
      var h = dofus.graphics.gapi.ui.Hello.HEIGHT;
      var p = dofus.graphics.gapi.ui.Hello.PADDING;
      var bw = dofus.graphics.gapi.ui.Hello.BUTTON_WIDTH;
      // "none": a window drawn by code, without a content symbol. A Window
      // centers itself on screen when sized: the rest is placed from it.
      this.attachMovie("Window","_winBackground",10,{contentPath:"none",styleName:"LightBrownWindow",title:"Hello"});
      this._winBackground.setSize(w,h);
      var x = this._winBackground._x;
      var y = this._winBackground._y;
      this.attachMovie("Label","_lblText",20,{_x:x + p,_y:y + 40,styleName:"BrownLeftMediumLabel",wordWrap:true,multiline:true,text:this._sText});
      this._lblText.setSize(w - 2 * p,h - 90);
      this.attachMovie("Button","_btnOk",30,{_x:x + (w - bw) / 2,_y:y + h - 40,styleName:"OrangeButton",backgroundUp:"ButtonNormalUp",backgroundDown:"ButtonNormalDown",label:this.api.lang.getText("OK")});
      this._btnOk.setSize(bw,25);
      this._btnOk.addEventListener("click",this);
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnOk)
      {
         this.unloadThis();
      }
   }
}
