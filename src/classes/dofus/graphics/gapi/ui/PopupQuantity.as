class dofus.graphics.gapi.ui.PopupQuantity extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgHidder;
   var _oParams;
   var _winBackground;
   var _xmouse;
   var _ymouse;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "PopupQuantity";
   var _nValue = 0;
   var _bUseAllStage = false;
   var _nMax = 1;
   var _nMin = 1;
   var _bMaxButtonValidationEnabled = true;
   function PopupQuantity()
   {
      super();
   }
   function set value(nValue)
   {
      this._nValue = nValue;
      var _loc3_ = this._winBackground.content;
      _loc3_._tiInput.text = nValue;
      _loc3_._tiInput.setFocus();
   }
   function get value()
   {
      return this._nValue;
   }
   function set max(nMax)
   {
      if(nMax == undefined || nMax < this._nMin)
      {
         this._nMax = this._nMin;
      }
      else
      {
         this._nMax = nMax;
      }
   }
   function set min(nMin)
   {
      this._nMin = nMin;
   }
   function set useAllStage(bUseAllStage)
   {
      this._bUseAllStage = bUseAllStage;
   }
   function get isMaxButtonValidationEnabled()
   {
      return this._bMaxButtonValidationEnabled;
   }
   function set isMaxButtonValidationEnabled(bMaxButtonValidationEnabled)
   {
      this._bMaxButtonValidationEnabled = bMaxButtonValidationEnabled;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.PopupQuantity.CLASS_NAME);
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
      _loc2_._btnMax.addEventListener("click",this);
      _loc2_._btnMin.addEventListener("click",this);
      _loc2_._btnMax.label = this.api.lang.getText("MAX_WORD");
      _loc2_._btnMin.label = this.api.lang.getText("MIN_WORD");
      _loc2_._tiInput.restrict = "0-9";
      _loc2_._tiInput.text = this._nValue;
      _loc2_._tiInput.addEventListener("change",this);
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
      this.dispatchEvent({type:"validate",value:this.value,params:this._oParams});
   }
   function change(oEvent)
   {
      var _loc3_ = this._winBackground.content;
      var _loc4_ = Number(_loc3_._tiInput.text);
      if(_global.isNaN(_loc4_))
      {
         this.value = this._nMin;
      }
      else if(_loc4_ > this._nMax)
      {
         this.value = this._nMax;
      }
      else if(_loc4_ < this._nMin)
      {
         this.value = this._nMin;
      }
      else
      {
         this._nValue = _loc4_;
      }
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
         case "_btnMax":
            if(this._bMaxButtonValidationEnabled && this.value == this._nMax)
            {
               this.validate();
               break;
            }
            this.value = this._nMax;
            return undefined;
            break;
         case "_bgHidder":
         case "_btnMin":
            this.value = this._nMin;
            return undefined;
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
