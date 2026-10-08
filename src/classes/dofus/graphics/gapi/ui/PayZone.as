class dofus.graphics.gapi.ui.PayZone extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnInfos;
   var _nDialogID;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "PayZone";
   function PayZone()
   {
      super();
   }
   function set dialogID(nDialogID)
   {
      this._nDialogID = nDialogID;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.PayZone.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      if(this.api.datacenter.Basics.payzone_isFirst)
      {
         this.gapi.loadUIComponent("PayZoneDialog2","PayZoneDialog2",{name:"El Pemy",gfx:"9059",dialogID:this._nDialogID});
      }
   }
   function addListeners()
   {
      this._btnInfos.addEventListener("click",this);
   }
   function click(oEvent)
   {
      this.gapi.loadUIComponent("PayZoneDialog2","PayZoneDialog2",{name:"El Pemy",gfx:"9059",dialogID:this._nDialogID});
   }
}
