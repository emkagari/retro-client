class dofus.graphics.gapi.ui.subway.PrismItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnLocate;
   var _lblArea;
   var _lblCost;
   var _lblName;
   var _ldrUnderAttack;
   var _mcKamas;
   var _mcList;
   var _oItem;
   var addToQueue;
   function PrismItem()
   {
      super();
      this.api = _global.API;
      this._ldrUnderAttack._visible = false;
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblCost.text = oItem.cost != 0 ? new ank.utils.ExtendedString(oItem.cost).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "-";
         this._btnLocate.label = "[" + oItem.coordinates + "]";
         this._lblName.text = oItem.name;
         this._lblArea.text = oItem.areaName;
         this._btnLocate._visible = true;
         this._mcKamas._visible = oItem.cost > 0;
         if(this._oItem.attackNear)
         {
            this._ldrUnderAttack._visible = true;
            this._lblName.width = 198;
         }
         else
         {
            this._ldrUnderAttack._visible = false;
            this._lblName.width = 214;
         }
      }
      else if(this._lblCost.text != undefined)
      {
         this._lblCost.text = "";
         this._btnLocate.label = "";
         this._lblName.text = "";
         this._lblArea.text = "";
         this._btnLocate._visible = false;
         this._mcKamas._visible = false;
         this._ldrUnderAttack._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnLocate.addEventListener("click",this);
      this._ldrUnderAttack.addEventListener("over",this);
      this._ldrUnderAttack.addEventListener("out",this);
   }
   function click(oEvent_)
   {
      this.api.ui.loadUIAutoHideComponent("MapExplorer","MapExplorer",{mapID:this._oItem.mapID});
   }
   function over(event)
   {
      this.api.ui.showTooltip(this.api.lang.getText("CONQUEST_NEAR_PRISM_UNDER_ATTACK"));
   }
   function out(event)
   {
      this.api.ui.hideTooltip();
   }
}
