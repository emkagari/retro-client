class dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager
{
   var _api;
   var _chat;
   var _nCurrentPanel;
   var _nCurrentTemporaryPanel;
   static var NO_REPLACEMENT_PANEL = -1;
   static var MINIMAP = 0;
   static var SHORTCUTS = 1;
   static var FULL_WIDTH_FIGHTER_EFFECTS = 1001;
   var _bCurrentPanelInstanciated = false;
   function ChatReplacementPanelsManager(api, chat)
   {
      this._api = api;
      this._chat = chat;
      this._nCurrentPanel = dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.NO_REPLACEMENT_PANEL;
   }
   function get api()
   {
      return this._api;
   }
   function get chat()
   {
      return this._chat;
   }
   function get currentReplacementPanel()
   {
      return this._nCurrentPanel;
   }
   function get currentTemporaryReplacementPanel()
   {
      return this._nCurrentTemporaryPanel;
   }
   function set currentTemporaryReplacementPanel(nCurrentTemporaryReplacementPanel)
   {
      this._nCurrentTemporaryPanel = nCurrentTemporaryReplacementPanel;
   }
   function get isCurrentReplacementPanelTemporary()
   {
      return this._nCurrentTemporaryPanel != undefined && this._nCurrentTemporaryPanel == this._nCurrentPanel;
   }
   function instanciateCurrentReplacementPanel(aPanelArgs)
   {
      if(this._bCurrentPanelInstanciated)
      {
         return undefined;
      }
      this._bCurrentPanelInstanciated = true;
      switch(this._nCurrentPanel)
      {
         case dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP:
            this.instanciateMiniMap();
            break;
         case dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS:
            this.instanciateShortcuts();
            break;
         case dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.FULL_WIDTH_FIGHTER_EFFECTS:
            this.instanciateFighterEffectsPanel(aPanelArgs);
      }
      if(this._nCurrentPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP)
      {
         this._chat._mcMiniMapReplacementPanel._visible = true;
      }
      else
      {
         this._chat._mcReplacementPanel.setMask(this._chat._mcReplacementPanelMask);
         this._chat._mcReplacementPanel.addEventListener("click",this);
      }
   }
   function removeCurrentReplacementPanel()
   {
      if(!this._bCurrentPanelInstanciated)
      {
         return undefined;
      }
      this._bCurrentPanelInstanciated = false;
      this._chat._mcMiniMapReplacementPanel._visible = false;
      this._chat._mcReplacementPanel.removeEventListener("click",this);
      this._chat._mcReplacementPanel.removeMovieClip();
   }
   function instanciateMiniMap()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this._chat._mcMiniMapReplacementPanel == undefined)
      {
         _loc2_ = 150;
         _loc3_ = {_x:_loc2_,_y:this._chat._mcReplacementPanelMask._y,contentPath:"Map",enabled:true,showHintsMaxDistance:15,customBgScaleWidth:this._chat._mcReplacementPanelMask._width,customBgScaleHeight:this._chat._mcReplacementPanelMask._height,customBgScaleX:- _loc2_,customBgScaleY:0,customBgColor:14012330};
         _loc4_ = this._chat.attachMovie("MiniMap","_mcMiniMapReplacementPanel",dofus.graphics.gapi.controls.Chat.MINIMAP_REPLACEMENT_PANEL_DEPTH,_loc3_);
         _loc4_.addEventListener("click",this);
      }
      this._chat._mcMiniMapReplacementPanel.setMask(this._chat._mcReplacementPanelMask);
   }
   function instanciateShortcuts()
   {
      var _loc2_ = {_x:0,_y:0};
      this._chat.attachMovie("ShortcutsChatReplacementPanel","_mcReplacementPanel",dofus.graphics.gapi.controls.Chat.REPLACEMENT_PANEL_DEPTH,_loc2_);
      this.api.kernel.OptionsManager.setOption("MovableBar",false);
      this._chat._mcMiniMapReplacementPanel.removeEventListener("click",this);
      this._chat._mcMiniMapReplacementPanel.removeMovieClip();
   }
   function instanciateFighterEffectsPanel(aPanelArgs)
   {
      var _loc3_ = !(aPanelArgs != undefined && aPanelArgs.length > 0) ? undefined : aPanelArgs[0];
      var _loc4_ = {_x:0,_y:0,spriteData:_loc3_};
      this._chat.attachMovie("FighterEffectsReplacementPanel","_mcReplacementPanel",dofus.graphics.gapi.controls.Chat.REPLACEMENT_PANEL_DEPTH,_loc4_);
   }
   function changeReplacementPanel(nPanelWished, bUpdateOption, aPanelArgs)
   {
      var _loc6_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      if(_loc6_ == undefined || _loc6_.useFlashChat)
      {
         return undefined;
      }
      var _loc5_;
      if(this._nCurrentTemporaryPanel != undefined)
      {
         if(nPanelWished == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS && this._nCurrentTemporaryPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.FULL_WIDTH_FIGHTER_EFFECTS)
         {
            this._nCurrentTemporaryPanel = undefined;
            _loc5_ = nPanelWished;
         }
         else
         {
            _loc5_ = this._nCurrentTemporaryPanel;
         }
      }
      else
      {
         _loc5_ = nPanelWished;
      }
      var _loc7_ = _loc5_ != this._nCurrentPanel;
      var _loc8_ = nPanelWished != this.api.kernel.OptionsManager.getOption("chatReplacementPanel");
      this._nCurrentPanel = _loc5_;
      if(_loc8_ && bUpdateOption)
      {
         this.api.kernel.OptionsManager.setOption("chatReplacementPanel",nPanelWished);
      }
      if(_loc7_)
      {
         this.removeCurrentReplacementPanel();
      }
      if(_loc5_ != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.NO_REPLACEMENT_PANEL)
      {
         this.instanciateCurrentReplacementPanel(aPanelArgs);
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target._name)
      {
         case "_mcReplacementPanel":
         case "_mcReplacementPanelMask":
         case "_mcMiniMapReplacementPanel":
         case "_mcMiniMap":
         case "_mcMiniMapMask":
            _loc3_ = this.api.ui.createPopupMenu();
            _loc4_ = this.api.kernel.OptionsManager.getOption("chatReplacementPanel");
            _loc3_.addStaticItem(this.api.lang.getText("SHOW"));
            _loc3_.addItem(this.api.lang.getText("BANNER_MAP"),this,this.changeReplacementPanel,[dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP,true],_loc4_ != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP);
            _loc3_.addItem(this.api.lang.getText("BANNER_SHORTCUTS_BAR"),this,this.changeReplacementPanel,[dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS,true],_loc4_ != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS);
            _loc3_.show(_root._xmouse,_root._ymouse,true);
         default:
            return;
      }
   }
}
