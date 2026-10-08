class dofus.datacenter.DofusMap extends ank.battlefield.datacenter.Map
{
   var aTacticColorsRGB;
   var api;
   var eaMountParks;
   var id;
   function DofusMap(nID)
   {
      super(nID);
   }
   function get coordinates()
   {
      var _loc2_ = _global.API.lang.getMapText(this.id);
      return _global.API.lang.getText("COORDINATES") + " : " + _loc2_.x + ", " + _loc2_.y;
   }
   function get x()
   {
      return _global.API.lang.getMapText(this.id).x;
   }
   function get y()
   {
      return _global.API.lang.getMapText(this.id).y;
   }
   function get superarea()
   {
      var _loc2_ = _global.API.lang;
      return _loc2_.getMapAreaInfos(this.subarea).superareaID;
   }
   function get area()
   {
      var _loc2_ = _global.API.lang;
      return _loc2_.getMapAreaInfos(this.subarea).areaID;
   }
   function get subarea()
   {
      var _loc2_ = _global.API.lang;
      return _loc2_.getMapText(this.id).sa;
   }
   function get mapName()
   {
      var _loc2_ = _global.API.lang;
      return _loc2_.getMapText(this.id).n;
   }
   function get musics()
   {
      var _loc2_ = _global.API.lang;
      return _loc2_.getMapSubAreaText(this.subarea).m;
   }
   function get dungeonID()
   {
      return Number(_global.API.lang.getMapText(this.id).d);
   }
   function get dungeon()
   {
      return _global.API.lang.getDungeonText(this.dungeonID);
   }
   function get dungeonName()
   {
      return this.dungeon.n;
   }
   function get dungeonFloorName()
   {
      return this.dungeonCurrentMap.n;
   }
   function get dungeonCurrentMap()
   {
      return this.dungeon.m[this.id];
   }
   function get isDungeon()
   {
      return !_global.isNaN(this.dungeonID);
   }
   function get isGladiatrool()
   {
      return this.subarea == 86;
   }
   function get isTournament()
   {
      return _global.API.lang.getMapText(this.id).tournament;
   }
   function get firstMountPark()
   {
      return this.eaMountParks[0];
   }
   function getMountPark(instance)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this.eaMountParks.length)
      {
         _loc4_ = this.eaMountParks[_loc3_];
         if(_loc4_.instanceId == instance)
         {
            return _loc4_;
         }
         _loc3_ = _loc3_ + 1;
      }
      return undefined;
   }
   function get mountParks()
   {
      return this.eaMountParks;
   }
   function resetMountPark()
   {
      this.eaMountParks = new ank.utils.ExtendedArray();
   }
   function addMountPark(oPark)
   {
      this.eaMountParks.push(oPark);
   }
   function get tacticColors()
   {
      return this.api.lang.getMapSubareaTacticColors(this.subarea);
   }
   function get tacticColorsRGB()
   {
      if(this.aTacticColorsRGB == undefined)
      {
         return this.aTacticColorsRGB = this.parseTacticColorsInRGB(this.tacticColors);
      }
      return this.aTacticColorsRGB;
   }
   function parseTacticColorsInRGB(aColors)
   {
      var _loc3_ = this.tacticColors;
      var _loc4_ = [];
      var _loc5_ = 0;
      while(_loc5_ < _loc3_.length)
      {
         _loc4_[_loc5_] = _global.parseInt(_loc3_[_loc5_],16);
         _loc5_ = _loc5_ + 1;
      }
      return _loc4_;
   }
   static function isJail(nMapId)
   {
      switch(nMapId)
      {
         case 10240:
         case 8726:
         case 666:
            return true;
         default:
            return false;
      }
   }
   static function isOutdoor(nMapID_)
   {
      return !!_global.API.lang.getMapText(nMapID_).o;
   }
}
