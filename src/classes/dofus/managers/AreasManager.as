class dofus.managers.AreasManager extends dofus.utils.ApiElement
{
   var _oAreasCoords;
   var _oSubAreaOutdoorMaps;
   var _oSubAreasCoords;
   static var _sSelf = null;
   function AreasManager()
   {
      super();
      dofus.managers.AreasManager._sSelf = this;
   }
   static function getInstance()
   {
      return dofus.managers.AreasManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this._oAreasCoords = {};
      this._oSubAreasCoords = {};
      this._oSubAreaOutdoorMaps = {};
      var _loc4_ = this.api.lang.getAllMapsInfos();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      for(var k in _loc4_)
      {
         _loc5_ = _loc4_[k];
         _loc6_ = _loc5_.sa;
         _loc7_ = this.api.lang.getMapSubAreaText(_loc6_).a;
         _loc8_ = this.api.lang.getMapAreaText(_loc7_).sua;
         _loc9_ = _loc8_ + "_" + _loc5_.x + "_" + _loc5_.y;
         if(this._oAreasCoords[_loc9_] == undefined)
         {
            this._oAreasCoords[_loc9_] = _loc7_;
            this._oSubAreasCoords[_loc9_] = _loc6_;
            _loc10_ = _loc5_.o;
            if(_loc10_)
            {
               if(this._oSubAreaOutdoorMaps[_loc6_] == undefined)
               {
                  this._oSubAreaOutdoorMaps[_loc6_] = {};
               }
               this._oSubAreaOutdoorMaps[_loc6_][k] = {x:_loc5_.x,y:_loc5_.y};
            }
         }
      }
   }
   function getAreaIDFromCoordinates(nX, nY, nSuperAreaID)
   {
      if(nSuperAreaID == undefined)
      {
         nSuperAreaID = 0;
      }
      return this._oAreasCoords[nSuperAreaID + "_" + nX + "_" + nY];
   }
   function getSubAreaIDFromCoordinates(nX, nY, nSuperAreaID)
   {
      if(nSuperAreaID == undefined)
      {
         nSuperAreaID = 0;
      }
      return this._oSubAreasCoords[nSuperAreaID + "_" + nX + "_" + nY];
   }
   function getOutdoorMapsFromSubarea(nSubareaID)
   {
      return this._oSubAreaOutdoorMaps[nSubareaID];
   }
}
