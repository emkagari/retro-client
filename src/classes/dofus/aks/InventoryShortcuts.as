class dofus.aks.InventoryShortcuts extends dofus.aks.Handler
{
   var api;
   function InventoryShortcuts(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function sendInventoryShortcutAdd(nPosition, nObjectID)
   {
      this.aks.send("OrA" + nPosition + ";" + nObjectID);
   }
   function sendInventoryShortcutQuickAdd(nPosition, nCustomSetID)
   {
      this.aks.send("OrQ" + nPosition + ";" + nCustomSetID);
   }
   function sendInventoryShortcutMove(nOldPosition, nNewPosition)
   {
      this.aks.send("OrM" + nOldPosition + ";" + nNewPosition);
   }
   function sendInventoryShortcutRemove(nPosition)
   {
      this.aks.send("OrR" + nPosition);
   }
   function onInventoryShortcutAdded(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = Number(_loc3_[2]);
      var _loc7_ = _loc3_[3];
      var _loc8_ = new dofus.datacenter.InventoryShortcutItem(_loc5_,_loc4_,_loc6_,_loc7_);
      var _loc9_ = this.api.datacenter.Player.InventoryShortcuts;
      _loc9_.addItemAt(_loc4_,_loc8_);
   }
   function onInventoryShortcutRemoved(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = this.api.datacenter.Player.InventoryShortcuts;
      _loc4_.removeItemAt(_loc3_);
   }
}
