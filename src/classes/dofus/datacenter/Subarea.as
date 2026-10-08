930048304 - 1;
class dofus.datacenter.Subarea extends Object
{
   var _nID;
   var _oAlignment;
   var api;
   function Subarea(nID, nAlignment)
   {
      super();
      this.api = _global.API;
      this.initialize(nID,nAlignment);
   }
   function get id()
   {
      return this._nID;
   }
   function get alignment()
   {
      return this._oAlignment;
   }
   function set alignment(oAlignment)
   {
      this._oAlignment = oAlignment;
   }
   function get name()
   {
      return this.api.lang.getMapSubAreaName(this._nID) + (!dofus.Constants.DEBUG ? "" : " (" + this._nID + ")");
   }
   function get color()
   {
      return dofus.Constants.AREA_ALIGNMENT_COLOR[this._oAlignment.index];
   }
   function initialize(nID, nAlignment)
   {
      this._nID = nID;
      this._oAlignment = new dofus.datacenter.Alignment(nAlignment);
   }
}
