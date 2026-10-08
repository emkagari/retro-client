class dofus.graphics.gapi.ui.achievements.AchievementObjectiveProgressBarItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblDescription;
   var _nMaxValue;
   var _oAchievementObjective;
   var _pbProgress;
   var addToQueue;
   function AchievementObjectiveProgressBarItem()
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
      this._oAchievementObjective.addEventListener("updateProgression",this);
      this._oAchievementObjective.addEventListener("updateFinishedState",this);
   }
   function initTexts()
   {
      var _loc2_ = this._oAchievementObjective.parameters.count;
      this._nMaxValue = _loc2_ == undefined ? this._oAchievementObjective.parameters.points : _loc2_;
   }
   function initData()
   {
      this._pbProgress.maximum = this._nMaxValue;
      this._pbProgress.value = !this._oAchievementObjective.isFinished ? this._oAchievementObjective.progression : this._nMaxValue;
      this.updateName();
   }
   function updateName()
   {
      var _loc2_ = this._pbProgress.value;
      var _loc3_ = "";
      if(this._oAchievementObjective.needsDetails)
      {
         _loc3_ = " - " + this._oAchievementObjective.description;
      }
      else if(dofus.Constants.DEBUG)
      {
         _loc3_ = " (" + this._oAchievementObjective.ID + ")";
      }
      this._lblDescription.text = _loc2_ + "/" + this._nMaxValue + _loc3_;
   }
   function updateProgression(oEvent_)
   {
      var _loc3_ = oEvent_.value;
      this._pbProgress.value = _loc3_;
      this.updateName();
   }
   function updateFinishedState(oEvent_)
   {
      var _loc3_ = oEvent_.value;
      var _loc4_;
      if(_loc3_)
      {
         this._pbProgress.value = this._nMaxValue;
         this.updateName();
      }
      else
      {
         _loc4_ = this._oAchievementObjective.progression;
         this._pbProgress.value = _loc4_;
         this.updateName();
      }
   }
}
