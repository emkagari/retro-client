class dofus.graphics.gapi.controls.TaxCollectorsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnHireTaxCollector;
   var _dgTaxCollectors;
   var _lblCount;
   var _lblDescription;
   var _lblHowDefend;
   var _parent;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "TaxCollectorsViewer";
   function TaxCollectorsViewer()
   {
      super();
   }
   function set taxCollectors(eaTaxCollectors)
   {
      this.updateData(eaTaxCollectors);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.TaxCollectorsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnHireTaxCollector.addEventListener("click",this);
      this._btnHireTaxCollector.addEventListener("over",this);
      this._btnHireTaxCollector.addEventListener("out",this);
   }
   function initTexts()
   {
      this._dgTaxCollectors.columnsNames = ["",this.api.lang.getText("NAME_BIG") + " / " + this.api.lang.getText("LOCALISATION"),this.api.lang.getText("ATTACKERS_SMALL"),this.api.lang.getText("DEFENDERS")];
      this._lblDescription.text = this.api.lang.getText("GUILD_TAXCOLLECTORS_LIST");
      this._lblHowDefend.text = this.api.lang.getText("HELP_HOW_DEFEND_TAX_SHORT");
      this._btnHireTaxCollector.label = this.api.lang.getText("HIRE_TAXCOLLECTOR");
   }
   function updateData(eaTaxCollectors)
   {
      var _loc3_ = this.api.datacenter.Player.guildInfos;
      this._lblCount.text = this.api.lang.getText("GUILD_TAX_COUNT",[_loc3_.taxCount,_loc3_.taxCountMax]);
      eaTaxCollectors.sortOn(["state","isMine","startDate"],Array.NUMERIC | Array.DESCENDING);
      this._dgTaxCollectors.dataProvider = eaTaxCollectors;
      this._btnHireTaxCollector.enabled = _loc3_.playerRights.canHireTaxCollector && (_loc3_.taxCount < _loc3_.taxCountMax && !this.api.datacenter.Player.cantInteractWithTaxCollector);
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._btnHireTaxCollector)
      {
         _loc3_ = this.api.datacenter.Player;
         if(_loc3_.guildInfos.taxcollectorHireCost < _loc3_.Kama)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("DO_YOU_HIRE_TAXCOLLECTOR",[new ank.utils.ExtendedString(_loc3_.guildInfos.taxcollectorHireCost).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]),"CAUTION_YESNO",{name:"GuildTaxCollector",listener:this});
         }
         else
         {
            this.api.kernel.showMessage("undefined",this.api.lang.getText("NOT_ENOUGTH_RICH_TO_HIRE_TAX"),"ERROR_BOX");
         }
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnHireTaxCollector)
      {
         this.gapi.showTooltip(this.api.lang.getText("COST") + " : " + new ank.utils.ExtendedString(this.api.datacenter.Player.guildInfos.taxcollectorHireCost).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " " + this.api.lang.getText("KAMAS"));
      }
   }
   function yes(oEvent)
   {
      this.api.network.Guild.hireTaxCollector();
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
