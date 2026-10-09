class dofus.graphics.gapi.ui.SecureCraft extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSelectedSuperTypes;
   var _bFiligraneVisible;
   var _btnClose;
   var _btnCraft;
   var _btnFilterCards;
   var _btnFilterEquipement;
   var _btnFilterNonEquipement;
   var _btnFilterRessoureces;
   var _btnFilterRunes;
   var _btnFilterSoul;
   var _btnMarked;
   var _btnPay;
   var _btnPrivateMessage;
   var _btnQuantity;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _btnValidate;
   var _btnValidatePay;
   var _cbTypes;
   var _cgCoop;
   var _cgDistant;
   var _cgGrid;
   var _cgLocal;
   var _ctrMarkRuneDistant;
   var _ctrMarkRuneLocal;
   var _ctrPreview;
   var _currentOverContainer;
   var _cvCraftViewer;
   var _eaCoopDataProvider;
   var _eaDataProvider;
   var _eaDistantDataProvider;
   var _eaLocalDataProvider;
   var _eaMarked;
   var _eaNotMarked;
   var _eaPayDataProvider;
   var _eaPayIfSuccessDataProvider;
   var _eaReadyDataProvider;
   var _iifFilter;
   var _itvItemViewer;
   var _lblFilter;
   var _lblKama;
   var _lblKamaPayment;
   var _lblNewObject;
   var _lblPay;
   var _lblPayIfSuccess;
   var _lblPayIfSuccessKamaTotal;
   var _lblPayKama;
   var _lblPayKamaTotal;
   var _lblQty1;
   var _lblQty2;
   var _lblSkill;
   var _mcArrow_;
   var _mcBlinkPayIfSuccess_TripleFramerate;
   var _mcBlinkPay_TripleFramerate;
   var _mcFiligrane;
   var _mcPayHighlight;
   var _mcPayIfSuccessKama;
   var _mcPayKama;
   var _mcPlacer;
   var _mcPods;
   var _nForgemagusItemType;
   var _nJobLevel;
   var _nKamaPaymentIfSuccess;
   var _nMaxItem;
   var _nPayBar;
   var _nSkillId;
   var _oMarkedBaseItem;
   var _parent;
   var _sCurrentDragSource;
   var _sCurrentDragTarget;
   var _sDropTargetGrid;
   var _srSearch;
   var _symbolKama;
   var _tiSearch;
   var _txtUseMarkRune;
   var _winCraftViewer;
   var _winCrafter;
   var _winCustomer;
   var _winDistant;
   var _winInventory;
   var _winItemViewer;
   var _winMarked;
   var _winOrder;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var setMovieClipTransform;
   static var CLASS_NAME = "SecureCraft";
   static var READY_COLOR = dofus.Constants.CRAFT_LOCK_WINDOW_COLOR;
   static var NON_READY_COLOR = dofus.Constants.CRAFT_UNLOCK_WINDOW_COLOR;
   static var GRID_CONTAINER_WIDTH = 33;
   static var DELAY_BEFORE_VALIDATE = 3000;
   static var FILTER_TYPE_ONLY_USEFUL = 10000;
   static var MARK_RUNE_ID = 7508;
   var _bInvalidateCoop = false;
   var _nSelectedTypeID = 0;
   var _sCurrentItemSearch = "";
   static var secureCraftNotified = false;
   var _btnPayIfSuccessKama = 0;
   var _nKamaPayment = 0;
   var _nLastRegenerateTimer = 0;
   static var NAME_GENERATION_DELAY = 1000;
   var _bIsLooping = false;
   var _nCurrentQuantity = 1;
   function SecureCraft()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return dofus.datacenter.Item(this._currentOverContainer.contentData);
      }
      return undefined;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function set maxItem(nMaxItem)
   {
      this._nMaxItem = Number(nMaxItem);
   }
   function set skillId(nSkillId)
   {
      this._nSkillId = Number(nSkillId);
      this._nForgemagusItemType = _global.API.lang.getSkillForgemagus(this._nSkillId);
   }
   function set jobLevel(nJobLevel)
   {
      this._nJobLevel = nJobLevel;
   }
   function get _cgPay()
   {
      return this.api.datacenter.Basics.aks_exchange_echangeType == 13;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider.removeEventListener("modelChange",this);
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaDataProvider});
   }
   function set _nDistantReadyState(eaDistantDataProvider)
   {
      this._eaLocalDataProvider.removeEventListener("modelChange",this);
      this._eaLocalDataProvider = eaDistantDataProvider;
      this._eaLocalDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaLocalDataProvider});
   }
   function set _mcBlinkPay(eaLocalDataProvider)
   {
      this._eaDistantDataProvider.removeEventListener("modelChange",this);
      this._eaDistantDataProvider = eaLocalDataProvider;
      this._eaDistantDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaDistantDataProvider});
   }
   function set _winCoop(eaCoopDataProvider)
   {
      this._eaCoopDataProvider.removeEventListener("modelChange",this);
      this._eaCoopDataProvider = eaCoopDataProvider;
      this._eaCoopDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaCoopDataProvider});
   }
   function set _bPayMode(eaPayDataProvider)
   {
      this._eaPayDataProvider.removeEventListener("modelChange",this);
      this._eaPayDataProvider = eaPayDataProvider;
      this._eaPayDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaPayDataProvider});
   }
   function set _mcBlinkPayIfSuccess(eaPayIfSuccessDataProvider)
   {
      this._eaPayIfSuccessDataProvider.removeEventListener("modelChange",this);
      this._eaPayIfSuccessDataProvider = eaPayIfSuccessDataProvider;
      this._eaPayIfSuccessDataProvider.addEventListener("modelChanged",this);
      this.modelChanged({target:this._eaPayIfSuccessDataProvider});
   }
   function set _winPay(eaReadyDataProvider)
   {
      this._eaReadyDataProvider.removeEventListener("modelChange",this);
      this._eaReadyDataProvider = eaReadyDataProvider;
      this._eaReadyDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function get openedCraftList()
   {
      return this._cvCraftViewer;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.SecureCraft.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this._mcPlacer._visible = false;
      this._winCraftViewer.swapDepths(this.getNextHighestDepth());
      this.showPreview(undefined,false);
      this.showCraftViewer(false);
      this.enableSearch(false);
      this.addToQueue({object:this,method:this.addListeners});
      this._btnSelectedFilterButton = this._btnFilterRessoureces;
      this.addToQueue({object:this,method:this.initData});
      this.hideItemViewer(true);
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initGridWidth});
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
   }
   function addListeners()
   {
      this._cgGrid.addEventListener("dblClickItem",this);
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgLocal.addEventListener("dblClickItem",this);
      this._cgLocal.addEventListener("dropItem",this);
      this._cgLocal.addEventListener("dragItem",this);
      this._cgLocal.addEventListener("selectItem",this);
      this._cgLocal.addEventListener("overItem",this);
      this._cgLocal.addEventListener("outItem",this);
      this._cgDistant.addEventListener("selectItem",this);
      this._cgDistant.addEventListener("overItem",this);
      this._cgDistant.addEventListener("outItem",this);
      this._cgCoop.addEventListener("selectItem",this);
      this._cgCoop.addEventListener("overItem",this);
      this._cgCoop.addEventListener("outItem",this);
      this._btnFilterEquipement.addEventListener("click",this);
      this._btnFilterNonEquipement.addEventListener("click",this);
      this._btnFilterRessoureces.addEventListener("click",this);
      this._btnFilterSoul.addEventListener("click",this);
      this._btnFilterCards.addEventListener("click",this);
      this._btnFilterEquipement.addEventListener("over",this);
      this._btnFilterNonEquipement.addEventListener("over",this);
      this._btnFilterRessoureces.addEventListener("over",this);
      this._btnFilterSoul.addEventListener("over",this);
      this._btnFilterCards.addEventListener("over",this);
      this._btnFilterEquipement.addEventListener("out",this);
      this._btnFilterNonEquipement.addEventListener("out",this);
      this._btnFilterRessoureces.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("click",this);
      this._btnFilterRunes.addEventListener("over",this);
      this._btnClose.addEventListener("click",this);
      this._btnQuantity.addEventListener("click",this);
      this._btnSearch.addEventListener("click",this);
      this._btnSearch.addEventListener("over",this);
      this._btnSearch.addEventListener("out",this);
      this.api.datacenter.Exchange.addEventListener("localKamaChange",this);
      this.api.datacenter.Exchange.addEventListener("distantKamaChange",this);
      this.api.datacenter.Exchange.addEventListener("payKamaChange",this);
      this.api.datacenter.Exchange.addEventListener("payIfSuccessKamaChange",this);
      this._btnValidate.addEventListener("click",this);
      this._btnCraft.addEventListener("click",this);
      this._btnPrivateMessage.addEventListener("click",this);
      this._btnMarked.addEventListener("click",this);
      this._mcFiligrane.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcFiligrane.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this._cbTypes.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
      this._lblPay.addEventListener("click",this);
      this._btnValidatePay.addEventListener("click",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
      this._lblPayKama.onRelease = function()
      {
         this._parent.switchPayBar(2);
      };
      this._mcPayHighlight.onRelease = function()
      {
         this._parent.switchPayBar(1);
      };
      this._cgCoop.multipleContainerSelectionEnabled = false;
      this._cgDistant.multipleContainerSelectionEnabled = false;
      this._cgGrid.multipleContainerSelectionEnabled = false;
      this._cgLocal.multipleContainerSelectionEnabled = false;
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winCrafter.title = this.api.datacenter.Player.data.name;
      this._winDistant.title = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name;
      this._winMarked.title = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name;
      this._btnValidate.label = this.api.lang.getText("COMBINE");
      this._btnValidatePay.label = this.api.lang.getText("VALIDATE");
      this._btnCraft.label = this.api.lang.getText("RECEIPTS");
      this._btnPrivateMessage.label = this.api.lang.getText("WISPER_MESSAGE");
      this._lblPay.label = this.api.lang.getText("WISPER_MESSAGE");
      this._btnQuantity.label = this.api.lang.getText("QUANTITY_SMALL") + ": 1";
      this._lblNewObject.text = this.api.lang.getText("CRAFTED_ITEM");
      this._winCraftViewer.title = this.api.lang.getText("RECEIPTS_FROM_JOB");
      this._lblSkill.text = this.api.lang.getText("SKILL") + " : " + this.api.lang.getSkillText(this._nSkillId).d + " (" + this.api.lang.getText("LEVEL") + " : " + this._nJobLevel + ")";
      this._winDistant.title = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name;
      this._lblKama.text = new ank.utils.ExtendedString(this.api.datacenter.Player.Kama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._mcArrow_.text = this.api.lang.getText("PAY");
      this._nKamaPaymentIfSuccess.text = this.api.lang.getText("GRANT_IF_SUCCESS");
      this._lblQty1.text = "" + this._nCurrentQuantity;
      this._lblQty2.text = "" + this._nCurrentQuantity;
      this._winOrder.title = this.api.lang.getText("ORDER");
      this._txtUseMarkRune.text = this.api.lang.getText("USE_MARKED_RUNE_IN_CRAFT");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
      this.updateTotalKama();
   }
   function initData()
   {
      this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
      this.dataProvider = this.api.datacenter.Exchange.inventory;
      this._nDistantReadyState = this.api.datacenter.Exchange.localGarbage;
      this._mcBlinkPay = this.api.datacenter.Exchange.distantGarbage;
      this._winCoop = this.api.datacenter.Exchange.coopGarbage;
      this._bPayMode = this.api.datacenter.Exchange.payIfSuccessGarbage;
      this._mcBlinkPayIfSuccess = this.api.datacenter.Exchange.payGarbage;
      this._winPay = this.api.datacenter.Exchange.readyStates;
      this.switchPayBar(1);
      this.showPreview(undefined,false);
      this._winInventory._visible = this._cgPay;
      this._cgGrid._visible = this._cgPay;
      this._cbTypes._visible = this._cgPay;
      this._lblKama._visible = this._cgPay;
      this._symbolKama._visible = this._cgPay;
      this._mcPods._visible = this._cgPay;
      this._btnFilterEquipement._visible = this._cgPay;
      this._btnFilterNonEquipement._visible = this._cgPay;
      this._btnFilterRessoureces._visible = this._cgPay;
      this._btnFilterSoul._visible = this._cgPay;
      this._btnFilterCards._visible = this._cgPay;
      this._btnFilterRunes._visible = this._cgPay;
      this._btnSearch._visible = this._cgPay;
      this._cgLocal._visible = this._cgPay;
      this._winCustomer._visible = this._cgPay;
      this._winMarked._visible = this._cgPay;
      this._ctrMarkRuneDistant._visible = this._cgPay;
      this._winCrafter._visible = !this._cgPay;
      this._ctrMarkRuneLocal._visible = !this._cgPay;
      this._txtUseMarkRune._visible = !this._cgPay;
      this._btnMarked._visible = !this._cgPay;
      this._mcPayIfSuccessKama._visible = this._cgPay;
      this._mcPayKama._visible = this._cgPay;
      this._btnQuantity._visible = this._cgPay;
      this._winDistant._visible = !this._cgPay;
      this._cgDistant._visible = !this._cgPay;
      this._oMarkedBaseItem = dofus.datacenter.Item.getItemTemplate(dofus.graphics.gapi.ui.SecureCraft.MARK_RUNE_ID);
      this._eaNotMarked = new ank.utils.ExtendedArray();
      this._eaMarked = new ank.utils.ExtendedArray();
      this._eaMarked.push(this._oMarkedBaseItem);
      var _loc2_;
      var _loc3_;
      if(this._cgPay)
      {
         this._ctrMarkRuneDistant.dataProvider = this._eaNotMarked;
      }
      else
      {
         _loc2_ = this.api.datacenter.Player.Inventory.findFirstItem("unicID",dofus.graphics.gapi.ui.SecureCraft.MARK_RUNE_ID);
         _loc3_ = new ank.utils.ExtendedArray();
         _loc3_.push(_loc2_.item);
         this._ctrMarkRuneLocal.dataProvider = _loc3_;
      }
   }
   function updateInventory()
   {
      this.api.datacenter.Exchange.inventory = this.api.datacenter.Player.Inventory.deepClone();
      this.dataProvider = this.api.datacenter.Exchange.inventory;
   }
   function initGridWidth()
   {
      if(this._nMaxItem == undefined)
      {
         this._nMaxItem = 9;
      }
      var _loc2_ = Math.min(8,this._nMaxItem);
      var _loc3_ = Math.min(9,this._nMaxItem);
      this._cgLocal.visibleColumnCount = _loc2_;
      this._cgDistant.visibleColumnCount = _loc2_;
      var _loc4_ = dofus.graphics.gapi.ui.SecureCraft.GRID_CONTAINER_WIDTH * _loc2_;
      this._cgLocal.setSize(_loc4_);
      this._cgLocal._x = this._winCustomer._x + this._winCustomer.width - _loc4_ - 10;
      _loc4_ = dofus.graphics.gapi.ui.SecureCraft.GRID_CONTAINER_WIDTH * _loc2_;
      this._cgDistant.setSize(_loc4_);
      this._cgDistant._x = this._winDistant._x + 10;
   }
   function updateData(eaDataProvider)
   {
      if(eaDataProvider == undefined)
      {
         eaDataProvider = this._eaDataProvider;
      }
      var _loc3_ = this.api.datacenter.Basics[dofus.graphics.gapi.ui.SecureCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name];
      this._nSelectedTypeID = _loc3_ != undefined ? _loc3_ : 0;
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = {};
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      for(var k in eaDataProvider)
      {
         _loc7_ = eaDataProvider[k];
         if(_loc7_.position == -1 && this._aSelectedSuperTypes[_loc7_.superType])
         {
            _loc8_ = _loc7_.type;
            if(!_loc5_[_loc8_])
            {
               _loc4_.push({label:this.api.lang.getItemTypeText(_loc8_).n,id:_loc8_});
               _loc5_[_loc8_] = true;
            }
            _loc9_ = this._iifFilter == null || this._iifFilter.isItemListed(_loc7_);
            _loc10_ = _loc7_.type == this._nSelectedTypeID || this._nSelectedTypeID == 0;
            _loc11_ = this._nSelectedTypeID == dofus.graphics.gapi.ui.SecureCraft.FILTER_TYPE_ONLY_USEFUL && this.api.kernel.GameManager.isItemUseful(_loc7_.unicID,this._nSkillId,this._nMaxItem);
            if(_loc9_ && (_loc10_ || _loc11_))
            {
               _loc6_.push(_loc7_);
            }
         }
      }
      _loc4_.sortOn("label");
      _loc4_.splice(0,0,{label:this.api.lang.getText("TYPE_FILTER_ONLY_USEFUL"),id:dofus.graphics.gapi.ui.SecureCraft.FILTER_TYPE_ONLY_USEFUL});
      _loc4_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:0});
      this._cbTypes.dataProvider = _loc4_;
      this.setType(this._nSelectedTypeID);
      this._cgGrid.dataProvider = _loc6_;
      var _loc12_;
      var _loc13_;
      if(!this._cgPay)
      {
         _loc12_ = this.api.datacenter.Player.Inventory.findFirstItem("unicID",dofus.graphics.gapi.ui.SecureCraft.MARK_RUNE_ID);
         _loc13_ = new ank.utils.ExtendedArray();
         _loc13_.push(_loc12_.item);
         this._ctrMarkRuneLocal.dataProvider = _loc13_;
      }
      this.updateTotalKama();
   }
   function getQtyIn(eaFrom, nItemID)
   {
      for(var qtc in eaFrom)
      {
         if(eaFrom[qtc].unicID == nItemID)
         {
            return eaFrom[qtc].Quantity;
         }
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
   function updateLocalData()
   {
      this._cgLocal.dataProvider = this._eaLocalDataProvider;
      this._bInvalidateCoop = true;
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function updateCoopData()
   {
      this._cgCoop.dataProvider = this._eaCoopDataProvider;
      this._mcFiligrane._visible = this._btnPay = this._eaCoopDataProvider == undefined;
      var _loc2_ = dofus.datacenter.Item(this._cgCoop.getContainer(0).contentData);
      if(_loc2_ != undefined)
      {
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = _loc2_;
      }
   }
   function updateDistantData()
   {
      this._cgDistant.dataProvider = this._eaDistantDataProvider;
      this._bInvalidateCoop = true;
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function updateReadyState()
   {
      var _loc2_ = !this._eaReadyDataProvider[0] ? dofus.graphics.gapi.ui.SecureCraft.NON_READY_COLOR : dofus.graphics.gapi.ui.SecureCraft.READY_COLOR;
      this.setMovieClipTransform(this._winCrafter,_loc2_);
      this.setMovieClipTransform(this._ctrMarkRuneLocal,_loc2_);
      this.setMovieClipTransform(this._btnMarked,_loc2_);
      this.setMovieClipTransform(this._winCustomer,_loc2_);
      this.setMovieClipTransform(this._btnValidate,_loc2_);
      this.setMovieClipTransform(this._cgLocal,_loc2_);
      _loc2_ = !this._eaReadyDataProvider[1] ? dofus.graphics.gapi.ui.SecureCraft.NON_READY_COLOR : dofus.graphics.gapi.ui.SecureCraft.READY_COLOR;
      this.setMovieClipTransform(this._winMarked,_loc2_);
      this.setMovieClipTransform(this._ctrMarkRuneDistant,_loc2_);
      this.setMovieClipTransform(this._winDistant,_loc2_);
      this.setMovieClipTransform(this._cgDistant,_loc2_);
   }
   function hideButtonValidate(bHide)
   {
      var _loc3_ = !bHide ? dofus.graphics.gapi.ui.SecureCraft.NON_READY_COLOR : dofus.graphics.gapi.ui.SecureCraft.READY_COLOR;
      this.setMovieClipTransform(this._btnValidate,_loc3_);
      this._btnValidate.enabled = !bHide;
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
   }
   function validateDrop(sToGrid, oItem, nValue)
   {
      if(nValue < 1 || nValue == undefined)
      {
         return undefined;
      }
      if(nValue > oItem.Quantity)
      {
         nValue = oItem.Quantity;
      }
      this._sDropTargetGrid = sToGrid;
      switch(sToGrid)
      {
         case "_cgGrid":
            this.api.network.Exchange.movementItem(false,oItem,nValue);
            break;
         case "_cgLocal":
            this.api.network.Exchange.movementItem(true,oItem,nValue);
      }
      if(this._bInvalidateCoop)
      {
         this.api.datacenter.Exchange.clearCoopGarbage();
         this._bInvalidateCoop = false;
      }
   }
   function setReady()
   {
      var _loc2_ = this.getTotalCraftInventory();
      if(_loc2_.length == 0)
      {
         return undefined;
      }
      if(_loc2_.length > this._nMaxItem)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_CRAFT_SLOT",[this._nMaxItem]),"ERROR_BOX",{name:"NotEnoughtCraftSlot"});
         return undefined;
      }
      this.api.network.Exchange.ready();
   }
   function canDropInGarbage(oItem)
   {
      var _loc3_ = this.api.datacenter.Exchange.localGarbage.findFirstItem("ID",oItem.ID);
      var _loc4_ = this.api.datacenter.Exchange.localGarbage.length;
      if(_loc3_.index == -1 && _loc4_ >= this._nMaxItem)
      {
         return false;
      }
      return true;
   }
   function showCraftViewer(bShow)
   {
      var _loc3_;
      if(bShow)
      {
         _loc3_ = this.attachMovie("CraftViewer","_cvCraftViewer",this.getNextHighestDepth());
         _loc3_._x = this._mcPlacer._x;
         _loc3_._y = this._mcPlacer._y;
         _loc3_.skill = new dofus.datacenter.Skill(this._nSkillId,this._nMaxItem);
      }
      else
      {
         this._cvCraftViewer.removeMovieClip();
      }
      this._winCraftViewer._visible = bShow;
   }
   function showPreview(item, b)
   {
      if(this._ctrPreview.contentPath == undefined)
      {
         return undefined;
      }
      this._mcFiligrane._visible = this._btnPay = b;
      this._ctrPreview._visible = b;
      this._ctrPreview.contentPath = !b ? "" : item.iconFile;
      this._mcFiligrane.itemName = item.name;
   }
   function updatePreview()
   {
      var _loc2_ = this.api.kernel.GameManager.analyseReceipts(this.getTotalCraftInventory(),this._nSkillId,this._nMaxItem);
      if(_loc2_ != undefined)
      {
         this.showPreview(new dofus.datacenter.Item(-1,_loc2_,1,0,"",0),true);
      }
      else
      {
         this.showPreview(undefined,false);
      }
   }
   function getTotalCraftInventory()
   {
      var _loc2_ = this.api.kernel.GameManager;
      return _loc2_.mergeUnicItemInInventory(_loc2_.mergeTwoInventory(this._eaLocalDataProvider,this._eaDistantDataProvider));
   }
   function switchPayBar(nPayBar)
   {
      if(nPayBar != undefined)
      {
         this._nPayBar = nPayBar;
      }
      this._mcPayHighlight._visible = this._cgPay;
      this._lblPayKama._visible = this._cgPay;
      this._mcPayHighlight._alpha = this._nPayBar != 1 ? 0 : 100;
      this._lblPayKama._alpha = this._nPayBar != 2 ? 0 : 100;
   }
   function validateKama(nQuantity)
   {
      if(nQuantity * this._nCurrentQuantity > this.api.datacenter.Player.Kama)
      {
         nQuantity = this.api.datacenter.Player.Kama;
      }
      this.api.network.Exchange.movementPayKama(this._nPayBar,nQuantity);
   }
   function askKamaQuantity(nPayBar)
   {
      this.switchPayBar(nPayBar);
      var _loc3_ = 0;
      var _loc4_ = 0;
      if(nPayBar == 1)
      {
         _loc3_ = this.api.datacenter.Player.Kama - this._nKamaPayment * this._nCurrentQuantity;
         _loc4_ = this._btnPayIfSuccessKama;
      }
      if(nPayBar == 2)
      {
         _loc3_ = this.api.datacenter.Player.Kama - this._btnPayIfSuccessKama * this._nCurrentQuantity;
         _loc4_ = this._nKamaPayment;
      }
      var _loc5_ = 0;
      var _loc6_ = Math.floor(_loc3_ / this._nCurrentQuantity);
      var _loc7_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:_loc4_,min:0,max:_loc6_,params:{targetType:"kama"}});
      _loc7_.addEventListener("validate",this);
   }
   function canUseItemInCraft(oItem)
   {
      if(this._nForgemagusItemType == undefined || this.isNotForgemagus())
      {
         return true;
      }
      if(oItem.type == 78)
      {
         return true;
      }
      var _loc3_ = false;
      var _loc4_ = 0;
      while(_loc4_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
      {
         if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc4_] == oItem.unicID)
         {
            return true;
         }
         _loc4_ = _loc4_ + 1;
      }
      var _loc5_ = 0;
      while(_loc5_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
      {
         if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc5_] == oItem.type)
         {
            return true;
         }
         _loc5_ = _loc5_ + 1;
      }
      if(this._nForgemagusItemType != oItem.type || !oItem.enhanceable)
      {
         return false;
      }
      return true;
   }
   function validCraft()
   {
      this.showCraftViewer(false);
      this._btnCraft.selected = false;
      this.setReady();
   }
   function isNotForgemagus()
   {
      return _global.isNaN(this._nForgemagusItemType);
   }
   function addCraft(nTargetItemId)
   {
      if(this._nLastRegenerateTimer + dofus.graphics.gapi.ui.SecureCraft.NAME_GENERATION_DELAY >= getTimer())
      {
         return undefined;
      }
      this._nLastRegenerateTimer = getTimer();
      var _loc3_ = this.api.lang.getSkillText(this._nSkillId).cl;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc7_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc18_;
      var _loc20_;
      var _loc17_;
      var _loc19_;
      var _loc21_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(nTargetItemId == _loc5_)
         {
            _loc6_ = this.api.lang.getCraftText(_loc5_);
            _loc8_ = 0;
            _loc9_ = [];
            _loc10_ = 0;
            while(_loc10_ < _loc6_.length)
            {
               _loc11_ = _loc6_[_loc10_];
               _loc12_ = _loc11_[0];
               _loc13_ = _loc11_[1];
               _loc7_ = false;
               _loc14_ = false;
               _loc15_ = 0;
               while(_loc15_ < this._eaDataProvider.length)
               {
                  if(_loc12_ == this._eaDataProvider[_loc15_].unicID)
                  {
                     if(this._eaDataProvider[_loc15_].isLock)
                     {
                        _loc14_ = true;
                     }
                     else if(_loc13_ <= this._eaDataProvider[_loc15_].Quantity)
                     {
                        _loc8_ = _loc8_ + 1;
                        _loc7_ = true;
                        _loc9_.push({item:this._eaDataProvider[_loc15_],qty:_loc13_});
                        break;
                     }
                  }
                  _loc15_ = _loc15_ + 1;
               }
               if(!_loc7_)
               {
                  if(_loc14_)
                  {
                     _loc16_ = new dofus.datacenter.Item(0,_loc12_);
                     this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_291",[_loc16_.name]),"ERROR_CHAT");
                  }
                  break;
               }
               _loc10_ = _loc10_ + 1;
            }
            if(_loc7_ && _loc6_.length == _loc8_)
            {
               _loc18_ = [];
               _loc20_ = 0;
               while(_loc20_ < this._cgLocal.dataProvider.length)
               {
                  _loc17_ = this._cgLocal.dataProvider[_loc20_];
                  _loc19_ = _loc17_.Quantity;
                  if(!(_loc19_ < 1 || _loc19_ == undefined))
                  {
                     _loc18_.push({Add:false,ID:_loc17_.ID,Quantity:_loc19_});
                  }
                  _loc20_ = _loc20_ + 1;
               }
               _loc21_ = 0;
               while(_loc21_ < _loc9_.length)
               {
                  _loc17_ = _loc9_[_loc21_].item;
                  _loc19_ = _loc9_[_loc21_].qty;
                  if(!(_loc19_ < 1 || _loc19_ == undefined))
                  {
                     _loc18_.push({Add:true,ID:_loc17_.ID,Quantity:_loc19_});
                  }
                  _loc21_ = _loc21_ + 1;
               }
               this.api.network.Exchange.movementItems(_loc18_);
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("DONT_HAVE_ALL_INGREDIENT"),"ERROR_BOX");
            }
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function updateTotalKama()
   {
      this._lblPayKamaTotal.text = new ank.utils.ExtendedString(this._nCurrentQuantity * this._btnPayIfSuccessKama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._lblPayIfSuccessKamaTotal.text = new ank.utils.ExtendedString(this._nCurrentQuantity * this._nKamaPayment).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._lblKamaPayment.text = new ank.utils.ExtendedString(this._nKamaPayment).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._bFiligraneVisible.text = new ank.utils.ExtendedString(this._btnPayIfSuccessKama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      if(this._cgPay)
      {
         this._lblKama.text = new ank.utils.ExtendedString(this.api.datacenter.Player.Kama - this._btnPayIfSuccessKama * this._nCurrentQuantity - this._nKamaPayment * this._nCurrentQuantity).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      }
   }
   function playBlink(idx)
   {
      if(dofus.Constants.TRIPLEFRAMERATE)
      {
         if(idx == 1)
         {
            this._mcBlinkPay_TripleFramerate.play();
         }
         if(idx == 2)
         {
            this._mcBlinkPayIfSuccess_TripleFramerate.play();
         }
      }
      else
      {
         if(idx == 1)
         {
            this._sCurrentDragSource.play();
         }
         if(idx == 2)
         {
            this._sCurrentDragTarget.play();
         }
      }
   }
   function reset()
   {
      var _loc2_ = this.api.datacenter.Exchange;
      _loc2_.clearDistantGarbage();
      _loc2_.clearPayIfSuccessGarbage();
      _loc2_.clearPayGarbage();
      _loc2_.payKama = 0;
      _loc2_.payIfSuccessKama = 0;
      this._nCurrentQuantity = 1;
      this._btnQuantity.label = this.api.lang.getText("QUANTITY_SMALL") + ": 1";
      this.updateData();
      this.updateInventory();
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
      this.updateData(_loc3_);
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
   function kamaChanged(oEvent)
   {
      this._lblKama.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.target)
      {
         case this._eaLocalDataProvider:
            this.updateLocalData();
            this.updatePreview();
            return;
         case this._eaDistantDataProvider:
            this.updateDistantData();
            this.updatePreview();
            if(this._eaDistantDataProvider.length > 0)
            {
               this._cgCoop.dataProvider = new ank.utils.ExtendedArray();
            }
            return;
         case this._eaDataProvider:
            this.updateData();
            if(this._sCurrentItemSearch != "")
            {
               this.searchItem(this._sCurrentItemSearch);
            }
            this.updatePreview();
            return;
         case this._eaCoopDataProvider:
            this.updateCoopData();
            this.updatePreview();
            return;
         case this._eaReadyDataProvider:
            this.updateReadyState();
            return;
         default:
            this.updateData();
            this.updateLocalData();
            this.updateDistantData();
            this.updateCoopData();
            this.updatePreview();
            return;
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
         case this._btnFilterRunes:
            this.api.ui.showTooltip(this.api.lang.getText("RUNES"));
            break;
         case this._btnFilterCards:
            this.api.ui.showTooltip(this.api.lang.getText("CARDS"));
            break;
         case this._btnSearch:
            this.api.ui.showTooltip(this.api.lang.getText("SEARCH"));
            break;
         case this._mcFiligrane:
            if(this._mcFiligrane.itemName != undefined)
            {
               this.gapi.showTooltip(this._mcFiligrane.itemName);
            }
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function onCraftLoopEnd()
   {
      this._bIsLooping = false;
      this._btnValidate.label = this.api.lang.getText("COMBINE");
      this._btnQuantity.enabled = true;
      this._mcPayKama.enabled = true;
      this._mcPayIfSuccessKama.enabled = true;
      this._btnMarked.enabled = true;
      this.reset();
   }
   function onCraftLoopStart()
   {
      this._bIsLooping = true;
      this._btnValidate.label = this.api.lang.getText("STOP_WORD");
      this._btnQuantity.enabled = false;
      this._mcPayKama.enabled = false;
      this._mcPayIfSuccessKama.enabled = false;
      this._btnMarked.enabled = false;
   }
   function onCraftLoop(nCrafted)
   {
      if(!this._cgPay)
      {
         return undefined;
      }
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      while(_loc3_ < this._eaLocalDataProvider.length)
      {
         _loc4_ = this._eaLocalDataProvider[_loc3_];
         _loc5_ = this._eaDataProvider.findFirstItem("ID",_loc4_.ID);
         _loc6_ = _loc5_.item.Quantity - _loc4_.Quantity * nCrafted;
         _loc5_.item.Quantity = _loc6_;
         this._eaDataProvider.updateItem(_loc5_.index,_loc5_.item);
         _loc3_ = _loc3_ + 1;
      }
      this.updateData();
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnClose)
      {
         this.callClose();
         return undefined;
      }
      if(oEvent.target == this._btnPrivateMessage || oEvent.target == this._lblPay)
      {
         this.api.kernel.GameManager.askPrivateMessage(this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name);
      }
      if(this._bIsLooping)
      {
         if(oEvent.target == this._btnValidate)
         {
            this.api.network.Exchange.stopRepeatCraft();
         }
         return undefined;
      }
      var _loc3_;
      if(oEvent.target == this._btnValidate)
      {
         _loc3_ = this.api.kernel.GameManager.analyseReceipts(this.getTotalCraftInventory(),this._nSkillId,this._nMaxItem);
         if(_loc3_ == undefined && (this.api.kernel.OptionsManager.getOption("AskForWrongCraft") && this.isNotForgemagus()))
         {
            this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("WRONG_CRAFT_CONFIRM"),"CAUTION_YESNO",{name:"confirmWrongCraft",listener:this});
         }
         else
         {
            this.validCraft();
         }
         return undefined;
      }
      if(oEvent.target == this._btnMarked)
      {
         if(this._cgPay)
         {
            return undefined;
         }
         this.api.network.Exchange.markCraft(this._btnMarked.selected);
         return undefined;
      }
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc9_;
      var _loc8_;
      var _loc10_;
      var _loc7_;
      var _loc11_;
      if(oEvent.target == this._btnQuantity)
      {
         if(!this._cgPay)
         {
            return undefined;
         }
         _loc4_ = 99;
         _loc5_ = 1;
         _loc6_ = Math.floor(this.api.datacenter.Player.Kama / (this._btnPayIfSuccessKama + this._nKamaPayment));
         _loc9_ = 0;
         while(_loc9_ < this._eaLocalDataProvider.length)
         {
            _loc8_ = false;
            _loc10_ = 0;
            while(_loc10_ < this._eaDataProvider.length)
            {
               if(this._eaLocalDataProvider[_loc9_].ID == this._eaDataProvider[_loc10_].ID)
               {
                  _loc8_ = true;
                  _loc7_ = Math.floor(this._eaDataProvider[_loc10_].Quantity / this._eaLocalDataProvider[_loc9_].Quantity) + 1;
                  if(_loc7_ < _loc6_)
                  {
                     _loc6_ = _loc7_;
                  }
               }
               _loc10_ = _loc10_ + 1;
            }
            if(!_loc8_)
            {
               break;
            }
            _loc9_ = _loc9_ + 1;
         }
         if(_loc8_)
         {
            _loc5_ = 1;
            _loc4_ = _loc6_;
         }
         else
         {
            _loc4_ = 0;
            _loc5_ = 0;
         }
         _loc11_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:this._nCurrentQuantity,max:_loc4_,params:{targetType:"repeat"}});
         _loc11_.addEventListener("validate",this);
         return undefined;
      }
      if(oEvent.target == this._btnCraft)
      {
         this.showCraftViewer(oEvent.target.selected);
         return undefined;
      }
      if(oEvent.target == this._btnSearch)
      {
         this.enableSearch(this._btnSearch.selected);
         if(!this._btnSearch.selected)
         {
            this.updateData(this._eaDataProvider);
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
               this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
               this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
               break;
            case this._btnFilterNonEquipement:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
               this._lblFilter.text = this.api.lang.getText("CONSUMABLES");
               break;
            case this._btnFilterRessoureces:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
               this._lblFilter.text = this.api.lang.getText("RESSOURECES");
               break;
            case this._btnFilterSoul:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
               this._lblFilter.text = this.api.lang.getText("SOUL");
               break;
            case this._btnFilterRunes:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
               this._lblFilter.text = this.api.lang.getText("RUNES");
               break;
            case this._btnFilterCards:
               this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
               this._lblFilter.text = this.api.lang.getText("CARDS");
         }
         this.updateData();
      }
      else
      {
         oEvent.target.selected = true;
      }
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
      this._currentOverContainer = _loc3_;
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
      this._currentOverContainer = undefined;
   }
   function dblClickItem(oEvent)
   {
      if(this._bIsLooping)
      {
         return undefined;
      }
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = !Key.isDown(Key.CONTROL) ? 1 : _loc3_.Quantity;
      var _loc5_ = oEvent.owner._name;
      this._lblPayIfSuccess = _loc5_;
      var _loc6_;
      switch(_loc5_)
      {
         case "_cgGrid":
            if(!this.canDropInGarbage(_loc3_))
            {
               return undefined;
            }
            if(!this.canUseItemInCraft(_loc3_))
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("WRONG_ITEM_TYPE"),"ERROR_CHAT");
               return undefined;
            }
            _loc6_ = "_cgLocal";
            break;
         case "_cgLocal":
            _loc6_ = "_cgGrid";
      }
      this.validateDrop(_loc6_,_loc3_,_loc4_);
   }
   function dragItem(oEvent)
   {
      this.gapi.removeCursor();
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this._lblPayIfSuccess = oEvent.target._parent._parent._name;
      this.gapi.setCursor(oEvent.target.contentData);
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
      if(this._bIsLooping)
      {
         return undefined;
      }
      var _loc4_ = oEvent.target._parent._parent._name;
      switch(_loc4_)
      {
         case "_cgGrid":
            if(_loc3_.position == -1)
            {
               return undefined;
            }
            break;
         case "_cgLocal":
            if(_loc3_.position == -2)
            {
               return undefined;
            }
            if(!this.canUseItemInCraft(_loc3_))
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("WRONG_ITEM_TYPE"),"ERROR_CHAT");
               return undefined;
            }
            if(!this.canDropInGarbage(_loc3_))
            {
               return undefined;
            }
      }
      var _loc5_;
      if(_loc3_.Quantity > 1 && _loc4_ != "_cgGrid")
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc3_.Quantity,params:{targetType:"item",oItem:_loc3_,targetGrid:_loc4_}});
         _loc5_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(_loc4_,_loc3_,1);
      }
   }
   function selectItem(oEvent)
   {
      if(oEvent.target.contentData == undefined)
      {
         this.hideItemViewer(true);
      }
      else
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
            return undefined;
         }
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.target.contentData;
      }
   }
   function validate(oEvent)
   {
      if(this._bIsLooping)
      {
         return undefined;
      }
      var _loc3_;
      switch(oEvent.params.targetType)
      {
         case "item":
            this.validateDrop(oEvent.params.targetGrid,oEvent.params.oItem,oEvent.value);
            break;
         case "kama":
            this.validateKama(oEvent.value);
            break;
         case "repeat":
            _loc3_ = Number(oEvent.value);
            if(_loc3_ < 1 || (_loc3_ == undefined || _global.isNaN(_loc3_)))
            {
               _loc3_ = 1;
            }
            this.api.network.Exchange.setQuantity(_loc3_);
         default:
            return;
      }
   }
   function onQuantityChange(oEvent)
   {
      this.playBlink(1);
      this.playBlink(2);
      this._btnQuantity.label = this.api.lang.getText("QUANTITY_SMALL") + ": " + oEvent;
      this._nCurrentQuantity = oEvent;
      this._lblQty1.text = "" + oEvent;
      this._lblQty2.text = "" + oEvent;
      this.updateTotalKama();
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function onMarkChange(bMarked)
   {
      this._btnMarked.selected = bMarked;
      if(this._cgPay)
      {
         if(bMarked)
         {
            this._ctrMarkRuneDistant.dataProvider = this._eaMarked;
         }
         else
         {
            this._ctrMarkRuneDistant.dataProvider = this._eaNotMarked;
         }
      }
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_cbTypes")
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.ui.SecureCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name] = this._nSelectedTypeID;
         this.updateData();
      }
   }
   function localKamaChange(oEvent)
   {
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function payKamaChange(bShow)
   {
      this.playBlink(1);
      this._btnPayIfSuccessKama = bShow.value;
      if(_global.isNaN(this._nKamaPayment) || this._nKamaPayment == undefined)
      {
         this._nKamaPayment = 0;
      }
      this.updateTotalKama();
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function payIfSuccessKamaChange(bShow)
   {
      this.playBlink(2);
      this._nKamaPayment = bShow.value;
      if(_global.isNaN(this._btnPayIfSuccessKama) || this._btnPayIfSuccessKama == undefined)
      {
         this._btnPayIfSuccessKama = 0;
      }
      this.updateTotalKama();
      this.hideButtonValidate(true);
      ank.utils.Timer.setTimer(this,"securecraft",this,this.hideButtonValidate,dofus.graphics.gapi.ui.SecureCraft.DELAY_BEFORE_VALIDATE,[false]);
   }
   function yes()
   {
      if(this._bIsLooping)
      {
         return undefined;
      }
      this.validCraft();
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
         this.updateData(this._eaDataProvider);
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
}
