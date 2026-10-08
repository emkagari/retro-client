class dofus.graphics.gapi.ui.WaitingMessage extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblBlackBL;
   var _lblBlackBR;
   var _lblBlackTL;
   var _lblBlackTR;
   var _lblWhite;
   var addToQueue;
   static var CLASS_NAME = "WaitingMessage";
   var _sText = "";
   function WaitingMessage()
   {
      super();
   }
   function set text(sText)
   {
      this._sText = sText;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.WaitingMessage.CLASS_NAME);
   }
   function createChildren()
   {
      if(this._sText.length == 0)
      {
         return undefined;
      }
      this.addToQueue({object:this,method:this.initText});
   }
   function initText()
   {
      this._lblWhite.text = this._lblBlackTL.text = this._lblBlackTR.text = this._lblBlackBL.text = this._lblBlackBR.text = this._sText;
   }
}
