class dofus.graphics.gapi.ui.achievements.AchievementObjectiveCheckboxItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnObjectiveState;
   var _oAchievementObjective;
   var _txtDescription;
   var addToQueue;
   function AchievementObjectiveCheckboxItem()
   {
      super();
   }
   function set data(oAchievementObjective)
   {
      this._oAchievementObjective = oAchievementObjective;
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._txtDescription.addEventListener("href",this);
      this._oAchievementObjective.addEventListener("updateFinishedState",this);
   }
   function initTexts()
   {
      var _loc2_ = this._oAchievementObjective.description;
      if(this._oAchievementObjective.type == dofus.datacenter.achievements.AchievementObjective.ACHIEVEMENT_OF_ACHIEVEMENTS_TYPE_ID)
      {
         _loc2_ += " (<u><a href=\"asfunction:onHref,viewAchievement," + this._oAchievementObjective.achievementID + "\">" + this.api.lang.getText("VIEW") + "</a></u>)";
      }
      this._txtDescription.text = _loc2_;
   }
   function initData()
   {
      this.setComponentsFinishedState(this._oAchievementObjective.isFinished);
   }
   function setComponentsFinishedState(bIsFinished)
   {
      this._btnObjectiveState.selected = bIsFinished;
      this._txtDescription._alpha = !bIsFinished ? 100 : 50;
   }
   function href(oEvent_)
   {
      this.api.ui.getUIComponent("Chat").href(oEvent_);
   }
   function updateFinishedState(oEvent_)
   {
      this.setComponentsFinishedState(oEvent_.value);
   }
}
