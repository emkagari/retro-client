class dofus.graphics.gapi.controls.chat.ShortcutsChatReplacementPanel extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _banner;
   var _lblName;
   var _lstEffects;
   var _mcMiniMap;
   var _mcMiniMapMask;
   var _mouseShortcuts;
   var _oSpriteData;
   var addToQueue;
   var attachMovie;
   var getNextHighestDepth;
   static var CLASS_NAME = "ShortcutsChatReplacementPanel";
   static var MAX_CONTAINER = 16;
   function ShortcutsChatReplacementPanel()
   {
      super();
   }
   function get miniMap()
   {
      return this._mcMiniMap;
   }
   function set spriteData(oSpriteData)
   {
      this._oSpriteData = oSpriteData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.chat.ShortcutsChatReplacementPanel.CLASS_NAME);
      this._banner = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      this._mouseShortcuts = this._banner.shortcuts;
   }
   function createChildren()
   {
      this.showMiniMap(true);
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function updateSprite(oSpriteData)
   {
      this.api.ui.hideTooltip();
      this._oSpriteData = oSpriteData;
      this.addToQueue({object:this,method:this.initData});
   }
   function getContainer(nID)
   {
      return this["_ctr" + nID];
   }
   function setContainer(nID, cContainer)
   {
      this["_ctr" + nID] = cContainer;
   }
   function initData()
   {
      this._lstEffects.scrollFromEverywhere = true;
      if(this._oSpriteData == undefined)
      {
         this._lblName.text = "";
         this._lstEffects.dataProvider = undefined;
      }
      else
      {
         this._lblName.text = this._oSpriteData.name + " (" + this.api.lang.getText("LEVEL_SMALL") + this._oSpriteData.Level + ")";
         this._lstEffects.dataProvider = this._oSpriteData.EffectsManager.getEffects();
      }
   }
   function showMiniMap(bShow)
   {
      if(bShow)
      {
         this.instanciateMiniMap();
      }
      this._mcMiniMap._visible = bShow;
      this._mcMiniMapMask._visible = bShow;
   }
   function instanciateMiniMap()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this._mcMiniMap == undefined)
      {
         _loc2_ = 72;
         _loc3_ = {_x:_loc2_,_y:this._mcMiniMapMask._y,contentPath:"Map",enabled:true,showHintsMaxDistance:10,customBgScaleWidth:this._mcMiniMapMask._width,customBgScaleHeight:this._mcMiniMapMask._height,customBgScaleX:- _loc2_,customBgScaleY:0,customBgColor:14012330};
         _loc4_ = this.attachMovie("MiniMap","_mcMiniMap",this.getNextHighestDepth(),_loc3_);
         _loc4_.addEventListener("click",this._banner.chat.replacementPanelsManager);
      }
      this._mcMiniMap.setMask(this._mcMiniMapMask);
   }
   function initTexts()
   {
   }
   function addListeners()
   {
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc2_ < dofus.graphics.gapi.controls.chat.ShortcutsChatReplacementPanel.MAX_CONTAINER)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc4_ = 15 + _loc2_;
         this._mouseShortcuts.setContainer(_loc4_,_loc3_);
         _loc3_.addEventListener("click",this._mouseShortcuts);
         _loc3_.addEventListener("dblClick",this._mouseShortcuts);
         _loc3_.addEventListener("over",this._mouseShortcuts);
         _loc3_.addEventListener("out",this._mouseShortcuts);
         _loc3_.addEventListener("drag",this._mouseShortcuts);
         _loc3_.addEventListener("drop",this._mouseShortcuts);
         _loc3_.addEventListener("onContentLoaded",this._mouseShortcuts);
         _loc3_.params = {position:_loc4_};
         _loc2_ = _loc2_ + 1;
      }
      this._mouseShortcuts.updateCurrentTabInformations();
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      var chat = this._banner.chat;
      this._mcMiniMapMask.onRelease = function()
      {
         var _loc2_ = {};
         _loc2_.target = this;
         chat.replacementPanelsManager.click(_loc2_);
      };
   }
   function onShortcut(shortcut)
   {
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < dofus.graphics.gapi.controls.chat.ShortcutsChatReplacementPanel.MAX_CONTAINER)
      {
         if(shortcut == "MOVABLEBAR_SH" + _loc3_)
         {
            _loc4_ = 15 + _loc3_;
            _loc5_ = this._mouseShortcuts.getContainer(_loc4_);
            if(_loc5_ != undefined)
            {
               _loc5_.emulateClick();
               return false;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      return true;
   }
}
