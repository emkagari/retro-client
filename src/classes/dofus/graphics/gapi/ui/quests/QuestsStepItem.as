class dofus.graphics.gapi.ui.quests.QuestsStepItem extends ank.gapi.core.UIBasicComponent
{
   var _lblName;
   var _mcArrow;
   var _mcCheckFinished;
   var _mcList;
   var _oItem;
   function QuestsStepItem()
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
         this._lblName.text = oItem.name;
         this._lblName.styleName = !oItem.isFinished ? "BrownLeftSmallLabel" : "GreyLeftSmallLabel";
         this._mcCheckFinished._visible = oItem.isFinished;
         this._mcArrow._visible = oItem.isCurrent;
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._mcCheckFinished._visible = false;
         this._mcArrow._visible = false;
      }
   }
   function init()
   {
      super.init(false);
      this._mcArrow._visible = false;
      this._mcCheckFinished._visible = false;
   }
}
