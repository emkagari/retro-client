class dofus.graphics.gapi.ui.Storage extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bMount;
   var _btnClose;
   var _itvItemViewer;
   var _ivInventoryViewer;
   var _ivInventoryViewer2;
   var _oData;
   var _pbPods;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   static var CLASS_NAME = "Storage";
   function Storage()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function set isMount(bMount)
   {
      this._bMount = bMount;
   }
   function get currentOverItem()
   {
      if(this._ivInventoryViewer != undefined && this._ivInventoryViewer.currentOverItem != undefined)
      {
         return this._ivInventoryViewer.currentOverItem;
      }
      if(this._ivInventoryViewer2 != undefined && this._ivInventoryViewer2.currentOverItem != undefined)
      {
         return this._ivInventoryViewer2.currentOverItem;
      }
      return undefined;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Storage.CLASS_NAME);
   }
   function callClose()
   {
      if(this._bMount == true)
      {
         this.api.ui.loadUIComponent("Mount","Mount");
      }
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      if(this._bMount != true)
      {
         this._pbPods._visible = false;
      }
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.hideItemViewer(true);
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._ivInventoryViewer.addEventListener("selectedItem",this);
      this._ivInventoryViewer.addEventListener("dblClickItem",this);
      this._ivInventoryViewer.addEventListener("dropItem",this);
      this._ivInventoryViewer.addEventListener("dragKama",this);
      this._ivInventoryViewer2.addEventListener("selectedItem",this);
      this._ivInventoryViewer2.addEventListener("dblClickItem",this);
      this._ivInventoryViewer2.addEventListener("dropItem",this);
      this._ivInventoryViewer2.addEventListener("dragKama",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
      }
      else
      {
         ank.utils.Logger.err("[Storage] il n\'y a pas de data");
      }
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      if(this._bMount != true)
      {
         this._winInventory2.title = this.api.lang.getText("STORAGE");
      }
      else
      {
         this._winInventory2.title = this.api.lang.getText("MY_MOUNT");
      }
   }
   function initData()
   {
      if(this._bMount == true)
      {
         this._ivInventoryViewer.showKamas = false;
         this._ivInventoryViewer2.showKamas = false;
      }
      this._ivInventoryViewer.dataProvider = this.api.datacenter.Player.Inventory;
      this._ivInventoryViewer.kamasProvider = this.api.datacenter.Player;
      this._ivInventoryViewer2.kamasProvider = this._oData;
      this._ivInventoryViewer.checkPlayerPods = true;
      this._ivInventoryViewer2.checkMountPods = this._bMount;
      this._ivInventoryViewer.canTransfer = true;
      this.modelChanged();
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
   }
   function click(oEvent)
   {
      var _loc0_;
      var _temp_1 = _loc0_ = oEvent.target;
      this.callClose();
      _temp_1;
   }
   function selectedItem(oEvent)
   {
      if(oEvent.item == undefined)
      {
         this.hideItemViewer(true);
      }
      else
      {
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.item;
         switch(oEvent.target._name)
         {
            case "_ivInventoryViewer":
               this._ivInventoryViewer2.setFilter(this._ivInventoryViewer.currentFilterID);
               break;
            case "_ivInventoryViewer2":
               this._ivInventoryViewer.setFilter(this._ivInventoryViewer2.currentFilterID);
            default:
               return;
         }
      }
   }
   function dblClickItem(oEvent)
   {
      var _loc3_ = oEvent.item;
      var _loc4_ = oEvent.targets;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY);
      switch(oEvent.target._name)
      {
         case "_ivInventoryViewer":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,true);
            }
            else
            {
               this.moveItem(_loc3_,true,_loc5_);
            }
            break;
         case "_ivInventoryViewer2":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,false);
            }
            else
            {
               this.moveItem(_loc3_,false,_loc5_);
            }
         default:
            return;
      }
   }
   function moveItems(aItems, bAdd)
   {
      if((bAdd && this._bMount || !bAdd) && !this.api.datacenter.Player.canReceiveItems(aItems,bAdd && this._bMount))
      {
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_6"),"ERROR_BOX",{name:undefined});
         return undefined;
      }
      var _loc4_ = [];
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < aItems.length)
      {
         _loc6_ = aItems[_loc5_];
         _loc4_.push({Add:bAdd,ID:_loc6_.ID,Quantity:_loc6_.Quantity});
         _loc5_ = _loc5_ + 1;
      }
      this.api.network.Exchange.movementItems(_loc4_);
   }
   function moveItem(oItem, bAdd, bMoveMultipleItems)
   {
      var _loc5_ = oItem.Quantity;
      if(bAdd && this._bMount || !bAdd)
      {
         _loc5_ = this.api.datacenter.Player.getPossibleItemReceiveQuantity(oItem,bAdd && this._bMount);
         if(_loc5_ <= 0)
         {
            this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_6"),"ERROR_BOX",{name:undefined});
            return undefined;
         }
      }
      var _loc6_ = 1;
      if(bMoveMultipleItems)
      {
         _loc6_ = _loc5_;
      }
      this.api.network.Exchange.movementItem(bAdd,oItem,_loc6_);
   }
   function modelChanged(oEvent)
   {
      this._ivInventoryViewer2.dataProvider = this._oData.inventory;
   }
   function dropItem(oEvent)
   {
      var _loc3_ = oEvent.item;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      switch(oEvent.target._name)
      {
         case "_ivInventoryViewer":
            this.api.network.Exchange.movementItem(false,_loc3_,oEvent.quantity);
            break;
         case "_ivInventoryViewer2":
            this.api.network.Exchange.movementItem(true,_loc3_,oEvent.quantity);
         default:
            return;
      }
   }
   function dragKama(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._ivInventoryViewer:
            _loc3_ = dofus.Constants.isIntAdditionOverFlow(oEvent.quantity,this._oData.Kama);
            if(_loc3_)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_70"),"ERROR_BOX");
               return undefined;
            }
            this.api.network.Exchange.movementKama(oEvent.quantity);
            break;
         case this._ivInventoryViewer2:
            _loc4_ = dofus.Constants.isIntAdditionOverFlow(oEvent.quantity,this.api.datacenter.Player.Kama);
            if(_loc4_)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_70"),"ERROR_BOX");
               return undefined;
            }
            this.api.network.Exchange.movementKama(- oEvent.quantity);
         default:
            return;
      }
   }
}
