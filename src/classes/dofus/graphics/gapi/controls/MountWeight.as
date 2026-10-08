class dofus.graphics.gapi.controls.MountWeight extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _nCurrentWeight;
   var _pbWeight;
   var _sStyleName;
   var addToQueue;
   var api;
   var gapi;
   var initialized;
   static var CLASS_NAME = "MountWeight";
   function MountWeight()
   {
      super();
   }
   function set styleName(sStyleName)
   {
      this._sStyleName = sStyleName;
      if(this.initialized)
      {
         this._pbWeight.styleName = sStyleName;
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.MountWeight.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._pbWeight.addEventListener("over",this);
      this._pbWeight.addEventListener("out",this);
      this.api.datacenter.Player.mount.addEventListener("podsChanged",this);
   }
   function initData()
   {
      if(this._sStyleName != undefined)
      {
         this._pbWeight.styleName = this._sStyleName;
      }
      this.podsChanged();
   }
   function podsChanged(oEvent)
   {
      var _loc3_ = this.api.datacenter.Player.mount.podsMax;
      var _loc4_ = this.api.datacenter.Player.mount.pods;
      this._nCurrentWeight = _loc4_;
      this._pbWeight.maximum = _loc3_;
      this._pbWeight.value = _loc4_;
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent.target) === this._pbWeight)
      {
         _loc3_ = oEvent.target.maximum;
         _loc4_ = new ank.utils.ExtendedString(this._nCurrentWeight).addMiddleChar(" ",3);
         _loc5_ = new ank.utils.ExtendedString(_loc3_).addMiddleChar(" ",3);
         this.gapi.showTooltip(this.api.lang.getText("PLAYER_WEIGHT",[_loc4_,_loc5_]));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
