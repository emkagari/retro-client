class dofus.graphics.gapi.ui.quests.QuestsQuestItem extends ank.gapi.core.UIBasicComponent
{
   var _lblName;
   var _mcCheckFinished;
   var _mcCurrent;
   var _mcCurrentAccount;
   var _mcCurrentRepeatable;
   var _mcCurrentRepeatableAccount;
   var _mcList;
   var _oItem;
   function QuestsQuestItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      this.hideQuestState();
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblName.text = oItem.name;
         if(oItem.isFinished)
         {
            this._mcCheckFinished._visible = true;
         }
         else if(oItem.isAccountQuest)
         {
            if(oItem.isRepeatableQuest)
            {
               this._mcCurrentRepeatableAccount._visible = true;
            }
            else
            {
               this._mcCurrentAccount._visible = true;
            }
         }
         else if(oItem.isRepeatableQuest)
         {
            this._mcCurrentRepeatable._visible = true;
         }
         else
         {
            this._mcCurrent._visible = true;
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this.hideQuestState();
      }
   }
   function init()
   {
      super.init(false);
   }
   function hideQuestState()
   {
      this._mcCurrent._visible = false;
      this._mcCheckFinished._visible = false;
      this._mcCurrentAccount._visible = false;
      this._mcCurrentRepeatable._visible = false;
      this._mcCurrentRepeatableAccount._visible = false;
   }
}
