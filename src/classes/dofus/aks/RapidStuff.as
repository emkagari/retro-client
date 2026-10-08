class dofus.aks.RapidStuff extends dofus.aks.Handler
{
   var aks;
   var api;
   function RapidStuff(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function editRapidStuff(nRapidStuffID, nIconID, sName)
   {
      this.aks.send("xE" + nRapidStuffID + "|" + nIconID + "|" + sName);
   }
   function deleteRapidStuff(nRapidStuffID)
   {
      this.aks.send("xD" + nRapidStuffID);
   }
   function saveRapidStuff(nRapidStuffID)
   {
      this.aks.send("xS" + nRapidStuffID);
   }
   function loadRapidStuff(nRapidStuffID)
   {
      this.aks.send("xL" + nRapidStuffID);
   }
   function onRapidStuffCache(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_.length <= 2 ? undefined : _loc3_[2];
      var _loc7_ = _loc3_.length <= 3 ? undefined : _loc3_[3];
      var _loc8_ = _loc3_.length <= 4 ? false : Number(_loc3_[4]) == 1;
      var _loc9_ = [];
      var _loc10_;
      var _loc11_;
      var _loc12_;
      if(_loc7_ != undefined)
      {
         _loc10_ = _loc7_.split(";");
         _loc11_ = 0;
         while(_loc11_ < _loc10_.length)
         {
            _loc12_ = this.api.kernel.CharactersManager.getItemObjectFromData(_loc10_[_loc11_]);
            _loc9_.push(_loc12_);
            _loc11_ = _loc11_ + 1;
         }
      }
      var _loc13_ = new dofus.datacenter.RapidStuff(_loc5_,_loc4_,_loc6_,_loc9_,_loc8_);
      this.api.datacenter.Player.putRapidStuff(_loc4_,_loc13_);
      var _loc14_ = this.api.datacenter.Player.InventoryShortcuts.getItems();
      var _loc15_;
      for(var k in _loc14_)
      {
         _loc15_ = _loc14_[k];
         if(_loc15_.isCustomSet)
         {
            if(_loc15_.genericID == _loc4_)
            {
               _loc15_.updateCustomSet();
               this.api.datacenter.Player.InventoryShortcuts.dispatchEvent({type:"modelChanged"});
            }
         }
      }
   }
}
