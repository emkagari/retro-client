class dofus.datacenter.Waypoint extends Object
{
   var _bCurrent;
   var _bRespawn;
   var _nCost;
   var _nID;
   var _oArea;
   var _oMap;
   var api;
   var fieldToSort;
   function Waypoint(nID, bCurrent, bRespawn, nCost)
   {
      super();
      this.api = _global.API;
      this._oMap = this.api.lang.getMapText(nID);
      this._oArea = this.api.lang.getMapAreaInfos(this._oMap.sa);
      this._nID = nID;
      this._bCurrent = bCurrent;
      this._bRespawn = bRespawn;
      this._nCost = nCost;
      this.fieldToSort = this.areaName + this.subareaName;
   }
   function get id()
   {
      return this._nID;
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
   function get subareaName()
   {
      var _loc2_ = this.api.lang.getMapSubAreaName(this._oMap.sa);
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
   function get coordinates()
   {
      return this._oMap.x + ", " + this._oMap.y;
   }
   function get isRespawn()
   {
      return this._bRespawn;
   }
   function set respawn(bRespawn)
   {
      this._bRespawn = bRespawn;
   }
   function get isCurrent()
   {
      return this._bCurrent;
   }
   function get cost()
   {
      return this._nCost;
   }
}
