class dofus.graphics.gapi.ui.BigStoreBuy extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnClose2;
   var _btnGrid;
   var _btnList;
   var _btnSearch;
   var _btnSwitchToSell;
   var _btnTypes;
   var _cbTypes;
   var _cgItems;
   var _iCurrentItemSearched;
   var _iifFilter;
   var _itvItemViewer;
   var _lblItemType;
   var _lblItems;
   var _lblItemsCount;
   var _lblKamas;
   var _lblNoItem;
   var _lblPrices;
   var _lblTypes;
   var _lstItems;
   var _mcArrowAnim;
   var _mcBottomArrow;
   var _mcLeft2Arrow;
   var _mcLeftArrow;
   var _mcPricesGrid;
   var _mcSpacer;
   var _nCurrentTypeSelected;
   var _nLastSelectedIndex;
   var _nLastSelectedItemId;
   var _nLastSelectedPrice;
   var _oCurrentItem;
   var _oData;
   var _winBackground;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "BigStoreBuy";
   var _sDefaultSearch = "";
   var _autoSelectPriceMin = 3000;
   var _autoSelectPriceDiff = 50;
   var _bIsCurrentTypeCeremonial = false;
   function BigStoreBuy()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function set defaultSearch(sText)
   {
      this._sDefaultSearch = sText;
   }
   function get isFullSoul()
   {
      return dofus.datacenter.Item.isFullSoul(this._nCurrentTypeSelected);
   }
   function get previousBoughtId()
   {
      return this._nLastSelectedItemId;
   }
   function get previousBoughtQty()
   {
      return this._nLastSelectedIndex;
   }
   function get currentItemSearched()
   {
      return this._iCurrentItemSearched;
   }
   function set currentItemSearched(iCurrentItemSearched)
   {
      this._iCurrentItemSearched = iCurrentItemSearched;
   }
   function askBuy(oItem, nQuantityIndex, nPrice)
   {
      var _loc5_;
      if(oItem != undefined && (nQuantityIndex != undefined && !_global.isNaN(nPrice)))
      {
         if(nPrice > this.api.datacenter.Player.Kama)
         {
            this.gapi.loadUIComponent("AskOk","AskOkNotRich",{title:this.api.lang.getText("ERROR_WORD"),text:this.api.lang.getText("NOT_ENOUGH_RICH")});
         }
         else
         {
            _loc5_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoBuy",{title:this.api.lang.getText("BIGSTORE"),text:this.api.lang.getText("DO_U_BUY_ITEM_BIGSTORE",["x" + this._oData["quantity" + nQuantityIndex] + " " + oItem.name,new ank.utils.ExtendedString(nPrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]),params:{id:oItem.ID,quantityIndex:nQuantityIndex,price:nPrice}});
            _loc5_.addEventListener("yes",this);
         }
      }
   }
   function setTypeFromItemType(iItem)
   {
      var _loc3_ = this._cbTypes.dataProvider;
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].id;
         _loc6_ = _loc3_[_loc4_].isCeremonial;
         if(_loc5_ == iItem.type && (!iItem.isCeremonial || _loc6_))
         {
            this._cbTypes.selectedIndex = _loc4_;
            this._bIsCurrentTypeCeremonial = _loc6_;
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function setType(nType)
   {
      var _loc3_ = this._oData.types;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         if(_loc3_[_loc4_] == nType)
         {
            this._cbTypes.selectedIndex = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function setItem(nUnicID)
   {
      var _loc3_ = this._lstItems.dataProvider;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         if(_loc3_[_loc4_].unicID == nUnicID)
         {
            if(this._lstItems.selectedIndex != _loc4_)
            {
               this._lstItems.selectedIndex = _loc4_;
               this._lstItems.setVPosition(_loc4_);
            }
            if(!this.isFullSoul && this._cgItems.selectedIndex != _loc4_)
            {
               _loc5_ = Math.floor(_loc4_ / this._cgItems.visibleColumnCount);
               this._cgItems.setVPosition(_loc5_);
               this._cgItems.selectedIndex = _loc4_;
            }
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._mcPricesGrid.updateItem(new dofus.datacenter.Item(0,nUnicID),false);
   }
   function askMiddlePrice(oItem)
   {
      this.api.network.Exchange.getItemMiddlePriceInBigStore(oItem.unicID);
   }
   function setMiddlePrice(nUnicID, nPrice)
   {
      var _loc4_ = "";
      var _loc5_;
      if(nPrice == -2)
      {
         _loc4_ = this.api.lang.getText("BIG_STORE_UNCALCULABLE");
      }
      else if(nPrice == -1)
      {
         _loc4_ = this.api.lang.getText("BIG_STORE_NOT_SOLD_YET");
      }
      else
      {
         _loc5_ = new ank.utils.ExtendedString(nPrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         _loc4_ = this.api.lang.getText("MIDDLEPRICE",[_loc5_]);
      }
      this._lblPrices.text = "<font color=\"#FFFFFF\">" + _loc4_ + "</font>";
   }
   function isSimilarToPreviousBought(oItem)
   {
      if(oItem.id != this._nLastSelectedItemId)
      {
         return false;
      }
      var _loc3_ = oItem["priceSet" + this._nLastSelectedIndex];
      if(_loc3_ == undefined || _global.isNaN(_loc3_))
      {
         return false;
      }
      if(_loc3_ < this._autoSelectPriceMin)
      {
         return true;
      }
      var _loc4_ = 100 * _loc3_ / this._nLastSelectedPrice - 100;
      if(_loc4_ > this._autoSelectPriceDiff)
      {
         return false;
      }
      return true;
   }
   function selectThisItem(item)
   {
      if(item.unicID != this._oCurrentItem.unicID)
      {
         this._mcPricesGrid.updateItem(item,true);
         this._oCurrentItem = item;
         this.askMiddlePrice(item);
      }
      if(this.isFullSoul)
      {
         this.toggleComponentsVisibility(2);
      }
      else
      {
         this._itvItemViewer.itemData = item;
         this.toggleComponentsVisibility(4,true);
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.BigStoreBuy.CLASS_NAME);
   }
   function callClose()
   {
      this.gapi.hideTooltip();
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.populateComboBox});
      this.addToQueue({object:this,method:this.updateData});
      this.showArrowAnim(false);
      this._itvItemViewer._visible = false;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClose2.addEventListener("click",this);
      this._btnSearch.addEventListener("click",this);
      this._btnTypes.addEventListener("over",this);
      this._btnTypes.addEventListener("out",this);
      this._btnSwitchToSell.addEventListener("click",this);
      this._btnList.addEventListener("click",this);
      this._btnGrid.addEventListener("click",this);
      this._cbTypes.addEventListener("itemSelected",this);
      this._lstItems.addEventListener("itemSelected",this);
      this._cgItems.addEventListener("selectItem",this);
      this._cgItems.addEventListener("overItem",this);
      this._cgItems.addEventListener("outItem",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
         this._oData.addEventListener("modelChanged2",this);
      }
      else
      {
         ank.utils.Logger.err("[BigStoreBuy] il n\'y a pas de data");
      }
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
      this.toggleGridView(this.api.kernel.OptionsManager.getOption("DisplayBigStoreAsGrid"));
   }
   function initTexts()
   {
      this._winBackground.title = this.api.lang.getText("BIGSTORE") + (this._oData != undefined ? " (" + this.api.lang.getText("BIGSTORE_MAX_LEVEL") + " : " + this._oData.maxLevel + ")" : "");
      this._lblItems.text = this.api.lang.getText("BIGSTORE_ITEM_LIST");
      this._lblItemType.text = this.api.lang.getText("ITEM_TYPE");
      this._lblKamas.text = this.api.lang.getText("WALLET") + " :";
      this._btnClose2.label = this.api.lang.getText("CLOSE");
      this._btnSearch.label = this.api.lang.getText("SEARCH");
      this._btnSwitchToSell.label = this.api.lang.getText("BIGSTORE_MODE_SELL");
   }
   function updateData()
   {
      this.kamaChanged({value:this.api.datacenter.Player.Kama});
   }
   function populateComboBox()
   {
      var _loc2_ = this._oData.types;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < _loc2_.length)
      {
         _loc5_ = Number(_loc2_[_loc4_]);
         _loc3_.push({label:this.api.lang.getItemTypeText(_loc5_).n,id:_loc5_});
         _loc6_ = this.isTypeCeremonial(_loc5_);
         if(_loc6_)
         {
            _loc3_.push({label:this.api.lang.getItemTypeText(_loc5_).n + " (" + this.api.lang.getText("CEREMONIAL") + ")",id:_loc5_,isCeremonial:true});
         }
         _loc4_ = _loc4_ + 1;
      }
      _loc3_.sortOn("label");
      this._oData.types = [];
      var _loc7_ = 0;
      while(_loc7_ < _loc3_.length)
      {
         this._oData.types.push(_loc3_[_loc7_].id);
         _loc7_ = _loc7_ + 1;
      }
      this._cbTypes.dataProvider = _loc3_;
      if(_loc3_.length > 0)
      {
         this._cbTypes.selectedIndex = 0;
         this.updateType(this._cbTypes.selectedItem.id);
         if(this._cbTypes.selectedIndex == undefined)
         {
            this.toggleComponentsVisibility(0);
         }
      }
   }
   function updateType(nTypeID)
   {
      this._lstItems.selectedIndex = -1;
      this._mcPricesGrid.updateItem(undefined,true);
      this._bIsCurrentTypeCeremonial = this._cbTypes.selectedItem.isCeremonial || nTypeID == dofus.datacenter.Item.TYPE_LIVING_ITEM;
      this.api.network.Exchange.bigStoreType(nTypeID);
      this._nCurrentTypeSelected = nTypeID;
      this._oCurrentItem = undefined;
   }
   function toggleComponentsVisibility(nIndex, bShowBaseEffects)
   {
      this._mcBottomArrow._visible = false;
      this._mcBottomArrow.stop();
      this._mcLeftArrow._visible = false;
      this._mcLeftArrow.stop();
      this._mcLeft2Arrow._visible = false;
      this._mcLeft2Arrow.stop();
      this._itvItemViewer._visible = false;
      this._mcSpacer._visible = false;
      this._lblNoItem._y = 151;
      switch(nIndex)
      {
         case 0:
            this._mcLeftArrow._visible = true;
            this._mcLeftArrow.play();
            this._lblNoItem.text = this.api.lang.getText("BIGSTORE_HELP_SELECT_TYPE");
            this._lblPrices.text = "";
            this._lblNoItem._y = 101;
            break;
         case 1:
            this._mcLeft2Arrow._visible = true;
            this._mcLeft2Arrow.play();
            this._lblNoItem.text = this.api.lang.getText("BIGSTORE_HELP_SELECT_ITEM");
            this._lblPrices.text = "";
            break;
         case 2:
            this._mcBottomArrow._visible = true;
            this._mcBottomArrow.play();
            this._lblNoItem.text = this.api.lang.getText("BIGSTORE_HELP_SELECT_PRICE");
            break;
         case 3:
            this._lblNoItem.text = this.api.lang.getText("NO_INVENTORY_SEARCH_RESULT");
            this._lblItemsCount.text = this.api.lang.getText(this.isFullSoul != true ? "NO_BIGSTORE_RESULT" : "NO_BIGSTORE_MONSTER_RESULT");
            this._lblPrices.text = "";
            break;
         case 4:
            this._itvItemViewer.showBaseEffects = bShowBaseEffects;
            this._itvItemViewer._visible = true;
            this._mcSpacer._visible = true;
            this._lblNoItem.text = "";
         default:
            return;
      }
   }
   function showArrowAnim(bShow)
   {
      if(bShow)
      {
         this._mcArrowAnim._visible = true;
         this._mcArrowAnim.play();
         ank.utils.Timer.setTimer(this,"bigstore",this,this.showArrowAnim,800,[false]);
      }
      else
      {
         this._mcArrowAnim._visible = false;
         this._mcArrowAnim.stop();
      }
   }
   function toggleGridView(bGrid, bSetOption)
   {
      this._btnList.selected = this._lstItems._visible = !bGrid;
      this._btnGrid.selected = this._cgItems._visible = bGrid;
      if(bSetOption)
      {
         this.api.kernel.OptionsManager.setOption("DisplayBigStoreAsGrid",bGrid);
      }
   }
   function isTypeCeremonial(nTypeID)
   {
      return this.api.lang.getItemTypeText(nTypeID).a == "1";
   }
   function onSearchResult(bSuccess)
   {
      if(bSuccess)
      {
         this.api.ui.unloadUIComponent("BigStoreSearch");
         if(!this.isFullSoul)
         {
            this.setTypeFromItemType(this._iCurrentItemSearched);
         }
      }
      else
      {
         this.api.kernel.showMessage(this.api.lang.getText("BIGSTORE"),this.api.lang.getText("ITEM_NOT_IN_BIGSTORE"),"ERROR_BOX");
         this._iCurrentItemSearched = undefined;
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnList:
            this.toggleGridView(false,true);
            break;
         case this._btnGrid:
            this.toggleGridView(true,true);
            break;
         case this._btnClose:
         case this._btnClose2:
            this.callClose();
            break;
         case this._btnSearch:
            this.api.ui.loadUIComponent("BigStoreSearch","BigStoreSearch",{types:this._oData.types,defaultSearch:this._sDefaultSearch,oParent:this,isMonster:this.isFullSoul});
            break;
         case this._btnSwitchToSell:
            this.api.network.Exchange.request(10,this._oData.npcID);
         default:
            return;
      }
   }
   function itemSelected(oEvent)
   {
      switch(oEvent.target)
      {
         case this._cbTypes:
            this.updateType(this._cbTypes.selectedItem.id);
            break;
         case this._lstItems:
            if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.row.item != undefined)
            {
               this.api.kernel.GameManager.insertItemInChat(oEvent.row.item);
               return undefined;
            }
            this.selectThisItem(oEvent.row.item);
         default:
            return;
      }
   }
   function selectItem(oEvent_)
   {
      if(oEvent_.target.contentData == undefined)
      {
         this._oCurrentItem = undefined;
         this._lstItems.selectedIndex = -1;
         this._mcPricesGrid.updateItem(undefined,true);
         this.toggleComponentsVisibility(1);
         return undefined;
      }
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent_.target.contentData != undefined)
      {
         this.api.kernel.GameManager.insertItemInChat(oEvent_.target.contentData);
         return undefined;
      }
      this.selectThisItem(oEvent_.target.contentData);
   }
   function overItem(oEvent_)
   {
      var _loc3_ = oEvent_.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      _loc3_.showStatsTooltip(_loc3_.style);
   }
   function outItem(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function modelChanged(oEvent)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      if(!this.isFullSoul)
      {
         if(this._bIsCurrentTypeCeremonial)
         {
            this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
         }
         else
         {
            this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
         }
      }
      else
      {
         this._iifFilter = undefined;
      }
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._oData.inventory.length)
      {
         _loc5_ = this._oData.inventory[_loc4_];
         if(this._iifFilter == undefined || this._iifFilter.isItemListed(_loc5_))
         {
            _loc3_.push(this._oData.inventory[_loc4_]);
         }
         _loc4_ = _loc4_ + 1;
      }
      if(this.isFullSoul)
      {
         _loc3_.sortOn("name");
         this.toggleGridView(false);
         this._btnGrid._visible = this._btnList._visible = false;
      }
      else
      {
         _loc3_.sortOn(["_itemLevel","_itemName"],Array.NUMERIC | Array.CASEINSENSITIVE);
         this.toggleGridView(!this.isFullSoul && this.api.kernel.OptionsManager.getOption("DisplayBigStoreAsGrid"));
         this._btnGrid._visible = this._btnList._visible = true;
      }
      if(!this.isFullSoul)
      {
         this._cgItems.dataProvider = _loc3_;
      }
      this._lstItems.dataProvider = _loc3_;
      if(_loc3_.length > 0)
      {
         this.toggleComponentsVisibility(1);
         this._lblItemsCount.text = _loc3_.length + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText(this.isFullSoul != true ? "OBJECTS" : "MONSTER"),"m",_loc3_.length < 2);
      }
      else
      {
         this.toggleComponentsVisibility(3);
      }
   }
   function modelChanged2(oEvent)
   {
      if(this._oData.inventory2.length > 0 && this._mcPricesGrid.hasSelected)
      {
         this.toggleComponentsVisibility(4);
      }
      else if(this._oData.inventory2.length > 0 && !this._itvItemViewer._visible)
      {
         this.toggleComponentsVisibility(2);
      }
      else if(this._oData.inventory2.length == 0)
      {
         this._oCurrentItem = undefined;
         this.toggleComponentsVisibility(1);
      }
   }
   function yes(oEvent)
   {
      this.api.network.Exchange.bigStoreBuy(oEvent.target.params.id,oEvent.target.params.quantityIndex,oEvent.target.params.price);
      this._nLastSelectedItemId = oEvent.target.params.id;
      this._nLastSelectedIndex = oEvent.target.params.quantityIndex;
      this._nLastSelectedPrice = oEvent.target.params.price;
   }
   function kamaChanged(oEvent)
   {
      this._lblTypes.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function over(oEvent)
   {
      var _loc3_ = this.api.lang.getText("BIGSTORE_MAX_LEVEL") + " : " + this._oData.maxLevel;
      _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_TAX") + " : " + this._oData.tax + "%";
      _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_MAX_ITEM_PER_ACCOUNT") + " : " + this._oData.maxItemCount;
      _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_MAX_SELL_TIME") + " : " + this._oData.maxSellTime + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("HOURS"),"m",this._oData.maxSellTime < 2);
      _loc3_ += "\n\n" + this.api.lang.getText("BIGSTORE_GAIN_SLOT");
      _loc3_ += "\n\n" + this.api.lang.getText("BIGSTORE_TYPES") + " :";
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._cbTypes.dataProvider.length)
      {
         _loc5_ = this._cbTypes.dataProvider[_loc4_].label;
         _loc3_ += "\n - " + _loc5_;
         _loc4_ = _loc4_ + 1;
      }
      this.gapi.showTooltip(_loc3_);
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
