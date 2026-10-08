class dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter extends ank.gapi.core.UIBasicComponent
{
   var api;
   function UIBasicFilter()
   {
      super();
   }
   function init()
   {
      this.api = _global.API;
      mx.events.EventDispatcher.initialize(this);
      super.init(false);
   }
   function get data()
   {
      return undefined;
   }
   function reset()
   {
   }
   function close()
   {
   }
}
