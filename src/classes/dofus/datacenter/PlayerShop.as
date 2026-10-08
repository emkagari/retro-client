class dofus.datacenter.PlayerShop extends Object
{
   var _eaInventory;
   var dispatchEvent;
   function PlayerShop()
   {
      super();
      this.initialize();
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
   function initialize()
   {
      mx.events.EventDispatcher.initialize(this);
   }
}
