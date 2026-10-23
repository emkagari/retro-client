class dofus.graphics.gapi.ui.TemporaryEvent extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _oData;
   var _pbProgression;
   var _txtDescription;
   var _txtEndDate;
   var _txtProgression;
   var _txtTitle;
   var addToQueue;
   var gapi;
   var gotoAndStop;
   var unloadThis;
   static var CLASS_NAME = "TemporaryEvent";
   static var REWARDS_MAX_INDEX = 6;
   function TemporaryEvent()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
      this.updateData();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.TemporaryEvent.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.TemporaryEvent.REWARDS_MAX_INDEX)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initData()
   {
      this.api.network.TemporaryEvent.askTemporaryEventInfos();
   }
   function updateMilestonesComponents()
   {
      var _loc2_ = this._oData.rewards;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc3_ < dofus.graphics.gapi.ui.TemporaryEvent.REWARDS_MAX_INDEX)
      {
         _loc4_ = this["_ctr" + _loc3_];
         _loc5_ = _loc2_[_loc3_].item;
         _loc6_ = _loc2_[_loc3_].milestone;
         _loc4_.contentData = _loc5_;
         _loc4_.label = String(_loc5_.Quantity);
         _loc4_.borderRenderer = this._oData.currentScore < _loc6_ ? "" : "TemporaryEventItemOK";
         _loc7_ = this["_txtMilestone" + _loc3_];
         _loc7_.text = 100 * _loc6_ / this._oData.totalScore + "%";
         _loc3_ = _loc3_ + 1;
      }
   }
   function updateData()
   {
      this.gotoAndStop(this._oData.eventID);
      this._txtTitle.text = this._oData.title;
      this._txtDescription.htmlText = this._oData.description;
      this._txtEndDate.text = this.api.lang.getText("EVENT_ENDING_AT",[this._oData.dateString]);
      var _loc2_ = this._oData.currentScore;
      var _loc3_ = this._oData.totalScore;
      this._txtProgression.text = 100 * _loc2_ / _loc3_ + "%";
      this._pbProgression.styleName = "TemporaryEvent" + this._oData.eventID + "ProgressBar";
      this._pbProgression.uberMaximum = this._pbProgression.maximum = _loc3_;
      this._pbProgression.value = _loc3_;
      this._pbProgression.uberValue = _loc2_;
      this.updateMilestonesComponents();
   }
   function click(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) !== this._btnClose)
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent_.target.contentData != undefined)
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent_.target.contentData);
         }
      }
      else
      {
         this.callClose();
      }
   }
   function over(oEvent_)
   {
      var _loc3_ = oEvent_.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
   }
   function out(oEvent_)
   {
      this.gapi.hideTooltip();
   }
}
