class dofus.datacenter.SurveyManager
{
   var eaQuestions;
   var nId;
   var sDate;
   var sDesc;
   var sTitle;
   function SurveyManager()
   {
   }
   function set id(nSurveyId)
   {
      this.nId = nSurveyId;
   }
   function set title(sText)
   {
      this.sTitle = sText;
   }
   function set desc(sText_)
   {
      this.sDesc = sText_;
   }
   function set date(sText)
   {
      this.sDate = sText;
   }
   function get id()
   {
      return this.nId;
   }
   function get title()
   {
      return this.sTitle;
   }
   function get desc()
   {
      return this.sDesc;
   }
   function get date()
   {
      return this.sDate;
   }
   function set questions(eaData)
   {
      this.eaQuestions = eaData;
   }
   function get questions()
   {
      return this.eaQuestions;
   }
   function resetAllAnswers()
   {
      var _loc2_ = 0;
      while(_loc2_ < this.eaQuestions.length)
      {
         this.eaQuestions[_loc2_].answerSelected = 0;
         _loc2_ = _loc2_ + 1;
      }
      this.eaQuestions.dispatchEvent({type:"modelChanged"});
   }
   function setAnswer(questionId, answerId)
   {
      this.eaQuestions[questionId].answerSelected = answerId;
      this.eaQuestions.dispatchEvent({type:"modelChanged"});
   }
   function getAnswersPacket()
   {
      var _loc2_ = "" + this.nId;
      var _loc3_ = 0;
      while(_loc3_ < this.eaQuestions.length)
      {
         _loc2_ += "|" + _loc3_ + ";" + this.eaQuestions[_loc3_].answerSelected;
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
}
