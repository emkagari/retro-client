class dofus.datacenter.Spell extends Object
{
   var _aEffectZones;
   var _aForbiddenStates;
   var _aRequiredStates;
   var _bInFrontOfSprite;
   var _bSummonSpell;
   var _hasInvocationConditionnedEffectCache;
   var _minPlayerLevel;
   var _nAnimID;
   var _nID;
   var _nLevel;
   var _nMaxLevel;
   var _nPassivePosition;
   var _nPosition;
   var _oIconProperties;
   var _oSpellText;
   var api;
   var _nFlags = 0;
   function Spell(nID, nLevel, sCompressedPosition)
   {
      super();
      this.initialize(nID,nLevel,sCompressedPosition);
   }
   function get ID()
   {
      return this._nID;
   }
   function get iconProperties()
   {
      return this._oIconProperties;
   }
   function get flags()
   {
      return this._nFlags;
   }
   function set flags(nFlags)
   {
      this._nFlags = nFlags;
   }
   function get isUndeletable()
   {
      return (this._nFlags & 1) == 1;
   }
   function get isValid()
   {
      return this._oSpellText["l" + this._nLevel] != undefined;
   }
   function get maxLevel()
   {
      return this._nMaxLevel;
   }
   function set level(nLevel)
   {
      this._nLevel = nLevel;
   }
   function get level()
   {
      return this._nLevel;
   }
   function set position(nPosition)
   {
      this._nPosition = nPosition;
   }
   function get position()
   {
      return this._nPosition;
   }
   function set inFrontOfSprite(bInFrontOfSprite_)
   {
      this._bInFrontOfSprite = bInFrontOfSprite_;
   }
   function get inFrontOfSprite()
   {
      return this._bInFrontOfSprite;
   }
   function get summonSpell()
   {
      return this._bSummonSpell;
   }
   function get glyphSpell()
   {
      return this.searchIfGlyph(this.getSpellLevelText(0));
   }
   function get trapSpell()
   {
      return this.searchIfTrap(this.getSpellLevelText(0));
   }
   function set animID(nAnimID)
   {
      this._nAnimID = nAnimID;
   }
   function get animID()
   {
      return this._nAnimID;
   }
   function get iconFile()
   {
      return "SpellFullIcon";
   }
   function get params()
   {
      return {spell:this,spellID:this.ID,breedID:this.api.datacenter.Player.Guild};
   }
   function get forceReloadOnContainer()
   {
      return true;
   }
   function get file()
   {
      return dofus.Constants.SPELLS_PATH + this._bInFrontOfSprite + ".swf";
   }
   function get name()
   {
      var _loc2_ = this._oSpellText.n;
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.ID + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      return this._oSpellText.d;
   }
   function get isOwnedByPlayer()
   {
      return this.api.datacenter.Player.isSpellOwned(this.ID);
   }
   function get apCost()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_AP_COST,this._nID);
      var _loc3_ = this.getSpellLevelText(2);
      if(_loc2_ > -1)
      {
         return _loc3_ - _loc2_;
      }
      return _loc3_;
   }
   function get rangeMin()
   {
      var _loc2_ = this.getSpellLevelText(3);
      if(_loc2_ == undefined)
      {
         _loc2_ = 0;
      }
      return _loc2_;
   }
   function get rangeMax()
   {
      var _loc2_ = this.getSpellLevelText(4);
      var _loc3_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGE_NO_RANGEABLE_TRIGGER,this._nID);
      if(_loc3_ > -1)
      {
         _loc2_ += _loc3_;
      }
      var _loc4_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGE,this._nID);
      if(_loc4_ > -1)
      {
         _loc2_ += _loc4_;
      }
      return _loc2_;
   }
   function get rangeModerator()
   {
      return !this.canBoostRange ? 0 : this.api.datacenter.Player.data.CharacteristicsManager.getModeratorValue(19) + this.api.datacenter.Player.RangeModerator;
   }
   function get rangeStr()
   {
      return (this.rangeMin == 0 ? "" : this.rangeMin + " " + this.api.lang.getText("TO_RANGE") + " ") + this.rangeMax;
   }
   function get criticalHit()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CC,this._nID);
      var _loc3_ = this.getSpellLevelText(5);
      if(_loc2_ > -1)
      {
         return _loc3_ <= 0 ? 0 : Math.max(_loc3_ - _loc2_,2);
      }
      return _loc3_;
   }
   function get actualCriticalHit()
   {
      return this.api.kernel.GameManager.getCriticalHitChance(this.criticalHit);
   }
   function get criticalFailure()
   {
      return this.getSpellLevelText(6);
   }
   function get lineOnly()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CASTOUTLINE,this._nID);
      var _loc3_ = this.getSpellLevelText(7);
      if(_loc2_ > 0)
      {
         return false;
      }
      return _loc3_;
   }
   function get lineOfSight()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_NOLINEOFSIGHT,this._nID);
      var _loc3_ = this.getSpellLevelText(8);
      if(_loc2_ > 0)
      {
         return false;
      }
      return _loc3_;
   }
   function get freeCell()
   {
      return this.getSpellLevelText(9);
   }
   function get canBoostRange()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGEABLE,this._nID);
      var _loc3_ = this.getSpellLevelText(10);
      if(_loc2_ > 0)
      {
         return true;
      }
      return _loc3_;
   }
   function get classID()
   {
      return this.getSpellLevelText(11);
   }
   function get launchCountByTurn()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_MAXPERTURN,this._nID);
      var _loc3_ = this.getSpellLevelText(12);
      if(_loc3_ == undefined)
      {
         _loc3_ = 0;
      }
      if(_loc2_ > -1)
      {
         return _loc3_ + _loc2_;
      }
      return _loc3_;
   }
   function get launchCountByPlayerTurn()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_MAXPERTARGET,this._nID);
      var _loc3_ = this.getSpellLevelText(13);
      if(_loc3_ == undefined)
      {
         _loc3_ = 0;
      }
      if(_loc2_ > -1)
      {
         return _loc3_ + _loc2_;
      }
      return _loc3_;
   }
   function get delayBetweenLaunch()
   {
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CAST_INTVL,this._nID);
      var _loc3_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_SET_INTVL,this._nID);
      var _loc4_ = _loc3_ <= -1 ? this.getSpellLevelText(14) : _loc3_;
      if(_loc4_ == undefined)
      {
         _loc4_ = 0;
      }
      if(_loc2_ > -1)
      {
         return Math.max(0,_loc4_ - _loc2_);
      }
      return _loc4_;
   }
   function get descriptionNormalHit()
   {
      return this.api.kernel.GameManager.getSpellDescriptionWithEffects(this.getSpellLevelText(0),false,this._nID);
   }
   function get descriptionCriticalHit()
   {
      return this.api.kernel.GameManager.getSpellDescriptionWithEffects(this.getSpellLevelText(1),false,this._nID);
   }
   function get hasInvocationConditionnedEffect()
   {
      if(this._hasInvocationConditionnedEffectCache != undefined)
      {
         return this._hasInvocationConditionnedEffectCache;
      }
      var _loc2_ = false;
      var _loc3_ = this.effectsNormalHit;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_.hasInvocationConditions)
         {
            _loc2_ = true;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(!_loc2_)
      {
         _loc6_ = this.effectsCriticalHit;
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = _loc6_[_loc7_];
            if(_loc8_.hasInvocationConditions)
            {
               _loc2_ = true;
               break;
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      this._hasInvocationConditionnedEffectCache = _loc2_;
      return _loc2_;
   }
   function get effectsNormalHit()
   {
      return this.api.kernel.GameManager.getSpellEffects(this.getSpellLevelText(0),this._nID);
   }
   function get effectsCriticalHit()
   {
      return this.api.kernel.GameManager.getSpellEffects(this.getSpellLevelText(1),this._nID);
   }
   function get effectsNormalHitWithArea()
   {
      var _loc2_ = this.api.kernel.GameManager.getSpellEffects(this.getSpellLevelText(0),this._nID);
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc2_.length)
      {
         _loc6_ = {};
         _loc6_.fx = _loc2_[_loc5_];
         _loc6_.at = this._aEffectZones[_loc4_ + _loc5_].shape;
         _loc6_.ar = this._aEffectZones[_loc4_ + _loc5_].size;
         _loc3_.push(_loc6_);
         _loc5_ = _loc5_ + 1;
      }
      return _loc3_;
   }
   function get effectsCriticalHitWithArea()
   {
      var _loc2_ = this.api.kernel.GameManager.getSpellEffects(this.getSpellLevelText(1),this._nID);
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this.effectsNormalHit.length;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc2_.length)
      {
         _loc6_ = {};
         _loc6_.fx = _loc2_[_loc5_];
         _loc6_.at = this._aEffectZones[_loc4_ + _loc5_].shape;
         _loc6_.ar = this._aEffectZones[_loc4_ + _loc5_].size;
         _loc3_.push(_loc6_);
         _loc5_ = _loc5_ + 1;
      }
      return _loc3_;
   }
   function get requiredStates()
   {
      return this._aRequiredStates;
   }
   function get forbiddenStates()
   {
      return this._aForbiddenStates;
   }
   function get needStates()
   {
      return this._aRequiredStates.length > 0 || this._aForbiddenStates.length > 0;
   }
   function get minPlayerLevel()
   {
      return Number(this.getSpellLevelText(18));
   }
   function get normalMinPlayerLevel()
   {
      return Number(this.getSpellLevelText(18,1));
   }
   function get criticalFailureEndsTheTurn()
   {
      return this.getSpellLevelText(19);
   }
   function get levelID()
   {
      return this.getSpellLevelText(20);
   }
   function get spellBreed()
   {
      return this._oSpellText.b;
   }
   function get category()
   {
      return this._oSpellText.c;
   }
   function get rarity()
   {
      return this.getRarityByCategory(this.category);
   }
   function get type()
   {
      return this._oSpellText.t;
   }
   function get origin()
   {
      return this._oSpellText.o;
   }
   function get isPassive()
   {
      return this._oSpellText.p;
   }
   function get isCastGlobalInterval()
   {
      return this._oSpellText.g;
   }
   function getRarityByCategory(nCategory)
   {
      switch(nCategory)
      {
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_COMMON:
            return 1;
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_RARE:
            return 2;
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_EPIC:
            return 3;
         case dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_LEGENDARY:
            return 4;
         default:
            return -1;
      }
   }
   function get elements()
   {
      var _loc2_ = {none:false,neutral:false,earth:false,fire:false,water:false,air:false};
      var _loc3_ = this.effectsNormalHit;
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = _loc3_[k].element;
         switch(_loc4_)
         {
            case "N":
               _loc2_.neutral = true;
               break;
            case "E":
               _loc2_.earth = true;
               break;
            case "F":
               _loc2_.fire = true;
               break;
            case "W":
               _loc2_.water = true;
               break;
            case "A":
               _loc2_.air = true;
               break;
            default:
               _loc2_.none = true;
         }
      }
      return _loc2_;
   }
   function get effectZones()
   {
      return this._aEffectZones;
   }
   function initialize(nID, nLevel, sCompressedPosition)
   {
      this.api = _global.API;
      this._nID = nID;
      this._nLevel = nLevel;
      var _loc5_ = _global.parseInt(sCompressedPosition,16);
      if(_loc5_ > 31 || _loc5_ < 1)
      {
         _loc5_ = null;
      }
      this._oSpellText = this.api.lang.getSpellText(nID);
      if(this.isPassive)
      {
         this._nPosition = undefined;
         this._nPassivePosition = _loc5_;
      }
      else
      {
         this._nPosition = _loc5_;
      }
      this._oIconProperties = dofus.datacenter.SpellIconProperties.buildFromSpellText(this._oSpellText);
      var _loc6_ = this.getSpellLevelText(15);
      var _loc7_ = _loc6_.split("");
      this._aEffectZones = [];
      var _loc8_ = 0;
      while(_loc8_ < _loc7_.length)
      {
         this._aEffectZones.push({shape:_loc7_[_loc8_],size:ank.utils.Compressor.decode64(_loc7_[_loc8_ + 1])});
         _loc8_ += 2;
      }
      this._bSummonSpell = this.searchIfSummon(this.getSpellLevelText(0)) || this.searchIfSummon(this.getSpellLevelText(1));
      this._nMaxLevel = 1;
      var _loc9_ = 1;
      while(_loc9_ <= dofus.Constants.SPELL_BOOST_MAX_LEVEL)
      {
         if(this._oSpellText["l" + _loc9_] == undefined)
         {
            break;
         }
         this._nMaxLevel = _loc9_;
         _loc9_ = _loc9_ + 1;
      }
      this._aRequiredStates = this.getSpellLevelText(16);
      this._aForbiddenStates = this.getSpellLevelText(17);
      this._minPlayerLevel = this.normalMinPlayerLevel;
   }
   function getSpellLevelText(nPropertyIndex, nLevel)
   {
      if(nLevel == undefined)
      {
         nLevel = this._nLevel;
      }
      return this._oSpellText["l" + nLevel][nPropertyIndex];
   }
   function searchIfSummon(aEffects)
   {
      var _loc3_ = aEffects.length;
      var _loc4_;
      var _loc5_;
      if(typeof aEffects == "object")
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = aEffects[_loc4_][0];
            if(_loc5_ == 180 || _loc5_ == 181)
            {
               return true;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return false;
   }
   function searchIfGlyph(aEffects)
   {
      var _loc3_ = aEffects.length;
      var _loc4_;
      var _loc5_;
      if(typeof aEffects == "object")
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = aEffects[_loc4_][0];
            if(_loc5_ == 401)
            {
               return true;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return false;
   }
   function searchIfTrap(aEffects)
   {
      var _loc3_ = aEffects.length;
      var _loc4_;
      var _loc5_;
      if(typeof aEffects == "object")
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = aEffects[_loc4_][0];
            if(_loc5_ == 400)
            {
               return true;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return false;
   }
}
