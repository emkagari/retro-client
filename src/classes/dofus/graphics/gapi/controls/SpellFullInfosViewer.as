class dofus.graphics.gapi.controls.SpellFullInfosViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnLevel1;
   var _btnLevel2;
   var _btnLevel3;
   var _btnLevel4;
   var _btnLevel5;
   var _btnLevel6;
   var _btnTabCreature;
   var _btnTabCritical;
   var _btnTabGlyph;
   var _btnTabNormal;
   var _btnTabTrap;
   var _lblAP;
   var _lblAddThisHouseToGuildSystem;
   var _lblCountByTurn;
   var _lblCountByTurnByPlayer;
   var _lblCountByTurnByPlayerValue;
   var _lblCountByTurnValue;
   var _lblCriticalHit;
   var _lblCriticalHitValue;
   var _lblCriticalMiss;
   var _lblCriticalMissValue;
   var _lblDelay;
   var _lblDelayValue;
   var _lblEffectsTitle;
   var _lblFailureEndsTheTurn;
   var _lblFreeCell;
   var _lblLevel;
   var _lblLineOfSight;
   var _lblLineOnly;
   var _lblName;
   var _lblRange;
   var _lblRealCrit;
   var _lblRealCritValue;
   var _lblReqLevel;
   var _ldrIcon;
   var _lstEffects;
   var _mcCheckBoostRange;
   var _mcCheckFailureEndsTheTurn;
   var _mcCheckFreeCell;
   var _mcCheckLineOfSight;
   var _mcCheckLineOnly;
   var _mcCheckRangeBoost;
   var _mcCrossFailureEndsTheTurn;
   var _mcCrossFreeCell;
   var _mcCrossLineOfSight;
   var _mcCrossLineOnly;
   var _mcCrossRangeBoost;
   var _oSpell;
   var _txtDescription;
   var addToQueue;
   var dispatchEvent;
   var initialized;
   var unloadThis;
   static var CLASS_NAME = "SpellFullInfosViewer";
   var _sCurrentTab = "Normal";
   function SpellFullInfosViewer()
   {
      super();
   }
   function set spell(oSpell)
   {
      if(oSpell == undefined)
      {
         return;
      }
      if(oSpell == this._oSpell)
      {
         return;
      }
      this._ldrIcon.forceReload = oSpell.ID != this._oSpell.ID;
      if(!oSpell.isValid)
      {
         this._oSpell = new dofus.datacenter.Spell(oSpell.ID,1);
      }
      else
      {
         this._oSpell = oSpell;
      }
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function get spell()
   {
      return this._oSpell;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.SpellFullInfosViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.hideAllCheck();
      this._btnTabCreature._visible = false;
      this._btnTabGlyph._visible = false;
      this._btnTabTrap._visible = false;
   }
   function addListeners()
   {
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this._ldrIcon.addEventListener("complete",this);
      this._btnTabNormal.addEventListener("click",this);
      this._btnTabCritical.addEventListener("click",this);
      this._btnTabCreature.addEventListener("click",this);
      this._btnTabGlyph.addEventListener("click",this);
      this._btnTabTrap.addEventListener("click",this);
      this._btnLevel1.addEventListener("click",this);
      this._btnLevel2.addEventListener("click",this);
      this._btnLevel3.addEventListener("click",this);
      this._btnLevel4.addEventListener("click",this);
      this._btnLevel5.addEventListener("click",this);
      this._btnLevel6.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      var _loc0_;
      if((_loc0_ = sShortcut) === "ESCAPE")
      {
         this.dispatchEvent({type:"close"});
         this.unloadThis();
         _loc3_ = false;
      }
      return _loc3_;
   }
   function initData()
   {
      this.updateData();
   }
   function initTexts()
   {
      this._lblEffectsTitle.text = this.api.lang.getText("EFFECTS");
      this._lblAddThisHouseToGuildSystem.text = this.api.lang.getText("OTHER_CHARACTERISTICS");
      this._lblLineOfSight.text = this.api.lang.getText("CRITICAL_HIT_PROBABILITY");
      this._lblFreeCell.text = this.api.lang.getText("CRITICAL_MISS_PROBABILITY");
      this._lblCriticalMiss.text = this.api.lang.getText("COUNT_BY_TURN");
      this._lblCountByTurn.text = this.api.lang.getText("COUNT_BY_TURN_BY_PLAYER");
      this._lblCountByTurnValue.text = this.api.lang.getText("RANGE_BOOST");
      this._lblCriticalHit.text = this.api.lang.getText("LINE_OF_SIGHT");
      this._lblCountByTurnByPlayer.text = this.api.lang.getText("LINE_ONLY");
      this._lblRealCritValue.text = this.api.lang.getText("FREE_CELL");
      this._lblCountByTurnByPlayerValue.text = this.api.lang.getText("ACTUAL_CRITICAL_CHANCE");
      this._lblReqLevel.text = this.api.lang.getText("FAILURE_ENDS_THE_TURN");
      this._btnTabNormal.label = this.api.lang.getText("NORMAL_EFFECTS");
      this._btnTabCritical.label = this.api.lang.getText("CRITICAL_EFECTS");
      this._btnTabCreature.label = this.api.lang.getText("SUMMONED_CREATURE");
      this._btnTabGlyph.label = this.api.lang.getText("GLYPH");
      this._btnTabTrap.label = this.api.lang.getText("TRAP");
   }
   function updateData()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(this._oSpell != undefined && this._txtDescription.text != undefined)
      {
         this._ldrIcon.contentParams = this._oSpell.params;
         this._ldrIcon.contentPath = this._oSpell.iconFile;
         if(this._ldrIcon.loaded)
         {
            this._ldrIcon.content.applyColors();
         }
         this._lblDelay.text = !this._oSpell.isCastGlobalInterval ? this.api.lang.getText("DELAY_RELAUNCH") : this.api.lang.getText("DELAY_RELAUNCH_GLOBAL");
         this._lblName.text = this._oSpell.name;
         this._lblLevel.text = this.api.lang.getText("ACTUAL_SPELL_LEVEL") + ":";
         this._mcCrossRangeBoost.text = this._oSpell.minPlayerLevel == undefined ? "" : this.api.lang.getText("REQUIRED_SPELL_LEVEL") + ": " + this._oSpell.minPlayerLevel;
         this._lblRange.text = this._oSpell.rangeStr + " " + this.api.lang.getText("RANGE");
         this._lblAP.text = (!(this._oSpell.apCost < 1 && !this._oSpell.isPassive) ? this._oSpell.apCost : "1") + " " + this.api.lang.getText("AP");
         this._txtDescription.text = this._oSpell.description;
         this._btnTabCreature._visible = this._oSpell.summonSpell;
         this._btnTabGlyph._visible = this._oSpell.glyphSpell;
         this._btnTabTrap._visible = this._oSpell.trapSpell;
         if(this._oSpell.effectsCriticalHit[0] == undefined)
         {
            if(this._sCurrentTab == "Critical")
            {
               this.setCurrentTab("Normal");
            }
            this._btnTabCritical._alpha = 70;
            this._btnTabCritical.enabled = false;
         }
         else
         {
            this._btnTabCritical._alpha = 100;
            this._btnTabCritical.enabled = true;
         }
         if(!this._oSpell.summonSpell && this._sCurrentTab == "Creature")
         {
            this.setCurrentTab("Normal");
         }
         else if(!this._oSpell.glyphSpell && this._sCurrentTab == "Glyph")
         {
            this.setCurrentTab("Normal");
         }
         else if(!this._oSpell.trapSpell && this._sCurrentTab == "Trap")
         {
            this.setCurrentTab("Normal");
         }
         else
         {
            this.updateCurrentTabInformations();
         }
         _loc2_ = this.api.kernel.GameManager.getCriticalHitChance(this._oSpell.criticalHit);
         this._lblDelayValue.text = _loc2_ != 0 ? "1/" + _loc2_ : "-";
         this._lblCriticalHitValue.text = this._oSpell.criticalHit != 0 ? "1/" + this._oSpell.criticalHit : "-";
         this._lblCriticalMissValue.text = this._oSpell.criticalFailure != 0 ? "1/" + this._oSpell.criticalFailure : "-";
         this._lblRealCrit.text = this._oSpell.launchCountByTurn != 0 ? String(this._oSpell.launchCountByTurn) : "-";
         this._lblLineOnly.text = this._oSpell.launchCountByPlayerTurn != 0 ? String(this._oSpell.launchCountByPlayerTurn) : "-";
         this._lblFailureEndsTheTurn.text = this._oSpell.delayBetweenLaunch < 63 ? (this._oSpell.delayBetweenLaunch != 0 ? String(this._oSpell.delayBetweenLaunch) : "-") : "inf.";
         this._mcCheckBoostRange._visible = !this._oSpell.canBoostRange;
         this._mcCrossFreeCell._visible = this._oSpell.canBoostRange;
         this._mcCheckFailureEndsTheTurn._visible = !this._oSpell.lineOfSight;
         this._mcCrossLineOnly._visible = this._oSpell.lineOfSight;
         this._mcCheckRangeBoost._visible = !this._oSpell.lineOnly;
         this._mcCheckLineOnly._visible = this._oSpell.lineOnly;
         this._mcCrossFailureEndsTheTurn._visible = !this._oSpell.freeCell;
         this._mcCheckLineOfSight._visible = this._oSpell.freeCell;
         this._mcCheckFreeCell._visible = !this._oSpell.criticalFailureEndsTheTurn;
         this._mcCrossLineOfSight._visible = this._oSpell.criticalFailureEndsTheTurn;
         if(this._oSpell.level != undefined)
         {
            _loc3_ = 1;
            while(_loc3_ <= 6)
            {
               _loc4_ = this["_btnLevel" + _loc3_];
               _loc5_ = _loc3_ == this._oSpell.level;
               _loc4_.selected = _loc5_;
               _loc4_.enabled = !_loc5_;
               if(_loc3_ <= this._oSpell.maxLevel)
               {
                  _loc4_._alpha = 100;
               }
               else
               {
                  _loc4_.enabled = false;
                  _loc4_._alpha = 20;
               }
               _loc3_ = _loc3_ + 1;
            }
         }
         else
         {
            _loc6_ = 1;
            while(_loc6_ <= 6)
            {
               _loc7_ = this["_btnLevel" + _loc6_];
               _loc7_.selected = false;
               _loc7_.enabled = false;
               _loc7_._alpha = 20;
               _loc6_ = _loc6_ + 1;
            }
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._lblDelay.text = this.api.lang.getText("DELAY_RELAUNCH");
         this._ldrIcon.contentPath = "";
         this._lblName.text = "";
         this._lblLevel.text = "";
         this._lblRange.text = "";
         this._lblAP.text = "";
         this._txtDescription.text = "";
         this._lblCriticalHitValue.text = "";
         this._lblCriticalMissValue.text = "";
         this._lblRealCrit.text = "";
         this._lblLineOnly.text = "";
         this._lblFailureEndsTheTurn.text = "";
         this.hideAllCheck();
         this._lstEffects.dataProvider = null;
      }
   }
   function updateCurrentTabInformations()
   {
      var _loc2_;
      var _loc4_;
      var _loc3_;
      var _loc0_;
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
      var _loc17_;
      var _loc16_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      switch(this._sCurrentTab)
      {
         case "Normal":
            this._lstEffects.dataProvider = this._oSpell.effectsNormalHitWithArea;
            break;
         case "Critical":
            this._lstEffects.dataProvider = this._oSpell.effectsCriticalHitWithArea;
            break;
         case "Creature":
            _loc2_ = this._oSpell.effectsNormalHit;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_];
               if(_loc3_.type == 181)
               {
                  break;
               }
               _loc3_.type = _loc0_ = 180;
               if(_loc0_)
               {
                  _loc5_ = new ank.utils.ExtendedArray();
                  _loc6_ = this.api.datacenter.Player.data;
                  _loc5_.push(_loc6_.name + " (" + this.api.lang.getText("LEVEL") + " " + this.api.datacenter.Player.Level + ")");
                  _loc5_.push(this.api.lang.getText("LP") + " : " + this.api.datacenter.Player.LP);
                  _loc5_.push(this.api.lang.getText("AP") + " : " + _loc6_.AP);
                  _loc5_.push(this.api.lang.getText("MP") + " : " + _loc6_.MP);
                  this._lstEffects.dataProvider = _loc5_;
                  return undefined;
               }
               _loc4_ = _loc4_ + 1;
            }
            _loc7_ = new ank.utils.ExtendedArray();
            if(_loc3_ != undefined)
            {
               _loc8_ = _loc3_.param1;
               _loc9_ = _loc3_.param2;
               _loc10_ = this.api.lang.getMonstersText(_loc8_);
               _loc11_ = _loc10_["g" + _loc9_];
               _loc7_.push(_loc10_.n + " (" + this.api.lang.getText("LEVEL") + " " + _loc11_.l + ")");
               _loc12_ = !this.api.datacenter.Gladiatrool.isIncarnation(this.api.datacenter.Player.weaponItem.unicID) ? this.api.datacenter.Player.Level : 200;
               _loc13_ = Math.floor(_loc11_.lp * (1 + _loc12_ / 100));
               _loc7_.push(this.api.lang.getText("LP") + " : " + _loc13_ + " (" + _loc11_.lp + " + " + (_loc13_ - _loc11_.lp) + ")");
               _loc7_.push(this.api.lang.getText("AP") + " : " + _loc11_.ap);
               _loc7_.push(this.api.lang.getText("MP") + " : " + _loc11_.mp);
            }
            this._lstEffects.dataProvider = _loc7_;
            break;
         case "Glyph":
         case "Trap":
            _loc14_ = 400;
            if(this._sCurrentTab == "Glyph")
            {
               _loc14_ = 401;
            }
            _loc15_ = this._oSpell.effectsNormalHit;
            _loc17_ = 0;
            while(_loc17_ < _loc15_.length)
            {
               _loc16_ = _loc15_[_loc17_];
               if(_loc16_.type == _loc14_)
               {
                  break;
               }
               _loc17_ = _loc17_ + 1;
            }
            _loc18_ = new ank.utils.ExtendedArray();
            if(_loc16_ != undefined)
            {
               _loc19_ = _loc16_.param1;
               _loc20_ = _loc16_.param2;
               _loc21_ = this.api.kernel.CharactersManager.getSpellObjectFromData(_loc19_ + "~" + _loc20_ + "~");
               _loc18_ = _loc21_.effectsNormalHit;
            }
            this._lstEffects.dataProvider = _loc18_;
         default:
            return;
      }
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this.updateCurrentTabInformations();
   }
   function hideAllCheck()
   {
      this._mcCheckBoostRange._visible = true;
      this._mcCrossFreeCell._visible = false;
      this._mcCheckFailureEndsTheTurn._visible = true;
      this._mcCrossLineOnly._visible = false;
      this._mcCheckRangeBoost._visible = true;
      this._mcCheckLineOnly._visible = false;
      this._mcCrossFailureEndsTheTurn._visible = true;
      this._mcCheckLineOfSight._visible = false;
   }
   function setLevel(nLevel)
   {
      var _loc3_ = this.api.kernel.CharactersManager.getSpellObjectFromData(this._oSpell.ID + "~" + nLevel);
      if(_loc3_.isValid)
      {
         this.spell = _loc3_;
      }
      else
      {
         this["_btnLevel" + nLevel].selected = false;
      }
   }
   function complete(oEvent)
   {
      var _loc3_ = oEvent.clip;
      _loc3_.applyColors();
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_btnTabNormal":
            this.setCurrentTab("Normal");
            break;
         case "_btnTabCritical":
            this.setCurrentTab("Critical");
            break;
         case "_btnTabCreature":
            this.setCurrentTab("Creature");
            break;
         case "_btnTabGlyph":
            this.setCurrentTab("Glyph");
            break;
         case "_btnTabTrap":
            this.setCurrentTab("Trap");
            break;
         case "_btnLevel1":
         case "_btnLevel2":
         case "_btnLevel3":
         case "_btnLevel4":
         case "_btnLevel5":
         case "_btnLevel6":
            _loc3_ = oEvent.target._name.substr(9);
            this.setLevel(Number(_loc3_));
            break;
         case "_btnClose":
            this.dispatchEvent({type:"close"});
            this.unloadThis();
         default:
            return;
      }
   }
}
