17453258 - 1;
class dofus.graphics.gapi.ui.Banner extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aBannerLayout;
   var _bIsMutant;
   var _bIsOnFocus;
   var _bMoreButton;
   var _btnAchievement;
   var _btnEncyclopedia;
   var _btnEvenementialServer;
   var _btnFights;
   var _btnFriends;
   var _btnGiveUp;
   var _btnGuild;
   var _btnHelp;
   var _btnHelpForPanel;
   var _btnInventory;
   var _btnJob;
   var _btnMap;
   var _btnMore;
   var _btnMount;
   var _btnNextTurn;
   var _btnPvP;
   var _btnQuests;
   var _btnSpells;
   var _btnStatsJob;
   var _btnTemporis;
   var _btnTitle;
   var _cChat;
   var _ccChrono;
   var _circleXtra;
   var _hHeart;
   var _lastKeyIsShortcut;
   var _lblFinalCountDown;
   var _mcBgTxtConsole;
   var _mcCircleXtraMask;
   var _mcCircleXtraMaskBig;
   var _mcCircleXtraPlacer;
   var _mcMoreButtonBg;
   var _mcRightPanel;
   var _mcRightPanelPlacer;
   var _mcXtra;
   var _mcbMovableBar;
   var _msShortcuts;
   var _nAutoCompleteTimeout;
   var _oData;
   var _parent;
   var _pvAP;
   var _pvMP;
   var _sCurrentCircleXtra;
   var _txtConsole;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var parentNode_;
   var setMovieClipTransform;
   static var CHECK_MOUSE_POSITION_REFRESH_RATE = 250;
   static var CLASS_NAME = "Banner";
   static var DRAGGABLE_BUTTON_EVENTS = ["click","over","out","drag","drop"];
   static var BUTTONS_EVENTS = ["click","over","out"];
   static var BUTTONS_IN_BANNER = 9;
   static var BANNER_LAYOUT_VERSION = 2;
   static var BANNER_DEFAULT_LAYOUT = ["_btnStatsJob","_btnSpells","_btnInventory","_btnQuests","_btnMap","_btnFriends","_btnGuild","_btnPvP","_btnMore","_btnEncyclopedia","_btnTitle","_btnEvenementialServer","_btnAchievement","_btnJob","_btnMount"];
   var _nFightsCount = 0;
   var _bChatAutoFocus = true;
   var _sChatPrefix = "";
   var _bHeartMovedTop = false;
   var _bUseFlashChat = true;
   function Banner()
   {
      super();
   }
   function get currentOverItem()
   {
      return this._msShortcuts.currentOverItem;
   }
   function get useFlashChat()
   {
      return this._bUseFlashChat;
   }
   function get circleXtra()
   {
      return this._circleXtra;
   }
   function get chatPrefix()
   {
      return this._sChatPrefix;
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function get fightsCount()
   {
      return this._nFightsCount;
   }
   function set fightsCount(nFightsCount)
   {
      this._nFightsCount = nFightsCount;
      this.updateEye();
   }
   function get chatAutoFocus()
   {
      return this._bChatAutoFocus;
   }
   function set chatAutoFocus(bChatAutoFocus)
   {
      this._bChatAutoFocus = bChatAutoFocus;
   }
   function get txtConsole()
   {
      return this._txtConsole.text;
   }
   function set txtConsole(sText)
   {
      this._txtConsole.text = sText;
   }
   function get chat()
   {
      return this._cChat;
   }
   function get shortcuts()
   {
      return this._msShortcuts;
   }
   function get illustration()
   {
      return this._mcXtra;
   }
   function get illustrationType()
   {
      return this._sCurrentCircleXtra;
   }
   function updateEye()
   {
      if(this._btnFights.icon == "")
      {
         this._btnFights.icon = "Eye2";
      }
      var _loc2_ = this._nFightsCount != 0 && !this.api.datacenter.Game.isFight;
      this._btnFights._visible = _loc2_;
   }
   function setSelectable(bSelectable)
   {
      this._cChat.selectable = bSelectable;
   }
   function setChatAutoScroll(bAutoScroll)
   {
      this._cChat.isAutoScrollingEnabled = bAutoScroll;
   }
   function insertChat(sText)
   {
      if(this._bUseFlashChat)
      {
         this._txtConsole.text += sText;
      }
      else
      {
         this.api.electron.retroChatInsertPromptText(sText);
      }
   }
   function showNextTurnButton(bShow)
   {
      this._btnNextTurn._visible = bShow;
   }
   function showGiveUpButton(bShow)
   {
      if(bShow)
      {
         this._circleXtra.setXtraFightMask(true);
      }
      this._btnGiveUp._visible = bShow;
   }
   function get giveUpButtonVisible()
   {
      return this._btnGiveUp._visible;
   }
   function showOverweightPods(bShow_)
   {
      this._circleXtra.setXtraMaskOverweight(bShow_);
   }
   function moveHeart(bTop)
   {
      if(bTop)
      {
         if(!this._bHeartMovedTop)
         {
            this._hHeart._y -= 30;
         }
      }
      else if(this._bHeartMovedTop)
      {
         this._hHeart._y += 30;
      }
      this._bHeartMovedTop = bTop;
   }
   function showPoints(bShow)
   {
      this._pvAP._visible = bShow;
      this._pvMP._visible = bShow;
      this._cChat.showSitDown(!bShow);
      if(bShow)
      {
         this._oData.data.addEventListener("lpChanged",this);
         this._oData.data.addEventListener("apChanged",this);
         this._oData.data.addEventListener("mpChanged",this);
         this.apChanged({value:Math.max(0,this._oData.data.AP)});
         this.mpChanged({value:Math.max(0,this._oData.data.MP)});
      }
   }
   function startTimer(nDuration)
   {
      this.moveHeart(false);
      this._circleXtra.setXtraFightMask(true);
      if(this.api.kernel.TutorialManager.isTutorialModeInFight)
      {
         this._ccChrono.setGaugeChrono(0,16737792);
      }
      this._ccChrono.startTimer(nDuration);
   }
   function redrawChrono()
   {
      this._ccChrono.redraw();
   }
   function stopTimer()
   {
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.redrawChrono();
      }
      this._ccChrono.stopTimer();
   }
   function setChatText(sText)
   {
      this._cChat.setText(sText);
   }
   function showRightPanel(sPanelName, oParams, bSpecForce, bMouseSpriteRollover)
   {
      if(this.api.datacenter.Game.isSpectator && this._mcRightPanel.bMouseSpriteRollover == true)
      {
         return undefined;
      }
      if(this._mcRightPanel.className == sPanelName && !(this.api.datacenter.Game.isSpectator && bSpecForce == true))
      {
         return undefined;
      }
      var _loc6_;
      var _loc7_;
      if(!(this.api.datacenter.Game.isSpectator && bSpecForce != true))
      {
         _loc6_ = this.chat.fightSpectatorReplacementPanel;
         if(_loc6_ != undefined)
         {
            _loc6_.update(oParams.data);
         }
         else if(this.api.kernel.OptionsManager.getOption("SpriteInfos"))
         {
            if(this.chat.replacementPanelsManager.currentReplacementPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS)
            {
               this.chat.shortcutsReplacementPanel.showMiniMap(false);
               this.chat.shortcutsReplacementPanel.updateSprite(oParams.data);
            }
            else
            {
               this.chat.useTemporaryReplacementPanel(dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.FULL_WIDTH_FIGHTER_EFFECTS,[oParams.data]);
            }
         }
         if(this._mcRightPanel.className == sPanelName)
         {
            this._mcRightPanel.update(oParams.data);
         }
         else
         {
            if(this._mcRightPanel != undefined)
            {
               this.hideRightPanel(true);
            }
            oParams._x = this._mcRightPanelPlacer._x;
            oParams._y = this._mcRightPanelPlacer._y;
            _loc7_ = this.attachMovie(sPanelName,"_mcRightPanel",this.getNextHighestDepth(),oParams);
            _loc7_.swapDepths(this._mcRightPanelPlacer);
            _loc7_.parentNode_ = this;
            _loc7_.onRollOver = function()
            {
               this.parentNode_.hideRightPanel(true);
            };
         }
         this._mcRightPanel.bMouseSpriteRollover = bMouseSpriteRollover;
      }
   }
   function hideRightPanel(bSpecForce, bMouseSpriteRollout)
   {
      if(bMouseSpriteRollout)
      {
         this._mcRightPanel.bMouseSpriteRollover = false;
      }
      if(this._mcRightPanel != undefined && !(this.api.datacenter.Game.isSpectator && bSpecForce != true))
      {
         this._mcRightPanel.swapDepths(this._mcRightPanelPlacer);
         this._mcRightPanel.removeMovieClip();
      }
   }
   function updateSmileysEmotes()
   {
      this._cChat.updateSmileysEmotes();
   }
   function showSmileysEmotesPanel(bShow)
   {
      if(bShow == undefined)
      {
         bShow = true;
      }
      this._cChat.hideSmileys(!bShow);
      this._cChat._btnSmileys.selected = bShow;
   }
   function updateLocalPlayer()
   {
      this._circleXtra.updateArtwork(false);
      this._bIsMutant = this._oData.isMutant && !this.api.datacenter.Player.isAuthorized;
      this._msShortcuts.meleeVisible = !this._oData.isMutant && this._msShortcuts.currentTab == dofus.graphics.gapi.controls.MouseShortcuts.TAB_SPELLS;
   }
   function setCurrentTab(oEvent)
   {
      this._msShortcuts.setCurrentTab(oEvent);
   }
   function isButtonInMorePanel(sButtonName)
   {
      var _loc3_ = this.api.kernel.OptionsManager.getOption("BannerLayout");
      var _loc4_ = dofus.graphics.gapi.ui.Banner.BUTTONS_IN_BANNER;
      while(_loc4_ < _loc3_.length)
      {
         if(sButtonName == _loc3_[_loc4_])
         {
            return true;
         }
         _loc4_ = _loc4_ + 1;
      }
      return false;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Banner.CLASS_NAME);
      this._circleXtra = new dofus.graphics.gapi.ui.banner.BannerCircleXtra(this.api,this);
   }
   function createChildren()
   {
      this._btnFights._visible = false;
      this.addToQueue({object:this,method:this.initBannerLayout});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.showPoints(false);
      this.showNextTurnButton(false);
      this.showGiveUpButton(false);
      this.hideMoreButtons();
      this._mcRightPanelPlacer._visible = false;
      this._mcCircleXtraPlacer._visible = false;
      this.api.ui.unloadUIComponent("FightOptionButtons");
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this.api.kernel.KeyManager.addKeysListener("onKeys",this);
      this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_ON_CONNECT);
      this.api.network.Game.nLastMapIdReceived = -1;
      this._txtConsole.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
      this._txtConsole.onKillFocus = function()
      {
         this._parent.onKillFocus();
      };
      this._txtConsole.maxChars = dofus.Constants.MAX_MESSAGE_LENGTH + dofus.Constants.MAX_MESSAGE_LENGTH_MARGIN;
      ank.battlefield.Battlefield.useCacheAsBitmapOnStaticAnim = this.api.lang.getConfigText("USE_CACHEASBITMAP_ON_STATICANIM");
      var _loc2_ = this.api.datacenter.Basics.forceFlashChat || (!this.api.kernel.OptionsManager.getOption("EnableWidescreenPanels") || !this.api.electron.isShowingWidescreenPanel);
      this.addToQueue({object:this,method:this.configureUseFlashChat,params:[_loc2_]});
   }
   function linkMovableContainer()
   {
      var _loc2_ = this._mcbMovableBar.containers;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         this._msShortcuts.setContainer(_loc3_ + 15,_loc4_);
         _loc4_.addEventListener("click",this._msShortcuts);
         _loc4_.addEventListener("dblClick",this._msShortcuts);
         _loc4_.addEventListener("over",this._msShortcuts);
         _loc4_.addEventListener("out",this._msShortcuts);
         _loc4_.addEventListener("drag",this._msShortcuts);
         _loc4_.addEventListener("drop",this._msShortcuts);
         _loc4_.addEventListener("onContentLoaded",this._msShortcuts);
         _loc4_.params = {position:_loc3_ + 15};
         _loc3_ = _loc3_ + 1;
      }
   }
   function registerButtonEvents(aButtons, aEvents)
   {
      var _loc4_ = aButtons.length;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = this[aButtons[_loc5_]];
         _loc7_ = 0;
         while(_loc7_ < aEvents.length)
         {
            _loc6_.addEventListener(aEvents[_loc7_],this);
            _loc7_ = _loc7_ + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function addListeners()
   {
      this.registerButtonEvents(this._aBannerLayout,dofus.graphics.gapi.ui.Banner.DRAGGABLE_BUTTON_EVENTS);
      this.registerButtonEvents(["_btnFights","_btnHelp","_btnNextTurn","_btnGiveUp"],dofus.graphics.gapi.ui.Banner.BUTTONS_EVENTS);
      var _loc2_ = this._ccChrono;
      _loc2_.addEventListener("finalCountDown",this);
      _loc2_.addEventListener("beforeFinalCountDown",this);
      _loc2_.addEventListener("tictac",this);
      _loc2_.addEventListener("finish",this);
      var _loc3_ = this._cChat;
      _loc3_.addEventListener("filterChanged",this);
      _loc3_.addEventListener("selectSmiley",this);
      _loc3_.addEventListener("selectEmote",this);
      this._oData.addEventListener("lpChanged",this);
      this._oData.addEventListener("lpMaxChanged",this);
      this._pvAP.addEventListener("over",this);
      this._pvAP.addEventListener("out",this);
      this._pvMP.addEventListener("over",this);
      this._pvMP.addEventListener("out",this);
      this._oData.Spells.addEventListener("modelChanged",this);
      this._oData.Inventory.addEventListener("modelChanged",this);
      this.api.datacenter.Player.addEventListener("huntMatchmakingStatusChanged",this);
      this._hHeart.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._hHeart.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this._hHeart.onRelease = function()
      {
         this._btnTemporis();
      };
      var banner = this;
      this._mcCircleXtraMaskBig.onRelease = function()
      {
         var _loc2_ = {};
         _loc2_.target = this;
         banner.click(_loc2_);
      };
   }
   function initData()
   {
      var _loc2_ = this.api.kernel.OptionsManager.getOption("BannerIllustrationMode");
      switch(_loc2_)
      {
         case "artwork":
            this._circleXtra.showCircleXtra("artwork",true,{bMask:true});
            break;
         case "clock":
            this._circleXtra.showCircleXtra("clock",true,{bMask:true});
            break;
         case "compass":
            this._circleXtra.showCircleXtra("compass",true,{bMask:true});
            break;
         case "helper":
            this._circleXtra.showCircleXtra("helper",true,{bMask:true});
            break;
         case "map":
            this._circleXtra.showCircleXtra("map",true,{bMask:true});
      }
      this.drawBar();
      this.lpMaxChanged({value:this._oData.LPmax});
      this.lpChanged({value:this._oData.LP});
      this._txtConsole.restrict = dofus.Constants.CHAT_ALLOWED_CHARACTERS;
      this.api.kernel.ChatManager.refresh();
      dofus.graphics.gapi.ui.banner.BannerGauge.setGaugeMode(this,this.api.kernel.OptionsManager.getOption("BannerGaugeMode"));
      this.updatePvPButtonState();
      this.updateButtonState(this._btnEvenementialServer,this.api.datacenter.ServerEvenemential.isActif);
      if(this.api.kernel.OptionsManager.getOption("MovableBar"))
      {
         this.displayMovableBar(this.api.kernel.OptionsManager.getOption("MovableBar") && (!this.api.kernel.OptionsManager.getOption("HideSpellBar") || this.api.datacenter.Game.isFight));
      }
      this.setChatPrefix("",false);
   }
   function setChatFocus()
   {
      if(this._bUseFlashChat)
      {
         Selection.setFocus(this._txtConsole);
      }
      else
      {
         this.api.electron.focusWidescreenPanelIfPossible();
      }
   }
   function isChatFocus()
   {
      return this._bUseFlashChat && eval(Selection.getFocus())._name == "_txtConsole";
   }
   function placeCursorAtTheEnd()
   {
      if(!this._bUseFlashChat)
      {
         return undefined;
      }
      Selection.setFocus(this._txtConsole);
      Selection.setSelection(this._txtConsole.text.length,dofus.Constants.MAX_MESSAGE_LENGTH + dofus.Constants.MAX_MESSAGE_LENGTH_MARGIN);
   }
   function setChatFocusWithLastKey()
   {
      if(!this._bChatAutoFocus)
      {
         return undefined;
      }
      if(Selection.getFocus() != undefined)
      {
         return undefined;
      }
      this.setChatFocus();
      this.placeCursorAtTheEnd();
   }
   function setChatPrefix(sPrefix, bFocusTxtCommand)
   {
      if(bFocusTxtCommand == undefined)
      {
         bFocusTxtCommand = true;
      }
      if(sPrefix == "")
      {
         sPrefix = "/s";
      }
      this._sChatPrefix = sPrefix;
      if(sPrefix != "/s")
      {
         this._btnHelp.label = sPrefix;
         this._btnHelp.icon = "";
      }
      else
      {
         this._btnHelp.label = "";
         this._btnHelp.icon = "UI_BannerChatCommandAll";
      }
      this.api.electron.retroChatSetPrefix(sPrefix);
      if(bFocusTxtCommand)
      {
         this.addToQueue({object:this,method:this.placeCursorAtTheEnd});
      }
   }
   function getChatCommand()
   {
      var _loc2_ = this._txtConsole.text;
      if(_loc2_.charAt(0) == "/")
      {
         return _loc2_;
      }
      if(this._sChatPrefix != "")
      {
         return this._sChatPrefix + " " + _loc2_;
      }
      return _loc2_;
   }
   function updateBannerButtons()
   {
      var _loc2_ = this._aBannerLayout;
      var _loc3_ = _loc2_.length;
      var _loc4_ = 476;
      var _loc5_ = 440;
      var _loc6_ = 29.25;
      var _loc7_ = 710;
      var _loc8_ = 404;
      var _loc9_ = 28;
      var _loc10_ = 0;
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      while(_loc11_ < _loc3_)
      {
         _loc12_ = _loc2_[_loc11_];
         _loc13_ = this[_loc12_];
         if(_loc13_ != undefined)
         {
            if(_loc11_ < dofus.graphics.gapi.ui.Banner.BUTTONS_IN_BANNER)
            {
               _loc13_._x = _loc4_ + _loc11_ * _loc6_;
               _loc13_._y = _loc5_;
               _loc13_._visible = true;
            }
            else
            {
               _loc13_._visible = this._bMoreButton;
               _loc13_._x = _loc7_;
               _loc13_._y = _loc8_ - _loc10_ * _loc9_;
               _loc10_ = _loc10_ + 1;
            }
         }
         _loc11_ = _loc11_ + 1;
      }
   }
   function initBannerLayout()
   {
      var _loc2_ = this.api.kernel.OptionsManager.getOption("BannerLayout");
      var _loc3_ = this.api.kernel.OptionsManager.getOption("BannerLayoutVersion");
      var _loc4_ = dofus.graphics.gapi.ui.Banner.BANNER_DEFAULT_LAYOUT.concat();
      if(_loc2_.length > 0)
      {
         if(_loc3_ != dofus.graphics.gapi.ui.Banner.BANNER_LAYOUT_VERSION)
         {
            this._aBannerLayout = this.addNewButtonToBannerLayout(_loc4_,_loc2_);
            this.api.kernel.OptionsManager.setOption("BannerLayoutVersion",dofus.graphics.gapi.ui.Banner.BANNER_LAYOUT_VERSION);
            this.saveBannerLayout();
         }
         else
         {
            this._aBannerLayout = _loc2_.concat();
         }
      }
      else
      {
         this._aBannerLayout = _loc4_.concat();
      }
      this.updateBannerButtons();
      this.lockBannerButtons(this.api.kernel.OptionsManager.getOption("BannerLayoutLocked"));
   }
   function swapBannerButton(btnToSwap, btnSwapped)
   {
      if(!btnToSwap || !btnSwapped)
      {
         return undefined;
      }
      if(btnToSwap == btnSwapped)
      {
         return undefined;
      }
      var _loc4_ = btnToSwap._name;
      var _loc5_ = btnSwapped._name;
      var _loc8_ = 0;
      var _loc9_;
      var _loc6_;
      var _loc7_;
      while(_loc8_ < this._aBannerLayout.length)
      {
         _loc9_ = this._aBannerLayout[_loc8_];
         if(_loc6_ == undefined && _loc9_ == _loc4_)
         {
            _loc6_ = _loc8_;
         }
         if(_loc7_ == undefined && _loc9_ == _loc5_)
         {
            _loc7_ = _loc8_;
         }
         _loc8_ = _loc8_ + 1;
      }
      if(_loc6_ == undefined || _loc7_ == undefined)
      {
         return undefined;
      }
      var _loc10_ = this._aBannerLayout[_loc6_];
      this._aBannerLayout[_loc6_] = this._aBannerLayout[_loc7_];
      this._aBannerLayout[_loc7_] = _loc10_;
      this.updateBannerButtons();
      this.saveBannerLayout();
   }
   function saveBannerLayout()
   {
      if(ank.utils.ExtendedArray.equals(dofus.graphics.gapi.ui.Banner.BANNER_DEFAULT_LAYOUT,this._aBannerLayout))
      {
         this.api.kernel.OptionsManager.resetBannerLayout();
         return undefined;
      }
      this.api.kernel.OptionsManager.setOption("BannerLayout",this._aBannerLayout);
   }
   function addNewButtonToBannerLayout(aNewButtons, aOldButtons)
   {
      var _loc4_ = [];
      var _loc5_ = {};
      var _loc6_ = {};
      var _loc7_ = 0;
      while(_loc7_ < aNewButtons.length)
      {
         _loc5_[aNewButtons[_loc7_]] = true;
         _loc7_ = _loc7_ + 1;
      }
      var _loc8_ = 0;
      var _loc9_;
      while(_loc8_ < aOldButtons.length)
      {
         _loc9_ = aOldButtons[_loc8_];
         if(_loc5_[_loc9_] && !_loc6_[_loc9_])
         {
            _loc4_.push(_loc9_);
            _loc6_[_loc9_] = true;
         }
         _loc8_ = _loc8_ + 1;
      }
      var _loc10_ = 0;
      var _loc11_;
      while(_loc10_ < aNewButtons.length)
      {
         _loc11_ = aNewButtons[_loc10_];
         if(!_loc6_[_loc11_])
         {
            _loc4_.push(_loc11_);
            _loc6_[_loc11_] = true;
         }
         _loc10_ = _loc10_ + 1;
      }
      return _loc4_;
   }
   function xpChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function energyChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function currentWeightChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function mountChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function currentJobChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function tempotonsChanged()
   {
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
   }
   function displayMovableBar(bShow)
   {
      if(bShow == undefined)
      {
         bShow = this._mcbMovableBar == undefined;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(bShow)
      {
         if(this._mcbMovableBar._name != undefined)
         {
            return undefined;
         }
         this._mcbMovableBar = dofus.graphics.gapi.ui.MovableContainerBar(this.api.ui.loadUIComponent("MovableContainerBar","MovableBar",[],{bAlwaysOnTop:true}));
         this._mcbMovableBar.addEventListener("drawBar",this);
         this._mcbMovableBar.addEventListener("drop",this);
         this._mcbMovableBar.addEventListener("dblClick",this);
         _loc3_ = {left:0,top:0,right:this.gapi.screenWidth,bottom:this.gapi.screenHeight};
         _loc4_ = this.api.kernel.OptionsManager.getOption("MovableBarSize");
         _loc5_ = this.api.kernel.OptionsManager.getOption("MovableBarCoord");
         _loc5_ = !_loc5_ ? {x:0,y:(this.gapi.screenHeight - this._mcbMovableBar._height) / 2} : _loc5_;
         this.addToQueue({object:this._mcbMovableBar,method:this._mcbMovableBar.setOptions,params:[16,20,_loc3_,_loc4_,_loc5_]});
      }
      else
      {
         this.api.ui.unloadUIComponent("MovableBar");
      }
   }
   function setMovableBarSize(nSize)
   {
      this._mcbMovableBar.size = nSize;
   }
   function chatInputHasText()
   {
      return this._txtConsole.text != undefined && this._txtConsole.text != "";
   }
   function hideMoreButtons()
   {
      this._bMoreButton = false;
      this.updateMoreButtonsWindow();
      this.addToQueue({object:this,method:this.updateBtnMoreIcon,params:["UI_BannerMoreIcon"]});
   }
   function showMoreButtons()
   {
      this._bMoreButton = true;
      this.updateMoreButtonsWindow();
      this.addToQueue({object:this,method:this.updateBtnMoreIcon,params:["UI_BannerLessIcon"]});
   }
   function updateBtnMoreIcon(sIcon)
   {
      this._btnMore.icon = sIcon;
   }
   function updateMoreButtonsWindow()
   {
      var _loc2_ = this._aBannerLayout;
      var _loc3_ = dofus.graphics.gapi.ui.Banner.BUTTONS_IN_BANNER;
      while(_loc3_ < _loc2_.length)
      {
         this[_loc2_[_loc3_]]._visible = this._bMoreButton;
         _loc3_ = _loc3_ + 1;
      }
      this._mcMoreButtonBg._visible = this._bMoreButton;
   }
   function lockBannerButtons(bLocked)
   {
      var _loc3_ = this._aBannerLayout;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         ank.gapi.controls.DraggableButton(this[_loc3_[_loc4_]]).dragAndDrop = !bLocked && !this.api.datacenter.Basics.inDemoMode;
         _loc4_ = _loc4_ + 1;
      }
   }
   function onKeys(sKey)
   {
      if(this._lastKeyIsShortcut)
      {
         this._lastKeyIsShortcut = false;
         return undefined;
      }
      this.setChatFocusWithLastKey();
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      switch(sShortcut)
      {
         case "CTRL_STATE_CHANGED_ON":
            if(this._bIsOnFocus && !(this.api.config.isLinux || this.api.config.isMac))
            {
               fscommand("trapallkeys","false");
            }
            break;
         case "CTRL_STATE_CHANGED_OFF":
            if(this._bIsOnFocus && !(this.api.config.isLinux || this.api.config.isMac))
            {
               fscommand("trapallkeys","true");
            }
            break;
         case "ESCAPE":
            if(this.isChatFocus())
            {
               org.flashdevelop.utils.FlashConnect.trace("ESCAPE ON BANNER","dofus.graphics.gapi.ui.Banner::onShortcut","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/ui/Banner.as",1035);
               Selection.setFocus(null);
               _loc3_ = false;
            }
            break;
         case "ACCEPT_CURRENT_DIALOG":
            if(this.isChatFocus())
            {
               if(this._txtConsole.text.length == 0)
               {
                  if(this.api.electron.isShowingWidescreenPanel)
                  {
                     _loc3_ = false;
                     this.api.electron.focusWidescreenPanelIfPossible();
                  }
                  break;
               }
               this.api.kernel.Console.process(this.getChatCommand(),this.api.datacenter.Basics.chatParams);
               this.api.datacenter.Basics.chatParams = {};
               if(this._txtConsole.text != undefined)
               {
                  this._txtConsole.text = "";
                  this.api.electron.retroChatSetPromptText("");
               }
               _loc3_ = false;
            }
            else if(this._bChatAutoFocus)
            {
               _loc4_ = dofus.graphics.gapi.ui.Debug(this.gapi.getUIComponent("Debug"));
               if(Selection.getFocus() != undefined && !(_loc4_ != undefined && (_loc4_.isFocused() && !_loc4_.commandInputHasText())))
               {
                  break;
               }
               _loc3_ = false;
               this.setChatFocus();
            }
            break;
         case "TEAM_MESSAGE":
            if(this.isChatFocus())
            {
               if(this._txtConsole.text.length != 0)
               {
                  _loc5_ = this.getChatCommand();
                  if(_loc5_.charAt(0) == "/")
                  {
                     _loc5_ = _loc5_.substr(_loc5_.indexOf(" ") + 1);
                  }
                  this.api.kernel.Console.process("/t " + _loc5_,this.api.datacenter.Basics.chatParams);
                  this.api.datacenter.Basics.chatParams = {};
                  if(this._txtConsole.text != undefined)
                  {
                     this._txtConsole.text = "";
                     this.api.electron.retroChatSetPromptText("");
                  }
                  _loc3_ = false;
               }
            }
            else if(Selection.getFocus() == undefined && this._bChatAutoFocus)
            {
               _loc3_ = false;
               this.setChatFocus();
            }
            break;
         case "GUILD_MESSAGE":
            if(this.isChatFocus())
            {
               if(this._txtConsole.text.length != 0)
               {
                  _loc6_ = this.getChatCommand();
                  if(_loc6_.charAt(0) == "/")
                  {
                     _loc6_ = _loc6_.substr(_loc6_.indexOf(" ") + 1);
                  }
                  this.api.kernel.Console.process("/g " + _loc6_,this.api.datacenter.Basics.chatParams);
                  this.api.datacenter.Basics.chatParams = {};
                  if(this._txtConsole.text != undefined)
                  {
                     this._txtConsole.text = "";
                     this.api.electron.retroChatSetPromptText("");
                  }
                  _loc3_ = false;
               }
            }
            else if(Selection.getFocus() == undefined && this._bChatAutoFocus)
            {
               _loc3_ = false;
               this.setChatFocus();
            }
            break;
         case "WHISPER_HISTORY_UP":
            if(this.isChatFocus())
            {
               this.doChatWhisperHistoryUp();
               _loc3_ = false;
            }
            break;
         case "WHISPER_HISTORY_DOWN":
            if(this.isChatFocus())
            {
               this.doChatWhisperHistoryDown();
               _loc3_ = false;
            }
            break;
         case "HISTORY_UP":
            if(this.isChatFocus())
            {
               this.doChatHistoryUp();
               _loc3_ = false;
            }
            break;
         case "HISTORY_DOWN":
            if(this.isChatFocus())
            {
               this.doChatHistoryDown();
               _loc3_ = false;
            }
            break;
         case "AUTOCOMPLETE":
            if(this.isChatFocus())
            {
               this.askShowAutoCompleteResult();
               _loc3_ = false;
            }
            break;
         case "NEXTTURN":
            if(!this.isChatFocus() && this.api.datacenter.Game.isFight)
            {
               if(!this.api.datacenter.Game.isRunning)
               {
                  _loc7_ = dofus.graphics.gapi.ui.ChallengeMenu(this.gapi.getUIComponent("ChallengeMenu"));
                  if(_loc7_ != undefined)
                  {
                     _loc7_.sendReadyState();
                  }
               }
               else
               {
                  this.api.network.Game.prepareTurnEnd();
               }
               _loc3_ = false;
            }
            break;
         case "MAXI":
            if(this._bUseFlashChat)
            {
               this._cChat.open(false);
               _loc3_ = false;
            }
            break;
         case "MINI":
            if(this._bUseFlashChat)
            {
               this._cChat.open(true);
               _loc3_ = false;
            }
            break;
         case "CHARAC":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.onStatsAskOpen();
               _loc3_ = false;
            }
            break;
         case "SPELLS":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.onSpellAskOpen();
               _loc3_ = false;
            }
            break;
         case "INVENTORY":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnInventory});
               _loc3_ = false;
            }
            break;
         case "QUESTS":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnQuests});
               _loc3_ = false;
            }
            break;
         case "MAP":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnMap});
               _loc3_ = false;
            }
            break;
         case "FRIENDS":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnFriends});
               _loc3_ = false;
            }
            break;
         case "GUILD":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.onGuildAskOpen();
               _loc3_ = false;
            }
            break;
         case "GUILD_TAX_COLLECTOR":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts") && this.api.datacenter.Player.guildInfos.isValid)
            {
               this.onGuildAskOpen("TaxCollectors");
               _loc3_ = false;
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_CHAT");
            }
            break;
         case "CONQUEST_AND_HUNT":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnPvP});
               _loc3_ = false;
            }
            break;
         case "MOUNT":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts") && !this.api.datacenter.Basics.aks_current_server.isTemporis())
            {
               this.click({target:this._btnMount});
               _loc3_ = false;
            }
            break;
         case "MOUNT_INVENTORY":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.api.network.Exchange.request(15);
               _loc3_ = false;
            }
            break;
         case "EVENEMENTIAL_SERVER":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts") && this.api.datacenter.ServerEvenemential.isActif)
            {
               this.click({target:this._btnEvenementialServer});
               _loc3_ = false;
            }
            break;
         case "ACHIEVEMENTS":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnAchievement});
               _loc3_ = false;
            }
            break;
         case "JOBS":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnJob});
               _loc3_ = false;
            }
            break;
         case "TITLES":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnTitle});
               _loc3_ = false;
            }
            break;
         case "ENCYCLOPEDIA":
            if(this.api.kernel.OptionsManager.getOption("BannerShortcuts"))
            {
               this.click({target:this._btnEncyclopedia});
               _loc3_ = false;
            }
      }
      this._lastKeyIsShortcut = _loc3_;
      return _loc3_;
   }
   function askShowAutoCompleteResult()
   {
      Selection.setFocus(null);
      if(this._nAutoCompleteTimeout != undefined)
      {
         _global.clearTimeout(this._nAutoCompleteTimeout);
      }
      var _loc2_ = _global.setTimeout(this,"doAutoComplete",100);
      this._nAutoCompleteTimeout = _loc2_;
   }
   function doChatWhisperHistoryUp()
   {
      this._txtConsole.text = this.api.kernel.Console.getWhisperHistoryUp();
      this.addToQueue({object:this,method:this.placeCursorAtTheEnd});
      this.api.electron.retroChatSetPromptText(this._txtConsole.text);
   }
   function doChatWhisperHistoryDown()
   {
      this._txtConsole.text = this.api.kernel.Console.getWhisperHistoryDown();
      this.addToQueue({object:this,method:this.placeCursorAtTheEnd});
      this.api.electron.retroChatSetPromptText(this._txtConsole.text);
   }
   function doChatHistoryUp()
   {
      var _loc2_ = this.api.kernel.Console.getHistoryUp();
      if(_loc2_ != undefined)
      {
         this.api.datacenter.Basics.chatParams = _loc2_.params;
         this._txtConsole.text = _loc2_.value;
      }
      this.addToQueue({object:this,method:this.placeCursorAtTheEnd});
      this.api.electron.retroChatSetPromptText(this._txtConsole.text);
   }
   function doChatHistoryDown()
   {
      var _loc2_ = this.api.kernel.Console.getHistoryDown();
      if(_loc2_ != undefined)
      {
         this.api.datacenter.Basics.chatParams = _loc2_.params;
         this._txtConsole.text = _loc2_.value;
      }
      else
      {
         this._txtConsole.text = "";
      }
      this.addToQueue({object:this,method:this.placeCursorAtTheEnd});
      this.api.electron.retroChatSetPromptText(this._txtConsole.text);
   }
   function doAutoComplete()
   {
      var _loc2_ = [];
      var _loc3_ = this.api.datacenter.Sprites.getItems();
      for(var k in _loc3_)
      {
         if(_loc3_[k] instanceof dofus.datacenter.Character)
         {
            _loc2_.push(_loc3_[k].name);
         }
      }
      var _loc4_ = this.api.kernel.Console.autoCompletion(_loc2_,this._txtConsole.text);
      if(!_loc4_.isFull)
      {
         if(_loc4_.list == undefined || _loc4_.list.length == 0)
         {
            this.api.sounds.events.onError();
         }
         else
         {
            this.api.ui.showTooltip(_loc4_.list.sort().join(", "));
         }
      }
      this._txtConsole.text = _loc4_.result + (!_loc4_.isFull ? "" : " ");
      this.api.electron.retroChatSetPromptText(this._txtConsole.text);
      this.placeCursorAtTheEnd();
   }
   function click(oEvent)
   {
      this.api.kernel.GameManager.signalFightActivity();
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnPvP:
            this.api.sounds.events.onBannerRoundButtonClick();
            if(this.api.datacenter.Player.alignment.index == 0)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NEED_ALIGNMENT"),"ERROR_CHAT");
            }
            else
            {
               this.showSmileysEmotesPanel(false);
               this.hideMoreButtons();
               this.gapi.loadUIAutoHideComponent("Conquest","Conquest",{currentTab:(!Key.isDown(Key.SHIFT) ? "Stats" : "Zones")});
            }
            break;
         case this._btnMount:
            this.api.sounds.events.onBannerRoundButtonClick();
            if(this._bIsMutant)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_U_ARE_MUTANT"),"ERROR_CHAT");
               return undefined;
            }
            if(this._oData.mount != undefined)
            {
               this.showSmileysEmotesPanel(false);
               this.hideMoreButtons();
               if(Key.isDown(Key.SHIFT))
               {
                  this.api.network.Exchange.request(15);
               }
               else if(this.gapi.getUIComponent("MountAncestorsViewer") != undefined)
               {
                  this.gapi.unloadUIComponent("MountAncestorsViewer");
                  this.gapi.unloadUIComponent("Mount");
               }
               else
               {
                  this.gapi.loadUIAutoHideComponent("Mount","Mount");
               }
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("UI_ONLY_FOR_MOUNT"),"ERROR_CHAT");
            }
            break;
         case this._btnGuild:
            this.onGuildAskOpen();
            break;
         case this._btnStatsJob:
            this.onStatsAskOpen();
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["stats_click"]);
            }
            break;
         case this._btnSpells:
            this.onSpellAskOpen();
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["spell_click"]);
            }
            break;
         case this._btnEvenementialServer:
            this.api.sounds.events.onBannerRoundButtonClick();
            if(!this.api.datacenter.ServerEvenemential.isActif)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_226"),"ERROR_CHAT");
               return undefined;
            }
            this.showSmileysEmotesPanel(false);
            this.hideMoreButtons();
            this.gapi.loadUIAutoHideComponent("ServerEvenemential","ServerEvenemential");
            break;
         case this._btnInventory:
            this.onAskOpen("Inventory");
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["inventory_click"]);
            }
            break;
         case this._btnQuests:
            this.onAskOpen("Quests");
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["quest_click"]);
            }
            break;
         case this._btnMap:
            this.onAskOpen("MapExplorer",undefined,{nHideSprites:1});
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["map_click"]);
            }
            break;
         case this._btnFriends:
            this.onAskOpen("Friends");
            if(this.api.electron.enabled)
            {
               this.api.electron.eventClient("eventUIOpened",["friend_click"]);
            }
            break;
         case this._btnAchievement:
            _loc3_ = this.api.lang.getDungeonTextFromSubarea(this.api.datacenter.Map.subarea);
            if(_loc3_ != undefined && (_loc3_.a != undefined && _loc3_.a.length > 0))
            {
               this.onAskOpen("Achievements",{displayAchievementWithoutToggle:_loc3_.a[0]});
            }
            else
            {
               this.onAskOpen("Achievements",{selectedCategory:dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY});
            }
            break;
         case this._btnJob:
            this.onAskOpen("JobViewer");
            break;
         case this._btnTitle:
            this.onAskOpen("TitleAndOrnament");
            break;
         case this._btnEncyclopedia:
            if(Key.isDown(Key.SHIFT))
            {
               this.onAskOpen("Encyclopedia",{_sCurrentTab:"Equipments"});
            }
            else
            {
               this.onAskOpen("Encyclopedia");
            }
            break;
         case this._btnMore:
            this.onMoreAskOpen();
            break;
         case this._btnFights:
            if(!this.api.datacenter.Game.isFight)
            {
               this.gapi.loadUIComponent("FightsInfos","FightsInfos",null,{bAlwaysOnTop:true});
            }
            break;
         case this._btnHelp:
         case this._btnHelpForPanel:
            this.openChatPrefixMenu();
            break;
         case this._btnNextTurn:
            if(this.api.datacenter.Game.isFight)
            {
               this.api.network.Game.prepareTurnEnd();
            }
            break;
         case this._btnGiveUp:
            if(this.api.datacenter.Game.isFight)
            {
               if(this.api.datacenter.Game.isSpectator)
               {
                  this.api.network.Game.leave();
               }
               else
               {
                  this.api.kernel.GameManager.giveUpGame();
               }
            }
            break;
         case this._mcXtra:
         case this._mcCircleXtraMaskBig:
            if(!this.api.datacenter.Player.isAuthorized || this.api.datacenter.Player.isAuthorized && Key.isDown(Key.SHIFT))
            {
               if(this._sCurrentCircleXtra == "helper" && dofus.managers.TipsManager.getInstance().hasNewTips())
               {
                  dofus.managers.TipsManager.getInstance().displayNextTips();
                  return;
               }
               _loc4_ = this.api.ui.createPopupMenu();
               _loc4_.addItem(this.api.lang.getText("SHOW") + " >>",dofus.graphics.gapi.ui.banner.BannerGauge,dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeModeSelectMenu,[this]);
               if(this._sCurrentCircleXtra == "helper")
               {
                  _loc4_.addStaticItem(this.api.lang.getText("HELP_ME"));
                  _loc4_.addItem(this.api.lang.getText("KB_TITLE"),this.api.ui,this.api.ui.loadUIComponent,["KnownledgeBase","KnownledgeBase"],true);
                  _loc4_.addStaticItem(this.api.lang.getText("OTHER_DISPLAY_OPTIONS"));
               }
               _loc4_.addItem(this.api.lang.getText("BANNER_ARTWORK"),this._circleXtra,this._circleXtra.showCircleXtra,["artwork",true,{bMask:true,bUpdateGauge:true}],this._sCurrentCircleXtra != "artwork");
               _loc4_.addItem(this.api.lang.getText("BANNER_CLOCK"),this._circleXtra,this._circleXtra.showCircleXtra,["clock",true,{bMask:true,bUpdateGauge:true}],this._sCurrentCircleXtra != "clock");
               _loc4_.addItem(this.api.lang.getText("BANNER_COMPASS"),this._circleXtra,this._circleXtra.showCircleXtra,["compass",true,{bUpdateGauge:true}],this._sCurrentCircleXtra != "compass");
               _loc4_.addItem(this.api.lang.getText("BANNER_HELPER"),this._circleXtra,this._circleXtra.showCircleXtra,["helper",true,{bUpdateGauge:true}],this._sCurrentCircleXtra != "helper");
               _loc4_.addItem(this.api.lang.getText("BANNER_MAP"),this._circleXtra,this._circleXtra.showCircleXtra,["map",true,{bMask:true,bUpdateGauge:true}],this._sCurrentCircleXtra != "map");
               _loc4_.show(_root._xmouse,_root._ymouse,true);
            }
            else
            {
               this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:this.api.datacenter.Player.Name,sPlayerID:this.api.datacenter.Player.ID});
            }
         default:
            return;
      }
   }
   function openChatPrefixMenu(oCustomPopupPosition)
   {
      var _loc3_ = this.api.lang.getConfigText("CHAT_FILTERS");
      var _loc4_ = this.api.ui.createPopupMenu();
      _loc4_.addStaticItem(this.api.lang.getText("CHAT_PREFIX"));
      _loc4_.addItem(this.api.lang.getText("DEFAUT") + " (/s)",this,this.setChatPrefix,["/s"]);
      _loc4_.addItem(this.api.lang.getText("TEAM") + " (/t)",this,this.setChatPrefix,["/t"],this.api.datacenter.Game.isFight);
      _loc4_.addItem(this.api.lang.getText("PARTY") + " (/p)",this,this.setChatPrefix,["/p"],this.api.ui.getUIComponent("Party") != undefined);
      _loc4_.addItem(this.api.lang.getText("GUILD") + " (/g)",this,this.setChatPrefix,["/g"],this.api.datacenter.Player.guildInfos != undefined);
      if(_loc3_[4])
      {
         _loc4_.addItem(this.api.lang.getText("ALIGNMENT") + " (/a)",this,this.setChatPrefix,["/a"],this.api.datacenter.Player.alignment.index != 0);
      }
      if(_loc3_[5])
      {
         _loc4_.addItem(this.api.lang.getText("RECRUITMENT") + " (/r)",this,this.setChatPrefix,["/r"]);
      }
      if(_loc3_[6])
      {
         _loc4_.addItem(this.api.lang.getText("TRADE") + " (/b)",this,this.setChatPrefix,["/b"]);
      }
      if(_loc3_[7])
      {
         _loc4_.addItem(this.api.lang.getText("MEETIC") + " (/i)",this,this.setChatPrefix,["/i"]);
      }
      if(this.api.datacenter.Player.isAuthorized)
      {
         _loc4_.addItem(this.api.lang.getText("PRIVATE_CHANNEL") + " (/q)",this,this.setChatPrefix,["/q"]);
      }
      _loc4_.addItem(this.api.lang.getText("HELP"),this._cChat,this._cChat.displayChatHelp,[]);
      if(this.api.electron.enabled)
      {
         _loc4_.addItem(this.api.lang.getText("OPEN_EXTERNAL_CHAT"),dofus.Electron,dofus.Electron.retroChatOpen,[]);
      }
      if(oCustomPopupPosition != undefined)
      {
         _loc4_.show(oCustomPopupPosition.x,oCustomPopupPosition.y,true);
      }
      else
      {
         _loc4_.show(this._btnHelp._x,this._btnHelp._y,true);
      }
   }
   function dblClick(oEvent)
   {
      if(oEvent.target == this._mcbMovableBar)
      {
         this._mcbMovableBar.size = this._mcbMovableBar.size != 0 ? 0 : this.api.kernel.OptionsManager.getOption("MovableBarSize");
         return undefined;
      }
   }
   function createSpellActionPopupMenu(oSpell)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addItem(this.api.lang.getText("REMOVE_SHORTCUT"),this.api.network.Spells,this.api.network.Spells.spellRemove,[oSpell.position],!oSpell.isUndeletable);
      _loc3_.show(_root._xmouse,_root._ymouse,true);
   }
   function createInventoryShortcutItemActionPopupMenu(oInventoryShortcut)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addItem(this.api.lang.getText("REMOVE_SHORTCUT"),this.api.network.InventoryShortcuts,this.api.network.InventoryShortcuts.sendInventoryShortcutRemove,[oInventoryShortcut.position]);
      _loc3_.show(_root._xmouse,_root._ymouse,true);
   }
   function beforeFinalCountDown(oEvent)
   {
      this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_FINAL_COUNTDOWN);
   }
   function finalCountDown(oEvent)
   {
      this._mcXtra._visible = false;
      this._lblFinalCountDown.text = oEvent.value;
   }
   function tictac(oEvent)
   {
      this.api.sounds.events.onBannerTimer();
   }
   function finish(oEvent)
   {
      this._mcXtra._visible = true;
      if(this._lblFinalCountDown.text != undefined)
      {
         this._lblFinalCountDown.text = "";
      }
   }
   function complete(oEvent)
   {
      var _loc3_ = this.api.kernel.OptionsManager.getOption("BannerIllustrationMode");
      if(oEvent.target.contentPath.indexOf("artworks") != -1 && _loc3_ == "helper")
      {
         this._circleXtra.showCircleXtra("helper",true,{bMask:true});
      }
      else
      {
         this.api.colors.addSprite(this._mcXtra.content,this._oData);
      }
   }
   function over(oEvent)
   {
      if(!this.gapi.isCursorHidden())
      {
         return undefined;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(oEvent.target._name)
      {
         case "_btnHelp":
         case "_btnHelpForPanel":
            this.gapi.showTooltip(this.api.lang.getText("CHAT_MENU"));
            break;
         case "_btnGiveUp":
            if(this.api.datacenter.Game.isSpectator)
            {
               _loc3_ = this.api.lang.getText("GIVE_UP_SPECTATOR");
            }
            else if(this.api.datacenter.Game.fightType == dofus.managers.GameManager.FIGHT_TYPE_CHALLENGE || !this.api.datacenter.Basics.aks_current_server.isHardcore())
            {
               _loc3_ = this.api.lang.getText("GIVE_UP");
            }
            else
            {
               _loc3_ = this.api.lang.getText("SUICIDE");
            }
            this.gapi.showTooltip(_loc3_);
            break;
         case "_btnPvP":
            _loc4_ = this.api.lang.getText("CONQUEST_WORD") + " " + this.api.lang.getText("AND") + " " + this.api.lang.getText("HUNT");
            _loc5_ = this.api.datacenter.Player.huntMatchmakingStatus;
            if(_loc5_ != undefined && _loc5_.currentStatus == "WAITING_FOR_START_CONFIRMATION")
            {
               _loc4_ += "\n\n" + this.api.lang.getText("HUNT_LOOKING_FOR_TARGET_HURRY_UP_ALIGN_" + this.api.datacenter.Player.alignment.index);
            }
            this.gapi.showTooltip(_loc4_);
            break;
         case "_btnMount":
            this.gapi.showTooltip(this.api.lang.getText("MY_MOUNT"));
            break;
         case "_btnEvenementialServer":
            if(this.api.datacenter.ServerEvenemential.isActif)
            {
               this.gapi.showTooltip(this.api.lang.getText("EVENEMENTIAL_SERVER"));
            }
            break;
         case "_btnGuild":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_GUILD"));
            break;
         case "_btnStatsJob":
            this.api.datacenter.Player.Level != 200 ? this.gapi.showTooltip(this.api.lang.getText("YOUR_STATS_JOB") + "\n\n" + this.api.lang.getText("NEXT_LEVEL") + " " + this.api.kernel.Console.getcurrentXPPercentText() + "\n" + this.api.lang.getText("REQUIRED") + " " + new ank.utils.ExtendedString(this.api.datacenter.Player.XPhigh - this.api.datacenter.Player.XP).addMiddleChar(" ",3) + " " + this.api.lang.getText("WORD_XP")) : this.gapi.showTooltip(this.api.lang.getText("YOUR_STATS_JOB"));
            break;
         case "_btnSpells":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_SPELLS"));
            break;
         case "_btnQuests":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_QUESTS"));
            break;
         case "_btnInventory":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_INVENTORY") + "\n\n" + this.api.datacenter.Player.getWeightText());
            break;
         case "_btnMap":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_BOOK"));
            break;
         case "_btnFriends":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_FRIENDS"));
            break;
         case "_btnFights":
            if(this._nFightsCount != 0)
            {
               this.gapi.showTooltip(ank.utils.PatternDecoder.combine(this.api.lang.getText("FIGHTS_ON_MAP",[this._nFightsCount]),"m",this._nFightsCount < 2));
            }
            break;
         case "_btnNextTurn":
            this.gapi.showTooltip(this.api.lang.getText("NEXT_TURN"));
            break;
         case "_pvAP":
            this.gapi.showTooltip(this.api.lang.getText("ACTIONPOINTS"));
            break;
         case "_pvMP":
            this.gapi.showTooltip(this.api.lang.getText("MOVEPOINTS"));
            break;
         case "_mcXtra":
            switch(this._sCurrentCircleXtra)
            {
               case "compass":
                  _loc6_ = oEvent.target.targetCoords;
                  if(_loc6_ == undefined)
                  {
                     this.gapi.showTooltip(this.api.lang.getText("BANNER_SET_FLAG"));
                  }
                  else
                  {
                     this.gapi.showTooltip(_loc6_[0] + ", " + _loc6_[1]);
                  }
                  break;
               case "clock":
                  this.gapi.showTooltip(this.api.kernel.NightManager.time + "\n" + this.api.kernel.NightManager.getCurrentDateString());
            }
            if(!this.api.datacenter.Game.isFight && !this.api.kernel.TutorialManager.isTutorialModeInFight)
            {
               this._circleXtra.setXtraMask(this._mcCircleXtraMaskBig);
               this.moveHeart(true);
               dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
            }
            break;
         case "_hHeart":
            this.gapi.showTooltip(this.api.lang.getText("HELP_LIFE"));
            break;
         case "_btnAchievement":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_ACHIEVEMENTS"));
            break;
         case "_btnJob":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_JOBS"));
            break;
         case "_btnTitle":
            this.gapi.showTooltip(this.api.lang.getText("YOUR_TITLES"));
            break;
         case "_btnEncyclopedia":
            this.gapi.showTooltip(this.api.lang.getText("ENCYCLOPEDIA"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_mcXtra")
      {
         if(this.api.kernel.TutorialManager.isTutorialModeInFight)
         {
            return undefined;
         }
         this.moveHeart(false);
         if(!this.api.datacenter.Game.isFight && this.api.kernel.OptionsManager.getOption("BannerGaugeMode") == "none")
         {
            this._circleXtra.setXtraMask(this._mcCircleXtraMaskBig);
         }
         else
         {
            this._circleXtra.setXtraMask(this._mcCircleXtraMask);
         }
         dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(this);
      }
      this.gapi.hideTooltip();
   }
   function drag(oEvent_)
   {
      if(oEvent_.target == undefined)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      this.gapi.setCursor(oEvent_.data,{width:32,height:32},false);
   }
   function drop(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      if((_loc0_ = oEvent.target) !== this._mcbMovableBar)
      {
         _loc3_ = oEvent.data.source;
         _loc4_ = oEvent.target;
         this.swapBannerButton(_loc3_,_loc4_);
      }
      else
      {
         this.api.kernel.OptionsManager.setOption("MovableBarCoord",{x:this._mcbMovableBar._x,y:this._mcbMovableBar._y,v:this._mcbMovableBar._bVertical});
      }
   }
   function filterChanged(oEvent)
   {
      this.api.network.Chat.subscribeChannels(oEvent.filter,oEvent.selected);
   }
   function lpChanged(oEvent)
   {
      this._hHeart.value = oEvent.value;
   }
   function lpMaxChanged(oEvent)
   {
      this._hHeart.max = oEvent.value;
   }
   function apChanged(oEvent)
   {
      this._pvAP.value = oEvent.value;
      if(!this.api.datacenter.Game.isFight)
      {
      }
      this._msShortcuts.setSpellStateOnAllContainers();
   }
   function mpChanged(oEvent)
   {
      this._pvMP.value = Math.max(0,oEvent.value);
   }
   function selectSmiley(oEvent)
   {
      this.api.network.Chat.useSmiley(oEvent.index);
   }
   function selectEmote(oEvent)
   {
      this.api.network.Emotes.useEmote(oEvent.index);
   }
   function updatePvPButtonState()
   {
      var _loc2_ = this.api.datacenter.Player.huntMatchmakingStatus;
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc3_ = _loc2_.currentStatus;
      switch(_loc3_)
      {
         case "PLAYER_LEFT_MATCHMAKING":
         case "HUNT_STARTED":
         case "WAITING_FOR_START_CONFIRMATION_TIMEOUT":
            this._btnPvP.backgroundDown = "ButtonBannerRoundDown";
            this._btnPvP.backgroundUp = "ButtonBannerRoundUp";
            break;
         case "WAITING_FOR_TARGET":
            this._btnPvP.backgroundDown = "ButtonBannerRoundInSearchDown";
            this._btnPvP.backgroundUp = "ButtonBannerRoundInSearchUp";
            break;
         case "WAITING_FOR_START_CONFIRMATION":
            this._btnPvP.backgroundDown = "ButtonBannerRoundWaitResponseDown";
            this._btnPvP.backgroundUp = !dofus.Constants.TRIPLEFRAMERATE ? "ButtonBannerRoundWaitResponseUp" : "ButtonBannerRoundWaitResponseUp_TripleFramerate";
         default:
            return;
      }
   }
   function updateButtonState(btn, bEnabled_)
   {
      btn.enabled = bEnabled_;
      this.setMovieClipTransform(btn,!bEnabled_ ? {ra:70,rb:0,ga:70,gb:0,ba:70,bb:0} : {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0});
   }
   function huntMatchmakingStatusChanged(oEvent)
   {
      this.updatePvPButtonState();
   }
   function configureUseFlashChat(bUse)
   {
      this._bUseFlashChat = bUse;
      this._cChat.useReplacementPanel(bUse ? dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.NO_REPLACEMENT_PANEL : this.api.kernel.OptionsManager.getOption("chatReplacementPanel"));
      this._txtConsole._visible = bUse;
      this._mcBgTxtConsole._visible = bUse;
      this._cChat._btnOpenClose._visible = bUse;
      this._cChat._btnHelpForPanel._visible = !bUse;
      this._btnHelp._visible = bUse;
      if(!bUse)
      {
         this._cChat.open(true);
      }
   }
   function drawBar(oEvent)
   {
      this.linkMovableContainer();
      this._msShortcuts.updateCurrentTabInformations();
      this.updateEye();
   }
   function onSetFocus()
   {
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      if(this.api.config.isLinux || this.api.config.isMac)
      {
         fscommand("trapallkeys","false");
      }
      else
      {
         this._bIsOnFocus = true;
      }
   }
   function onKillFocus()
   {
      if(this.api.config.isLinux || this.api.config.isMac)
      {
         fscommand("trapallkeys","true");
      }
      else
      {
         this._bIsOnFocus = false;
      }
   }
   function statesChanged()
   {
      org.flashdevelop.utils.FlashConnect.trace("[Banner] (statesChanged)","dofus.graphics.gapi.ui.Banner::statesChanged","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/ui/Banner.as",2102);
      this._msShortcuts.setSpellStateOnAllContainers();
   }
   function onAskOpen(sComponentName, oComponentParams, oUIParams)
   {
      this.api.sounds.events.onBannerRoundButtonClick();
      this.showSmileysEmotesPanel(false);
      this.hideMoreButtons();
      this.gapi.loadUIAutoHideComponent(sComponentName,sComponentName,oComponentParams,oUIParams);
   }
   function onStatsAskOpen()
   {
      this.api.sounds.events.onBannerRoundButtonClick();
      if(this._bIsMutant)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_U_ARE_MUTANT"),"ERROR_CHAT");
         return undefined;
      }
      this.showSmileysEmotesPanel(false);
      this.hideMoreButtons();
      this.gapi.loadUIAutoHideComponent("StatsJob","StatsJob");
   }
   function onSpellAskOpen()
   {
      this.api.sounds.events.onBannerRoundButtonClick();
      if(this._bIsMutant)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_U_ARE_MUTANT"),"ERROR_CHAT");
         return undefined;
      }
      this.showSmileysEmotesPanel(false);
      this.hideMoreButtons();
      this.gapi.loadUIAutoHideComponent("Spells","Spells");
   }
   function onGuildAskOpen(sCurrentTab)
   {
      this.api.sounds.events.onBannerRoundButtonClick();
      if(this._bIsMutant)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_U_ARE_MUTANT"),"ERROR_CHAT");
         return undefined;
      }
      var _loc3_;
      if(this._oData.guildInfos != undefined)
      {
         _loc3_ = sCurrentTab == undefined ? "Members" : sCurrentTab;
         if(Key.isDown(Key.SHIFT))
         {
            if(!this.api.datacenter.Player.guildInfos.isValid)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_CHAT");
               return undefined;
            }
            _loc3_ = "TaxCollectors";
         }
         this.showSmileysEmotesPanel(false);
         this.hideMoreButtons();
         this.gapi.loadUIAutoHideComponent("Guild","Guild",{currentTab:_loc3_});
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("UI_ONLY_FOR_GUILD"),"ERROR_CHAT");
      }
   }
   function onMoreAskOpen()
   {
      this.api.sounds.events.onBannerRoundButtonClick();
      if(this._bMoreButton)
      {
         this.hideMoreButtons();
      }
      else
      {
         this.showMoreButtons();
      }
   }
}
