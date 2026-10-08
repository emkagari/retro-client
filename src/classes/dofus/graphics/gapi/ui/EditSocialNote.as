class dofus.graphics.gapi.ui.EditSocialNote extends ank.gapi.ui.FlyWindow
{
   var _winBackground;
   var api;
   var dispatchEvent;
   var gapi;
   var getStyle;
   var params;
   var unloadThis;
   static var CLASS_NAME = "EditSocialNote";
   static var ALLOWED_CHARACTERS = "a-zA-Z0-9!?_ ÑñÓóÍíÚúÁáàâäéèêëîïôöùûüÿçæœÀÂÄÇÉÈÊËÎÏÔÖÙÛÜŸŒÆÃãÕõẞß";
   function EditSocialNote()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.EditSocialNote.CLASS_NAME);
      this.gapi.getUIComponent("Banner").chatAutoFocus = false;
   }
   function destroy()
   {
      this.gapi.getUIComponent("Banner").chatAutoFocus = true;
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
   }
   function initWindowContent()
   {
      var _loc2_ = this._winBackground.content;
      _loc2_._txtNote.maxChars = 50;
      _loc2_._txtNote.restrict = dofus.graphics.gapi.ui.EditSocialNote.ALLOWED_CHARACTERS;
      if(this.params.note != undefined)
      {
         _loc2_._txtNote.text = this.params.note;
      }
      _loc2_._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      _loc2_._btnSave.label = this.api.lang.getText("SAVE");
      _loc2_._btnCancel.addEventListener("click",this);
      _loc2_._btnSave.addEventListener("click",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      Selection.setFocus(_loc2_._txtNote._tText);
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG")
      {
         this.click({target:this._winBackground.content._btnSave});
         return false;
      }
      if(sShortcut == "NEXTTURN")
      {
         return false;
      }
      return true;
   }
   function click(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target._name)
      {
         case "_btnCancel":
            this.dispatchEvent({type:"cancel",params:this.params});
            this.unloadThis();
            break;
         case "_btnSave":
            _loc3_ = this._winBackground.content._txtNote.text;
            _loc3_ = new ank.utils.ExtendedString(_loc3_).replace(String.fromCharCode(13)," ");
            this.dispatchEvent({type:"save",text:_loc3_,params:this.params});
            this.unloadThis();
         default:
            return;
      }
   }
}
