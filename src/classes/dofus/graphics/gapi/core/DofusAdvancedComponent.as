class dofus.graphics.gapi.core.DofusAdvancedComponent extends ank.gapi.core.UIAdvancedComponent
{
   function DofusAdvancedComponent()
   {
      super();
   }
   function get api()
   {
      return _global.API;
   }
   function set api(a)
   {
      super.api = a;
   }
   function init(bDontHideBoundingBox, sClassName)
   {
      super.init(bDontHideBoundingBox,sClassName);
   }
}
