class dofus.graphics.gapi.ui.Options extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnClose2;
   var _btnDefault;
   var _btnTabDisplay;
   var _btnTabGeneral;
   var _btnTabOptimization;
   var _btnTabSound;
   var _eaDisplayStyles;
   var _eaFlashQualities;
   var _eaLanguage;
   var _eaSpellIconsPacks;
   var _eaStylePoints;
   var _lblAudio;
   var _lblDetailLevel;
   var _lblDisplay;
   var _lblGeneral;
   var _mcComboBoxPopup;
   var _mcMask;
   var _mcPlacer;
   var _mcTabViewer;
   var _parent;
   var _sCurrentTab;
   var _sbOptions;
   var _target;
   var _winBackground;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "Options";
   static var SCROLL_BY = 20;
   function Options()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Options.CLASS_NAME);
      var _loc3_ = System.capabilities.playerType == "StandAlone" && System.capabilities.os.indexOf("Windows") != -1;
      this._eaDisplayStyles = new ank.utils.ExtendedArray();
      var _loc4_ = _root.electron;
      if(_loc4_)
      {
         this._eaDisplayStyles.push({label:this.api.lang.getText("DISPLAYSTYLE_CLASSIC"),style:"normal"});
         this._eaDisplayStyles.push({label:this.api.lang.getText("DISPLAYSTYLE_WIDESCREENCHATPANEL"),style:dofus.managers.OptionsManager.DISPLAY_STYLE_WIDESCREEN_PANELS});
      }
      else
      {
         this._eaDisplayStyles.push({label:this.api.lang.getText("DISPLAYSTYLE_NORMAL"),style:"normal"});
         if(System.capabilities.screenResolutionY > 950 || _loc3_)
         {
            this._eaDisplayStyles.push({label:this.api.lang.getText("DISPLAYSTYLE_MEDIUM" + (!_loc3_ ? "" : "_RES")),style:"medium"});
            this._eaDisplayStyles.push({label:this.api.lang.getText("DISPLAYSTYLE_MAXIMIZED" + (!_loc3_ ? "" : "_RES")),style:"maximized"});
         }
      }
      this._eaFlashQualities = new ank.utils.ExtendedArray();
      this._eaFlashQualities.push({label:this.api.lang.getText("QUALITY_LOW"),quality:"low"});
      this._eaFlashQualities.push({label:this.api.lang.getText("QUALITY_MEDIUM"),quality:"medium"});
      this._eaFlashQualities.push({label:this.api.lang.getText("QUALITY_HIGH"),quality:"high"});
      this._eaSpellIconsPacks = new ank.utils.ExtendedArray();
      this._eaSpellIconsPacks.push({label:this.api.lang.getText("UI_OPTION_SPELLCOLOR_CLASSIC"),frame:dofus.managers.OptionsManager.OPTION_SPELL_PACK_CLASSIC});
      this._eaSpellIconsPacks.push({label:this.api.lang.getText("UI_OPTION_SPELLCOLOR_REMASTERED"),frame:dofus.managers.OptionsManager.OPTION_SPELL_PACK_REMASTERED});
      this._eaSpellIconsPacks.push({label:this.api.lang.getText("UI_OPTION_SPELLCOLOR_CONTRAST"),frame:dofus.managers.OptionsManager.OPTION_SPELL_PACK_CONTRAST});
      this._eaStylePoints = new ank.utils.ExtendedArray();
      this._eaStylePoints.push({label:this.api.lang.getText("PACK_STYLE_POINT_0"),value:0});
      this._eaStylePoints.push({label:this.api.lang.getText("PACK_STYLE_POINT_1"),value:1});
      this._eaLanguage = new ank.utils.ExtendedArray();
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < this.api.config.languagesFullName.length)
      {
         _loc6_ = this.api.config.languagesFullName[_loc5_];
         _loc7_ = this.api.config.languages[_loc5_];
         this._eaLanguage.push({label:_loc6_,language:_loc7_,icon:"Flag_" + _loc7_});
         _loc5_ = _loc5_ + 1;
      }
   }
   function callClose()
   {
      this.closeAllList();
      this.unloadThis();
      return true;
   }
   function closeAllList()
   {
      this._mcTabViewer._cbDisplayStyle.closeList();
      this._mcTabViewer._cbDefaultQuality.closeList();
      this._mcTabViewer._cbSpellIconsPack.closeList();
      this._mcTabViewer._cbStylePoints.closeList();
      this._mcTabViewer._cbLanguage.closeList();
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.setCurrentTab,params:["General"]});
   }
   function initTexts()
   {
      this._lblGeneral.text = this.api.lang.getText("OPTIONS_GENERAL");
      this._lblDetailLevel.text = this.api.lang.getText("OPTIONS_DETAILLEVEL");
      this._lblAudio.text = this.api.lang.getText("OPTIONS_AUDIO");
      this._lblDisplay.text = this.api.lang.getText("OPTIONS_DISPLAY");
      this._winBackground.title = this.api.lang.getText("OPTIONS");
      this._btnTabGeneral.label = this.api.lang.getText("OPTIONS_GENERAL");
      this._btnTabSound.label = this.api.lang.getText("OPTIONS_AUDIO");
      this._btnTabDisplay.label = this.api.lang.getText("OPTIONS_DISPLAY");
      this._btnTabOptimization.label = this.api.lang.getText("OPTIONS_OPTIMIZE");
   }
   function initTabTexts()
   {
      this._mcTabViewer._lblMusic.text = this.api.lang.getText("MUSICS");
      this._mcTabViewer._lblSounds.text = this.api.lang.getText("SOUNDS");
      this._mcTabViewer._lblEnvironment.text = this.api.lang.getText("ENVIRONMENT");
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._btnDefault.label = this.api.lang.getText("DEFAUT");
      this._mcTabViewer._btnShortcuts.label = this.api.lang.getText("KEYBORD_SHORTCUT");
      this._mcTabViewer._btnClearCache.label = this.api.lang.getText("CLEAR_CACHE");
      this._mcTabViewer._btnResetTips.label = this.api.lang.getText("REINIT_WORD");
      this._mcTabViewer._btnViewSurvey.label = this.api.lang.getText("OPEN_SURVEY");
      this._mcTabViewer._btnResetBanner.label = this.api.lang.getText("RESET_BANNER_LAYOUT");
      this._mcTabViewer._lblTitleMap.text = this.api.lang.getText("MAP");
      this._mcTabViewer._lblTitleFight.text = this.api.lang.getText("FIGHT");
      this._mcTabViewer._lblTitleSecurity.text = this.api.lang.getText("SECURITY_SHORTCUT");
      this._mcTabViewer._lblTitleUI.text = this.api.lang.getText("INTERFACE_WORD");
      this._mcTabViewer._lblTitleMisc.text = this.api.lang.getText("MISC_WORD");
      this._mcTabViewer._lblTitleOptimization.text = this.api.lang.getText("OPTIONS_OPTIMIZE");
      this._mcTabViewer._lblTitleLanguage.text = this.api.lang.getText("OPTIONS_LANGUAGE");
      this._mcTabViewer._lblTitleInactiveWindow.text = this.api.lang.getText("OPTIONS_INACTIVE_WINDOW");
      this._mcTabViewer._lblTitleOptimization.text = this.api.lang.getText("OPTIONS_OPTIMIZE");
      this._mcTabViewer._lblTitleScreen.text = this.api.lang.getText("OPTION_TITLE_SCREEN");
      this._mcTabViewer._lblGrid.text = this.api.lang.getText("OPTION_GRID");
      this._mcTabViewer._lblNightMode.text = this.api.lang.getText("OPTION_NIGHT_MODE");
      this._mcTabViewer._lblTransparency.text = this.api.lang.getText("OPTION_TRANSPARENCY");
      this._mcTabViewer._lblSpriteInfos.text = this.api.lang.getText("OPTION_SPRITEINFOS");
      this._mcTabViewer._lblSpriteMove.text = this.api.lang.getText("OPTION_SPRITEMOVE");
      this._mcTabViewer._lblMapInfos.text = this.api.lang.getText("OPTION_MAPINFOS");
      this._mcTabViewer._lblAutoHideSmileys.text = this.api.lang.getText("OPTION_AUTOHIDESMILEYS");
      this._mcTabViewer._lblStringCourse.text = this.api.lang.getText("OPTION_STRINGCOURSE");
      this._mcTabViewer._lblColorfulTactic.text = this.api.lang.getText("OPTION_COLORFULTACTIC");
      this._mcTabViewer._lblPointsOverHead.text = this.api.lang.getText("OPTION_POINTSOVERHEAD");
      this._mcTabViewer._lblChatEffects.text = this.api.lang.getText("OPTION_CHATEFFECTS");
      this._mcTabViewer._lblBuff.text = this.api.lang.getText("OPTION_BUFF");
      this._mcTabViewer._lblAdvancedLineOfSight.text = this.api.lang.getText("OPTION_LINEOFSIGHT");
      this._mcTabViewer._lblRemindTurnTime.text = this.api.lang.getText("OPTION_REMINDTURN");
      this._mcTabViewer._lblHideSpellBar.text = this.api.lang.getText("OPTION_SPELLBAR");
      this._mcTabViewer._lblCraftWrongConfirm.text = this.api.lang.getText("OPTION_WRONG_CRAFT_CONFIRM");
      this._mcTabViewer._lblGuildMessageSound.text = this.api.lang.getText("OPTION_GUILDMESSAGESOUND");
      this._mcTabViewer._lblStartTurnSound.text = this.api.lang.getText("OPTION_STARTTURNSOUND");
      this._mcTabViewer._lblBannerShortcuts.text = this.api.lang.getText("OPTION_BANNERSHORTCUTS");
      this._mcTabViewer._lblTipsOnStart.text = this.api.lang.getText("OPTION_TIPSONSTART");
      this._mcTabViewer._lblCreaturesMode.text = this.api.lang.getText("OPTION_CREATURESMODE");
      this._mcTabViewer._lblDisplayStyle.text = this.api.lang.getText("OPTION_DISPLAYSTYLE");
      this._mcTabViewer._lblMovableBar.text = this.api.lang.getText("OPTION_MOVABLEBAR");
      this._mcTabViewer._lblMovableBarSize.text = this.api.lang.getText("OPTION_MOVABLEBARSIZE");
      this._mcTabViewer._lblSpellBar.text = this.api.lang.getText("OPTION_SPELLBAR");
      this._mcTabViewer._lblViewAllMonsterInGroup.text = this.api.lang.getText("OPTION_VIEWALLMONSTERINGROUP");
      this._mcTabViewer._lblCharacterPreview.text = this.api.lang.getText("OPTION_CHARACTERPREVIEW");
      this._mcTabViewer._lblSeeAllSpell.text = this.api.lang.getText("UI_OPTION_SEEALLSPELL");
      this._mcTabViewer._lblAura.text = this.api.lang.getText("OPTION_AURA");
      this._mcTabViewer._lblTutorialTips.text = this.api.lang.getText("OPTION_TUTORIALTIPS");
      this._mcTabViewer._lblCensorshipFilter.text = this.api.lang.getText("OPTION_CENSORSHIP_FILTER");
      this._mcTabViewer._lblDefaultQuality.text = this.api.lang.getText("OPTION_DEFAULTQUALITY");
      this._mcTabViewer._lblSpeakingItems.text = this.api.lang.getText("OPTION_USE_SPEAKINGITEMS");
      this._mcTabViewer._lblConfirmDropItem.text = this.api.lang.getText("OPTION_CONFIRM_DROPITEM");
      this._mcTabViewer._lblChatTimestamp.text = this.api.lang.getText("OPTION_USE_CHATTIMESTAMP");
      this._mcTabViewer._lblViewDicesDammages.text = this.api.lang.getText("OPTION_VIEW_DICES_DAMMAGES");
      this._mcTabViewer._lblAnonymousGameEvents.text = this.api.lang.getText("OPTION_ANONYMOUS_GAME_EVENTS");
      this._mcTabViewer._lblSeeDamagesColor.text = this.api.lang.getText("UI_OPTION_SEEDAMAGESCOLOR");
      this._mcTabViewer._lblRegroupDamage.text = this.api.lang.getText("OPTION_REGROUP_DAMAGE");
      this._mcTabViewer._lblStylePoints.text = this.api.lang.getText("OPTION_POINTS_STYLE");
      this._mcTabViewer._lblViewHPAsBar.text = this.api.lang.getText("OPTION_VIEW_HP_AS_BAR");
      this._mcTabViewer._lblAnimateHPBar.text = this.api.lang.getText("OPTION_ANIMATE_HP_BAR");
      this._mcTabViewer._lblShowFixRes.text = this.api.lang.getText("OPTION_SPRITE_FIX_RES");
      this._mcTabViewer._lblRightClickToCast.text = this.api.lang.getText("OPTION_RIGHT_CLICK_TO_CAST");
      this._mcTabViewer._lblHideSpritesUIFullscreen.text = this.api.lang.getText("OPTION_HIDE_SPRITES_UI_FULLSCREEN");
      this._mcTabViewer._lblGlowOnCurrentPlayer.text = this.api.lang.getText("OPTION_GLOWONCURRENTPLAYER");
      this._mcTabViewer._lblHideCeremonialShield.text = this.api.lang.getText("OPTION_HIDE_CEREMONIAL_SHIELD");
      this._mcTabViewer._lblRemasteredSpellIcons.text = this.api.lang.getText("DOFUS_REMASTERED_SPELL_ICONS");
      this._mcTabViewer._lblIngameLanguage.text = this.api.lang.getText("OPTION_INGAME_LANGUAGE");
      this._mcTabViewer._lblAchievementSound.text = this.api.lang.getText("OPTION_ACHIEVEMENTSOUND");
      this._mcTabViewer._lblDisplayAchievementButton.text = this.api.lang.getText("OPTION_ACHIEVEMENTBUTTON");
      this._mcTabViewer._lblLockBanner.text = this.api.lang.getText("LOCK_BANNER_LAYOUT");
      this._mcTabViewer._lblHideInventoryItemsCornerIcon.text = this.api.lang.getText("OPTION_HIDE_ITEM_CORNER_ICON");
      this._mcTabViewer._lblEnableAntiLag.text = this.api.lang.getText("OPTION_ENABLE_ANTILAG");
      this._mcTabViewer._lblAntiLagHideSpellAnimation.text = this.api.lang.getText("OPTION_ANTILAG_SPELL_ANIMATION");
      this._mcTabViewer._lblAntiLagHideHit.text = this.api.lang.getText("OPTION_ANTILAG_HIT");
      this._mcTabViewer._lblAntiLagHideCriticalHit.text = this.api.lang.getText("OPTION_ANTILAG_CRITICAL_HIT");
      this._mcTabViewer._lblAntiLagHideDie.text = this.api.lang.getText("OPTION_ANTILAG_DIE");
      this._mcTabViewer._lblAntiLagHideStringCourse.text = this.api.lang.getText("OPTION_ANTILAG_STRING_COURSE");
      this._mcTabViewer._lblAntiLagHidePoints.text = this.api.lang.getText("OPTION_ANTILAG_POINTS");
      this._mcTabViewer._lblAntiLagHideTimeline.text = this.api.lang.getText("OPTION_ANTILAG_TIMELINE");
      this._mcTabViewer._lblAntiLagHideSpritesFight.text = this.api.lang.getText("OPTION_ANTILAG_SPRITE_FIGHT");
      this._mcTabViewer._lblAntiLagHideEmotes.text = this.api.lang.getText("OPTION_ANTILAG_EMOTES");
      this._mcTabViewer._lblAntiLagOptimizeMovement.text = this.api.lang.getText("OPTION_ANTILAG_MOVEMENT");
      this._mcTabViewer._lblAntiLagHideSpritesExceptPartyMembers.text = this.api.lang.getText("OPTION_ANTILAG_HIDE_EXCEPT_PARTY");
      this._mcTabViewer._lblAntiLagHideChildMonsters.text = this.api.lang.getText("OPTION_ANTILAG_HIDE_EXCEPT_MAIN_MONSTER");
      this._mcTabViewer._lblAntiLagHideMerchants.text = this.api.lang.getText("OPTION_ANTILAG_HIDE_MERCHANT");
      this._mcTabViewer._lblElectronBackgroundNotifications.text = this.api.lang.getText("OPTION_ELECTRON_NOTIFICATIONS");
      this._mcTabViewer._lblElectronDiscordRichPresence.text = this.api.lang.getText("OPTION_ELECTRON_DISCORD");
      this._mcTabViewer._lblElectronEnableForceGPURendering.text = this.api.lang.getText("OPTION_ELECTRON_GPU");
      this._mcTabViewer._lblElectronEnableHighRes.text = this.api.lang.getText("OPTION_ELECTRON_HIGHRES");
      this._mcTabViewer._lblElectronEnableChatDarkMode.text = this.api.lang.getText("OPTION_ELECTRON_CHAT_DARK");
      this._mcTabViewer._lblElectronEnableLimitWidescreenPanelWidth.text = this.api.lang.getText("OPTION_ELECTRON_LIMIT_WIDESCREEN_WIDTH");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._btnDefault.addEventListener("click",this);
      this._btnTabGeneral.addEventListener("click",this);
      this._btnTabSound.addEventListener("click",this);
      this._btnTabDisplay.addEventListener("click",this);
      this._btnTabOptimization.addEventListener("click",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
      ank.utils.MouseEvents.addListener(this);
   }
   function addTabListeners()
   {
      this._mcTabViewer._btnShortcuts.addEventListener("click",this);
      this._mcTabViewer._btnClearCache.addEventListener("click",this);
      this._mcTabViewer._btnViewSurvey.addEventListener("click",this);
      this._mcTabViewer._btnGrid.addEventListener("click",this);
      this._mcTabViewer._btnNightMode.addEventListener("click",this);
      this._mcTabViewer._btnTransparency.addEventListener("click",this);
      this._mcTabViewer._btnSpriteInfos.addEventListener("click",this);
      this._mcTabViewer._btnSpriteMove.addEventListener("click",this);
      this._mcTabViewer._btnMapInfos.addEventListener("click",this);
      this._mcTabViewer._btnAutoHideSmileys.addEventListener("click",this);
      this._mcTabViewer._btnStringCourse.addEventListener("click",this);
      this._mcTabViewer._btnColorfulTactic.addEventListener("click",this);
      this._mcTabViewer._btnPointsOverHead.addEventListener("click",this);
      this._mcTabViewer._btnChatEffects.addEventListener("click",this);
      this._mcTabViewer._btnBuff.addEventListener("click",this);
      this._mcTabViewer._btnGuildMessageSound.addEventListener("click",this);
      this._mcTabViewer._btnStartTurnSound.addEventListener("click",this);
      this._mcTabViewer._btnBannerShortcuts.addEventListener("click",this);
      this._mcTabViewer._btnTipsOnStart.addEventListener("click",this);
      this._mcTabViewer._btnMovableBar.addEventListener("click",this);
      this._mcTabViewer._btnViewAllMonsterInGroup.addEventListener("click",this);
      this._mcTabViewer._btnCharacterPreview.addEventListener("click",this);
      this._mcTabViewer._btnAura.addEventListener("click",this);
      this._mcTabViewer._btnTutorialTips.addEventListener("click",this);
      this._mcTabViewer._btnResetTips.addEventListener("click",this);
      this._mcTabViewer._btnCensorshipFilter.addEventListener("click",this);
      this._mcTabViewer._btnCraftWrongConfirm.addEventListener("click",this);
      this._mcTabViewer._btnAdvancedLineOfSight.addEventListener("click",this);
      this._mcTabViewer._btnRemindTurnTime.addEventListener("click",this);
      this._mcTabViewer._btnHideSpellBar.addEventListener("click",this);
      this._mcTabViewer._btnSeeAllSpell.addEventListener("click",this);
      this._mcTabViewer._btnSpeakingItems.addEventListener("click",this);
      this._mcTabViewer._btnConfirmDropItem.addEventListener("click",this);
      this._mcTabViewer._btnChatTimestamp.addEventListener("click",this);
      this._mcTabViewer._btnViewDicesDammages.addEventListener("click",this);
      this._mcTabViewer._btnAnonymousGameEvents.addEventListener("click",this);
      this._mcTabViewer._btnSeeDamagesColor.addEventListener("click",this);
      this._mcTabViewer._btnRegroupDamage.addEventListener("click",this);
      this._mcTabViewer._btnViewHPAsBar.addEventListener("click",this);
      this._mcTabViewer._btnAnimateHPBar.addEventListener("click",this);
      this._mcTabViewer._btnShowFixRes.addEventListener("click",this);
      this._mcTabViewer._btnRightClickToCast.addEventListener("click",this);
      this._mcTabViewer._btnGlowOnCurrentPlayer.addEventListener("click",this);
      this._mcTabViewer._btnHideCeremonialShield.addEventListener("click",this);
      this._mcTabViewer._btnHideSpritesUIFullscreen.addEventListener("click",this);
      this._mcTabViewer._btnAchievementSound.addEventListener("click",this);
      this._mcTabViewer._btnDisplayAchievementButton.addEventListener("click",this);
      this._mcTabViewer._btnResetBanner.addEventListener("click",this);
      this._mcTabViewer._btnLockBanner.addEventListener("click",this);
      this._mcTabViewer._btnHideInventoryItemsCornerIcon.addEventListener("click",this);
      this._mcTabViewer._btnEnableAntiLag.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideSpellAnimation.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideHit.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideCriticalHit.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideDie.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideStringCourse.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHidePoints.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideTimeline.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideSpritesFight.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideEmotes.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagOptimizeMovement.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideSpritesExceptPartyMembers.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideChildMonsters.addEventListener("click",this);
      this._mcTabViewer._btnAntiLagHideMerchants.addEventListener("click",this);
      this._mcTabViewer._btnElectronBackgroundNotifications.addEventListener("click",this);
      this._mcTabViewer._btnElectronDiscordRichPresence.addEventListener("click",this);
      this._mcTabViewer._btnElectronEnableForceGPURendering.addEventListener("click",this);
      this._mcTabViewer._btnElectronEnableHighRes.addEventListener("click",this);
      this._mcTabViewer._btnElectronEnableChatDarkMode.addEventListener("click",this);
      this._mcTabViewer._btnElectronEnableLimitWidescreenPanelWidth.addEventListener("click",this);
      this._mcTabViewer._cbDisplayStyle.addEventListener("itemSelected",this);
      this._mcTabViewer._cbDefaultQuality.addEventListener("itemSelected",this);
      this._mcTabViewer._cbSpellIconsPack.addEventListener("itemSelected",this);
      this._mcTabViewer._cbStylePoints.addEventListener("itemSelected",this);
      this._mcTabViewer._cbLanguage.addEventListener("itemSelected",this);
      this._mcTabViewer._vsMusic.addEventListener("change",this);
      this._mcTabViewer._vsSounds.addEventListener("change",this);
      this._mcTabViewer._vsEnvironment.addEventListener("change",this);
      this._mcTabViewer._vsCreaturesMode.addEventListener("change",this);
      this._mcTabViewer._vsMovableBarSize.addEventListener("change",this);
      this._mcTabViewer._btnMuteMusic.addEventListener("click",this);
      this._mcTabViewer._btnMuteSounds.addEventListener("click",this);
      this._mcTabViewer._btnMuteEnvironment.addEventListener("click",this);
      this._mcTabViewer._ldrHelpElectronGPU.addEventListener("over",this);
      this._mcTabViewer._ldrHelpElectronGPU.addEventListener("out",this);
      this._mcTabViewer._ldrHelpElectronHighResolution.addEventListener("over",this);
      this._mcTabViewer._ldrHelpElectronHighResolution.addEventListener("out",this);
      this._mcTabViewer._ldrHelpAntilag.addEventListener("over",this);
      this._mcTabViewer._ldrHelpAntilag.addEventListener("out",this);
      this._sbOptions.addEventListener("scroll",this);
   }
   function initData()
   {
      this._mcTabViewer._btnShortcuts.enabled = this.api.kernel.XTRA_LANG_FILES_LOADED;
      var _loc2_ = this.api.kernel.OptionsManager;
      this._mcTabViewer._vsMusic.value = _loc2_.getOption("AudioMusicVol");
      this._mcTabViewer._vsSounds.value = _loc2_.getOption("AudioEffectVol");
      this._mcTabViewer._vsEnvironment.value = _loc2_.getOption("AudioEnvVol");
      this._mcTabViewer._btnMuteMusic.selected = _loc2_.getOption("AudioMusicMute");
      this._mcTabViewer._btnMuteSounds.selected = _loc2_.getOption("AudioEffectMute");
      this._mcTabViewer._btnMuteEnvironment.selected = _loc2_.getOption("AudioEnvMute");
      this._mcTabViewer._btnGrid.selected = _loc2_.getOption("Grid");
      this._mcTabViewer._btnNightMode.selected = _loc2_.getOption("NightMode");
      this._mcTabViewer._btnTransparency.selected = _loc2_.getOption("Transparency");
      this._mcTabViewer._btnSpriteInfos.selected = _loc2_.getOption("SpriteInfos");
      this._mcTabViewer._btnSpriteMove.selected = _loc2_.getOption("SpriteMove");
      this._mcTabViewer._btnMapInfos.selected = _loc2_.getOption("MapInfos");
      this._mcTabViewer._btnAutoHideSmileys.selected = _loc2_.getOption("AutoHideSmileys");
      this._mcTabViewer._btnStringCourse.selected = _loc2_.getOption("StringCourse");
      this._mcTabViewer._btnColorfulTactic.selected = _loc2_.getOption("ColorfulTactic");
      this._mcTabViewer._btnPointsOverHead.selected = _loc2_.getOption("PointsOverHead");
      this._mcTabViewer._btnChatEffects.selected = _loc2_.getOption("ChatEffects");
      this._mcTabViewer._btnBuff.selected = _loc2_.getOption("Buff");
      this._mcTabViewer._btnGuildMessageSound.selected = _loc2_.getOption("GuildMessageSound");
      this._mcTabViewer._btnStartTurnSound.selected = _loc2_.getOption("StartTurnSound");
      this._mcTabViewer._btnBannerShortcuts.selected = _loc2_.getOption("BannerShortcuts");
      this._mcTabViewer._btnTipsOnStart.selected = _loc2_.getOption("TipsOnStart");
      this._mcTabViewer._btnViewAllMonsterInGroup.selected = _loc2_.getOption("ViewAllMonsterInGroup");
      this._mcTabViewer._btnCharacterPreview.selected = _loc2_.getOption("CharacterPreview");
      this._mcTabViewer._btnAura.selected = _loc2_.getOption("Aura");
      this._mcTabViewer._btnTutorialTips.selected = _loc2_.getOption("DisplayingFreshTips");
      this._mcTabViewer._btnCensorshipFilter.selected = _loc2_.getOption("CensorshipFilter");
      this._mcTabViewer._btnCraftWrongConfirm.selected = _loc2_.getOption("AskForWrongCraft");
      this._mcTabViewer._btnAdvancedLineOfSight.selected = _loc2_.getOption("AdvancedLineOfSight");
      this._mcTabViewer._btnRemindTurnTime.selected = _loc2_.getOption("RemindTurnTime");
      this._mcTabViewer._btnHideSpellBar.selected = _loc2_.getOption("HideSpellBar");
      this._mcTabViewer._btnSeeAllSpell.selected = !_loc2_.getOption("SeeAllSpell");
      this._mcTabViewer._btnSpeakingItems.selected = _loc2_.getOption("UseSpeakingItems");
      this._mcTabViewer._btnConfirmDropItem.selected = _loc2_.getOption("ConfirmDropItem");
      this._mcTabViewer._btnChatTimestamp.selected = _loc2_.getOption("TimestampInChat");
      this._mcTabViewer._btnViewDicesDammages.selected = _loc2_.getOption("ViewDicesDammages");
      this._mcTabViewer._btnAnonymousGameEvents.selected = _loc2_.getOption("AnonymousGameEvents");
      this._mcTabViewer._btnSeeDamagesColor.selected = _loc2_.getOption("SeeDamagesColor");
      this._mcTabViewer._btnRegroupDamage.selected = _loc2_.getOption("RegroupDamage");
      this._mcTabViewer._btnViewHPAsBar.selected = _loc2_.getOption("ViewHPAsBar");
      this._mcTabViewer._btnAnimateHPBar.selected = _loc2_.getOption("AnimateHPBar");
      this._mcTabViewer._btnShowFixRes.selected = _loc2_.getOption("ShowFixRes");
      this._mcTabViewer._btnRightClickToCast.selected = _loc2_.getOption("RightClickToCast");
      this._mcTabViewer._btnGlowOnCurrentPlayer.selected = _loc2_.getOption("GlowOnCurrentPlayer");
      this._mcTabViewer._btnHideCeremonialShield.selected = _loc2_.getOption("HideOptionalItem");
      this._mcTabViewer._btnHideSpritesUIFullscreen.selected = _loc2_.getOption("HideSpritesUIFullscreen");
      this._mcTabViewer._btnAchievementSound.selected = _loc2_.getOption("AchievementSound");
      this._mcTabViewer._btnDisplayAchievementButton.selected = _loc2_.getOption("DisplayAchievementButton");
      this._mcTabViewer._btnLockBanner.selected = _loc2_.getOption("BannerLayoutLocked");
      this._mcTabViewer._btnHideInventoryItemsCornerIcon.selected = _loc2_.getOption("HideInventoryItemsCornerIcon");
      this._mcTabViewer._btnEnableAntiLag.selected = _loc2_.getOption("EnableAntiLag");
      this._mcTabViewer._btnAntiLagHideSpellAnimation.selected = _loc2_.getOption("AntiLagHideSpellAnimation");
      this._mcTabViewer._btnAntiLagHideHit.selected = _loc2_.getOption("AntiLagHideHit");
      this._mcTabViewer._btnAntiLagHideCriticalHit.selected = _loc2_.getOption("AntiLagHideCriticalHit");
      this._mcTabViewer._btnAntiLagHideDie.selected = _loc2_.getOption("AntiLagHideDie");
      this._mcTabViewer._btnAntiLagHideStringCourse.selected = _loc2_.getOption("AntiLagHideStringCourse");
      this._mcTabViewer._btnAntiLagHidePoints.selected = _loc2_.getOption("AntiLagHidePoints");
      this._mcTabViewer._btnAntiLagHideTimeline.selected = _loc2_.getOption("AntiLagHideTimeline");
      this._mcTabViewer._btnAntiLagHideSpritesFight.selected = _loc2_.getOption("AntiLagHideSpritesFight");
      this._mcTabViewer._btnAntiLagHideEmotes.selected = _loc2_.getOption("AntiLagHideEmotes");
      this._mcTabViewer._btnAntiLagOptimizeMovement.selected = _loc2_.getOption("AntiLagOptimizeMovement");
      this._mcTabViewer._btnAntiLagHideSpritesExceptPartyMembers.selected = _loc2_.getOption("AntiLagHideSpritesExceptPartyMembers");
      this._mcTabViewer._btnAntiLagHideChildMonsters.selected = _loc2_.getOption("AntiLagHideChildMonsters");
      this._mcTabViewer._btnAntiLagHideMerchants.selected = _loc2_.getOption("AntiLagHideMerchants");
      this._mcTabViewer._btnElectronBackgroundNotifications.selected = _loc2_.getOption("ElectronBackgroundNotifications");
      this._mcTabViewer._btnElectronDiscordRichPresence.selected = _loc2_.getOption("ElectronDiscordRichPresence");
      this._mcTabViewer._btnElectronEnableForceGPURendering.selected = _loc2_.getOption("ElectronEnableForceGPURendering");
      this._mcTabViewer._btnElectronEnableHighRes.selected = _loc2_.getOption("ElectronEnableHighRes") && System.capabilities.os.indexOf("Windows") != -1;
      this._mcTabViewer._btnElectronEnableChatDarkMode.selected = _loc2_.getOption("ElectronEnableChatDarkMode");
      this._mcTabViewer._btnElectronEnableLimitWidescreenPanelWidth.selected = _loc2_.getOption("ElectronEnableLimitWidescreenPanelWidth");
      this._mcTabViewer._btnMovableBar.selected = _loc2_.getOption("MovableBar");
      this._mcTabViewer._vsMovableBarSize.value = _loc2_.getOption("MovableBarSize");
      this._mcTabViewer._lblMovableBarSizeValue.text = _loc2_.getOption("MovableBarSize");
      this._mcTabViewer._vsCreaturesMode.value = _loc2_.getOption("CreaturesMode");
      this._mcTabViewer._lblCreaturesModeValue.text = _global.isFinite(_loc2_.getOption("CreaturesMode")) ? _loc2_.getOption("CreaturesMode") : this.api.lang.getText("INFINIT");
      this._mcTabViewer._cbDefaultQuality.dataProvider = this._eaFlashQualities;
      this._mcTabViewer._cbDefaultQuality.mcListParent = String(this._parent);
      this.selectQuality(_loc2_.getOption("DefaultQuality"));
      this._mcTabViewer._cbSpellIconsPack.dataProvider = this._eaSpellIconsPacks;
      this._mcTabViewer._cbSpellIconsPack.mcListParent = String(this._parent);
      this.selectRemasteredSpellIconsPack(_loc2_.getOption("RemasteredSpellIconsPack"));
      this._mcTabViewer._cbStylePoints.dataProvider = this._eaStylePoints;
      this._mcTabViewer._cbStylePoints.mcListParent = String(this._parent);
      this.selectPointStyle(_loc2_.getOption("StylePoint"));
      this._mcTabViewer._cbDisplayStyle.dataProvider = this._eaDisplayStyles;
      this._mcTabViewer._cbDisplayStyle.mcListParent = String(this._parent);
      var _loc3_ = System.capabilities.playerType == "PlugIn" || (System.capabilities.playerType == "ActiveX" || System.capabilities.playerType == "StandAlone" && System.capabilities.os.indexOf("Windows") != -1);
      this.selectDisplayStyle(_loc3_ ? _loc2_.getOption("DisplayStyle") : "normal");
      this._mcTabViewer._cbDisplayStyle.enabled = _loc3_;
      this._mcTabViewer._btnElectronEnableLimitWidescreenPanelWidth.enabled = this._mcTabViewer._btnElectronEnableChatDarkMode.enabled = _loc2_.getOption("DisplayStyle") == "widescreenpanels";
      var _loc4_ = new Color(this._mcTabViewer._cbDisplayStyle);
      _loc4_.setTransform(!_loc3_ ? {ra:30,rb:149,ga:30,gb:145,ba:30,bb:119} : {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0});
      this._mcTabViewer._btnElectronEnableHighRes.enabled = System.capabilities.os.indexOf("Windows") != -1;
      this._mcTabViewer._cbLanguage.dataProvider = this._eaLanguage;
      this._mcTabViewer._cbLanguage.mcListParent = String(this._parent);
      this.selectLanguage(_loc2_.getOption("Language"));
   }
   function selectQuality(sQuality)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < this._eaFlashQualities.length)
      {
         if(this._eaFlashQualities[_loc4_].quality == sQuality)
         {
            _loc3_ = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcTabViewer._cbDefaultQuality.selectedIndex = _loc3_;
   }
   function selectRemasteredSpellIconsPack(nPackFrame)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < this._eaSpellIconsPacks.length)
      {
         if(this._eaSpellIconsPacks[_loc4_].frame == nPackFrame)
         {
            _loc3_ = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcTabViewer._cbSpellIconsPack.selectedIndex = _loc3_;
   }
   function selectDisplayStyle(sStyleName)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < this._eaDisplayStyles.length)
      {
         if(this._eaDisplayStyles[_loc4_].style == sStyleName)
         {
            _loc3_ = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcTabViewer._cbDisplayStyle.selectedIndex = _loc3_;
   }
   function selectPointStyle(nIndex)
   {
      this._mcTabViewer._cbStylePoints.selectedIndex = nIndex;
   }
   function selectLanguage(sLanguage)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < _global.CONFIG.languages.length)
      {
         if(_global.CONFIG.languages[_loc4_] == sLanguage)
         {
            _loc3_ = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcTabViewer._cbLanguage.selectedIndex = _loc3_;
   }
   function updateCurrentTabInformations()
   {
      this._mcTabViewer.removeMovieClip();
      this.attachMovie("Options" + this._sCurrentTab + "Content","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
      this._mcTabViewer.setMask(this._mcMask);
      if(this._mcTabViewer._height > this._mcPlacer._height)
      {
         this._sbOptions._visible = true;
         this._sbOptions.min = 0;
         this._sbOptions.max = this._mcTabViewer._height - this._mcPlacer._height;
         this._sbOptions.page = this._sbOptions.max / 2;
      }
      else
      {
         this._sbOptions._visible = false;
      }
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTabTexts});
      this.addToQueue({object:this,method:this.addTabListeners});
   }
   function setCurrentTab(sNewTab)
   {
      this._mcComboBoxPopup.removeMovieClip();
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this._sbOptions.scrollPosition = 0;
      this.updateCurrentTabInformations();
   }
   function click(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "_btnTabGeneral":
         case "_btnTabSound":
         case "_btnTabDisplay":
         case "_btnTabOptimization":
            this.closeAllList();
            this.setCurrentTab(oEvent.target._name.substr(7));
            break;
         case "_btnMuteMusic":
            this.api.kernel.OptionsManager.setOption("AudioMusicMute",oEvent.target.selected);
            break;
         case "_btnMuteSounds":
            this.api.kernel.OptionsManager.setOption("AudioEffectMute",oEvent.target.selected);
            break;
         case "_btnMuteEnvironment":
            this.api.kernel.OptionsManager.setOption("AudioEnvMute",oEvent.target.selected);
            break;
         case "_btnClose":
         case "_btnClose2":
            this.callClose();
            break;
         case "_btnDefault":
            this.api.kernel.OptionsManager.loadDefault();
            break;
         case "_btnShortcuts":
            this.api.ui.loadUIComponent("Shortcuts","Shortcuts",undefined,{bAlwaysOnTop:true});
            break;
         case "_btnViewSurvey":
            this.api.network.Survey.getSurvey();
            this.callClose();
            break;
         case "_btnClearCache":
            this.api.kernel.askClearCache();
            break;
         case "_btnGrid":
            this.api.kernel.OptionsManager.setOption("Grid",oEvent.target.selected);
            break;
         case "_btnNightMode":
            this.api.kernel.OptionsManager.setOption("NightMode",oEvent.target.selected);
            break;
         case "_btnTransparency":
            this.api.kernel.OptionsManager.setOption("Transparency",oEvent.target.selected);
            break;
         case "_btnSpriteInfos":
            this.api.kernel.OptionsManager.setOption("SpriteInfos",oEvent.target.selected);
            break;
         case "_btnSpriteMove":
            this.api.kernel.OptionsManager.setOption("SpriteMove",oEvent.target.selected);
            break;
         case "_btnMapInfos":
            this.api.kernel.OptionsManager.setOption("MapInfos",oEvent.target.selected);
            break;
         case "_btnCraftWrongConfirm":
            this.api.kernel.OptionsManager.setOption("AskForWrongCraft",oEvent.target.selected);
            break;
         case "_btnAutoHideSmileys":
            this.api.kernel.OptionsManager.setOption("AutoHideSmileys",oEvent.target.selected);
            break;
         case "_btnStringCourse":
            this.api.kernel.OptionsManager.setOption("StringCourse",oEvent.target.selected);
            break;
         case "_btnColorfulTactic":
            this.api.kernel.OptionsManager.setOption("ColorfulTactic",oEvent.target.selected);
            break;
         case "_btnPointsOverHead":
            this.api.kernel.OptionsManager.setOption("PointsOverHead",oEvent.target.selected);
            break;
         case "_btnChatEffects":
            this.api.kernel.OptionsManager.setOption("ChatEffects",oEvent.target.selected);
            break;
         case "_btnBuff":
            this.api.kernel.OptionsManager.setOption("Buff",oEvent.target.selected);
            break;
         case "_btnGuildMessageSound":
            this.api.kernel.OptionsManager.setOption("GuildMessageSound",oEvent.target.selected);
            break;
         case "_btnStartTurnSound":
            this.api.kernel.OptionsManager.setOption("StartTurnSound",oEvent.target.selected);
            break;
         case "_btnBannerShortcuts":
            this.api.kernel.OptionsManager.setOption("BannerShortcuts",oEvent.target.selected);
            break;
         case "_btnTipsOnStart":
            this.api.kernel.OptionsManager.setOption("TipsOnStart",oEvent.target.selected);
            break;
         case "_btnMovableBar":
            this.api.kernel.OptionsManager.setOption("MovableBar",oEvent.target.selected);
            this.api.kernel.OptionsManager.onMovableBarOptionChanged();
            break;
         case "_btnViewAllMonsterInGroup":
            this.api.kernel.OptionsManager.setOption("ViewAllMonsterInGroup",oEvent.target.selected);
            break;
         case "_btnCharacterPreview":
            this.api.kernel.OptionsManager.setOption("CharacterPreview",oEvent.target.selected);
            break;
         case "_btnAura":
            this.api.kernel.OptionsManager.setOption("Aura",oEvent.target.selected);
            break;
         case "_btnTutorialTips":
            this.api.kernel.OptionsManager.setOption("DisplayingFreshTips",oEvent.target.selected);
            break;
         case "_btnResetTips":
            this.api.kernel.showMessage(undefined,this.api.lang.getText("DO_U_RESET_TIPS"),"CAUTION_YESNO",{name:"ResetTips",listener:this});
            break;
         case "_btnCensorshipFilter":
            this.api.kernel.OptionsManager.setOption("CensorshipFilter",oEvent.target.selected);
            break;
         case "_btnAdvancedLineOfSight":
            this.api.kernel.OptionsManager.setOption("AdvancedLineOfSight",oEvent.target.selected);
            break;
         case "_btnRemindTurnTime":
            this.api.kernel.OptionsManager.setOption("RemindTurnTime",oEvent.target.selected);
            break;
         case "_btnHideSpellBar":
            this.api.kernel.OptionsManager.setOption("HideSpellBar",oEvent.target.selected);
            break;
         case "_btnSeeAllSpell":
            this.api.kernel.OptionsManager.setOption("SeeAllSpell",!oEvent.target.selected);
            break;
         case "_btnSpeakingItems":
            this.api.kernel.OptionsManager.setOption("UseSpeakingItems",oEvent.target.selected);
            break;
         case "_btnConfirmDropItem":
            this.api.kernel.OptionsManager.setOption("ConfirmDropItem",oEvent.target.selected);
            break;
         case "_btnChatTimestamp":
            this.api.kernel.OptionsManager.setOption("TimestampInChat",oEvent.target.selected);
            this.api.kernel.ChatManager.refresh();
            break;
         case "_btnViewDicesDammages":
            this.api.kernel.OptionsManager.setOption("ViewDicesDammages",oEvent.target.selected);
            break;
         case "_btnAnonymousGameEvents":
            this.api.kernel.OptionsManager.setOption("AnonymousGameEvents",oEvent.target.selected);
            break;
         case "_btnSeeDamagesColor":
            this.api.kernel.OptionsManager.setOption("SeeDamagesColor",oEvent.target.selected);
            break;
         case "_btnRegroupDamage":
            this.api.kernel.OptionsManager.setOption("RegroupDamage",oEvent.target.selected);
            break;
         case "_btnViewHPAsBar":
            this.api.kernel.OptionsManager.setOption("ViewHPAsBar",oEvent.target.selected);
            break;
         case "_btnAnimateHPBar":
            this.api.kernel.OptionsManager.setOption("AnimateHPBar",oEvent.target.selected);
            break;
         case "_btnShowFixRes":
            this.api.kernel.OptionsManager.setOption("ShowFixRes",oEvent.target.selected);
            break;
         case "_btnRightClickToCast":
            this.api.kernel.OptionsManager.setOption("RightClickToCast",oEvent.target.selected);
            break;
         case "_btnHideSpritesUIFullscreen":
            this.api.kernel.OptionsManager.setOption("HideSpritesUIFullscreen",oEvent.target.selected);
            break;
         case "_btnGlowOnCurrentPlayer":
            this.api.kernel.OptionsManager.setOption("GlowOnCurrentPlayer",oEvent.target.selected);
            break;
         case "_btnHideCeremonialShield":
            this.api.kernel.OptionsManager.setOption("HideOptionalItem",oEvent.target.selected);
            break;
         case "_btnEnableAntiLag":
            this.api.kernel.OptionsManager.setOption("EnableAntiLag",oEvent.target.selected);
            break;
         case "_btnAntiLagHideSpellAnimation":
            this.api.kernel.OptionsManager.setOption("AntiLagHideSpellAnimation",oEvent.target.selected);
            break;
         case "_btnAntiLagHideHit":
            this.api.kernel.OptionsManager.setOption("AntiLagHideHit",oEvent.target.selected);
            break;
         case "_btnAntiLagHideCriticalHit":
            this.api.kernel.OptionsManager.setOption("AntiLagHideCriticalHit",oEvent.target.selected);
            break;
         case "_btnAntiLagHideDie":
            this.api.kernel.OptionsManager.setOption("AntiLagHideDie",oEvent.target.selected);
            break;
         case "_btnAntiLagHideStringCourse":
            this.api.kernel.OptionsManager.setOption("AntiLagHideStringCourse",oEvent.target.selected);
            break;
         case "_btnAntiLagHidePoints":
            this.api.kernel.OptionsManager.setOption("AntiLagHidePoints",oEvent.target.selected);
            break;
         case "_btnAntiLagHideTimeline":
            this.api.kernel.OptionsManager.setOption("AntiLagHideTimeline",oEvent.target.selected);
            break;
         case "_btnAntiLagHideSpritesFight":
            this.api.kernel.OptionsManager.setOption("AntiLagHideSpritesFight",oEvent.target.selected);
            break;
         case "_btnAntiLagHideEmotes":
            this.api.kernel.OptionsManager.setOption("AntiLagHideEmotes",oEvent.target.selected);
            break;
         case "_btnAntiLagOptimizeMovement":
            this.api.kernel.OptionsManager.setOption("AntiLagOptimizeMovement",oEvent.target.selected);
            break;
         case "_btnAntiLagHideSpritesExceptPartyMembers":
            this.api.kernel.OptionsManager.setOption("AntiLagHideSpritesExceptPartyMembers",oEvent.target.selected);
            break;
         case "_btnAntiLagHideChildMonsters":
            this.api.kernel.OptionsManager.setOption("AntiLagHideChildMonsters",oEvent.target.selected);
            break;
         case "_btnAntiLagHideMerchants":
            this.api.kernel.OptionsManager.setOption("AntiLagHideMerchants",oEvent.target.selected);
            break;
         case "_btnElectronBackgroundNotifications":
            this.api.kernel.OptionsManager.setOption("ElectronBackgroundNotifications",oEvent.target.selected);
            break;
         case "_btnElectronDiscordRichPresence":
            this.api.kernel.OptionsManager.setOption("ElectronDiscordRichPresence",oEvent.target.selected);
            break;
         case "_btnElectronEnableForceGPURendering":
            this.api.kernel.OptionsManager.setOption("ElectronEnableForceGPURendering",oEvent.target.selected);
            this.api.kernel.showMessage(this.api.lang.getText("CHAT_LINK_WARNING"),this.api.lang.getText("OPTION_NEEDS_REBOOT"),"ERROR_BOX");
            break;
         case "_btnElectronEnableHighRes":
            this.api.kernel.OptionsManager.setOption("ElectronEnableHighRes",oEvent.target.selected);
            this.api.kernel.showMessage(this.api.lang.getText("CHAT_LINK_WARNING"),this.api.lang.getText("OPTION_NEEDS_REBOOT"),"ERROR_BOX");
            break;
         case "_btnElectronEnableChatDarkMode":
            this.api.kernel.OptionsManager.setOption("ElectronEnableChatDarkMode",oEvent.target.selected);
            break;
         case "_btnElectronEnableLimitWidescreenPanelWidth":
            this.api.kernel.OptionsManager.setOption("ElectronEnableLimitWidescreenPanelWidth",oEvent.target.selected);
            break;
         case "_btnAchievementSound":
            this.api.kernel.OptionsManager.setOption("AchievementSound",oEvent.target.selected);
            break;
         case "_btnDisplayAchievementButton":
            this.api.kernel.OptionsManager.setOption("DisplayAchievementButton",oEvent.target.selected);
            break;
         case "_btnLockBanner":
            this.api.kernel.OptionsManager.setOption("BannerLayoutLocked",oEvent.target.selected);
            break;
         case "_btnHideInventoryItemsCornerIcon":
            this.api.kernel.OptionsManager.setOption("HideInventoryItemsCornerIcon",oEvent.target.selected);
            break;
         case "_btnResetBanner":
            this.api.kernel.showMessage(undefined,this.api.lang.getText("DO_U_RESET_BANNER_LAYOUT"),"CAUTION_YESNO",{name:"ResetBanner",listener:this});
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      switch(oEvent_.target._name)
      {
         case "_ldrHelpElectronGPU":
            this.api.ui.showTooltip(this.api.lang.getText("OPTION_TOOLTIP_ELECTRON_GPU"));
            break;
         case "_ldrHelpElectronHighResolution":
            this.api.ui.showTooltip(this.api.lang.getText("OPTION_TOOLTIP_ELECTRON_HIGHRES"));
            break;
         case "_ldrHelpAntilag":
            this.api.ui.showTooltip(this.api.lang.getText("OPTION_TOOLTIP_ANTILAG"));
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function change(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_vsMusic":
            this.api.kernel.OptionsManager.setOption("AudioMusicVol",oEvent.target.value);
            break;
         case "_vsSounds":
            this.api.kernel.OptionsManager.setOption("AudioEffectVol",oEvent.target.value);
            break;
         case "_vsEnvironment":
            this.api.kernel.OptionsManager.setOption("AudioEnvVol",oEvent.target.value);
            break;
         case "_vsCreaturesMode":
            if(oEvent.target.value == oEvent.target.max)
            {
               this.api.kernel.OptionsManager.setOption("CreaturesMode",Number.POSITIVE_INFINITY);
            }
            else if(oEvent.target.value == oEvent.target.min)
            {
               this.api.kernel.OptionsManager.setOption("CreaturesMode",0);
            }
            else
            {
               this.api.kernel.OptionsManager.setOption("CreaturesMode",Math.floor(oEvent.target.value));
            }
            break;
         case "_vsMovableBarSize":
            _loc3_ = Math.floor(oEvent.target.value);
            this.api.kernel.OptionsManager.setOption("MovableBarSize",_loc3_);
            this._mcTabViewer._lblMovableBarSizeValue.text = _loc3_.toString();
         default:
            return;
      }
   }
   function optionChanged(oEvent)
   {
      switch(oEvent.key)
      {
         case "Grid":
            this._mcTabViewer._btnGrid.selected = oEvent.value;
            break;
         case "NightMode":
            this._mcTabViewer._btnNightMode.selected = oEvent.value;
            break;
         case "Transparency":
            this._mcTabViewer._btnTransparency.selected = oEvent.value;
            break;
         case "SpriteInfos":
            this._mcTabViewer._btnSpriteInfos.selected = oEvent.value;
            break;
         case "SpriteMove":
            this._mcTabViewer._btnSpriteMove.selected = oEvent.value;
            break;
         case "MapInfos":
            this._mcTabViewer._btnMapInfos.selected = oEvent.value;
            break;
         case "AutoHideSmileys":
            this._mcTabViewer._btnAutoHideSmileys.selected = oEvent.value;
            break;
         case "StringCourse":
            this._mcTabViewer._btnStringCourse.selected = oEvent.value;
            break;
         case "ColorfulTactic":
            this._mcTabViewer._btnColorfulTactic.selected = oEvent.value;
            break;
         case "PointsOverHead":
            this._mcTabViewer._btnPointsOverHead.selected = oEvent.value;
            break;
         case "ChatEffects":
            this._mcTabViewer._btnChatEffects.selected = oEvent.value;
            break;
         case "CreaturesMode":
            this._mcTabViewer._vsCreaturesMode.value = oEvent.value;
            this._mcTabViewer._lblCreaturesModeValue.text = !_global.isFinite(oEvent.value) ? this.api.lang.getText("INFINIT") : oEvent.value;
            break;
         case "Buff":
            this._mcTabViewer._btnBuff.selected = oEvent.value;
            break;
         case "GuildMessageSound":
            this._mcTabViewer._btnGuildMessageSound.selected = oEvent.value;
            break;
         case "StartTurnSound":
            this._mcTabViewer._btnStartTurnSound.selected = oEvent.value;
            break;
         case "BannerShortcuts":
            this._mcTabViewer._btnBannerShortcuts.selected = oEvent.value;
            break;
         case "TipsOnStart":
            this._mcTabViewer._btnTipsOnStart.selected = oEvent.value;
            break;
         case "DisplayStyle":
            this._mcTabViewer.selectDisplayStyle(oEvent.value);
            break;
         case "MovableBar":
            this._mcTabViewer._btnMovableBar.selected = oEvent.value;
            break;
         case "MovableBarSize":
            this._mcTabViewer._vsMovableBarSize.value = oEvent.value;
            break;
         case "ViewAllMonsterInGroup":
            this._mcTabViewer._btnViewAllMonsterInGroup.selected = oEvent.value;
            break;
         case "CharacterPreview":
            this._mcTabViewer._btnCharacterPreview.selected = oEvent.value;
            break;
         case "Aura":
            this._mcTabViewer._btnAura.selected = oEvent.value;
            break;
         case "DisplayingFreshTips":
            this._mcTabViewer._btnTutorialTips.selected = oEvent.value;
            break;
         case "CensorshipFilter":
            this._mcTabViewer._btnCensorshipFilter.selected = oEvent.value;
            break;
         case "AskForWrongCraft":
            this._mcTabViewer._btnCraftWrongConfirm.selected = oEvent.value;
            break;
         case "AdvancedLineOfSight":
            this._mcTabViewer._btnAdvancedLineOfSight.selected = oEvent.value;
            break;
         case "RemindTurnTime":
            this._mcTabViewer._btnRemindTurnTime.selected = oEvent.value;
            break;
         case "HideSpellBar":
            this._mcTabViewer._btnHideSpellBar.selected = oEvent.value;
            break;
         case "SeeAllSpell":
            this._mcTabViewer._btnSeeAllSpell.selected = !oEvent.value;
            break;
         case "UseSpeakingItems":
            this._mcTabViewer._btnSpeakingItems.selected = oEvent.value;
            break;
         case "ConfirmDropItem":
            this._mcTabViewer._btnConfirmDropItem.selected = oEvent.value;
            break;
         case "TimestampInChat":
            this._mcTabViewer._btnChatTimestamp.selected = oEvent.value;
            this.api.kernel.ChatManager.refresh();
            break;
         case "AudioMusicMute":
            this._mcTabViewer._btnMuteMusic.selected = oEvent.value;
            break;
         case "AudioEffectMute":
            this._mcTabViewer._btnMuteSounds.selected = oEvent.value;
            break;
         case "AudioEnvMute":
            this._mcTabViewer._btnMuteEnvironment.selected = oEvent.value;
            break;
         case "RegroupDamage":
            this._mcTabViewer._btnRegroupDamage.selected = oEvent.value;
            break;
         case "ShowFixRes":
            this._mcTabViewer._btnShowFixRes.selected = oEvent.value;
            break;
         case "HideOptionalItem":
            this._mcTabViewer._btnHideCeremonialShield.selected = oEvent.value;
            break;
         case "EnableAntiLag":
            this._mcTabViewer._btnEnableAntiLag.selected = oEvent.value;
            break;
         case "AntiLagHideSpellAnimation":
            this._mcTabViewer._btnAntiLagHideSpellAnimation.selected = oEvent.value;
            break;
         case "AntiLagHideHit":
            this._mcTabViewer._btnAntiLagHideHit.selected = oEvent.value;
            break;
         case "AntiLagHideCriticalHit":
            this._mcTabViewer._btnAntiLagHideCriticalHit.selected = oEvent.value;
            break;
         case "AntiLagHideDie":
            this._mcTabViewer._btnAntiLagHideDie.selected = oEvent.value;
            break;
         case "AntiLagHideStringCourse":
            this._mcTabViewer._btnAntiLagHideStringCourse.selected = oEvent.value;
            break;
         case "AntiLagHidePoints":
            this._mcTabViewer._btnAntiLagHidePoints.selected = oEvent.value;
            break;
         case "AntiLagHideTimeline":
            this._mcTabViewer._btnAntiLagHideTimeline.selected = oEvent.value;
            break;
         case "AntiLagHideSpritesFight":
            this._mcTabViewer._btnAntiLagHideSpritesFight.selected = oEvent.value;
            break;
         case "AntiLagHideEmotes":
            this._mcTabViewer._btnAntiLagHideEmotes.selected = oEvent.value;
            break;
         case "AntiLagOptimizeMovement":
            this._mcTabViewer._btnAntiLagOptimizeMovement.selected = oEvent.value;
            break;
         case "AntiLagHideSpritesExceptPartyMembers":
            this._mcTabViewer._btnAntiLagHideSpritesExceptPartyMembers.selected = oEvent.value;
            break;
         case "AntiLagHideChildMonsters":
            this._mcTabViewer._btnAntiLagHideChildMonsters.selected = oEvent.value;
            break;
         case "AntiLagHideMerchants":
            this._mcTabViewer._btnAntiLagHideMerchants.selected = oEvent.value;
            break;
         case "ElectronBackgroundNotifications":
            this._mcTabViewer._btnElectronBackgroundNotifications.selected = oEvent.value;
            break;
         case "ElectronDiscordRichPresence":
            this._mcTabViewer._btnElectronDiscordRichPresence.selected = oEvent.value;
            break;
         case "ElectronEnableForceGPURendering":
            this._mcTabViewer._btnElectronEnableForceGPURendering.selected = oEvent.value;
            break;
         case "ElectronEnableHighRes":
            this._mcTabViewer._btnElectronEnableHighRes.selected = oEvent.value;
            break;
         case "ElectronEnableChatDarkMode":
            this._mcTabViewer._btnElectronEnableChatDarkMode.selected = oEvent.value;
            break;
         case "ElectronEnableLimitWidescreenPanelWidth":
            this._mcTabViewer._btnElectronEnableLimitWidescreenPanelWidth.selected = oEvent.value;
            break;
         case "AchievementSound":
            this._mcTabViewer._btnAchievementSound.selected = oEvent.value;
            break;
         case "DisplayAchievementButton":
            this._mcTabViewer._btnDisplayAchievementButton.selected = oEvent.value;
            break;
         case "HideInventoryItemsCornerIcon":
            this._mcTabViewer._btnHideInventoryItemsCornerIcon.selected = oEvent.value;
            break;
         case "BannerLayoutLocked":
            this._mcTabViewer._btnLockBanner.selected = oEvent.value;
         default:
            return;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc3_;
      var _loc0_;
      var _loc4_;
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
      switch(oEvent.target._name)
      {
         case "_cbDisplayStyle":
            _loc3_ = oEvent.target.selectedItem;
            if(_loc3_.style == "normal" || this.api.electron.enabled)
            {
               this.api.kernel.OptionsManager.setOption("DisplayStyle",_loc3_.style);
               var _temp_2 = this._mcTabViewer._btnElectronEnableLimitWidescreenPanelWidth;
               var _temp_1 = "enabled";
               this._mcTabViewer._btnElectronEnableChatDarkMode.enabled = _loc0_ = _loc3_.style == "widescreenpanels";
               _temp_2[_temp_1] = _loc0_;
            }
            else
            {
               this.api.kernel.showMessage(this.api.lang.getText("OPTIONS_DISPLAY"),this.api.lang.getText("DO_U_CHANGE_DISPLAYSTYLE"),"CAUTION_YESNO",{name:"Display",listener:this,params:{style:_loc3_.style}});
            }
            break;
         case "_cbDefaultQuality":
            _loc4_ = oEvent.target.selectedItem;
            this.api.kernel.showMessage(this.api.lang.getText("OPTIONS_DISPLAY"),this.api.lang.getText("DO_U_CHANGE_QUALITY_" + String(_loc4_.quality).toUpperCase()),"CAUTION_YESNO",{name:"Quality",listener:this,params:{quality:_loc4_.quality}});
            break;
         case "_cbSpellIconsPack":
            _loc5_ = oEvent.target.selectedItem;
            _loc6_ = _loc5_.frame;
            _loc7_ = this.api.kernel.OptionsManager.getOption("RemasteredSpellIconsPack");
            if(_loc7_ != _loc6_)
            {
               this.api.kernel.OptionsManager.setOption("RemasteredSpellIconsPack",_loc6_);
               this.selectRemasteredSpellIconsPack(_loc6_);
               _loc8_ = dofus.graphics.gapi.ui.Banner(this.gapi.getUIComponent("Banner"));
               if(_loc8_ != undefined)
               {
                  _loc8_.shortcuts.updateSpells();
               }
               _loc9_ = dofus.graphics.gapi.ui.Spells(this.gapi.getUIComponent("Spells"));
               if(_loc9_ != undefined)
               {
                  _loc9_.updateSpells();
                  _loc10_ = _loc9_.spellFullInfosViewer;
                  if(_loc10_ != undefined)
                  {
                     _loc10_.updateData();
                  }
               }
               _loc11_ = dofus.graphics.gapi.ui.SpellViewerOnCreate(this.gapi.getUIComponent("SpellViewerOnCreate"));
               if(_loc11_ != undefined)
               {
                  _loc11_.refreshSpellsPack();
               }
               _loc12_ = dofus.graphics.gapi.ui.SpellsCollection(this.gapi.getUIComponent("SpellsCollection"));
               if(_loc12_ != undefined)
               {
                  _loc12_.initData();
               }
            }
            break;
         case "_cbStylePoints":
            _loc13_ = oEvent.target.selectedItem;
            this.api.kernel.OptionsManager.setOption("StylePoint",_loc13_.value);
            break;
         case "_cbLanguage":
            _loc14_ = oEvent.target.selectedItem;
            if(_loc14_.language != this.api.kernel.OptionsManager.getOption("Language"))
            {
               this.api.kernel.showMessage(this.api.lang.getText("CHAT_LINK_WARNING"),this.api.lang.getText("DO_U_CHANGE_LANGUAGE"),"CAUTION_YESNO",{name:"Language",listener:this,params:{language:_loc14_.language}});
            }
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoDisplay":
            this.api.kernel.OptionsManager.setOption("DisplayStyle",oEvent.target.params.style);
            break;
         case "AskYesNoResetTips":
            dofus.managers.TipsManager.getInstance().resetDisplayedTipsList();
            break;
         case "AskYesNoQuality":
            this.api.kernel.OptionsManager.setOption("DefaultQuality",oEvent.target.params.quality);
            break;
         case "AskYesNoLanguage":
            this.api.kernel.OptionsManager.setOption("Language",oEvent.target.params.language);
            break;
         case "AskYesNoResetBanner":
            this.api.kernel.OptionsManager.resetBannerLayout(true);
         default:
            return;
      }
   }
   function no(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoDisplay":
            this.selectDisplayStyle(this.api.kernel.OptionsManager.getOption("DisplayStyle"));
            break;
         case "AskYesNoQuality":
            this.selectQuality(this.api.kernel.OptionsManager.getOption("DefaultQuality"));
            break;
         case "AskYesNoLanguage":
            this.selectLanguage(this.api.kernel.OptionsManager.getOption("Language"));
         default:
            return;
      }
   }
   function scroll(oEvent)
   {
      this._mcTabViewer._y = this._mcPlacer._y - this._sbOptions.scrollPosition;
      this.closeAllList();
   }
   function onMouseWheel(nDelta, mc)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(String(mc._target).indexOf(this._target) != -1 && this._sbOptions._visible)
      {
         this._sbOptions.scrollPosition -= nDelta <= 0 ? - dofus.graphics.gapi.ui.Options.SCROLL_BY : dofus.graphics.gapi.ui.Options.SCROLL_BY;
      }
   }
}
