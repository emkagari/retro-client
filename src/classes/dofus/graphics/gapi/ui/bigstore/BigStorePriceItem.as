class dofus.graphics.gapi.ui.bigstore.BigStorePriceItem extends ank.gapi.core.UIBasicComponent
{
   var _btnBuy;
   var _ldrIcon;
   var _mcList;
   var _mcRow;
   var _nSelectedSet;
   var _oBigStoreUI;
   var _oItem;
   var addToQueue;
   static var NUMBER_OF_PRICES = 3;
   function BigStorePriceItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function set row(mcRow)
   {
      this._mcRow = mcRow;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      delete this._nSelectedSet;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if(bUsed)
      {
         this._oItem = oItem;
         this._ldrIcon.forceReload = !oItem.item.isMonsterInBidHouse ? false : true;
         this._ldrIcon.contentParams = oItem.item.params;
         this._ldrIcon.contentPath = oItem.item.iconFile;
         _loc5_ = 1;
         while(_loc5_ <= dofus.graphics.gapi.ui.bigstore.BigStorePriceItem.NUMBER_OF_PRICES)
         {
            _loc6_ = this["_btnPriceSet" + _loc5_];
            _loc7_ = this["_mcMySale" + _loc5_];
            _loc8_ = oItem["priceSet" + _loc5_];
            _loc9_ = oItem["isMySale" + _loc5_];
            _loc10_ = this._oBigStoreUI._mcPricesGrid.isThisPriceSelected(oItem.id,_loc5_);
            if(_loc10_)
            {
               this._nSelectedSet = _loc5_;
               this._oBigStoreUI._mcPricesGrid.setButtons(_loc6_,this._btnBuy);
            }
            _loc6_.enabled = !_global.isNaN(_loc8_);
            _loc6_.selected = _loc10_;
            _loc6_.label = !_global.isNaN(_loc8_) ? new ank.utils.ExtendedString(_loc8_).addMiddleChar(this._mcList.gapi.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + "  " : "-  ";
            _loc6_._visible = true;
            _loc7_._visible = _loc9_;
            _loc5_ = _loc5_ + 1;
         }
         this._btnBuy._visible = true;
         this._btnBuy.enabled = this._nSelectedSet != undefined;
      }
      else if(this._ldrIcon.contentPath != undefined)
      {
         _loc11_ = 1;
         while(_loc11_ <= dofus.graphics.gapi.ui.bigstore.BigStorePriceItem.NUMBER_OF_PRICES)
         {
            _loc12_ = this["_btnPriceSet" + _loc11_];
            _loc13_ = this["_mcMySale" + _loc11_];
            _loc12_._visible = false;
            _loc13_._visible = false;
            _loc11_ = _loc11_ + 1;
         }
         this._btnBuy._visible = false;
         this._ldrIcon.contentPath = "";
      }
   }
   function init()
   {
      super.init(false);
      this._oBigStoreUI = this._mcList._parent._parent._parent;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      var _loc2_ = 1;
      var _loc3_;
      while(_loc2_ <= dofus.graphics.gapi.ui.bigstore.BigStorePriceItem.NUMBER_OF_PRICES)
      {
         _loc3_ = this["_btnPriceSet" + _loc2_];
         _loc3_.addEventListener("click",this);
         _loc2_ = _loc2_ + 1;
      }
      this._btnBuy.addEventListener("click",this);
   }
   function initTexts()
   {
      this._btnBuy.label = this._mcList.gapi.api.lang.getText("BUY");
   }
   function selectItem(bSelect, nIndex)
   {
      this._oBigStoreUI._mcPricesGrid.selectPrice(this._oItem,nIndex,this["_btnPriceSet" + nIndex],this._btnBuy);
      if(bSelect)
      {
         this._nSelectedSet = nIndex;
         this._mcRow.select();
         this._btnBuy.enabled = true;
      }
      else
      {
         delete this._nSelectedSet;
         this._btnBuy.enabled = false;
      }
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) !== this._btnBuy)
      {
         _loc3_ = Number(oEvent.target._name.substr(12));
         this.selectItem(oEvent.target.selected,_loc3_);
      }
      else
      {
         if(!this._nSelectedSet || _global.isNaN(this._nSelectedSet))
         {
            this._btnBuy.enabled = false;
            return undefined;
         }
         this._oBigStoreUI.askBuy(this._oItem.item,this._nSelectedSet,this._oItem["priceSet" + this._nSelectedSet]);
         this._oBigStoreUI.askMiddlePrice(this._oItem.item);
      }
   }
}
