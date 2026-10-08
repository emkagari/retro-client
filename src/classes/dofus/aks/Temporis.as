class dofus.aks.Temporis extends dofus.aks.Handler
{
   var _temporisEpisodeThree;
   var _temporisEpisodeTwo;
   var aks;
   var api;
   function Temporis(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
      this._temporisEpisodeTwo = new dofus.aks.temporis.TemporisEpisodeTwo(this);
      this._temporisEpisodeThree = new dofus.aks.temporis.TemporisEpisodeThree(this);
   }
   function get episodeTwo()
   {
      return this._temporisEpisodeTwo;
   }
   function get episodeThree()
   {
      return this._temporisEpisodeThree;
   }
   function sendTemporisPacket(nEpisode, sPacket)
   {
      this.aks.send("YT" + nEpisode + "|" + sPacket);
   }
   function onTemporisPacketReceived(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      _loc3_.shift();
      var _loc5_ = _loc3_.join("|");
      switch(_loc4_)
      {
         case 2:
            this._temporisEpisodeTwo.onPacketReceived(_loc5_);
            break;
         case 3:
            this._temporisEpisodeThree.onPacketReceived(_loc5_);
         default:
            return;
      }
   }
   function onTemporisInfos(sExtraData)
   {
      var _loc3_ = 1000;
      if(this.api.datacenter.Player.temporisInfos == undefined)
      {
         this.api.datacenter.Player.temporisInfos = new dofus.datacenter.TemporisInfos(_loc3_);
      }
      else
      {
         this.api.datacenter.Player.temporisInfos.initialize(true,_loc3_);
      }
   }
   function onTemporisConfig(sExtraData)
   {
      var _loc3_ = this.api.kernel.TemporisConfigManager;
      _loc3_.initialize();
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_].split(";");
         _loc7_ = _loc6_[0];
         _loc8_ = _loc6_[1];
         _loc9_ = Number(_loc8_);
         if(!_global.isNaN(_loc9_))
         {
            _loc3_.putIntegerValue(_loc7_,_loc9_);
         }
         _loc5_ = _loc5_ + 1;
      }
   }
}
