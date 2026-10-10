/**
 * A window whose background is a graphic of ours: src/assets/new/panneau/Fond.svg,
 * exported by the build by its path in lower case, "panneau/fond" (docs/ASSETS.md). A title, a text and
 * a close button from the client's components; dragged by its background.
 *
 * Open it from anywhere: this.api.ui.loadUIComponent("Panneau", "Panneau", {title: "…", text: "…"});
 * (in game: the /panneau chat command). What it needs besides this class:
 * - "UI_Panneau" in src/symbols.json: the library clip loadUIComponent attaches;
 * - Object.registerClass("UI_Panneau", dofus.graphics.gapi.ui.Panneau) in dofus.DofusCore.
 */
class dofus.graphics.gapi.ui.Panneau extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   static var CLASS_NAME = "Panneau";
   // Fond.svg's size.
   static var WIDTH = 300;
   static var HEIGHT = 200;
   static var PADDING = 12;
   static var BUTTON_WIDTH = 100;
   var _mcBg;
   var _lblTitle;
   var _lblText;
   var _btnClose;
   var _sTitle = "";
   var _sText = "";
   var api;
   var gapi;
   var attachMovie;
   var unloadThis;
   var startDrag;
   var stopDrag;
   var _x;
   var _y;
   function Panneau()
   {
      super();
   }
   function set title(sTitle)
   {
      this._sTitle = sTitle;
      this._lblTitle.text = sTitle;
   }
   function get title()
   {
      return this._sTitle;
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
      super.init(false,dofus.graphics.gapi.ui.Panneau.CLASS_NAME);
   }
   function createChildren()
   {
      var w = dofus.graphics.gapi.ui.Panneau.WIDTH;
      var h = dofus.graphics.gapi.ui.Panneau.HEIGHT;
      var p = dofus.graphics.gapi.ui.Panneau.PADDING;
      var bw = dofus.graphics.gapi.ui.Panneau.BUTTON_WIDTH;
      this._x = Math.round((this.gapi.screenWidth - w) / 2);
      this._y = Math.round((this.gapi.screenHeight - h) / 2);
      // A shape alone lets clicks through to the map: a handler on it stops them.
      this.attachMovie("panneau/fond","_mcBg",10);
      this._mcBg.useHandCursor = false;
      var owner = this;
      this._mcBg.onPress = function()
      {
         owner.startDrag(false);
      };
      this._mcBg.onRelease = this._mcBg.onReleaseOutside = function()
      {
         owner.stopDrag();
      };
      this.attachMovie("Label","_lblTitle",20,{_x:p,_y:6,styleName:"WhiteLeftMediumBoldLabel",text:this._sTitle});
      this._lblTitle.setSize(w - 2 * p,20);
      this.attachMovie("Label","_lblText",30,{_x:p,_y:42,styleName:"BrownLeftMediumLabel",wordWrap:true,multiline:true,text:this._sText});
      this._lblText.setSize(w - 2 * p,h - 42 - 50);
      this.attachMovie("Button","_btnClose",40,{_x:(w - bw) / 2,_y:h - 38,styleName:"OrangeButton",backgroundUp:"ButtonNormalUp",backgroundDown:"ButtonNormalDown",label:this.api.lang.getText("CLOSE")});
      this._btnClose.setSize(bw,25);
      this._btnClose.addEventListener("click",this);
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnClose)
      {
         this.unloadThis();
      }
   }
}
