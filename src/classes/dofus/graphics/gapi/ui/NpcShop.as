class dofus.graphics.gapi.ui.NpcShop extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnBuy;
   var _btnClose;
   var _btnSell;
   var _colors;
   var _itvItemViewer;
   var _ldrArtwork;
   var _livInventory;
   var _livInventory2;
   var _mcBuyArrow;
   var _mcSellArrow;
   var _oData;
   var _oDefaultButton;
   var _oSelectedItem;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   var api;
   var gapi;
   static var CLASS_NAME = "NpcShop";
   var _bIsCurrencyKamas = true;
   function NpcShop()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function set colors(aColors)
   {
      this._colors = aColors;
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
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.NpcShop.CLASS_NAME);
      this.gapi.getUIComponent("Banner").chatAutoFocus = false;
   }
   function destroy()
   {
      this.gapi.getUIComponent("Banner").chatAutoFocus = true;
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.hideItemViewer(true);
      this.setSellMode(false);
      this.setBuyMode(false);
      this.gapi.unloadLastUIAutoHideComponent();
   }
   function addListeners()
   {
      this._livInventory.addEventListener("selectedItem",this);
      this._livInventory2.addEventListener("selectedItem",this);
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
      this._btnSell.addEventListener("click",this);
      this._btnBuy.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._ldrArtwork.addEventListener("complete",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
      }
      else
      {
         ank.utils.Logger.err("[NpcShop] il n\'y a pas de data");
      }
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initTexts()
   {
      this._btnSell.label = this.api.lang.getText("SELL");
      this._btnBuy.label = this.api.lang.getText("BUY");
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winInventory2.title = this._oData.name;
   }
   function initData()
   {
      this._livInventory.dataProvider = this.api.datacenter.Player.Inventory;
      this._livInventory.kamasProvider = this.api.datacenter.Player;
      this._ldrArtwork.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + this._oData.gfx + ".swf";
      this.modelChanged();
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
      if(bHide)
      {
         this._oSelectedItem = undefined;
      }
   }
   function setSellMode(bActive)
   {
      this._btnSell._visible = bActive;
      this._mcSellArrow._visible = bActive;
   }
   function setBuyMode(bActive)
   {
      this._btnBuy._visible = bActive;
      this._mcBuyArrow._visible = bActive;
   }
   function getPlayerMoneyAmount()
   {
      if(this._oSelectedItem.hasCustomMoneyItemId)
      {
         return this.api.datacenter.Player.getInventoryItemQuantityByUnicID(this._oSelectedItem.customMoneyItemId);
      }
      return this.api.datacenter.Player.Kama;
   }
   function askQuantity(sType, nQty, nPrice, nWeight)
   {
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      if(sType == "buy")
      {
         _loc5_ = Math.floor(this.getPlayerMoneyAmount() / nPrice);
         if(_loc5_ < 1)
         {
            this.gapi.loadUIComponent("AskOk","AskOkRich",{title:this.api.lang.getText("ERROR_WORD"),text:this.getNotEnoughMoneyText()});
            return undefined;
         }
         if(nWeight != undefined)
         {
            _loc6_ = this.api.datacenter.Player.maxWeight - this.api.datacenter.Player.currentWeight;
            _loc7_ = Math.floor(_loc6_ / nWeight);
            if(_loc5_ > _loc7_)
            {
               _loc5_ = _loc7_;
            }
         }
         if(_loc5_ < 1)
         {
            this.gapi.loadUIComponent("AskOk","AskOkRich",{title:this.api.lang.getText("ERROR_WORD"),text:this.api.lang.getText("INVENTORY_FULL")});
            return undefined;
         }
      }
      else
      {
         _loc5_ = nQty;
      }
      var api = this.api;
      var _loc8_ = "POPUP_QUANTITY_NPC_SHOP";
      var sMoney = !this._oSelectedItem.hasCustomMoneyItemId ? " " + api.lang.getText("KAMAS") : "x " + new dofus.datacenter.Item(0,this._oSelectedItem.customMoneyItemId).name;
      var _loc9_ = [function(nMin, nMax, nValue_)
      {
         var _loc5_ = nValue_ * nPrice;
         var _loc6_ = new ank.utils.ExtendedString(_loc5_).addMiddleChar(api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         _loc6_ += sMoney;
         return _loc6_;
      }];
      var _loc10_ = this.gapi.loadUIComponent("PopupQuantityWithDescription","PopupQuantity",{descriptionLangKey:_loc8_,descriptionLangKeyParams:_loc9_,value:1,max:_loc5_,min:1,isMaxButtonValidationEnabled:sType == "sell",params:{type:sType}});
      _loc10_.addEventListener("validate",this);
   }
   function validateBuy(nQuantity)
   {
      if(nQuantity <= 0)
      {
         return undefined;
      }
      if(this.getPlayerMoneyAmount() < this._oSelectedItem.price * nQuantity)
      {
         this.gapi.loadUIComponent("AskOk","AskOkRich",{title:this.api.lang.getText("ERROR_WORD"),text:this.getNotEnoughMoneyText()});
         return undefined;
      }
      this.api.network.Exchange.buy(this._oSelectedItem.unicID,nQuantity);
   }
   function validateSell(nQuantity)
   {
      if(nQuantity <= 0)
      {
         return undefined;
      }
      var _loc3_;
      if(!this._oSelectedItem.canBeExchange || this._oSelectedItem.isLock)
      {
         _loc3_ = this.api.lang.getText("CANT_BUY");
         this.gapi.loadUIComponent("AskOk","AskOkRich",{title:this.api.lang.getText("ERROR_WORD"),text:_loc3_});
         return undefined;
      }
      if(nQuantity > this._oSelectedItem.Quantity)
      {
         nQuantity = this._oSelectedItem.Quantity;
      }
      this.api.network.Exchange.sell(this._oSelectedItem.ID,nQuantity);
      this._oSelectedItem._nQuantity -= nQuantity;
      if(this._oSelectedItem._nQuantity > 0)
      {
         return undefined;
      }
      this.hideItemViewer(true);
      this.setSellMode(false);
      this.setBuyMode(false);
   }
   function applyColor(mc, zone)
   {
      var _loc4_ = this._colors[zone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function getNotEnoughMoneyText()
   {
      var _loc3_;
      var _loc2_;
      if(this._oSelectedItem.hasCustomMoneyItemId)
      {
         _loc3_ = new dofus.datacenter.Item(0,this._oSelectedItem.customMoneyItemId);
         _loc2_ = this.api.lang.getText("NOT_ENOUGH_X",[_loc3_.name]);
      }
      else
      {
         _loc2_ = this.api.lang.getText("NOT_ENOUGH_RICH");
      }
      return _loc2_;
   }
   function showCurrencyAsCustom(bShow_)
   {
      this._bIsCurrencyKamas = !bShow_;
      var _loc3_;
      if(bShow_)
      {
         _loc3_ = new dofus.datacenter.Item(0,this._oSelectedItem.customMoneyItemId);
         this._livInventory._ldrMoneyIcon.contentParams = _loc3_.params;
         this._livInventory._ldrMoneyIcon.contentPath = _loc3_.iconFile;
         this._livInventory.kamaChanged({value:this.api.datacenter.Player.getInventoryItemQuantityByUnicID(this._oSelectedItem.customMoneyItemId)});
         this._livInventory.showKamasSymbol = false;
      }
      else if(this._livInventory._ldrMoneyIcon.contentPath != "")
      {
         this._livInventory._ldrMoneyIcon.contentParams = "";
         this._livInventory._ldrMoneyIcon.contentPath = "";
         this._livInventory.kamaChanged({value:this.api.datacenter.Player.Kama});
         this._livInventory.showKamasSymbol = true;
      }
   }
   function modelChanged(oEvent)
   {
      this._livInventory2.dataProvider = this._oData.inventory;
   }
   function click(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "_btnBuy":
            this.askQuantity("buy",1,this._oSelectedItem.price,this._oSelectedItem.weight);
            break;
         case "_btnSell":
            this.askQuantity("sell",this._oSelectedItem.Quantity,this._oSelectedItem.price);
            break;
         case "_btnClose":
            this.callClose();
         default:
            return;
      }
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG" && this._oSelectedItem != undefined)
      {
         this.click({target:this._oDefaultButton});
         return false;
      }
      this.gapi.getUIComponent("Banner").setChatFocus();
      return true;
   }
   function selectedItem(oEvent)
   {
      if(oEvent.item == undefined)
      {
         this.hideItemViewer(true);
         this.setSellMode(false);
         this.setBuyMode(false);
      }
      else
      {
         this._oSelectedItem = oEvent.item;
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.item;
         switch(oEvent.target._name)
         {
            case "_livInventory":
               this.setSellMode(true);
               this.setBuyMode(false);
               this._oDefaultButton = this._btnSell;
               this._livInventory2.setFilter(this._livInventory.currentFilterID);
               this.showCurrencyAsCustom(oEvent.item.hasCustomMoneyItemId);
               break;
            case "_livInventory2":
               this.setSellMode(false);
               this.setBuyMode(true);
               this._oDefaultButton = this._btnBuy;
               this._livInventory.setFilter(this._livInventory2.currentFilterID);
               this.showCurrencyAsCustom(oEvent.item.hasCustomMoneyItemId);
            default:
               return;
         }
      }
   }
   function validate(oEvent)
   {
      switch(oEvent.params.type)
      {
         case "sell":
            this.validateSell(oEvent.value);
            break;
         case "buy":
            this.validateBuy(oEvent.value);
         default:
            return;
      }
   }
   function complete(oEvent)
   {
      var ref = this;
      this._ldrArtwork.content.stringCourseColor = function(mc_, nColorIndex)
      {
         ref.applyColor(mc_,nColorIndex);
      };
   }
   function kamaChanged(oEvent_)
   {
      if(!this._bIsCurrencyKamas)
      {
         this._livInventory.kamaChanged({value:this.api.datacenter.Player.getInventoryItemQuantityByUnicID(this._oSelectedItem.customMoneyItemId)});
      }
      else
      {
         this._livInventory.kamaChanged({value:this.api.datacenter.Player.Kama});
      }
   }
}
