class dofus.datacenter.FightChallengeData extends Object
{
   var _sDescription;
   var _sName;
   var achievements;
   var api;
   var category;
   var iconPath;
   var id;
   var params;
   var state;
   var targetId;
   var targetSpriteId;
   static var ACHIEVEMENT_CATEGORY_INDEX = 2;
   function FightChallengeData(nObjectID, showTarget, targetId, category, state, oChallengeParams)
   {
      super();
      this.api = _global.API;
      this.id = nObjectID;
      this._sName = this.api.lang.getFightChallenge(nObjectID).n;
      this.targetId = showTarget;
      this.targetSpriteId = targetId;
      this.category = category;
      this.params = oChallengeParams;
      this.state = state;
      var _loc9_ = this.api.datacenter.Sprites.getItemAt(targetId).name + " (" + this.api.lang.getText("LEVEL_SMALL") + " " + this.api.datacenter.Sprites.getItemAt(targetId).mc.data.Level + ")";
      this._sDescription = this.api.lang.getFightChallenge(nObjectID).d.split("%1").join(_loc9_);
      this.iconPath = dofus.Constants.FIGHT_CHALLENGE_PATH + this.api.lang.getFightChallenge(nObjectID).g + ".swf";
   }
   function get name()
   {
      var _loc2_ = this._sName;
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      var _loc2_ = "";
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(this.category == dofus.datacenter.FightChallengeData.ACHIEVEMENT_CATEGORY_INDEX)
      {
         _loc3_ = 0;
         while(_loc3_ < this.achievements.length)
         {
            _loc4_ = String(this.achievements[_loc3_]);
            _loc5_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(_loc4_);
            _loc2_ += this.api.lang.getText("ACHIEVEMENT") + " : " + _loc5_.name + "\n";
            _loc3_ = _loc3_ + 1;
         }
         _loc2_ += "\n";
      }
      return _loc2_ + this._sDescription;
   }
   function get basicXpBonus()
   {
      return this.params[0];
   }
   function get teamXpBonus()
   {
      return this.params[1];
   }
   function get basicDropBonus()
   {
      return this.params[2];
   }
   function get teamDropBonus()
   {
      return this.params[3];
   }
   function get canOpenAchievement()
   {
      return this.achievements.length == 1;
   }
   function clone()
   {
      var _loc2_ = new dofus.datacenter.FightChallengeData(this.id,this.targetId,this.targetSpriteId,this.category,this.state,this.params);
      _loc2_.achievements = this.achievements;
      return _loc2_;
   }
}
