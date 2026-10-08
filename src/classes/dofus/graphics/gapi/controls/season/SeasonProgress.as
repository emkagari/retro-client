class dofus.graphics.gapi.controls.season.SeasonProgress extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _lblFinished;
   var _lblRewards;
   var _lblScore;
   var _mcPlacer;
   var _mcRewardsList;
   var _nActualProgress;
   var _nTotalRewards;
   var _sbScrollbar;
   var _target;
   var _txtSeasonDescription;
   var _txtSeasonGameplay;
   var addToQueue;
   var api;
   var createEmptyMovieClip;
   var getNextHighestDepth;
   static var SCROLL_BY;
   static var CLASS_NAME = "SeasonProgress";
   static var MARGIN = 3;
   static var REWARDS_BY_PAGE = 6;
   function SeasonProgress()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.season.SeasonProgress.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initText});
   }
   function addListeners()
   {
      this._sbScrollbar.addEventListener("scroll",this);
      ank.utils.MouseEvents.addListener(this);
   }
   function initText()
   {
      this._txtSeasonDescription.text = this.api.lang.getText("SEASON_1_DESCRIPTION");
      this._txtSeasonGameplay.text = this.api.lang.getText("SEASON_1_GAMEPLAY");
      this._lblRewards.text = this.api.lang.getText("SEASON_REWARDS");
      this._lblFinished.text = this.api.lang.getText("REWARDS_EARNED",[this._nActualProgress,this._nTotalRewards]);
      this._lblScore.text = this.api.lang.getText("SCORE") + ": " + this.api.datacenter.Season.score;
   }
   function initData()
   {
      this.renderRewardsList(this.api.datacenter.Season.rewards);
   }
   function renderRewardsList(eaRewards)
   {
      if(this._mcRewardsList != undefined)
      {
         this._mcRewardsList.removeMovieClip();
      }
      this._mcRewardsList = this.createEmptyMovieClip("_mcRewards",this.getNextHighestDepth());
      this._mcRewardsList._x = this._mcPlacer._x;
      this._mcRewardsList._y = this._mcPlacer._y;
      this._mcRewardsList.setMask(this._mcPlacer);
      this._nActualProgress = 0;
      var _loc5_ = dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN;
      var _loc6_ = 0;
      var _loc7_;
      var _loc4_;
      var _loc3_;
      while(_loc6_ < eaRewards.length)
      {
         _loc7_ = eaRewards[_loc6_];
         _loc4_ = this._mcRewardsList.attachMovie("SeasonRewardBackground","SeasonRewardBackground" + _loc6_,this._mcRewardsList.getNextHighestDepth());
         _loc3_ = this._mcRewardsList.attachMovie("SeasonRewardItem","SeasonReward_" + _loc6_,this._mcRewardsList.getNextHighestDepth(),{data:_loc7_,name:_loc6_ + 1});
         _loc3_._x = _loc5_ + dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN * 2;
         _loc5_ = _loc3_._x + _loc3_._width;
         this.arrangeBackgroundClip(_loc3_,_loc4_,_loc6_ % 2 + 1);
         if(this.api.datacenter.Season.score >= _loc7_.score)
         {
            this._nActualProgress = this._nActualProgress + 1;
         }
         _loc6_ = _loc6_ + 1;
      }
      if(_loc3_ != undefined)
      {
         dofus.graphics.gapi.controls.season.SeasonProgress.SCROLL_BY = _loc3_._width + dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN * 2;
      }
      this._nTotalRewards = eaRewards.length;
      this.refreshScrollbar(this._mcRewardsList);
   }
   function refreshScrollbar(mc_)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(mc_._width > this._mcPlacer._width)
      {
         this._sbScrollbar._visible = true;
         _loc3_ = 0;
         _loc4_ = this._nTotalRewards - dofus.graphics.gapi.controls.season.SeasonProgress.REWARDS_BY_PAGE;
         _loc5_ = dofus.graphics.gapi.controls.season.SeasonProgress.REWARDS_BY_PAGE;
         _loc4_ = Math.max(0,_loc4_);
         this._sbScrollbar.setScrollProperties(_loc5_,_loc3_,_loc4_);
         _loc6_ = Math.max(_loc3_,Math.min(_loc4_,this._nActualProgress));
         this.addToQueue({object:this,method:this.applyScroll,params:[_loc6_]});
      }
      else
      {
         this._sbScrollbar._visible = false;
         this._sbScrollbar.scrollPosition = 0;
      }
   }
   function applyScroll(nScrollPosition)
   {
      this._sbScrollbar.scrollPosition = nScrollPosition;
   }
   function arrangeBackgroundClip(mcItem, mcBackground, nBackgroundIndex)
   {
      mcBackground.gotoAndStop(nBackgroundIndex);
      mcBackground._x = mcItem._x - dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN;
      mcBackground._width = mcItem._width + dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN * 2;
      mcBackground._height = this._mcPlacer._height;
   }
   function scroll(oEvent_)
   {
      this._mcRewardsList._x = this._mcPlacer._x - (this._sbScrollbar.scrollPosition * dofus.graphics.gapi.controls.season.SeasonProgress.SCROLL_BY + 3) - dofus.graphics.gapi.controls.season.SeasonProgress.MARGIN;
   }
   function onMouseWheel(nDelta, mc_)
   {
      if(dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      if(String(mc_._target).indexOf(this._target) != -1)
      {
         this._sbScrollbar.scrollPosition -= nDelta <= 0 ? -1 : 1;
         this.scroll();
      }
   }
}
