867880353 - 1;
class dofus.datacenter.achievements.Achievement extends dofus.utils.ApiElement
{
   var _aDescriptionsParams;
   var _aObjectives;
   var _nCategory;
   var _nFinishedTimestamp;
   var _nFinishedTimestampForSort;
   var _nID;
   var _nIconID;
   var _nScore;
   var _nTypeID;
   var _oObjectivesMap;
   var _oRewards;
   var _sCustomDescription;
   var _sDescription;
   var _sName;
   var api;
   var dispatchEvent;
   static var MONSTER_TYPES;
   var _bRewardsClaimed = true;
   function Achievement(nID)
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.initialize(nID);
   }
   function initialize(nID)
   {
      this._nID = nID;
      var _loc3_ = this.api.lang.getAchievement(nID);
      this._sName = _loc3_.n;
      this._nTypeID = _loc3_.t;
      this._nCategory = _loc3_.c;
      this._nIconID = _loc3_.i;
      this._nScore = _loc3_.s;
      this._oRewards = _loc3_.r;
      this._aObjectives = _loc3_.o;
      this._aDescriptionsParams = _loc3_.p;
      this._sCustomDescription = _loc3_.d;
      if(dofus.datacenter.achievements.Achievement.MONSTER_TYPES == undefined)
      {
         dofus.datacenter.achievements.Achievement.initMonsterTypes();
      }
   }
   static function initMonsterTypes()
   {
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES = {};
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES[1] = true;
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES[2] = true;
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES[3] = true;
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES[5] = true;
      dofus.datacenter.achievements.Achievement.MONSTER_TYPES[33] = true;
   }
   function get ID()
   {
      return this._nID;
   }
   function get typeID()
   {
      return this._nTypeID;
   }
   function get name()
   {
      if(dofus.Constants.DEBUG)
      {
         return this._sName + " (" + this._nID + ")";
      }
      return this._sName;
   }
   function get description()
   {
      if(this._sDescription != undefined)
      {
         return this._sDescription;
      }
      if(this._sCustomDescription != undefined && this._sCustomDescription.length > 0)
      {
         this._sDescription = this._sCustomDescription;
      }
      else
      {
         this._sDescription = this.api.lang.getAchievementDescription(this._nTypeID).t;
         if(this._aDescriptionsParams != undefined)
         {
            this._sDescription = dofus.managers.AchievementDescriptionManager.getDescription(this._nTypeID,this._sDescription,this._aDescriptionsParams);
         }
      }
      return this._sDescription;
   }
   function get category()
   {
      return this._nCategory;
   }
   function get isFinished()
   {
      return this._nFinishedTimestamp > -1;
   }
   function set finishedTimestamp(nFinishedTimestamp)
   {
      this._nFinishedTimestamp = nFinishedTimestamp;
      this._nFinishedTimestampForSort = nFinishedTimestamp;
      this.dispatchEvent({type:"updateFinishedState",value:this.finishedFormattedTime,state:this.getFinishedState()});
   }
   function get finishedFormattedTime()
   {
      if(!this.isFinished)
      {
         return "";
      }
      var _loc2_ = new Date(this._nFinishedTimestamp);
      return org.utils.SimpleDateFormatter.formatDate(_loc2_,this.api.lang.getConfigText("SMALL_DATE_FORMAT"),this.api.config.language);
   }
   function get iconFile()
   {
      var _loc2_ = dofus.datacenter.achievements.Achievement.MONSTER_TYPES[this._nTypeID] != true ? dofus.Constants.ACHIEVEMENTS_PATH : dofus.Constants.ACHIEVEMENTS_MONSTER_PATH;
      return _loc2_ + this._nIconID + ".swf";
   }
   function get score()
   {
      return this._nScore;
   }
   function get objectives()
   {
      if(this._oObjectivesMap == undefined)
      {
         this._oObjectivesMap = this.initObjectives();
      }
      return this._oObjectivesMap;
   }
   function get rewardsKamas()
   {
      return this._oRewards.k;
   }
   function get rewardsExperiences()
   {
      return this._oRewards.xp;
   }
   function get rewardsItems()
   {
      return this._oRewards.i;
   }
   function get rewardsTitle()
   {
      if(this._oRewards.at != undefined)
      {
         return {id:this._oRewards.at,type:0};
      }
      if(this._oRewards.ct != undefined)
      {
         return {id:this._oRewards.ct,type:1};
      }
      return undefined;
   }
   function get rewardsAvailable()
   {
      return this.isFinished && !this._bRewardsClaimed;
   }
   function get rewardsClaimed()
   {
      return this.isFinished && this._bRewardsClaimed;
   }
   function set rewardsClaimed(bRewardsClaimed)
   {
      this._bRewardsClaimed = bRewardsClaimed;
      this.dispatchEvent({type:"updateRewardsClaimed",value:bRewardsClaimed,state:this.getFinishedState()});
   }
   function get hasRewards()
   {
      return this.rewardsExperiences > 0 || (this.rewardsKamas > 0 || (this.hasItemsReward() || this.rewardsTitle != undefined));
   }
   function get objectivesCount()
   {
      return this._aObjectives.length;
   }
   function getFinishedState()
   {
      if(!this.isFinished)
      {
         return "unfinished";
      }
      return !this.rewardsClaimed ? "unclaimed" : "claimed";
   }
   function initObjectives()
   {
      var _loc2_ = {};
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aObjectives.length)
      {
         _loc4_ = this._aObjectives[_loc3_];
         _loc2_[_loc4_] = new dofus.datacenter.achievements.AchievementObjective(_loc4_,this.isFinished);
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function hasItemsReward()
   {
      for(var sID in this.rewardsItems)
      {
         return true;
         break;
      }
      return false;
   }
}
