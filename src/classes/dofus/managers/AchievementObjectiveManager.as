class dofus.managers.AchievementObjectiveManager
{
   function AchievementObjectiveManager()
   {
   }
   static function getObjectiveName(nType, oChallengeParams)
   {
      var _loc4_ = _global.API;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(nType)
      {
         case 1:
         case 2:
         case 3:
         case 5:
            return _loc4_.lang.getMonstersText(oChallengeParams.monsters[0]).n;
         case 4:
            return _loc4_.lang.getAchievement(oChallengeParams.achievement).n;
         case 9:
            return _loc4_.lang.getQuest(oChallengeParams.quest).n;
         case 10:
            return _loc4_.lang.getText("MISSION_CATEGORY_" + oChallengeParams.category);
         case 11:
            return _loc4_.lang.getText("LEVEL") + " " + oChallengeParams.level;
         case 13:
            _loc5_ = oChallengeParams.points;
            _loc6_ = ank.utils.PatternDecoder.combine(_loc4_.lang.getText("POINTS",[_loc5_]),null,_loc5_ <= 1);
            return _loc6_;
         case 15:
            return _loc4_.lang.getMapSubAreaName(oChallengeParams.subarea);
         case 26:
            _loc7_ = _loc4_.lang.getDailyQuestID(oChallengeParams.pool[0]);
            return _loc4_.lang.getQuest(_loc7_).n;
         case 27:
            _loc8_ = _loc4_.lang.getText("ITEM_CHARACTERISTICS").split(",")[22];
            return _loc8_ + " " + oChallengeParams.level;
         case 31:
         case 32:
            return _loc4_.lang.getMountText(oChallengeParams.model).n;
         case 99:
            return _loc4_.lang.getFightChallenge(oChallengeParams.challenge).n;
         default:
            return String(dofus.managers.AchievementObjectiveManager.getCount(oChallengeParams));
      }
   }
   static function updateFinishedState(oObjective)
   {
      if(oObjective.isCountType)
      {
         oObjective.isFinished = oObjective.progression == dofus.managers.AchievementObjectiveManager.getCount(oObjective.parameters);
      }
      else
      {
         oObjective.isFinished = oObjective.progression == 1;
      }
   }
   static function getCount(oChallengeParams)
   {
      var _loc3_ = 0;
      if(oChallengeParams.count != undefined)
      {
         _loc3_ = Number(oChallengeParams.count);
      }
      else if(oChallengeParams.points != undefined)
      {
         _loc3_ = Number(oChallengeParams.points);
      }
      return _loc3_;
   }
}
