class dofus.datacenter.achievements.AchievementObjective extends dofus.utils.ApiElement
{
   var _bIsCountType;
   var _bIsFinished;
   var _nID;
   var _nType;
   var _oParameters;
   var _sCustomDescription;
   var _sDescription;
   var api;
   var dispatchEvent;
   static var OBJECTIVES_TYPE_NEEDS_DETAILS;
   static var ACHIEVEMENT_OF_ACHIEVEMENTS_TYPE_ID = 4;
   var _nProgression = 0;
   function AchievementObjective(nID, bIsFinished)
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.initialize(nID,bIsFinished);
   }
   function initialize(nID, bIsFinished)
   {
      this._nID = nID;
      var _loc4_ = this.api.lang.getAchievementObjective(nID);
      this._nType = _loc4_.t;
      this._oParameters = _loc4_.p;
      this._bIsCountType = this.api.lang.getAchievementDescription(this._nType).c;
      this._bIsFinished = bIsFinished;
      this._sCustomDescription = _loc4_.n;
      if(dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS == undefined)
      {
         dofus.datacenter.achievements.AchievementObjective.initTypesDetails();
      }
   }
   static function initTypesDetails()
   {
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS = {};
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[10] = true;
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[12] = true;
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[16] = true;
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[26] = true;
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[31] = true;
      dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[32] = true;
   }
   function get ID()
   {
      return this._nID;
   }
   function get description()
   {
      if(this._sDescription != undefined)
      {
         return !dofus.Constants.DEBUG ? this._sDescription : this._sDescription + " (" + this._nID + ")";
      }
      if(this._sCustomDescription != undefined && this._sCustomDescription.length > 0)
      {
         this._sDescription = this._sCustomDescription;
      }
      else
      {
         this._sDescription = dofus.managers.AchievementObjectiveManager.getObjectiveName(this._nType,this._oParameters);
      }
      return !dofus.Constants.DEBUG ? this._sDescription : this._sDescription + " (" + this._nID + ")";
   }
   function get isFinished()
   {
      return this._bIsFinished;
   }
   function set isFinished(bIsFinished)
   {
      if(this._bIsFinished == bIsFinished)
      {
         return;
      }
      this._bIsFinished = bIsFinished;
      this.dispatchEvent({type:"updateFinishedState",value:bIsFinished});
   }
   function get progression()
   {
      return this._nProgression;
   }
   function set progression(nProgression)
   {
      if(this._nProgression == nProgression)
      {
         return;
      }
      this._nProgression = nProgression;
      this.dispatchEvent({type:"updateProgression",value:nProgression});
      dofus.managers.AchievementObjectiveManager.updateFinishedState(this);
   }
   function get type()
   {
      return this._nType;
   }
   function get parameters()
   {
      return this._oParameters;
   }
   function get achievementID()
   {
      if(this._nType != dofus.datacenter.achievements.AchievementObjective.ACHIEVEMENT_OF_ACHIEVEMENTS_TYPE_ID)
      {
         return -1;
      }
      return this._oParameters.achievement;
   }
   function get isCountType()
   {
      var _loc2_ = false;
      if(this._bIsCountType)
      {
         for(var key in this._oParameters)
         {
            if(key == "count" || key == "points")
            {
               _loc2_ = true;
               break;
            }
         }
      }
      return _loc2_;
   }
   function get needsDetails()
   {
      return dofus.datacenter.achievements.AchievementObjective.OBJECTIVES_TYPE_NEEDS_DETAILS[this._nType];
   }
}
