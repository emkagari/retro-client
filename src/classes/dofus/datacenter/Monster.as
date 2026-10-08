class dofus.datacenter.Monster extends dofus.datacenter.PlayableCharacter
{
   var CharacteristicsManager;
   var _gfxID;
   var _nColor1;
   var _nColor2;
   var _nColor3;
   var _nNameID;
   var _nPowerLevel;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var api;
   var dispatchEvent;
   var refreshGfxFileName;
   static var MONSTER_CATEGORY_SOLO_BOSS = 1;
   static var MONSTER_CATEGORY_MINI_BOSS = 78;
   static var CHAT_PREFIX = "m";
   var _nSpeedModerator = 1;
   function Monster(sID, clipClass, sGfxFile, cellNum, dir, gfxID)
   {
      super();
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
      this.name = sID;
   }
   static function isMiniBossCategory(nCategory)
   {
      return nCategory == dofus.datacenter.Monster.MONSTER_CATEGORY_MINI_BOSS;
   }
   static function getMonsterIDSoulPriority(aMonsterID)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < aMonsterID.length)
      {
         _loc4_ = new dofus.datacenter.Monster(aMonsterID[_loc3_]);
         if(_loc4_.isBoss || _loc4_.isArchmonster)
         {
            return aMonsterID[_loc3_];
         }
         _loc3_ = _loc3_ + 1;
      }
      return aMonsterID[0];
   }
   function set name(nNameID)
   {
      this._nNameID = Number(nNameID);
   }
   function get name()
   {
      return this.api.lang.getMonstersText(this._nNameID).n;
   }
   function get gfxID()
   {
      return this._gfxID == undefined ? this.api.lang.getMonstersText(this._nNameID).g : this._gfxID;
   }
   function get kickable()
   {
      return this.api.lang.getMonstersText(this._nNameID).k;
   }
   function get category()
   {
      return this.api.lang.getMonstersText(this._nNameID).b;
   }
   function get categoryName()
   {
      return this.api.lang.getMonstersRaceText(this.category).n;
   }
   function set powerLevel(nPowerLevel)
   {
      this._nPowerLevel = Number(nPowerLevel);
   }
   function get powerLevel()
   {
      return this._nPowerLevel;
   }
   function get Level()
   {
      return this.api.lang.getMonstersText(this._nNameID)["g" + this._nPowerLevel].l;
   }
   function getLevelFromGrade(nGrade)
   {
      return this.api.lang.getMonstersText(this._nNameID)["g" + nGrade].l;
   }
   function get isBoss()
   {
      return this.api.lang.getMonstersText(this._nNameID).d;
   }
   function get isArchmonster()
   {
      return dofus.datacenter.Monster.MONSTER_CATEGORY_MINI_BOSS == this.category;
   }
   function get alternateMonsterID()
   {
      return this.api.lang.getMonstersText(this._nNameID).t;
   }
   function get spawn()
   {
      return this.api.lang.getMonstersText(this._nNameID).spawn;
   }
   function onResistancesUpdated()
   {
      this.dispatchEvent({type:"resistancesChanged"});
   }
   function get resistances()
   {
      var _loc2_ = this.api.lang.getMonstersText(this._nNameID)["g" + this._nPowerLevel].r;
      var _loc3_ = [];
      var _loc4_ = 0;
      while(_loc4_ < _loc2_.length)
      {
         _loc3_[_loc4_] = _loc2_[_loc4_];
         _loc4_ = _loc4_ + 1;
      }
      _loc3_[0] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT);
      _loc3_[1] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT);
      _loc3_[2] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT);
      _loc3_[3] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT);
      _loc3_[4] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT);
      _loc3_[5] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PA_LOST_PROBABILITY);
      _loc3_[6] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PM_LOST_PROBABILITY);
      return _loc3_;
   }
   function get alignment()
   {
      return new dofus.datacenter.Alignment(this.api.lang.getMonstersText(this._nNameID).a,0);
   }
   function get circleFilePath()
   {
      if(this.isBoss || this.isArchmonster)
      {
         return dofus.Constants.CIRCLE_BOSS_FILE;
      }
      return super.circleFilePath;
   }
   function get creatureGfxFile()
   {
      if(this._sCreatureGfxFile != undefined)
      {
         return this._sCreatureGfxFile;
      }
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH;
      if(this.isBoss || this.isArchmonster)
      {
         _loc2_ += "901.swf";
      }
      else
      {
         _loc2_ += "900.swf";
      }
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
   function get canSwitchInCreaturesMode()
   {
      return this.api.datacenter.Game.isFight;
   }
   function get color1()
   {
      return this._nColor1 == undefined ? this.api.lang.getMonstersText(this._nNameID).colors.c1 : this._nColor1;
   }
   function get color2()
   {
      return this._nColor2 == undefined ? this.api.lang.getMonstersText(this._nNameID).colors.c2 : this._nColor2;
   }
   function get color3()
   {
      return this._nColor3 == undefined ? this.api.lang.getMonstersText(this._nNameID).colors.c3 : this._nColor3;
   }
   function get accessories()
   {
      if(super.accessories == undefined)
      {
         return this.api.lang.getMonstersText(this._nNameID).colors.acc;
      }
      return super.accessories;
   }
   function set accessories(value_)
   {
      super.accessories = value_;
   }
   function alertChatText()
   {
      var _loc2_ = this.api.datacenter.Map;
      return this.name + " niveau " + this.Level + " en " + _loc2_.x + "," + _loc2_.y + ".";
   }
   function getSpells(sGrade)
   {
      return this.api.lang.getMonstersText(this._nNameID)[sGrade].s;
   }
}
