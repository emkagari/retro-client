class dofus.aks.GameServer extends dofus.aks.Handler
{
   var api;
   function GameServer(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function updateServerInformation(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      this.api.datacenter.GameServer.dropBonusForServer = Number(_loc3_[0]);
   }
   function updateServerStaticCriterions(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split(":");
         _loc6_ = Number(_loc5_[0]);
         _loc7_ = _loc5_[1] == "1";
         this.api.datacenter.GameServer.updateServerStaticCriterion(_loc6_,_loc7_);
         _loc4_ = _loc4_ + 1;
      }
      dofus.graphics.gapi.ui.Encyclopedia.resetData();
   }
}
