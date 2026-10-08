class dofus.graphics.gapi.controls.PlayerWeight extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _nCurrentOverWeight;
   var _nCurrentWeight;
   var _pbWeight;
   var _sStyleName;
   var addToQueue;
   var gapi;
   var initialized;
   static var CLASS_NAME = "PlayerWeight";
   function PlayerWeight()
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
      super.init(false,dofus.graphics.gapi.controls.PlayerWeight.CLASS_NAME);
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
      this.api.datacenter.Player.addEventListener("maxWeightChanged",this);
      this.api.datacenter.Player.addEventListener("maxOverWeightChanged",this);
      this.api.datacenter.Player.addEventListener("currentWeightChanged",this);
   }
   function initData()
   {
      if(this._sStyleName != undefined)
      {
         this._pbWeight.styleName = this._sStyleName;
      }
      this.currentWeightChanged({value:this.api.datacenter.Player.currentWeight});
   }
   function currentWeightChanged(oEvent)
   {
      var _loc3_ = this.api.datacenter.Player.maxWeight;
      var _loc4_ = oEvent.value;
      var _loc5_ = this.api.datacenter.Player.currentOverWeight;
      var _loc6_ = this.api.datacenter.Player.maxOverWeight;
      this._nCurrentWeight = _loc4_;
      this._nCurrentOverWeight = _loc5_;
      this._pbWeight.maximum = _loc3_;
      this._pbWeight.value = _loc4_;
      this._pbWeight.uberMaximum = _loc6_ != 0 ? _loc6_ : 1;
      this._pbWeight.uberValue = _loc5_;
   }
   function maxWeightChanged(oEvent)
   {
      this._pbWeight.maximum = oEvent.value;
   }
   function maxOverWeightChanged(oEvent)
   {
      this._pbWeight.uberMaximum = oEvent.value;
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._pbWeight)
      {
         this.gapi.showTooltip(this.api.datacenter.Player.getWeightText());
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
