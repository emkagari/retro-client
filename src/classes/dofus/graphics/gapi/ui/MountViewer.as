class dofus.graphics.gapi.ui.MountViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _mvMountViewer;
   var _oMount;
   var addToQueue;
   var api;
   var gapi;
   var initialized;
   var unloadThis;
   static var CLASS_NAME = "MountViewer";
   function MountViewer()
   {
      super();
   }
   function set mount(oMount)
   {
      this._oMount = oMount;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function get mount()
   {
      return this._oMount;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MountViewer.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
   }
   function updateData()
   {
      this._mvMountViewer.mount = this._oMount;
   }
   function initTexts()
   {
      this._btnClose.label = this.api.lang.getText("CLOSE");
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnClose)
      {
         this.callClose();
      }
   }
}
