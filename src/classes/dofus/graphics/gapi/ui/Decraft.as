class dofus.graphics.gapi.ui.Decraft extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnRecycle;
   var _cgDistant;
   var _cgGrid;
   var _ctrPreview;
   var _eaDistantDataProvider;
   var _itvItemViewer;
   var _ivInventoryViewer;
   var _lblNbItemsToDestroy;
   var _lblNewObject;
   var _lblSkill;
   var _mcFiligrane;
   var _nMaxItem;
   var _nSkillId;
   var _oData;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "Decraft";
   function Decraft()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._ivInventoryViewer != undefined && this._ivInventoryViewer.currentOverItem != undefined)
      {
         return this._ivInventoryViewer.currentOverItem;
      }
      return undefined;
   }
   function set maxItem(nMaxItem)
   {
      this._nMaxItem = Number(nMaxItem);
   }
   function set skillId(nSkillId)
   {
      this._nSkillId = Number(nSkillId);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Decraft.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnRecycle.addEventListener("click",this);
      this._ivInventoryViewer.addEventListener("selectedItem",this);
      this._ivInventoryViewer.addEventListener("dblClickItem",this);
      this._ivInventoryViewer.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("dblClickItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgDistant.addEventListener("selectItem",this);
      this._eaDistantDataProvider.addEventListener("modelChanged",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
      }
      else
      {
         ank.utils.Logger.err("[Storage] il n\'y a pas de data");
      }
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winInventory2.title = this.api.lang.getText("MUNSTER_CUSHER");
      this._btnRecycle.label = this.api.lang.getText("VALIDATE");
      this._lblSkill.text = this.api.lang.getText("SKILL") + " : " + this.api.lang.getSkillText(this._nSkillId).d;
      this._lblNewObject.text = this.api.lang.getText("CRAFTED_ITEM");
      this._lblNbItemsToDestroy.text = this.api.lang.getText("MUNSTER_CRUSHER_CONTENT",[0,this._nMaxItem]);
   }
   function initData()
   {
      this._btnRecycle._visible = true;
      this._btnRecycle.enabled = false;
      this._ivInventoryViewer.showKamas = false;
      this._ivInventoryViewer.hideNonEquipementFilters();
      this._ivInventoryViewer.checkPlayerPods = false;
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.Player.Inventory;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         _loc2_.push(_loc5_.clone());
         _loc4_ = _loc4_ + 1;
      }
      this._ivInventoryViewer.dataProvider = _loc2_;
      var _loc6_ = new ank.utils.ExtendedArray();
      this._cgGrid.dataProvider = _loc6_;
      this.hideItemViewer(true);
      this._eaDistantDataProvider = this.api.datacenter.Exchange.distantGarbage;
      this._cgDistant.multipleContainerSelectionEnabled = false;
   }
   function doRecycle()
   {
      if(this._cgGrid.dataProvider.length == 0)
      {
         return undefined;
      }
      var _loc2_ = this._cgGrid.dataProvider;
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc2_.length)
      {
         _loc5_ = _loc2_[_loc4_];
         _loc3_.push({Add:true,ID:_loc5_.ID,Quantity:_loc5_.Quantity});
         _loc4_ = _loc4_ + 1;
      }
      this.api.network.Exchange.movementItems(_loc3_);
      this.api.network.Exchange.ready();
      this._cgGrid.dataProvider = new ank.utils.ExtendedArray();
      this._lblNbItemsToDestroy.text = this.api.lang.getText("MUNSTER_CRUSHER_CONTENT",[0,this._nMaxItem]);
   }
   function updateForgemagusResult(oItem)
   {
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
   }
   function itemSelected(oItem)
   {
      if(oItem == undefined)
      {
         this.hideItemViewer(true);
      }
      else
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(oItem);
            return undefined;
         }
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oItem;
      }
   }
   function modelChanged(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._eaDistantDataProvider)
      {
         this._cgDistant.dataProvider = this._eaDistantDataProvider;
         this._mcFiligrane._visible = false;
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnRecycle:
            this.doRecycle();
            break;
         case this._btnClose:
            this.callClose();
         default:
            return;
      }
   }
   function dragItem(oEvent)
   {
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      this.gapi.setCursor(oEvent.target.contentData);
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
      switch(oEvent.owner._name)
      {
         case "_ivInventoryViewer":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,true);
            }
            else
            {
               this.moveItem(_loc3_,true,!Key.isDown(Key.CONTROL) ? 1 : _loc3_.Quantity);
            }
            break;
         case "_cgGrid":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,false);
            }
            else
            {
               this.moveItem(_loc3_,false,!Key.isDown(Key.CONTROL) ? 1 : _loc3_.Quantity);
            }
         default:
            return;
      }
   }
   function moveItems(aItems, bAddToWorkshop)
   {
      var _loc4_ = [];
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < aItems.length)
      {
         _loc6_ = aItems[_loc5_];
         this.moveItem(_loc6_,bAddToWorkshop,_loc6_.Quantity);
         _loc5_ = _loc5_ + 1;
      }
   }
   function moveItem(oItem, bAddToWorkshop, nQuantity)
   {
      if(nQuantity > oItem.Quantity)
      {
         nQuantity = oItem.Quantity;
      }
      if(nQuantity < 1)
      {
         return undefined;
      }
      var _loc5_ = this._ivInventoryViewer.dataProvider;
      var _loc6_ = this._cgGrid.dataProvider;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      if(bAddToWorkshop)
      {
         _loc7_ = _loc5_.findFirstItem("ID",oItem.ID);
         if(_loc7_.item != oItem || _loc7_.item.Quantity != oItem.Quantity)
         {
            return undefined;
         }
         if(oItem.isLock || (!oItem.canDestroy || (oItem.isCeremonial || !oItem.canBeExchange)))
         {
            return undefined;
         }
         _loc8_ = _loc6_.findFirstItem("ID",oItem.ID);
         if(_loc8_.item != undefined)
         {
            _loc8_.item.Quantity += nQuantity;
            _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc6_.updateItem(_loc8_.index,_loc8_.item);
         }
         else
         {
            if(_loc6_.length >= this._nMaxItem)
            {
               return undefined;
            }
            _loc9_ = new dofus.datacenter.Item(oItem.ID,oItem.unicID,nQuantity,-2,oItem.compressedEffects);
            _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc6_.push(_loc9_);
         }
         oItem.Quantity -= nQuantity;
         if(oItem.Quantity < 1)
         {
            _loc5_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc5_.removeItems(_loc7_.index,1);
         }
         else
         {
            _loc5_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc5_.updateItem(_loc7_.index,oItem);
         }
      }
      else
      {
         _loc10_ = _loc6_.findFirstItem("ID",oItem.ID);
         if(_loc10_.item != oItem || _loc10_.item.Quantity != oItem.Quantity)
         {
            return undefined;
         }
         _loc11_ = _loc5_.findFirstItem("ID",oItem.ID);
         if(_loc11_.item != undefined)
         {
            _loc11_.item.Quantity += nQuantity;
            _loc5_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc5_.updateItem(_loc11_.index,_loc11_.item);
         }
         else
         {
            _loc12_ = new dofus.datacenter.Item(oItem.ID,oItem.unicID,nQuantity,-1,oItem.compressedEffects);
            _loc5_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc5_.push(_loc12_);
         }
         oItem.Quantity -= nQuantity;
         if(oItem.Quantity < 1)
         {
            _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc6_.removeItems(_loc10_.index,1);
         }
         else
         {
            _loc6_.startNoEventDispatchsPeriod(dofus.Constants.DELAYED_INVENTORY_ITEMS_VISUAL_REFRESH);
            _loc6_.updateItem(_loc10_.index,oItem);
         }
      }
      this._btnRecycle.enabled = _loc6_.length > 0;
      this._mcFiligrane._visible = true;
      this._ctrPreview.contentPath = _loc6_.length <= 0 ? "" : dofus.Constants.ITEMS_PATH + "88/44.swf";
      this._lblNbItemsToDestroy.text = this.api.lang.getText("MUNSTER_CRUSHER_CONTENT",[_loc6_.length,this._nMaxItem]);
   }
   function dropItem(oEvent)
   {
      var _loc3_ = oEvent.item == undefined ? this.gapi.getCursor() : oEvent.item;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc4_;
      var _loc5_;
      var _loc0_;
      if(oEvent.item != undefined)
      {
         this.moveItem(dofus.datacenter.Item(_loc3_),false,oEvent.quantity);
      }
      else
      {
         _loc4_ = _loc3_.Quantity;
         if(_loc4_ <= 0)
         {
            this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_6"),"ERROR_BOX",{name:undefined});
         }
         else if(_loc4_ > 1)
         {
            _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc4_,params:{ownerMc:oEvent.owner,targetType:"item",oItem:_loc3_}});
            _loc5_.addEventListener("validate",this);
         }
         else if((_loc0_ = oEvent.owner._name) === "_cgGrid")
         {
            this.moveItem(dofus.datacenter.Item(_loc3_),true,_loc4_);
         }
      }
   }
   function validate(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.params.targetType) === "item")
      {
         if((_loc0_ = oEvent.params.ownerMc._name) === "_cgGrid")
         {
            this.moveItem(oEvent.params.oItem,true,oEvent.value);
         }
      }
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      var _loc0_;
      if((_loc0_ = sShortcut) === "MERGE_RUNE")
      {
         this.doRecycle();
         _loc3_ = false;
      }
      return _loc3_;
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      _loc3_.showStatsTooltip(oEvent.target.contentData.style);
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function selectedItem(oEvent)
   {
      this.itemSelected(oEvent.item);
   }
   function selectItem(oEvent)
   {
      this.itemSelected(oEvent.target.contentData);
   }
}
