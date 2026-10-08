class dofus.aks.temporis.TemporisEpisodeThree
{
   var _aksTemporis;
   var api;
   static var TEMPORIS_EPISODE = 3;
   function TemporisEpisodeThree(aksTemporis)
   {
      this.api = aksTemporis.api;
      this._aksTemporis = aksTemporis;
   }
   function onPacketReceived(sPacket)
   {
      if(sPacket.length == 0)
      {
         return undefined;
      }
      var _loc3_ = sPacket.charAt(0);
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(_loc3_)
      {
         case "i":
            _loc4_ = sPacket.charAt(1);
            switch(_loc4_)
            {
               case "L":
                  this.onInvadeList(sPacket.substring(2));
                  break;
               case "R":
                  this.onInvadeRanks(sPacket.substring(2));
                  break;
               case "F":
                  this.onFilter(sPacket.substring(2));
            }
            break;
         case "u":
            _loc5_ = sPacket.charAt(1);
            switch(_loc5_)
            {
               case "p":
                  this.onUpgradePreview(sPacket.substring(2));
                  break;
               case "i":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("TR3_UPGRADE_ERR5"),"ERROR_CHAT");
                  break;
               case "s":
                  this.onUpgradeFinished(sPacket.substring(2),true);
                  break;
               case "f":
                  this.onUpgradeFinished(sPacket.substring(2),false);
            }
            break;
         case "d":
            _loc6_ = sPacket.charAt(1);
            switch(_loc6_)
            {
               case "L":
                  this.onDungeonList(sPacket.substring(2));
                  break;
               case "R":
                  this.onDungeonRanks(sPacket.substring(2));
            }
         default:
            return;
      }
   }
   function askInvadeInfo()
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"iL");
   }
   function askInvadeRank(nInvadeId)
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"iR" + nInvadeId);
   }
   function askUpgradePreview(itemUID, relicId)
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"up" + itemUID + ";" + relicId);
   }
   function askUpgradeExecute(itemUID, itemUID2, itemUID3, fragUID, fragQty, relicUID)
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"uu" + itemUID + ";" + itemUID2 + ";" + itemUID3 + ";" + fragUID + ";" + fragQty + (relicUID == undefined ? "" : ";" + relicUID));
   }
   function askDungeonInfo()
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"dL");
   }
   function askDungeonLadderRank(nDungeonId)
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"dR" + nDungeonId);
   }
   function askRestat()
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"r");
   }
   function askChangeLevel(arg)
   {
      this._aksTemporis.sendTemporisPacket(dofus.aks.temporis.TemporisEpisodeThree.TEMPORIS_EPISODE,"a" + arg);
   }
   function onFilter(sPacket)
   {
      var _loc3_ = sPacket.split("|");
      var _loc4_ = Number(_loc3_[0]) == 1;
      this.api.datacenter.Temporis.currentAreaInvadeTimer = Number(_loc3_[1]);
      this.api.datacenter.Temporis.currentAreaInvadeLevel = Number(_loc3_[2]);
   }
   function onUpgradeFinished(sPacket, succeed)
   {
      var _loc4_ = this.api.ui.getUIComponent("Temporis");
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      if(succeed)
      {
         _loc4_.getCurrentTab().itemUpgrader.updateOnSucceed();
      }
      else
      {
         _loc4_.getCurrentTab().itemUpgrader.updateOnFailed();
      }
   }
   function onUpgradePreview(sPacket)
   {
      var _loc3_ = this.api.ui.getUIComponent("Temporis");
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sPacket.split("|");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = this.api.kernel.CharactersManager.getItemObjectFromData(_loc4_[1]);
      var _loc7_ = Number(_loc4_[2]);
      var _loc8_ = Number(_loc4_[3]);
      this.api.datacenter.Temporis.actualUpgradeRecipe = {preview:_loc6_,cost:_loc7_,proba:_loc8_};
      _loc3_.getCurrentTab().itemUpgrader.placeMasterItem(_loc5_);
      _loc3_.getCurrentTab().updateDataView();
   }
   function onInvadeList(sPacket)
   {
      var _loc3_ = this.api.ui.getUIComponent("Temporis");
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sPacket.split("|");
      var _loc5_ = Number(_loc4_.shift());
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      while(_loc7_ < _loc4_.length)
      {
         _loc8_ = _loc4_[_loc7_].split(";");
         _loc9_ = {};
         _loc9_.id = _loc7_ + 1;
         _loc9_.areaId = _loc8_[0].split(",");
         _loc9_.completionLevel = Number(_loc8_[1]);
         _loc9_.invadeLevel = Number(_loc8_[2]);
         _loc9_.active = Number(_loc8_[3]) == 1;
         _loc9_.remainingTime = Number(_loc8_[4]);
         _loc6_.push(_loc9_);
         _loc7_ = _loc7_ + 1;
      }
      this.api.datacenter.Temporis.invadeAreas = _loc6_;
      this.api.datacenter.Temporis.actualInvade = _loc5_;
      _loc3_.updateCurrentTabInformations();
   }
   function onInvadeRanks(sPacket)
   {
      var _loc3_ = this.api.ui.getUIComponent("Temporis");
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sPacket.split("|");
      var _loc5_ = _loc4_.shift().split(";");
      var _loc6_ = {rank:(Number(_loc5_[0]) != 0 ? "#" + _loc5_[0] : "-"),breed:_loc5_[1],name:_loc5_[2],score:(Number(_loc5_[3]) != 0 ? _loc5_[3] : "-")};
      var _loc7_ = new ank.utils.ExtendedArray();
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      while(_loc8_ < _loc4_.length)
      {
         _loc9_ = _loc4_[_loc8_].split(";");
         _loc10_ = {};
         _loc10_.rank = "#" + _loc9_[0];
         _loc10_.breed = _loc9_[1];
         _loc10_.name = _loc9_[2];
         _loc10_.score = Number(_loc9_[3]);
         _loc7_.push(_loc10_);
         _loc8_ = _loc8_ + 1;
      }
      this.api.datacenter.Temporis.invadeRanks = _loc7_;
      this.api.datacenter.Temporis.invadePlayerInfo = _loc6_;
      _loc3_.getCurrentTab().updateRanking();
   }
   function onDungeonList(sPacket)
   {
      var _loc3_ = this.api.ui.getUIComponent("Temporis");
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sPacket.split("|");
      var _loc5_ = _loc4_.shift().split(";");
      var _loc6_ = [(Number(_loc5_[0]) < 10 ? "0" : "") + _loc5_[0],(Number(_loc5_[1]) < 10 ? "0" : "") + _loc5_[1],_loc5_[2],(Number(_loc5_[3]) < 10 ? "0" : "") + _loc5_[3],(Number(_loc5_[4]) < 10 ? "0" : "") + _loc5_[4]];
      this.api.datacenter.Temporis.dungeonLadderDate = _loc6_;
      var _loc7_ = new ank.utils.ExtendedArray();
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      while(_loc8_ < _loc4_.length)
      {
         _loc9_ = _loc4_[_loc8_].split(";");
         _loc10_ = {};
         _loc10_.id = Number(_loc9_[0]);
         _loc10_.dungeonID = _loc9_[1];
         _loc10_.dungeonLevel = Number(_loc9_[2]);
         _loc10_.keyId = Number(_loc9_[3]);
         _loc10_.accessible = Number(_loc9_[4]) == 1;
         _loc10_.unlocked = Number(_loc9_[5]) == 1;
         _loc10_.completed = Number(_loc9_[6]) == 1;
         _loc7_.push(_loc10_);
         _loc8_ = _loc8_ + 1;
      }
      this.api.datacenter.Temporis.dungeons = _loc7_;
      _loc3_.updateCurrentTabInformations();
   }
   function onDungeonRanks(sPacket)
   {
      var _loc3_ = this.api.ui.getUIComponent("Temporis");
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sPacket.split("|");
      var _loc5_ = _loc4_.shift().split(";");
      var _loc6_ = {rank:(Number(_loc5_[0]) != 0 ? "#" + _loc5_[0] : "-"),breed:_loc5_[1],name:_loc5_[2],score:(Number(_loc5_[3]) != 0 ? _loc5_[3] : "-")};
      var _loc7_ = new ank.utils.ExtendedArray();
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      while(_loc8_ < _loc4_.length)
      {
         _loc9_ = _loc4_[_loc8_].split(";");
         _loc10_ = {};
         _loc10_.rank = "#" + _loc9_[0];
         _loc10_.breed = _loc9_[1];
         _loc10_.name = _loc9_[2];
         _loc10_.score = Number(_loc9_[3]);
         _loc7_.push(_loc10_);
         _loc8_ = _loc8_ + 1;
      }
      this.api.datacenter.Temporis.dungeonRanks = _loc7_;
      this.api.datacenter.Temporis.dungeonPlayerInfo = _loc6_;
      _loc3_.getCurrentTab().updateRanking();
   }
}
