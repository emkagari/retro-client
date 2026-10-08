class dofus.aks.Waypoints extends dofus.aks.Handler
{
   var aks;
   var api;
   function Waypoints(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function leave()
   {
      this.aks.send("WV",true);
   }
   function use(nWaypointID)
   {
      this.aks.send("WU" + nWaypointID,true);
   }
   function save()
   {
      this.aks.send("WS",true);
   }
   function onCreate(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_ = 1;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc6_ < _loc3_.length)
      {
         _loc7_ = _loc3_[_loc6_].split(";");
         _loc8_ = Number(_loc7_[0]);
         _loc9_ = Number(_loc7_[1]);
         _loc10_ = new dofus.datacenter.Waypoint(_loc8_,_loc8_ == this.api.datacenter.Map.id,_loc8_ == _loc4_,_loc9_);
         _loc5_.push(_loc10_);
         _loc6_ = _loc6_ + 1;
      }
      this.api.ui.loadUIComponent("Waypoints","Waypoints",{data:_loc5_});
   }
   function onLeave()
   {
      this.api.ui.unloadUIComponent("Waypoints");
   }
   function onSave(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = this.api.ui.getUIComponent("Waypoints");
      if(_loc4_ != undefined)
      {
         dofus.graphics.gapi.ui.Waypoints(_loc4_).setNewSaveMap(_loc3_);
      }
   }
   function onUseError()
   {
      this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_USE_WAYPOINT"),"ERROR_CHAT");
   }
}
