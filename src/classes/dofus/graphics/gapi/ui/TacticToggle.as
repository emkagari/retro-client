/**
 * Tactic mode button, in and out of fights, at the end of the chat's button
 * row: after its last visible button (emotes, sit down, temporary event),
 * drawn like them — a white tab rounded at the bottom — with the fight
 * button's icon (FightOptionButtons) inside, pressed while the mode is on.
 * Both buttons switch the same state (dofus.datacenter.Game.isTacticMode,
 * static: it outlives fights), which dofus.aks.Game.onMapLoaded applies
 * again on every map.
 *
 * Loaded by dofus.aks.Game.onMapLoaded, in the top UI layer (the banner, loaded
 * later, would hide it); clip "UI_TacticToggle" in src/symbols.json.
 */
class dofus.graphics.gapi.ui.TacticToggle extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   static var CLASS_NAME = "TacticToggle";
   static var TAB_COLOR = 16777215;
   static var TAB_RADIUS = 5;
   /** Icon height, as a share of the tab's. */
   static var ICON_RATIO = 0.75;
   var _mcButton;
   var _mcTab;
   var _mcIconUp;
   var _mcIconDown;
   var _nWidth = 0;
   var _nHeight = 0;
   var api;
   var gapi;
   var createEmptyMovieClip;
   var onEnterFrame;
   function TacticToggle()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.TacticToggle.CLASS_NAME);
   }
   function createChildren()
   {
      this._mcButton = this.createEmptyMovieClip("_mcButton",10);
      this._mcButton._visible = false;
      this._mcTab = this._mcButton.createEmptyMovieClip("_mcTab",10);
      this._mcIconUp = this._mcButton.attachMovie("UI_FightOptionTacticModeUp","_mcIconUp",20);
      this._mcIconDown = this._mcButton.attachMovie("UI_FightOptionTacticModeDown","_mcIconDown",30);
      var self = this;
      this._mcButton.onRelease = function()
      {
         self.click();
      };
      this._mcButton.onRollOver = function()
      {
         self.over();
      };
      this._mcButton.onRollOut = this._mcButton.onReleaseOutside = function()
      {
         self.out();
      };
      this.onEnterFrame = function()
      {
         self.update();
      };
   }
   /** In game only (the banner is there), after the chat's buttons; follows the state switched elsewhere. */
   function update()
   {
      var chat = this.gapi.getUIComponent("Banner")._cChat;
      var visible = chat != undefined;
      if(this._mcButton._visible != visible)
      {
         this._mcButton._visible = visible;
      }
      if(!visible)
      {
         return undefined;
      }
      this.place(chat);
      var on = this.api.datacenter.Game.isTacticMode == true;
      if(this._mcIconDown._visible != on)
      {
         this._mcIconDown._visible = on;
         this._mcIconUp._visible = !on;
      }
   }
   /**
    * After the row's last VISIBLE button (out of fights: sit down, or the
    * temporary event one; in fights sit down is hidden), as far from it as
    * two neighbours of the row are from each other, as big as the emotes button.
    */
   function place(chat)
   {
      var row = [chat._btnOpenClose,chat._btnHelpForPanel,chat._btnSmileys,chat._btnSitDown,chat._btnTemporaryEvent];
      var shown = [];
      var i = 0;
      while(i < row.length)
      {
         if(row[i] != undefined && row[i]._visible)
         {
            shown.push(row[i].getBounds(this));
         }
         i = i + 1;
      }
      if(shown.length == 0)
      {
         return undefined;
      }
      shown.sortOn("xMin",Array.NUMERIC);
      var last = shown[shown.length - 1];
      var gap = shown.length > 1 ? shown[1].xMin - shown[0].xMax : 0;
      var size = chat._btnSmileys.getBounds(this);
      var w = size.xMax - size.xMin;
      var h = size.yMax - size.yMin;
      this._mcButton._x = last.xMax + Math.max(gap,0);
      this._mcButton._y = size.yMin;
      if(w != this._nWidth || h != this._nHeight)
      {
         this._nWidth = w;
         this._nHeight = h;
         this.drawTab(w,h);
      }
   }
   function drawTab(w, h)
   {
      var r = dofus.graphics.gapi.ui.TacticToggle.TAB_RADIUS;
      this._mcTab.clear();
      this.drawRoundRect(this._mcTab,0,0,w,h,{tl:0,tr:0,br:r,bl:r},dofus.graphics.gapi.ui.TacticToggle.TAB_COLOR);
      this.fit(this._mcIconUp,w,h);
      this.fit(this._mcIconDown,w,h);
   }
   /** The icon scaled to the tab's height, centered in it. */
   function fit(mc, w, h)
   {
      mc._xscale = mc._yscale = 100;
      var b = mc.getBounds(mc);
      var scale = dofus.graphics.gapi.ui.TacticToggle.ICON_RATIO * h / (b.yMax - b.yMin);
      mc._xscale = mc._yscale = 100 * scale;
      mc._x = (w - (b.xMax - b.xMin) * scale) / 2 - b.xMin * scale;
      mc._y = (h - (b.yMax - b.yMin) * scale) / 2 - b.yMin * scale;
   }
   function click()
   {
      var bTactic = !this.api.datacenter.Game.isTacticMode;
      this.api.datacenter.Game.isTacticMode = bTactic;
      this.api.gfx.activateTacticMode(this.api,bTactic);
   }
   function over()
   {
      this.gapi.showTooltip(this.api.lang.getText("TACTIC_MODE"));
   }
   function out()
   {
      this.gapi.hideTooltip();
   }
}
