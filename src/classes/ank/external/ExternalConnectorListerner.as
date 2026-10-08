class ank.external.ExternalConnectorListerner
{
   var _oParams;
   var dispatchEvent;
   function ExternalConnectorListerner()
   {
      mx.events.EventDispatcher.initialize(this);
      ank.external.ExternalConnector.getInstance().addEventListener("onExternalConnectionFaild",this);
   }
   function getParams()
   {
      return this._oParams;
   }
   function setParams(oParams)
   {
      this._oParams = oParams;
   }
   function removeListeners()
   {
      ank.external.ExternalConnector.getInstance().removeEventListener("onExternalConnectionFaild",this);
   }
   function onExternalConnectionFaild(oEvent)
   {
      this.dispatchEvent({type:"onExternalError"});
   }
}
