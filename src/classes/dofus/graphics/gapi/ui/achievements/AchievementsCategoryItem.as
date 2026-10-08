298068507 - 1;
class dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem extends ank.gapi.core.UIBasicComponent
{
   var _bAlreadyShifted;
   var _bIsSubcategory;
   var _lblName;
   var _lblProgression;
   var _ldrIcon;
   var _mcList;
   var _oItem;
   var addToQueue;
   static var X_OFFSET = 16;
   function AchievementsCategoryItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function get api()
   {
      return this._mcList.gapi.api;
   }
   function setValue(bUsed, sSuggested, oItem_)
   {
      if(bUsed)
      {
         this._oItem = oItem_;
         this._lblName.text = this.getName();
         this._lblProgression.text = this.getPercent();
         this._ldrIcon.contentPath = oItem_.iconFile;
         this._bIsSubcategory = oItem_.isSubcategory;
         if(this._bIsSubcategory && !this._bAlreadyShifted)
         {
            this._ldrIcon._x += dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._lblName._x += dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._lblName.width -= dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._bAlreadyShifted = true;
         }
         else if(!this._bIsSubcategory && this._bAlreadyShifted)
         {
            this._ldrIcon._x -= dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._lblName._x -= dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._lblName.width += dofus.graphics.gapi.ui.achievements.AchievementsCategoryItem.X_OFFSET;
            this._bAlreadyShifted = false;
         }
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblProgression.text = "";
         this._ldrIcon.contentPath = "";
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
   }
   function getPercent()
   {
      return this._oItem.ID != dofus.graphics.gapi.ui.Achievements.SYNTHESIS_CATEGORY ? this._oItem.completionPercent + "%" : "";
   }
   function getName()
   {
      var _loc2_ = this._oItem.name;
      var _loc3_ = "";
      if(this._oItem.hasSubcategories)
      {
         if(this._oItem.ID == this.api.ui.getUIComponent("Achievements").currentParentID)
         {
            _loc3_ = " (-)";
         }
         else
         {
            _loc3_ = " (+)";
         }
      }
      return _loc2_.concat(_loc3_);
   }
   function over(oEvent_)
   {
   }
   function out(oEvent_)
   {
      this._mcList.gapi.hideTooltip();
   }
}
