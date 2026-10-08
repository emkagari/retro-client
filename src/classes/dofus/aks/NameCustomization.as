class dofus.aks.NameCustomization extends dofus.aks.Handler
{
   var api;
   function NameCustomization(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function setTitle(nId_)
   {
      this.aks.send("nt" + nId_);
   }
   function getTitles()
   {
      this.aks.send("nT",true);
   }
   function onTitles(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      this.api.datacenter.NameCustomization.selectedId = _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if(_loc3_.length > 1)
      {
         _loc5_ = new ank.utils.ExtendedArray();
         if(_loc3_[1].length > 0)
         {
            _loc6_ = _loc3_[1].split(",");
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = _loc6_[_loc7_].split(":");
               _loc9_ = Number(_loc8_[0]);
               _loc10_ = _loc8_[1].split("*");
               _loc11_ = Number(_loc10_[0]);
               _loc12_ = _loc10_[1];
               _loc13_ = new dofus.datacenter.Title(_loc11_,_loc12_,_loc9_);
               _loc5_.push(_loc13_);
               _loc7_ = _loc7_ + 1;
            }
         }
         this.api.datacenter.NameCustomization.titles = _loc5_;
      }
   }
}
