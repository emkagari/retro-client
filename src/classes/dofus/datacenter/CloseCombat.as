class dofus.datacenter.CloseCombat extends Object
{
   var _aEffectZones;
   var _aForbiddenStates;
   var _aRequiredStates;
   var _oCloseCombatClassInfos;
   var _oItem;
   var api;
   static var CLOSE_COMBAT_SPELL_ID = 0;
   function CloseCombat(oItem, nClassID)
   {
      super();
      this.initialize(oItem,nClassID);
   }
   function get ID()
   {
      return dofus.datacenter.CloseCombat.CLOSE_COMBAT_SPELL_ID;
   }
   function get isValid()
   {
      return true;
   }
   function get maxLevel()
   {
      return 1;
   }
   function get position()
   {
      return 0;
   }
   function get item()
   {
      return this._oItem;
   }
   function get summonSpell()
   {
      return false;
   }
   function get glyphSpell()
   {
      return false;
   }
   function get trapSpell()
   {
      return false;
   }
   function get iconFile()
   {
      if(this._oItem == undefined)
      {
         return dofus.Constants.DEFAULT_CC_ICON_FILE;
      }
      return this._oItem.iconFile;
   }
   function get isUnusable()
   {
      return this._oItem.isCaptureItem || this._oItem.isCeremonial;
   }
   function get name()
   {
      return this._oItem.name != undefined ? this._oItem.name : this.api.lang.getSpellText(0).n;
   }
   function get apCost()
   {
      if(this._oItem != undefined)
      {
         return this._oItem.apCost;
      }
      var _loc2_ = this.api.kernel.SpellsBoostsManager.getSpellModificator(dofus.managers.SpellsBoostsManager.ACTION_BOOST_ITEM_AP_COST,dofus.datacenter.CloseCombat.CLOSE_COMBAT_SPELL_ID);
      var _loc3_ = this.getDefaultProperty(2);
      if(_loc2_ > -1)
      {
         _loc3_ -= _loc2_;
      }
      return Math.max(1,_loc3_);
   }
   function get rangeMin()
   {
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(3);
      }
      return this._oItem.rangeMin;
   }
   function get rangeMax()
   {
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(4);
      }
      return this._oItem.rangeMax;
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
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(5);
      }
      return this._oItem.criticalHit;
   }
   function get criticalFailure()
   {
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(6);
      }
      return this._oItem.criticalFailure;
   }
   function get lineOnly()
   {
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(7);
      }
      return this._oItem.lineOnly;
   }
   function get lineOfSight()
   {
      if(this._oItem == undefined)
      {
         return this.getDefaultProperty(8);
      }
      return this._oItem.lineOfSight;
   }
   function get freeCell()
   {
      return false;
   }
   function get canBoostRange()
   {
      return false;
   }
   function get classID()
   {
      return -1;
   }
   function get launchCountByTurn()
   {
      return 0;
   }
   function get launchCountByPlayerTurn()
   {
      return 0;
   }
   function get delayBetweenLaunch()
   {
      return 0;
   }
   function get descriptionVisibleEffects()
   {
      var _loc2_;
      if(this._oItem == undefined)
      {
         _loc2_ = this.getDefaultProperty(0);
         return this.api.kernel.GameManager.getSpellDescriptionWithEffects(_loc2_,true,0);
      }
      var _loc3_ = this._oItem.visibleEffects;
      var _loc4_ = [];
      var _loc5_ = 0;
      while(_loc5_ < _loc3_.length)
      {
         _loc4_.push(_loc3_[_loc5_].description);
         _loc5_ = _loc5_ + 1;
      }
      return _loc4_.join("\n");
   }
   function get descriptionNormalHit()
   {
      var _loc2_;
      if(this._oItem == undefined)
      {
         _loc2_ = this.getDefaultProperty(0);
         return this.api.kernel.GameManager.getSpellDescriptionWithEffects(_loc2_,false,0);
      }
      var _loc3_ = this._oItem.normalHit;
      var _loc4_ = [];
      var _loc5_ = 0;
      while(_loc5_ < _loc3_.length)
      {
         _loc4_.push(_loc3_.description);
         _loc5_ = _loc5_ + 1;
      }
      return _loc4_.join(", ");
   }
   function get descriptionCriticalHit()
   {
      var _loc2_;
      if(this._oItem == undefined)
      {
         _loc2_ = this.getDefaultProperty(1);
      }
      else
      {
         _loc2_ = this._oItem.criticalHitBonus;
      }
      return this.api.kernel.GameManager.getSpellDescriptionWithEffects(_loc2_,false,0);
   }
   function get effectsNormalHit()
   {
      var _loc2_;
      if(this._oItem == undefined)
      {
         _loc2_ = this.getDefaultProperty(0);
      }
      else
      {
         _loc2_ = this._oItem.normalHit;
      }
      return this.api.kernel.GameManager.getSpellEffects(_loc2_,0);
   }
   function get effectsCriticalHit()
   {
      var _loc2_;
      if(this._oItem == undefined)
      {
         _loc2_ = this.getDefaultProperty(1);
      }
      else
      {
         _loc2_ = this._oItem.criticalHitBonus;
      }
      return this.api.kernel.GameManager.getSpellEffects(_loc2_,0);
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
   function initialize(oItem, nClassID)
   {
      this.api = _global.API;
      this._oItem = oItem;
      if(oItem == undefined)
      {
         this._oCloseCombatClassInfos = this.api.lang.getClassText(nClassID).cc;
      }
      var _loc4_ = this.api.lang.getItemTypeText(this._oItem.type).z;
      if(_loc4_ == undefined)
      {
         _loc4_ = "Pa";
      }
      var _loc5_ = _loc4_.split("");
      this._aEffectZones = [];
      var _loc6_ = 0;
      while(_loc6_ < _loc5_.length)
      {
         this._aEffectZones.push({shape:_loc5_[_loc6_],size:ank.utils.Compressor.decode64(_loc5_[_loc6_ + 1])});
         _loc6_ += 2;
      }
      var _loc7_ = this.api.lang.getClassText(this.api.datacenter.Player.Guild).cc;
      this._aRequiredStates = _loc7_[9];
      this._aForbiddenStates = _loc7_[10];
   }
   function getDefaultProperty(nPropertyIndex)
   {
      return this._oCloseCombatClassInfos[nPropertyIndex];
   }
}
