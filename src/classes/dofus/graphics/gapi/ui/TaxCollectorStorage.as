class dofus.graphics.gapi.ui.TaxCollectorStorage extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnGetAll;
   var _btnGetItem;
   var _itvItemViewer;
   var _ldrArtwork;
   var _livInventory;
   var _livInventory2;
   var _mcBuyArrow;
   var _oData;
   var _oSelectedItem;
   var _sGetItemText;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "TaxCollectorStorage";
   function TaxCollectorStorage()
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
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.TaxCollectorStorage.CLASS_NAME);
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
      this.setGetItemMode(false);
   }
   function addListeners()
   {
      this._livInventory.addEventListener("selectedItem",this);
      this._livInventory2.addEventListener("selectedItem",this);
      this._livInventory2.addEventListener("rollOverItem",this);
      this._livInventory2.addEventListener("rollOutItem",this);
      this._livInventory2.lstInventory.multipleSelection = true;
      this._btnGetItem.addEventListener("click",this);
      this._btnGetAll.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
      }
      else
      {
         ank.utils.Logger.err("[TaxCollectorShop] il n\'y a pas de data");
      }
   }
   function initTexts()
   {
      this.refreshGetItemButton();
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winInventory2.title = this._oData.name;
      this._btnGetAll.label = this.api.lang.getText("TRANSFERT_ALL");
   }
   function initData()
   {
      this._livInventory.dataProvider = this.api.datacenter.Player.Inventory;
      this._ldrArtwork.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + this._oData.gfx + ".swf";
      this.modelChanged();
   }
   function refreshGetItemButton(nTargets)
   {
      if(nTargets == undefined)
      {
         nTargets = this._livInventory2.lstInventory.getSelectedItems().length;
      }
      if(this._sGetItemText == undefined)
      {
         this._sGetItemText = this.api.lang.getText("GET_ITEM");
      }
      this._btnGetItem.enabled = nTargets != undefined && (nTargets <= 1 && (this._oSelectedItem != undefined && this._mcBuyArrow._visible) || nTargets > 1);
      if(nTargets == undefined || nTargets <= 1)
      {
         this._btnGetItem.label = this._sGetItemText;
      }
      else
      {
         this._btnGetItem.label = this._sGetItemText + " (" + nTargets + ")";
      }
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
   function setGetItemMode(bActive)
   {
      this._mcBuyArrow._visible = bActive;
   }
   function askQuantity(nQuantity, oParams)
   {
      var _loc4_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:nQuantity,max:nQuantity,params:oParams});
      _loc4_.addEventListener("validate",this);
   }
   function validateGetItems(aSelectedItems)
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
      this.hideItemViewer(true);
      this.setGetItemMode(false);
   }
   function validateGetItem(nQuantity)
   {
      if(nQuantity <= 0)
      {
         return undefined;
      }
      nQuantity = Math.min(this._oSelectedItem.Quantity,nQuantity);
      this.api.network.Exchange.movementItem(false,this._oSelectedItem,nQuantity);
      this.hideItemViewer(true);
      this.setGetItemMode(false);
   }
   function modelChanged(oEvent)
   {
      this._livInventory2.dataProvider = this._oData.inventory;
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_btnGetItem":
            _loc3_ = this._livInventory2.lstInventory.getSelectedItems();
            if(_loc3_.length > 1)
            {
               this.validateGetItems(_loc3_);
            }
            else if(this._oSelectedItem != undefined)
            {
               if(this._oSelectedItem.Quantity > 1)
               {
                  this.askQuantity(this._oSelectedItem.Quantity);
               }
               else
               {
                  this.validateGetItem(1);
               }
            }
            break;
         case "_btnGetAll":
            this.api.network.Exchange.transferAll("");
            break;
         case "_btnClose":
            this.callClose();
         default:
            return;
      }
   }
   function rollOverItem(oEvent)
   {
      var _loc3_ = oEvent.targets.length;
      this.refreshGetItemButton(_loc3_);
   }
   function rollOutItem(oEvent)
   {
      var _loc3_ = oEvent.targets.length;
      this.refreshGetItemButton(_loc3_);
   }
   function selectedItem(oEvent)
   {
      var _loc3_;
      if(oEvent.item == undefined)
      {
         this.hideItemViewer(true);
         this.setGetItemMode(false);
      }
      else
      {
         this._oSelectedItem = oEvent.item;
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.item;
         switch(oEvent.target._name)
         {
            case "_livInventory":
               this.setGetItemMode(false);
               this._livInventory2.setFilter(this._livInventory.currentFilterID);
               this.refreshGetItemButton();
               break;
            case "_livInventory2":
               this.setGetItemMode(true);
               this._livInventory.setFilter(this._livInventory2.currentFilterID);
               _loc3_ = oEvent.targets.length;
               this.refreshGetItemButton(_loc3_);
            default:
               return;
         }
      }
   }
   function validate(oEvent)
   {
      this.validateGetItem(oEvent.value);
   }
}
