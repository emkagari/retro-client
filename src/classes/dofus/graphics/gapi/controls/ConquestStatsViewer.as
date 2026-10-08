class dofus.graphics.gapi.controls.ConquestStatsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnDisgraceSanction;
   var _btnInformation;
   var _btnStartHunt;
   var _btnToggleHuntFinder;
   var _btnTogglePvP;
   var _lblBadLevel;
   var _lblBonus;
   var _lblBonusTitle;
   var _lblCommander;
   var _lblCommanderName;
   var _lblDishonour;
   var _lblHonour;
   var _lblHunt;
   var _lblMalusTitle;
   var _lblType;
   var _lstBonuses;
   var _mcBonusInteractivity;
   var _mcCharacter;
   var _mcDishonour;
   var _mcHonour;
   var _mcHuntShield;
   var _mcMalusInteractivity;
   var _oRank;
   var _parent;
   var _pbDishonour;
   var _pbHonour;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "ConquestStatsViewer";
   function ConquestStatsViewer()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ConquestStatsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnTogglePvP.addEventListener("click",this);
      this._btnTogglePvP.addEventListener("over",this);
      this._btnTogglePvP.addEventListener("out",this);
      this._btnDisgraceSanction.addEventListener("click",this);
      this._btnDisgraceSanction.addEventListener("over",this);
      this._btnDisgraceSanction.addEventListener("out",this);
      this._btnInformation.addEventListener("click",this);
      this._btnInformation.addEventListener("over",this);
      this._btnInformation.addEventListener("out",this);
      this.api.datacenter.Player.addEventListener("rankChanged",this);
      this.api.datacenter.Conquest.addEventListener("bonusChanged",this);
      this.api.datacenter.Player.addEventListener("huntMatchmakingStatusChanged",this);
      var ref = this;
      this._mcBonusInteractivity.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcBonusInteractivity.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._mcMalusInteractivity.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcMalusInteractivity.onRollOut = function()
      {
         ref.out({target:this});
      };
      if(this.api.datacenter.Player.Level >= dofus.Constants.HUNT_LEVEL)
      {
         this._btnToggleHuntFinder.addEventListener("click",this);
         this._btnToggleHuntFinder.addEventListener("over",this);
         this._btnToggleHuntFinder.addEventListener("out",this);
         this._btnStartHunt.addEventListener("click",this);
         this._btnStartHunt.addEventListener("over",this);
         this._btnStartHunt.addEventListener("out",this);
         this.api.datacenter.Player.addEventListener("alignmentChanged",this);
      }
   }
   function initTexts()
   {
      this._lblHonour.text = this.api.lang.getText("HONOUR_POINTS");
      this._lblDishonour.text = this.api.lang.getText("DISGRACE_POINTS");
      this._lblBonus.text = this.api.lang.getText("ALIGNED_AREA_MODIFICATORS");
      this._lblType.text = this.api.lang.getText("TYPE");
      this._lblBonusTitle.text = this.api.lang.getText("BONUS");
      this._lblMalusTitle.text = this.api.lang.getText("MALUS");
      this._lblHunt.text = this.api.lang.getText("HUNT_FINDER");
      if(this.api.datacenter.Player.Level >= dofus.Constants.HUNT_LEVEL)
      {
         this._lblCommander.text = this.api.lang.getText("YOUR_COMMANDER");
         this._btnStartHunt.label = this.api.lang.getText("HUNT_START_BUTTON");
         this._mcHuntShield._visible = false;
         this.updatePvPHuntFinderButtons();
      }
      else
      {
         this._btnStartHunt._visible = false;
         this._btnToggleHuntFinder._visible = false;
         this._lblBadLevel.text = this.api.lang.getText("LEVEL_NEED_TO_BOOST",[dofus.Constants.HUNT_LEVEL]);
      }
   }
   function initData()
   {
      this.api.network.Conquest.getAlignedBonus();
      this.rankChanged({rank:this.api.datacenter.Player.rank});
      if(this.api.datacenter.Player.Level >= dofus.Constants.HUNT_LEVEL)
      {
         this.alignmentChanged({alignment:this.api.datacenter.Player.alignment});
      }
   }
   function updateBonus()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.Conquest.alignBonus;
      var _loc4_ = this.api.datacenter.Conquest.rankMultiplicator;
      var _loc5_ = this.api.datacenter.Conquest.alignMalus;
      _loc2_.push({type:this.api.lang.getText("EXPERIMENT"),bonus:(_loc4_.drop != 0 ? "+" + _loc3_.xp * _loc4_.xp + "% (" + _loc3_.xp + "% x" + _loc4_.xp + ")" : "0%"),malus:_loc5_.xp + "%"});
      _loc2_.push({type:this.api.lang.getText("COLLECT"),bonus:(_loc4_.drop != 0 ? "+" + _loc3_.drop_ * _loc4_.drop_ + "% (" + _loc3_.drop_ + "% x" + _loc4_.drop_ + ")" : "0%"),malus:_loc5_.drop_ + "%"});
      _loc2_.push({type:this.api.lang.getText("LOOT"),bonus:(_loc4_.drop != 0 ? "+" + _loc3_.drop * _loc4_.drop + "% (" + _loc3_.drop + "% x" + _loc4_.drop + ")" : "0%"),malus:_loc5_.drop + "%"});
      this._lstBonuses.dataProvider = _loc2_;
   }
   function updatePvPHuntFinderButtons()
   {
      var _loc2_ = this.api.datacenter.Player.isHuntMatchmakingActive();
      if(_loc2_ && this.api.datacenter.Player.huntMatchmakingStatus.currentStatus == "WAITING_FOR_START_CONFIRMATION")
      {
         this._btnStartHunt._visible = true;
         this._btnToggleHuntFinder._visible = false;
      }
      else
      {
         this._btnToggleHuntFinder.label = !_loc2_ ? this.api.lang.getText("HUNT_START_FINDER") : this.api.lang.getText("HUNT_STOP_FINDER");
         this._btnToggleHuntFinder._visible = true;
         this._btnStartHunt._visible = false;
      }
   }
   function bonusChanged(oEvent)
   {
      this.updateBonus();
   }
   function rankChanged(oEvent)
   {
      this._oRank = oEvent.rank;
      var _loc3_ = this.api.lang.getGradeHonourPointsBounds(this._oRank.value);
      this._pbHonour.maximum = !_global.isNaN(_loc3_.max) ? _loc3_.max : 0;
      this._pbHonour.minimum = !_global.isNaN(_loc3_.min) ? _loc3_.min : 0;
      this._pbHonour.value = !_global.isNaN(this._oRank.honour) ? this._oRank.honour : 0;
      this._mcHonour.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oRank.honour).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._pbHonour.maximum).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcHonour.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._pbDishonour.maximum = this.api.lang.getMaxDisgracePoints();
      this._pbDishonour.value = this._oRank.disgrace;
      this._mcDishonour.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oRank.disgrace).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._pbDishonour.maximum).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcDishonour.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      var _loc4_;
      if(this._oRank.enable && this._lblHunt.text != undefined)
      {
         _loc4_ = this.api.datacenter.Player.alignment.index;
         this._btnTogglePvP.label = this.api.lang.getText("DISABLE_PVP_SHORT");
      }
      else if(this._lblHunt.text != undefined)
      {
         this._btnTogglePvP.label = this.api.lang.getText("ENABLE_PVP_SHORT");
      }
      this._btnDisgraceSanction._visible = this.api.datacenter.Player.rank.disgrace > 0;
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnStartHunt:
            this.api.network.Game.hunterAcceptPvPHunt();
            break;
         case this._btnToggleHuntFinder:
            if(!this.api.datacenter.Player.rank.enable)
            {
               _loc3_ = this.api.lang.getText("DO_U_ATTACK_WHEN_PVP_DISABLED");
               this.api.kernel.showMessage(undefined,_loc3_,"CAUTION_YESNO",{name:"ToggleHuntFinder",listener:this});
            }
            else
            {
               this.api.network.Game.toggleHunterMatchmakingRegister();
            }
            break;
         case this._btnDisgraceSanction:
            this.api.kernel.GameManager.showDisgraceSanction();
            break;
         case this._btnTogglePvP:
            if(this.api.datacenter.Player.rank.enable)
            {
               this.api.network.Game.askDisablePVPMode();
            }
            else
            {
               this.api.network.Game.onPVP("",true);
            }
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoToggleHuntFinder")
      {
         if(!this.api.datacenter.Player.rank.enable)
         {
            this.api.network.Game.enabledPVPMode(true);
         }
         this.api.network.Game.toggleHunterMatchmakingRegister();
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnTogglePvP:
            this.gapi.showTooltip(this.api.lang.getText(!this._oRank.enable ? "ENABLE_PVP" : "DISABLE_PVP"));
            break;
         case this._btnDisgraceSanction:
            this.gapi.showTooltip(this.api.lang.getText("DISGRACE_SANCTION_TOOLTIP"));
            break;
         case this._mcBonusInteractivity:
            this.gapi.showTooltip(this.api.lang.getText("CONQUEST_STATS_BONUS"));
            break;
         case this._mcMalusInteractivity:
            this.gapi.showTooltip(this.api.lang.getText("CONQUEST_STATS_MALUS"));
            break;
         case this._btnInformation:
            this.gapi.showTooltip(this.api.lang.getText("RANK_SYSTEM_INFO"));
         default:
            return;
      }
   }
   function huntMatchmakingStatusChanged(oEvent)
   {
      this.updatePvPHuntFinderButtons();
   }
   function alignmentChanged(oEvent)
   {
      if(oEvent.alignment.index == 0 || oEvent.alignment.index == 3)
      {
         this._mcCharacter.gotoAndStop(0);
         this._lblCommanderName.text = "-";
      }
      else
      {
         this._mcCharacter.gotoAndStop(oEvent.alignment.index + 1);
         this._lblCommanderName.text = this.api.lang.getText("COMMANDER_ALIGN_" + oEvent.alignment.index);
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
