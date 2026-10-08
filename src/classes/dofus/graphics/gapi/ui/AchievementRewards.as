996643632 - 1;
class dofus.graphics.gapi.ui.AchievementRewards extends dofus.graphics.gapi.core.MovableComponent
{
   var _btnAchievementRewards;
   var _btnClose;
   var _srDrag;
   var _x;
   var _y;
   var addToQueue;
   var api;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "AchievementRewards";
   function AchievementRewards()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.AchievementRewards.CLASS_NAME);
   }
   function createChildren()
   {
      this.bindDragHandle(this._srDrag);
      var _loc2_ = this.api.datacenter.Basics.achievementButton_position;
      if(_loc2_.y != undefined)
      {
         this._x = _loc2_.x;
         this._y = _loc2_.y;
      }
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnAchievementRewards.addEventListener("click",this);
   }
   function savePositionAndClose()
   {
      this.api.datacenter.Basics.achievementButton_position = {x:this._x,y:this._y};
      this.unloadThis();
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.savePositionAndClose();
            break;
         case this._btnAchievementRewards:
            this.api.sounds.events.onBannerRoundButtonClick();
            this.gapi.loadUIComponent("AchievementRewardsViewer","AchievementRewardsViewer");
         default:
            return;
      }
   }
}
