class dofus.datacenter.Character extends dofus.datacenter.PlayableCharacter
{
   var CharacteristicsManager;
   var _aMultiCraftSkillsID;
   var _aResistances;
   var _bCraftPublicMode;
   var _bDied;
   var _bHasTtgCollection;
   var _nAuraLevel;
   var _nRestrictions;
   var _nServerID;
   var _nSex;
   var _nSpeedModerator;
   var _oAlignment;
   var _oCharacterTitle;
   var _oEmblem;
   var _oRank;
   var _sCharacterTitle;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var _sGuildName;
   var api;
   var dispatchEvent;
   var gfxFileName;
   var refreshGfxFileName;
   static var MAX_NEUTRAL_RESISTANCE_MIXED = 50;
   static var MAX_EARTH_RESISTANCE_MIXED = 50;
   static var MAX_WATER_RESISTANCE_MIXED = 50;
   static var MAX_FIRE_RESISTANCE_MIXED = 50;
   static var MAX_AIR_RESISTANCE_MIXED = 50;
   var xtraClipTopAnimations = {staticF:true};
   function Character(sID, clipClass, sGfxFile, cellNum, dir, gfxID, title)
   {
      super();
      this._oCharacterTitle = title;
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
   }
   function get speedModerator()
   {
      var _loc2_ = this._nSpeedModerator;
      if(this._nAuraValue)
      {
         _loc2_ /= 2;
      }
      else if(this._bIsMerchant)
      {
         _loc2_ *= 5;
      }
      return _loc2_;
   }
   function get hasTtgCollection()
   {
      return this._bHasTtgCollection;
   }
   function set hasTtgCollection(bHasTtgCollection)
   {
      this._bHasTtgCollection = bHasTtgCollection;
   }
   function get Guild()
   {
      return this._bCraftPublicMode;
   }
   function set Guild(value)
   {
      this._bCraftPublicMode = Number(value);
   }
   function get Sex()
   {
      return this._nSex;
   }
   function set Sex(value)
   {
      this._nSex = Number(value);
   }
   function get Aura()
   {
      return this._nAuraLevel;
   }
   function set Aura(value)
   {
      this._nAuraLevel = Number(value);
   }
   function get alignment()
   {
      return this._oAlignment;
   }
   function set alignment(value)
   {
      this._oAlignment = value;
   }
   function get Merchant()
   {
      return this._sCharacterTitle;
   }
   function set Merchant(value_)
   {
      this._sCharacterTitle = value_;
   }
   function get serverID()
   {
      return this._nServerID;
   }
   function set serverID(value)
   {
      this._nServerID = value;
   }
   function get multiCraftSkills()
   {
      return this._aMultiCraftSkillsID;
   }
   function set multiCraftSkills(value)
   {
      this._aMultiCraftSkillsID = value;
   }
   function get rank()
   {
      return this._oRank;
   }
   function set rank(value)
   {
      this._oRank = value;
   }
   function get multiCraftSkillsID()
   {
      return this._bDied;
   }
   function set multiCraftSkillsID(value)
   {
      this._bDied = value;
   }
   function set guildName(sGuildName)
   {
      this._sGuildName = sGuildName;
   }
   function get guildName()
   {
      return this._sGuildName;
   }
   function get title()
   {
      return this._oCharacterTitle;
   }
   function set emblem(oEmblem)
   {
      this._oEmblem = oEmblem;
   }
   function get emblem()
   {
      return this._oEmblem;
   }
   function set restrictions(nRestrictions)
   {
      this._nRestrictions = Number(nRestrictions);
   }
   function get canBeAssault()
   {
      return (this._nRestrictions & 1) != 1;
   }
   function get canBeChallenge()
   {
      return (this._nRestrictions & 2) != 2;
   }
   function get canExchange()
   {
      return (this._nRestrictions & 4) != 4;
   }
   function get canBeAttack()
   {
      return (this._nRestrictions & 8) != 8;
   }
   function get forceWalk()
   {
      return (this._nRestrictions & 0x10) == 16;
   }
   function get _nAuraValue()
   {
      return (this._nRestrictions & 0x20) == 32;
   }
   function get canSwitchInCreaturesMode()
   {
      return (this._nRestrictions & 0x40) != 64;
   }
   function get isTomb()
   {
      return (this._nRestrictions & 0x80) == 128;
   }
   function get _bIsMerchant()
   {
      return (this._nRestrictions & 0x0100) == 256;
   }
   function onResistancesUpdated()
   {
      this.dispatchEvent({type:"resistancesChanged"});
   }
   function set resistances(aResistances)
   {
      this._aResistances = aResistances;
   }
   function get resistances()
   {
      var _loc2_ = [];
      var _loc3_ = 0;
      while(_loc3_ < this._aResistances.length)
      {
         _loc2_[_loc3_] = this._aResistances[_loc3_];
         _loc3_ = _loc3_ + 1;
      }
      _loc2_[0] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT);
      _loc2_[1] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT);
      _loc2_[2] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT);
      _loc2_[3] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT);
      _loc2_[4] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT);
      if(_loc2_.length > 7)
      {
         _loc2_[10] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PA_LOST_PROBABILITY);
         _loc2_[11] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PM_LOST_PROBABILITY);
      }
      else
      {
         _loc2_[5] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PA_LOST_PROBABILITY);
         _loc2_[6] += this.CharacteristicsManager.getModeratorValue(dofus.managers.CharacteristicsManager.DODGE_PM_LOST_PROBABILITY);
      }
      _loc2_[0] = Math.min(_loc2_[0],dofus.datacenter.Character.MAX_NEUTRAL_RESISTANCE_MIXED);
      _loc2_[1] = Math.min(_loc2_[1],dofus.datacenter.Character.MAX_EARTH_RESISTANCE_MIXED);
      _loc2_[2] = Math.min(_loc2_[2],dofus.datacenter.Character.MAX_FIRE_RESISTANCE_MIXED);
      _loc2_[3] = Math.min(_loc2_[3],dofus.datacenter.Character.MAX_WATER_RESISTANCE_MIXED);
      _loc2_[4] = Math.min(_loc2_[4],dofus.datacenter.Character.MAX_AIR_RESISTANCE_MIXED);
      return _loc2_;
   }
   function get creatureGfxFile()
   {
      if(this._sCreatureGfxFile != undefined)
      {
         return this._sCreatureGfxFile;
      }
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH;
      if(this.api.datacenter.Map.isGladiatrool)
      {
         _loc2_ += this.gfxFileName.substr(0,this.gfxFileName.length - 1) + "2.swf";
      }
      else
      {
         _loc2_ += this.Guild + "2.swf";
      }
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
}
