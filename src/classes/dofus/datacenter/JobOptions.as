class dofus.datacenter.JobOptions extends Object
{
   var _nMaxSlot;
   var _nMinSlot;
   var _nParams;
   function JobOptions(nParams, nMinSlot, nMaxSlot)
   {
      super();
      this._nParams = nParams;
      this._nMinSlot = nMinSlot <= 1 ? 2 : nMinSlot;
      this._nMaxSlot = nMaxSlot;
   }
   function get isNotFree()
   {
      return (this._nParams & 1) == 1;
   }
   function get isFreeIfFailed()
   {
      return (this._nParams & 2) == 2;
   }
   function get minSlots()
   {
      return this._nMinSlot;
   }
   function get maxSlots()
   {
      return this._nMaxSlot;
   }
}
