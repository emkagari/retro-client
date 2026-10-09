class dofus.graphics.gapi.ui.AskCancel extends ank.gapi.ui.FlyWindow
{
   var _sText;
   var _winBackground;
   var api;
   var dispatchEvent;
   var params;
   var unloadThis;
   static var CLASS_NAME = "AskCancel";
   function AskCancel()
   {
      super();
   }
   function set text(sText)
   {
      this._sText = sText;
   }
   function get text()
   {
      return this._sText;
   }
   function callClose()
   {
      this.dispatchEvent({type:"cancel",params:this.params});
      this.unloadThis();
      return true;
   }
   function initWindowContent()
   {
      var _loc2_ = this._winBackground.content;
      _loc2_._txtText.text = this._sText;
      _loc2_._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      _loc2_._btnCancel.addEventListener("click",this);
      _loc2_._txtText.addEventListener("change",this);
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_btnCancel")
      {
         this.dispatchEvent({type:"cancel",params:this.params});
      }
      this.unloadThis();
   }
   function change(oEvent)
   {
      var _loc3_ = this._winBackground.content;
      _loc3_._btnCancel._y = _loc3_._txtText._y + _loc3_._txtText.height + 20;
      this._winBackground.setPreferedSize();
   }
}
