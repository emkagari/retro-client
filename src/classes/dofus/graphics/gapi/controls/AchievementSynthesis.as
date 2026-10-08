class dofus.graphics.gapi.controls.AchievementSynthesis extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aData;
   var _mcBigItem;
   var _mcPlacer;
   var _mcSynthesisItems;
   var addToQueue;
   var createEmptyMovieClip;
   var getNextHighestDepth;
   static var CLASS_NAME = "AchievementSynthesis";
   static var NB_COLUMNS = 2;
   static var Y_OFFSET = 7;
   static var X_OFFSET = 13;
   function AchievementSynthesis()
   {
      super();
   }
   function set data(aValues)
   {
      this._aData = aValues;
      this.addToQueue({object:this,method:this.modelChanged});
   }
   function updateTotalProgress()
   {
      this._mcBigItem.progressPercentage = this.getTotalProgress();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.AchievementSynthesis.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
   }
   function modelChanged()
   {
      if(this._mcSynthesisItems != undefined)
      {
         this._mcSynthesisItems.removeMovieClip();
      }
      this._mcSynthesisItems = this.createEmptyMovieClip("_mcSynthesisItems",this.getNextHighestDepth());
      this._mcSynthesisItems._x = this._mcPlacer._x;
      this._mcSynthesisItems._y = this._mcPlacer._y;
      var _loc3_ = 0;
      var _loc4_;
      var _loc2_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < this._aData.length)
      {
         _loc4_ = this._aData[_loc3_];
         _loc2_ = this._mcSynthesisItems.attachMovie("AchievementSynthesisItem","SynthesisItem_" + _loc3_,this._mcSynthesisItems.getNextHighestDepth(),{data:_loc4_,synthesisComponent:this});
         _loc5_ = _loc3_ % dofus.graphics.gapi.controls.AchievementSynthesis.NB_COLUMNS;
         _loc6_ = Math.floor(_loc3_ / dofus.graphics.gapi.controls.AchievementSynthesis.NB_COLUMNS);
         _loc2_._x = _loc5_ * (_loc2_._width + dofus.graphics.gapi.controls.AchievementSynthesis.X_OFFSET);
         _loc2_._y = _loc6_ * (_loc2_._height + dofus.graphics.gapi.controls.AchievementSynthesis.Y_OFFSET);
         _loc3_ = _loc3_ + 1;
      }
   }
   function initData()
   {
      this._mcBigItem.data = {ID:dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY,name:this.api.lang.getText("PROGRESS"),completionPercent:this.getTotalProgress()};
   }
   function getTotalProgress()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._aData.length)
      {
         _loc5_ = this._aData[_loc4_];
         _loc2_ += _loc5_.achievementsCount;
         _loc3_ += _loc5_.finishedAchievementsCount;
         _loc4_ = _loc4_ + 1;
      }
      if(_loc2_ == 0)
      {
         return 0;
      }
      return Math.floor(100 * _loc3_ / _loc2_);
   }
}
