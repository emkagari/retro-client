class dofus.graphics.gapi.ui.nmr.ModReportObjectItem extends ank.gapi.core.UIBasicComponent
{
   var _lblReporterName;
   var _lblScore;
   var _ldrCurrentState;
   var _ldrHasChatConversationIcon;
   var _ldrHasCustomNoteIcon;
   var _mcList;
   var _oItem;
   function ModReportObjectItem()
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
         this._lblReporterName.text = oItem.reporterName;
         this._lblScore.text = String(oItem.score);
         if(oItem.hasChatConversation)
         {
            this._ldrHasChatConversationIcon.contentPath = "UI_QuestsBubble";
         }
         else
         {
            this._ldrHasChatConversationIcon.contentPath = "";
         }
         if(oItem.hasCustomNote)
         {
            this._ldrHasCustomNoteIcon.contentPath = "Edit";
         }
         else
         {
            this._ldrHasCustomNoteIcon.contentPath = "";
         }
         switch(oItem.currentState)
         {
            case dofus.datacenter.modreport.ModReportStates.STATE_CONFIRMED:
               this._ldrCurrentState.contentPath = "NewValid";
               break;
            case dofus.datacenter.modreport.ModReportStates.STATE_INVALID:
               this._ldrCurrentState.contentPath = "NewCross";
               break;
            case dofus.datacenter.modreport.ModReportStates.STATE_STUDYING:
               this._ldrCurrentState.contentPath = "Loupe";
               break;
            case dofus.datacenter.modreport.ModReportStates.STATE_PENDING:
            case dofus.datacenter.modreport.ModReportStates.STATE_IGNORED:
               this._ldrCurrentState.contentPath = "";
         }
      }
      else if(this._lblReporterName.text != undefined)
      {
         this._lblReporterName.text = "";
         this._lblScore.text = "";
         this._ldrCurrentState.contentPath = "";
         this._ldrHasChatConversationIcon.contentPath = "";
         this._ldrHasCustomNoteIcon.contentPath = "";
      }
   }
   function init()
   {
      super.init(false);
   }
}
