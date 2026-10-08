class dofus.datacenter.TaxCollectorStorage extends dofus.datacenter.Shop
{
   var _nKamas;
   var dispatchEvent;
   function TaxCollectorStorage()
   {
      super();
      this.initialize();
   }
   function set Kama(nKamas)
   {
      this._nKamas = nKamas;
      this.dispatchEvent({type:"kamaChanged",value:nKamas});
   }
   function get Kama()
   {
      return this._nKamas;
   }
}
