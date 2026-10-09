class dofus.datacenter.ConquestVillageData extends Object
{
   var _bDoor;
   var _bPrism;
   var _nAlignment;
   var _nSubAreaId;
   var areaName;
   function ConquestVillageData(id, alignment, door, prism)
   {
      super();
      this._nSubAreaId = id;
      this._nAlignment = alignment;
      this._bDoor = door;
      this._bPrism = prism;
      this.areaName = String(_global.API.lang.getMapAreaText(Number(_global.API.lang.getMapSubAreaText(this._nSubAreaId).a)).n);
   }
   function get id()
   {
      return this._nSubAreaId;
   }
   function get areaId()
   {
      return Number(_global.API.lang.getMapSubAreaText(this._nSubAreaId).a);
   }
   function get alignment()
   {
      return this._nAlignment;
   }
   function get doorOpen()
   {
      return this._bDoor;
   }
   function get subway()
   {
      return this._bPrism;
   }
}
