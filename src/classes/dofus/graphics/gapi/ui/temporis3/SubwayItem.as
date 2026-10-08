class dofus.graphics.gapi.ui.temporis3.SubwayItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnLocate;
   var _lblCost;
   var _lblName;
   var _mcKamas;
   var _mcList;
   var _oItem;
   var addToQueue;
   function SubwayItem()
   {
      super();
      this.api = _global.API;
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      if(bUsed)
      {
         this._oItem = oItem_;
         this._lblCost.text = oItem_.cost != 0 ? new ank.utils.ExtendedString(oItem_.cost).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "-";
         this._btnLocate.label = oItem_.coordinates;
         this._lblName.text = oItem_.name;
         this._mcKamas._visible = oItem_.cost > 0;
         this._btnLocate._visible = true;
      }
      else if(this._lblCost.text != undefined)
      {
         this._lblCost.text = "";
         this._btnLocate.label = "";
         this._lblName.text = "";
         this._mcKamas._visible = false;
         this._btnLocate._visible = false;
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
   }
   function click(oEvent_)
   {
      this.api.ui.loadUIAutoHideComponent("MapExplorer","MapExplorer",{mapID:this._oItem.mapID});
   }
}
