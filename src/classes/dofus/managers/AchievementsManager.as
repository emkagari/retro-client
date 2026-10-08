class dofus.managers.AchievementsManager extends dofus.utils.ApiElement
{
   var _eoAchievements;
   var _nAchievementWithRewardsAvailableCount;
   var _oAchievementIDsByCategory;
   var _playerManager;
   var dispatchEvent;
   static var ACHIEVEMENT_SOUND_COOLDOWN = 1000;
   var _nLastAchievementSoundTime = 0;
   function AchievementsManager(playerManager, oAPI)
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.initialize(playerManager,oAPI);
   }
   function initialize(playerManager, oAPI)
   {
      super.initialize(oAPI);
      this._playerManager = playerManager;
      this._eoAchievements = new ank.utils.ExtendedObject();
      this._nAchievementWithRewardsAvailableCount = 0;
   }
   function getOrInitAchievement(sID)
   {
      var _loc3_ = dofus.datacenter.achievements.Achievement(this._eoAchievements.getItemAt(sID));
      if(_loc3_ != undefined)
      {
         return _loc3_;
      }
      _loc3_ = new dofus.datacenter.achievements.Achievement(Number(sID));
      this._eoAchievements.addItemAt(sID,_loc3_);
      return _loc3_;
   }
   function getAchievementsByCategory(nCategoryID_, bHideCompletedAchievements)
   {
      return this.getAchievementsList(nCategoryID_,bHideCompletedAchievements);
   }
   function getAllParentsCategories()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getAchievementsCategories();
      for(var k in _loc3_)
      {
         if(_loc3_[k].p == -1)
         {
            _loc2_.push(new dofus.datacenter.achievements.AchievementCategory(Number(k)));
         }
      }
      _loc2_.sort(Array.DESCENDING);
      return _loc2_;
   }
   function getSubcategories(nCategoryID_)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this.api.lang.getAchievementCategory(nCategoryID_).s;
      _loc4_.sort();
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc3_.push(new dofus.datacenter.achievements.AchievementCategory(_loc6_));
         _loc5_ = _loc5_ + 1;
      }
      return _loc3_;
   }
   function getCategoryDatas(aCategoriesID)
   {
      this.buildStaticIndexIfNeeded();
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc5_ < aCategoriesID.length)
      {
         _loc6_ = String(aCategoriesID[_loc5_]);
         _loc7_ = this._oAchievementIDsByCategory[_loc6_];
         if(_loc7_ != undefined)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc9_ = _loc7_[_loc8_];
               _loc3_ = _loc3_ + 1;
               _loc10_ = dofus.datacenter.achievements.Achievement(this._eoAchievements.getItemAt(_loc9_));
               if(_loc10_ != undefined && _loc10_.isFinished)
               {
                  _loc4_ = _loc4_ + 1;
               }
               _loc8_ = _loc8_ + 1;
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      if(_loc3_ == 0)
      {
         return {total:0,finished:0,percentage:0};
      }
      var _loc11_ = Math.floor(100 * _loc4_ / _loc3_);
      return {total:_loc3_,finished:_loc4_,percentage:_loc11_};
   }
   function notifyAchievementCompleted(oAchievement)
   {
      var _loc3_ = oAchievement.category;
      var _loc4_ = this.api.lang.getAchievementCategory(_loc3_).p;
      this.dispatchEvent({type:"achievementCompleted",categoryID:_loc3_,parentCategoryID:_loc4_,achievement:oAchievement});
      var _loc5_;
      if(oAchievement.isFinished)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ACHIEVEMENT_COMPLETED",["<b><a href=\"asfunction:onHref,viewAchievement," + oAchievement.ID + "\">[" + oAchievement.name + "]</a></b>"]),"INFO_CHAT");
         if(this.api.kernel.OptionsManager.getOption("AchievementSound"))
         {
            _loc5_ = getTimer();
            if(_loc5_ - this._nLastAchievementSoundTime >= dofus.managers.AchievementsManager.ACHIEVEMENT_SOUND_COOLDOWN)
            {
               this._nLastAchievementSoundTime = _loc5_;
               this.api.sounds.events.onChatGameEvent();
            }
         }
         this.api.electron.makeNotification(this.api.lang.getText("ACHIEVEMENT_COMPLETED",[oAchievement.name]));
      }
   }
   function getAchievementsWithRewardsAvailable()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this._eoAchievements.getItems();
      var _loc4_;
      for(var sID in _loc3_)
      {
         _loc4_ = _loc3_[sID];
         if(_loc4_.rewardsAvailable)
         {
            _loc2_.push(_loc4_);
         }
      }
      _loc2_.sortOn("_nFinishedTimestampForSort",Array.NUMERIC | Array.DESCENDING);
      return _loc2_;
   }
   function addRewardsCounter(nQty)
   {
      this._nAchievementWithRewardsAvailableCount += nQty;
   }
   function substractRewardsCounter(nQty)
   {
      this._nAchievementWithRewardsAvailableCount -= nQty;
      if(this._nAchievementWithRewardsAvailableCount < 0)
      {
         this._nAchievementWithRewardsAvailableCount = 0;
      }
   }
   function get achievementsWithRewardsAvailable()
   {
      return this._nAchievementWithRewardsAvailableCount > 0;
   }
   function getAchievementsList(nCategoryID_, bHideCompletedAchievements)
   {
      this.buildStaticIndexIfNeeded();
      var _loc4_ = this._oAchievementIDsByCategory[String(nCategoryID_)];
      if(_loc4_ == undefined)
      {
         return [];
      }
      var _loc5_ = [];
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_];
         _loc8_ = dofus.datacenter.achievements.Achievement(this._eoAchievements.getItemAt(_loc7_));
         if(_loc8_ == undefined)
         {
            _loc8_ = new dofus.datacenter.achievements.Achievement(Number(_loc7_));
            this._eoAchievements.addItemAt(_loc7_,_loc8_);
            _loc5_.push(_loc8_);
         }
         else if(!(bHideCompletedAchievements && _loc8_.isFinished))
         {
            _loc5_.push(_loc8_);
         }
         _loc6_ = _loc6_ + 1;
      }
      return _loc5_;
   }
   function buildStaticIndexIfNeeded()
   {
      if(this._oAchievementIDsByCategory != undefined)
      {
         return undefined;
      }
      this._oAchievementIDsByCategory = {};
      var _loc2_ = this.api.lang.getAchievements();
      var _loc3_;
      var _loc4_;
      for(var sID in _loc2_)
      {
         _loc3_ = Number(_loc2_[sID].c);
         _loc4_ = String(_loc3_);
         if(this._oAchievementIDsByCategory[_loc4_] == undefined)
         {
            this._oAchievementIDsByCategory[_loc4_] = [];
         }
         this._oAchievementIDsByCategory[_loc4_].push(sID);
      }
      for(var k in this._oAchievementIDsByCategory)
      {
         this._oAchievementIDsByCategory[k].reverse();
      }
   }
}
