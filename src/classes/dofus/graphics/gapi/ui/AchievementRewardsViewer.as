class dofus.graphics.gapi.ui.AchievementRewardsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgWindow;
   var _btnClose;
   var _btnGetAll;
   var _lblRemaining;
   var _lstAchievements;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "AchievementRewardsViewer";
   function AchievementRewardsViewer()
   {
      super();
   }
   function refreshRewardList()
   {
      this.initData();
   }
   function removeAchievement(nAchievementID)
   {
      var _loc3_ = this._lstAchievements.dataProvider;
      var _loc5_ = 0;
      var _loc6_;
      var _loc4_;
      while(_loc5_ < _loc3_.length)
      {
         _loc6_ = _loc3_[_loc5_];
         if(_loc6_.ID == nAchievementID)
         {
            _loc4_ = _loc5_;
            break;
         }
         _loc5_ = _loc5_ + 1;
      }
      if(_loc4_ != undefined)
      {
         this._lstAchievements.removeItemAt(_loc4_);
         this.updateLabel();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.AchievementRewardsViewer.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function initTexts()
   {
      this._bgWindow.title = this.api.lang.getText("UNCLAIMED_REWARDS");
      this._btnGetAll.label = this.api.lang.getText("GET_ALL");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnGetAll.addEventListener("click",this);
   }
   function initData()
   {
      this._lstAchievements.dataProvider = this.api.datacenter.Player.Achievements.getAchievementsWithRewardsAvailable();
      if(this._lstAchievements.dataProvider.length == 0)
      {
         this.api.ui.getUIComponent("AchievementRewards").savePositionAndClose();
         this.callClose();
      }
      else
      {
         this.updateLabel();
      }
   }
   function updateLabel()
   {
      var _loc2_ = this._lstAchievements.length;
      var _loc3_ = this.api.lang.getText("REMAINING_REWARDS",[_loc2_]);
      this._lblRemaining.text = ank.utils.PatternDecoder.combine(_loc3_,"n",_loc2_ < 2);
   }
   function getAllAchievementsRewards()
   {
      this.api.network.Achievements.askAchievementReward("-1");
   }
   function click(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnGetAll:
            if(this.api.datacenter.Player.isBusy)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
            }
            else if(this.api.datacenter.Map.isGladiatrool)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_IN_GLADIATROOL"),"ERROR_CHAT");
            }
            else
            {
               _loc3_ = this.api.lang.getText("ASK_AVAILABLE_REWARDS_GET_ALL") + this.api.datacenter.Basics.getWarningGainExperienceMessage();
               _loc4_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoGetAll",{title:this.api.lang.getText("QUESTION"),text:_loc3_});
               _loc4_.addEventListener("yes",this);
            }
         default:
            return;
      }
   }
   function yes(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target._name) === "AskYesNoGetAll")
      {
         this.getAllAchievementsRewards();
         this.callClose();
      }
   }
}
