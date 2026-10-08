class dofus.datacenter.Storage extends Object
{
   var _eaInventory;
   var _nKamas;
   var dispatchEvent;
   var _bLocalOwner = false;
   var _bLocked = false;
   function Storage()
   {
      super();
      this.initialize();
   }
   function set localOwner(bLocalOwner)
   {
      this._bLocalOwner = bLocalOwner;
   }
   function get localOwner()
   {
      return this._bLocalOwner;
   }
   function set isLocked(bLocked)
   {
      this._bLocked = bLocked;
      this.dispatchEvent({type:"locked",value:bLocked});
   }
   function get isLocked()
   {
      return this._bLocked;
   }
   function set inventory(eaInventory)
   {
      this._eaInventory = eaInventory;
      this.dispatchEvent({type:"modelChanged"});
   }
   function get inventory()
   {
      return this._eaInventory;
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
   function initialize()
   {
      mx.events.EventDispatcher.initialize(this);
   }
}
