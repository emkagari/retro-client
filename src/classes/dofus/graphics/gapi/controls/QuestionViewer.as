class dofus.graphics.gapi.controls.QuestionViewer extends ank.gapi.core.UIBasicComponent
{
   var _bFirstQuestion;
   var _lstResponses;
   var _oQuestion;
   var _parent;
   var _txtQuestion;
   var addToQueue;
   var dispatchEvent;
   var getStyle;
   var setSize;
   static var CLASS_NAME = "QuestionViewer";
   static var RESPONSE_HEIGHT = 30;
   static var QUESTION_RESPONSE_SPACE = 20;
   function QuestionViewer()
   {
      super();
   }
   function set question(oQuestion)
   {
      this._oQuestion = oQuestion;
      this.addToQueue({object:this,method:this.layoutContent});
   }
   function set isFirstQuestion(bFirstQuestion)
   {
      this._bFirstQuestion = bFirstQuestion;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.QuestionViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this._lstResponses._visible = false;
      this.addToQueue({object:this,method:this.addListeners});
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
   }
   function layoutContent()
   {
      var _loc2_;
      var _loc3_;
      if(this._bFirstQuestion)
      {
         _loc2_ = this._oQuestion.responses;
      }
      else if(this._oQuestion.responses.length == 0)
      {
         _loc3_ = new ank.utils.ExtendedArray();
         _loc3_.push({label:this._parent.api.lang.getText("CONTINUE_TO_SPEAK"),id:-1});
         _loc2_ = _loc3_;
      }
      else
      {
         _loc2_ = this._oQuestion.responses;
      }
      var _loc4_ = _loc2_.length;
      this._lstResponses.removeAll();
      this._lstResponses.setSize(undefined,dofus.graphics.gapi.controls.QuestionViewer.RESPONSE_HEIGHT * _loc4_);
      this.addToQueue({object:this,method:this.addResponses,params:[_loc2_]});
      this._txtQuestion.text = this._oQuestion.label;
   }
   function addListeners()
   {
      this._lstResponses.addEventListener("itemSelected",this);
      this._txtQuestion.addEventListener("change",this);
   }
   function addResponses(eaResp)
   {
      this._lstResponses.dataProvider = eaResp;
   }
   function change(oEvent)
   {
      this._lstResponses._y = this._txtQuestion._y + dofus.graphics.gapi.controls.QuestionViewer.QUESTION_RESPONSE_SPACE + this._txtQuestion.height;
      this._lstResponses._visible = true;
      this.setSize(undefined,this._lstResponses._y + this._lstResponses.height);
      this.dispatchEvent({type:"resize"});
   }
   function itemSelected(oEvent)
   {
      this.dispatchEvent({type:"response",response:oEvent.row.item});
   }
}
