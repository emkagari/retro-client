class dofus.graphics.gapi.ui.achievements.AchievementRewardItem extends ank.gapi.core.UIBasicComponent
{
   var _aCtrs;
   var _btnGetReward;
   var _ctr1;
   var _ctr2;
   var _ctr3;
   var _ctr4;
   var _ctr5;
   var _ctr6;
   var _lblKama;
   var _lblName;
   var _lblWinXP;
   var _mcList;
   var _oItem;
   var _visible;
   var addToQueue;
   function AchievementRewardItem()
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
         this._lblName.text = oItem_.name;
         this._lblKama.text = new ank.utils.ExtendedString(oItem_.rewardsKamas).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         this._lblWinXP.text = new ank.utils.ExtendedString(oItem_.rewardsExperiences).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         this.resetContainersData();
         this.initContainersData();
         this._visible = true;
      }
      else if(this._lblName.text != undefined)
      {
         this._visible = false;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this._visible = false;
      this.initContainers();
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initContainers()
   {
      this._aCtrs = [this._ctr1,this._ctr2,this._ctr3,this._ctr4,this._ctr5,this._ctr6];
   }
   function addListeners()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aCtrs.length)
      {
         _loc3_ = this._aCtrs[_loc2_];
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
      this._btnGetReward.addEventListener("click",this);
      this._btnGetReward.addEventListener("over",this);
      this._btnGetReward.addEventListener("out",this);
   }
   function initContainersData()
   {
      var _loc2_ = this._oItem.rewardsTitle;
      var _loc3_ = this._oItem.rewardsItems;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc2_.id != undefined)
      {
         _loc5_ = _loc2_.id;
         _loc6_ = _loc2_.type;
         _loc7_ = this._aCtrs[_loc4_];
         _loc7_.contentData = new dofus.datacenter.Title(_loc5_,undefined,_loc6_);
         _loc7_.enabled = _loc7_.contentData != undefined;
         _loc4_ = _loc4_ + 1;
      }
      var _loc8_;
      var _loc9_;
      var _loc10_;
      for(var id in _loc3_)
      {
         if(_loc4_ >= this._aCtrs.length)
         {
            break;
         }
         _loc8_ = Number(id);
         _loc9_ = _loc3_[id];
         _loc10_ = this._aCtrs[_loc4_];
         _loc10_.contentData = new dofus.datacenter.Item(undefined,_loc8_,_loc9_,undefined,String(this.api.lang.getItemStats(_loc8_)));
         _loc10_.label = _loc9_ <= 1 ? undefined : String(_loc9_);
         _loc10_.enabled = _loc10_.contentData != undefined;
         _loc4_ = _loc4_ + 1;
      }
   }
   function resetContainersData()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aCtrs.length)
      {
         _loc3_ = this._aCtrs[_loc2_];
         _loc3_.contentData = undefined;
         _loc2_ = _loc2_ + 1;
      }
   }
   function click(oEvent_)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent_.target) !== this._btnGetReward)
      {
         _loc3_ = oEvent_.target.contentData;
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && _loc3_ != undefined)
         {
            this.api.kernel.GameManager.insertItemInChat(_loc3_);
         }
      }
      else if(this.api.datacenter.Player.isBusy)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
      }
      else if(this.api.datacenter.Map.isGladiatrool)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_IN_GLADIATROOL"),"ERROR_CHAT");
      }
      else
      {
         this.api.network.Achievements.askAchievementReward(String(this._oItem.ID));
      }
   }
   function over(oEvent_)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if((_loc0_ = oEvent_.target) !== this._btnGetReward)
      {
         _loc3_ = oEvent_.target;
         _loc4_ = _loc3_.contentData;
         if(_loc4_ instanceof dofus.datacenter.Title)
         {
            _loc5_ = dofus.datacenter.Title(_loc4_);
            this.api.ui.showTooltip(_loc5_.toString());
         }
         else
         {
            _loc6_ = dofus.datacenter.Item(_loc4_);
            _loc6_.showStatsTooltip(_loc6_.style);
         }
      }
      else
      {
         this.api.ui.showTooltip(this.api.lang.getText("GET_ITEM") + (this._oItem.rewardsExperiences <= 0 ? "" : this.api.datacenter.Basics.getWarningGainExperienceMessage()));
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
}
