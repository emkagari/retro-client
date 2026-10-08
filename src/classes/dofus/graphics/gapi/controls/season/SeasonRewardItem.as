class dofus.graphics.gapi.controls.season.SeasonRewardItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _ctr;
   var _lblName;
   var _lblScoreMax;
   var _mcCheck;
   var _nMax;
   var _nMin;
   var _oItem;
   var _pbScore;
   var _sName;
   var addToQueue;
   var api;
   function SeasonRewardItem()
   {
      super();
   }
   function set name(nLevel)
   {
      this._sName = String(nLevel);
   }
   function set data(oData)
   {
      this._nMin = oData.previsousStep;
      this._nMax = oData.score;
      this._oItem = oData.items[0];
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
      this._ctr.addEventListener("over",this);
      this._ctr.addEventListener("out",this);
      this._ctr.addEventListener("click",this);
   }
   function initTexts()
   {
      this._lblName.text = this._sName;
      this._lblScoreMax.text = String(this._nMax);
   }
   function initData()
   {
      this._ctr.contentData = this._oItem;
      var _loc2_ = this.api.datacenter.Season.score >= this._nMax;
      this._lblScoreMax._visible = !_loc2_;
      this._mcCheck._visible = _loc2_;
      this._pbScore.minimum = this._nMin;
      this._pbScore.maximum = this._nMax;
      this._pbScore.value = !_loc2_ ? this.api.datacenter.Season.score : this._nMax;
   }
   function click(oEvent_)
   {
      var _loc3_ = oEvent_.target.contentData;
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && _loc3_ != undefined)
      {
         this.api.kernel.GameManager.insertItemInChat(_loc3_);
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
      this.api.ui.hideTooltip();
   }
}
