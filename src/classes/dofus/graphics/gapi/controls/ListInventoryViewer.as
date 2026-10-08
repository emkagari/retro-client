class dofus.graphics.gapi.controls.ListInventoryViewer extends dofus.graphics.gapi.controls.InventoryViewerWithAllFilter
{
   var _cbTypes;
   var _currentOverRow;
   var _lblKama;
   var _lstInventory;
   var _mcKamaSymbol;
   var _mcLstPlacer;
   var _oDataViewer;
   var _oKamasProvider;
   var addToQueue;
   var api;
   var attachMovie;
   var dispatchEvent;
   var initialized;
   var kamaChanged;
   static var CLASS_NAME = "ListInventoryViewer";
   var _bDisplayKama = true;
   var _bDisplayPrices = true;
   function ListInventoryViewer()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverRow != undefined && this._currentOverRow.item != undefined)
      {
         return dofus.datacenter.Item(this._currentOverRow.item);
      }
      return undefined;
   }
   function get lstInventory()
   {
      return this._lstInventory;
   }
   function set displayKamas(bDisplayKama)
   {
      this._bDisplayKama = bDisplayKama;
      if(this.initialized)
      {
         this.showKamas(bDisplayKama);
      }
   }
   function set displayPrices(bDisplayPrices)
   {
      if(this.initialized)
      {
         ank.utils.Logger.err("[displayPrices] impossible après init");
         return;
      }
      this._bDisplayPrices = bDisplayPrices;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ListInventoryViewer.CLASS_NAME);
   }
   function createChildren()
   {
      var _loc3_ = !this._bDisplayPrices ? "ListInventoryViewerItemNoPrice" : "ListInventoryViewerItem";
      this.attachMovie("List","_lstInventory",10,{styleName:"LightBrownList",cellRenderer:_loc3_,rowHeight:20});
      this._lstInventory.move(this._mcLstPlacer._x,this._mcLstPlacer._y);
      this._lstInventory.setSize(this._mcLstPlacer._width,this._mcLstPlacer._height);
      this._oDataViewer = this._lstInventory;
      this.showKamas(this._bDisplayKama);
      this.addToQueue({object:this,method:this.addListeners});
      super.createChildren();
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      super.addListeners();
      this._lstInventory.addEventListener("itemSelected",this);
      this._lstInventory.addEventListener("itemdblClick",this);
      this._lstInventory.addEventListener("itemRollOver",this);
      this._lstInventory.addEventListener("itemRollOut",this);
   }
   function initTexts()
   {
      super.initTexts();
   }
   function initData()
   {
      this.kamaChanged({value:this._oKamasProvider.Kama});
   }
   function showKamas(bShow)
   {
      this._lblKama._visible = bShow;
      this._mcKamaSymbol._visible = bShow;
   }
   function set showKamasSymbol(bShow_)
   {
      this._mcKamaSymbol._visible = bShow_;
   }
   function itemSelected(oEvent)
   {
      super.itemSelected(oEvent);
      if(oEvent.target != this._cbTypes)
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.row.item != undefined)
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent.row.item);
            return undefined;
         }
         this.dispatchEvent({type:"selectedItem",item:oEvent.row.item,targets:oEvent.targets});
      }
   }
   function itemdblClick(oEvent)
   {
      this.dispatchEvent({type:"itemdblClick",item:oEvent.row.item,targets:oEvent.targets});
   }
   function itemRollOver(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      this._currentOverRow = oEvent.row;
      this.dispatchEvent({type:"rollOverItem",item:oEvent.row.item,targets:oEvent.targets});
   }
   function itemRollOut(oEvent)
   {
      this._currentOverRow = undefined;
      var _loc3_ = oEvent.row.item;
      this.dispatchEvent({type:"rollOutItem",item:oEvent.row.item,targets:oEvent.targets});
   }
}
