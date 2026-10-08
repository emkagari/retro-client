class dofus.graphics.gapi.ui.quests.QuestsObjectiveItem extends ank.gapi.core.UIBasicComponent
{
   var _mcCheckFinished;
   var _mcCompass;
   var _mcList;
   var _oItem;
   var _txtDescription;
   function QuestsObjectiveItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = oItem;
         this._txtDescription.text = oItem.description;
         this._txtDescription.styleName = !oItem.isFinished ? "BrownLeftSmallTextArea" : "GreyLeftSmallTextArea";
         this._mcCheckFinished._visible = oItem.isFinished;
         this._mcCompass._visible = oItem.x != undefined && oItem.y != undefined && !oItem.isFinished;
      }
      else if(this._txtDescription.text != undefined)
      {
         this._txtDescription.text = "";
         this._mcCheckFinished._visible = false;
         this._mcCompass._visible = false;
      }
   }
   function init()
   {
      super.init(false);
      this._mcCheckFinished._visible = false;
      this._mcCompass._visible = false;
   }
}
