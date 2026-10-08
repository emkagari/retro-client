class dofus.aks.Storages extends dofus.aks.Handler
{
   var api;
   function Storages(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function onInformations(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split(",");
         _loc6_ = _loc5_[0];
         _loc7_ = _loc5_[1] == "1";
         _loc8_ = this.api.datacenter.Storages;
         _loc9_ = _loc8_.getItemAt(_loc6_);
         if(_loc9_ == undefined)
         {
            _loc9_ = new dofus.datacenter.Storage();
         }
         _loc9_.isLocked = _loc7_;
         _loc8_.addItemAt(_loc6_,_loc9_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function onLockedStorage(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1] == "1";
      var _loc6_ = this.api.datacenter.Storages;
      var _loc7_ = _loc6_.getItemAt(_loc4_);
      if(_loc7_ == undefined)
      {
         _loc7_ = new dofus.datacenter.Storage(_loc4_);
         _loc6_.addItemAt(_loc4_,_loc7_);
      }
      _loc7_.isLocked = _loc5_;
   }
}
