class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSearchedMonsterIDs;
   var _bIgnoreSubareaFilterIfEmpty;
   var _dgMonsters;
   var _filtersList;
   var _lblCount;
   var _mcEncyclopedia;
   var _nAreaFilterIndex;
   var _nSubareaInitialFilter;
   var _oFilterTag;
   var addToQueue;
   var attachMovie;
   var getNextHighestDepth;
   static var _eaData;
   static var CLASS_NAME = "EncyclopediaBestiaryViewer";
   static var CATEGORY_CLASSIC = 1;
   static var CATEGORY_ARCHMONSTER = 2;
   static var CATEGORY_BOSS = 3;
   static var _nMonsterMaxLevel = 1;
   function EncyclopediaBestiaryViewer()
   {
      super();
   }
   function set focusMonster(nMonsterID)
   {
      this.displayDetails(nMonsterID);
   }
   function get monsterMaxLevel()
   {
      return dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._nMonsterMaxLevel;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this._mcEncyclopedia = this.api.ui.getUIComponent("Encyclopedia");
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initFilters});
      this.addToQueue({object:this,method:this.setTagFilter});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._dgMonsters.addEventListener("itemSelected",this);
      this._dgMonsters.addEventListener("itemRollOver",this);
      this._dgMonsters.addEventListener("itemRollOut",this);
      this._filtersList.addEventListener("filterChanged",this);
      this._filtersList.addEventListener("filterClosed",this);
   }
   function initFilters()
   {
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("MONSTER_TITLE"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterSearch("searchName"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterInterval("LEVEL","lvlMin","lvlMax",1,this.monsterMaxLevel));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("AREA"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory("areas",this.getMonsterAreaList()));
      this._nAreaFilterIndex = this._filtersList.length - 1;
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("MONSTER_FAMILY"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory("type",this.getMonsterTypeList()));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabel("MONSTER_CATEGORY"));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck("MONSTERS","basic",true,dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_INCLUDE));
      this._filtersList.addFilter(new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck("DUNGEON_GUARDIANS","boss",true,dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_INCLUDE));
      var _loc2_ = new dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck("ARCHMONSTERS","archmonster",false,dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_INCLUDE);
      _loc2_.checked = this.searchedMonstersIncludeArchMonster();
      this._filtersList.addFilter(_loc2_);
      this._filtersList.drawAll();
   }
   function searchedMonstersIncludeArchMonster()
   {
      var _loc2_;
      var _loc3_;
      if(this._aSearchedMonsterIDs != undefined && this._aSearchedMonsterIDs.length > 0)
      {
         _loc2_ = dofus.datacenter.Monster.MONSTER_CATEGORY_MINI_BOSS;
         _loc3_ = 0;
         while(_loc3_ < this._aSearchedMonsterIDs.length)
         {
            if(this.api.lang.getMonstersText(this._aSearchedMonsterIDs[_loc3_]).b == _loc2_)
            {
               return true;
            }
            _loc3_ = _loc3_ + 1;
         }
      }
      return false;
   }
   function setTagFilter()
   {
      var _loc2_;
      var _loc3_;
      if(this._aSearchedMonsterIDs != undefined && this._aSearchedMonsterIDs.length > 0)
      {
         _loc2_ = this.api.lang.getText("TARGETED_SEARCH");
         this._oFilterTag = new dofus.graphics.gapi.controls.encyclopedia.filters.FilterTag(_loc2_,"id",this._aSearchedMonsterIDs);
         this._filtersList.addFilter(this._oFilterTag);
      }
      else if(this._nSubareaInitialFilter != undefined)
      {
         _loc3_ = new dofus.datacenter.Subarea(this._nSubareaInitialFilter).name;
         this._oFilterTag = new dofus.graphics.gapi.controls.encyclopedia.filters.FilterTag(_loc3_,"subareas",[this._nSubareaInitialFilter]);
         if(!this._bIgnoreSubareaFilterIfEmpty || this.filterHasResults(this._oFilterTag))
         {
            this._filtersList.addFilter(this._oFilterTag);
         }
      }
      if(this._nSubareaInitialFilter != undefined || this._aSearchedMonsterIDs != undefined)
      {
         this._nSubareaInitialFilter = undefined;
         this._aSearchedMonsterIDs = undefined;
         this._filtersList.drawAll();
      }
   }
   function filterHasResults(oFilter)
   {
      if(oFilter == undefined)
      {
         return false;
      }
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData.length)
      {
         _loc5_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData[_loc4_];
         if(oFilter.isObjectValid(_loc5_))
         {
            _loc3_.push(_loc5_);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_.length > 0;
   }
   function initTexts()
   {
      this._dgMonsters.columnsNames = ["",this.api.lang.getText("NAME_BIG"),this.api.lang.getText("LOOT"),this.api.lang.getText("LEVEL")];
      this._dgMonsters.columnsButtonsState = [false,true,false,true];
      this.updateCountLabel(0);
   }
   function initData()
   {
      if(dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData != undefined)
      {
         return undefined;
      }
      var _loc2_ = this.api.lang.getMonsters();
      var _loc3_ = dofus.Constants.DEBUG;
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData = new ank.utils.ExtendedArray();
      var _loc4_;
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
      for(var k in _loc2_)
      {
         _loc4_ = _loc2_[k];
         _loc5_ = _loc4_.e;
         if(!(!_loc5_ && _loc5_ != undefined))
         {
            _loc6_ = _loc4_.n + (!_loc3_ ? "" : " (" + k + ")");
            _loc7_ = _loc4_.nn + (!_loc3_ ? "" : " (" + k + ")");
            _loc8_ = _loc4_.g;
            _loc9_ = _loc4_.b;
            _loc10_ = String(this.api.lang.getMonstersRaceText(_loc9_).n);
            _loc11_ = this.getMinGradeLevel(_loc4_);
            _loc12_ = this.getMaxGradeLevel(_loc4_);
            _loc13_ = this.getMinMaxText(_loc11_,_loc12_);
            _loc14_ = this.api.lang.getMonsterDrops(Number(k));
            _loc15_ = _loc4_.colors;
            _loc16_ = this.getSpawnSubAreas(_loc4_);
            if(_loc12_ > dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._nMonsterMaxLevel)
            {
               dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._nMonsterMaxLevel = _loc12_;
            }
            _loc17_ = {name:_loc6_,searchName:_loc7_,id:k,gfxID:_loc8_,categoryName:_loc10_,type:_loc9_,loot:_loc14_,lvlMin:_loc11_,lvlMax:_loc12_,level:_loc13_,basic:this.isMonsterCategory(_loc4_,dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_CLASSIC),boss:this.isMonsterCategory(_loc4_,dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_BOSS),archmonster:this.isMonsterCategory(_loc4_,dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_ARCHMONSTER),colors:_loc15_,subareas:_loc16_,areas:this.getSpawnAreas(_loc16_)};
            dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData.push(_loc17_);
         }
      }
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData.sortOn("searchName");
   }
   function updateData()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      org.flashdevelop.utils.FlashConnect.trace("Filtre de " + dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData.length + " monstres","dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer::updateData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/controls/encyclopedia/EncyclopediaBestiaryViewer.as",262);
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData.length)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData[_loc3_];
         if(this._filtersList.isObjectValid(_loc4_))
         {
            _loc2_.push(_loc4_);
         }
         _loc3_ = _loc3_ + 1;
      }
      this._dgMonsters.dataProvider = _loc2_;
      this.updateCountLabel(_loc2_.length);
   }
   function updateCountLabel(nCount)
   {
      this._lblCount.text = nCount + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("MONSTER"),null,nCount < 2);
   }
   function getMinGradeLevel(oMonster)
   {
      var _loc3_ = 9999;
      var _loc4_ = 1;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ <= 10)
      {
         _loc5_ = oMonster["g" + _loc4_];
         _loc6_ = _loc5_.e;
         if(!(_loc5_ == undefined || !_loc6_))
         {
            _loc7_ = _loc5_.l;
            if(_loc3_ > _loc7_)
            {
               _loc3_ = _loc7_;
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function getMaxGradeLevel(oMonster)
   {
      var _loc3_ = 0;
      var _loc4_ = 1;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ <= 10)
      {
         _loc5_ = oMonster["g" + _loc4_];
         _loc6_ = _loc5_.e;
         if(!(_loc5_ == undefined || !_loc6_))
         {
            _loc7_ = _loc5_.l;
            if(_loc3_ < _loc7_)
            {
               _loc3_ = _loc7_;
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function getMinMaxText(nMin, nMax)
   {
      if(nMin == nMax)
      {
         return String(nMin);
      }
      return nMin + " " + this.api.lang.getText("TO") + " " + nMax;
   }
   function getMonsterTypeList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = dofus.datacenter.Monster.MONSTER_CATEGORY_MINI_BOSS;
      var _loc4_ = dofus.datacenter.Monster.MONSTER_CATEGORY_SOLO_BOSS;
      var _loc5_ = {};
      var _loc6_;
      var _loc7_;
      for(var k in dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData)
      {
         _loc6_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData[k];
         _loc7_ = _loc6_.type;
         if(!_loc5_[_loc7_] && (_loc7_ != _loc3_ && _loc7_ != _loc4_))
         {
            _loc2_.push({label:this.api.lang.getMonstersRaceText(_loc7_).n,id:_loc7_});
            _loc5_[_loc7_] = true;
         }
      }
      _loc2_.sortOn("label");
      _loc2_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID});
      return _loc2_;
   }
   function isMonsterCategory(oMonster, nCategory)
   {
      var _loc4_ = dofus.datacenter.Monster.MONSTER_CATEGORY_MINI_BOSS;
      var _loc5_ = dofus.datacenter.Monster.MONSTER_CATEGORY_SOLO_BOSS;
      var _loc6_ = oMonster.b;
      var _loc7_ = oMonster.d || _loc6_ == _loc5_;
      var _loc8_ = _loc6_ == _loc4_;
      switch(nCategory)
      {
         case dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_CLASSIC:
            return !_loc7_ && !_loc8_;
         case dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_BOSS:
            return _loc7_;
         case dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer.CATEGORY_ARCHMONSTER:
            return _loc8_;
         default:
            return false;
      }
   }
   function displayDetails(nMonsterID)
   {
      if(!_global.isNaN(nMonsterID))
      {
         this._filtersList.closeAll();
         this.attachMovie("EncyclopediaBestiaryMonsterDetails","_mcDetails",this.getNextHighestDepth(),{monsterID:nMonsterID});
      }
   }
   function getMonsterAreaList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = {};
      var _loc4_;
      var _loc5_;
      for(var k in dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData)
      {
         _loc4_ = dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData[k];
         for(var i in _loc4_.areas)
         {
            _loc5_ = Number(_loc4_.areas[i]);
            if(!_loc3_[_loc5_])
            {
               _loc2_.push({label:this.api.lang.getMapAreaText(_loc5_).n + (!dofus.Constants.DEBUG ? "" : " (" + _loc5_ + ")"),id:_loc5_});
               _loc3_[_loc5_] = true;
            }
         }
      }
      _loc2_.sortOn("label");
      _loc2_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID});
      return _loc2_;
   }
   function getSpawnSubAreas(oMonster)
   {
      var _loc3_ = [];
      var _loc4_;
      for(var i in oMonster.spawn.a)
      {
         _loc4_ = Number(oMonster.spawn.a[i]);
         _loc3_.push(_loc4_);
      }
      var _loc5_;
      var _loc6_;
      if(_loc3_.length < 1)
      {
         for(var i in oMonster.spawn.m)
         {
            _loc5_ = Number(oMonster.spawn.m[i]);
            _loc6_ = Number(this.api.lang.getMapText(_loc5_).sa);
            if(!_global.isNaN(_loc6_))
            {
               _loc3_.push(_loc6_);
            }
         }
      }
      return _loc3_;
   }
   function getSpawnAreas(aSubAreas)
   {
      var _loc3_ = [];
      var _loc4_;
      var _loc5_;
      for(var i in aSubAreas)
      {
         _loc4_ = Number(aSubAreas[i]);
         _loc5_ = this.api.lang.getMapAreaInfos(_loc4_);
         _loc3_.push(_loc5_.areaID);
      }
      return _loc3_;
   }
   function itemSelected(oEvent_)
   {
      var _loc3_ = oEvent_.row.item;
      var _loc4_ = Number(_loc3_.id);
      this.displayDetails(_loc4_);
   }
   function itemRollOver(oEvent_)
   {
      oEvent_.row.cellRenderer_mc.over();
      this._mcEncyclopedia.currentOverItem = new dofus.datacenter.Monster(oEvent_.row.item.id);
   }
   function itemRollOut(oEvent_)
   {
      oEvent_.row.cellRenderer_mc.out();
      this._mcEncyclopedia.currentOverItem = undefined;
   }
   function filterChanged(oEvent_)
   {
      if(oEvent_.closeTag && this._oFilterTag != undefined)
      {
         this._filtersList.removeFilter(this._oFilterTag);
      }
      this.updateData();
   }
   function filterClosed(oEvent_)
   {
      var _loc3_ = dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant(oEvent_.value);
      this._filtersList.removeFilter(_loc3_);
      this.updateData();
   }
   static function resetData()
   {
      dofus.graphics.gapi.controls.encyclopedia.EncyclopediaBestiaryViewer._eaData = undefined;
   }
}
