class dofus.graphics.gapi.controls.timeline.TimelineItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _ldrSprite;
   var _mcBackRect;
   var _mcHealth;
   var _oData;
   var _vcChrono;
   var addToQueue;
   var api;
   var gapi;
   static var CLASS_NAME = "Timeline";
   var _bHidden = false;
   function TimelineItem()
   {
      super();
   }
   function get isHidden()
   {
      return this._bHidden;
   }
   function set isHidden(bHidden)
   {
      this._bHidden = bHidden;
   }
   function get chrono()
   {
      return this._vcChrono;
   }
   function get sprite()
   {
      return this._ldrSprite;
   }
   function set data(oData)
   {
      this._oData = oData;
      this.updateHealth();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.timeline.TimelineItem.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.loadSprite,params:[dofus.Constants.CLIPS_PERSOS_PATH + this._oData.gfxID + ".swf"]});
   }
   function loadSprite(sFile)
   {
      this._ldrSprite.contentPath = sFile;
      this._ldrSprite.addEventListener("initialization",this);
      this.api.colors.addSprite(this._ldrSprite,this._oData);
      this.setHealthTeamColor();
      this.updateHealth();
   }
   function setHealthTeamColor()
   {
      var _loc2_ = new Color(this._mcHealth);
      _loc2_.setRGB(dofus.Constants.TEAMS_COLOR[this._oData._summoned]);
   }
   function updateHealth()
   {
      this._mcHealth._yscale = this._oData._lp / this._oData._lpmax * 100;
   }
   function onRollOver()
   {
      this._oData.mc.onRollOver();
      this._oData.mc.showEffects(true);
   }
   function onRollOut()
   {
      this._oData.mc.onRollOut();
      this._oData.mc.showEffects(false);
   }
   function itemOver()
   {
      this._mcBackRect._alpha = 50;
   }
   function itemOut()
   {
      this._mcBackRect._alpha = 100;
   }
   function onRelease()
   {
      var _loc2_;
      var _loc3_;
      if(this._oData.isVisible && (this.api.datacenter.Game.interactionType == 2 || this.api.datacenter.Game.interactionType == 3))
      {
         this._oData.mc.onRelease();
      }
      else
      {
         _loc2_ = this.gapi.getUIComponent("PlayerInfos");
         _loc3_ = _loc2_ != undefined && this._oData != _loc2_.data;
         this.gapi.loadUIComponent("PlayerInfos","PlayerInfos",{data:this._oData},{bForceLoad:_loc3_});
      }
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target.content;
      _loc3_.attachMovie("staticR","anim",10);
      _loc3_._x = 15;
      _loc3_._y = 32;
      _loc3_._xscale = -80;
      _loc3_._yscale = 80;
   }
}
