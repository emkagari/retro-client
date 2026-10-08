class dofus.graphics.gapi.ui.AskOkWait extends ank.gapi.ui.FlyWindow
{
   var _nInterval;
   var _nWaitClosureDuration;
   var _sText;
   var _winBackground;
   var api;
   var dispatchEvent;
   var unloadThis;
   static var CLASS_NAME = "AskOkWait";
   function AskOkWait()
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
      return true;
   }
   function initWindowContent()
   {
      this._nWaitClosureDuration = 5;
      var _loc2_ = this._winBackground.content;
      var _loc3_ = _loc2_._btnOk;
      _loc3_.enabled = false;
      _loc3_.label = this.api.lang.getText("OK") + " (" + this._nWaitClosureDuration + ")";
      _loc3_.addEventListener("click",this);
      _loc2_._txtText.addEventListener("change",this);
      _loc2_._txtText.text = this._sText;
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this.startTimer();
   }
   function click(oEvent)
   {
      this.api.kernel.KeyManager.removeShortcutsListener(this);
      this.dispatchEvent({type:"ok"});
      this.unloadThis();
   }
   function change(oEvent)
   {
      var _loc3_ = this._winBackground.content;
      _loc3_._btnOk._y = _loc3_._txtText._y + _loc3_._txtText.height + 20;
      this._winBackground.setPreferedSize();
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG" && this._winBackground.content._btnOk.enabled)
      {
         Selection.setFocus();
         this.click();
      }
      return false;
   }
   function startTimer()
   {
      this.stopTimer();
      this._nInterval = _global.setInterval(this,"updateTimer",1000);
   }
   function stopTimer()
   {
      _global.clearInterval(this._nInterval);
   }
   function updateTimer()
   {
      this._nWaitClosureDuration -= 1;
      var _loc2_ = this._winBackground.content._btnOk;
      _loc2_.label = this.api.lang.getText("OK") + " (" + this._nWaitClosureDuration + ")";
      if(this._nWaitClosureDuration == 0)
      {
         _loc2_.label = this.api.lang.getText("OK");
         _loc2_.enabled = true;
         this.stopTimer();
      }
   }
}
