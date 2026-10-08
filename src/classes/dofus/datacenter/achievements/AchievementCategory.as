class dofus.datacenter.achievements.AchievementCategory extends dofus.utils.ApiElement
{
   var _aSubcategories;
   var _nAchievementsCount;
   var _nCompletionPercent;
   var _nFinishedAchievementsCount;
   var _nID;
   var _nIconID;
   var _nParentCategory;
   var _sName;
   var api;
   var dispatchEvent;
   function AchievementCategory(nID)
   {
      super();
      mx.events.EventDispatcher.initialize(this);
      this.initialize(nID);
   }
   function initialize(nID)
   {
      this._nID = nID;
      var _loc3_ = this.api.lang.getAchievementCategory(nID);
      this._sName = _loc3_.n;
      this._nParentCategory = _loc3_.p;
      this._nIconID = _loc3_.i;
      this._aSubcategories = _loc3_.s;
      this.refresh();
   }
   function get ID()
   {
      return this._nID;
   }
   function get name()
   {
      if(dofus.Constants.DEBUG)
      {
         return this._sName + " (" + this._nID + ")";
      }
      return this._sName;
   }
   function get subCategories()
   {
      return this._aSubcategories;
   }
   function get isSubcategory()
   {
      return this._nParentCategory != -1;
   }
   function get hasSubcategories()
   {
      return this._aSubcategories.length > 0;
   }
   function get parentCategory()
   {
      return this._nParentCategory;
   }
   function get iconFile()
   {
      if(this.isSubcategory)
      {
         return dofus.Constants.ACHIEVEMENTS_CATEGORY_PATH + "-1.swf";
      }
      return dofus.Constants.ACHIEVEMENTS_CATEGORY_PATH + this._nIconID + ".swf";
   }
   function get completionPercent()
   {
      return this._nCompletionPercent;
   }
   function get achievementsCount()
   {
      return this._nAchievementsCount;
   }
   function get finishedAchievementsCount()
   {
      return this._nFinishedAchievementsCount;
   }
   function refresh()
   {
      this.refreshCompletionPercent();
      this.dispatchEvent({type:"updateCompletion",percentage:this._nCompletionPercent,total:this._nAchievementsCount,finished:this._nFinishedAchievementsCount});
   }
   function refreshCompletionPercent()
   {
      var _loc2_ = this.api.datacenter.Player.Achievements.getCategoryDatas(!this.hasSubcategories ? [this._nID] : this._aSubcategories);
      this._nCompletionPercent = _loc2_.percentage;
      this._nAchievementsCount = _loc2_.total;
      this._nFinishedAchievementsCount = _loc2_.finished;
   }
}
