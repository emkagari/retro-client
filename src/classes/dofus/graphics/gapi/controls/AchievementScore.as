class dofus.graphics.gapi.controls.AchievementScore extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _txtScore;
   var addToQueue;
   static var CLASS_NAME = "AchievementScore";
   function AchievementScore()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.AchievementScore.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this.api.datacenter.Player.addEventListener("achievementScoreChanged",this);
   }
   function initTexts()
   {
      this._txtScore.text = String(this.api.datacenter.Player.achievementScore);
   }
   function size()
   {
   }
   function achievementScoreChanged(oEvent_)
   {
      this._txtScore.text = oEvent_.value;
   }
}
