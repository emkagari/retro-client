class dofus.graphics.gapi.controls.Chat extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bSmileysOpened;
   var _btnOpenClose;
   var _btnSitDown;
   var _btnSmileys;
   var _btnTemporaryEvent;
   var _chatFilters;
   var _mcMiniMapReplacementPanel;
   var _mcReplacementPanel;
   var _mcReplacementPanelMask;
   var _parent;
   var _replacementPanelsManager;
   var _sSmileys;
   var _txtChat;
   var _y;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   static var CLASS_NAME = "Chat";
   static var OPEN_OFFSET = 350;
   static var XTRA_MASK_OPEN_OFFSET = 300;
   static var REPLACEMENT_PANEL_DEPTH = 10;
   static var MINIMAP_REPLACEMENT_PANEL_DEPTH = 9;
   var _bOpened = false;
   function Chat()
   {
      super();
   }
   function get replacementPanelsManager()
   {
      return this._replacementPanelsManager;
   }
   function get shortcutsReplacementPanel()
   {
      if(this.replacementPanelsManager.currentReplacementPanel != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS)
      {
         return undefined;
      }
      return dofus.graphics.gapi.controls.chat.ShortcutsChatReplacementPanel(this._mcReplacementPanel);
   }
   function get miniMapReplacementPanel()
   {
      if(this.replacementPanelsManager.currentReplacementPanel != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP)
      {
         return undefined;
      }
      return dofus.graphics.gapi.controls.MiniMap(this._mcMiniMapReplacementPanel);
   }
   function get fightSpectatorReplacementPanel()
   {
      if(this.replacementPanelsManager.currentReplacementPanel != dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.FULL_WIDTH_FIGHTER_EFFECTS)
      {
         return undefined;
      }
      return dofus.graphics.gapi.controls.chat.FighterEffectsReplacementPanel(this._mcReplacementPanel);
   }
   function get filters()
   {
      return this._chatFilters.filters;
   }
   function get selectable()
   {
      return this._txtChat.selectable;
   }
   function set selectable(bSelectable)
   {
      this._txtChat.selectable = bSelectable;
   }
   function get isAutoScrollingEnabled()
   {
      return this._txtChat.isAutoScrollingEnabled;
   }
   function set isAutoScrollingEnabled(bAutoScrolling)
   {
      this._txtChat.isAutoScrollingEnabled = bAutoScrolling;
   }
   function open(bOpen)
   {
      var _loc3_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      if(_loc3_ != undefined && (!_loc3_.useFlashChat && !bOpen))
      {
         return undefined;
      }
      if(bOpen == !this._bOpened)
      {
         return undefined;
      }
      var _loc4_;
      if(!bOpen && this.api.datacenter.Player.isAuthorized)
      {
         if(this.api.kernel.OptionsManager.getOption("DebugSizeIndex") != dofus.graphics.gapi.ui.Debug.CONSOLE_MINIMIZED)
         {
            _loc4_ = dofus.graphics.gapi.ui.Debug(this.api.ui.getUIComponent("Debug"));
            if(_loc4_ != undefined)
            {
               this.api.kernel.OptionsManager.setOption("DebugSizeIndex",dofus.graphics.gapi.ui.Debug.CONSOLE_MINIMIZED);
               _loc4_.applySizeIndex(false);
            }
         }
      }
      this._btnOpenClose.selected = !bOpen;
      var _loc5_;
      if(bOpen)
      {
         _loc5_ = -1;
      }
      else
      {
         _loc5_ = 1;
      }
      this._txtChat.setSize(this._txtChat.width,this._txtChat.height + _loc5_ * dofus.graphics.gapi.controls.Chat.OPEN_OFFSET);
      var _loc6_ = this._mcReplacementPanelMask._height + _loc5_ * dofus.graphics.gapi.controls.Chat.XTRA_MASK_OPEN_OFFSET;
      this._mcReplacementPanelMask._height = _loc6_;
      var _loc7_ = this.miniMapReplacementPanel;
      if(_loc7_ != undefined)
      {
         _loc7_.customBgScaleHeight = this._mcReplacementPanelMask._height;
         _loc7_.setScale(dofus.graphics.gapi.controls.MiniMap.SCALE_CUSTOM,true);
      }
      this._y -= _loc5_ * dofus.graphics.gapi.controls.Chat.OPEN_OFFSET;
      this._bOpened = !bOpen;
   }
   function useReplacementPanel(nReplacementPanel, aArgs)
   {
      var _loc4_ = nReplacementPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.NO_REPLACEMENT_PANEL;
      this._chatFilters._visible = _loc4_;
      this._txtChat._visible = _loc4_;
      this._mcReplacementPanel._visible = !_loc4_;
      this._mcMiniMapReplacementPanel._visible = nReplacementPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP && (!_loc4_ && !this._replacementPanelsManager.isCurrentReplacementPanelTemporary);
      this._mcReplacementPanelMask._visible = !_loc4_;
      this.addToQueue({object:this._replacementPanelsManager,method:this._replacementPanelsManager.changeReplacementPanel,params:[nReplacementPanel,undefined,aArgs]});
   }
   function useTemporaryReplacementPanel(nReplacementPanel, aArgs)
   {
      this._replacementPanelsManager.currentTemporaryReplacementPanel = nReplacementPanel;
      this.addToQueue({object:this._replacementPanelsManager,method:this._replacementPanelsManager.changeReplacementPanel,params:[nReplacementPanel,undefined,aArgs]});
   }
   function removeTemporaryReplacementPanel()
   {
      this.replacementPanelsManager.currentTemporaryReplacementPanel = undefined;
      var _loc2_ = this.api.kernel.OptionsManager.getOption("chatReplacementPanel");
      this.addToQueue({object:this._replacementPanelsManager,method:this._replacementPanelsManager.changeReplacementPanel,params:[_loc2_]});
   }
   function setText(sText)
   {
      this._txtChat.text = sText;
   }
   function updateSmileysEmotes()
   {
      this._sSmileys.update();
   }
   function hideSmileys(bHide)
   {
      this._sSmileys._visible = !bHide;
      this._bSmileysOpened = !bHide;
   }
   function showSitDown(bShow)
   {
      this._btnSitDown._visible = bShow;
   }
   function selectFilter(nFilter, bSelect)
   {
      this._chatFilters.selectFilter(nFilter,bSelect);
   }
   function displayChatHelp()
   {
      this.api.kernel.Console.process("/help");
      this.open(false);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.Chat.CLASS_NAME);
      this._replacementPanelsManager = new dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager(this.api,this);
      this.api.kernel.ChatManager.updateRigth();
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTemporaryEvent});
      this.hideSmileys(true);
   }
   function addListeners()
   {
      this._btnOpenClose.addEventListener("click",this);
      this._btnSmileys.addEventListener("click",this);
      this._btnSitDown.addEventListener("click",this);
      this._btnOpenClose.addEventListener("over",this);
      this._btnSmileys.addEventListener("over",this);
      this._btnSitDown.addEventListener("over",this);
      this._btnOpenClose.addEventListener("out",this);
      this._btnSmileys.addEventListener("out",this);
      this._btnSitDown.addEventListener("out",this);
      this._sSmileys.addEventListener("selectSmiley",this);
      this._sSmileys.addEventListener("selectEmote",this);
      this._txtChat.addEventListener("href",this);
      this._chatFilters.addEventListener("filterChanged",this);
      var chat = this;
      this._mcReplacementPanelMask.onRelease = function()
      {
         var _loc2_ = {};
         _loc2_.target = this;
         chat.replacementPanelsManager.click(_loc2_);
      };
      this._btnTemporaryEvent.onRelease = function()
      {
         this._parent.click({target:this});
      };
      this.api.kernel.ChatManager.refresh();
   }
   function initTemporaryEvent()
   {
      this._btnTemporaryEvent.eventID = this.api.datacenter.Basics.temporaryEventID;
   }
   function filterChanged(oEvent)
   {
      this.dispatchEvent({type:"filterChanged",filter:oEvent.filter,selected:oEvent.selected});
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnSitDown:
            this.api.sounds.events.onBannerChatButtonClick();
            _loc3_ = this.api.lang.getEmoteID("sit");
            if(_loc3_ != undefined)
            {
               this.api.network.Emotes.useEmote(_loc3_);
            }
            break;
         case this._btnSmileys:
            this.api.sounds.events.onBannerChatButtonClick();
            this.hideSmileys(this._bSmileysOpened);
            break;
         case this._btnOpenClose:
            this.api.sounds.events.onBannerChatButtonClick();
            this.open(!oEvent.target.selected);
            break;
         case this._btnTemporaryEvent:
            this.api.sounds.events.onBannerChatButtonClick();
            this.api.ui.loadUIComponent("TemporaryEvent","TemporaryEvent");
         default:
            return;
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnSmileys:
            this.gapi.showTooltip(this.api.lang.getText("CHAT_SHOW_SMILEYS"));
            break;
         case this._btnOpenClose:
            this.gapi.showTooltip(this.api.lang.getText("CHAT_SHOW_MORE"));
            break;
         case this._btnSitDown:
            this.gapi.showTooltip(this.api.lang.getText("SITDOWN_TOOLTIP"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function selectSmiley(oEvent)
   {
      if(!this.api.datacenter.Player.data.isInMove)
      {
         this.dispatchEvent(oEvent);
         if(this.api.kernel.OptionsManager.getOption("AutoHideSmileys"))
         {
            this.hideSmileys(true);
            this._btnSmileys.selected = false;
         }
      }
   }
   function selectEmote(oEvent)
   {
      if(!this.api.datacenter.Player.data.isInMove)
      {
         this.dispatchEvent(oEvent);
         if(this.api.kernel.OptionsManager.getOption("AutoHideSmileys"))
         {
            this.hideSmileys(true);
            this._btnSmileys.selected = false;
         }
      }
   }
   function href(oEvent_, oCustomPopupPosition)
   {
      var _loc4_ = oEvent_.params.split(",");
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      switch(_loc4_[0])
      {
         case "showEndPanel":
            this.addToQueue({object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.showEndPanel,params:[_loc4_[1]]});
            break;
         case "HunterAcceptPvPHunt":
            this.addToQueue({object:this.api.network.Game,method:this.api.network.Game.hunterAcceptPvPHunt});
            break;
         case "OpenGuildTaxCollectors":
            _loc5_ = this.gapi.getUIComponent("Guild");
            if(_loc5_ == null)
            {
               this.addToQueue({object:this.gapi,method:this.gapi.loadUIAutoHideComponent,params:["Guild","Guild",{currentTab:"TaxCollectors"},{bStayIfPresent:true}]});
            }
            else
            {
               this.addToQueue({object:_loc5_,method:_loc5_.setCurrentTab,params:["TaxCollectors"]});
            }
            break;
         case "OpenPayZoneDetails":
            this.addToQueue({object:this.gapi,method:this.gapi.loadUIComponent,params:["PayZoneDialog2","PayZoneDialog2",{name:"El Pemy",gfx:"9059",dialogID:dofus.graphics.gapi.ui.PayZoneDialog.PAYZONE_DETAILS},{bForceLoad:true}]});
            break;
         case "ShowPlayerPopupMenu":
            this.addToQueue({object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.showPlayerPopupMenu,params:[undefined,{sPlayerID:_global.unescape(_loc4_[1]),sPlayerName:_global.unescape(_loc4_[2]),bShowJoinFriend:this.api.datacenter.Player.isAuthorized,oCustomPopupPosition:oCustomPopupPosition}]});
            break;
         case "ShowMessagePopupMenu":
            this.addToQueue({object:this.api.kernel.GameManager,method:this.api.kernel.GameManager.showMessagePopupMenu,params:[_global.unescape(_loc4_[1]),_global.unescape(_loc4_[2]),_global.unescape(_loc4_[3]),oCustomPopupPosition]});
            break;
         case "ShowItemViewer":
            _loc6_ = this.api.kernel.ChatManager.getItemFromBuffer(Number(_loc4_[1]));
            if(_loc6_ == undefined)
            {
               this.addToQueue({object:this.api.kernel,method:this.api.kernel.showMessage,params:[this.api.lang.getText("ERROR_WORD"),this.api.lang.getText("ERROR_ITEM_CANT_BE_DISPLAYED"),"ERROR_BOX"]});
            }
            else
            {
               _loc7_ = {id:_loc6_._nUnicID,effects:_loc6_._sEffects,displayWarning:true};
               _loc8_ = !_loc6_.isConsideredAsEquipementInEncyclopediaDetailWindow ? "Ressources" : "Equipments";
               this.api.ui.loadUIComponent("EncyclopediaDetailsWindow","EncyclopediaDetailsWindow",{component:_loc8_,data:_loc7_});
            }
            break;
         case "updateCompass":
            this.api.kernel.GameManager.updateCompass(Number(_loc4_[1]),Number(_loc4_[2]));
            break;
         case "ShowLinkWarning":
            this.addToQueue({object:this.api.ui,method:this.api.ui.loadUIComponent,params:["AskLinkWarning","AskLinkWarning",{text:this.api.lang.getText(_loc4_[1])}]});
            break;
         case "highlightSprite":
            if(this.api.datacenter.Game.isRunning)
            {
               _loc9_ = 1;
               while(_loc9_ < _loc4_.length)
               {
                  _loc10_ = _loc4_[_loc9_];
                  _loc11_ = this.api.datacenter.Sprites.getItemAt(_loc10_);
                  if(_loc11_ != undefined)
                  {
                     if(!(!_loc11_.isVisible || _loc11_.isClear))
                     {
                        _loc12_ = _loc11_.cellNum;
                        if(_loc12_ != undefined)
                        {
                           this.addToQueue({object:this.api.gfx.mapHandler,method:this.api.gfx.mapHandler.flagCellNonBlocking,params:[_loc12_,_loc10_]});
                        }
                     }
                  }
                  _loc9_ = _loc9_ + 1;
               }
            }
            break;
         case "highlightCell":
            _loc13_ = _loc4_[1];
            if(_loc13_ != undefined)
            {
               _loc14_ = this.api.gfx.mapHandler.getCellData(_loc13_);
               if(_loc14_.isTargetable)
               {
                  this.addToQueue({object:this.api.gfx.mapHandler,method:this.api.gfx.mapHandler.flagCellNonBlocking,params:[_loc13_]});
               }
               else
               {
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR",[this.api.lang.getText("THIS_CELL_IS_NOT_TARGETABLE")]),"ERROR_CHAT");
               }
            }
            break;
         case "acceptTeleport":
            this.api.network.Party.acceptTeleport();
            break;
         case "viewAchievement":
            _loc15_ = _loc4_[1];
            if(_loc15_ != undefined)
            {
               this.api.ui.loadUIAutoHideComponent("Achievements","Achievements",{displayAchievement:_loc15_},{bStayIfPresent:true});
            }
            break;
         case "viewBestiary":
            _loc16_ = _loc4_[1];
            _loc17_ = {id:_loc16_};
            this.api.ui.loadUIComponent("EncyclopediaDetailsWindow","EncyclopediaDetailsWindow",{component:"Bestiary",data:_loc17_});
         default:
            return;
      }
   }
}
