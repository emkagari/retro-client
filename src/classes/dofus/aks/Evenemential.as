class dofus.aks.Evenemential extends dofus.aks.Handler
{
   var aks;
   var api;
   function Evenemential(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function sendAskWorldUniqueDropsStates()
   {
      this.aks.send("YD");
   }
   function sendRollDice(nDicesCount, nDiceMaxValue, sChatChannelSymbol)
   {
      this.aks.send("Yd" + nDicesCount + "|" + nDiceMaxValue + "|" + sChatChannelSymbol);
   }
   function onSeasonScore(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Season.score = _loc3_;
   }
   function onSeasonData(sExtraData)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = 0;
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = _loc4_[_loc6_].split(";");
         _loc8_ = new Object();
         _loc8_.score = Number(_loc7_[0]);
         _loc8_.previsousStep = _loc5_;
         _loc8_.items = [];
         _loc9_ = _loc7_[1].split(",");
         _loc10_ = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc11_ = _loc9_[_loc10_].split(":");
            _loc12_ = Number(_loc11_[0]);
            _loc13_ = Number(_loc11_[1]);
            _loc14_ = new dofus.datacenter.Item(undefined,_loc12_,_loc13_,undefined,String(this.api.lang.getItemStats(_loc12_)));
            _loc8_.items.push(_loc14_);
            _loc10_ = _loc10_ + 1;
         }
         _loc3_.push(_loc8_);
         _loc5_ = _loc8_.score;
         _loc6_ = _loc6_ + 1;
      }
      this.api.datacenter.Season.rewards = _loc3_;
   }
   function onWorldUniqueDropsStates(sExtraData)
   {
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_].split(";");
         _loc7_ = Number(_loc6_[0]);
         _loc8_ = _loc6_[1] == "1";
         _loc9_ = new dofus.datacenter.evenemential.WorldUniqueDropState(_loc7_,_loc8_);
         _loc3_.addItemAt(_loc7_,_loc9_);
         _loc5_ = _loc5_ + 1;
      }
      this.api.datacenter.Basics.worldUniqueDropsStates = _loc3_;
   }
   function onDicesRollResult(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0] == "E";
      var _loc5_;
      if(_loc4_)
      {
         _loc5_ = _loc3_[1];
         _loc3_ = _loc3_.slice(2);
         this.api.kernel.showMessage(undefined,this.api.lang.getText(_loc5_,_loc3_),"ERROR_CHAT");
         return undefined;
      }
      var _loc6_ = _loc3_[1];
      var _loc7_ = _loc3_[2];
      var _loc8_ = Number(_loc3_[3]);
      var _loc9_ = Number(_loc3_[4]);
      var _loc10_ = Number(_loc3_[5]);
      var _loc11_ = _loc3_.length <= 6 ? "" : "(" + this.api.lang.getText(_loc3_[6]) + ") ";
      var _loc12_ = this.api.kernel.ChatManager.getLinkName(_loc6_,_loc7_);
      var _loc13_ = this.api.kernel.DebugManager.getTimestampShort() + " " + _loc11_ + this.api.lang.getText("DICE_LAUNCH_RESULT",[_loc12_,_loc8_,_loc9_,_loc10_]);
      this.api.kernel.showMessage(undefined,_loc13_,"INFO_CHAT");
   }
}
