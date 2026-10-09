class dofus.graphics.gapi.controls.GuildBoostsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnBoostPP;
   var _btnBoostPod;
   var _btnBoostPop;
   var _btnBoostWisdom;
   var _lblBonus;
   var _lblBonusValue;
   var _lblBoostPP;
   var _lblBoostPPValue;
   var _lblBoostPod;
   var _lblBoostPodValue;
   var _lblBoostPoints;
   var _lblBoostPointsValue;
   var _lblBoostPop;
   var _lblBoostPopValue;
   var _lblBoostWisdom;
   var _lblBoostWisdomValue;
   var _lblDescription;
   var _lblLP;
   var _lblLPValue;
   var _lblLevel;
   var _lblTaxCharacteristics;
   var _lblTaxSpells;
   var _lstSpells;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "GuildBoostsViewer";
   function GuildBoostsViewer()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.GuildBoostsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this._btnBoostWisdom._visible = false;
      this._btnBoostPod._visible = false;
      this._btnBoostPop._visible = false;
      this._btnBoostPP._visible = false;
   }
   function addListeners()
   {
      this._lstSpells.addEventListener("itemSelected",this);
      this._btnBoostPP.addEventListener("click",this);
      this._btnBoostWisdom.addEventListener("click",this);
      this._btnBoostPod.addEventListener("click",this);
      this._btnBoostPop.addEventListener("click",this);
      this._btnBoostPP.addEventListener("over",this);
      this._btnBoostWisdom.addEventListener("over",this);
      this._btnBoostPod.addEventListener("over",this);
      this._btnBoostPop.addEventListener("over",this);
      this._btnBoostPP.addEventListener("out",this);
      this._btnBoostWisdom.addEventListener("out",this);
      this._btnBoostPod.addEventListener("out",this);
      this._btnBoostPop.addEventListener("out",this);
   }
   function initTexts()
   {
      this._lblLP.text = this.api.lang.getText("LIFEPOINTS");
      this._lblBonus.text = this.api.lang.getText("DAMAGES_BONUS");
      this._lblBoostPopValue.text = this.api.lang.getText("DISCERNMENT");
      this._lblBoostWisdomValue.text = this.api.lang.getText("WISDOM");
      this._lblBoostPPValue.text = this.api.lang.getText("WEIGHT");
      this._lblBoostPointsValue.text = this.api.lang.getText("TAX_COLLECTOR_COUNT");
      this._lblBoostPodValue.text = this.api.lang.getText("GUILD_BONUSPOINTS");
      this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL");
      this._lblTaxCharacteristics.text = this.api.lang.getText("GUILD_TAXSPELLS");
      this._lblTaxSpells.text = this.api.lang.getText("GUILD_TAXCHARACTERISTICS");
      this._lblDescription.text = this.api.lang.getText("GUILD_RIGHTS_BOOST") + " " + this.api.lang.getText("OF") + " " + this.api.lang.getText("TAXCOLLECTOR").toLowerCase();
   }
   function updateData()
   {
      this.gapi.hideTooltip();
      var _loc2_ = this.api.datacenter.Player.guildInfos;
      this._lblLPValue.text = _loc2_.taxPP + "";
      this._lblBoostPP.text = _loc2_.boostProspection + "";
      this._lblBoostPod.text = _loc2_.taxPod + "";
      this._lblBoostWisdom.text = _loc2_.taxWisdom + "";
      this._lblBonusValue.text = _loc2_.taxCollectorWisdom + "";
      this._lblBoostPop.text = _loc2_.maxMountParks + "";
      this._lblBoostPoints.text = ank.utils.PatternDecoder.combine(this.api.lang.getText("POINTS",[_loc2_.boostPoints]),"m",_loc2_.boostPoints < 2);
      this._lstSpells.dataProvider = _loc2_.taxSpells;
      var _loc3_ = _loc2_.playerRights.canManageBoost && _loc2_.boostPoints > 0;
      this._btnBoostPod._visible = _loc3_ && _loc2_.canBoost("w");
      this._btnBoostPP._visible = _loc3_ && _loc2_.canBoost("p");
      this._btnBoostWisdom._visible = _loc3_ && _loc2_.canBoost("x");
      this._btnBoostPop._visible = _loc3_ && _loc2_.canBoost("c");
   }
   function itemSelected(oEvent)
   {
      this.gapi.loadUIComponent("SpellInfos","SpellInfos",{spell:oEvent.row.item});
   }
   function click(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "_btnBoostPod":
            this.api.sounds.events.onGuildButtonClick();
            this.api.network.Guild.boostCharacteristic("w");
            break;
         case "_btnBoostPP":
            this.api.sounds.events.onGuildButtonClick();
            this.api.network.Guild.boostCharacteristic("p");
            break;
         case "_btnBoostWisdom":
            this.api.sounds.events.onGuildButtonClick();
            this.api.network.Guild.boostCharacteristic("x");
            break;
         case "_btnBoostPop":
            this.api.sounds.events.onGuildButtonClick();
            this.api.network.Guild.boostCharacteristic("c");
         default:
            return;
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
      switch(oEvent.target._name)
      {
         case "_btnBoostPod":
            _loc3_ = this.api.datacenter.Player.guildInfos.getBoostCostAndCountForCharacteristic("w");
            _loc4_ = this.api.lang.getGuildBoostsMax("w");
            this.gapi.showTooltip(this.api.lang.getText("COST") + " : " + _loc3_.cost + " " + this.api.lang.getText("POUR") + " " + _loc3_.count + " (max : " + _loc4_ + ")");
            break;
         case "_btnBoostPP":
            _loc5_ = this.api.datacenter.Player.guildInfos.getBoostCostAndCountForCharacteristic("p");
            _loc6_ = this.api.lang.getGuildBoostsMax("p");
            this.gapi.showTooltip(this.api.lang.getText("COST") + " : " + _loc5_.cost + " " + this.api.lang.getText("POUR") + " " + _loc5_.count + " (max : " + _loc6_ + ")");
            break;
         case "_btnBoostWisdom":
            _loc7_ = this.api.datacenter.Player.guildInfos.getBoostCostAndCountForCharacteristic("x");
            _loc8_ = this.api.lang.getGuildBoostsMax("x");
            this.gapi.showTooltip(this.api.lang.getText("COST") + " : " + _loc7_.cost + " " + this.api.lang.getText("POUR") + " " + _loc7_.count + " (max : " + _loc8_ + ")");
            break;
         case "_btnBoostPop":
            _loc9_ = this.api.datacenter.Player.guildInfos.getBoostCostAndCountForCharacteristic("c");
            _loc10_ = this.api.lang.getGuildBoostsMax("c");
            this.gapi.showTooltip(this.api.lang.getText("COST") + " : " + _loc9_.cost + " " + this.api.lang.getText("POUR") + " " + _loc9_.count + " (max : " + _loc10_ + ")");
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function yes(oEvent)
   {
   }
}
