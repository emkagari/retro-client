class dofus.graphics.gapi.ui.achievements.AchievementSynthesisItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblName;
   var _lblProgress;
   var _ldrIcon;
   var _mcMask;
   var _mcSynthesis;
   var _oAchievementCategory;
   var _pb;
   var addToQueue;
   function AchievementSynthesisItem()
   {
      super();
   }
   function set data(oAchievementCategory)
   {
      this._oAchievementCategory = oAchievementCategory;
   }
   function set progressPercentage(nPercentage)
   {
      this.updateProgress(nPercentage);
   }
   function set synthesisComponent(mcSynthesis)
   {
      this._mcSynthesis = mcSynthesis;
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
      this._ldrIcon.addEventListener("click",this);
      this._oAchievementCategory.addEventListener("updateCompletion",this);
   }
   function initTexts()
   {
      this._lblName.text = this._oAchievementCategory.name;
      this._lblProgress.text = this._oAchievementCategory.completionPercent + "%";
   }
   function initData()
   {
      this._pb.styleName = "AchievementProgressBarCategory" + this._oAchievementCategory.ID;
      this._ldrIcon.contentPath = dofus.Constants.ACHIEVEMENTS_ARTWORK_PATH + this._oAchievementCategory.ID + ".swf";
      this._pb.value = this._oAchievementCategory.completionPercent;
      this._lblName.filters = [new flash.filters.GlowFilter(5327422,1,4,4,1,2)];
      this._mcMask.filters = [new flash.filters.DropShadowFilter(2,90,5327422,1,4,4,0.7,2,true,false,true)];
   }
   function updateProgress(nPercentage)
   {
      this._lblProgress.text = nPercentage + "%";
      this._pb.value = nPercentage;
   }
   function click(oEvent_)
   {
      this.api.ui.getUIComponent("Achievements").selectCategory(this._oAchievementCategory.ID);
   }
   function updateCompletion(oEvent_)
   {
      this.updateProgress(this._oAchievementCategory.completionPercent);
      this._mcSynthesis.updateTotalProgress();
   }
}
