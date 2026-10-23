class dofus.aks.Achievements extends dofus.aks.Handler
{
   var addToQueue;
   var aks;
   var api;
   function Achievements(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function askAchievementReward(sAchievementIDs)
   {
      this.aks.send("jR" + sAchievementIDs);
   }
   function onScoreUpdate(sExtraData)
   {
      this.api.datacenter.Player.achievementScore = Number(sExtraData);
   }
   function onInitialize(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      while(_loc5_ < _loc3_.length)
      {
         _loc6_ = _loc3_[_loc5_].split(";");
         _loc7_ = _loc6_[0];
         _loc8_ = Number(_loc6_[1]);
         _loc9_ = _loc6_[2] == "1";
         _loc10_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc7_);
         if(_loc8_ > -1)
         {
            _loc10_.finishedTimestamp = _loc8_;
            _loc10_.rewardsClaimed = _loc9_;
            if(_loc10_.rewardsAvailable)
            {
               _loc4_ = _loc4_ + 1;
            }
         }
         else
         {
            _loc11_ = _loc6_[3].split(",");
            _loc12_ = 0;
            while(_loc12_ < _loc11_.length)
            {
               _loc13_ = _loc11_[_loc12_].split(":");
               _loc14_ = _loc13_[0];
               _loc15_ = Number(_loc13_[1]);
               _loc16_ = _loc10_.objectives[_loc14_];
               if(_loc16_ != undefined)
               {
                  _loc16_.progression = _loc15_;
               }
               _loc12_ = _loc12_ + 1;
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      if(_loc4_ > 0)
      {
         this.api.datacenter.Player.Achievements.addRewardsCounter(_loc4_);
         if(this.api.kernel.OptionsManager.getOption("DisplayAchievementButton"))
         {
            this.addToQueue({object:this.api.ui,method:this.api.ui.loadUIComponent,params:["AchievementRewards","AchievementRewards",{_visible:false},{bStayIfPresent:true}]});
         }
      }
   }
   function onObjectiveProgress(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc3_[0]);
      var _loc5_ = _loc4_.objectives[_loc3_[1]];
      var _loc6_ = Number(_loc3_[2]);
      if(_loc5_ != undefined)
      {
         _loc5_.progression = _loc6_;
      }
   }
   function onAchievementCompleted(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = _loc3_[0];
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc4_);
      _loc6_.finishedTimestamp = _loc5_;
      this.api.datacenter.Player.Achievements.notifyAchievementCompleted(_loc6_);
   }
   function onAchievementRewardState(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1] == "1";
      var _loc6_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc4_);
      _loc6_.rewardsClaimed = _loc5_;
      if(_loc6_.rewardsAvailable)
      {
         this.api.datacenter.Player.Achievements.addRewardsCounter(1);
      }
      else if(_loc6_.hasRewards)
      {
         this.api.datacenter.Player.Achievements.substractRewardsCounter(1);
      }
      if(this.api.datacenter.Player.Achievements.achievementsWithRewardsAvailable && this.api.kernel.OptionsManager.getOption("DisplayAchievementButton"))
      {
         this.api.ui.loadUIComponent("AchievementRewards","AchievementRewards",undefined,{bStayIfPresent:true});
      }
      else
      {
         this.api.ui.getUIComponent("AchievementRewards").savePositionAndClose();
         this.api.ui.unloadUIComponent("AchievementRewardsViewer");
      }
      var _loc7_;
      if(_loc5_)
      {
         _loc7_ = dofus.graphics.gapi.ui.AchievementRewardsViewer(this.api.ui.getUIComponent("AchievementRewardsViewer"));
         if(_loc7_ != undefined)
         {
            _loc7_.removeAchievement(_loc6_.ID);
         }
      }
   }
}
