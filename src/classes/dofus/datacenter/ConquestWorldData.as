class dofus.datacenter.ConquestWorldData extends Object
{
   var _aAreas;
   var _aVillages;
   var _nOwnedAreas;
   var _nOwnedVillages;
   var _nPossibleAreas;
   var _nTotalAreas;
   var _nTotalVillages;
   function ConquestWorldData()
   {
      super();
   }
   function get ownedAreas()
   {
      return this._nOwnedAreas;
   }
   function set ownedAreas(value_)
   {
      this._nOwnedAreas = value_;
   }
   function get totalAreas()
   {
      return this._nTotalAreas;
   }
   function set totalAreas(value_)
   {
      this._nTotalAreas = value_;
   }
   function get possibleAreas()
   {
      return this._nPossibleAreas;
   }
   function set possibleAreas(value_)
   {
      this._nPossibleAreas = value_;
   }
   function get areas()
   {
      return this._aAreas;
   }
   function set areas(value_)
   {
      this._aAreas = value_;
   }
   function get ownedVillages()
   {
      return this._nOwnedVillages;
   }
   function set ownedVillages(value_)
   {
      this._nOwnedVillages = value_;
   }
   function get totalVillages()
   {
      return this._nTotalVillages;
   }
   function set totalVillages(value_)
   {
      this._nTotalVillages = value_;
   }
   function get villages()
   {
      return this._aVillages;
   }
   function set villages(value_)
   {
      this._aVillages = value_;
   }
}
