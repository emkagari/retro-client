class dofus.aks.SecureForgemagusCraft extends dofus.aks.Handler
{
   var aks;
   var api;
   var CONTAINER_IDX_CRAFTER_INVENTORY = 1;
   var CONTAINER_IDX_CUSTOMER_INVENTORY = 2;
   var CONTAINER_IDX_BAG = 3;
   var CONTAINER_IDX_CRAFT = 4;
   function SecureForgemagusCraft(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function askAddItem(nItemId, nQty)
   {
      this.aks.send("EFa" + nItemId + ";" + nQty,true);
   }
   function askMoveItem(bToCraft, nItemId, nQty)
   {
      this.aks.send("EFm" + (!bToCraft ? "0" : "1") + ";" + nItemId + ";" + nQty,true);
   }
   function askRemoveItem(nItemId, nQty)
   {
      this.aks.send("EFr" + nItemId + ";" + nQty,true);
   }
   function askLockBag(bLock)
   {
      this.aks.send("EFb" + (!bLock ? "0" : "1"),true);
   }
   function askAutoCraft(bAutoCraft)
   {
      this.aks.send("EFl" + (!bAutoCraft ? "0" : "1"),true);
   }
   function onLoopStart()
   {
      this.api.datacenter.Basics.isCraftLooping = true;
      this.api.ui.getUIComponent("SecureCraft").onCraftLoopStart();
   }
   function onItemMove(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0);
      var _loc4_ = sExtraData.substr(1).split("|");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = Number(_loc4_[1]);
      var _loc7_ = Number(_loc4_[2]);
      var _loc8_ = Number(_loc4_[3]);
      var _loc9_ = _loc4_[4];
      var _loc10_;
      var _loc11_;
      switch(_loc3_)
      {
         case "+":
            _loc10_ = new dofus.datacenter.Item(_loc6_,_loc8_,_loc7_,-1,_loc9_);
            this.onItemAdded(_loc5_,_loc10_);
            break;
         case "-":
            _loc11_ = new dofus.datacenter.Item(_loc6_,_loc8_,_loc7_,-1,_loc9_);
            this.onItemRemoved(_loc5_,_loc11_);
         default:
            return;
      }
   }
   function onItemRemoved(nTarget, oItem_)
   {
      var _loc4_ = this.api.datacenter.Exchange;
      var _loc5_;
      switch(nTarget)
      {
         case this.CONTAINER_IDX_CRAFTER_INVENTORY:
            if(this.api.ui.getUIComponent("SecureCraft")._cgPay)
            {
               break;
            }
            _loc5_ = _loc4_.inventory;
            break;
         case this.CONTAINER_IDX_CUSTOMER_INVENTORY:
            if(!this.api.ui.getUIComponent("SecureCraft")._cgPay)
            {
               break;
            }
            _loc5_ = _loc4_.inventory;
            break;
         case this.CONTAINER_IDX_BAG:
            _loc5_ = _loc4_.coopGarbage;
            break;
         case this.CONTAINER_IDX_CRAFT:
            _loc5_ = _loc4_.distantGarbage;
      }
      if(_loc5_ == undefined)
      {
         return undefined;
      }
      var _loc6_ = _loc5_.findFirstItem("ID",oItem_.ID);
      if(_loc6_.index == -1)
      {
         return undefined;
      }
      var _loc7_ = _loc6_.item;
      var _loc8_ = _loc7_.Quantity - oItem_.Quantity;
      if(_loc8_ <= 0)
      {
         _loc5_.removeItems(_loc6_.index,1);
      }
      else
      {
         _loc7_.Quantity = _loc8_;
         _loc5_.updateItem(_loc6_.index,_loc7_);
      }
   }
   function onItemAdded(nTarget, oItem_)
   {
      var _loc4_ = this.api.datacenter.Exchange;
      var _loc5_;
      switch(nTarget)
      {
         case this.CONTAINER_IDX_CRAFTER_INVENTORY:
            if(this.api.ui.getUIComponent("SecureCraft")._cgPay)
            {
               break;
            }
            _loc5_ = _loc4_.inventory;
            break;
         case this.CONTAINER_IDX_CUSTOMER_INVENTORY:
            if(!this.api.ui.getUIComponent("SecureCraft")._cgPay)
            {
               break;
            }
            _loc5_ = _loc4_.inventory;
            break;
         case this.CONTAINER_IDX_BAG:
            _loc5_ = _loc4_.coopGarbage;
            break;
         case this.CONTAINER_IDX_CRAFT:
            _loc5_ = _loc4_.distantGarbage;
      }
      if(_loc5_ == undefined)
      {
         return undefined;
      }
      var _loc6_ = _loc5_.findFirstItem("ID",oItem_.ID);
      var _loc7_;
      var _loc8_;
      if(_loc6_.index == -1)
      {
         _loc5_.push(oItem_);
      }
      else
      {
         _loc7_ = _loc6_.item;
         _loc8_ = _loc7_.Quantity + oItem_.Quantity;
         _loc7_.Quantity = _loc8_;
         _loc5_.updateItem(_loc6_.index,_loc7_);
      }
   }
}
