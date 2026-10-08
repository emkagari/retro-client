class dofus.graphics.gapi.controls.questionviewer.QuestionViewerAnswerItem extends ank.gapi.core.UIBasicComponent
{
   var _mcRound;
   var _txtResponse;
   function QuestionViewerAnswerItem()
   {
      super();
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_;
      if(bUsed)
      {
         this._mcRound._visible = true;
         _loc5_ = oItem.label;
         if(dofus.Constants.DEBUG)
         {
            _loc5_ = _loc5_ + " (" + oItem.id + ")";
         }
         this._txtResponse.text = _loc5_;
      }
      else if(this._txtResponse.text != undefined)
      {
         this._mcRound._visible = false;
         this._txtResponse.text = "";
      }
   }
   function init()
   {
      super.init(false);
      this._mcRound._visible = false;
   }
   function size()
   {
      super.size();
   }
}
