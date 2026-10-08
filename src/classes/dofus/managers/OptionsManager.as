class dofus.managers.OptionsManager extends dofus.utils.ApiElement
{
   var _so;
   var api;
   var dispatchEvent;
   static var DISPLAY_STYLE_WIDESCREEN_PANELS = "widescreenpanels";
   static var DEFAULT_VALUES = {loaded:true,Grid:false,Transparency:false,SpriteInfos:true,SpriteMove:true,MapInfos:true,AutoHideSmileys:false,StringCourse:true,ColorfulTactic:true,PointsOverHead:true,ChatEffects:true,CreaturesMode:50,Buff:true,GuildMessageSound:false,BannerShortcuts:true,StartTurnSound:true,TipsOnStart:true,DisplayStyle:"normal",DebugSizeIndex:0,ServerPortIndex:0,MovableBar:false,ViewAllMonsterInGroup:true,MovableBarSize:5,ShortcutSet:1,ShortcutSetDefault:1,CharacterPreview:true,MapFilters:[0,1,1,1,1,1,1],Aura:true,AudioMusicVol:60,AudioEffectVol:100,AudioEnvVol:60,AudioMusicMute:false,AudioEffectMute:false,AudioEnvMute:false,FloatingTipsCoord:new com.ankamagames.types.Point(415,30),DisplayingFreshTips:true,CensorshipFilter:true,BigStoreSellFilter:false,RememberAccountName:false,LastAccountNameUsed:"",DefaultQuality:"high",ConquestFilter:-2,FightGroupAutoLock:false,BannerIllustrationMode:"artwork",BannerGaugeMode:"xp",AskForWrongCraft:true,AdvancedLineOfSight:true,RemindTurnTime:true,HideSpellBar:false,SeeAllSpell:true,UseSpeakingItems:true,ConfirmDropItem:true,TimestampInChat:true,ViewDicesDammages:false,AnonymousGameEvents:false,NightMode:true,SeeDamagesColor:true,RemasteredSpellIconsPack:1,EnableWidescreenPanels:true,chatReplacementPanel:dofus
   .graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP,UseLightEndFightUI:false,RegroupDamage:true,StylePoint:1,ViewHPAsBar:true,AnimateHPBar:true,RightClickToCast:true,DisplayBigStoreAsGrid:false,HideSpritesUIFullscreen:true,GlowOnCurrentPlayer:true,HideOptionalItem:false,EnableAntiLag:true,AntiLagHideSpellAnimation:true,AntiLagHideHit:true,AntiLagHideCriticalHit:true,AntiLagHideDie:false,AntiLagHideStringCourse:true,AntiLagHidePoints:true,AntiLagHideTimeline:false,AntiLagHideSpritesFight:false,AntiLagHideEmotes:true,AntiLagOptimizeMovement:true,AntiLagHideSpritesExceptPartyMembers:false,AntiLagHideChildMonsters:false,AntiLagHideMerchants:false,Language:"fr",AchievementSound:true,DisplayAchievementButton:true,BannerLayout:[],BannerLayoutLocked:false,BannerLayoutVersion:0,HideInventoryItemsCornerIcon:false,ElectronBackgroundNotifications:true,ElectronDiscordRichPresence:true,ElectronEnableForceGPURendering:true,ElectronEnableHighRes:true,ElectronEnableChatDarkMode:false,ElectronEnableLimitWidescreenPanelWidth:true};
   static var OPTION_SPELL_PACK_REMASTERED = 1;
   static var OPTION_SPELL_PACK_CONTRAST = 2;
   static var OPTION_SPELL_PACK_CLASSIC = 3;
   static var _sSelf = null;
   function OptionsManager(oAPI)
   {
      super();
      dofus.managers.OptionsManager._sSelf = this;
      this.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.OptionsManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      mx.events.EventDispatcher.initialize(this);
      this._so = _global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME];
      if(this._so.data.loaded == undefined)
      {
         this._so.clear();
      }
      for(var k in dofus.managers.OptionsManager.DEFAULT_VALUES)
      {
         if(this._so.data[k] == undefined)
         {
            this._so.data[k] = dofus.managers.OptionsManager.DEFAULT_VALUES[k];
         }
      }
      this._so.flush();
   }
   function loadDefault()
   {
      var _loc2_ = this._so.data.language;
      this._so.clear();
      for(var k in dofus.managers.OptionsManager.DEFAULT_VALUES)
      {
         if(k == "ShortcutSetDefault")
         {
            this.setOption(k,this.api.kernel.KeyManager.getCurrentDefaultSet());
         }
         else
         {
            this.setOption(k,dofus.managers.OptionsManager.DEFAULT_VALUES[k]);
         }
      }
      this._so.data.language = _loc2_;
      this._so.flush();
   }
   function setOption(sKey, mValue)
   {
      var _loc4_ = this.saveValue(sKey,mValue);
      if(this.applyOption(sKey,_loc4_))
      {
         this.dispatchEvent({type:"optionChanged",key:sKey,value:_loc4_});
      }
   }
   function getOption(sKey)
   {
      return this.loadValue(sKey);
   }
   function applyAllOptions()
   {
      var _loc2_ = this._so.data;
      var _loc3_;
      for(var k in _loc2_)
      {
         _loc3_ = false;
         switch(k)
         {
            case "ShortcutSet":
            case "Language":
            case "ElectronEnableChatDarkMode":
            case "BannerLayoutLocked":
               _loc3_ = true;
         }
         if(!_loc3_)
         {
            this.applyOption(k,_loc2_[k]);
         }
      }
   }
   function get isMapConquestFilterEnabled()
   {
      return !!this.getOption("MapFilters")[dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID];
   }
   function saveValue(sKey, mValue)
   {
      var _loc4_ = this._so.data;
      if(mValue == undefined)
      {
         if(typeof _loc4_[sKey] == "boolean")
         {
            _loc4_[sKey] = !_loc4_[sKey];
         }
         else
         {
            _loc4_[sKey] = true;
         }
      }
      else
      {
         _loc4_[sKey] = mValue;
      }
      this._so.flush();
      return _loc4_[sKey];
   }
   function loadValue(sKey)
   {
      return this._so.data[sKey];
   }
   function applyOption(sKey, mValue)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(sKey)
      {
         case "Grid":
            if(mValue == true)
            {
               this.api.gfx.drawGrid();
            }
            else
            {
               this.api.gfx.removeGrid();
            }
            break;
         case "NightMode":
            if(this.api.ui.getUIComponent("Banner") == undefined)
            {
               break;
            }
            _loc4_ = this.api.datacenter.Map;
            if(mValue && (_loc4_ && _loc4_.bOutdoor))
            {
               this.api.kernel.NightManager.clear();
               this.api.kernel.NightManager.setState();
            }
            else
            {
               this.api.kernel.NightManager.noEffects();
            }
            break;
         case "Transparency":
            this.api.gfx.setSpriteGhostView(mValue);
            break;
         case "SpriteInfos":
            if(mValue == false)
            {
               this.api.ui.unloadUIComponent("SpriteInfos");
               this.setOption("SpriteMove",false);
               this.setOption("ShowFixRes",false);
            }
            break;
         case "SpriteMove":
            if(mValue == false)
            {
               this.api.gfx.clearZoneLayer("move");
            }
            else if(this.loadValue("SpriteInfos") == false)
            {
               this.setOption("SpriteInfos",true);
            }
            break;
         case "MapInfos":
            if(mValue == true)
            {
               this.api.ui.loadUIComponent("MapInfos","MapInfos",undefined,{bForceLoad:true});
            }
            else
            {
               this.api.ui.unloadUIComponent("MapInfos");
            }
            break;
         case "StringCourse":
            if(mValue == false)
            {
               this.api.ui.unloadUIComponent("StringCourse");
            }
            break;
         case "ColorfulTactic":
            if(this.api.datacenter.Game.isFight)
            {
               this.api.ui.getUIComponent("FightOptionButtons").refreshTacticButton();
               if(this.api.datacenter.Game.isTacticMode)
               {
                  this.api.gfx.activateTacticMode(this.api,false);
                  this.api.gfx.activateTacticMode(this.api,true);
               }
            }
            break;
         case "CreaturesMode":
            this.api.kernel.GameManager.applyCreatureMode();
            break;
         case "Buff":
            if(mValue)
            {
               this.api.ui.loadUIComponent("Buff","Buff");
            }
            else
            {
               this.api.ui.unloadUIComponent("Buff");
            }
            break;
         case "DisplayStyle":
            this.api.kernel.setDisplayStyle(mValue);
            break;
         case "DefaultQuality":
            this.api.kernel.setQuality(mValue);
            break;
         case "MovableBar":
            this.api.ui.getUIComponent("Banner").displayMovableBar(mValue && (this.api.datacenter.Game.isFight || !this.getOption("HideSpellBar")));
            break;
         case "HideSpellBar":
            this.api.ui.getUIComponent("Banner").displayMovableBar(this.getOption("MovableBar") && (this.api.datacenter.Game.isFight || !mValue));
            break;
         case "MovableBarSize":
            this.api.ui.getUIComponent("Banner").setMovableBarSize(mValue);
            break;
         case "ShortcutSet":
            this.api.kernel.KeyManager.onSetChange(mValue);
            break;
         case "CharacterPreview":
            this.api.ui.getUIComponent("Inventory").showCharacterPreview(mValue);
            break;
         case "AudioMusicVol":
            this.api.kernel.AudioManager.musicVolume = mValue;
            break;
         case "AudioEffectVol":
            this.api.kernel.AudioManager.effectVolume = mValue;
            break;
         case "AudioEnvVol":
            this.api.kernel.AudioManager.environmentVolume = mValue;
            break;
         case "AudioMusicMute":
            this.api.kernel.AudioManager.musicMute = mValue;
            break;
         case "AudioEffectMute":
            this.api.kernel.AudioManager.effectMute = mValue;
            break;
         case "AudioEnvMute":
            this.api.kernel.AudioManager.environmentMute = mValue;
            break;
         case "TimestampInChat":
            this.api.electron.retroChatRefresh(undefined,mValue);
            this.api.kernel.ChatManager.refresh();
            break;
         case "EnableWidescreenPanels":
            this.api.electron.setWidescreenEnabled(mValue);
            _loc5_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
            if(_loc5_ != undefined)
            {
               _loc5_.configureUseFlashChat(this.api.datacenter.Basics.forceFlashChat || (!mValue || !this.api.electron.isShowingWidescreenPanel));
            }
            break;
         case "MapFilters":
            if(mValue[dofus.graphics.gapi.ui.MapExplorer.FILTER_CONQUEST_ID])
            {
               this.api.network.Conquest.worldInfosJoin();
            }
            else
            {
               this.api.network.Conquest.worldInfosLeave();
            }
            break;
         case "ShowFixRes":
            if(mValue && !this.loadValue("SpriteInfos"))
            {
               this.setOption("SpriteInfos",true);
            }
            break;
         case "GlowOnCurrentPlayer":
            if(this.api.datacenter.Game.isRunning)
            {
               _loc6_ = this.api.datacenter.Game.currentPlayerID;
               _loc7_ = this.api.datacenter.Sprites.getItemAt(_loc6_);
               _loc8_ = dofus.Constants.TEAMS_COLOR[_loc7_.Team];
               if(mValue)
               {
                  this.api.gfx.setGlowOnPlayer(_loc6_,_loc8_);
                  this.api.datacenter.Game.currentPlayerWithGlowID = _loc6_;
               }
               else
               {
                  this.api.gfx.removeGlowOnPlayer(this.api.datacenter.Game.currentPlayerWithGlowID);
                  this.api.datacenter.Game.currentPlayerWithGlowID = undefined;
               }
            }
            break;
         case "HideOptionalItem":
            this.api.gfx.spriteHandler.refreshAllSpriteAccessories();
            break;
         case "Language":
            this.api.config.language = mValue;
            this.api.electron.setLanguage(mValue);
            this.api.kernel.clearCache();
            break;
         case "ElectronBackgroundNotifications":
         case "ElectronDiscordRichPresence":
         case "ElectronEnableForceGPURendering":
         case "ElectronEnableHighRes":
         case "ElectronEnableChatDarkMode":
         case "ElectronEnableLimitWidescreenPanelWidth":
            this.api.electron.setOption(sKey,mValue);
            break;
         case "DisplayAchievementButton":
            if(this.api.datacenter.Player.Achievements.achievementsWithRewardsAvailable && mValue == true)
            {
               this.api.ui.loadUIComponent("AchievementRewards","AchievementRewards",undefined,{bStayIfPresent:true});
            }
            else if(mValue == false)
            {
               this.api.ui.getUIComponent("AchievementRewards").savePositionAndClose();
               this.api.ui.unloadUIComponent("AchievementRewardsViewer");
            }
            break;
         case "BannerLayoutLocked":
            this.api.ui.getUIComponent("Banner").lockBannerButtons(mValue);
      }
      return true;
   }
   function onMovableBarOptionChanged()
   {
      var _loc2_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      var _loc3_;
      if(_loc2_ != undefined)
      {
         _loc3_ = _loc2_.chat.replacementPanelsManager;
         if(_loc3_.currentReplacementPanel == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS)
         {
            _loc3_.changeReplacementPanel(dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP,true);
         }
      }
      if(this.getOption("chatReplacementPanel") == dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.SHORTCUTS)
      {
         this.setOption("chatReplacementPanel",dofus.graphics.gapi.ui.chat.ChatReplacementPanelsManager.MINIMAP);
      }
   }
   function resetBannerLayout(bUpdateBanner)
   {
      this._so.data.BannerLayout = dofus.managers.OptionsManager.DEFAULT_VALUES.BannerLayout;
      if(bUpdateBanner)
      {
         this.api.ui.getUIComponent("Banner").initBannerLayout();
      }
   }
}
