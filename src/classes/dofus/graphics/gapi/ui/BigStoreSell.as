class dofus.graphics.gapi.ui.BigStoreSell extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bFullSoul;
   var _btnAdd;
   var _btnClose;
   var _btnFilterSell;
   var _btnRemove;
   var _btnSwitchToBuy;
   var _btnTypes;
   var _cbQuantity;
   var _itvItemViewer;
   var _lblFilterSell;
   var _lblKama;
   var _lblMiddlePrice;
   var _lblPrice;
   var _lblQuantity;
   var _lblQuantityValue;
   var _lblTaxTime;
   var _lblTaxTimeValue;
   var _livInventory;
   var _livInventory2;
   var _mcBuyArrow;
   var _mcKamaSymbol;
   var _mcMask;
   var _mcMiddlePrice;
   var _mcPrice;
   var _mcPricesGrid;
   var _mcSellArrow;
   var _nLastPrice;
   var _nQuantityIndex;
   var _nTotalKamasSelling;
   var _oData;
   var _oDefaultButton;
   var _oSelectedItem;
   var _sReason;
   var _sRemoveText;
   var _srBottom;
   var _tiPrice;
   var _txtBadItem;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "BigStoreSell";
   function BigStoreSell()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function get currentOverItem()
   {
      if(this._livInventory != undefined && this._livInventory.currentOverItem != undefined)
      {
         return this._livInventory.currentOverItem;
      }
      if(this._livInventory2 != undefined && this._livInventory2.currentOverItem != undefined)
      {
         return this._livInventory2.currentOverItem;
      }
      return undefined;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function setMiddlePrice(nUnicID, nPrice)
   {
      var _loc4_;
      if(this._itvItemViewer.itemData.unicID == nUnicID && this._itvItemViewer.itemData != undefined)
      {
         if(nPrice == -2)
         {
            this._lblMiddlePrice.text = this.api.lang.getText("BIG_STORE_UNCALCULABLE");
         }
         else if(nPrice == -1)
         {
            this._lblMiddlePrice.text = this.api.lang.getText("BIG_STORE_NOT_SOLD_YET");
         }
         else
         {
            _loc4_ = new ank.utils.ExtendedString(nPrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
            this._lblMiddlePrice.text = this.api.lang.getText("MIDDLEPRICE",[_loc4_]);
         }
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.BigStoreSell.CLASS_NAME);
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
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.setAddMode,params:[false]});
      this.addToQueue({object:this,method:this.setRemoveMode,params:[false]});
      this.hideItemViewer(true);
   }
   function addListeners()
   {
      this._livInventory.addEventListener("selectedItem",this);
      this._livInventory.addEventListener("filterChanged",this);
      this._livInventory2.addEventListener("selectedItem",this);
      this._livInventory2.addEventListener("rollOverItem",this);
      this._livInventory2.addEventListener("rollOutItem",this);
      this._livInventory2.addEventListener("updateTotalKamas",this);
      this._livInventory2.lstInventory.multipleSelection = true;
      this._btnAdd.addEventListener("click",this);
      this._btnRemove.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._btnSwitchToBuy.addEventListener("click",this);
      this._btnTypes.addEventListener("over",this);
      this._btnTypes.addEventListener("out",this);
      this._btnFilterSell.addEventListener("click",this);
      this._btnFilterSell.addEventListener("over",this);
      this._btnFilterSell.addEventListener("out",this);
      this._lblKama.addEventListener("over",this);
      this._lblKama.addEventListener("out",this);
      this._lblKama.enableOverEvents = true;
      this._tiPrice.addEventListener("change",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
         this._oData.addEventListener("modelChanged2",this);
      }
      else
      {
         ank.utils.Logger.err("[PlayerShop] il n\'y a pas de data");
      }
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initTexts()
   {
      this._btnAdd.label = this.api.lang.getText("PUT_ON_SELL");
      this.refreshRemoveButton();
      this._btnSwitchToBuy.label = this.api.lang.getText("BIGSTORE_MODE_BUY");
      this._lblQuantity.text = this.api.lang.getText("SET_QUANTITY") + " :";
      this._lblPrice.text = this.api.lang.getText("SET_PRICE") + " :";
      this._lblFilterSell.text = this.api.lang.getText("BIGSTORE_FILTER");
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winInventory2.title = this.api.lang.getText("SHOP_STOCK");
   }
   function populateComboBox(nQuantity)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      if(nQuantity >= this._oData.quantity1)
      {
         _loc3_.push({label:"x" + this._oData.quantity1,index:1});
      }
      if(nQuantity >= this._oData.quantity2)
      {
         _loc3_.push({label:"x" + this._oData.quantity2,index:2});
      }
      if(nQuantity >= this._oData.quantity3)
      {
         _loc3_.push({label:"x" + this._oData.quantity3,index:3});
      }
      this._cbQuantity.dataProvider = _loc3_;
   }
   function initData()
   {
      this.enableFilter(this.api.kernel.OptionsManager.getOption("BigStoreSellFilter"));
      this._livInventory.dataProvider = this.api.datacenter.Player.Inventory;
      this._livInventory.kamasProvider = this.api.datacenter.Player;
      var _loc2_ = this._oData.inventory;
      this._livInventory2.dataProvider = _loc2_;
      this.updateItemCount();
   }
   function enableFilter(bEnable)
   {
      var _loc3_ = this._livInventory.currentFilterID == dofus.Constants.FILTER_ID_CEREMONIAL;
      var _loc4_ = this._livInventory.currentFilterID == dofus.Constants.FILTER_ID_EQUIPEMENT;
      var _loc5_;
      if(bEnable)
      {
         _loc5_ = [];
         for(var i in this._oData.typesObj)
         {
            _loc5_.push(i);
         }
         this._livInventory.customInventoryFilter = new dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter(Number(this._oData.maxLevel),_loc5_,_loc3_,_loc4_);
      }
      else if(_loc3_)
      {
         this._livInventory.customInventoryFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
      }
      else if(_loc4_)
      {
         this._livInventory.customInventoryFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
      }
      else
      {
         this._livInventory.customInventoryFilter = undefined;
      }
      this._btnFilterSell.selected = bEnable;
      this.api.kernel.OptionsManager.setOption("BigStoreSellFilter",bEnable);
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
      this._srBottom._visible = !bHide;
      this._mcPricesGrid._visible = !bHide;
      this._mcPrice._visible = !bHide;
      this._mcKamaSymbol._visible = !bHide;
      this._lblQuantity._visible = !bHide;
      this._lblQuantityValue._visible = !bHide;
      this._lblPrice._visible = !bHide;
      this._lblTaxTime._visible = !bHide;
      this._lblTaxTimeValue._visible = !bHide;
      this._cbQuantity._visible = !bHide;
      this._tiPrice._visible = !bHide;
      this._mcMiddlePrice._visible = !bHide;
      this._lblMiddlePrice._visible = !bHide;
   }
   function emptyPricesGrid()
   {
      this._mcPricesGrid._dgPrices.dataProvider = new ank.utils.ExtendedArray();
   }
   function setAddMode(bActive)
   {
      this._btnAdd._visible = bActive;
      this._mcSellArrow._visible = bActive;
      this._mcPrice._visible = bActive;
      this._mcMask._visible = false;
      this._cbQuantity._visible = bActive;
      this._lblQuantityValue._visible = false;
      this._tiPrice.tabIndex = 0;
      this._tiPrice.enabled = bActive;
      this._oDefaultButton = this._btnAdd;
      this._mcKamaSymbol._visible = bActive;
      this._lblTaxTime.text = this.api.lang.getText("BIGSTORE_TAX") + " :";
      if(this._lblTaxTimeValue.text != undefined)
      {
         this._lblTaxTimeValue.text = "";
      }
      if(this._txtBadItem.text != undefined)
      {
         this._txtBadItem.text = "";
      }
      this._lblTaxTime._visible = bActive;
      this._lblQuantity._visible = bActive;
      this._lblPrice._visible = bActive;
      this._srBottom._visible = bActive;
      this._lblTaxTimeValue._visible = bActive;
      this._tiPrice._visible = bActive;
   }
   function setRemoveMode(bActive)
   {
      this._mcBuyArrow._visible = bActive;
      this._mcPrice._visible = false;
      this._mcMask._visible = false;
      this._cbQuantity._visible = false;
      this._lblQuantityValue._visible = bActive;
      this._tiPrice.tabIndex = 0;
      this._tiPrice.enabled = !bActive;
      this._oDefaultButton = this._btnRemove;
      this._mcKamaSymbol._visible = false;
      this._lblTaxTime.text = this.api.lang.getText("BIGSTORE_TIME") + " :";
      if(this._lblTaxTimeValue.text != undefined)
      {
         this._lblTaxTimeValue.text = "";
      }
      if(this._txtBadItem.text != undefined)
      {
         this._txtBadItem.text = "";
      }
      this._lblTaxTime._visible = bActive;
      this._lblQuantity._visible = bActive;
      this._lblPrice._visible = bActive;
      this._srBottom._visible = bActive;
      this._lblTaxTimeValue._visible = bActive;
      this._tiPrice._visible = bActive;
   }
   function canItemBeSold(oItem)
   {
      var _loc3_ = oItem._bIsSkineable;
      if(!this._oData.typesObj[_loc3_] || oItem.isAssociateWithLivingItem)
      {
         this._sReason = this.api.lang.getText("BIGSTORE_BAD_TYPE");
         return false;
      }
      if(oItem.level > this._oData.maxLevel)
      {
         this._sReason = this.api.lang.getText("BIGSTORE_BAD_LEVEL");
         return false;
      }
      if(!oItem.canBeExchange)
      {
         this._sReason = this.api.lang.getText("ITEM_LINKED_CANT_SELL");
         return false;
      }
      return true;
   }
   function setBadItemMode(sMessage)
   {
      this._mcBuyArrow._visible = false;
      this._mcPrice._visible = false;
      this._mcMask._visible = true;
      this._cbQuantity._visible = false;
      this._lblQuantityValue._visible = false;
      this._tiPrice.tabIndex = 0;
      this._tiPrice.enabled = false;
      this._oDefaultButton = undefined;
      this._mcKamaSymbol._visible = false;
      this._txtBadItem.text = sMessage;
      this._lblTaxTime._visible = false;
      this._lblQuantity._visible = false;
      this._lblPrice._visible = false;
      this._srBottom._visible = false;
      this._lblTaxTimeValue._visible = false;
      this._tiPrice._visible = false;
      this.refreshRemoveButton();
   }
   function remove(aSelectedItems)
   {
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < aSelectedItems.length)
      {
         _loc5_ = aSelectedItems[_loc4_];
         _loc3_.push({Add:false,ID:_loc5_.ID,Quantity:_loc5_.Quantity});
         _loc4_ = _loc4_ + 1;
      }
      this.api.network.Exchange.movementItems(_loc3_);
   }
   function calculateTax()
   {
      if(this._oData.tax == 0)
      {
         this._lblTaxTimeValue.text = "0";
         return undefined;
      }
      var _loc2_ = _global.parseInt(this._tiPrice.text,10);
      var _loc3_ = Math.max(1,Math.round(_loc2_ * this._oData.tax / 100));
      this._lblTaxTimeValue.text = new ank.utils.ExtendedString(!_global.isNaN(_loc3_) ? _loc3_ : 0).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function updateItemCount()
   {
      this._winInventory2.title = this.api.lang.getText("SHOP_STOCK") + " (" + this._oData.inventory.length + "/" + this._oData.maxItemCount + ")";
   }
   function updateTotalKamas(oEvent_)
   {
      this._nTotalKamasSelling = 0;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < oEvent_.value.length)
      {
         _loc4_ = oEvent_.value[_loc3_];
         this._nTotalKamasSelling += _loc4_.price;
         _loc3_ = _loc3_ + 1;
      }
      this._lblKama.text = new ank.utils.ExtendedString(this._nTotalKamasSelling).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function askSell(oItem, nQuantityIndex, nPrice)
   {
      var _loc5_ = this._oData["quantity" + nQuantityIndex];
      var _loc6_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoSell",{title:this.api.lang.getText("BIGSTORE"),text:this.api.lang.getText("DO_U_SELL_ITEM_BIGSTORE_WITH_TAXES",["x" + _loc5_ + " " + oItem.name,new ank.utils.ExtendedString(nPrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3),this._lblTaxTimeValue.text]),params:{item:oItem,itemQuantity:oItem.Quantity,quantity:_loc5_,quantityIndex:nQuantityIndex,price:nPrice}});
      _loc6_.addEventListener("yes",this);
   }
   function askMiddlePrice(oItem)
   {
      this.api.network.Exchange.getItemMiddlePriceInBigStore(oItem.unicID);
   }
   function refreshRemoveButton(nTargets)
   {
      if(nTargets == undefined)
      {
         nTargets = this._livInventory2.lstInventory.getSelectedItems().length;
      }
      if(this._sRemoveText == undefined)
      {
         this._sRemoveText = this.api.lang.getText("REMOVE");
      }
      this._btnRemove.enabled = nTargets != undefined && (nTargets == 0 && (this._oSelectedItem != undefined && this._mcBuyArrow._visible) || nTargets > 0);
      if(nTargets == undefined || nTargets <= 1)
      {
         this._btnRemove.label = this._sRemoveText;
      }
      else
      {
         this._btnRemove.label = this._sRemoveText + " (" + nTargets + ")";
      }
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG" && this._oSelectedItem != undefined)
      {
         this.click({target:this._oDefaultButton});
         return false;
      }
      return true;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(oEvent.target)
      {
         case this._btnRemove:
            _loc3_ = this._livInventory2.lstInventory.getSelectedItems();
            if(!(_loc3_.length == 0 && this._oSelectedItem == undefined))
            {
               if(_loc3_.length == 0)
               {
                  _loc3_.push(this._oSelectedItem);
               }
               this.remove(_loc3_);
               this.hideItemViewer(true);
               this.setRemoveMode(false);
               this._btnAdd._visible = false;
            }
            break;
         case this._btnAdd:
            _loc4_ = _global.parseInt(this._tiPrice.text,10);
            org.flashdevelop.utils.FlashConnect.trace(_loc4_,"dofus.graphics.gapi.ui.BigStoreSell::click","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/graphics/gapi/ui/BigStoreSell.as",575);
            _loc5_ = Number(this._cbQuantity.selectedItem.index);
            if(_global.isNaN(_loc4_) || _loc4_ == 0)
            {
               this.gapi.loadUIComponent("AskOk","AksOkBadPrice",{title:this.api.lang.getText("ERROR_WORD"),text:this.api.lang.getText("ERROR_INVALID_PRICE")});
            }
            else if(_global.isNaN(_loc5_) || _loc5_ == 0)
            {
               this.gapi.loadUIComponent("AskOk","AksOkBadQuantity",{title:this.api.lang.getText("ERROR_WORD"),text:this.api.lang.getText("ERROR_INVALID_QUANTITY")});
            }
            else
            {
               this.askSell(this._oSelectedItem,_loc5_,_loc4_);
            }
            break;
         case this._btnClose:
            this.callClose();
            break;
         case this._btnSwitchToBuy:
            this.api.network.Exchange.request(11,this._oData.npcID);
            break;
         case this._btnFilterSell:
            this.enableFilter(this._btnFilterSell.selected);
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnTypes:
            _loc3_ = this.api.lang.getText("BIGSTORE_MAX_LEVEL") + " : " + this._oData.maxLevel;
            _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_TAX") + " : " + this._oData.tax + "%";
            _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_MAX_ITEM_PER_ACCOUNT") + " : " + this._oData.maxItemCount;
            _loc3_ += "\n" + this.api.lang.getText("BIGSTORE_MAX_SELL_TIME") + " : " + this._oData.maxSellTime + " " + ank.utils.PatternDecoder.combine(this.api.lang.getText("HOURS"),"m",this._oData.maxSellTime < 2);
            _loc3_ += "\n\n" + this.api.lang.getText("BIGSTORE_GAIN_SLOT");
            _loc3_ += "\n\n" + this.api.lang.getText("BIGSTORE_TYPES") + " :";
            _loc4_ = this._oData.types;
            for(var k in _loc4_)
            {
               _loc3_ += "\n - " + this.api.lang.getItemTypeText(_loc4_[k]).n;
            }
            break;
            this.gapi.showTooltip(_loc3_);
         case this._btnFilterSell:
            this.gapi.showTooltip(this.api.lang.getText("BIGSTORE_SELL_FILTER_OVER"));
            break;
         case this._lblKama:
            this.gapi.showTooltip(this.api.lang.getText("BIGSTORE_SELL_TOTAL"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function rollOverItem(oEvent)
   {
      var _loc3_ = oEvent.targets.length;
      this.refreshRemoveButton(_loc3_);
   }
   function rollOutItem(oEvent)
   {
      var _loc3_ = oEvent.targets.length;
      this.refreshRemoveButton(_loc3_);
   }
   function selectedItem(oEvent)
   {
      var _loc3_;
      var _loc4_;
      if(oEvent.item == undefined)
      {
         this.hideItemViewer(true);
         this.setAddMode(false);
         this.setRemoveMode(false);
      }
      else
      {
         this._itvItemViewer.itemData = oEvent.item;
         this.hideItemViewer(false);
         this.populateComboBox(oEvent.item.Quantity);
         this._bFullSoul = dofus.datacenter.Item.isFullSoul(oEvent.item.type);
         if(this.canItemBeSold(oEvent.item))
         {
            _loc3_ = oEvent.item.unicID != this._oSelectedItem.unicID;
            switch(oEvent.target)
            {
               case this._livInventory:
                  if(this._nQuantityIndex != undefined && (this._cbQuantity.dataProvider.length >= this._nQuantityIndex && !_loc3_))
                  {
                     this._cbQuantity.selectedIndex = this._nQuantityIndex - 1;
                  }
                  else
                  {
                     this._nQuantityIndex = undefined;
                     this._cbQuantity.selectedIndex = 0;
                  }
                  this.setRemoveMode(false);
                  this.setAddMode(true);
                  if(!_global.isNaN(this._nLastPrice) && !_loc3_)
                  {
                     this._tiPrice.text = String(this._nLastPrice);
                  }
                  else
                  {
                     this._tiPrice.text = "";
                  }
                  if(_loc3_)
                  {
                     this._mcPricesGrid.resetDatagridScrollbar();
                  }
                  this._livInventory2.setFilter(this._livInventory.currentFilterID);
                  this._tiPrice.setFocus();
                  this.refreshRemoveButton();
                  break;
               case this._livInventory2:
                  this._lblQuantityValue.text = "x" + String(oEvent.item.Quantity);
                  this.setAddMode(false);
                  this.setRemoveMode(true);
                  this._tiPrice.text = oEvent.item.price;
                  this._livInventory.setFilter(this._livInventory2.currentFilterID);
                  this._lblTaxTimeValue.text = oEvent.item.remainingHours + "h";
                  _loc4_ = oEvent.targets.length;
                  this.refreshRemoveButton(_loc4_);
                  if(_loc3_)
                  {
                     this._mcPricesGrid.resetDatagridScrollbar();
                  }
            }
            if(!this._bFullSoul)
            {
               if(oEvent.item.unicID != this._oSelectedItem.unicID)
               {
                  this._mcPricesGrid.updateItem(oEvent.item,true);
                  this.askMiddlePrice(oEvent.item);
               }
            }
            else
            {
               this._mcPricesGrid.updateItem(oEvent.item,true,true);
               this.setMiddlePrice(oEvent.item.unicID,-2);
            }
            this._oSelectedItem = oEvent.item;
         }
         else
         {
            this.setAddMode(false);
            this.setRemoveMode(false);
            this.emptyPricesGrid();
            this.setBadItemMode(this._sReason);
         }
      }
   }
   function modelChanged(oEvent)
   {
      this._livInventory2.dataProvider = this._oData.inventory;
      this.updateItemCount();
      this.updateTotalKamas();
   }
   function change(oEvent)
   {
      if(this._btnAdd._visible)
      {
         this._nLastPrice = _global.parseInt(this._tiPrice.text,10);
         this.calculateTax();
      }
   }
   function yes(oEvent)
   {
      this._nQuantityIndex = oEvent.target.params.quantityIndex;
      this.api.network.Exchange.movementItem(true,oEvent.target.params.item,oEvent.target.params.quantityIndex,oEvent.target.params.price);
      if(oEvent.target.params.itemQuantity - oEvent.target.params.quantity < oEvent.target.params.quantity)
      {
         this.setAddMode(false);
         this.hideItemViewer(true);
      }
      else
      {
         this.populateComboBox(oEvent.target.params.itemQuantity - oEvent.target.params.quantity);
      }
   }
   function filterChanged(oEvent_)
   {
      this.enableFilter(this._btnFilterSell.selected);
   }
}
