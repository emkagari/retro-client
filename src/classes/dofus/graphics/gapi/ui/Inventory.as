class dofus.graphics.gapi.ui.Inventory extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSelectedSuperTypes;
   var _btnClose;
   var _btnCustomSet;
   var _btnFilterCards;
   var _btnFilterCeremonials;
   var _btnFilterEquipement;
   var _btnFilterFavorites;
   var _btnFilterNonEquipement;
   var _btnFilterQuest;
   var _btnFilterRessoureces;
   var _btnFilterRunes;
   var _btnFilterSoul;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _cbTypes;
   var _cgGrid;
   var _ctr1;
   var _ctr15;
   var _ctr16;
   var _ctrMount;
   var _ctrShield;
   var _ctrWeapon;
   var _currentOverItem;
   var _eaDataProvider;
   var _evolvItemViewer;
   var _icsCustomSet;
   var _iifFilter;
   var _isvItemSetViewer;
   var _itvItemViewer;
   var _lblFilter;
   var _lblKama;
   var _lblNoItem;
   var _lblWeight;
   var _livItemViewer;
   var _mcArrowAnimation;
   var _mcBottomPlacer;
   var _mcItemSetViewerPlacer;
   var _mcItvDescBg;
   var _mcItvIconBg;
   var _mcMountCross;
   var _mcTwoHandedCrossLeft;
   var _mcTwoHandedCrossRight;
   var _mcTwoHandedLink;
   var _popupQuantity;
   var _srSearch;
   var _svCharacterViewer;
   var _tiSearch;
   var _winBg;
   var _winEvolvingItems;
   var _winLivingItems;
   var _winPreview;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var getStyle;
   var unloadThis;
   static var CLASS_NAME = "Inventory";
   static var CONTAINER_BY_TYPE = {type1:["_ctr0"],type2:["_ctr1"],type3:["_ctr2","_ctr4"],type4:["_ctr3"],type5:["_ctr5"],type6:["_ctrMount"],type8:["_ctr1"],type9:["_ctr8","_ctrMount"],type10:["_ctr6"],type11:["_ctr7"],type12:["_ctr8","_ctr16"],type13:["_ctr9","_ctr10","_ctr11","_ctr12","_ctr13","_ctr14"],type7:["_ctr15"],type23:["_ctr1"]};
   static var SUPERTYPE_NOT_EQUIPABLE = [9,14,15,16,17,18,6,19,21,20,8,22];
   var _nSelectedTypeID = 0;
   var _sCurrentItemSearch = "";
   function Inventory()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverItem != undefined)
      {
         return this._currentOverItem;
      }
      return undefined;
   }
   function set currentOverItem(oItem_)
   {
      this._currentOverItem = oItem_;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider.removeEventListener("modelChanged",this);
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function showCharacterPreview(bShow)
   {
      if(bShow)
      {
         this._winPreview._visible = true;
         this._svCharacterViewer._visible = true;
         this._mcItemSetViewerPlacer._x = this._mcBottomPlacer._x;
         this._mcItemSetViewerPlacer._y = this._mcBottomPlacer._y;
         this._isvItemSetViewer._x = this._mcBottomPlacer._x;
         this._isvItemSetViewer._y = this._mcBottomPlacer._y;
         this.showLivingItems(false);
         this.showEvolvingItems(false);
      }
      else
      {
         this._winPreview._visible = false;
         this._svCharacterViewer._visible = false;
         this._mcItemSetViewerPlacer._x = this._winPreview._x;
         this._mcItemSetViewerPlacer._y = this._winPreview._y;
         this._isvItemSetViewer._x = this._winPreview._x;
         this._isvItemSetViewer._y = this._winPreview._y;
      }
   }
   function showLivingItems(bShow)
   {
      this._livItemViewer._visible = bShow;
      this._winLivingItems._visible = bShow;
      if(bShow)
      {
         this._winPreview._visible = false;
         this._svCharacterViewer._visible = false;
         this._mcItemSetViewerPlacer._x = this._mcBottomPlacer._x;
         this._mcItemSetViewerPlacer._y = this._mcBottomPlacer._y;
         this._isvItemSetViewer._x = this._mcBottomPlacer._x;
         this._isvItemSetViewer._y = this._mcBottomPlacer._y;
      }
   }
   function showEvolvingItems(bShow_)
   {
      this._evolvItemViewer._visible = bShow_;
      this._winEvolvingItems._visible = bShow_;
      if(bShow_)
      {
         this._winPreview._visible = false;
         this._svCharacterViewer._visible = false;
         this._mcItemSetViewerPlacer._x = this._mcBottomPlacer._x;
         this._mcItemSetViewerPlacer._y = this._mcBottomPlacer._y;
         this._isvItemSetViewer._x = this._mcBottomPlacer._x;
         this._isvItemSetViewer._y = this._mcBottomPlacer._y;
      }
   }
   function showItemInfos(oItem)
   {
      var _loc3_;
      var _loc4_;
      if(oItem == undefined)
      {
         this.hideItemViewer(true);
         this.hideItemSetViewer(true);
      }
      else
      {
         this.hideItemViewer(false);
         _loc3_ = oItem.clone();
         if(_loc3_.realGfx)
         {
            _loc3_.gfx = _loc3_.realGfx;
         }
         this._itvItemViewer.itemData = _loc3_;
         if(oItem.isFromItemSet)
         {
            _loc4_ = new dofus.datacenter.ItemSet(oItem.itemSetID,this.api.datacenter.Player.equippedItems);
            this.hideItemSetViewer(false);
            this._isvItemSetViewer.itemSet = _loc4_;
         }
         else
         {
            this.hideItemSetViewer(true);
         }
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Inventory.CLASS_NAME);
      this.gapi.getUIComponent("Banner").shortcuts.setCurrentTab("Items");
      this.showCharacterPreview(this.api.kernel.OptionsManager.getOption("CharacterPreview"));
      this.showLivingItems(false);
      this.showEvolvingItems(false);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
      if(this.api.datacenter.Game.isFight)
      {
         this.gapi.getUIComponent("Banner").shortcuts.setCurrentTab("Spells");
      }
      if(this._popupQuantity != undefined)
      {
         this._popupQuantity.callClose();
      }
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this._winBg.onRelease = function()
      {
      };
      this._winBg.useHandCursor = false;
      this._winLivingItems.onRelease = function()
      {
      };
      this._winLivingItems.useHandCursor = false;
      this._winEvolvingItems.onRelease = function()
      {
      };
      this._winEvolvingItems.useHandCursor = false;
      this.addToQueue({object:this,method:this.hideEpisodicContent});
      this.addToQueue({object:this,method:this.initFilter});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.hideItemViewer(true);
      this.hideItemSetViewer(true);
      this.enableSearch(false);
      this._ctrShield = this._ctr15;
      this._ctrWeapon = this._ctr1;
      this._ctrMount = this._ctr16;
      this._mcTwoHandedLink._visible = false;
      this._mcTwoHandedLink.stop();
      this._mcTwoHandedCrossLeft._visible = false;
      this._mcTwoHandedCrossRight._visible = false;
      ank.utils.MouseEvents.addListener(this);
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
      this.api.datacenter.Player.addEventListener("mountChanged",this);
      this.api.datacenter.Player.addEventListener("nameChanged",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
      this.addToQueue({object:this,method:this.kamaChanged,params:[{value:this.api.datacenter.Player.Kama}]});
      this.addToQueue({object:this,method:this.mountChanged});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function draw()
   {
      var _loc2_ = this.getStyle();
      this.addToQueue({object:this,method:this.setSubComponentsStyle,params:[_loc2_]});
   }
   function setSubComponentsStyle(oStyle)
   {
      this._itvItemViewer.styleName = oStyle.itenviewerstyle;
   }
   function hideEpisodicContent()
   {
      if(this.api.datacenter.Basics.aks_current_regional_version < 20)
      {
         this._ctrMount._visible = false;
         this._mcMountCross._visible = false;
      }
      else
      {
         this._ctrMount._visible = true;
      }
   }
   function addListeners()
   {
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgGrid.addEventListener("dblClickItem",this);
      this._cgGrid.multipleContainerSelectionEnabled = false;
      this._btnFilterEquipement.addEventListener("click",this);
      this._btnFilterNonEquipement.addEventListener("click",this);
      this._btnFilterRessoureces.addEventListener("click",this);
      this._btnFilterQuest.addEventListener("click",this);
      this._btnFilterSoul.addEventListener("click",this);
      this._btnFilterCards.addEventListener("click",this);
      this._btnFilterEquipement.addEventListener("over",this);
      this._btnFilterNonEquipement.addEventListener("over",this);
      this._btnFilterRessoureces.addEventListener("over",this);
      this._btnFilterQuest.addEventListener("over",this);
      this._btnFilterSoul.addEventListener("over",this);
      this._btnFilterCards.addEventListener("over",this);
      this._btnFilterEquipement.addEventListener("out",this);
      this._btnFilterNonEquipement.addEventListener("out",this);
      this._btnFilterRessoureces.addEventListener("out",this);
      this._btnFilterQuest.addEventListener("out",this);
      this._btnFilterSoul.addEventListener("out",this);
      this._btnFilterCards.addEventListener("out",this);
      this._btnClose.addEventListener("click",this);
      this._btnCustomSet.addEventListener("click",this);
      this._btnCustomSet.addEventListener("over",this);
      this._btnCustomSet.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("click",this);
      this._btnFilterRunes.addEventListener("over",this);
      this._btnFilterRunes.addEventListener("out",this);
      this._btnFilterCeremonials.addEventListener("click",this);
      this._btnFilterCeremonials.addEventListener("over",this);
      this._btnFilterCeremonials.addEventListener("out",this);
      this._btnFilterFavorites.addEventListener("click",this);
      this._btnFilterFavorites.addEventListener("over",this);
      this._btnFilterFavorites.addEventListener("out",this);
      this._btnSearch.addEventListener("click",this);
      this._btnSearch.addEventListener("over",this);
      this._btnSearch.addEventListener("out",this);
      this._itvItemViewer.addEventListener("useItem",this);
      this._itvItemViewer.addEventListener("batchUseItem",this);
      this._itvItemViewer.addEventListener("destroyItem",this);
      this._itvItemViewer.addEventListener("reinitializeItem",this);
      this._itvItemViewer.addEventListener("unlinkSkinItem",this);
      this._itvItemViewer.addEventListener("destroyMimibiote",this);
      this._itvItemViewer.addEventListener("targetItem",this);
      this._itvItemViewer.addEventListener("unlockItem",this);
      this._itvItemViewer.addEventListener("lockItem",this);
      this._itvItemViewer.addEventListener("unlinkLivingItem",this);
      this._tiSearch.addEventListener("change",this);
      this._cbTypes.addEventListener("itemSelected",this);
      var _loc2_;
      var _loc3_;
      var _loc4_;
      for(var a in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE)
      {
         _loc2_ = dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[a];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = this[_loc2_[_loc3_]];
            _loc4_.addEventListener("over",this);
            _loc4_.addEventListener("out",this);
            if(_loc4_.toolTipText == undefined)
            {
               _loc4_.toolTipText = this.api.lang.getText(_loc4_ != this._ctrMount ? "INVENTORY_" + a.toUpperCase() : "MOUNT");
            }
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function initTexts()
   {
      switch(this._btnSelectedFilterButton)
      {
         case this._btnFilterEquipement:
            this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
            break;
         case this._btnFilterNonEquipement:
            this._lblFilter.text = this.api.lang.getText("CONSUMABLES");
            break;
         case this._btnFilterRessoureces:
            this._lblFilter.text = this.api.lang.getText("RESSOURECES");
            break;
         case this._btnFilterSoul:
            this._lblFilter.text = this.api.lang.getText("SOUL");
            break;
         case this._btnFilterCards:
            this._lblFilter.text = this.api.lang.getText("CARDS");
            break;
         case this._btnFilterQuest:
            this._lblFilter.text = this.api.lang.getText("QUEST_OBJECTS");
            break;
         case this._btnFilterRunes:
            this._lblFilter.text = this.api.lang.getText("RUNES");
            break;
         case this._btnFilterCeremonials:
            this._lblFilter.text = this.api.lang.getText("ITEM_TYPE_CEREMONIAL");
            break;
         case this._btnFilterFavorites:
            this._lblFilter.text = this.api.lang.getText("FAVORITE_TYPE");
            break;
         case this._btnCustomSet:
            this._lblFilter.text = this.api.lang.getText("CUSTOM_SET");
      }
      this._lblWeight.text = this.api.lang.getText("WEIGHT");
      this._winPreview.title = this.api.lang.getText("CHARACTER_PREVIEW",[this.api.datacenter.Player.Name]);
      this._winBg.title = this.api.lang.getText("INVENTORY");
      this._lblNoItem.text = this.api.lang.getText("SELECT_ITEM");
      this._winLivingItems.title = this.api.lang.getText("MANAGE_ITEM");
      this._winEvolvingItems.title = this.api.lang.getText("MANAGE_ITEM");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function initFilter()
   {
      switch(this.api.datacenter.Basics.inventory_filter)
      {
         case "customSet":
            this._btnCustomSet.selected = true;
            this.showCustomSet(true);
            this._btnSelectedFilterButton = this._btnCustomSet;
            break;
         case "runes":
            this._btnFilterRunes.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
            this._btnSelectedFilterButton = this._btnFilterRunes;
            break;
         case "soul":
            this._btnFilterSoul.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
            this._btnSelectedFilterButton = this._btnFilterSoul;
            break;
         case "cards":
            this._btnFilterCards.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
            this._btnSelectedFilterButton = this._btnFilterCards;
            break;
         case "nonequipement":
            this._btnFilterNonEquipement.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
            this._btnSelectedFilterButton = this._btnFilterNonEquipement;
            break;
         case "resources":
            this._btnFilterRessoureces.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
            this._btnSelectedFilterButton = this._btnFilterRessoureces;
            break;
         case "quest":
            this._btnFilterQuest.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.INVADER_AREA;
            this._btnSelectedFilterButton = this._btnFilterQuest;
            break;
         case "ceremonials":
            this._btnFilterCeremonials.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
            this._btnSelectedFilterButton = this._btnFilterCeremonials;
            this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
            break;
         case "favorites":
            this._btnFilterFavorites.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
            this._btnSelectedFilterButton = this._btnFilterFavorites;
            this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryFavoriteFilter();
            break;
         case "equipement":
         default:
            this._btnFilterEquipement.selected = true;
            this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
            this._btnSelectedFilterButton = this._btnFilterEquipement;
            this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
      }
      if(this._btnSelectedFilterButton != this._btnCustomSet)
      {
         this.showCustomSet(false);
      }
   }
   function initData()
   {
      this._svCharacterViewer.zoom = 250;
      this.refreshSpriteViewer();
      this.dataProvider = this.api.datacenter.Player.Inventory;
   }
   function refreshSpriteViewer()
   {
      var _loc2_ = ank.battlefield.datacenter.Sprite(this.api.datacenter.Player.data);
      if(_loc2_ == undefined)
      {
         return undefined;
      }
      var _loc3_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,_loc2_.gfxFile,undefined,5);
      _loc3_.color1 = _loc2_.color1;
      _loc3_.color2 = _loc2_.color2;
      _loc3_.color3 = _loc2_.color3;
      _loc3_.accessories = _loc2_.accessories;
      _loc3_.mount = _loc2_.mount;
      this._svCharacterViewer.sourceSpriteData = _loc2_;
      this._svCharacterViewer.spriteData = _loc3_;
   }
   function enabledFromSuperType(oItem)
   {
      var _loc3_ = oItem.superType;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(_loc3_ != undefined)
      {
         for(var k in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE)
         {
            for(var i in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k])
            {
               _loc4_ = this[dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k][i]];
               _loc4_.enabled = false;
               _loc4_.selected = false;
            }
         }
         _loc5_ = this.api.lang.getItemSuperTypeText(_loc3_);
         if(_loc5_)
         {
            for(var i in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE["type" + _loc3_])
            {
               _loc6_ = this[dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE["type" + _loc3_][i]];
               if(!(_loc3_ == 9 && _loc6_.contentPath == ""))
               {
                  _loc6_.enabled = true;
                  _loc6_.selected = true;
               }
            }
         }
         else
         {
            for(var i in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE["type" + _loc3_])
            {
               _loc7_ = this[dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE["type" + _loc3_][i]];
               _loc7_.enabled = true;
               _loc7_.selected = true;
            }
         }
         if(oItem.needTwoHands)
         {
            _loc8_ = dofus.datacenter.Item(this._ctr15.contentData);
            if(_loc8_ != undefined && !_loc8_.isCeremonial)
            {
               this._mcTwoHandedCrossLeft._visible = true;
               this._ctrShield.content._alpha = 30;
               this._mcTwoHandedLink.play();
               this._mcTwoHandedLink._visible = true;
            }
         }
         if(_loc3_ == 7 && this.api.datacenter.Player.weaponItem.needTwoHands)
         {
            this._mcTwoHandedCrossLeft._visible = false;
            if(!oItem.isCeremonial)
            {
               this._mcTwoHandedCrossRight._visible = true;
               this._ctrWeapon.content._alpha = 30;
               this._mcTwoHandedLink.play();
               this._mcTwoHandedLink._visible = true;
            }
         }
      }
      else
      {
         for(var k in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE)
         {
            for(var i in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k])
            {
               _loc9_ = this[dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k][i]];
               _loc9_.enabled = true;
               if(_loc9_.selected)
               {
                  _loc9_.selected = false;
               }
            }
         }
         if(this.api.datacenter.Player.weaponItem.needTwoHands)
         {
            this._mcTwoHandedLink.gotoAndStop(1);
            this._mcTwoHandedLink._visible = true;
            this._mcTwoHandedCrossLeft._visible = this._ctr15.contentData == undefined;
         }
      }
   }
   function updateData(bOnlyInventoryGrid, eaDataProvider)
   {
      var _loc4_ = this.api.datacenter.Basics[dofus.graphics.gapi.ui.Inventory.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name];
      this._nSelectedTypeID = _loc4_ != undefined ? _loc4_ : 0;
      if(eaDataProvider == undefined)
      {
         eaDataProvider = this._eaDataProvider;
      }
      var _loc5_ = {};
      if(!bOnlyInventoryGrid)
      {
         for(var k in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE)
         {
            for(var i in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k])
            {
               _loc5_[dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[k][i]] = true;
            }
         }
      }
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_ = new ank.utils.ExtendedArray();
      var _loc8_ = {};
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      for(var k in eaDataProvider)
      {
         _loc9_ = eaDataProvider[k];
         _loc10_ = _loc9_.position;
         if(_loc10_ != -1)
         {
            if(!bOnlyInventoryGrid)
            {
               _loc11_ = this["_ctr" + _loc10_];
               _loc11_.contentData = _loc9_;
               delete _loc5_[_loc11_._name];
            }
         }
         else if(this._aSelectedSuperTypes[_loc9_.superType] && (this._iifFilter == null || (this._iifFilter == undefined || this._iifFilter.isItemListed(_loc9_))))
         {
            _loc12_ = _loc9_.type;
            if(!_loc8_[_loc12_])
            {
               _loc7_.push({label:this.api.lang.getItemTypeText(_loc12_).n,id:_loc12_});
               _loc8_[_loc12_] = true;
            }
            if(this._nSelectedTypeID == 0 || _loc12_ == this._nSelectedTypeID)
            {
               _loc6_.push(_loc9_);
            }
         }
      }
      _loc7_.sortOn("label");
      _loc7_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:0});
      this._cbTypes.dataProvider = _loc7_;
      this.setType(this._nSelectedTypeID);
      this._cgGrid.dataProvider = _loc6_;
      if(!bOnlyInventoryGrid)
      {
         for(var k in _loc5_)
         {
            if(this[k] != this._ctrMount)
            {
               this[k].contentData = undefined;
            }
         }
      }
      this.resetTwoHandClip();
   }
   function resetTwoHandClip()
   {
      this._ctrShield.content._alpha = 100;
      this._ctrWeapon.content._alpha = 100;
      this._mcTwoHandedLink.gotoAndStop(1);
      if(this.api.datacenter.Player.weaponItem.needTwoHands)
      {
         this._mcTwoHandedLink._visible = true;
         this._mcTwoHandedCrossLeft._visible = this._ctr15.contentData == undefined;
         this._mcTwoHandedCrossRight._visible = false;
      }
      else
      {
         this._mcTwoHandedLink._visible = false;
         this._mcTwoHandedCrossLeft._visible = false;
         this._mcTwoHandedCrossRight._visible = false;
      }
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
   function askReinitialize(oItem)
   {
      var _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoReinitialize",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("RESET_PET_CONFIRM"),params:{item:oItem}});
      _loc3_.addEventListener("yes",this);
   }
   function askDestroy(oItem, nQuantity)
   {
      var _loc4_;
      if(oItem.Quantity == 1)
      {
         _loc4_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoDestroy",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("DO_U_DESTROY",[nQuantity,oItem.name]),params:{item:oItem,quantity:nQuantity}});
         _loc4_.addEventListener("yes",this);
      }
      else
      {
         this.api.network.Items.destroy(oItem.ID,nQuantity);
      }
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._mcItvDescBg._visible = !bHide;
      this._mcItvIconBg._visible = !bHide;
   }
   function hideItemSetViewer(bHide)
   {
      if(bHide)
      {
         this._isvItemSetViewer.removeMovieClip();
      }
      else if(this._isvItemSetViewer == undefined)
      {
         this.attachMovie("ItemSetViewer","_isvItemSetViewer",this.getNextHighestDepth(),{_x:this._mcItemSetViewerPlacer._x,_y:this._mcItemSetViewerPlacer._y});
      }
   }
   function showCustomSet(bShow)
   {
      this._cbTypes._visible = !bShow;
      this._btnSearch._visible = !bShow;
      this._cgGrid._visible = !bShow;
      if(bShow && (this._isvItemSetViewer == undefined || this._isvItemSetViewer != "_isvItemSetViewer"))
      {
         this.attachMovie("UI_CustomSet","_icsCustomSet",this.getNextHighestDepth(),{_x:581,_y:147});
      }
      else
      {
         this._icsCustomSet.removeMovieClip();
      }
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
      this.updateData(true,_loc3_);
   }
   function nameChanged(oEvent)
   {
      this._winPreview.title = this.api.lang.getText("CHARACTER_PREVIEW",[oEvent.value]);
   }
   function kamaChanged(oEvent)
   {
      this._lblKama.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnClose)
      {
         this.callClose();
         return undefined;
      }
      if(oEvent.target == this._btnSearch)
      {
         this.enableSearch(this._btnSearch.selected);
         if(!this._btnSearch.selected)
         {
            this.updateData(true,this._eaDataProvider);
         }
         return undefined;
      }
      if(this._mcArrowAnimation._visible)
      {
         this._mcArrowAnimation._visible = false;
      }
      if(oEvent.target != this._btnSelectedFilterButton)
      {
         this.api.sounds.events.onInventoryFilterButtonClick();
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
            case this._btnCustomSet:
               this._lblFilter.text = this.api.lang.getText("CUSTOM_SET");
               this.showCustomSet(true);
               this.api.datacenter.Basics.inventory_filter = "customSet";
               break;
            case this._btnFilterRunes:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
               this._lblFilter.text = this.api.lang.getText("RUNES");
               this.api.datacenter.Basics.inventory_filter = "runes";
               break;
            case this._btnFilterSoul:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
               this._lblFilter.text = this.api.lang.getText("SOUL");
               this.api.datacenter.Basics.inventory_filter = "soul";
               break;
            case this._btnFilterCards:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
               this._lblFilter.text = this.api.lang.getText("CARDS");
               this.api.datacenter.Basics.inventory_filter = "cards";
               break;
            case this._btnFilterEquipement:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
               this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
               this.api.datacenter.Basics.inventory_filter = "equipement";
               break;
            case this._btnFilterNonEquipement:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
               this._lblFilter.text = this.api.lang.getText("CONSUMABLES");
               this.api.datacenter.Basics.inventory_filter = "nonequipement";
               break;
            case this._btnFilterRessoureces:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
               this._lblFilter.text = this.api.lang.getText("RESSOURECES");
               this.api.datacenter.Basics.inventory_filter = "resources";
               break;
            case this._btnFilterQuest:
               this._aSelectedSuperTypes = dofus.Constants.INVADER_AREA;
               this._lblFilter.text = this.api.lang.getText("QUEST_OBJECTS");
               this.api.datacenter.Basics.inventory_filter = "quest";
               break;
            case this._btnFilterCeremonials:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
               this._lblFilter.text = this.api.lang.getText("ITEM_TYPE_CEREMONIAL");
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
               this.api.datacenter.Basics.inventory_filter = "ceremonials";
               break;
            case this._btnFilterFavorites:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
               this._lblFilter.text = this.api.lang.getText("FAVORITE_TYPE");
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryFavoriteFilter();
               this.api.datacenter.Basics.inventory_filter = "favorites";
         }
         this.updateData(true);
         if(this._btnSelectedFilterButton != this._btnCustomSet)
         {
            this.showCustomSet(false);
         }
      }
      else
      {
         oEvent.target.selected = true;
      }
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.eventName)
      {
         case "updateOne":
         case "updateAll":
      }
      this.updateData(false);
      if(this._sCurrentItemSearch != "")
      {
         this.searchItem(this._sCurrentItemSearch);
      }
      this.hideItemViewer(true);
      this.hideItemSetViewer(true);
      this.showLivingItems(false);
      this.showEvolvingItems(false);
      this.showCharacterPreview(this.api.kernel.OptionsManager.getOption("CharacterPreview"));
   }
   function onMouseUp()
   {
      this.addToQueue({object:this,method:this.enabledFromSuperType});
   }
   function dragItem(oEvent)
   {
      this.gapi.removeCursor();
      if(!this.api.datacenter.Player.checkCanMoveItem())
      {
         return undefined;
      }
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      if(oEvent.target.contentData.isCursed)
      {
         return undefined;
      }
      this.enabledFromSuperType(oEvent.target.contentData);
      this.gapi.setCursor(oEvent.target.contentData);
   }
   function dropItem(oEvent)
   {
      if(!this.api.datacenter.Player.checkCanMoveItem())
      {
         return undefined;
      }
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         this.api.network.InventoryShortcuts.sendInventoryShortcutRemove(_loc3_.position);
         return undefined;
      }
      var _loc4_;
      if(oEvent.target._parent == this)
      {
         _loc4_ = Number(oEvent.target._name.substr(4));
      }
      else
      {
         if(_loc3_.position == -1)
         {
            this.resetTwoHandClip();
            return undefined;
         }
         _loc4_ = -1;
      }
      if(_loc3_.position == _loc4_)
      {
         this.resetTwoHandClip();
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc5_;
      if(_loc3_.Quantity > 1 && (_loc4_ == -1 || _loc4_ == 16))
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:_loc3_.Quantity,max:_loc3_.Quantity,params:{type:"move",position:_loc4_,item:_loc3_}});
         _loc5_.addEventListener("validate",this);
         this._popupQuantity = _loc5_;
      }
      else
      {
         this.api.network.Items.movement(_loc3_.ID,_loc4_);
      }
   }
   function selectItem(oEvent)
   {
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.target.contentData != undefined)
      {
         this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
      }
      else
      {
         this.showItemInfos(oEvent.target.contentData);
         this.showLivingItems(oEvent.target.contentData.isLiving);
         this.showEvolvingItems(oEvent.target.contentData.isEvolving);
         if(oEvent.target.contentData.isLiving)
         {
            this._livItemViewer.itemData = oEvent.target.contentData;
         }
         if(oEvent.target.contentData.isEvolving)
         {
            this._evolvItemViewer.itemData = oEvent.target.contentData;
         }
         if(!oEvent.target.contentData.skineable)
         {
            this.showCharacterPreview(this.api.kernel.OptionsManager.getOption("CharacterPreview"));
         }
      }
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
      this._currentOverItem = _loc4_;
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
      this._currentOverItem = undefined;
   }
   function dblClickItem(oEvent)
   {
      if(!this.api.datacenter.Player.checkCanMoveItem())
      {
         return undefined;
      }
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(!_loc3_.isEquiped)
      {
         if(_loc3_.canUse && this.api.datacenter.Player.canUseObject)
         {
            if(Key.isDown(Key.CONTROL) || Key.isDown(Key.SHIFT))
            {
               this._popupQuantity = dofus.graphics.gapi.ui.Inventory.askBatchUseItem(this.api,_loc3_);
            }
            else
            {
               this.api.network.Items.use(_loc3_.ID);
            }
         }
         else if(this.api.lang.getConfigText("DOUBLE_CLICK_TO_EQUIP"))
         {
            this.api.network.Items.equipItem(_loc3_);
         }
      }
      else
      {
         this.api.network.Items.movement(_loc3_.ID,-1);
      }
   }
   function dropDownItem()
   {
      if(!this.api.datacenter.Player.checkCanMoveItem())
      {
         return undefined;
      }
      var _loc2_ = this.gapi.getCursor();
      if(_loc2_ != undefined && _loc2_.isShortcut)
      {
         return undefined;
      }
      if(!_loc2_.canDrop)
      {
         this.gapi.loadUIComponent("AskOk","AskOkCantDrop",{title:this.api.lang.getText("IMPOSSIBLE"),text:this.api.lang.getText("CANT_DROP_ITEM")});
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc3_;
      if(_loc2_.Quantity > 1)
      {
         _loc3_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc2_.Quantity,params:{type:"drop",item:_loc2_}});
         _loc3_.addEventListener("validate",this);
         this._popupQuantity = _loc3_;
      }
      else if(this.api.kernel.OptionsManager.getOption("ConfirmDropItem"))
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CONFIRM_DROP_ITEM"),"CAUTION_YESNO",{name:"ConfirmDropOne",params:{item:_loc2_},listener:this});
      }
      else
      {
         this.api.network.Items.drop(_loc2_.ID,1);
      }
   }
   function validate(oEvent)
   {
      var _loc3_;
      switch(oEvent.params.type)
      {
         case "destroy":
            if(oEvent.value > 0 && !_global.isNaN(Number(oEvent.value)))
            {
               _loc3_ = Math.min(oEvent.value,oEvent.params.item.Quantity);
               this.askDestroy(oEvent.params.item,_loc3_);
            }
            break;
         case "drop":
            this.gapi.removeCursor();
            if(oEvent.value > 0 && !_global.isNaN(Number(oEvent.value)))
            {
               if(this.api.kernel.OptionsManager.getOption("ConfirmDropItem"))
               {
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CONFIRM_DROP_ITEM"),"CAUTION_YESNO",{name:"ConfirmDrop",params:{item:oEvent.params.item,minValue:oEvent.value},listener:this});
               }
               else
               {
                  this.api.network.Items.drop(oEvent.params.item.ID,Math.min(oEvent.value,oEvent.params.item.Quantity));
               }
            }
            break;
         case "move":
            if(oEvent.value > 0 && !_global.isNaN(Number(oEvent.value)))
            {
               this.api.network.Items.movement(oEvent.params.item.ID,oEvent.params.position,Math.min(oEvent.value,oEvent.params.item.Quantity));
            }
         default:
            return;
      }
   }
   function useItem(oEvent)
   {
      if(!oEvent.item.canUse || !this.api.datacenter.Player.canUseObject)
      {
         return undefined;
      }
      this.api.network.Items.use(oEvent.item.ID);
   }
   function batchUseItem(oEvent)
   {
      var _loc3_ = oEvent.item;
      if(!_loc3_.canUse || !this.api.datacenter.Player.canUseObject)
      {
         return undefined;
      }
      this._popupQuantity = dofus.graphics.gapi.ui.Inventory.askBatchUseItem(this.api,_loc3_);
   }
   static function askBatchUseItem(api, oItem)
   {
      var _loc3_ = api.ui;
      var _loc4_ = "POPUP_QUANTITY_BATCH_USE_ITEM_DESCRIPTION";
      var _loc5_ = oItem.name;
      var _loc6_ = [function(nMin, nMax, nValue)
      {
         return String(nValue);
      },_loc5_];
      var _loc7_ = Math.min(dofus.aks.Items.MAX_BATCH_ITEM_USE,oItem.Quantity);
      var _loc8_ = _loc3_.loadUIComponent("PopupQuantityWithDescription","PopupQuantity",{descriptionLangKey:_loc4_,descriptionLangKeyParams:_loc6_,value:1,max:_loc7_,params:{type:"batchUseItem",item:oItem}},{bForceLoad:true});
      var _loc9_ = {};
      _loc9_.validate = function(oEvent)
      {
         var _loc3_ = oEvent.params.item.ID;
         api.network.Items.use(_loc3_,undefined,undefined,undefined,oEvent.value);
      };
      _loc8_.addEventListener("validate",_loc9_);
      return _loc8_;
   }
   function reinitializeItem(oEvent)
   {
      this.askReinitialize(oEvent.item);
   }
   function unlinkLivingItem(oEvent_)
   {
      this.api.network.Items.dissociate(oEvent_.item.ID,oEvent_.item.position);
   }
   function destroyItem(oEvent)
   {
      var _loc3_;
      if(oEvent.item.Quantity > 1)
      {
         _loc3_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:oEvent.item.Quantity,params:{type:"destroy",item:oEvent.item}});
         _loc3_.addEventListener("validate",this);
         this._popupQuantity = _loc3_;
      }
      else
      {
         this.askDestroy(oEvent.item,1);
      }
   }
   function destroyMimibiote(oEvent)
   {
      var _loc3_ = oEvent.item;
      var _loc4_ = !_loc3_.hasCeremonialSkinItem ? "DO_U_DESTROY_MIMIBIOTE" : "DO_U_DESTROY_MIMIBIOTE_ON_CEREMONIAL";
      var _loc5_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoDestroyMimibiote",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText(_loc4_,[_loc3_.name]),params:{item:_loc3_}});
      _loc5_.addEventListener("yes",this);
   }
   function unlinkSkinItem(oEvent)
   {
      this.api.network.Items.destroyMimibiote(oEvent.item.ID);
   }
   function targetItem(oEvent)
   {
      if(!oEvent.item.canTarget || !this.api.datacenter.Player.canUseObject)
      {
         return undefined;
      }
      this.api.kernel.GameManager.switchToItemTarget(oEvent.item);
      this.callClose();
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoConfirmDropOne":
            this.api.network.Items.drop(oEvent.target.params.item.ID,1);
            return;
         case "AskYesNoConfirmDrop":
            this.api.network.Items.drop(oEvent.params.item.ID,Math.min(oEvent.params.minValue,oEvent.params.item.Quantity));
            return;
         case "AskYesNoDestroyMimibiote":
            this.api.network.Items.destroyMimibiote(oEvent.target.params.item.ID);
            return;
         case "AskYesNoReinitialize":
            this.api.network.Items.reinitialize(oEvent.target.params.item.ID);
            return;
         case "AskYesNoConfirmLock":
            this.confrimedLockItem(oEvent.params);
      }
      this.api.network.Items.destroy(oEvent.target.params.item.ID,oEvent.target.params.quantity);
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_cbTypes")
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.ui.Inventory.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name] = this._nSelectedTypeID;
         this.updateData();
      }
   }
   function mountChanged(oEvent)
   {
      var _loc3_ = this.api.datacenter.Player.mount;
      if(_loc3_ != undefined)
      {
         this._ctrMount.contentPath = "UI_InventoryMountIcon";
         this._mcMountCross._visible = false;
      }
      else
      {
         this._ctrMount.contentPath = "";
         this._mcMountCross._visible = true;
      }
      this.hideEpisodicContent();
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnFilterEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("EQUIPEMENT"));
            return;
         case this._btnFilterNonEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("CONSUMABLES"));
            return;
         case this._btnFilterRessoureces:
            this.api.ui.showTooltip(this.api.lang.getText("RESSOURECES"));
            return;
         case this._btnFilterQuest:
            this.api.ui.showTooltip(this.api.lang.getText("QUEST_OBJECTS"));
            return;
         case this._btnFilterSoul:
            this.api.ui.showTooltip(this.api.lang.getText("SOUL"));
            return;
         case this._btnFilterCards:
            this.api.ui.showTooltip(this.api.lang.getText("CARDS"));
            return;
         case this._btnFilterRunes:
            this.api.ui.showTooltip(this.api.lang.getText("RUNES"));
            return;
         case this._btnFilterCeremonials:
            this.api.ui.showTooltip(this.api.lang.getText("ITEM_TYPE_CEREMONIAL"));
            return;
         case this._btnFilterFavorites:
            this.api.ui.showTooltip(this.api.lang.getText("FAVORITE_TYPE"));
            return;
         case this._btnSearch:
            this.api.ui.showTooltip(this.api.lang.getText("SEARCH"));
            return;
         case this._btnCustomSet:
            this.api.ui.showTooltip(this.api.lang.getText("CUSTOM_SET"));
            return;
         default:
            if(oEvent.target.contentData != undefined)
            {
               this.overItem(oEvent);
            }
            else
            {
               this.api.ui.showTooltip(oEvent.target.toolTipText);
            }
            return;
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
      if(this._currentOverItem != undefined)
      {
         this.outItem(oEvent);
      }
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
         this.updateData(true,this._eaDataProvider);
      }
   }
   function lockItem(oEvent)
   {
      if(oEvent.delay > 0)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CONFIRM_LOCK_ITEM"),"CAUTION_YESNO",{name:"ConfirmLock",params:{item:oEvent.item,delay:oEvent.delay},listener:this});
      }
      else
      {
         this.confrimedLockItem(oEvent);
      }
   }
   function confrimedLockItem(oItem)
   {
      this.api.network.Items.lock(oItem.item.ID,1,oItem.delay);
   }
   function unlockItem(oEvent)
   {
      this.api.network.Items.lock(oEvent.item.ID,0,oEvent.delay);
   }
}
