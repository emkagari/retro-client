class dofus.graphics.gapi.ui.ChooseItemSkin extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgh;
   var _btnClose;
   var _btnValid;
   var _cisItem;
   var _oItem;
   var _win;
   var addToQueue;
   var api;
   var gapi;
   var initialized;
   var unloadThis;
   static var CLASS_NAME = "ChooseItemSkin";
   function ChooseItemSkin()
   {
      super();
   }
   function set item(oItem)
   {
      this._oItem = oItem;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function get item()
   {
      return this._oItem;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ChooseItemSkin.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnValid.addEventListener("click",this);
   }
   function updateData()
   {
      this._cisItem.item = this._oItem;
   }
   function initTexts()
   {
      this._btnValid.label = this.api.lang.getText("VALIDATE");
      this._win.title = this.api.lang.getText("CHOOSE_SKIN");
   }
   function validate(oItem)
   {
      if(!oItem)
      {
         return undefined;
      }
      this.api.kernel.SpeakingItemsManager.triggerPrivateEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CHANGE_SKIN);
      this.api.network.Items.setSkin(this._oItem.ID,this._oItem.position,oItem.skin + 1);
      this.callClose();
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._bgh:
         case this._btnClose:
            this.callClose();
            break;
         case this._btnValid:
            this.validate(this._cisItem.selectedItem);
         default:
            return;
      }
   }
   function dblClickItem(oEvent)
   {
      this.validate(oEvent.target.contentData);
   }
}
