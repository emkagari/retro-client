class dofus.graphics.gapi.ui.waypoints.WaypointsItem extends ank.gapi.core.UIBasicComponent
{
   var _btnLocate;
   var _lblArea;
   var _lblCost;
   var _lblSubarea;
   var _mcCurrent;
   var _mcKamas;
   var _mcList;
   var _mcRespawn;
   var _oItem;
   var addToQueue;
   function WaypointsItem()
   {
      super();
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
         this._lblCost.text = oItem.cost != 0 ? new ank.utils.ExtendedString(oItem.cost).addMiddleChar(_global.API.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "-";
         this._mcKamas._visible = oItem.cost > 0;
         this._btnLocate.label = "[" + oItem.coordinates + "]";
         this._lblArea.text = oItem.areaName;
         this._lblSubarea.text = oItem.subareaName;
         this._mcRespawn._visible = oItem.isRespawn;
         this._btnLocate._visible = true;
         if(this._mcRespawn._visible)
         {
            this._lblSubarea.width = 188;
         }
         else
         {
            this._lblSubarea.width = 203;
         }
         this._mcCurrent._visible = oItem.isCurrent;
      }
      else if(this._lblCost.text != undefined)
      {
         this._lblArea.text = "";
         this._lblSubarea.text = "";
         this._lblCost.text = "";
         this._btnLocate.label = "";
         this._mcRespawn._visible = false;
         this._mcCurrent._visible = false;
         this._mcKamas._visible = false;
         this._btnLocate._visible = false;
      }
   }
   function init()
   {
      super.init(false);
      this._mcRespawn._visible = false;
      this._mcCurrent._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnLocate.addEventListener("click",this);
   }
   function click(oEvent)
   {
      this._mcList.gapi.loadUIAutoHideComponent("MapExplorer","MapExplorer",{mapID:this._oItem.id});
   }
}
