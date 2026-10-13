class dofus.graphics.gapi.ui.PopupText extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgHidder;
   var _oParams;
   var _sValue;
   var _winBackground;
   var _xmouse;
   var _ymouse;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "PopupText";
   var _bUseAllStage = false;
   var _nMaxChars = 20;
   var _sRestrict = "a-z A-Z";
   function PopupText()
   {
      super();
   }
   function set value(sValue)
   {
      this._sValue = sValue;
   }
   function set useAllStage(bUseAllStage)
   {
      this._bUseAllStage = bUseAllStage;
   }
   function set maxChars(nMaxChars)
   {
      this._nMaxChars = nMaxChars;
   }
   function set restrict(sRestrict)
   {
      this._sRestrict = sRestrict;
   }
   function get value()
   {
      return this._sValue;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.PopupText.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function addListeners()
   {
      this._winBackground.addEventListener("complete",this);
      this._bgHidder.addEventListener("click",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initWindowContent()
   {
      var _loc2_ = this._winBackground.content;
      _loc2_._btnOk.addEventListener("click",this);
      _loc2_._tiInput.restrict = this._sRestrict;
      _loc2_._tiInput.maxChars = this._nMaxChars;
      _loc2_._tiInput.text = this._sValue;
      _loc2_._tiInput.setFocus();
   }
   function placeWindow()
   {
      var _loc2_ = this._xmouse - this._winBackground.width;
      var _loc3_ = this._ymouse - this._winBackground._height;
      var _loc4_ = !this._bUseAllStage ? this.gapi.screenWidth : Stage.width;
      var _loc5_ = !this._bUseAllStage ? this.gapi.screenHeight : Stage.height;
      if(_loc2_ < 0)
      {
         _loc2_ = 0;
      }
      if(_loc3_ < 0)
      {
         _loc3_ = 0;
      }
      if(_loc2_ > _loc4_ - this._winBackground.width)
      {
         _loc2_ = _loc4_ - this._winBackground.width;
      }
      if(_loc3_ > _loc5_ - this._winBackground.height)
      {
         _loc3_ = _loc5_ - this._winBackground.height;
      }
      this._winBackground._x = _loc2_;
      this._winBackground._y = _loc3_;
   }
   function validate()
   {
      this.api.kernel.KeyManager.removeShortcutsListener(this);
      this.dispatchEvent({type:"validate",value:this._winBackground.content._tiInput.text,params:this._oParams});
   }
   function complete(oEvent)
   {
      this.placeWindow();
      this.addToQueue({object:this,method:this.initWindowContent});
   }
   function click(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "_btnOk":
            this.validate();
            break;
         case "_bgHidder":
      }
      this.unloadThis();
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG")
      {
         this.validate();
         this.unloadThis();
         return false;
      }
      return true;
   }
}
