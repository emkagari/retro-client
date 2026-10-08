class dofus.graphics.gapi.ui.SpellsCollection extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnFilterCraft;
   var _btnFilterMonster;
   var _btnFilterNotPossessed;
   var _btnFilterPossessed;
   var _btnFilterUnknown;
   var _btnNextDeck;
   var _btnPreviousDeck;
   var _cbProgressAir;
   var _cbProgressBoost;
   var _cbProgressEarth;
   var _cbProgressFire;
   var _cbProgressHeal;
   var _cbProgressInvoc;
   var _cbProgressMulti;
   var _cbProgressNeutral;
   var _cbProgressWater;
   var _cgSpells;
   var _circleProgressAir;
   var _circleProgressBoost;
   var _circleProgressEarth;
   var _circleProgressFire;
   var _circleProgressHeal;
   var _circleProgressInvoc;
   var _circleProgressMulti;
   var _circleProgressNeutral;
   var _circleProgressWater;
   var _ctrDeck1;
   var _ctrDeck2;
   var _ctrDeck3;
   var _ctrDeck4;
   var _ctrDeck5;
   var _ctrDeck6;
   var _ctrDeck7;
   var _ctrDeck8;
   var _ctrDeck9;
   var _ctrDeck10;
   var _ctrDeck11;
   var _ctrDeck12;
   var _ctrDeck13;
   var _ctrDeck14;
   var _currentOverContainer;
   var _eaAvailableSpells;
   var _eoSpellFilters;
   var _eoSpellTypesStatistics;
   var _lblBreedSpell;
   var _lblBreedSpellDescription;
   var _lblDeckSpellDescription;
   var _lblLevelFrom;
   var _lblLevelFromMiddle;
   var _lblNoSpellsFound;
   var _lblParchoSpellDescription;
   var _lblParchoSpells;
   var _lblSpellDeck;
   var _ldrBreed;
   var _ldrProgressAir;
   var _ldrProgressBoost;
   var _ldrProgressEarth;
   var _ldrProgressFire;
   var _ldrProgressHeal;
   var _ldrProgressInvoc;
   var _ldrProgressMulti;
   var _ldrProgressNeutral;
   var _ldrProgressWater;
   var _mcElementFilterSelected;
   var _mcResetSpellFilters;
   var _mcSpellFullInfosPlacer;
   var _nDeckNameChangeTimeout;
   var _nDelayTooltipEventTimeout;
   var _nMcElementFilterSelectedY;
   var _nSpellFullInfosPlacerX;
   var _oSpellsStatistics;
   var _sfivSpellFullInfosViewer;
   var _suSpell1;
   var _suSpell2;
   var _suSpell3;
   var _suSpell4;
   var _suSpell5;
   var _tiDeckName;
   var _tiFromLevel;
   var _tiSearch;
   var _tiToLevel;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "SpellsCollection";
   static var SPELLS_CATEGORY_TR2_BREED = 10;
   static var SPELLS_CATEGORY_TR2_COMMON = 11;
   static var SPELLS_CATEGORY_TR2_RARE = 12;
   static var SPELLS_CATEGORY_TR2_EPIC = 13;
   static var SPELLS_CATEGORY_TR2_LEGENDARY = 14;
   static var SPELLS_ORIGIN_DEFAULT = 0;
   static var SPELLS_ORIGIN_DROP_ON_MONSTER = 1;
   static var SPELLS_ORIGIN_CRAFT = 2;
   static var SPELLS_ORIGIN_UNKNOWN = 3;
   static var MIN_FILTER_DEFAULT_SPELL_LEVEL = 0;
   static var MAX_FILTER_DEFAULT_SPELL_LEVEL = 200;
   function SpellsCollection()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return dofus.datacenter.Spell(this._currentOverContainer.contentData);
      }
      return undefined;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.SpellsCollection.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this._lblNoSpellsFound._visible = false;
      this._mcElementFilterSelected._visible = false;
      this._nSpellFullInfosPlacerX = this._mcSpellFullInfosPlacer._x;
      this._nMcElementFilterSelectedY = this._mcElementFilterSelected._y;
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this._mcSpellFullInfosPlacer._visible = false;
   }
   function addListeners()
   {
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      var ref = this;
      this._mcResetSpellFilters.onPress = function()
      {
         ref.click({target:this});
      };
      this._mcResetSpellFilters.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcResetSpellFilters.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressFire.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressFire.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressFire.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressWater.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressWater.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressWater.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressEarth.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressEarth.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressEarth.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressNeutral.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressNeutral.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressNeutral.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressAir.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressAir.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressAir.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressMulti.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressMulti.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressMulti.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressInvoc.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressInvoc.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressInvoc.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressBoost.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressBoost.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressBoost.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._circleProgressHeal.onPress = function()
      {
         ref.click({target:this});
      };
      this._circleProgressHeal.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._circleProgressHeal.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._ctrDeck1.addEventListener("over",this);
      this._ctrDeck2.addEventListener("over",this);
      this._ctrDeck3.addEventListener("over",this);
      this._ctrDeck4.addEventListener("over",this);
      this._ctrDeck5.addEventListener("over",this);
      this._ctrDeck6.addEventListener("over",this);
      this._ctrDeck7.addEventListener("over",this);
      this._ctrDeck8.addEventListener("over",this);
      this._ctrDeck9.addEventListener("over",this);
      this._ctrDeck10.addEventListener("over",this);
      this._ctrDeck11.addEventListener("over",this);
      this._ctrDeck12.addEventListener("over",this);
      this._ctrDeck13.addEventListener("over",this);
      this._ctrDeck14.addEventListener("over",this);
      this._btnClose.addEventListener("over",this);
      this._ctrDeck1.addEventListener("out",this);
      this._ctrDeck2.addEventListener("out",this);
      this._ctrDeck3.addEventListener("out",this);
      this._ctrDeck4.addEventListener("out",this);
      this._ctrDeck5.addEventListener("out",this);
      this._ctrDeck6.addEventListener("out",this);
      this._ctrDeck7.addEventListener("out",this);
      this._ctrDeck8.addEventListener("out",this);
      this._ctrDeck9.addEventListener("out",this);
      this._ctrDeck10.addEventListener("out",this);
      this._ctrDeck11.addEventListener("out",this);
      this._ctrDeck12.addEventListener("out",this);
      this._ctrDeck13.addEventListener("out",this);
      this._ctrDeck14.addEventListener("out",this);
      this._btnClose.addEventListener("out",this);
      this._ctrDeck1.addEventListener("click",this);
      this._ctrDeck2.addEventListener("click",this);
      this._ctrDeck3.addEventListener("click",this);
      this._ctrDeck4.addEventListener("click",this);
      this._ctrDeck5.addEventListener("click",this);
      this._ctrDeck6.addEventListener("click",this);
      this._ctrDeck7.addEventListener("click",this);
      this._ctrDeck8.addEventListener("click",this);
      this._ctrDeck9.addEventListener("click",this);
      this._ctrDeck10.addEventListener("click",this);
      this._ctrDeck11.addEventListener("click",this);
      this._ctrDeck12.addEventListener("click",this);
      this._ctrDeck13.addEventListener("click",this);
      this._ctrDeck14.addEventListener("click",this);
      this._ctrDeck1.addEventListener("drag",this);
      this._ctrDeck2.addEventListener("drag",this);
      this._ctrDeck3.addEventListener("drag",this);
      this._ctrDeck4.addEventListener("drag",this);
      this._ctrDeck5.addEventListener("drag",this);
      this._ctrDeck6.addEventListener("drag",this);
      this._ctrDeck7.addEventListener("drag",this);
      this._ctrDeck8.addEventListener("drag",this);
      this._ctrDeck9.addEventListener("drag",this);
      this._ctrDeck10.addEventListener("drag",this);
      this._ctrDeck11.addEventListener("drag",this);
      this._ctrDeck12.addEventListener("drag",this);
      this._ctrDeck13.addEventListener("drag",this);
      this._ctrDeck14.addEventListener("drag",this);
      this._ctrDeck1.addEventListener("drop",this);
      this._ctrDeck2.addEventListener("drop",this);
      this._ctrDeck3.addEventListener("drop",this);
      this._ctrDeck4.addEventListener("drop",this);
      this._ctrDeck5.addEventListener("drop",this);
      this._ctrDeck6.addEventListener("drop",this);
      this._ctrDeck7.addEventListener("drop",this);
      this._ctrDeck8.addEventListener("drop",this);
      this._ctrDeck9.addEventListener("drop",this);
      this._ctrDeck10.addEventListener("drop",this);
      this._ctrDeck11.addEventListener("drop",this);
      this._ctrDeck12.addEventListener("drop",this);
      this._ctrDeck13.addEventListener("drop",this);
      this._ctrDeck14.addEventListener("drop",this);
      this._ldrProgressFire.addEventListener("over",this);
      this._ldrProgressWater.addEventListener("over",this);
      this._ldrProgressEarth.addEventListener("over",this);
      this._ldrProgressNeutral.addEventListener("over",this);
      this._ldrProgressAir.addEventListener("over",this);
      this._ldrProgressMulti.addEventListener("over",this);
      this._ldrProgressInvoc.addEventListener("over",this);
      this._ldrProgressBoost.addEventListener("over",this);
      this._ldrProgressHeal.addEventListener("over",this);
      this._btnFilterMonster.addEventListener("over",this);
      this._btnFilterCraft.addEventListener("over",this);
      this._btnFilterUnknown.addEventListener("over",this);
      this._btnFilterPossessed.addEventListener("over",this);
      this._btnFilterNotPossessed.addEventListener("over",this);
      this._ldrProgressFire.addEventListener("out",this);
      this._ldrProgressWater.addEventListener("out",this);
      this._ldrProgressEarth.addEventListener("out",this);
      this._ldrProgressNeutral.addEventListener("out",this);
      this._ldrProgressAir.addEventListener("out",this);
      this._ldrProgressMulti.addEventListener("out",this);
      this._ldrProgressInvoc.addEventListener("out",this);
      this._ldrProgressBoost.addEventListener("out",this);
      this._ldrProgressHeal.addEventListener("out",this);
      this._btnFilterMonster.addEventListener("out",this);
      this._btnFilterCraft.addEventListener("out",this);
      this._btnFilterUnknown.addEventListener("out",this);
      this._btnFilterPossessed.addEventListener("out",this);
      this._btnFilterNotPossessed.addEventListener("out",this);
      this._ldrProgressFire.addEventListener("click",this);
      this._ldrProgressWater.addEventListener("click",this);
      this._ldrProgressEarth.addEventListener("click",this);
      this._ldrProgressNeutral.addEventListener("click",this);
      this._ldrProgressAir.addEventListener("click",this);
      this._ldrProgressMulti.addEventListener("click",this);
      this._ldrProgressInvoc.addEventListener("click",this);
      this._ldrProgressBoost.addEventListener("click",this);
      this._ldrProgressHeal.addEventListener("click",this);
      this._btnPreviousDeck.addEventListener("click",this);
      this._btnNextDeck.addEventListener("click",this);
      this._btnFilterMonster.addEventListener("click",this);
      this._btnFilterCraft.addEventListener("click",this);
      this._btnFilterUnknown.addEventListener("click",this);
      this._btnFilterPossessed.addEventListener("click",this);
      this._btnFilterNotPossessed.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._cgSpells.addEventListener("selectItem",this);
      this._cgSpells.addEventListener("dragItem",this);
      this._cgSpells.addEventListener("dropItem",this);
      this._suSpell1.addEventListener("selectItem",this);
      this._suSpell2.addEventListener("selectItem",this);
      this._suSpell3.addEventListener("selectItem",this);
      this._suSpell4.addEventListener("selectItem",this);
      this._suSpell5.addEventListener("selectItem",this);
      this._tiSearch.addEventListener("change",this);
      this._tiFromLevel.addEventListener("change",this);
      this._tiToLevel.addEventListener("change",this);
      this.api.datacenter.Player.Spells.addEventListener("modelChanged",this);
      var _loc2_ = {};
      _loc2_.onSetFocus = function(oldFocus_txt, newFocus_txt)
      {
         var _loc4_ = _global.API;
         if(eval(Selection.getFocus())._parent == ref._tiSearch)
         {
            if(ref._tiSearch.text == _loc4_.lang.getText("SEARCH"))
            {
               ref._tiSearch.text = "";
            }
         }
         else if(ref._tiSearch.text == "")
         {
            ref._tiSearch.text = _loc4_.lang.getText("SEARCH");
         }
      };
      Selection.addListener(_loc2_);
   }
   function validateDeckNameChange(nDeckID, sText)
   {
      var _loc4_ = new ank.utils.ExtendedString(sText).trim().toString();
      if(_loc4_.length == 0)
      {
         return undefined;
      }
      this.api.network.Temporis.episodeTwo.sendSpellsQuickEditName(nDeckID,_loc4_);
   }
   function change(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_;
      var _loc5_;
      switch(_loc3_)
      {
         case this._tiDeckName:
            _loc4_ = _loc3_.text;
            if(this._nDeckNameChangeTimeout != undefined)
            {
               _global.clearTimeout(this._nDeckNameChangeTimeout);
            }
            _loc5_ = _global.setTimeout(this,"validateDeckNameChange",500,this.api.datacenter.Player.currentSpellsDeckID,_loc4_);
            this._nDeckNameChangeTimeout = _loc5_;
            break;
         case this._tiSearch:
            if(_loc3_.text == this.api.lang.getText("SEARCH"))
            {
               this._eoSpellFilters.removeItemAt(1);
            }
            else
            {
               var sText = new ank.utils.ExtendedString(_loc3_.text).removeAccents().toLowerCase();
               this._eoSpellFilters.addItemAt(1,{fn:function(oSpell)
               {
                  return new ank.utils.ExtendedString(oSpell.name).removeAccents().toLowerCase().indexOf(sText) > -1;
               }});
            }
            this.applySpellFilters();
            break;
         case this._tiFromLevel:
         case this._tiToLevel:
            var ref = this;
            this._eoSpellFilters.addItemAt(2,{fn:function(oSpell)
            {
               var _loc3_ = oSpell.normalMinPlayerLevel;
               if(_loc3_ == undefined)
               {
                  return true;
               }
               var _loc4_ = Number(ref._tiFromLevel.text);
               var _loc5_ = Number(ref._tiToLevel.text);
               if(_loc4_ == undefined || (_global.isNaN(_loc4_) || (_loc5_ == undefined || _global.isNaN(_loc5_))))
               {
                  return true;
               }
               return _loc3_ >= _loc4_ && _loc3_ <= _loc5_;
            }});
            this.applySpellFilters();
         default:
            return;
      }
   }
   function initData()
   {
      this._cbProgressFire.value = 0;
      this._ldrBreed.contentPath = dofus.Constants.BREEDS_BACK_PATH + this.api.datacenter.Player.Guild + ".swf";
      this._eaAvailableSpells = dofus.graphics.gapi.ui.SpellsCollection.getAvailableSpells();
      this.generateSpellsCollectionStatistics();
      var _loc2_ = this.getBreedSpells();
      var _loc3_ = _loc2_.nonPassiveSpells;
      this._suSpell1.setValue(true,undefined,_loc3_[0]);
      this._suSpell2.setValue(true,undefined,_loc3_[1]);
      this._suSpell3.setValue(true,undefined,_loc3_[2]);
      this._suSpell4.setValue(true,undefined,_loc3_[3]);
      this._suSpell5.setValue(true,undefined,_loc2_.passiveSpell);
      this.resetSpellFilters();
      this._btnFilterPossessed.selected = true;
      this._eoSpellFilters.addItemAt(4,{fn:function(oSpell)
      {
         return oSpell.isOwnedByPlayer;
      }});
      this.applySpellFilters();
      this.initCurrentDeckGrid();
      this.applySpellsDeck();
   }
   function initSpellsGrid()
   {
      this._cgSpells.setVPosition(0);
      this.applySpellFilters();
   }
   function initCurrentDeckGrid()
   {
      var _loc2_ = this.api.datacenter.Player.Spells;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.datacenter.spellscollection.SpellsDeck.DECK_CAPACITY)
      {
         _loc4_ = this["_ctrDeck" + (_loc3_ + 1)];
         _loc4_.contentData = undefined;
         _loc3_ = _loc3_ + 1;
      }
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc5_ < _loc2_.length)
      {
         _loc6_ = _loc2_[_loc5_];
         _loc7_ = _loc6_.position;
         if(_loc7_ != undefined)
         {
            _loc8_ = this["_ctrDeck" + _loc7_];
            _loc8_.contentData = _loc6_;
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   function getDeckContainer(nID)
   {
      return this["_ctrDeck" + nID];
   }
   function spellMove(nSpellID, nPosition)
   {
      var _loc4_ = this.api.datacenter.Player.Spells;
      var _loc5_ = _loc4_.findFirstItem("ID",nSpellID).item;
      if(_loc5_ == undefined)
      {
         return undefined;
      }
      this.getDeckContainer(nPosition).contentData = _loc5_;
      this.refreshGridSpellsOwnedState();
   }
   function spellRemove(nPosition)
   {
      this.getDeckContainer(nPosition).contentData = undefined;
      this.refreshGridSpellsOwnedState();
   }
   function refreshGridSpellsOwnedState()
   {
      var _loc2_ = this._cgSpells.visibleContainers;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = _loc2_[_loc3_];
         _loc4_.content.setSpellOwnedState();
         _loc3_ = _loc3_ + 1;
      }
   }
   function applySpellsDeck()
   {
      var _loc2_ = this.api.datacenter.Player.getSpellsDeck(this.api.datacenter.Player.currentSpellsDeckID);
      this._tiDeckName.removeEventListener("change",this);
      this._tiDeckName.text = _loc2_.name;
      this._tiDeckName.addEventListener("change",this);
   }
   function applySpellFilters()
   {
      var _loc2_ = this._eaAvailableSpells;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this._eoSpellFilters.getItems();
      var _loc5_ = 0;
      var _loc6_ = function(a_, b_)
      {
         var _loc4_ = a_.spell.name >= b_.spell.name ? 1 : -1;
         return a_.spell.rarity - b_.spell.rarity || _loc4_;
      };
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc7_ < _loc2_.length)
      {
         _loc8_ = _loc2_[_loc7_];
         _loc9_ = false;
         for(var k in _loc4_)
         {
            _loc10_ = _loc4_[k].fn;
            if(_loc10_ != undefined && !_loc10_.apply(this,[_loc8_]))
            {
               _loc9_ = true;
               break;
            }
         }
         if(_loc9_)
         {
            _loc5_ = _loc5_ + 1;
         }
         else
         {
            _loc3_.push(new dofus.datacenter.spellscollection.SpellsCollectionItemObject(_loc8_));
         }
         _loc7_ = _loc7_ + 1;
      }
      _loc3_.sort(_loc6_);
      this._mcResetSpellFilters._visible = _loc5_ > 0;
      this._lblNoSpellsFound._visible = _loc3_.length == 0;
      this._cgSpells.dataProvider = _loc3_;
      this._cgSpells.setVPosition(0);
   }
   function showSpellDetails(bShow, oSpell, bMoveRight)
   {
      this._sfivSpellFullInfosViewer.removeMovieClip();
      var _loc5_;
      if(bShow)
      {
         _loc5_ = this._nSpellFullInfosPlacerX;
         if(bMoveRight)
         {
            _loc5_ += 350;
         }
         this.attachMovie("SpellFullInfosViewer","_sfivSpellFullInfosViewer",this.getNextHighestDepth(),{_x:_loc5_,_y:this._mcSpellFullInfosPlacer._y});
         this._sfivSpellFullInfosViewer.addEventListener("close",this);
         this._sfivSpellFullInfosViewer.spell = oSpell;
      }
   }
   function close(oEvent)
   {
      this.showSpellDetails(false);
   }
   function resetSpellFilters()
   {
      this._tiFromLevel.text = String(dofus.graphics.gapi.ui.SpellsCollection.MIN_FILTER_DEFAULT_SPELL_LEVEL);
      this._tiToLevel.text = String(dofus.graphics.gapi.ui.SpellsCollection.MAX_FILTER_DEFAULT_SPELL_LEVEL);
      this._tiSearch.text = this.api.lang.getText("SEARCH");
      this._mcElementFilterSelected._visible = false;
      this._btnFilterMonster.selected = false;
      this._btnFilterCraft.selected = false;
      this._btnFilterUnknown.selected = false;
      this._btnFilterPossessed.selected = false;
      this._btnFilterNotPossessed.selected = false;
      this._eoSpellFilters = new ank.utils.ExtendedObject();
   }
   function initTexts()
   {
      this._tiSearch.text = !this._tiSearch.text.length ? this.api.lang.getText("SEARCH") : this._tiSearch.text;
      this._lblBreedSpell.text = this.api.lang.getText("CLASS_SPELLS");
      this._lblParchoSpells.text = this.api.lang.getText("PARCHOMANCIA_SPELLS");
      this._lblParchoSpellDescription.text = this.api.lang.getText("HELP_PARCHO_SPELL_DESCRIPTION");
      this._lblBreedSpellDescription.text = this.api.lang.getText("TR2_HELP_BREED_SPELL_DESCRIPTION");
      this._lblSpellDeck.text = this.api.lang.getText("SPELLS_DECK");
      this._lblDeckSpellDescription.text = this.api.lang.getText("TR2_HELP_SPELLS_DECK");
      this._lblLevelFrom.text = this.api.lang.getText("LEVEL") + " " + this.api.lang.getText("FROM");
      this._lblLevelFromMiddle.text = this.api.lang.getText("TO");
      this._lblNoSpellsFound.text = this.api.lang.getText("TR2_SPELLS_COLLECTION_NO_SPELLS_FOUND");
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(oEvent.target)
      {
         case this._ctrDeck1:
         case this._ctrDeck2:
         case this._ctrDeck3:
         case this._ctrDeck4:
         case this._ctrDeck5:
         case this._ctrDeck6:
         case this._ctrDeck7:
         case this._ctrDeck8:
         case this._ctrDeck9:
         case this._ctrDeck10:
         case this._ctrDeck11:
         case this._ctrDeck12:
         case this._ctrDeck13:
         case this._ctrDeck14:
            _loc3_ = oEvent.target;
            _loc4_ = dofus.datacenter.Spell(_loc3_.contentData);
            if(_loc4_ != undefined)
            {
               this.showSpellDetails(true,_loc4_,true);
            }
            break;
         case this._mcResetSpellFilters:
            this.resetSpellFilters();
            this.applySpellFilters();
            break;
         case this._ldrProgressFire:
         case this._circleProgressFire:
            this.onSpellCategoryClick(1,oEvent.target);
            break;
         case this._ldrProgressWater:
         case this._circleProgressWater:
            this.onSpellCategoryClick(2,oEvent.target);
            break;
         case this._ldrProgressEarth:
         case this._circleProgressEarth:
            this.onSpellCategoryClick(3,oEvent.target);
            break;
         case this._ldrProgressNeutral:
         case this._circleProgressNeutral:
            this.onSpellCategoryClick(4,oEvent.target);
            break;
         case this._ldrProgressAir:
         case this._circleProgressAir:
            this.onSpellCategoryClick(5,oEvent.target);
            break;
         case this._ldrProgressMulti:
         case this._circleProgressMulti:
            this.onSpellCategoryClick(6,oEvent.target);
            break;
         case this._ldrProgressInvoc:
         case this._circleProgressInvoc:
            this.onSpellCategoryClick(7,oEvent.target);
            break;
         case this._ldrProgressBoost:
         case this._circleProgressBoost:
            this.onSpellCategoryClick(8,oEvent.target);
            break;
         case this._ldrProgressHeal:
         case this._circleProgressHeal:
            this.onSpellCategoryClick(9,oEvent.target);
            break;
         case this._btnFilterMonster:
         case this._btnFilterCraft:
         case this._btnFilterUnknown:
            _loc5_ = oEvent.target.selected;
            this._btnFilterMonster.selected = false;
            this._btnFilterCraft.selected = false;
            this._btnFilterUnknown.selected = false;
            oEvent.target.selected = _loc5_;
            if(this._btnFilterMonster.selected)
            {
               this._eoSpellFilters.addItemAt(3,{fn:function(oSpell)
               {
                  return oSpell.origin == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_DROP_ON_MONSTER;
               }});
            }
            else if(this._btnFilterCraft.selected)
            {
               this._eoSpellFilters.addItemAt(3,{fn:function(oSpell)
               {
                  return oSpell.origin == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_CRAFT;
               }});
            }
            else if(this._btnFilterUnknown.selected)
            {
               this._eoSpellFilters.addItemAt(3,{fn:function(oSpell)
               {
                  return oSpell.origin == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_ORIGIN_UNKNOWN;
               }});
            }
            else
            {
               this._eoSpellFilters.removeItemAt(3);
            }
            this.applySpellFilters();
            this.api.sounds.events.onSpellCollectionButtonClick();
            break;
         case this._btnFilterPossessed:
         case this._btnFilterNotPossessed:
            _loc6_ = oEvent.target.selected;
            this._btnFilterPossessed.selected = false;
            this._btnFilterNotPossessed.selected = false;
            oEvent.target.selected = _loc6_;
            if(this._btnFilterPossessed.selected)
            {
               this._eoSpellFilters.addItemAt(4,{fn:function(oSpell)
               {
                  return oSpell.isOwnedByPlayer;
               }});
            }
            else if(this._btnFilterNotPossessed.selected)
            {
               this._eoSpellFilters.addItemAt(4,{fn:function(oSpell)
               {
                  return !oSpell.isOwnedByPlayer;
               }});
            }
            else
            {
               this._eoSpellFilters.removeItemAt(4);
            }
            this.applySpellFilters();
            this.api.sounds.events.onSpellCollectionButtonClick();
            break;
         case this._btnPreviousDeck:
            if(Key.isDown(Key.SHIFT))
            {
               this.showSwitchDeckPopupMenu();
            }
            else
            {
               this.goPreviousDeck();
            }
            this.api.sounds.events.onSpellCollectionButtonClick();
            break;
         case this._btnNextDeck:
            if(Key.isDown(Key.SHIFT))
            {
               this.showSwitchDeckPopupMenu();
            }
            else
            {
               this.goNextDeck();
            }
            this.api.sounds.events.onSpellCollectionButtonClick();
            break;
         case this._btnClose:
            this.callClose();
         default:
            return;
      }
   }
   function showSwitchDeckPopupMenu()
   {
      var _loc2_ = this.api.ui.createPopupMenu();
      var _loc3_ = this.api.datacenter.Player.SpellsDecks.getLength();
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_)
      {
         _loc5_ = this.api.datacenter.Player.getSpellsDeck(_loc4_);
         _loc2_.addItem(_loc5_.name,this,this.switchDeck,[_loc5_.ID],_loc5_.ID != this.api.datacenter.Player.currentSpellsDeckID);
         _loc4_ = _loc4_ + 1;
      }
      _loc2_.show();
   }
   function goPreviousDeck()
   {
      var _loc2_ = this.api.datacenter.Player.SpellsDecks.getLength();
      var _loc3_ = this.api.datacenter.Player.currentSpellsDeckID;
      _loc3_ = _loc3_ - 1;
      if(_loc3_ < 0)
      {
         _loc3_ = _loc2_ - 1;
      }
      this.switchDeck(_loc3_);
   }
   function goNextDeck()
   {
      var _loc2_ = this.api.datacenter.Player.SpellsDecks.getLength();
      var _loc3_ = this.api.datacenter.Player.currentSpellsDeckID;
      _loc3_ = _loc3_ + 1;
      if(_loc3_ >= _loc2_)
      {
         _loc3_ = 0;
      }
      this.switchDeck(_loc3_);
   }
   function switchDeck(nDeckID)
   {
      this.api.datacenter.Player.currentSpellsDeckID = nDeckID;
      this.applySpellsDeck();
      this.api.network.Temporis.episodeTwo.sendSpellsQuickLoad(nDeckID);
   }
   function modelChanged()
   {
      this.generateSpellsCollectionStatistics();
      this.initCurrentDeckGrid();
      this.initSpellsGrid();
   }
   function over(oEvent)
   {
      if(this._nDelayTooltipEventTimeout != undefined)
      {
         _global.clearTimeout(this._nDelayTooltipEventTimeout);
         this._nDelayTooltipEventTimeout = undefined;
      }
      var _loc3_ = _global.setTimeout(this,"doOver",50,oEvent);
      this._nDelayTooltipEventTimeout = _loc3_;
   }
   function doOver(oEvent)
   {
      this._nDelayTooltipEventTimeout = undefined;
      this.gapi.hideTooltip();
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnClose:
            this.gapi.showTooltip(this.api.lang.getText("LEAVE"));
            return;
         case this._btnFilterPossessed:
            this.gapi.showTooltip(this.api.lang.getText("TR2_SPELLS_COLLECTION_UI_FILTER_1") + "\n" + this.getProgressionTooltipText(this._oSpellsStatistics));
            return;
         case this._btnFilterNotPossessed:
            this.gapi.showTooltip(this.api.lang.getText("TR2_SPELLS_COLLECTION_UI_FILTER_2"));
            return;
         case this._btnFilterMonster:
            this.gapi.showTooltip(this.api.lang.getText("TR2_SPELLS_COLLECTION_UI_FILTER_3"));
            return;
         case this._btnFilterCraft:
            this.gapi.showTooltip(this.api.lang.getText("TR2_SPELLS_COLLECTION_UI_FILTER_4"));
            return;
         case this._btnFilterUnknown:
            this.gapi.showTooltip(this.api.lang.getText("TR2_SPELLS_COLLECTION_UI_FILTER_5"));
            return;
         case this._mcResetSpellFilters:
            this.gapi.showTooltip(this.api.lang.getText("RESET_ALL_FILTERS"));
            return;
         case this._ctrDeck1:
         case this._ctrDeck2:
         case this._ctrDeck3:
         case this._ctrDeck4:
         case this._ctrDeck5:
         case this._ctrDeck6:
         case this._ctrDeck7:
         case this._ctrDeck8:
         case this._ctrDeck9:
         case this._ctrDeck10:
         case this._ctrDeck11:
         case this._ctrDeck12:
         case this._ctrDeck13:
         case this._ctrDeck14:
            _loc3_ = oEvent.target;
            this._currentOverContainer = _loc3_;
            _loc4_ = _loc3_.contentData;
            if(_loc4_ != undefined)
            {
               this.gapi.showTooltip(_loc4_.name + " (" + (_loc4_.apCost >= 1 ? _loc4_.apCost : "1") + " " + this.api.lang.getText("AP") + (_loc4_.actualCriticalHit <= 0 ? "" : ", " + this.api.lang.getText("ACTUAL_CRITICAL_CHANCE") + ": 1/" + _loc4_.actualCriticalHit) + ")");
            }
            else
            {
               this.gapi.hideTooltip();
            }
            return;
         case this._ldrProgressFire:
         case this._circleProgressFire:
            this.onSpellCategoryOver(1,this._circleProgressFire);
            return;
         case this._ldrProgressWater:
         case this._circleProgressWater:
            this.onSpellCategoryOver(2,this._circleProgressWater);
            return;
         case this._ldrProgressEarth:
         case this._circleProgressEarth:
            this.onSpellCategoryOver(3,this._circleProgressEarth);
            return;
         case this._ldrProgressNeutral:
         case this._circleProgressNeutral:
            this.onSpellCategoryOver(4,this._circleProgressNeutral);
            return;
         case this._ldrProgressAir:
         case this._circleProgressAir:
            this.onSpellCategoryOver(5,this._circleProgressAir);
            return;
         case this._ldrProgressMulti:
         case this._circleProgressMulti:
            this.onSpellCategoryOver(6,this._circleProgressMulti);
            return;
         case this._ldrProgressInvoc:
         case this._circleProgressInvoc:
            this.onSpellCategoryOver(7,this._circleProgressInvoc);
            return;
         case this._ldrProgressBoost:
         case this._circleProgressBoost:
            this.onSpellCategoryOver(8,this._circleProgressBoost);
            return;
         case this._ldrProgressHeal:
         case this._circleProgressHeal:
            this.onSpellCategoryOver(9,this._circleProgressHeal);
            return;
         default:
            this.gapi.hideTooltip();
            return;
      }
   }
   function out(oEvent)
   {
      if(this._nDelayTooltipEventTimeout != undefined)
      {
         _global.clearTimeout(this._nDelayTooltipEventTimeout);
         this._nDelayTooltipEventTimeout = undefined;
      }
      var _loc3_ = _global.setTimeout(this,"doOut",50,oEvent);
      this._nDelayTooltipEventTimeout = _loc3_;
   }
   function doOut(oEvent)
   {
      this._nDelayTooltipEventTimeout = undefined;
      this._currentOverContainer = undefined;
      this.gapi.hideTooltip();
   }
   function createSpellActionPopupMenu(oSpell)
   {
      var _loc3_ = this.api.datacenter.Player.getSpellsDeck(this.api.datacenter.Player.currentSpellsDeckID);
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = dofus.datacenter.Spell(_loc3_.eoSpells.getItemAt(oSpell.position));
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = this.api.ui.createPopupMenu();
      _loc5_.addItem(this.api.lang.getText("TR2_REMOVE_SPELL_FROM_DECK"),this.api.network.Temporis.episodeTwo,this.api.network.Temporis.episodeTwo.sendSpellsQuickRemove,[this.api.datacenter.Player.currentSpellsDeckID,oSpell.position],!_loc4_.isUndeletable);
      _loc5_.show(_root._xmouse,_root._ymouse,true);
   }
   function selectItem(oEvent)
   {
      var _loc3_ = oEvent.spell;
      var _loc4_ = oEvent.isFromSpellUnwrap;
      var _loc5_;
      if(_loc3_ == undefined)
      {
         _loc5_ = oEvent.target;
         if(_loc5_ == undefined || _loc5_.contentData == undefined)
         {
            return undefined;
         }
         _loc3_ = dofus.datacenter.Spell(_loc5_.contentData.spell);
      }
      var _loc6_;
      if(oEvent.grade != undefined)
      {
         this.showSpellDetails(true,new dofus.datacenter.Spell(_loc3_.ID,oEvent.grade),_loc4_);
      }
      else
      {
         _loc6_ = this.api.datacenter.Player.getOwnedSpell(_loc3_.ID);
         if(_loc6_ == undefined)
         {
            this.showSpellDetails(true,_loc3_,_loc4_);
            return undefined;
         }
         this.showSpellDetails(true,_loc6_,_loc4_);
      }
   }
   function drag(oEvent)
   {
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      this.gapi.setCursor(oEvent.target.contentData);
   }
   function drop(oEvent)
   {
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(_loc3_ instanceof dofus.datacenter.Spell)
      {
         _loc4_ = dofus.datacenter.Spell(_loc3_);
         if(!_loc4_.isOwnedByPlayer)
         {
            return undefined;
         }
         _loc5_ = oEvent.target;
         _loc6_ = Number(_loc5_._name.split("_ctrDeck")[1]);
         this.api.network.Temporis.episodeTwo.sendSpellsQuickMove(this.api.datacenter.Player.currentSpellsDeckID,_loc4_.ID,_loc6_);
      }
      this.gapi.removeCursor();
   }
   function dragItem(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(!_loc3_.spell.isOwnedByPlayer)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ACTION_IMPOSSIBLE_SPELL_NOT_OWNED"),"ERROR_CHAT");
         return undefined;
      }
      this.gapi.removeCursor();
      this.gapi.setCursor(_loc3_.spell);
   }
   function dropItem(oEvent)
   {
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      switch(sShortcut)
      {
         case "CODE_NEXT":
            this.goNextDeck();
            _loc3_ = false;
            break;
         case "CODE_PREVIOUS":
            this.goPreviousDeck();
            _loc3_ = false;
      }
      return _loc3_;
   }
   function onSpellCategoryOver(nElementID, mc)
   {
      var _loc4_ = this.getCircleBarByElementID(nElementID);
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = this._eoSpellTypesStatistics.getItemAt(this.convertElementValueToSpellType(nElementID));
      this.gapi.showTooltip(this.getProgressionTooltipText(_loc5_));
   }
   function getProgressionTooltipText(oRes)
   {
      return oRes.ownedPercentage + "% (" + oRes.ownedCount + "/" + oRes.totalCount + ")";
   }
   function onSpellCategoryClick(nElementID, mc)
   {
      var _loc4_ = this.getCircleBarByElementID(nElementID);
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = this._eoSpellFilters.getItemAt(5);
      if(_loc5_ != undefined && _loc5_.elementID == nElementID)
      {
         this._mcElementFilterSelected._visible = false;
         this._eoSpellFilters.removeItemAt(5);
      }
      else
      {
         this._mcElementFilterSelected._y = this._nMcElementFilterSelectedY + (nElementID - 1) * 25.5;
         this._mcElementFilterSelected._visible = true;
         var nSpellType = this.convertElementValueToSpellType(nElementID);
         this._eoSpellFilters.addItemAt(5,{elementID:nElementID,fn:function(oSpell)
         {
            return oSpell.type == nSpellType;
         }});
      }
      this.applySpellFilters();
   }
   function convertElementValueToSpellType(nElement)
   {
      switch(nElement)
      {
         case 1:
            return 3;
         case 2:
            return 1;
         case 3:
            return 4;
         case 4:
            return 5;
         case 5:
            return 2;
         case 6:
            return 6;
         case 7:
            return 8;
         case 8:
            return 7;
         case 9:
            return 9;
         default:
            return;
      }
   }
   function getCircleBarByElementID(nElementID)
   {
      var _loc3_;
      switch(nElementID)
      {
         case 1:
            _loc3_ = this._cbProgressFire;
            break;
         case 2:
            _loc3_ = this._cbProgressWater;
            break;
         case 3:
            _loc3_ = this._cbProgressEarth;
            break;
         case 4:
            _loc3_ = this._cbProgressNeutral;
            break;
         case 5:
            _loc3_ = this._cbProgressAir;
            break;
         case 6:
            _loc3_ = this._cbProgressMulti;
            break;
         case 7:
            _loc3_ = this._cbProgressInvoc;
            break;
         case 8:
            _loc3_ = this._cbProgressBoost;
            break;
         case 9:
            _loc3_ = this._cbProgressHeal;
      }
      return _loc3_;
   }
   function generateSpellsCollectionStatistics()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      var _loc4_ = new ank.utils.ExtendedObject();
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc5_ < this._eaAvailableSpells.length)
      {
         _loc6_ = this._eaAvailableSpells[_loc5_];
         _loc7_ = _loc6_.type;
         _loc8_ = _loc6_.isOwnedByPlayer;
         if(_loc8_)
         {
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
         if(_loc7_ != undefined)
         {
            _loc9_ = _loc4_.getItemAt(_loc7_);
            if(_loc9_ == undefined)
            {
               _loc9_ = {};
               _loc9_.ownedCount = 0;
               _loc9_.totalCount = 0;
               _loc4_.addItemAt(_loc7_,_loc9_);
            }
            if(_loc8_)
            {
               _loc9_.ownedCount = _loc9_.ownedCount + 1;
            }
            _loc9_.totalCount = _loc9_.totalCount + 1;
         }
         _loc5_ = _loc5_ + 1;
      }
      var _loc10_ = _loc4_.getItems();
      var _loc11_;
      for(var k in _loc10_)
      {
         _loc11_ = _loc10_[k];
         _loc11_.ownedPercentage = Math.floor(_loc11_.ownedCount / _loc11_.totalCount * 100);
      }
      var _loc12_ = 0;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc12_ == 0 || _loc13_ != undefined)
      {
         _loc12_ = _loc12_ + 1;
         _loc13_ = this.getCircleBarByElementID(_loc12_);
         _loc14_ = this.convertElementValueToSpellType(_loc12_);
         _loc15_ = _loc4_.getItemAt(_loc14_);
         if(_loc15_ != undefined)
         {
            _loc13_.value = _loc15_.ownedPercentage;
         }
      }
      var _loc16_ = {};
      _loc16_.ownedCount = _loc2_;
      _loc16_.totalCount = _loc3_;
      _loc16_.ownedPercentage = Math.floor(_loc2_ / _loc3_ * 100);
      this._oSpellsStatistics = _loc16_;
      this._eoSpellTypesStatistics = _loc4_;
   }
   function getBreedSpells()
   {
      var _loc2_ = this.api.lang.getSpells();
      var _loc3_ = [];
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      for(var i in _loc2_)
      {
         _loc5_ = _loc2_[i];
         _loc6_ = new dofus.datacenter.Spell(Number(i),1);
         _loc7_ = _loc6_.category;
         if(_loc7_ == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_BREED && _loc6_.spellBreed == this.api.datacenter.Player.Guild)
         {
            if(_loc6_.isPassive)
            {
               _loc4_ = _loc6_;
               continue;
            }
            _loc3_.push(_loc6_);
         }
      }
      return {nonPassiveSpells:_loc3_,passiveSpell:_loc4_};
   }
   static function getAvailableSpells()
   {
      var _loc2_ = _global.API;
      var _loc3_ = _loc2_.lang.getSpells();
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      for(var i in _loc3_)
      {
         _loc5_ = _loc3_[i];
         _loc6_ = new dofus.datacenter.Spell(Number(i),1);
         if(!_loc6_.isPassive)
         {
            _loc7_ = _loc6_.category;
            if(_loc7_ == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_COMMON || (_loc7_ == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_RARE || (_loc7_ == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_EPIC || _loc7_ == dofus.graphics.gapi.ui.SpellsCollection.SPELLS_CATEGORY_TR2_LEGENDARY)))
            {
               _loc4_.push(_loc6_);
            }
         }
      }
      return _loc4_;
   }
}
