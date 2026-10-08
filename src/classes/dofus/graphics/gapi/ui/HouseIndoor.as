class dofus.graphics.gapi.ui.HouseIndoor extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var §\t\n§;
   var _bShared;
   var _hHouse;
   var _mcForSale;
   var _mcHouse;
   var _mcLock;
   var _parent;
   var unloadThis;
   static var CLASS_NAME = "HouseIndoor";
   function HouseIndoor()
   {
      super();
   }
   function set house(hHouse)
   {
      this._hHouse = hHouse;
      this.api.gfx.addEventListener("mapLoaded",this);
      hHouse.addEventListener("forsale",this);
      hHouse.addEventListener("locked",this);
      this._mcForSale._visible = hHouse.isForSale;
      this._mcLock._visible = hHouse.isLocked;
   }
   function set skills(aSkills)
   {
      this._bShared = aSkills;
      return this["\t\n"]();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.HouseIndoor.CLASS_NAME);
   }
   function createChildren()
   {
      this._mcHouse.onRelease = this.click;
      if(this._hHouse == undefined)
      {
         this._mcForSale._visible = false;
         this._mcLock._visible = false;
      }
   }
   function click()
   {
      var _loc2_ = this._parent._hHouse.instanceID;
      this._parent.api.kernel.HouseManager.openHouseMenu(undefined,_loc2_,this._parent._bShared,undefined);
   }
   function forsale(oEvent)
   {
      this._mcForSale._visible = oEvent.value;
   }
   function locked(oEvent)
   {
      this._mcLock._visible = oEvent.value;
   }
   function mapLoaded(oEvent)
   {
      var _loc3_ = oEvent.currentMap;
      if(this.api.lang.getHousesMapText(_loc3_.id) == undefined || this.api.lang.getHousesMapText(_loc3_.id) != this._hHouse.id)
      {
         this.unloadThis();
      }
   }
}
