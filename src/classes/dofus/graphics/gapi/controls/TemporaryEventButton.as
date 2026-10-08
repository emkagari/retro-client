class dofus.graphics.gapi.controls.TemporaryEventButton extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _nEventID;
   var _txtTitle;
   var _visible;
   var addToQueue;
   var gotoAndStop;
   static var CLASS_NAME = "TemporaryEventButton";
   function TemporaryEventButton()
   {
      super();
   }
   function set eventID(nEventID)
   {
      this._nEventID = nEventID;
      this.updateVisuals();
      this.updateTexts();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.TemporaryEventButton.CLASS_NAME);
      this._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this.api.datacenter.Basics.addEventListener("updateTemporaryEvent",this);
   }
   function updateTexts()
   {
      this._txtTitle.text = this.api.lang.getText("TEMPORARY_EVENT_" + this._nEventID);
   }
   function updateVisuals()
   {
      this._visible = this._nEventID > 0;
      this.gotoAndStop(this._nEventID);
   }
   function updateTemporaryEvent(oEvent_)
   {
      this.eventID = oEvent_.value;
   }
}
