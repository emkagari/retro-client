class dofus.graphics.gapi.ui.customset.CustomSetEdit extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnDelete;
   var _btnSave;
   var _cgGrid;
   var _eaIcons;
   var _itName;
   var _lblIcon;
   var _lblName;
   var _nIcon;
   var _nIconID;
   var _oRapidStuff;
   var _winBg;
   var addToQueue;
   var api;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "CustomSetEdit";
   static var NAME_MIN_CHARS = 3;
   static var NAME_MAX_CHARS = 20;
   function CustomSetEdit()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.customset.CustomSetEdit.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function set rapidStuff(oRapidStuff)
   {
      this._oRapidStuff = oRapidStuff;
      this._nIcon = oRapidStuff.iconID;
      this._nIconID = oRapidStuff.iconID != 0 ? oRapidStuff.iconID : undefined;
   }
   function get rapidStuff()
   {
      return this._oRapidStuff;
   }
   function set icon(nIcon)
   {
      this._nIcon = nIcon;
   }
   function get icon()
   {
      return this._nIcon;
   }
   function createChildren()
   {
      this._eaIcons = new ank.utils.ExtendedArray();
      var _loc2_ = 1;
      while(_loc2_ <= dofus.Constants.CUSTOM_SET_ICONS_COUNT)
      {
         this._eaIcons.push({iconID:_loc2_,iconFile:dofus.Constants.CUSTOM_SET_ICONS + _loc2_ + ".swf"});
         _loc2_ = _loc2_ + 1;
      }
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("CUSTOM_SET_EDIT");
      this._lblName.text = this.api.lang.getText("NAME_BIG");
      this._lblIcon.text = this.api.lang.getText("ICON");
      this._btnDelete.label = this.api.lang.getText("DELETE_WORD");
      this._btnSave.label = this.api.lang.getText("VALIDATE");
      this._itName.text = this._oRapidStuff.name;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnDelete.addEventListener("click",this);
      this._btnSave.addEventListener("click",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("dblClickItem",this);
      this._cgGrid.multipleContainerSelectionEnabled = false;
   }
   function initData()
   {
      this._btnDelete.enabled = !this._oRapidStuff.isEmptyRapidStuff;
      this._cgGrid.dataProvider = this._eaIcons;
      if(this._nIconID == undefined)
      {
         this._nIconID = 1;
      }
      this._cgGrid.selectedIndex = this._nIconID - 1;
      this._itName.restrict = "\\-a-zA-Z0-9_.!?:;, ";
      this._itName.maxChars = dofus.graphics.gapi.ui.customset.CustomSetEdit.NAME_MAX_CHARS;
      this.setTextFocus();
   }
   function setTextFocus()
   {
      this._itName.setFocus();
   }
   function editSet(nIcon)
   {
      var _loc3_ = this._itName.text;
      if(_loc3_.length < dofus.graphics.gapi.ui.customset.CustomSetEdit.NAME_MIN_CHARS || _loc3_.length > dofus.graphics.gapi.ui.customset.CustomSetEdit.NAME_MAX_CHARS)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_INVALID_NAME"),"ERROR_BOX");
         return undefined;
      }
      if(this._nIconID == undefined)
      {
         return undefined;
      }
      if(this._oRapidStuff.isEmptyRapidStuff)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_SAVED",[_loc3_]),"INFO_CHAT");
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_EDITED",[_loc3_]),"INFO_CHAT");
      }
      this.api.network.RapidStuff.editRapidStuff(this._oRapidStuff.id,this._nIconID,_loc3_);
      this.callClose();
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_btnClose":
            this.callClose();
            break;
         case "_btnSave":
            this.editSet(this._nIconID);
            break;
         case "_btnDelete":
            _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoDeleteCustomSet",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CONFIRM_DELETE_CUSTOM_SET",[this._oRapidStuff.name])});
            _loc3_.addEventListener("yes",this);
         default:
            return;
      }
   }
   function selectItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_;
      if(_loc3_.contentData == undefined || !_loc3_.contentLoaded)
      {
         this._cgGrid.selectedIndex = this._cgGrid.lastLoadedContentIndex;
         _loc4_ = this._cgGrid.selectedContentData;
      }
      else
      {
         _loc4_ = _loc3_.contentData;
      }
      var _loc5_ = _loc4_.iconID;
      this._nIconID = _loc5_;
   }
   function dblClickItem(oEvent)
   {
      this.selectItem(oEvent);
      this.editSet(this._nIconID);
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoDeleteCustomSet")
      {
         this.api.network.RapidStuff.deleteRapidStuff(this._oRapidStuff.id);
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_DELETED",[this._oRapidStuff.name]),"INFO_CHAT");
         this.callClose();
      }
   }
}
