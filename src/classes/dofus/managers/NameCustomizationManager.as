987652468 - 1;
class dofus.managers.NameCustomizationManager extends Object
{
   var _eaTitles;
   var _aOrnaments;
   var _nSelectedOrnament;
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
   function setOrnaments(nSelected, aIds)
   {
      this._nSelectedOrnament = nSelected;
      this._aOrnaments = aIds;
      this.dispatchEvent({type:"updateOrnaments"});
   }
   function get ornaments()
   {
      return this._aOrnaments;
   }
   function get selectedOrnament()
   {
      return this._nSelectedOrnament;
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
