class dofus.aks.Quests extends dofus.aks.Handler
{
   var aks;
   var api;
   function Quests(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function getList()
   {
      this.api.datacenter.Player.questBook = new dofus.datacenter.QuestBook();
      this.aks.send("QL");
   }
   function getStep(nQuestID, nDelta)
   {
      this.aks.send("QS" + nQuestID + (nDelta == undefined ? "" : "|" + (nDelta <= 0 ? nDelta : "+" + nDelta)));
   }
   function getDailies()
   {
      this.aks.send("QD",true);
   }
   function onList(sExtraData)
   {
      var _loc3_ = sExtraData;
      var _loc4_ = 0;
      var _loc5_ = [];
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      if(sExtraData.length != 0)
      {
         _loc6_ = sExtraData.split("|");
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = _loc6_[_loc7_].split(";");
            _loc9_ = Number(_loc8_[0]);
            _loc10_ = _loc8_[1] == "1";
            _loc11_ = Number(_loc8_[2]);
            _loc12_ = _loc8_[3] == "1";
            _loc13_ = _loc8_[4] == "1";
            if(!_loc10_)
            {
               _loc4_ = _loc4_ + 1;
            }
            _loc14_ = new dofus.datacenter.Quest(_loc9_,_loc10_,_loc11_,_loc12_,_loc13_);
            _loc5_.push(_loc14_);
            _loc7_ = _loc7_ + 1;
         }
      }
      this.api.datacenter.Player.questBook.quests.replaceAll(0,_loc5_);
      this.api.ui.getUIComponent("Quests").setPendingCount(_loc4_);
   }
   function onStep(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0].split(";");
      var _loc5_ = Number(_loc4_[0]);
      var _loc6_ = _loc4_[1] == "1";
      var _loc7_ = _loc4_[2] == "1";
      var _loc8_ = Number(_loc3_[1]);
      var _loc9_ = _loc3_[2];
      var _loc10_ = new ank.utils.ExtendedArray();
      var _loc11_ = _loc3_[3];
      var _loc12_ = _loc11_.length != 0 ? _loc11_.split(";") : [];
      _loc12_.reverse();
      var _loc13_ = _loc3_[4];
      var _loc14_ = _loc13_.length != 0 ? _loc13_.split(";") : [];
      var _loc15_ = _loc3_[5].split(";");
      var _loc16_ = _loc15_[0];
      var _loc17_ = _loc15_[1].split(",");
      var _loc18_ = _loc9_.split(";");
      var _loc19_ = 0;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      while(_loc19_ < _loc18_.length)
      {
         _loc20_ = _loc18_[_loc19_].split(",");
         _loc21_ = Number(_loc20_[0]);
         _loc22_ = _loc20_[1] == "1";
         _loc23_ = new dofus.datacenter.QuestObjective(_loc21_,_loc22_);
         _loc10_.push(_loc23_);
         _loc19_ = _loc19_ + 1;
      }
      var _loc24_ = this.api.datacenter.Player.questBook;
      var _loc25_ = _loc24_.getQuest(_loc5_);
      var _loc26_;
      if(_loc25_ != null)
      {
         _loc26_ = new dofus.datacenter.QuestStep(_loc8_,1,_loc6_,_loc7_,_loc10_,_loc12_,_loc14_,_loc16_,_loc17_);
         _loc25_.addStep(_loc26_);
         this.api.ui.getUIComponent("Quests").setStep(_loc26_);
      }
      else
      {
         ank.utils.Logger.err("[onStep] Impossible de trouver l\'objet de quête");
      }
   }
   function onDailies(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      this.api.datacenter.DailyQuests.timeReset = Number(_loc3_[0]);
      this.api.datacenter.DailyQuests.missionType = Number(_loc3_[1]);
      this.api.datacenter.DailyQuests.missionFinished = _loc3_[2] == "1";
      this.api.datacenter.DailyQuests.completedTask = Number(_loc3_[3]);
      var _loc4_ = {};
      var _loc5_ = _loc3_[4].split(",");
      var _loc6_ = _loc5_.length - 1;
      var _loc7_;
      while(_loc6_ >= 0)
      {
         _loc7_ = _loc5_[_loc6_].split(":");
         _loc4_[_loc7_[0]] = _loc7_[1];
         _loc6_ = _loc6_ - 1;
      }
      this.api.datacenter.DailyQuests.questState = _loc4_;
      this.api.ui.getUIComponent("Quests").updateDaylies();
   }
}
