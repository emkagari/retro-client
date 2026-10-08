class dofus.datacenter.Crafter extends Object
{
   var _aAccessories;
   var _nBreedId;
   var _nColor1;
   var _nColor2;
   var _nColor3;
   var _nMapId;
   var _nSex;
   var _oJob;
   var _sName;
   var api;
   var id;
   function Crafter(sId, sName)
   {
      super();
      this.api = _global.API;
      this.id = sId;
      this._sName = sName;
   }
   function get name()
   {
      return this._sName;
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function get job()
   {
      return this._oJob;
   }
   function set job(value)
   {
      this._oJob = value;
   }
   function get breedId()
   {
      return this._nBreedId;
   }
   function set breedId(nBreedId)
   {
      this._nBreedId = nBreedId;
   }
   function get gfxFile()
   {
      var _loc2_ = this._nBreedId * 10 + this._nSex;
      return dofus.Constants.CLIPS_PERSOS_PATH + _loc2_ + ".swf";
   }
   function get gfxBreedFile()
   {
      return dofus.Constants.GUILDS_MINI_PATH + (this._nBreedId * 10 + this._nSex) + ".swf";
   }
   function get sex()
   {
      return this._nSex;
   }
   function set sex(value)
   {
      this._nSex = Number(value);
   }
   function get color1()
   {
      return this._nColor1;
   }
   function set color1(value)
   {
      this._nColor1 = Number(value);
   }
   function get color2()
   {
      return this._nColor2;
   }
   function set color2(value)
   {
      this._nColor2 = Number(value);
   }
   function get color3()
   {
      return this._nColor3;
   }
   function set color3(value)
   {
      this._nColor3 = Number(value);
   }
   function get accessories()
   {
      return this._aAccessories;
   }
   function set accessories(value)
   {
      this._aAccessories = value;
   }
   function set mapId(nMapId)
   {
      this._nMapId = nMapId;
   }
   function get subarea()
   {
      if(this._nMapId == 0)
      {
         return undefined;
      }
      var _loc2_ = this.api.lang.getMapText(this._nMapId);
      var _loc3_ = this.api.lang.getMapSubAreaText(_loc2_.sa);
      var _loc4_ = this.api.lang.getMapAreaText(_loc3_.a);
      return !(_loc3_.n.charAt(0) == "/" && _loc3_.n.charAt(1) == "/") ? _loc4_.n + " (" + _loc3_.n + ")" : _loc4_.n;
   }
   function get coord()
   {
      if(this._nMapId == 0)
      {
         return undefined;
      }
      var _loc2_ = this.api.lang.getMapText(this._nMapId);
      return {x:_loc2_.x,y:_loc2_.y};
   }
}
