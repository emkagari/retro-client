class dofus.datacenter.evenemential.WorldUniqueDropState
{
   var _bDropped;
   var _nItemGenericID;
   function WorldUniqueDropState(nItemGenericID, bDropped)
   {
      this._nItemGenericID = nItemGenericID;
      this._bDropped = bDropped;
   }
   function get itemGenericID()
   {
      return this._nItemGenericID;
   }
   function get dropped()
   {
      return this._bDropped;
   }
}
