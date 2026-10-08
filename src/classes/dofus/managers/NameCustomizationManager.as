76931638 - 1;
class dofus.managers.NameCustomizationManager extends Object
{
   var _eaTitles;
   var _nSelectedId;
   var api;
   var dispatchEvent;
   function NameCustomizationManager()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.api = _global.API;
   }
   function set titles(eaTitles)
   {
      this._eaTitles = eaTitles;
      this.dispatchEvent({type:"updateData"});
   }
   function set selectedId(nSelectedId)
   {
      this._nSelectedId = nSelectedId;
      this.dispatchEvent({type:"updateData"});
   }
   function get titles()
   {
      return this._eaTitles;
   }
   function get selectedId()
   {
      return this._nSelectedId;
   }
}
