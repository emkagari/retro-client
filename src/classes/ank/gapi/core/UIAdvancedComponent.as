class ank.gapi.core.UIAdvancedComponent extends ank.gapi.core.UIBasicComponent
{
   var _oAPI;
   var _parent;
   var _sInstanceName;
   var gapi;
   function UIAdvancedComponent()
   {
      super();
   }
   function set api(oAPI)
   {
      this._oAPI = oAPI;
   }
   function get api()
   {
      if(this._oAPI == undefined)
      {
         return this._parent.api;
      }
      return this._oAPI;
   }
   function set instanceName(sInstanceName)
   {
      this._sInstanceName = sInstanceName;
   }
   function get instanceName()
   {
      return this._sInstanceName;
   }
   function callClose()
   {
      return false;
   }
   function unloadThis()
   {
      this.gapi.unloadUIComponent(this._sInstanceName);
   }
}
