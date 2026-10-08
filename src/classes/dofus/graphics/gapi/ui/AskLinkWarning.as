class dofus.graphics.gapi.ui.AskLinkWarning extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnOk;
   var _sText;
   var _txtText;
   var _winBackground;
   var addToQueue;
   var dispatchEvent;
   var params;
   var unloadThis;
   static var CLASS_NAME = "AskLinkWarning";
   function AskLinkWarning()
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
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.AskLinkWarning.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnOk.addEventListener("click",this);
   }
   function initTexts()
   {
      this._btnOk.label = this.api.lang.getText("OK");
      this._winBackground.title = this.api.lang.getText("CAUTION");
      this._txtText.text = this._sText;
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_btnOk")
      {
         this.dispatchEvent({type:"ok",params:this.params});
      }
      this.unloadThis();
   }
}
