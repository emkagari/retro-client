class dofus.graphics.gapi.ui.Survey extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnReset;
   var _btnSave;
   var _lblDate;
   var _lblTitle;
   var _lstQuestions;
   var _txtDescription;
   var _winBackground;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "Survey";
   function Survey()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Survey.CLASS_NAME);
   }
   function callClose()
   {
      this.api.datacenter.Survey.questions = new ank.utils.ExtendedArray();
      this.refreshQuestions();
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("SURVEY");
      this._btnSave.label = this.api.lang.getText("SAVE_SURVEY");
      this._btnReset.label = this.api.lang.getText("RESET_SURVEY");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnReset.addEventListener("click",this);
      this._btnSave.addEventListener("click",this);
      this.api.datacenter.Survey.questions.addEventListener("modelChanged",this);
      this._lstQuestions.addEventListener("itemSelected",this);
      ank.utils.MouseEvents.addListener(this);
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Survey;
      this._lblTitle.text = _loc2_.title;
      this._txtDescription.text = _loc2_.desc;
      this._lblDate.text = _loc2_.date;
      this.refreshQuestions();
   }
   function refreshQuestions()
   {
      var _loc2_ = this.api.datacenter.Survey;
      this._lstQuestions.dataProvider = _loc2_.questions;
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnReset:
            this.api.datacenter.Survey.resetAllAnswers();
            break;
         case this._btnSave:
            _loc3_ = this.api.datacenter.Survey.getAnswersPacket();
            this.api.network.Survey.saveSurvey(_loc3_);
            this.callClose();
         default:
            return;
      }
   }
   function modelChanged(oEvent)
   {
      this.refreshQuestions();
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target.list) === this._lstQuestions)
      {
         this.api.datacenter.Survey.setAnswer(oEvent.id,oEvent.selectedIndex);
      }
   }
}
