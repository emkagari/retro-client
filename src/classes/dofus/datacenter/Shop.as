class dofus.datacenter.Shop extends Object
{
   var _eaInventory;
   var _sGfx;
   var _sID;
   var _sName;
   var dispatchEvent;
   function Shop()
   {
      super();
      this.initialize();
   }
   function set id(sID)
   {
      this._sID = sID;
   }
   function get id()
   {
      return this._sID;
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function get name()
   {
      return this._sName;
   }
   function set gfx(sGfx)
   {
      this._sGfx = sGfx;
   }
   function get gfx()
   {
      return this._sGfx;
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
