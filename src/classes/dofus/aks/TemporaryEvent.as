class dofus.aks.TemporaryEvent extends dofus.aks.Handler
{
   var aks;
   var api;
   function TemporaryEvent(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function askTemporaryEventInfos(sName_)
   {
      this.aks.send("Yi");
   }
   function onCurrentTemporaryEvent(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Basics.temporaryEventID = _loc3_;
   }
   function onTemporaryEventInfos(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = this.api.datacenter.Basics.temporaryEventID;
      var _loc5_ = _loc3_[1];
      var _loc6_ = new Date(_loc3_[2]);
      var _loc7_ = Number(_loc3_[3]);
      var _loc8_ = Number(_loc3_[4]);
      var _loc9_ = _loc3_[5].split(";");
      var _loc10_ = [];
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      while(_loc11_ < _loc9_.length)
      {
         _loc12_ = _loc9_[_loc11_].split(",");
         _loc13_ = Number(_loc12_[0]);
         _loc14_ = _loc12_[1].split(":");
         _loc15_ = Number(_loc14_[0]);
         _loc16_ = Number(_loc14_[1]);
         _loc17_ = new dofus.datacenter.Item(undefined,_loc15_,_loc16_,undefined,String(this.api.lang.getItemStats(_loc15_)));
         _loc10_.push({item:_loc17_,milestone:_loc13_});
         _loc11_ = _loc11_ + 1;
      }
      var _loc18_ = new dofus.datacenter.TemporaryEvent(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc10_);
      this.api.ui.getUIComponent("TemporaryEvent").data = _loc18_;
   }
}
