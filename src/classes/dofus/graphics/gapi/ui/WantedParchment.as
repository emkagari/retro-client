class dofus.graphics.gapi.ui.WantedParchment extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgHidder;
   var _btnClose;
   var _btnStartQuest;
   var _lblDescriptionTitle;
   var _lblDifficulty;
   var _lblRewardsTitle;
   var _lblTitle;
   var _ldrIcon;
   var _oWantedParchment;
   var _sdStars;
   var _txtBody;
   var _txtDescription;
   var _txtRewards;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "WantedParchment";
   function WantedParchment()
   {
      super();
   }
   function set data(oWantedParchment)
   {
      this._oWantedParchment = oWantedParchment;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.WantedParchment.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Documents.leave();
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
      this._lblTitle.text = this.api.lang.getText("WANTED_TITLE",[this._oWantedParchment.wantedMonster.name]);
      this._lblDifficulty.text = this.api.lang.getText("DIFFICULTY");
      this._txtBody.text = this._oWantedParchment.body;
      this._lblDescriptionTitle.text = this.api.lang.getText("WANTED_DESCRIPTION");
      this._txtDescription.text = this._oWantedParchment.description;
      this._lblRewardsTitle.text = this.api.lang.getText("WANTED_REWARD_TITLE");
      this._txtRewards.text = ank.utils.PatternDecoder.combine(this.api.lang.getText("WANTED_REWARD_DESCRIPTION",[new ank.utils.ExtendedString(this._oWantedParchment.kamasReward).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]),null,this._oWantedParchment.kamasReward <= 1) + ".";
      var _loc2_ = this._oWantedParchment.wantedMonster.name.indexOf(" ") == -1 ? this._oWantedParchment.wantedMonster.name : this._oWantedParchment.wantedMonster.name.substring(0,this._oWantedParchment.wantedMonster.name.indexOf(" "));
      this._btnStartQuest.label = this.api.lang.getText("WANTED_LOOK_FOR",[_loc2_]);
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._bgHidder.addEventListener("click",this);
      this._btnStartQuest.addEventListener("click",this);
      this._ldrIcon.addEventListener("initialization",this);
      this._sdStars.addEventListener("over",this);
      this._sdStars.addEventListener("out",this);
   }
   function initData()
   {
      this._ldrIcon.contentPath = this._oWantedParchment.wantedMonster.artworkFile;
      this._ldrIcon.filters = [new flash.filters.ColorMatrixFilter([0.52,0.43,0.06,0,0,0.22,0.73,0.06,0,0,0.22,0.43,0.36,0,0,0,0,0,0.7,0])];
      this._sdStars.value = this._oWantedParchment.difficultyValue * 20;
   }
   function initialization(oEvent_)
   {
      var _loc3_ = this._ldrIcon.content._mcIcon;
      var _loc4_ = this._ldrIcon.width;
      var _loc5_ = this._ldrIcon.height;
      var _loc6_ = _loc3_.getBounds(_loc3_);
      var _loc7_ = _loc6_.xMax - _loc6_.xMin;
      var _loc8_ = _loc6_.yMax - _loc6_.yMin;
      var _loc9_ = Math.min(_loc4_ / _loc7_,_loc5_ / _loc8_);
      _loc3_._xscale = _loc3_._yscale = _loc9_ * 100;
      _loc3_._x = _loc4_ / 2;
      _loc3_._y = _loc5_ / 2;
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnClose:
         case this._bgHidder:
            this.callClose();
            break;
         case this._btnStartQuest:
            this.api.network.GameActions.sendActions(34,[this._oWantedParchment.questID]);
            this.api.network.Documents.leave();
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target) === this._sdStars)
      {
         this.gapi.showTooltip(this.api.lang.getText("WANTED_DIFFICULTY",[this._oWantedParchment.difficultyValue]));
      }
   }
   function out(oEvent_)
   {
      this.gapi.hideTooltip();
   }
}
