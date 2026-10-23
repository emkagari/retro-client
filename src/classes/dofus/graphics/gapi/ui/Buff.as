class dofus.graphics.gapi.ui.Buff extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "Buff";
   static var LAST_CONTAINER = 27;
   function Buff()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Buff.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      var _loc2_ = 20;
      var _loc3_;
      while(_loc2_ <= dofus.graphics.gapi.ui.Buff.LAST_CONTAINER)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
      var _loc4_ = 66;
      var _loc5_;
      while(_loc4_ <= dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER)
      {
         _loc5_ = this["_ctr" + _loc4_];
         _loc5_.addEventListener("click",this);
         _loc5_.addEventListener("over",this);
         _loc5_.addEventListener("out",this);
         _loc4_ = _loc4_ + 1;
      }
      this.api.datacenter.Player.Inventory.addEventListener("modelChanged",this);
   }
   function updateData()
   {
      var _loc2_ = [];
      var _loc3_ = 20;
      while(_loc3_ <= dofus.graphics.gapi.ui.Buff.LAST_CONTAINER)
      {
         _loc2_[_loc3_] = true;
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = 6;
      while(_loc4_ <= dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER)
      {
         _loc2_[_loc4_] = true;
         _loc4_ = _loc4_ + 1;
      }
      var _loc5_ = this.api.datacenter.Player.Inventory;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      for(var k in _loc5_)
      {
         _loc6_ = _loc5_[k];
         if(!_global.isNaN(_loc6_.position))
         {
            _loc7_ = _loc6_.position;
            if(_loc7_ < 20 && (_loc7_ > dofus.graphics.gapi.ui.Buff.LAST_CONTAINER && (_loc7_ < dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER && _loc7_ > dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER)))
            {
               continue;
            }
            if(_loc7_ > dofus.datacenter.GladiatroolManager.FIRST_GLADIATROOL_CONTAINER)
            {
               continue;
            }
            _loc8_ = this["_ctr" + _loc7_];
            _loc8_.contentData = _loc6_;
            _loc8_.enabled = true;
            _loc2_[_loc7_] = false;
         }
      }
      var _loc9_ = 20;
      var _loc10_;
      while(_loc9_ <= dofus.graphics.gapi.ui.Buff.LAST_CONTAINER)
      {
         if(_loc2_[_loc9_])
         {
            _loc10_ = this["_ctr" + _loc9_];
            _loc10_.contentData = undefined;
            _loc10_.enabled = false;
         }
         _loc9_ = _loc9_ + 1;
      }
      var _loc11_ = 66;
      var _loc12_;
      while(_loc11_ <= dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER)
      {
         if(_loc2_[_loc11_])
         {
            _loc12_ = this["_ctr" + _loc11_];
            _loc12_.contentData = undefined;
            _loc12_.enabled = false;
         }
         _loc11_ = _loc11_ + 1;
      }
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.eventName)
      {
         case "updateOne":
         case "updateAll":
      }
      this.updateData();
   }
   function click(oEvent)
   {
      this.gapi.loadUIComponent("BuffInfos","BuffInfos",{data:oEvent.target.contentData},{bStayIfPresent:true});
   }
   function over(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ != undefined)
      {
         this.gapi.showTooltip(_loc3_.name + "\n");
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
