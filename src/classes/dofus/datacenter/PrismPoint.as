class dofus.datacenter.PrismPoint extends Object
{
   var _atkNear;
   var _nCost;
   var _nMapId;
   var _oArea;
   var _oMap;
   var api;
   var fieldToSort;
   function PrismPoint(map, cost, attackNear)
   {
      super();
      this.api = _global.API;
      this._nMapId = map;
      this._nCost = cost;
      this._atkNear = attackNear;
      this._oMap = this.api.lang.getMapText(this.mapID);
      this._oArea = this.api.lang.getMapAreaInfos(this._oMap.sa);
      this.fieldToSort = this.areaName + this.name;
   }
   function get cost()
   {
      return this._nCost;
   }
   function get mapID()
   {
      return this._nMapId;
   }
   function get attackNear()
   {
      return this._atkNear;
   }
   function get coordinates()
   {
      return this.x + ", " + this.y;
   }
   function get x()
   {
      return this.api.lang.getMapText(this._nMapId).x;
   }
   function get y()
   {
      return this.api.lang.getMapText(this._nMapId).y;
   }
   function get name()
   {
      var _loc2_ = this.api.lang.getMapSubAreaName(this._oMap.sa);
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this._nMapId + ")";
      }
      return _loc2_;
   }
   function get areaID()
   {
      return this._oArea.areaID;
   }
   function get areaName()
   {
      return this.api.lang.getMapAreaText(this._oArea.areaID).n;
   }
   function get subareaID()
   {
      return this._oMap.sa;
   }
}
