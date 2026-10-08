class dofus.graphics.gapi.ui.AskYesNoWithString extends ank.gapi.ui.FlyWindow
{
   var _nInputMaxChars;
   var _oParams;
   var _sHelp;
   var _winBackground;
   var api;
   var dispatchEvent;
   var unloadThis;
   static var CLASS_NAME = "AskYesNoWithString";
   function AskYesNoWithString()
   {
      super();
   }
   function get params()
   {
      return this._oParams;
   }
   function set params(oParams)
   {
      this._oParams = oParams;
   }
   function get help()
   {
      return this._sHelp;
   }
   function set help(sHelp)
   {
      this._sHelp = sHelp;
   }
   function get inputMaxChars()
   {
      return this._nInputMaxChars;
   }
   function set inputMaxChars(nInputMaxChars)
   {
      this._nInputMaxChars = nInputMaxChars;
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function initWindowContent()
   {
      var _loc2_ = this._winBackground.content;
      if(this._sHelp != undefined)
      {
         _loc2_._txtHelp.text = this._sHelp;
      }
      if(this._nInputMaxChars != undefined)
      {
         _loc2_._tiString.maxChars = this._nInputMaxChars;
      }
      _loc2_._btnOk.label = this.api.lang.getText("OK");
      _loc2_._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      _loc2_._btnOk.addEventListener("click",this);
      _loc2_._btnCancel.addEventListener("click",this);
      _loc2_._tiString.setFocus();
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function click(oEvent)
   {
      var _loc3_ = this._winBackground.content._tiString.text;
      switch(oEvent.target._name)
      {
         case "_btnOk":
            this.dispatchEvent({type:"yes",params:this.params,inputText:_loc3_});
            break;
         case "_btnCancel":
            this.dispatchEvent({type:"no",params:this.params,inputText:_loc3_});
      }
      this.unloadThis();
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG")
      {
         this.click({target:this._winBackground.content._btnOk});
         return false;
      }
      return true;
   }
}
