class dofus.datacenter.Effect extends Object
{
   var _bDispellable;
   var _bExo;
   var _bOver;
   var _nParam1;
   var _nParam2;
   var _nParam3;
   var _nRemainingTurn;
   var _nSpellID;
   var _nType;
   var _sCasterID;
   var _sConditions;
   var _sParam4;
   var api;
   var _nPropability = 0;
   var _nModificator = -1;
   var _eaWeaponDamages = ank.utils.ExtendedArray.createFromArray([100,96,97,99,98,95,94,93,92,91]);
   function Effect(sCasterID, mType, mParam1, mParam2, mParam3, mParam4, mRemainingTurn, mSpellID, nModificator, sConditions, bDispellable)
   {
      super();
      this.initialize(sCasterID,mType,mParam1,mParam2,mParam3,mParam4,mRemainingTurn,mSpellID,nModificator,sConditions,bDispellable != undefined ? bDispellable : true);
   }
   function get type()
   {
      return this._nType;
   }
   function set probability(nProbability)
   {
      this._nPropability = nProbability;
   }
   function get probability()
   {
      return this._nPropability;
   }
   function get param1()
   {
      return this._nParam1;
   }
   function set param1(value)
   {
      this._nParam1 = value;
   }
   function get param2()
   {
      return this._nParam2;
   }
   function set param2(value)
   {
      this._nParam2 = value;
   }
   function get param3()
   {
      return this._nParam3;
   }
   function set param3(value)
   {
      this._nParam3 = value;
   }
   function get param4()
   {
      return this._sParam4;
   }
   function set param4(value)
   {
      this._sParam4 = value;
   }
   function set remainingTurn(nRremainingTurn)
   {
      this._nRemainingTurn = nRremainingTurn;
   }
   function get remainingTurn()
   {
      return this._nRemainingTurn;
   }
   function get remainingTurnStr()
   {
      return this.getTurnCountStr(true);
   }
   function get spellID()
   {
      return this._nSpellID;
   }
   function get isNothing()
   {
      var _loc2_ = this.api.lang.getEffectText(this._nType).d;
      if(_loc2_ == "null" || (_loc2_ == null || _loc2_ == undefined))
      {
         return true;
      }
      return false;
   }
   function get description()
   {
      return this.getDescription(true);
   }
   function get isDispellable()
   {
      return this._bDispellable;
   }
   function getDescription(bShowRemainingTurns)
   {
      var _loc3_ = this.api.lang.getEffectText(this._nType).d;
      var _loc4_ = [this._nParam1,this._nParam2,this._nParam3,this._sParam4];
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      switch(this._nType)
      {
         case 10:
            _loc4_[2] = this.api.lang.getEmoteText(this._nParam3).n;
            break;
         case 181:
            _loc4_[0] = this.api.lang.getMonstersText(this._nParam1).n;
            break;
         case 197:
         case 239:
            _loc4_[0] = this.api.lang.getMonstersText(this._nParam1).n;
            break;
         case 165:
            _loc4_[0] = this._nParam1 != 0 ? this.api.lang.getItemTypeText(this._nParam1).n : this.api.lang.getText("WEAPONS");
            break;
         case 293:
         case 294:
         case 787:
            _loc4_[0] = this.api.lang.getSpellText(this._nParam1).n;
            break;
         case 601:
            _loc5_ = this.api.lang.getMapText(this._nParam2);
            _loc4_[0] = this.api.lang.getMapSubAreaName(_loc5_.sa);
            _loc4_[1] = _loc5_.x;
            _loc4_[2] = _loc5_.y;
            break;
         case 603:
            _loc4_[2] = this.api.lang.getJobText(this._nParam3).n;
            break;
         case 604:
            _loc6_ = this.api.datacenter.Spell.getSpellFromLevelID(this._nParam3).id;
            _loc4_[2] = this.api.lang.getSpellText(_loc6_).n;
            break;
         case 614:
            _loc4_[0] = this._nParam3;
            _loc4_[1] = this.api.lang.getJobText(this._nParam2).n;
            break;
         case 615:
            _loc4_[2] = this.api.lang.getJobText(this._nParam3).n;
            break;
         case 616:
         case 624:
            _loc4_[2] = this.api.lang.getSpellText(this._nParam3).n;
            break;
         case 699:
            _loc4_[0] = this.api.lang.getJobText(this._nParam1).n;
            break;
         case 621:
            _loc4_[2] = this.api.lang.getMonstersText(this._nParam2).n;
            break;
         case 905:
            _loc4_[1] = this.api.lang.getMonstersText(this._nParam2).n;
            break;
         case 628:
         case 623:
            _loc4_[2] = this.api.lang.getMonstersText(this._nParam3).n;
            break;
         case 715:
            _loc4_[0] = this.api.lang.getMonstersSuperRaceText(this._nParam1).n;
            break;
         case 716:
            _loc4_[0] = this.api.lang.getMonstersRaceText(this._nParam1).n;
            break;
         case 717:
            _loc4_[0] = this.api.lang.getMonstersText(this._nParam1).n;
            break;
         case 722:
         case 300:
            _loc7_ = this.api.datacenter.Spell.getSpellFromLevelID(this._nParam3).id;
            _loc4_[2] = this.api.lang.getSpellText(_loc7_).n;
            break;
         case 724:
         case 2187:
         case 2188:
            _loc4_[2] = this.api.lang.getTitle(this._nParam3).t;
            break;
         case 725:
            _loc4_[3] = this.api.datacenter.Player.guildInfos.name;
            break;
         case 805:
         case 808:
         case dofus.datacenter.Item.OBJECT_ACTION_LINK_ACCOUNT:
         case dofus.datacenter.Item.OBJECT_ACTION_LOCK_TEMPORARY:
         case dofus.datacenter.Item.OBJECT_ACTION_LINK_CHARACTER:
            if(this._nParam1 != undefined && this._nParam1 == -1)
            {
               _loc4_[0] = "";
            }
            else
            {
               this._nParam3 = this._nParam3 != undefined ? this._nParam3 : 0;
               _loc8_ = String(Math.floor(this._nParam2) / 100).split(".");
               _loc9_ = Number(_loc8_[0]);
               _loc10_ = this._nParam2 - _loc9_ * 100;
               _loc11_ = String(Math.floor(this._nParam3) / 100).split(".");
               _loc12_ = Number(_loc11_[0]);
               _loc13_ = this._nParam3 - _loc12_ * 100;
               _loc14_ = "";
               if(this._nType == dofus.datacenter.Item.OBJECT_ACTION_LINK_ACCOUNT || this._nType == dofus.datacenter.Item.OBJECT_ACTION_LINK_CHARACTER)
               {
                  _loc14_ = ": ";
               }
               _loc4_[0] = _loc14_ + ank.utils.PatternDecoder.getDescription(this.api.lang.getConfigText("DATE_FORMAT"),[this._nParam1,new ank.utils.ExtendedString(_loc9_ + 1).addLeftChar("0",2),new ank.utils.ExtendedString(_loc10_).addLeftChar("0",2),_loc12_,new ank.utils.ExtendedString(_loc13_).addLeftChar("0",2)]);
            }
            break;
         case 806:
            if(this._nParam2 == undefined && this._nParam3 == undefined)
            {
               _loc4_[0] = this.api.lang.getText("NORMAL");
            }
            else
            {
               _loc4_[0] = this._nParam2 <= 6 ? (this._nParam3 <= 6 ? this.api.lang.getText("NORMAL") : this.api.lang.getText("LEAN")) : this.api.lang.getText("FAT");
            }
            break;
         case 807:
            if(this._nParam3 == undefined)
            {
               _loc4_[0] = this.api.lang.getText("NO_LAST_MEAL");
            }
            else
            {
               _loc4_[0] = this.api.lang.getItemUnicText(this._nParam3).n;
            }
            break;
         case 814:
            _loc4_[0] = this.api.lang.getItemUnicText(this._nParam1).n;
            break;
         case 2152:
            _loc4_[2] = this.api.lang.getItemUnicText(this._nParam3).n;
            break;
         case 950:
         case 951:
         case 2128:
         case 2129:
         case 2137:
            _loc4_[2] = this.api.lang.getStateText(this._nParam3);
            break;
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_AP_COST:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGE:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGEABLE:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_RANGE_NO_RANGEABLE_TRIGGER:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_DMG:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_HEAL:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_AP_COST:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CAST_INTVL:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_SET_INTVL:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CC:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_CASTOUTLINE:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_NOLINEOFSIGHT:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_MAXPERTURN:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_MAXPERTARGET:
         case dofus.managers.SpellsBoostsManager.ACTION_BOOST_SPELL_DMG_PERCENT:
            _loc4_[0] = this.api.lang.getSpellText(Number(_loc4_[0])).n;
            break;
         case 939:
         case 940:
         case 969:
            _loc15_ = new dofus.datacenter.Item(-1,Number(_loc4_[2]),1,0,"",0);
            _loc4_[2] = _loc15_.name;
            break;
         case 649:
         case 960:
            _loc4_[2] = this.api.lang.getAlignment(this._nParam3).n;
            break;
         case 999:
            break;
         case 2143:
            _loc4_[0] = this.api.lang.getMonstersText(this._nParam3).n;
            break;
         case 2146:
            if(Number(_loc4_[2]) < 10)
            {
               _loc4_[2] = "0" + _loc4_[2];
            }
            break;
         case 2159:
            if(_loc4_[0] == 0 && _loc4_[1] == 0)
            {
               _loc4_[0] = _loc4_[2];
               _loc4_[1] = Number(_loc4_[2]) * 3 - 14;
               _loc4_[2] = undefined;
            }
            else
            {
               _loc16_ = _loc4_[0] + _loc4_[2];
               _loc17_ = _loc4_[1] + _loc4_[2];
               _loc4_[0] = _loc16_;
               _loc4_[1] = _loc16_ * 3 - 14;
               _loc4_[2] = _loc17_;
               _loc4_[3] = _loc17_ * 3 - 14;
            }
            break;
         case 2172:
         case 2173:
            _loc18_ = new dofus.datacenter.Spell(this._nParam3,1);
            _loc4_[1] = this._nParam2;
            _loc4_[2] = _loc18_.name;
            break;
         case 2165:
         case 2166:
            _loc19_ = "";
            switch(this._nParam1)
            {
               case 10:
                  _loc19_ = this.api.lang.getText("FORCE");
                  break;
               case 13:
                  _loc19_ = this.api.lang.getText("CHANCE");
                  break;
               case 14:
                  _loc19_ = this.api.lang.getText("AGILITY");
                  break;
               case 15:
                  _loc19_ = this.api.lang.getText("INTELLIGENCE");
            }
            _loc4_[0] = _loc19_;
            _loc4_[2] = this._nParam3;
            break;
         case 2051:
            _loc3_ = ank.utils.PatternDecoder.combine(_loc3_,null,_loc4_[0] <= 1);
            break;
         case 2190:
            _loc20_ = this._nParam1 * Math.pow(32,6) + this._nParam2 * Math.pow(32,3) + this._nParam3;
            _loc4_[0] = new ank.utils.ExtendedString(_loc20_).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
            break;
         case 300:
      }
      var _loc21_;
      var _loc22_;
      var _loc0_;
      if(this.api.lang.getEffectText(this._nType).j && this.api.kernel.OptionsManager.getOption("ViewDicesDammages"))
      {
         _loc21_ = this._sParam4.toLowerCase().split("d");
         _loc21_[1] = _loc21_[1].split("+");
         if(!(_loc21_[0] == undefined || (_loc21_[1] == undefined || (_loc21_[1][0] == undefined || _loc21_[1][0] == undefined))))
         {
            _loc22_ = "";
            _loc22_ += !(_loc21_[0] != "0" && _loc21_[1][0] != "0") ? "" : _loc21_[0] + "d" + _loc21_[1][0];
            _loc22_ += _loc21_[1][1] == "0" ? "" : (_loc22_ == "" ? "" : "+") + _loc21_[1][1];
            _loc4_[0] = _loc22_;
            var _temp_4 = _loc4_;
            var _temp_3 = 1;
            var _temp_2 = _loc4_;
            var _temp_1 = 2;
            _loc4_[4] = _loc0_;
            _temp_2[_temp_1] = _loc0_;
            _temp_4[_temp_3] = _loc0_;
         }
      }
      var _loc23_ = "";
      if(this._nPropability > 0 && this._nPropability != undefined)
      {
         _loc23_ += " - " + this.api.lang.getText("IN_CASE_PERCENT",[this._nPropability]) + ": ";
      }
      var _loc24_;
      if(this._nType == 666)
      {
         _loc23_ += this.api.lang.getText("DO_NOTHING");
      }
      else
      {
         _loc24_ = ank.utils.PatternDecoder.getDescription(_loc3_,_loc4_);
         _loc23_ += _loc24_;
      }
      if(this._nModificator > 0 && this.api.kernel.SpellsBoostsManager.isBoostedHealingOrDamagingEffect(this._nType))
      {
         _loc23_ += " " + this.api.lang.getText("BOOSTED_SPELLS_EFFECT_COMPLEMENT",[this._nModificator]);
      }
      if(!bShowRemainingTurns)
      {
         return _loc23_;
      }
      var _loc25_ = this.getTurnCountStr(false);
      if(_loc25_.length == 0)
      {
         return _loc23_;
      }
      return _loc23_ + " (" + _loc25_ + ")";
   }
   function get characteristic()
   {
      return this.api.lang.getEffectText(this._nType).c;
   }
   function get operator()
   {
      return this.api.lang.getEffectText(this._nType).o;
   }
   function get element()
   {
      return this.api.lang.getEffectText(this._nType).e;
   }
   function get spellName()
   {
      return this.api.lang.getSpellText(this._nSpellID).n;
   }
   function get spellDescription()
   {
      return this.api.lang.getSpellText(this._nSpellID).d;
   }
   function get showInTooltip()
   {
      return this.api.lang.getEffectText(this._nType).t;
   }
   function get sCasterID()
   {
      return this._sCasterID;
   }
   function get priorityDisplay()
   {
      return this.api.lang.getEffectText(this._nType).p + (!this.isExo ? 0 : 100000) + (!this.isWeaponDamage ? 0 : 200000);
   }
   function get hasInvocationConditions()
   {
      var _loc2_ = dofus.managers.EffectsManager.getConditionalElementFromString("FZ",this._sConditions);
      if(_loc2_ != undefined)
      {
         return true;
      }
      _loc2_ = dofus.managers.EffectsManager.getConditionalElementFromString("Fz",this._sConditions);
      if(_loc2_ != undefined)
      {
         return true;
      }
      return false;
   }
   function get conditions()
   {
      return dofus.managers.EffectsManager.parseConditionsString(this._sConditions);
   }
   function get conditionalStateID()
   {
      var _loc2_ = dofus.managers.EffectsManager.getConditionalElementFromString("FS",this._sConditions);
      return _loc2_ == undefined ? undefined : Number(_loc2_);
   }
   function get conditionalAlignmentID()
   {
      var _loc2_ = dofus.managers.EffectsManager.getConditionalElementFromString("Ps",this._sConditions);
      return _loc2_ == undefined ? undefined : Number(_loc2_);
   }
   function set isOver(bOver)
   {
      this._bOver = bOver;
   }
   function set isExo(bExo)
   {
      this._bExo = bExo;
   }
   function get isOver()
   {
      return this._bOver;
   }
   function get isExo()
   {
      return this._bExo;
   }
   function get isWeaponDamage()
   {
      return this._eaWeaponDamages.contains(this.type);
   }
   static function getIconNameFromID(sID)
   {
      switch(sID.toString())
      {
         case "W":
            return "IconWaterDommage";
         case "F":
            return "IconFireDommage";
         case "E":
            return "IconEarthDommage";
         case "A":
            return "IconAirDommage";
         case "N":
            return "IconNeutralDommage";
         case "B":
            return "IconBestElementDommage";
         case "1":
            return "Star";
         case "2":
            return "Gold";
         case "6":
            return "Shield";
         case "10":
            return "IconEarthBonus";
         case "11":
            return "IconVita";
         case "12":
            return "IconWisdom";
         case "13":
            return "IconWaterBonus";
         case "14":
            return "IconAirBonus";
         case "15":
            return "IconFireBonus";
         case "16":
            return "DamageWeapon";
         case "17":
            return "DamagePercent";
         case "18":
            return "CriticalHit";
         case "19":
            return "Range";
         case "23":
            return "IconMP";
         case "24":
            return "Invisible";
         case "26":
            return "Summon";
         case "27":
            return "DodgeAP";
         case "28":
            return "IconMP";
         case "31":
            return "ReflectDamage";
         case "33":
            return "IconEarth";
         case "34":
            return "IconFire";
         case "35":
            return "IconWater";
         case "36":
            return "IconAir";
         case "37":
            return "IconNeutral";
         case "39":
            return "CriticalFailure";
         case "44":
            return "IconInit";
         case "48":
            return "IconPP";
         case "49":
            return "HealBonus";
         case "50":
            return "ReflectDamage";
         case "69":
            return "DamageTrapPercent";
         case "70":
            return "DamageTrap";
         case "76":
            return "FinalDamageInflicted";
         case "78":
            return "FinalDamageReceived";
         case "79":
            return "DamagePhysical";
         case "80":
            return "Damage";
         case "81":
            return "GetMount";
         case "82":
            return "HealGain";
         case "83":
            return "IconEarthAlt";
         case "84":
            return "IconFireAlt";
         case "85":
            return "IconWaterAlt";
         case "86":
            return "IconAirAlt";
         case "87":
            return "IconNeutralAlt";
         case "88":
            return "IconAllElementsBonus";
         case "89":
            return "Teleportation";
         case "90":
            return "doubleArrow";
         case "91":
            return "PullArrow";
         case "92":
            return "PushArrow";
         case "93":
            return "IconNeutralDommage";
         case "94":
            return "IconEarthDommage";
         case "95":
            return "IconBestElementDommage";
         case "96":
            return "Inventory";
         case "97":
            return "Invocation";
         case "98":
            return "InvocationStatic";
         case "99":
            return "Coeur";
         case "100":
            return "Piece";
         case "101":
            return "Link";
         case "102":
            return "DeadHead";
         case "103":
            return "IconElementary";
         case "104":
            return "IconAction";
         case "105":
            return "IconTimeDown";
         case "106":
            return "IconRangeBoostable";
         case "107":
            return "IconLine";
         case "108":
            return "IconTarget";
         case "109":
            return "IconRangeUp";
         case "110":
            return "IconLineSight";
         case "111":
            return "IconRollback";
         default:
            return "";
      }
   }
   function initialize(sCasterID, mType, mParam1, mParam2, mParam3, mParam4, mRemainingTurn, mSpellID, nModificator, sConditions, bDispellable)
   {
      this.api = _global.API;
      this._nType = Number(mType);
      this._sCasterID = sCasterID;
      this._nParam1 = !_global.isNaN(Number(mParam1)) ? Number(mParam1) : undefined;
      this._nParam2 = !_global.isNaN(Number(mParam2)) ? Number(mParam2) : undefined;
      this._nParam3 = !_global.isNaN(Number(mParam3)) ? Number(mParam3) : undefined;
      this._sParam4 = mParam4;
      this._nRemainingTurn = mRemainingTurn != undefined ? Number(mRemainingTurn) : 0;
      if(this._nRemainingTurn < 0 || this._nRemainingTurn >= 63)
      {
         this._nRemainingTurn = Number.POSITIVE_INFINITY;
      }
      this._nSpellID = Number(mSpellID);
      this._nModificator = Number(nModificator);
      this._sConditions = sConditions;
      this._bDispellable = bDispellable;
   }
   function getParamWithOperator(nParamID)
   {
      var _loc3_ = this.operator != "-" ? 1 : -1;
      return this["_nParam" + nParamID] * _loc3_;
   }
   function getTurnCountStr(bShowLast)
   {
      var _loc3_ = new String();
      if(this._nRemainingTurn == undefined)
      {
         return "";
      }
      if(_global.isFinite(this._nRemainingTurn))
      {
         if(this._nRemainingTurn > 1)
         {
            return String(this._nRemainingTurn) + " " + this.api.lang.getText("TURNS");
         }
         if(this._nRemainingTurn == 0)
         {
            return "";
         }
         if(bShowLast)
         {
            return this.api.lang.getText("LAST_TURN");
         }
         return String(this._nRemainingTurn) + " " + this.api.lang.getText("TURN");
      }
      return this.api.lang.getText("INFINIT");
   }
}
