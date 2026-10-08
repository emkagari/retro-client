90655987 - 1;
class dofus.graphics.gapi.controls.InventoryViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSelectedSuperTypes;
   var _btnFilterCards;
   var _btnFilterCeremonials;
   var _btnFilterEquipement;
   var _btnFilterNonEquipement;
   var _btnFilterRessoureces;
   var _btnFilterRunes;
   var _btnFilterSoul;
   var _btnMoreChoice;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _cbTypes;
   var _eaDataProvider;
   var _iifFilter;
   var _lblKama;
   var _nCurrentFilterID;
   var _name;
   var _oDataViewer;
   var _oKamasProvider;
   var _sCurrentSort;
   var _srSearch;
   var _tiSearch;
   var addToQueue;
   var dispatchEvent;
   var initialized;
   static var CLASS_NAME = "InventoryViewer";
   var _bFilterAtStart = true;
   var _bAutoFilter = true;
   var _bCanTransfer = false;
   var _nSelectedTypeID = 0;
   var _nLastProviderLen = 0;
   var _nLastFilterID = -1;
   var _sCurrentItemSearch = "";
   function InventoryViewer()
   {
      super();
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider.removeEventListener("modelChanged",this);
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      if(this.initialized)
      {
         this.modelChanged();
      }
   }
   function get dataProvider()
   {
      return this._eaDataProvider;
   }
   function set kamasProvider(oKamasProvider)
   {
      oKamasProvider.removeEventListener("kamaChanged",this);
      this._oKamasProvider = oKamasProvider;
      oKamasProvider.addEventListener("kamaChanged",this);
      if(this.initialized)
      {
         this.kamaChanged();
      }
   }
   function set filterAtStart(bFilterAtStart)
   {
      this._bFilterAtStart = bFilterAtStart;
   }
   function set autoFilter(bAutoFilter)
   {
      this._bAutoFilter = bAutoFilter;
   }
   function get currentFilterID()
   {
      return this._nCurrentFilterID;
   }
   function get customInventoryFilter()
   {
      return this._iifFilter;
   }
   function set customInventoryFilter(iif)
   {
      this._iifFilter = iif;
      if(this.initialized)
      {
         this.modelChanged();
      }
   }
   function get selectedItem()
   {
      return this._oDataViewer.selectedIndex;
   }
   function set canTransfer(bAllow)
   {
      this._bCanTransfer = bAllow;
   }
   function hideNonEquipementFilters()
   {
      this._btnMoreChoice._x = this._btnFilterNonEquipement._x;
      this._btnFilterNonEquipement._visible = false;
      this._btnFilterRessoureces._visible = false;
      this._btnFilterSoul._visible = false;
      this._btnFilterCards._visible = false;
      this._btnFilterRunes._visible = false;
      this._btnFilterCeremonials._visible = false;
      this.setFilter(0);
   }
   function hideNonCardsFilters()
   {
      this._btnMoreChoice._x = this._btnFilterNonEquipement._x;
      this._btnFilterCards._x = this._btnFilterEquipement._x;
      this._btnFilterEquipement._visible = false;
      this._btnFilterNonEquipement._visible = false;
      this._btnFilterRessoureces._visible = false;
      this._btnFilterSoul._visible = false;
      this._btnFilterRunes._visible = false;
      this._btnFilterCeremonials._visible = false;
      this.setFilter(4);
   }
   function setFilter(nFilter)
   {
      if(nFilter == this._nCurrentFilterID)
      {
         return undefined;
      }
      switch(nFilter)
      {
         case dofus.Constants.FILTER_ID_EQUIPEMENT:
            this.click({target:this._btnFilterEquipement});
            this._btnFilterEquipement.selected = true;
            break;
         case dofus.Constants.FILTER_ID_NONEQUIPEMENT:
            this.click({target:this._btnFilterNonEquipement});
            this._btnFilterNonEquipement.selected = true;
            break;
         case dofus.Constants.FILTER_ID_RESSOURCES:
            this.click({target:this._btnFilterRessoureces});
            this._btnFilterRessoureces.selected = true;
            break;
         case dofus.Constants.FILTER_ID_SOUL:
            this.click({target:this._btnFilterSoul});
            this._btnFilterSoul.selected = true;
            break;
         case dofus.Constants.FILTER_ID_CARDS:
            this.click({target:this._btnFilterCards});
            this._btnFilterCards.selected = true;
            break;
         case dofus.Constants.FILTER_ID_RUNES:
            this.click({target:this._btnFilterRunes});
            this._btnFilterRunes.selected = true;
            break;
         case dofus.Constants.FILTER_ID_CEREMONIAL:
            this.click({target:this._btnFilterCeremonials});
            this._btnFilterCeremonials.selected = true;
         default:
            return;
      }
   }
   function createChildren()
   {
      if(this._bAutoFilter)
      {
         if(this._bFilterAtStart)
         {
            this.addToQueue({object:this,method:this.setPreferedFilter});
         }
         else
         {
            this.addToQueue({object:this,method:this.setFilter,params:[this.getDefaultFilter()]});
         }
      }
      this.enableSearch(false);
   }
   function initTexts()
   {
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function addListeners()
   {
      this._btnFilterEquipement.addEventListener("click",this);
      this._btnFilterNonEquipement.addEventListener("click",this);
      this._btnFilterRessoureces.addEventListener("click",this);
      this._btnFilterSoul.addEventListener("click",this);
      this._btnFilterCards.addEventListener("click",this);
      this._btnFilterRunes.addEventListener("click",this);
      this._btnFilterCeremonials.addEventListener("click",this);
      this._btnSearch.addEventListener("click",this);
      this._btnMoreChoice.addEventListener("click",this);
      this._btnFilterEquipement.addEventListener("over",this);
      this._btnFilterNonEquipement.addEventListener("over",this);
      this._btnFilterRessoureces.addEventListener("over",this);
      this._btnFilterSoul.addEventListener("over",this);
      this._btnFilterCards.addEventListener("over",this);
      this._btnFilterRunes.addEventListener("over",this);
      this._btnFilterCeremonials.addEventListener("over",this);
      this._btnSearch.addEventListener("over",this);
      this._btnMoreChoice.addEventListener("over",this);
      this._btnFilterEquipement.addEventListener("out",this);
      this._btnFilterNonEquipement.addEventListener("out",this);
      this._btnFilterRessoureces.addEventListener("out",this);
      this._btnFilterSoul.addEventListener("out",this);
      this._btnFilterCards.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("out",this);
      this._btnFilterCeremonials.addEventListener("out",this);
      this._btnSearch.addEventListener("out",this);
      this._btnMoreChoice.addEventListener("out",this);
      this._cbTypes.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
   }
   function getDefaultFilter()
   {
      return dofus.Constants.FILTER_ID_EQUIPEMENT;
   }
   function setPreferedFilter()
   {
      var _loc2_ = [{count:0,id:dofus.Constants.FILTER_ID_EQUIPEMENT},{count:0,id:dofus.Constants.FILTER_ID_NONEQUIPEMENT},{count:0,id:dofus.Constants.FILTER_ID_RESSOURCES},{count:0,id:dofus.Constants.FILTER_ID_SOUL},{count:0,id:dofus.Constants.FILTER_ID_CARDS},{count:0,id:dofus.Constants.FILTER_ID_RUNES},{count:0,id:dofus.Constants.FILTER_ID_CEREMONIAL}];
      var _loc3_;
      var _loc4_;
      for(var k in this._eaDataProvider)
      {
         _loc3_ = this._eaDataProvider[k];
         _loc4_ = _loc3_.superType;
         if(dofus.Constants.FILTER_EQUIPEMENT[_loc4_])
         {
            _loc2_[0].count++;
         }
         if(dofus.Constants.FILTER_NONEQUIPEMENT[_loc4_])
         {
            _loc2_[1].count++;
         }
         if(dofus.Constants.FILTER_RESSOURCES[_loc4_])
         {
            _loc2_[2].count++;
         }
         if(dofus.Constants.FILTER_SOUL[_loc4_])
         {
            _loc2_[3].count++;
         }
         if(dofus.Constants.FILTER_CARDS[_loc4_])
         {
            _loc2_[4].count++;
         }
         if(dofus.Constants.FILTER_RUNES[_loc4_])
         {
            _loc2_[5].count++;
         }
         if(_loc3_.isCeremonial)
         {
            _loc2_[6].count++;
         }
      }
      _loc2_.reverse.sortOn("count");
      this.setFilter(_loc2_[0].id);
   }
   function getValidLastTypeId(eaDataProvider)
   {
      var _loc3_ = this.api.datacenter.Basics[dofus.graphics.gapi.controls.InventoryViewer.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name + "_" + this._name];
      var _loc4_;
      var _loc5_;
      for(var k in eaDataProvider)
      {
         _loc4_ = eaDataProvider[k];
         _loc5_ = _loc4_.type;
         if(_loc3_ == _loc5_)
         {
            return _loc3_;
         }
      }
      return 0;
   }
   function updateDataGrid(eaDataProvider)
   {
      var _loc3_ = this.getValidLastTypeId(eaDataProvider);
      this._nSelectedTypeID = _loc3_ != undefined ? _loc3_ : 0;
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_ = {};
      var _loc7_;
      var _loc8_;
      for(var k in eaDataProvider)
      {
         _loc7_ = eaDataProvider[k];
         if(_loc7_.position == -1 && (this._aSelectedSuperTypes[_loc7_.superType] && (this._iifFilter == null || (this._iifFilter == undefined || this._iifFilter.isItemListed(_loc7_)))))
         {
            _loc8_ = _loc7_.type;
            if(!_loc6_[_loc8_])
            {
               _loc5_.push({label:this.api.lang.getItemTypeText(_loc8_).n,id:_loc8_});
               _loc6_[_loc8_] = true;
            }
            if(this._nSelectedTypeID == 0 || _loc8_ == this._nSelectedTypeID)
            {
               _loc4_.push(_loc7_);
            }
         }
      }
      _loc5_.sortOn("label");
      _loc5_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:0});
      this._cbTypes.dataProvider = _loc5_;
      this.setType(this._nSelectedTypeID);
      this._oDataViewer.dataProvider = _loc4_;
      this.sortInventory(this._sCurrentSort);
      this.dispatchEvent({type:"updateTotalKamas",value:_loc4_});
   }
   function updateData()
   {
      this.updateDataGrid(this._eaDataProvider);
   }
   function setType(nTypeID)
   {
      var _loc3_ = this._cbTypes.dataProvider;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         if(_loc3_[_loc4_].id == nTypeID)
         {
            this._cbTypes.selectedIndex = _loc4_;
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._nSelectedTypeID = 0;
      this._cbTypes.selectedIndex = this._nSelectedTypeID;
   }
   function sortInventory(sField)
   {
      if(!sField)
      {
         return undefined;
      }
      this._oDataViewer.dataProvider.sortOn(sField,Array.NUMERIC);
      this._sCurrentSort = sField;
      this._nLastProviderLen = this._oDataViewer.dataProvider.length;
      this._nLastFilterID = this._nCurrentFilterID;
      this._oDataViewer.modelChanged();
   }
   function resetSort()
   {
      if(this._sCurrentSort == undefined)
      {
         return undefined;
      }
      this._sCurrentSort = undefined;
      this.updateDataGrid(this._eaDataProvider);
   }
   function transferAll(bExisting)
   {
      var _loc3_ = "";
      var _loc4_ = 0;
      while(_loc4_ < this._aSelectedSuperTypes.length)
      {
         if(this._aSelectedSuperTypes[_loc4_])
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += ",";
            }
            _loc3_ += _loc4_;
         }
         _loc4_ = _loc4_ + 1;
      }
      this.api.network.Exchange.transferAll((!bExisting ? "1" : "2") + "|" + _loc3_);
   }
   function enableSearch(bEnable)
   {
      if(bEnable)
      {
         this._tiSearch._visible = true;
         this._srSearch._visible = true;
         this._cbTypes._visible = false;
         this._cbTypes.closeList();
         this._tiSearch.setFocus();
      }
      else
      {
         this._tiSearch._visible = false;
         this._srSearch._visible = false;
         this._tiSearch.clearText();
         this._sCurrentItemSearch = "";
         this._cbTypes._visible = true;
      }
   }
   function searchItem(sText_)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this._aSelectedSuperTypes == dofus.Constants.FILTER_SOUL;
      sText_ = new ank.utils.ExtendedString(sText_).removeAccents().toUpperCase();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      for(var i in this._eaDataProvider)
      {
         _loc5_ = this._eaDataProvider[i];
         if(_loc4_)
         {
            _loc6_ = _loc5_.getMonsterList();
            if(!(!_loc6_ || _loc6_.length == 0))
            {
               _loc7_ = _loc6_.split("|");
               for(var k in _loc7_)
               {
                  _loc8_ = Number(_loc7_[k]);
                  if(!_global.isNaN(_loc8_))
                  {
                     _loc9_ = new ank.utils.ExtendedString(this.api.lang.getMonstersText(_loc8_).n).removeAccents().toUpperCase();
                     if(_loc9_.indexOf(sText_) != -1)
                     {
                        _loc3_.push(_loc5_);
                        break;
                     }
                  }
               }
            }
         }
         else if(_loc5_.nameUppercase.indexOf(sText_) != -1)
         {
            _loc3_.push(_loc5_);
         }
      }
      this.updateDataGrid(_loc3_);
   }
   function modelChanged()
   {
      this.updateData();
      if(this._sCurrentItemSearch != "")
      {
         this.searchItem(this._sCurrentItemSearch);
      }
   }
   function kamaChanged(oEvent)
   {
      if(oEvent.value == undefined)
      {
         this._lblKama.text = "0";
      }
      else
      {
         this._lblKama.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      if(oEvent.target == this._btnMoreChoice)
      {
         _loc3_ = this.api.ui.createPopupMenu();
         _loc3_.addItem(this.api.lang.getText("ORDER_RESET"),this,this.resetSort);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_DATE_SORT"),this,this.sortInventory,["_itemDateId"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_NAME_SORT"),this,this.sortInventory,["_itemName"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_TYPE_SORT"),this,this.sortInventory,["_itemType"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_LEVEL_SORT"),this,this.sortInventory,["_itemLevel"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_POD_SORT"),this,this.sortInventory,["_itemWeight"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_QTY_SORT"),this,this.sortInventory,["_nQuantity"]);
         _loc3_.addItem(this.api.lang.getText("INVENTORY_FAVORITE_SORT"),this,this.sortInventory,["_itemFavorite"]);
         if(this._bCanTransfer)
         {
            _loc3_.addItem(this.api.lang.getText("INVENTORY_TRANSFER_EXISTING"),this,this.transferAll,[true]);
            _loc3_.addItem(this.api.lang.getText("INVENTORY_TRANSFER_ALL"),this,this.transferAll,[false]);
         }
         _loc3_.show(_root._xmouse,_root._ymouse);
         return undefined;
      }
      if(oEvent.target == this._btnSearch)
      {
         this.enableSearch(this._btnSearch.selected);
         if(!this._btnSearch.selected)
         {
            this.updateDataGrid(this._eaDataProvider);
         }
         return undefined;
      }
      if(oEvent.target != this._btnSelectedFilterButton)
      {
         this._btnSelectedFilterButton.selected = false;
         this._btnSelectedFilterButton = oEvent.target;
         this._iifFilter = undefined;
         if(this._btnSearch.selected)
         {
            this.enableSearch(false);
            this._btnSearch.selected = false;
         }
         switch(oEvent.target)
         {
            case this._btnFilterEquipement:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_EQUIPEMENT;
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
               break;
            case this._btnFilterNonEquipement:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_NONEQUIPEMENT;
               break;
            case this._btnFilterRessoureces:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_RESSOURCES;
               break;
            case this._btnFilterSoul:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_SOUL;
               break;
            case this._btnFilterCards:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_CARDS;
               break;
            case this._btnFilterRunes:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_RUNES;
               break;
            case this._btnFilterCeremonials:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
               this._nCurrentFilterID = dofus.Constants.FILTER_ID_CEREMONIAL;
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
         }
         this.updateData();
      }
      else
      {
         oEvent.target.selected = true;
      }
   }
   function select(oEvent)
   {
      var _loc3_ = oEvent.value;
      var _loc4_ = 0;
      while(_loc4_ < this._oDataViewer.dataProvider.length)
      {
         if(_loc3_ == this._oDataViewer.dataProvider[_loc4_].unicID)
         {
            this._oDataViewer.setVPosition(Math.floor(_loc4_ / this._oDataViewer.visibleColumnCount));
            this._oDataViewer.selectedIndex = _loc4_;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._cbTypes)
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.controls.InventoryViewer.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name + "_" + this._name] = this._nSelectedTypeID;
         this.updateData();
      }
   }
   function change(oEvent_)
   {
      var _loc3_ = this._tiSearch.text;
      if(_loc3_ == this._sCurrentItemSearch)
      {
         return undefined;
      }
      if(_loc3_.length >= dofus.Constants.INV_SEARCH_MIN_CHARACTERS)
      {
         this._sCurrentItemSearch = _loc3_;
         this.searchItem(_loc3_);
      }
      else
      {
         this._sCurrentItemSearch = "";
         this.updateDataGrid(this._eaDataProvider);
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnFilterEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("EQUIPEMENT"));
            break;
         case this._btnFilterNonEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("CONSUMABLES"));
            break;
         case this._btnFilterRessoureces:
            this.api.ui.showTooltip(this.api.lang.getText("RESSOURECES"));
            break;
         case this._btnFilterSoul:
            this.api.ui.showTooltip(this.api.lang.getText("SOUL"));
            break;
         case this._btnFilterCards:
            this.api.ui.showTooltip(this.api.lang.getText("CARDS"));
            break;
         case this._btnFilterRunes:
            this.api.ui.showTooltip(this.api.lang.getText("RUNES"));
            break;
         case this._btnFilterCeremonials:
            this.api.ui.showTooltip(this.api.lang.getText("ITEM_TYPE_CEREMONIAL"));
            break;
         case this._btnSearch:
            this.api.ui.showTooltip(this.api.lang.getText("SEARCH"));
            break;
         case this._btnMoreChoice:
            this.api.ui.showTooltip(this.api.lang.getText("SORT_AND_TRANSFER"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function optionChanged(oEvent_)
   {
      if(oEvent_.key == "HideInventoryItemsCornerIcon")
      {
         this.updateData();
         if(this._sCurrentItemSearch != "")
         {
            this.searchItem(this._sCurrentItemSearch);
         }
      }
   }
}
