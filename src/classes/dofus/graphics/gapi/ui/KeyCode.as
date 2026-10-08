class dofus.graphics.gapi.ui.KeyCode extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnNoCode;
   var _btnResetCode;
   var _btnValidate;
   var _mcSlotPlacer;
   var _mcSlots;
   var _nChangeType;
   var _nLockType;
   var _nSlotsCount;
   var _txtDescription;
   var _winCode;
   var addToQueue;
   var createEmptyMovieClip;
   var gapi;
   static var CLASS_NAME = "KeyCode";
   static var CODE_SLOT_WIDTH = 40;
   var _aKeyCode = [];
   var _nCurrentSelectedSlot = 0;
   function KeyCode()
   {
      super();
   }
   function set title(sTitle)
   {
      this.addToQueue({object:this,method:function()
      {
         this._winCode.title = sTitle;
      }});
   }
   function set changeType(nChangeType)
   {
      this._nChangeType = nChangeType;
   }
   function set slotsCount(nSlotsCount)
   {
      if(nSlotsCount > 8)
      {
         ank.utils.Logger.err("[slotsCount] doit être au max 8");
         return;
      }
      this._nSlotsCount = nSlotsCount;
      this.resetKeyCode();
   }
   function set lockType(nLockType)
   {
      this._nLockType = nLockType;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.KeyCode.CLASS_NAME);
      this.gapi.getUIComponent("Banner").chatAutoFocus = false;
   }
   function destroy()
   {
      this.gapi.getUIComponent("Banner").chatAutoFocus = true;
   }
   function callClose()
   {
      this.api.network.Key.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.drawCodeSlots();
      this.resetKeyCode();
      this._mcSlotPlacer._visible = false;
      this._btnNoCode._visible = false;
   }
   function addListeners()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 10)
      {
         _loc3_ = this["_ctrSymbol" + _loc2_];
         _loc3_.addEventListener("drag",this);
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("dblClick",this);
         _loc3_.params = {index:_loc2_};
         _loc2_ = _loc2_ + 1;
      }
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this.api.kernel.KeyManager.addKeysListener("onKeys",this);
      this._btnValidate.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._btnResetCode.addEventListener("click",this);
      this._btnNoCode.addEventListener("click",this);
   }
   function initTexts()
   {
      switch(this._nChangeType)
      {
         case 0:
            this._btnValidate.label = this.api.lang.getText("UNLOCK");
            this._txtDescription.text = this.api.lang.getText("UNLOCK_INFOS");
            break;
         case 1:
            this._btnValidate.label = this.api.lang.getText("CHANGE");
            this._btnNoCode.label = this.api.lang.getText("NO_CODE");
            this._txtDescription.text = this.api.lang.getText("LOCK_INFOS");
         default:
            return;
      }
   }
   function initData()
   {
      var _loc2_ = 0;
      while(_loc2_ < 10)
      {
         this["_ctrSymbol" + _loc2_].contentData = {iconFile:"UI_KeyCodeSymbol" + _loc2_,value:String(_loc2_)};
         _loc2_ = _loc2_ + 1;
      }
      switch(this._nChangeType)
      {
         case 0:
            this._btnNoCode._visible = false;
            break;
         case 1:
            this._btnNoCode._visible = true;
      }
      switch(this._nLockType)
      {
         case 0:
            this._btnNoCode.enabled = true;
            break;
         case 1:
            this._btnNoCode.enabled = false;
         default:
            return;
      }
   }
   function drawCodeSlots()
   {
      this._mcSlots.removeMovieClip();
      this.createEmptyMovieClip("_mcSlots",10);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._nSlotsCount)
      {
         _loc3_ = this._mcSlots.attachMovie("Container","_ctrCode" + _loc2_,_loc2_,{_x:_loc2_ * dofus.graphics.gapi.ui.KeyCode.CODE_SLOT_WIDTH,backgroundRenderer:"UI_KeyCodeContainer",dragAndDrop:true,highlightRenderer:"UI_KeyCodeHighlight",styleName:"none",enabled:true,_width:30,_height:30});
         _loc3_.addEventListener("drop",this);
         _loc3_.addEventListener("drag",this);
         _loc3_.params = {index:_loc2_};
         _loc2_ = _loc2_ + 1;
      }
      this._mcSlots._x = this._mcSlotPlacer._x - this._mcSlots._width;
      this._mcSlots._y = this._mcSlotPlacer._y;
   }
   function selectPreviousSlot()
   {
      var _loc2_ = this._nCurrentSelectedSlot;
      this._nCurrentSelectedSlot = this._nCurrentSelectedSlot - 1;
      if(this._nCurrentSelectedSlot < 0)
      {
         this._nCurrentSelectedSlot = this._nSlotsCount - 1;
      }
      this.selectSlot(_loc2_,this._nCurrentSelectedSlot);
   }
   function selectNextSlot()
   {
      var _loc2_ = this._nCurrentSelectedSlot;
      this._nCurrentSelectedSlot = ++this._nCurrentSelectedSlot % this._nSlotsCount;
      this.selectSlot(_loc2_,this._nCurrentSelectedSlot);
   }
   function selectSlot(nLastSlotID, nSlotID)
   {
      var _loc4_ = this._mcSlots["_ctrCode" + nLastSlotID];
      _loc4_.selected = false;
      this._mcSlots["_ctrCode" + nSlotID].selected = true;
   }
   function setKeyInCurrentSlot(nKey)
   {
      var _loc3_ = this._mcSlots["_ctrCode" + this._nCurrentSelectedSlot];
      var _loc4_ = this["_ctrSymbol" + nKey];
      if(nKey != undefined)
      {
         _loc3_.contentData = _loc4_.contentData;
         this._aKeyCode[this._nCurrentSelectedSlot] = nKey;
      }
      else
      {
         _loc3_.contentData = undefined;
         this._aKeyCode[this._nCurrentSelectedSlot] = "_";
      }
      this.selectNextSlot();
   }
   function resetKeyCode()
   {
      this._aKeyCode = [];
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._nSlotsCount)
      {
         _loc3_ = this._mcSlots["_ctrCode" + _loc2_];
         _loc3_.contentData = "_";
         this._aKeyCode[_loc2_] = "_";
         _loc2_ = _loc2_ + 1;
      }
      this.selectSlot(this._nCurrentSelectedSlot,0);
      this._nCurrentSelectedSlot = 0;
   }
   function validate()
   {
      var _loc2_ = true;
      var _loc3_ = 0;
      while(_loc3_ < this._aKeyCode.length)
      {
         if(this._aKeyCode[_loc3_] != "_")
         {
            _loc2_ = false;
         }
         _loc3_ = _loc3_ + 1;
      }
      this.api.network.Key.sendKey(this._nChangeType,!_loc2_ ? this._aKeyCode.join("") : "-");
   }
   function dblClick(oEvent)
   {
      this.click(oEvent);
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnValidate:
            this.validate();
            return;
         case this._btnClose:
            this.callClose();
            return;
         case this._btnResetCode:
            this.resetKeyCode();
            return;
         case this._btnNoCode:
            this.api.network.Key.sendKey(this._nChangeType,"-");
            return;
         default:
            this.setKeyInCurrentSlot(oEvent.target.params.index);
            return;
      }
   }
   function drop(oEvent)
   {
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      oEvent.target.contentData = _loc3_;
      this._aKeyCode[oEvent.target.params.index] = _loc3_.value;
   }
   function drag(oEvent)
   {
      this.gapi.removeCursor();
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this.gapi.setCursor(_loc3_);
      if(oEvent.target._parent != this)
      {
         oEvent.target.contentData = undefined;
         this._aKeyCode[oEvent.target.params.index] = "_";
      }
   }
   function onShortcut(sShortcut)
   {
      if(Selection.getFocus() != null)
      {
         return true;
      }
      if(sShortcut == "CODE_CLEAR")
      {
         this.setKeyInCurrentSlot();
         return false;
      }
      if(sShortcut == "CODE_NEXT")
      {
         this.selectNextSlot();
         return false;
      }
      if(sShortcut == "CODE_PREVIOUS")
      {
         this.selectPreviousSlot();
         return false;
      }
      if(sShortcut == "ACCEPT_CURRENT_DIALOG")
      {
         this.validate();
         return false;
      }
      return true;
   }
   function onKeys(sKey)
   {
      if(Selection.getFocus() != null)
      {
         return undefined;
      }
      var _loc3_ = sKey.charCodeAt(0) - 48;
      if(_loc3_ < 0 || _loc3_ > 9)
      {
         return undefined;
      }
      this.setKeyInCurrentSlot(_loc3_);
   }
}
