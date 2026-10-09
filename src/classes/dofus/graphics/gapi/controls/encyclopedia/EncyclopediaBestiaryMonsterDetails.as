class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aMonsterGrades;
   var _bInitialized;
   var _bgh;
   var _btnArchmonster;
   var _btnClose;
   var _btnMap;
   var _cgDrops;
   var _ctrJob1;
   var _ctrSpe1;
   var _lblAP;
   var _lblAir;
   var _lblDodgeAP;
   var _lblDodgeMP;
   var _lblEarth;
   var _lblFamily;
   var _lblFire;
   var _lblLP;
   var _lblLPValue;
   var _lblMP;
   var _lblName;
   var _lblNeutral;
   var _lblRes;
   var _lblResistances;
   var _lblSpells;
   var _lblWisdom;
   var _ldrSprite;
   var _lstSpells;
   var _mcAboutWisdom;
   var _mcBackground;
   var _mcButtons;
   var _mcGradesButtonsPlacer;
   var _mcOverEnergy;
   var _mcParentWindow;
   var _mcTitleBackground;
   var _nMonsterID;
   var _oMonster;
   var _oMonsterInfos;
   var _sCurrentTab;
   var addToQueue;
   var createEmptyMovieClip;
   var gapi;
   var removeMovieClip;
   static var RARE_BORDER = {ra:0,rb:220,ga:0,gb:220,ba:0,bb:220,ab:255};
   static var VERY_RARE_BORDER = {ra:0,rb:255,ga:0,gb:210,ba:0,bb:0,ab:255};
   static var DEFAULT_BORDER = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,ab:0};
   static var QUEST_BACKGROUND = {ra:50,rb:0,ga:100,gb:0,ba:50,bb:0};
   static var IMPOSSIBLE_BACKGROUND = {ra:100,rb:0,ga:50,gb:0,ba:50,bb:0};
   static var MAX_FULL_SIZE_BUTTON_LABELS = 6;
   static var INCARNAM_CENTRAL_MAP = 10287;
   static var AMAKNA_CENTRAL_MAP = 32;
   static var INCARNAM_SUPERAREA = 3;
   static var AMAKNA_SUPERAREA = 0;
   static var UNKNOWN_SUPERAREA = -1;
   var _nCurrentMonsterGrade = 1;
   var _bEmbeded = false;
   static var RESISTANCE_INFOS = [{label:"_lblFire",colorable:true},{label:"_lblRes",colorable:true},{label:"_lblEarth",colorable:true},{label:"_lblAir",colorable:true},{label:"_lblDodgeAP",colorable:true},{label:"_lblDodgeMP",colorable:false},{label:"_lblNeutral",colorable:false}];
   function EncyclopediaBestiaryMonsterDetails()
   {
      super();
   }
   function set monsterID(nMonsterID)
   {
      var _loc3_ = new dofus.datacenter.Monster(String(nMonsterID));
      this._oMonster = _loc3_;
      this._oMonsterInfos = this.api.lang.getMonstersText(nMonsterID);
      this._nMonsterID = nMonsterID;
      this._aMonsterGrades = this.getMonsterGrades();
      if(this._bInitialized)
      {
         this.initTexts();
         this.initData();
         this.initSprite();
         this.initGradeButtons();
      }
   }
   function set currentTab(sTab)
   {
      this._sCurrentTab = sTab;
   }
   function set embeded(bEmbeded)
   {
      this._bEmbeded = bEmbeded;
      this._bgh._visible = !bEmbeded;
      this._btnClose._visible = !bEmbeded;
      this._mcTitleBackground._visible = !bEmbeded;
      this._mcBackground._visible = !bEmbeded;
   }
   function setCurrentGradeTab(sNewTab)
   {
      var _loc3_ = this._mcButtons[this._sCurrentTab];
      var _loc4_ = this._mcButtons[sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this._nCurrentMonsterGrade = Number(this._sCurrentTab.substr(1,2));
      this.initData();
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this._btnArchmonster._visible = false;
      this._btnMap._visible = false;
      this._mcParentWindow = !this._bEmbeded ? this.api.ui.getUIComponent("Encyclopedia") : this.api.ui.getUIComponent("EncyclopediaDetailsWindow");
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initSprite});
      this.addToQueue({object:this,method:this.initGradeButtons});
      this.addToQueue({object:this,method:this.setCurrentGradeTab,params:[this.getFirstAvailableGradeName()]});
   }
   function close()
   {
      this.api.datacenter.Player.removeEventListener("updatePartyProspection",this);
      this.api.datacenter.Player.removeEventListener("discernmentChanged",this);
      this.removeMovieClip();
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnMap.addEventListener("click",this);
      this._btnMap.addEventListener("over",this);
      this._btnMap.addEventListener("out",this);
      this._btnArchmonster.addEventListener("click",this);
      this._btnArchmonster.addEventListener("over",this);
      this._btnArchmonster.addEventListener("out",this);
      this._cgDrops.addEventListener("overItem",this);
      this._cgDrops.addEventListener("outItem",this);
      this._cgDrops.addEventListener("selectItem",this);
      this._cgDrops.addEventListener("scrollGrid",this);
      this.api.datacenter.Player.addEventListener("updatePartyProspection",this);
      this.api.datacenter.Player.addEventListener("discernmentChanged",this);
      this._lstSpells.addEventListener("itemSelected",this);
      this._lstSpells.addEventListener("itemRollOver",this);
      this._lstSpells.addEventListener("itemRollOut",this);
      this._lblFire.addEventListener("over",this);
      this._lblFire.addEventListener("out",this);
      this._lblFire.enableOverEvents = true;
      this._lblRes.addEventListener("over",this);
      this._lblRes.addEventListener("out",this);
      this._lblRes.enableOverEvents = true;
      this._lblEarth.addEventListener("over",this);
      this._lblEarth.addEventListener("out",this);
      this._lblEarth.enableOverEvents = true;
      this._lblAir.addEventListener("over",this);
      this._lblAir.addEventListener("out",this);
      this._lblAir.enableOverEvents = true;
      this._lblDodgeAP.addEventListener("over",this);
      this._lblDodgeAP.addEventListener("out",this);
      this._lblDodgeAP.enableOverEvents = true;
      this._lblDodgeMP.addEventListener("over",this);
      this._lblDodgeMP.addEventListener("out",this);
      this._lblDodgeMP.enableOverEvents = true;
      this._lblNeutral.addEventListener("over",this);
      this._lblNeutral.addEventListener("out",this);
      this._lblNeutral.enableOverEvents = true;
   }
   function initTexts()
   {
      this._lblName.text = this._oMonster.name + (!dofus.Constants.DEBUG ? "" : " (" + this._nMonsterID + " - GFX : " + this._oMonster.gfxID + ")");
      this._lblFamily.text = this.api.lang.getText("TTG_FAMILY") + ": " + this._oMonster.categoryName;
      this._lblLP.text = this.api.lang.getText("LIFEPOINTS");
      this._lblMP.text = this.api.lang.getText("MOVEPOINTS");
      this._lblAP.text = this.api.lang.getText("ACTIONPOINTS");
      this._ctrJob1.text = this.api.lang.getText("INITIATIVE");
      this._lblLP.text = this.api.lang.getText("LIFEPOINTS");
      this._lblResistances.text = this.api.lang.getText("RESISTANCES");
      this._lblSpells.text = this.api.lang.getText("BANNER_TAB_SPELLS");
      this._mcAboutWisdom.text = this.api.lang.getText("CHARACTERISTICS");
   }
   function initData()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.lang.getMonsterDrops(this._nMonsterID);
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc4_ = Number(k);
         if(dofus.datacenter.ItemDrop.isEnabled(this._nMonsterID,_loc4_))
         {
            _loc2_.push(new dofus.datacenter.ItemDrop(this._nMonsterID,this._nCurrentMonsterGrade,_loc4_,1,String(this.api.lang.getItemStats(_loc4_))));
         }
      }
      this._cgDrops.dataProvider = _loc2_;
      this.updateContainers();
      this.updateGradeInfos();
      this.updateSpells();
      this.updateArchmonsterButton();
      this.updateMapButton();
   }
   function initSprite()
   {
      this._ldrSprite.accessories = this._oMonster.accessories;
      this._ldrSprite.colors = [this._oMonster.color1,this._oMonster.color2,this._oMonster.color3];
      this._ldrSprite.gfxID = this._oMonster.gfxID;
   }
   function initGradeButtons()
   {
      this._mcButtons.removeMovieClip();
      this.createEmptyMovieClip("_mcButtons",10);
      var _loc2_ = this._aMonsterGrades.length;
      var _loc3_ = this._mcGradesButtonsPlacer._width / _loc2_;
      var _loc4_ = _loc2_ > dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.MAX_FULL_SIZE_BUTTON_LABELS;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < _loc2_)
      {
         _loc6_ = this._aMonsterGrades[_loc5_];
         _loc7_ = this.createGradeButton(_loc6_,_loc4_);
         _loc7_.addEventListener("click",this);
         _loc7_.setSize(_loc3_,this._mcGradesButtonsPlacer._height);
         _loc7_._x = this._mcGradesButtonsPlacer._x + _loc5_ * _loc3_;
         _loc7_._y = this._mcGradesButtonsPlacer._y;
         _loc5_ = _loc5_ + 1;
      }
   }
   function getMonsterGrades()
   {
      var _loc3_ = -1;
      var _loc4_ = [];
      var _loc5_ = 1;
      var _loc6_;
      var _loc2_;
      var _loc7_;
      for(; _loc5_ <= 10; _loc5_ = _loc5_ + 1)
      {
         _loc6_ = _loc2_;
         _loc2_ = this._oMonsterInfos["g" + _loc5_];
         _loc7_ = _loc2_.e;
         if(!(_loc2_ == undefined || !_loc7_))
         {
            if(_loc6_ != undefined)
            {
               if(this.areGradesEqual(_loc6_,_loc2_))
               {
                  continue;
               }
            }
            _loc4_.push(_loc5_);
         }
      }
      return _loc4_;
   }
   function areGradesEqual(oGrade1, oGrade2)
   {
      return this.areValuesEqual(oGrade1,oGrade2);
   }
   function areValuesEqual(oValue1, oValue2)
   {
      if(oValue1 === oValue2)
      {
         return true;
      }
      if(oValue1 == undefined || oValue2 == undefined)
      {
         return false;
      }
      var _loc4_;
      if(oValue1 instanceof Array || oValue2 instanceof Array)
      {
         if(!(oValue1 instanceof Array) || !(oValue2 instanceof Array))
         {
            return false;
         }
         if(oValue1.length != oValue2.length)
         {
            return false;
         }
         _loc4_ = 0;
         while(_loc4_ < oValue1.length)
         {
            if(!this.areValuesEqual(oValue1[_loc4_],oValue2[_loc4_]))
            {
               return false;
            }
            _loc4_ = _loc4_ + 1;
         }
         return true;
      }
      if(typeof oValue1 == "object" || typeof oValue2 == "object")
      {
         if(typeof oValue1 != "object" || typeof oValue2 != "object")
         {
            return false;
         }
         return this.areObjectsEqual(oValue1,oValue2);
      }
      return oValue1 == oValue2;
   }
   function areObjectsEqual(oObject1, oObject2)
   {
      for(var _loc4_ in oObject1)
      {
         if(oObject2[_loc4_] == undefined && oObject1[_loc4_] != undefined)
         {
            return false;
         }
         if(!this.areValuesEqual(oObject1[_loc4_],oObject2[_loc4_]))
         {
            return false;
         }
      }
      for(_loc4_ in oObject2)
      {
         if(oObject1[_loc4_] == undefined && oObject2[_loc4_] != undefined)
         {
            return false;
         }
      }
      return true;
   }
   function createGradeButton(nGradeIndex, bSmallLabel)
   {
      var _loc4_ = ank.gapi.controls.Button(this._mcButtons.attachMovie("Button","g" + nGradeIndex,nGradeIndex,{backgroundDown:"ButtonTabDown",backgroundUp:"ButtonTabUp",toggle:true,styleName:"MiddleBrownTabButton",label:(!bSmallLabel ? this.api.lang.getText("LEVEL_SMALL") + " " : this.api.lang.getText("LEVEL_VERY_SMALL")) + this._oMonsterInfos["g" + nGradeIndex].l,selected:true,grade:"g" + nGradeIndex}));
      return _loc4_;
   }
   function getFirstAvailableGradeName()
   {
      return "g" + this._aMonsterGrades[0];
   }
   function updateContainers()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._cgDrops.dataProvider.length)
      {
         _loc3_ = this._cgDrops.getContainer(_loc2_);
         this.updateCtrBorder(_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function updateCtrBorder(ctr)
   {
      var _loc3_ = dofus.datacenter.ItemDrop(ctr.contentData);
      var _loc4_ = _loc3_.getDropRate(false);
      if(_loc4_ < dofus.datacenter.ItemDrop.VERY_RARE_VALUE)
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.VERY_RARE_BORDER;
      }
      else if(_loc4_ <= dofus.datacenter.ItemDrop.RARE_VALUE && _loc4_ != undefined)
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.RARE_BORDER;
      }
      else
      {
         ctr.borderTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.DEFAULT_BORDER;
      }
      var _loc5_ = "";
      var _loc6_ = this.api.datacenter.Player.totalPartyProspection;
      if(_loc6_ < _loc3_.minimumProspection)
      {
         ctr.backgroundTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.IMPOSSIBLE_BACKGROUND;
      }
      else if(_loc3_.isQuest)
      {
         ctr.backgroundTransform = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.QUEST_BACKGROUND;
         _loc5_ = "QuestBook";
      }
      else
      {
         ctr.backgroundTransform = dofus.Constants.NO_TRANSFORM;
      }
      if(_loc3_.hasDropConditions)
      {
         _loc5_ = "ExclamationBlue";
      }
      ctr.cornerIcon = _loc5_;
   }
   function updateGradeInfos()
   {
      var _loc2_ = this._oMonsterInfos[this._sCurrentTab];
      this._lblLPValue.text = _loc2_.lp;
      this._ctrSpe1.text = _loc2_.ap;
      this._mcOverEnergy.text = _loc2_.mp;
      this._lblWisdom.text = _loc2_.i;
      var _loc3_ = _loc2_.r;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         _loc6_ = this[dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.RESISTANCE_INFOS[_loc4_].label];
         _loc7_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.RESISTANCE_INFOS[_loc4_].colorable;
         this.updateResistanceLabelTextAndColor(_loc6_,_loc5_,_loc7_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function updateSpells()
   {
      var _loc2_ = this._oMonster.getSpells(this._sCurrentTab);
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc2_.length)
      {
         _loc5_ = _loc2_[_loc4_];
         _loc6_ = _loc5_.i;
         _loc7_ = _loc5_.l;
         _loc3_.push(new dofus.datacenter.Spell(_loc6_,_loc7_));
         _loc4_ = _loc4_ + 1;
      }
      this._lstSpells.dataProvider = _loc3_;
   }
   function updateArchmonsterButton()
   {
      this._btnArchmonster._visible = this._oMonster.alternateMonsterID != undefined;
      this._btnArchmonster.selected = this._oMonster.isArchmonster;
   }
   function updateMapButton()
   {
      this._btnMap._visible = this.isMonsterOutdoor();
   }
   function updateResistanceLabelTextAndColor(oLabel, nValue_, bChangeColor)
   {
      if(bChangeColor)
      {
         if(nValue_ > 0)
         {
            oLabel.styleName = "GreenLeftExtraSmallLabel";
         }
         else if(nValue_ < 0)
         {
            oLabel.styleName = "DarkRedLeftExtraSmallLabel";
         }
         else
         {
            oLabel.styleName = "BrownLeftExtraSmallLabel";
         }
      }
      oLabel.text = nValue_ != undefined ? nValue_ + "%" : "0%";
   }
   function isMonsterOutdoor()
   {
      var _loc2_ = this._oMonster.spawn;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.a.length)
      {
         _loc4_ = this.api.kernel.AreasManager.getOutdoorMapsFromSubarea(_loc2_.a[_loc3_]);
         for(var prop in _loc4_)
         {
            return true;
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
      var _loc5_ = 0;
      while(_loc5_ < _loc2_.m.length)
      {
         if(dofus.datacenter.DofusMap.isOutdoor(_loc2_.m[_loc5_]))
         {
            return true;
         }
         _loc5_ = _loc5_ + 1;
      }
      return false;
   }
   function selectItem(oEvent_)
   {
      var _loc3_ = oEvent_.target.contentData;
      var _loc4_;
      var _loc5_;
      if(_loc3_ != undefined)
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(_loc3_);
         }
         else
         {
            _loc4_ = {id:_loc3_.unicID,effects:_loc3_.compressedEffects};
            _loc5_ = !_loc3_.isConsideredAsEquipementInEncyclopediaDetailWindow ? "Ressources" : "Equipments";
            this.api.ui.loadUIComponent("EncyclopediaDetailsWindow","EncyclopediaDetailsWindow",{component:_loc5_,data:_loc4_},{bStayIfPresent:true,bAlwaysOnTop:true});
         }
      }
   }
   function scrollGrid(oEvent_)
   {
      this.updateContainers();
   }
   function click(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.close();
            return;
         case this._btnMap:
            _loc3_ = this._oMonster.spawn;
            _loc4_ = this.getAppropriateSuperarea(this._oMonster.spawn.sa);
            _loc5_ = this.getHighlightedMaps(_loc3_.a,_loc3_.m,_loc4_);
            _loc6_ = this.getCentralMap(_loc4_);
            _loc7_ = 40;
            _loc8_ = _loc6_ == undefined;
            this.gapi.loadUIComponent("MapExplorer","MapExplorer",{nHideSprites:1,_oHighlightedMaps:_loc5_,_dmMap:_loc6_,_bShowPlayerPosition:_loc8_,_nForcedInitialZoom:_loc7_,_bSaveZoom:false,_bSavePosition:false});
            return;
         case this._btnArchmonster:
            this.monsterID = this._oMonster.alternateMonsterID;
            _loc9_ = this._nCurrentMonsterGrade <= this._aMonsterGrades.length ? this._sCurrentTab : this.getFirstAvailableGradeName();
            this.setCurrentGradeTab(_loc9_);
            return;
         default:
            _loc10_ = oEvent_.target.grade;
            this.setCurrentGradeTab(_loc10_);
            return;
      }
   }
   function getHighlightedMaps(aSubareaIDs, aFixedMapIDs, nSuperarea)
   {
      var _loc5_ = [];
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(aSubareaIDs != undefined)
      {
         _loc6_ = 0;
         while(_loc6_ < aSubareaIDs.length)
         {
            _loc7_ = this.api.kernel.AreasManager.getOutdoorMapsFromSubarea(aSubareaIDs[_loc6_]);
            for(var nMapID in _loc7_)
            {
               _loc8_ = new dofus.datacenter.DofusMap(Number(nMapID));
               if(nSuperarea != _loc8_.superarea)
               {
                  break;
               }
               _loc5_[nMapID] = _loc7_[nMapID];
            }
            _loc6_ = _loc6_ + 1;
         }
      }
      var _loc9_;
      var _loc10_;
      var _loc11_;
      if(aFixedMapIDs != undefined)
      {
         _loc9_ = 0;
         while(_loc9_ < aFixedMapIDs.length)
         {
            _loc10_ = aFixedMapIDs[_loc9_];
            _loc11_ = new dofus.datacenter.DofusMap(Number(_loc10_));
            if(nSuperarea == _loc11_.superarea)
            {
               _loc5_[_loc10_] = this.api.lang.getMapText(_loc10_);
            }
            _loc9_ = _loc9_ + 1;
         }
      }
      return _loc5_;
   }
   function getAppropriateSuperarea(aSuperareaIDs)
   {
      var _loc3_ = 0;
      while(_loc3_ < aSuperareaIDs.length)
      {
         if(this.api.datacenter.Map.superarea == aSuperareaIDs[_loc3_])
         {
            return this.api.datacenter.Map.superarea;
         }
         _loc3_ = _loc3_ + 1;
      }
      if(aSuperareaIDs.length > 0)
      {
         return aSuperareaIDs[0];
      }
      return this.api.datacenter.Map.superarea;
   }
   function getCentralMap(nSuperarea)
   {
      if(nSuperarea == this.api.datacenter.Map.superarea)
      {
         return undefined;
      }
      if(nSuperarea == dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.AMAKNA_SUPERAREA || nSuperarea == dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.UNKNOWN_SUPERAREA)
      {
         return new dofus.datacenter.DofusMap(dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.AMAKNA_CENTRAL_MAP);
      }
      if(nSuperarea == dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.INCARNAM_SUPERAREA)
      {
         return new dofus.datacenter.DofusMap(dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryMonsterDetails.INCARNAM_CENTRAL_MAP);
      }
      return undefined;
   }
   function itemSelected(oEvent_)
   {
      if(dofus.Constants.DEBUG)
      {
         if(oEvent_.row.item != undefined)
         {
            this.gapi.loadUIComponent("SpellInfos","SpellInfos",{spell:oEvent_.row.item});
         }
      }
   }
   function over(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target)
      {
         case this._btnMap:
            this.api.ui.showTooltip(this.api.lang.getText("DISPLAY_MONSTER_AREA_ON_MAP"));
            break;
         case this._btnArchmonster:
            _loc3_ = !this._btnArchmonster.selected ? "DISPLAY_ARCHMONSTER_OF_MONSTER" : "DISPLAY_MONSTER_OF_ARCHMONSTER";
            this.api.ui.showTooltip(this.api.lang.getText(_loc3_));
            break;
         case this._lblFire:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID32"));
            break;
         case this._lblRes:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID36"));
            break;
         case this._lblEarth:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID48"));
            break;
         case this._lblAir:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID40"));
            break;
         case this._lblDodgeAP:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID44"));
            break;
         case this._lblDodgeMP:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID29"));
            break;
         case this._lblNeutral:
            this.api.ui.showTooltip(this.api.lang.getText("FULL_STATS_ID30"));
         default:
            return;
      }
   }
   function overItem(oEvent_)
   {
      var _loc3_ = oEvent_.target.contentData;
      var _loc4_;
      if(_loc3_ != undefined)
      {
         _loc4_ = dofus.datacenter.ItemDrop(_loc3_);
         _loc4_.showStatsTooltip(_loc4_.style,_loc4_.getDropInfosString());
         this._mcParentWindow.currentOverItem = _loc4_;
      }
   }
   function itemRollOver(oEvent_)
   {
      if(dofus.Constants.DEBUG)
      {
         this.api.ui.showTooltip("[Debug] Clic pour afficher le sort");
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function outItem(oEvent_)
   {
      this.api.ui.hideTooltip();
      this._mcParentWindow.currentOverItem = undefined;
   }
   function itemRollOut(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function updatePartyProspection(oEvent_)
   {
      this.updateContainers();
   }
   function discernmentChanged(oEvent_)
   {
      this.updateContainers();
   }
}
