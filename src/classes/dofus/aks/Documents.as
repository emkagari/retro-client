class dofus.aks.Documents extends dofus.aks.Handler
{
   var aks;
   var api;
   function Documents(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function leave()
   {
      this.aks.send("dV");
   }
   function onCreate(bSuccess, sExtraData)
   {
      var _loc4_;
      var _loc5_;
      if(bSuccess)
      {
         _loc4_ = sExtraData;
         _loc5_ = this.api.config.language;
         this.api.ui.loadUIComponent("CenterText","CenterText",{text:this.api.lang.getText("LOADING"),background:false},{bForceLoad:true});
         this.api.kernel.DocumentsServersManager.loadDocument(_loc5_ + "_" + _loc4_);
      }
   }
   function onCreateWantedParchment(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = new dofus.datacenter.WantedParchment(_loc3_);
      this.api.ui.loadUIComponent("WantedParchment","Document",{data:_loc4_});
   }
   function onLeave()
   {
      this.api.ui.unloadUIComponent("Document");
   }
}
