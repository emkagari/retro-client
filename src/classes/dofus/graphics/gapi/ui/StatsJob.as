class dofus.graphics.gapi.ui.StatsJob extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _avAlignment;
   var _btn10;
   var _btn11;
   var _btn12;
   var _btn13;
   var _btn14;
   var _btn15;
   var _btnAchievement;
   var _btnClose;
   var _btnClosePanel;
   var _btnLockExperience;
   var _btnMoreStats;
   var _btnResetStats;
   var _cbModulatedLevel;
   var _ctrAlignment;
   var _ctrGuild;
   var _ctrJob0;
   var _ctrJob1;
   var _ctrJob2;
   var _ctrSpe0;
   var _ctrSpe1;
   var _ctrSpe2;
   var _lblAP;
   var _lblAgility;
   var _lblAgilityValue;
   var _lblChance;
   var _lblChanceValue;
   var _lblEnergy;
   var _lblForce;
   var _lblForceValue;
   var _lblIntelligence;
   var _lblIntelligenceValue;
   var _lblLP;
   var _lblLPValue;
   var _lblLevel;
   var _lblMP;
   var _lblName;
   var _lblRange;
   var _lblRangeValue;
   var _lblScore;
   var _lblSummon;
   var _lblSummonValue;
   var _lblVitality;
   var _lblVitalityValue;
   var _lblWisdom;
   var _lblWisdomValue;
   var _lblXP;
   var _ldrAboutModulatedLevel;
   var _ldrAboutRestats;
   var _ldrAboutWisdom;
   var _ldrCharacter;
   var _mcAboutModulatedLevel;
   var _mcAboutWisdom;
   var _mcMoreStats;
   var _mcNoGuild;
   var _mcOverEnergy;
   var _mcViewersPlacer;
   var _pbEnergy;
   var _pbXP;
   var _popupQuantity;
   var _svStats;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "StatsJob";
   function StatsJob()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.StatsJob.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
      if(this._popupQuantity != undefined)
      {
         this._popupQuantity.callClose();
      }
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initTemporis});
      this._mcViewersPlacer._visible = false;
      this._btnClosePanel._visible = false;
      if(Key.isDown(Key.SHIFT))
      {
         this.showStats();
      }
      this.api.datacenter.Player.data.addListener(this);
      this.api.datacenter.Player.addEventListener("nameChanged",this);
      this.api.datacenter.Player.addEventListener("levelChanged",this);
      this.api.datacenter.Player.addEventListener("xpChanged",this);
      this.api.datacenter.Player.addEventListener("lpChanged",this);
      this.api.datacenter.Player.addEventListener("lpMaxChanged",this);
      this.api.datacenter.Player.addEventListener("apChanged",this);
      this.api.datacenter.Player.addEventListener("mpChanged",this);
      this.api.datacenter.Player.addEventListener("initiativeChanged",this);
      this.api.datacenter.Player.addEventListener("discernmentChanged",this);
      this.api.datacenter.Player.addEventListener("rangeChanged",this);
      this.api.datacenter.Player.addEventListener("summonChanged",this);
      this.api.datacenter.Player.addEventListener("forceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("vitalityXtraChanged",this);
      this.api.datacenter.Player.addEventListener("wisdomXtraChanged",this);
      this.api.datacenter.Player.addEventListener("chanceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("agilityXtraChanged",this);
      this.api.datacenter.Player.addEventListener("intelligenceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("bonusPointsChanged",this);
      this.api.datacenter.Player.addEventListener("energyChanged",this);
      this.api.datacenter.Player.addEventListener("energyMaxChanged",this);
      this.api.datacenter.Player.addEventListener("alignmentChanged",this);
      this.api.datacenter.Player.addEventListener("achievementScoreChanged",this);
   }
   function addListeners()
   {
      this.api.datacenter.Game.addEventListener("stateChanged",this);
      this._ctrAlignment.addEventListener("click",this);
      this._ctrAlignment.addEventListener("over",this);
      this._ctrAlignment.addEventListener("out",this);
      this._ctrGuild.addEventListener("click",this);
      this._ctrGuild.addEventListener("over",this);
      this._ctrGuild.addEventListener("out",this);
      this._btn10.addEventListener("click",this);
      this._btn10.addEventListener("over",this);
      this._btn10.addEventListener("out",this);
      this._btn11.addEventListener("click",this);
      this._btn11.addEventListener("over",this);
      this._btn11.addEventListener("out",this);
      this._btn12.addEventListener("click",this);
      this._btn12.addEventListener("over",this);
      this._btn12.addEventListener("out",this);
      this._btn13.addEventListener("click",this);
      this._btn13.addEventListener("over",this);
      this._btn13.addEventListener("out",this);
      this._btn14.addEventListener("click",this);
      this._btn14.addEventListener("over",this);
      this._btn14.addEventListener("out",this);
      this._btn15.addEventListener("click",this);
      this._btn15.addEventListener("over",this);
      this._btn15.addEventListener("out",this);
      this._btnMoreStats.addEventListener("click",this);
      this._btnMoreStats.addEventListener("over",this);
      this._btnMoreStats.addEventListener("out",this);
      this._btnResetStats.addEventListener("click",this);
      this._btnResetStats.addEventListener("over",this);
      this._btnResetStats.addEventListener("out",this);
      this._btnClose.addEventListener("click",this);
      this._btnClosePanel.addEventListener("click",this);
      this._btnLockExperience.addEventListener("click",this);
      this._btnLockExperience.addEventListener("over",this);
      this._btnLockExperience.addEventListener("out",this);
      this._btnAchievement.addEventListener("click",this);
      this._btnAchievement.addEventListener("over",this);
      this._btnAchievement.addEventListener("out",this);
      this._pbXP.addEventListener("over",this);
      this._pbXP.addEventListener("out",this);
      this._pbEnergy.addEventListener("over",this);
      this._pbEnergy.addEventListener("out",this);
      this._cbModulatedLevel.addEventListener("itemSelected",this);
      this._ldrAboutModulatedLevel.addEventListener("over",this);
      this._ldrAboutModulatedLevel.addEventListener("out",this);
      this._ldrAboutRestats.addEventListener("over",this);
      this._ldrAboutRestats.addEventListener("out",this);
      this._ldrAboutWisdom.addEventListener("over",this);
      this._ldrAboutWisdom.addEventListener("out",this);
      this._lblEnergy.addEventListener("over",this);
      this._lblEnergy.addEventListener("out",this);
      this._lblEnergy.enableOverEvents = true;
      this._lblXP.addEventListener("over",this);
      this._lblXP.addEventListener("out",this);
      this._lblXP.enableOverEvents = true;
      this._lblLevel.addEventListener("over",this);
      this._lblLevel.addEventListener("out",this);
      this._lblLevel.enableOverEvents = true;
      this._lblAP.addEventListener("over",this);
      this._lblAP.addEventListener("out",this);
      this._lblAP.enableOverEvents = true;
      this._lblMP.addEventListener("over",this);
      this._lblMP.addEventListener("out",this);
      this._lblMP.enableOverEvents = true;
      this._ctrJob1.addEventListener("over",this);
      this._ctrJob1.addEventListener("out",this);
      this._ctrJob1.enableOverEvents = true;
      this._lblVitality.addEventListener("over",this);
      this._lblVitality.addEventListener("out",this);
      this._lblVitality.enableOverEvents = true;
      this._lblRange.addEventListener("over",this);
      this._lblRange.addEventListener("out",this);
      this._lblRange.enableOverEvents = true;
      this._lblSummon.addEventListener("over",this);
      this._lblSummon.addEventListener("out",this);
      this._lblSummon.enableOverEvents = true;
      this._ctrSpe0.addEventListener("over",this);
      this._ctrSpe0.addEventListener("out",this);
      this._ctrSpe0.enableOverEvents = true;
      this._lblVitalityValue.addEventListener("over",this);
      this._lblVitalityValue.addEventListener("out",this);
      this._lblVitalityValue.enableOverEvents = true;
      this._mcAboutModulatedLevel.addEventListener("over",this);
      this._mcAboutModulatedLevel.addEventListener("out",this);
      this._mcAboutModulatedLevel.enableOverEvents = true;
      this._lblWisdomValue.addEventListener("over",this);
      this._lblWisdomValue.addEventListener("out",this);
      this._lblWisdomValue.enableOverEvents = true;
      this._lblForce.addEventListener("over",this);
      this._lblForce.addEventListener("out",this);
      this._lblForce.enableOverEvents = true;
      this._lblForceValue.addEventListener("over",this);
      this._lblForceValue.addEventListener("out",this);
      this._lblForceValue.enableOverEvents = true;
      this._lblIntelligence.addEventListener("over",this);
      this._lblIntelligence.addEventListener("out",this);
      this._lblIntelligence.enableOverEvents = true;
      this._lblIntelligenceValue.addEventListener("over",this);
      this._lblIntelligenceValue.addEventListener("out",this);
      this._lblIntelligenceValue.enableOverEvents = true;
      this._lblChance.addEventListener("over",this);
      this._lblChance.addEventListener("out",this);
      this._lblChance.enableOverEvents = true;
      this._lblChanceValue.addEventListener("over",this);
      this._lblChanceValue.addEventListener("out",this);
      this._lblChanceValue.enableOverEvents = true;
      this._lblAgility.addEventListener("over",this);
      this._lblAgility.addEventListener("out",this);
      this._lblAgility.enableOverEvents = true;
      this._lblAgilityValue.addEventListener("over",this);
      this._lblAgilityValue.addEventListener("out",this);
      this._lblAgilityValue.enableOverEvents = true;
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Player;
      this.levelChanged({value:_loc2_.Level});
      this.xpChanged({value:_loc2_.XP});
      this.lpChanged({value:_loc2_.LP});
      this.lpMaxChanged({value:_loc2_.LPmax});
      this.apChanged({value:_loc2_.AP});
      this.mpChanged({value:_loc2_.MP});
      this.initiativeChanged({value:_loc2_.Initiative});
      this.discernmentChanged({value:_loc2_.Discernment});
      this.rangeChanged({value:_loc2_.RangeModerator});
      this.summonChanged({value:_loc2_.MaxSummonedCreatures});
      this.forceXtraChanged({value:_loc2_.ForceXtra});
      this.vitalityXtraChanged({value:_loc2_.VitalityXtra});
      this.wisdomXtraChanged({value:_loc2_.WisdomXtra});
      this.chanceXtraChanged({value:_loc2_.ChanceXtra});
      this.agilityXtraChanged({value:_loc2_.AgilityXtra});
      this.intelligenceXtraChanged({value:_loc2_.IntelligenceXtra});
      this.bonusPointsChanged({value:_loc2_.BonusPoints});
      this.energyChanged({value:_loc2_.Energy});
      this.alignmentChanged({alignment:_loc2_.alignment});
      this.xpLockedChanged(_loc2_.isXpLocked);
      this._lblName.text = this.api.datacenter.Player.Name;
      this.activateBoostButtons(!this.api.datacenter.Game.isFight && this.api.datacenter.Map.bCanBoostStats);
      this._btnResetStats.enabled = this._cbModulatedLevel.enabled = !this.api.datacenter.Game.isFight && !this.api.datacenter.Temporis.isCursedDungeonMap(this.api.datacenter.Map.id);
      this.api.colors.addSprite(this._ldrCharacter,_loc2_);
      this._ldrCharacter.contentPath = dofus.Constants.GUILDS_FACES_PATH + _loc2_.Guild + _loc2_.Sex + ".swf";
      if(_loc2_.guildInfos != undefined)
      {
         this._mcNoGuild._visible = false;
         this._ctrGuild.contentPath = "SquareEmblem";
      }
      var _loc3_ = ank.utils.PatternDecoder.combine(this.api.lang.getText("POINTS",[new ank.utils.ExtendedString(_loc2_.achievementScore).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]),null,_loc2_.achievementScore <= 1);
      this._lblScore.text = _loc3_;
   }
   function initTexts()
   {
      this._lblEnergy.text = this.api.lang.getText("ENERGY");
      if(this.api.datacenter.Basics.aks_current_server.typeNum == dofus.datacenter.Server.SERVER_HARDCORE)
      {
         this._lblEnergy._alpha = 50;
         this._lblEnergy.enableOverEvents = false;
      }
      this._winBg.title = this.api.lang.getText("YOUR_STATS_JOB");
      this._mcAboutWisdom.text = this.api.lang.getText("CHARACTERISTICS");
      this._lblXP.text = this.api.lang.getText("EXPERIMENT");
      this._lblLP.text = this.api.lang.getText("LIFEPOINTS");
      this._lblAP.text = this.api.lang.getText("ACTIONPOINTS");
      this._lblMP.text = this.api.lang.getText("MOVEPOINTS");
      this._ctrJob1.text = this.api.lang.getText("INITIATIVE");
      this._lblVitality.text = this.api.lang.getText("DISCERNMENT");
      this._lblRange.text = this.api.lang.getText("FULL_STATS_ID17");
      this._lblSummon.text = this.api.lang.getText("MAX_SUMMON");
      this._lblForce.text = this.api.lang.getText("FORCE");
      this._ctrSpe0.text = this.api.lang.getText("VITALITY");
      this._mcAboutModulatedLevel.text = this.api.lang.getText("WISDOM");
      this._lblChance.text = this.api.lang.getText("CHANCE");
      this._lblAgility.text = this.api.lang.getText("AGILITY");
      this._lblIntelligence.text = this.api.lang.getText("INTELLIGENCE");
      this._ctrSpe2.text = this.api.lang.getText("CHARACTERISTICS_POINTS");
   }
   function initTemporis()
   {
      var _loc2_ = this.api.datacenter.Basics.aks_current_server.isTemporis();
      this._ldrAboutWisdom._visible = _loc2_;
      this._btnResetStats._visible = _loc2_;
      this._ldrAboutRestats._visible = _loc2_;
      this._btnResetStats.enabled = !this.api.datacenter.Game.isFight;
      this._cbModulatedLevel._visible = _loc2_;
      this._ldrAboutModulatedLevel._visible = _loc2_;
      this._cbModulatedLevel.enabled = !this.api.datacenter.Game.isFight && !this.api.datacenter.Temporis.isCursedDungeonMap(this.api.datacenter.Map.id);
   }
   function getStatsCostString(oBoost)
   {
      return "<b><u>" + this.api.lang.getText("COST") + " :" + "</u> " + oBoost.cost + "</b> " + this.api.lang.getText("POUR") + " <b>" + oBoost.count + "</b>";
   }
   function showStats()
   {
      this.hideAlignment();
      if(this._svStats == undefined)
      {
         this.attachMovie("StatsViewer","_svStats",this.getNextHighestDepth(),{_x:this._mcViewersPlacer._x,_y:this._mcViewersPlacer._y});
         this._btnClosePanel._visible = true;
         this._btnClosePanel.swapDepths(this.getNextHighestDepth());
         this._btnClosePanel._x += 70;
      }
      else
      {
         this.hideStats();
      }
   }
   function hideStats()
   {
      if(this._svStats != undefined)
      {
         this._btnClosePanel._x -= 70;
      }
      this._svStats.removeMovieClip();
      this._btnClosePanel._visible = false;
   }
   function showAlignment()
   {
      this.hideStats();
      if(this._avAlignment == undefined)
      {
         this.attachMovie("AlignmentViewer","_avAlignment",this.getNextHighestDepth(),{_x:this._mcViewersPlacer._x,_y:this._mcViewersPlacer._y});
         this._btnClosePanel._visible = true;
         this._btnClosePanel.swapDepths(this.getNextHighestDepth());
      }
      else
      {
         this.hideAlignment();
      }
   }
   function hideAlignment()
   {
      this._avAlignment.removeMovieClip();
      this._btnClosePanel._visible = false;
   }
   function activateBoostButtons(bActivated)
   {
      var _loc3_ = 10;
      while(_loc3_ < 16)
      {
         this["_btn" + _loc3_].enabled = bActivated;
         _loc3_ = _loc3_ + 1;
      }
   }
   function updateCharacteristicButton(nCharacteristicID)
   {
      var _loc3_ = this.api.datacenter.Player.getBoostCostAndCountForCharacteristic(nCharacteristicID).cost;
      var _loc4_ = this["_btn" + nCharacteristicID];
      if(_loc3_ <= this.api.datacenter.Player.BonusPoints)
      {
         _loc4_._visible = true;
      }
      else
      {
         _loc4_._visible = false;
      }
      if(this.api.datacenter.Basics.aks_current_server.isTemporis())
      {
         this._btn12.enabled = false;
         this._btn12._visible = false;
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(oEvent.target)
      {
         case this._btnClosePanel:
            this.hideAlignment();
            this.hideStats();
            break;
         case this._ctrAlignment:
            if(this.api.datacenter.Player.alignment.index == 0)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NEED_ALIGNMENT"),"ERROR_BOX");
            }
            else
            {
               this.showAlignment();
            }
            break;
         case this._ctrGuild:
            this.api.ui.getUIComponent("Banner").onGuildAskOpen();
            break;
         case this._btn10:
         case this._btn11:
         case this._btn12:
         case this._btn13:
         case this._btn14:
         case this._btn15:
            this.api.sounds.events.onStatsJobBoostButtonClick();
            _loc3_ = Number(oEvent.target._name.substr(4));
            if(this.api.datacenter.Player.canBoost(_loc3_))
            {
               var oBoost = this.api.datacenter.Player.getBoostCostAndCountForCharacteristic(_loc3_);
               var nCost = oBoost.cost;
               _loc4_ = oBoost.possibleCount;
               var nCapital = this.api.datacenter.Player.BonusPoints;
               if(Key.isDown(Key.CONTROL) || Key.isDown(Key.SHIFT))
               {
                  _loc5_ = "POPUP_QUANTITY_STATS_BOOST_DESCRIPTION";
                  _loc6_ = [this.getStatsCostString(oBoost),function(nMin, nMax, nValue)
                  {
                     return String(nValue * nCost);
                  },function(nMin, nMax, nValue)
                  {
                     return String(nCapital - nValue * nCost);
                  },function(nMin, nMax, nValue)
                  {
                     return String(nValue * oBoost.count);
                  }];
                  _loc7_ = this.gapi.loadUIComponent("PopupQuantityWithDescription","PopupQuantity",{descriptionLangKey:_loc5_,descriptionLangKeyParams:_loc6_,value:1,max:_loc4_,isMaxButtonValidationEnabled:false,params:{targetType:"charac",characteristicID:_loc3_}});
                  _loc7_.addEventListener("validate",this);
                  this._popupQuantity = _loc7_;
               }
               else
               {
                  this.api.network.Account.boost(_loc3_,1);
               }
            }
            break;
         case this._btnResetStats:
            _loc8_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoRestat",{title:this.api.lang.getText("RESET_STATS"),text:this.api.lang.getText("CONFIRM_RESET_STATS")});
            _loc8_.addEventListener("yes",this);
            break;
         case this._btnClose:
            this.callClose();
            break;
         case this._btnMoreStats:
            this.showStats();
            break;
         case this._btnLockExperience:
            this.api.network.Account.lockCharacterXp(this._btnLockExperience.selected);
            break;
         case this._btnAchievement:
            this.api.ui.loadUIAutoHideComponent("Achievements","Achievements",{selectedCategory:dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY});
         default:
            return;
      }
   }
   function validate(oEvent)
   {
      var _loc3_ = oEvent.value;
      var _loc0_;
      var _loc4_;
      if((_loc0_ = oEvent.params.targetType) === "charac")
      {
         _loc4_ = oEvent.params.characteristicID;
         this.api.network.Account.boost(_loc4_,_loc3_);
      }
   }
   function over(oEvent)
   {
      var _loc3_;
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
      var _loc15_;
      var _loc16_;
      var _loc17_;
      switch(oEvent.target)
      {
         case this._btn10:
         case this._btn11:
         case this._btn12:
         case this._btn13:
         case this._btn14:
         case this._btn15:
            _loc3_ = Number(oEvent.target._name.substr(4));
            _loc4_ = this.api.datacenter.Player.getBoostCostAndCountForCharacteristic(_loc3_);
            this.gapi.showTooltip(this.getStatsCostString(_loc4_));
            return;
         case this._ctrAlignment:
            this.gapi.showTooltip(this.api.datacenter.Player.alignment.name);
            return;
         case this._ctrGuild:
            _loc5_ = this.api.datacenter.Player.guildInfos.name;
            this.gapi.showTooltip(_loc5_ != undefined ? _loc5_ : this.api.lang.getText("INLINE_VARIABLE_GUILD_ERROR"));
            return;
         case this._btnResetStats:
            this.gapi.showTooltip(this.api.lang.getText("RESET_STATS"));
            return;
         case this._ctrSpe0:
            this.gapi.showTooltip(this.api.lang.getText("HELP_VITALITY"));
            return;
         case this._mcAboutModulatedLevel:
            this.gapi.showTooltip(this.api.lang.getText("HELP_WISDOM"));
            return;
         case this._lblIntelligence:
            this.gapi.showTooltip(this.api.lang.getText("HELP_INTELLIGENCE"));
            return;
         case this._lblForce:
            this.gapi.showTooltip(this.api.lang.getText("HELP_FORCE"));
            return;
         case this._lblChance:
            this.gapi.showTooltip(this.api.lang.getText("HELP_CHANCE"));
            return;
         case this._lblAgility:
            this.gapi.showTooltip(this.api.lang.getText("HELP_AGILITY"));
            return;
         case this._lblVitalityValue:
            _loc6_ = 11;
            _loc7_ = this.api.datacenter.Player.getStatDetail(_loc6_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc7_.s - _loc7_.a,_loc7_.a,_loc7_.i,_loc7_.d + _loc7_.b,_loc7_.s + _loc7_.i + _loc7_.d + _loc7_.b]));
            return;
         case this._lblWisdomValue:
            _loc8_ = 12;
            _loc9_ = this.api.datacenter.Player.getStatDetail(_loc8_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc9_.s - _loc9_.a,_loc9_.a,_loc9_.i,_loc9_.d + _loc9_.b,_loc9_.s + _loc9_.i + _loc9_.d + _loc9_.b]));
            return;
         case this._lblIntelligenceValue:
            _loc10_ = 15;
            _loc11_ = this.api.datacenter.Player.getStatDetail(_loc10_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc11_.s - _loc11_.a,_loc11_.a,_loc11_.i,_loc11_.d + _loc11_.b,_loc11_.s + _loc11_.i + _loc11_.d + _loc11_.b]));
            return;
         case this._lblForceValue:
            _loc12_ = 10;
            _loc13_ = this.api.datacenter.Player.getStatDetail(_loc12_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc13_.s - _loc13_.a,_loc13_.a,_loc13_.i,_loc13_.d + _loc13_.b,_loc13_.s + _loc13_.i + _loc13_.d + _loc13_.b]));
            return;
         case this._lblChanceValue:
            _loc14_ = 13;
            _loc15_ = this.api.datacenter.Player.getStatDetail(_loc14_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc15_.s - _loc15_.a,_loc15_.a,_loc15_.i,_loc15_.d + _loc15_.b,_loc15_.s + _loc15_.i + _loc15_.d + _loc15_.b]));
            return;
         case this._lblAgilityValue:
            _loc16_ = 14;
            _loc17_ = this.api.datacenter.Player.getStatDetail(_loc16_);
            this.gapi.showTooltip(this.api.lang.getText("STAT_DETAILS",[_loc17_.s - _loc17_.a,_loc17_.a,_loc17_.i,_loc17_.d + _loc17_.b,_loc17_.s + _loc17_.i + _loc17_.d + _loc17_.b]));
            return;
         case this._btnLockExperience:
            this.gapi.showTooltip(this.api.lang.getText("LOCK_XP_TOOLTIP"));
            return;
         case this._btnMoreStats:
            this.gapi.showTooltip(this.api.lang.getText("MORE_STATS"));
            return;
         case this._pbXP:
            this.gapi.showTooltip(new ank.utils.ExtendedString(this.api.datacenter.Player.XP).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._pbXP.maximum).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " <b>" + this.api.lang.getText("WORD_XP") + "</b>");
            return;
         case this._pbEnergy:
            this.gapi.showTooltip(new ank.utils.ExtendedString(this._pbEnergy.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(Math.max(10000,this._pbEnergy.maximum)).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
            return;
         case this._ldrAboutModulatedLevel:
            this.gapi.showTooltip(this.api.lang.getText("ABOUT_MODULATED_LEVEL"));
            return;
         case this._ldrAboutRestats:
            this.gapi.showTooltip(this.api.lang.getText("ABOUT_RESET_STATS"));
            return;
         case this._ldrAboutWisdom:
            this.gapi.showTooltip(this.api.lang.getText("ABOUT_WISDOM"));
            return;
         case this._lblEnergy:
            this.gapi.showTooltip(this.api.lang.getText("HELP_ENERGY"));
            return;
         case this._lblXP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_XP"));
            return;
         case this._lblLevel:
            this.gapi.showTooltip(this.api.lang.getText("HELP_LEVEL"));
            return;
         case this._lblLP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_LIFE"));
            return;
         case this._lblAP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_ACTIONPOINTS"));
            return;
         case this._lblMP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_MOVEPOINTS"));
            return;
         case this._ctrJob1:
            this.gapi.showTooltip(this.api.lang.getText("HELP_INITIATIVE"));
            return;
         case this._lblVitality:
            this.gapi.showTooltip(this.api.lang.getText("HELP_DISCERNMENT"));
            return;
         case this._lblRange:
            this.gapi.showTooltip(this.api.lang.getText("HELP_RANGE"));
            return;
         case this._lblSummon:
            this.gapi.showTooltip(this.api.lang.getText("HELP_SUMMON"));
            return;
         case this._btnAchievement:
            this.gapi.showTooltip(this.api.lang.getText("YOUR_ACHIEVEMENTS"));
            return;
         default:
            this.gapi.showTooltip(oEvent.target.contentData.name);
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._cbModulatedLevel)
      {
         _loc3_ = this._cbModulatedLevel.selectedItem;
         if(_loc3_.id == 0)
         {
            this.api.network.Temporis.episodeThree.askChangeLevel("real");
         }
         else
         {
            this.api.network.Temporis.episodeThree.askChangeLevel("" + _loc3_.id * 30);
         }
      }
   }
   function yes(oEvent)
   {
      this.api.network.Temporis.episodeThree.askRestat();
   }
   function nameChanged(oEvent)
   {
      this._lblName.text = oEvent.value;
   }
   function levelChanged(oEvent)
   {
      this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + this.api.datacenter.Player.ShowedLevel;
      var _loc3_ = new ank.utils.ExtendedArray();
      _loc3_.push({label:this.api.lang.getText("ACTUAL_LEVEL"),id:0});
      var _loc4_ = 1;
      var _loc5_;
      while(_loc4_ < 7)
      {
         _loc5_ = _loc4_ * 30;
         if(_loc5_ >= this.api.datacenter.Player.Level)
         {
            break;
         }
         _loc3_.push({label:"" + _loc5_,id:_loc4_});
         _loc4_ = _loc4_ + 1;
      }
      this._cbModulatedLevel.dataProvider = _loc3_;
      var _loc6_;
      var _loc7_;
      if(this.api.datacenter.Player.Level == this.api.datacenter.Player.ShowedLevel)
      {
         this._cbModulatedLevel.selectedIndex = 0;
      }
      else
      {
         _loc6_ = 1;
         while(_loc6_ < 7)
         {
            _loc7_ = _loc6_ * 30;
            if(_loc7_ == this.api.datacenter.Player.ShowedLevel)
            {
               this._cbModulatedLevel.selectedIndex = _loc6_;
            }
            _loc6_ = _loc6_ + 1;
         }
      }
   }
   function xpChanged(oEvent)
   {
      this._pbXP.minimum = this.api.datacenter.Player.XPlow;
      this._pbXP.maximum = this.api.datacenter.Player.Level != 200 ? this.api.datacenter.Player.XPhigh : -1;
      this._pbXP.value = oEvent.value;
   }
   function lpChanged(oEvent)
   {
      this._lblLPValue.text = String(oEvent.value);
   }
   function lpMaxChanged(oEvent)
   {
      this._mcMoreStats.text = String(oEvent.value);
   }
   function apChanged(oEvent)
   {
      this._ctrSpe1.text = String(Math.max(0,oEvent.value));
   }
   function mpChanged(oEvent)
   {
      this._mcOverEnergy.text = String(Math.max(0,oEvent.value));
   }
   function forceXtraChanged(oEvent)
   {
      this._lblForceValue.text = this.api.datacenter.Player.Force + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(10);
   }
   function vitalityXtraChanged(oEvent)
   {
      this._lblVitalityValue.text = this.api.datacenter.Player.Vitality + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(11);
   }
   function wisdomXtraChanged(oEvent)
   {
      this._lblWisdomValue.text = this.api.datacenter.Player.Wisdom + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(12);
   }
   function chanceXtraChanged(oEvent)
   {
      this._lblChanceValue.text = this.api.datacenter.Player.Chance + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(13);
   }
   function agilityXtraChanged(oEvent)
   {
      this._lblAgilityValue.text = this.api.datacenter.Player.Agility + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(14);
   }
   function intelligenceXtraChanged(oEvent)
   {
      this._lblIntelligenceValue.text = this.api.datacenter.Player.Intelligence + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
      this.updateCharacteristicButton(15);
   }
   function bonusPointsChanged(oEvent)
   {
      this._ctrJob0.text = String(oEvent.value);
   }
   function energyChanged(oEvent)
   {
      if(this.api.datacenter.Basics.aks_current_server.typeNum != dofus.datacenter.Server.SERVER_HARDCORE)
      {
         this._pbEnergy.maximum = this.api.datacenter.Player.EnergyMax;
         this._pbEnergy.value = oEvent.value;
      }
      else
      {
         this._pbEnergy._alpha = 50;
         this._pbEnergy.enabled = false;
      }
   }
   function energyMaxChanged(oEvent)
   {
      this._pbEnergy.maximum = oEvent.value;
   }
   function alignmentChanged(oEvent)
   {
      this._ctrAlignment.contentPath = oEvent.alignment.iconFile;
   }
   function initiativeChanged(oEvent)
   {
      this._lblWisdom.text = String(oEvent.value);
   }
   function discernmentChanged(oEvent)
   {
      this._ctrJob2.text = String(oEvent.value);
   }
   function rangeChanged(oEvent_)
   {
      this._lblRangeValue.text = String(oEvent_.value);
   }
   function summonChanged(oEvent_)
   {
      this._lblSummonValue.text = String(oEvent_.value);
   }
   function stateChanged(oEvent)
   {
      this.activateBoostButtons(!(oEvent.value > 1 && oEvent.value != undefined));
   }
   function xpLockedChanged(bLock)
   {
      this._btnLockExperience.selected = bLock;
   }
   function achievementScoreChanged(oEvent_)
   {
      this._lblScore = oEvent_.value;
   }
}
