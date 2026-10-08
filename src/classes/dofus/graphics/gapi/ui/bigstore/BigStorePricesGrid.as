class dofus.graphics.gapi.ui.bigstore.BigStorePricesGrid extends ank.gapi.core.UIBasicComponent
{
   var _btnSelectedBuy;
   var _btnSelectedPrice;
   var _dgPrices;
   var _nSelectedPriceIndex;
   var _nSelectedPriceItemID;
   var _parent;
   var _sLastMonsterID;
   var addToQueue;
   var api;
   static var CLASS_NAME = "BigStorePricesGrid";
   function BigStorePricesGrid()
   {
      super();
   }
   function get hasSelected()
   {
      return this._nSelectedPriceItemID != null;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.bigstore.BigStorePricesGrid.CLASS_NAME);
      this.api = _global.API;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
      this.addToQueue({object:this,method:this.setQuantityHeader});
   }
   function addListeners()
   {
      this._dgPrices.addEventListener("itemSelected",this);
      this._parent._oData.addEventListener("modelChanged2",this);
   }
   function updateData()
   {
      this.modelChanged2();
   }
   function setQuantityHeader()
   {
      this._dgPrices.columnsNames = ["","x" + this._parent._oData.quantity1,"x" + this._parent._oData.quantity2,"x" + this._parent._oData.quantity3];
   }
   function deletePreviousSelection()
   {
      delete this._nSelectedPriceItemID;
      delete this._nSelectedPriceIndex;
      delete this._btnSelectedPrice;
      delete this._btnSelectedBuy;
   }
   function updateItem(oItem, bRefreshList, bIsMonster)
   {
      this._dgPrices.selectedIndex = -1;
      this.deletePreviousSelection();
      var _loc5_;
      var _loc6_;
      if(bRefreshList)
      {
         this.resetDatagridScrollbar();
         if(oItem != undefined)
         {
            if(bIsMonster)
            {
               _loc5_ = oItem.getMonsterList();
               _loc6_ = dofus.datacenter.Monster.getMonsterIDSoulPriority(_loc5_.split("|"));
               if(this._sLastMonsterID != _loc6_)
               {
                  this._sLastMonsterID = _loc6_;
                  this.api.network.Exchange.bigStoreSoulList(_loc5_);
               }
            }
            else
            {
               this.api.network.Exchange.bigStoreItemList(oItem.unicID);
            }
         }
         else
         {
            this._dgPrices.dataProvider = new ank.utils.ExtendedArray();
         }
      }
   }
   function setButtons(btnPrice, btnBuy)
   {
      this._btnSelectedPrice.selected = false;
      this._btnSelectedPrice = btnPrice;
      this._btnSelectedBuy.enabled = false;
      this._btnSelectedBuy = btnBuy;
   }
   function selectPrice(oItem, nQuantityIndex, btnPrice, btnBuy)
   {
      if(btnPrice != this._btnSelectedPrice)
      {
         this._nSelectedPriceItemID = oItem.id;
         this._nSelectedPriceIndex = nQuantityIndex;
         this.setButtons(btnPrice,btnBuy);
      }
      else
      {
         this.deletePreviousSelection();
      }
   }
   function isThisPriceSelected(nItemID, nQuantityIndex)
   {
      return nItemID == this._nSelectedPriceItemID && this._nSelectedPriceIndex == nQuantityIndex;
   }
   function modelChanged2(oEvent)
   {
      this.deletePreviousSelection();
      this._btnSelectedPrice.selected = false;
      this._btnSelectedBuy.enabled = false;
      var _loc3_ = this._parent._oData.inventory2;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(this._parent.isSimilarToPreviousBought(_loc5_))
         {
            this._nSelectedPriceItemID = this._parent.previousBoughtId;
            this._nSelectedPriceIndex = this._parent.previousBoughtQty;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._dgPrices.dataProvider = _loc3_;
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._dgPrices)
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.row.item.item != undefined)
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent.row.item.item);
            return undefined;
         }
         this._parent._itvItemViewer.itemData = oEvent.row.item.item;
         this._parent.toggleComponentsVisibility(4,false);
      }
   }
   function resetDatagridScrollbar()
   {
      this._dgPrices.setVPosition(0);
   }
}
