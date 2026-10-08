class dofus.datacenter.Creature extends dofus.datacenter.PlayableCharacter
{
   var CharacteristicsManager;
   var _aResistances;
   var _gfxID;
   var _nNameID;
   var _nPowerLevel;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var api;
   var dispatchEvent;
   var refreshGfxFileName;
   var _bHasAlreadyAppeared = false;
   function Creature(sID, clipClass, sGfxFile, cellNum, dir, gfxID)
   {
      super();
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
   }
   function set name(nNameID)
   {
      this._nNameID = Number(nNameID);
   }
   function get name()
   {
      return this.api.lang.getMonstersText(this._nNameID).n;
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
   function onResistancesUpdated()
   {
      this.dispatchEvent({type:"resistancesChanged"});
   }
   function set resistances(aResistances)
   {
      this._aResistances = aResistances;
   }
   function get startAnimation()
   {
      return !this._bHasAlreadyAppeared ? "appear" : super.startAnimation;
   }
   function get resistances()
   {
      var _loc2_ = !this._aResistances ? this.api.lang.getMonstersText(this._nNameID)["g" + this._nPowerLevel].r : this._aResistances;
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
   function get isCawotte()
   {
      return this._gfxID == 1277;
   }
   function get isTree()
   {
      return this._gfxID == 1183 || (this._gfxID == 9369 || this._gfxID == 1974);
   }
   function get alignment()
   {
      return new dofus.datacenter.Alignment(this.api.lang.getMonstersText(this._nNameID).a,0);
   }
   function get circleFilePath()
   {
      return dofus.Constants.CIRCLE_CREATURE_FILE;
   }
   function get canSwitchInCreaturesMode()
   {
      return this.api.datacenter.Game.isFight;
   }
   function get creatureGfxFile()
   {
      if(this._sCreatureGfxFile != undefined)
      {
         return this._sCreatureGfxFile;
      }
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH;
      if(this.isCawotte)
      {
         _loc2_ += "904.swf";
      }
      else if(this.isTree)
      {
         _loc2_ += "905.swf";
      }
      else if(this.isSummoned)
      {
         if(this.Team == this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team)
         {
            _loc2_ += "902.swf";
         }
         else
         {
            _loc2_ += "903.swf";
         }
      }
      else
      {
         _loc2_ += "906.swf";
      }
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
}
