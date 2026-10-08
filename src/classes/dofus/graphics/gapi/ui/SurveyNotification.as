class dofus.graphics.gapi.ui.SurveyNotification extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btn;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "SurveyNotification";
   function SurveyNotification()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.SurveyNotification.CLASS_NAME);
   }
   function hide()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btn.addEventListener("click",this);
      this._btn.addEventListener("over",this);
   }
   function click(oEvent)
   {
      this.api.network.Survey.getSurvey();
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btn)
      {
         this.api.ui.showTooltip(this.api.lang.getText("SURVEY"));
      }
   }
}
