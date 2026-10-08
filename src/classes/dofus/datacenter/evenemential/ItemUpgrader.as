class dofus.datacenter.evenemential.ItemUpgrader
{
   var _api;
   var _dataProvider;
   var _frag;
   var _item1;
   var _item2;
   var _itemMaster;
   var _nLastFragUid;
   var _relic;
   var _view;
   static var MASTER_INDEX = 0;
   static var RELIC_INDEX = 3;
   static var FRAGMENT_INDEX = 4;
   static var UPGRADE_MULTIPLICATOR = 100000;
   var aTierLabels = ["I","II","III","IV","V","VI","VII"];
   var aTierFragments = [20066,20067,20068,20069,20070,20071,20072];
   var aTierRelics = [20073,20074,20075,20076,20077,20078,20079,20080];
   function ItemUpgrader(oApi, oView)
   {
      this._api = oApi;
      this._view = oView;
      this._api.datacenter.Temporis.actualUpgradeRecipe = undefined;
      this._dataProvider = this._api.datacenter.Player.Inventory.deepClone();
   }
   function get dataProvider()
   {
      return this._dataProvider;
   }
   function get item1()
   {
      return this._item1;
   }
   function get item2()
   {
      return this._item2;
   }
   function get itemMaster()
   {
      return this._itemMaster;
   }
   function get frag()
   {
      return this._frag;
   }
   function get relic()
   {
      return this._relic;
   }
   function get resultPreview()
   {
      return dofus.datacenter.Item(this._api.datacenter.Temporis.actualUpgradeRecipe.preview);
   }
   function get nUpgradeLevel()
   {
      return this._itemMaster != undefined ? Math.floor(this._itemMaster.unicID / dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR) : -1;
   }
   function resetInventoryClone()
   {
      this._dataProvider = this._api.datacenter.Player.Inventory.deepClone();
      this._view.dataProvider = this._dataProvider;
   }
   function resetContainers(bRemove)
   {
      if(!bRemove)
      {
         this.restoreToInventory(this._itemMaster);
         this.restoreToInventory(this._item1);
         this.restoreToInventory(this._item2);
         this.restoreToInventory(this._relic);
         this.restoreToInventory(this._frag);
      }
      this._itemMaster = undefined;
      this._item1 = undefined;
      this._item2 = undefined;
      this._frag = undefined;
      this._relic = undefined;
      this._view.updateDataView();
   }
   function updateInfoFromMasterItem()
   {
      if(this.itemMaster == undefined)
      {
         this._api.datacenter.Temporis.actualUpgradeRecipe = undefined;
      }
      var _loc2_ = this.nUpgradeLevel;
      if(_loc2_ != 1)
      {
         if(this._relic != undefined)
         {
            this.restoreToInventory(this._relic);
            this._relic = undefined;
         }
      }
      if(this._item1 != undefined && this._item1.unicID != this._itemMaster.unicID)
      {
         this.restoreToInventory(dofus.datacenter.Item(this._item1));
         this._item1 = undefined;
      }
      if(this._item2 != undefined && this._item2.unicID != this._itemMaster.unicID)
      {
         this.restoreToInventory(this._item2);
         this._item2 = undefined;
      }
      this._view.updateDataView();
      this._view.setMaskDefault();
   }
   function fillContainersWithItem(idx, oItemToPut)
   {
      var _loc4_ = dofus.datacenter.Item(oItemToPut.clone());
      if(idx != dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX)
      {
         _loc4_.Quantity = 1;
      }
      switch(idx)
      {
         case dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX:
            if(this._itemMaster != undefined)
            {
               this.restoreToInventory(this._itemMaster);
            }
            this._itemMaster = _loc4_;
            this.updateInfoFromMasterItem();
            break;
         case 1:
            if(this._item1 != undefined)
            {
               this.restoreToInventory(this._item1);
            }
            this._item1 = _loc4_;
            this._view.updateDataView();
            break;
         case 2:
            if(this._item2 != undefined)
            {
               this.restoreToInventory(this._item2);
            }
            this._item2 = _loc4_;
            this._view.updateDataView();
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX:
            if(this._relic != undefined)
            {
               this.restoreToInventory(this._relic);
            }
            this._relic = _loc4_;
            this._view.updateDataView();
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX:
            if(this._frag != undefined)
            {
               this.restoreToInventory(this._frag);
            }
            this._frag = _loc4_;
            this._nLastFragUid = _loc4_.ID;
            this._view.updateDataView();
         default:
            return;
      }
   }
   function ctrToAddItem(oItem)
   {
      if(this.isRelic(oItem))
      {
         return dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX;
      }
      if(this.isFragment(oItem))
      {
         return dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX;
      }
      if(!oItem.isEnhanceableSuperType)
      {
         return -1;
      }
      if(this._itemMaster == undefined || this._itemMaster.unicID != oItem.unicID)
      {
         return dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX;
      }
      if(this._item1 == undefined)
      {
         return 1;
      }
      if(this._item2 == undefined)
      {
         return 2;
      }
      return -1;
   }
   function askFusion()
   {
      if(this._itemMaster == undefined)
      {
         this._api.kernel.showMessage(undefined,this._api.lang.getText("TR3_UPGRADE_ERR1"),"ERROR_CHAT");
         return undefined;
      }
      var _loc3_ = this._itemMaster.ID;
      if(this._item1 == undefined || this._item2 == undefined)
      {
         this._api.kernel.showMessage(undefined,this._api.lang.getText("TR3_UPGRADE_ERR2"),"ERROR_CHAT");
         return undefined;
      }
      var _loc4_ = this._item1.ID;
      var _loc5_ = this._item2.ID;
      if(this._frag == undefined)
      {
         this._api.kernel.showMessage(undefined,this._api.lang.getText("TR3_UPGRADE_ERR4"),"ERROR_CHAT");
         return undefined;
      }
      var _loc6_ = this._frag.ID;
      var _loc7_ = this._frag.Quantity;
      if(this._api.datacenter.Temporis.actualUpgradeRecipe.cost > _loc7_)
      {
         this._api.kernel.showMessage(undefined,this._api.lang.getText("TR3_UPGRADE_ERR4"),"ERROR_CHAT");
         return undefined;
      }
      if(!this.isFragUsableForItem(this._frag,this._itemMaster))
      {
         this._api.kernel.showMessage(undefined,this._api.lang.getText("TR3_UPGRADE_ERR3"),"ERROR_CHAT");
         return undefined;
      }
      this._api.network.Temporis.episodeThree.askUpgradeExecute(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,this._relic.ID);
   }
   function moveToUpgrader(oItem, nIndex)
   {
      if(nIndex == undefined)
      {
         nIndex = this.ctrToAddItem(oItem);
      }
      if(nIndex == -1)
      {
         return undefined;
      }
      if(nIndex == dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX)
      {
         this._api.network.Temporis.episodeThree.askUpgradePreview(oItem.ID,this.relic != undefined ? this.relic.unicID : -1);
         return undefined;
      }
      if(nIndex == dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX && this.nUpgradeLevel != 1)
      {
         return undefined;
      }
      if(nIndex == dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX && this.itemMaster != undefined)
      {
         this._api.network.Temporis.episodeThree.askUpgradePreview(this.itemMaster.ID,oItem.unicID);
      }
      if((nIndex == 1 || nIndex == 2) && (this.itemMaster == undefined || this.itemMaster.unicID != oItem.unicID))
      {
         return undefined;
      }
      this.fillContainersWithItem(nIndex,oItem);
      this.removeFromInventory(oItem,nIndex != dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX ? 1 : oItem.Quantity);
   }
   function moveToInventory(nIndex)
   {
      switch(nIndex)
      {
         case dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX:
            if(this._itemMaster != undefined)
            {
               this.restoreToInventory(this._itemMaster);
            }
            this._itemMaster = undefined;
            this.updateInfoFromMasterItem();
            break;
         case 1:
            if(this._item1 != undefined)
            {
               this.restoreToInventory(this._item1);
            }
            this._item1 = undefined;
            this._view.updateDataView();
            break;
         case 2:
            if(this._item2 != undefined)
            {
               this.restoreToInventory(this._item2);
            }
            this._item2 = undefined;
            this._view.updateDataView();
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.RELIC_INDEX:
            if(this._relic != undefined)
            {
               this.restoreToInventory(this._relic);
            }
            this._relic = undefined;
            if(this.itemMaster != undefined)
            {
               this._api.network.Temporis.episodeThree.askUpgradePreview(this.itemMaster.ID,-1);
            }
            break;
         case dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX:
            if(this._frag != undefined)
            {
               this.restoreToInventory(this._frag);
            }
            this._frag = undefined;
            this._view.updateDataView();
         default:
            return;
      }
   }
   function restoreToInventory(oItemToPutBack)
   {
      var _loc3_ = this._dataProvider.findFirstItem("ID",oItemToPutBack.ID);
      if(_loc3_ == undefined || _loc3_.index == -1)
      {
         this._dataProvider.push(oItemToPutBack);
      }
      else
      {
         this._dataProvider[_loc3_.index].Quantity += 1;
         this._view.cgGrid.modelChanged();
      }
   }
   function removeFromInventory(oItemToRemove, nQuantity)
   {
      var _loc4_ = this._dataProvider.findFirstItem("ID",oItemToRemove.ID);
      if(this._dataProvider[_loc4_.index].Quantity == nQuantity)
      {
         this._dataProvider.removeItems(_loc4_.index,1);
      }
      else
      {
         this._dataProvider[_loc4_.index].Quantity -= nQuantity;
         this._view.cgGrid.modelChanged();
      }
   }
   function updateOnFailed()
   {
      if(this._relic != undefined)
      {
         this._relic = undefined;
      }
      var _loc2_ = this._frag.Quantity - this._api.datacenter.Temporis.actualUpgradeRecipe.cost;
      if(_loc2_ == 0)
      {
         this._frag = undefined;
      }
      else
      {
         this._frag.Quantity = _loc2_;
      }
      this._api.kernel.showMessage(undefined,this._api.lang.getText("CRAFT_FAILED"),"ERROR_CHAT");
      this._view.updateDataView();
   }
   function updateOnSucceed()
   {
      this._view.playAnim();
      this.resetContainers(true);
      this.resetInventoryClone();
      this.placeFragment(this._nLastFragUid);
   }
   function placeMasterItem(nUnicID)
   {
      if(this.itemMaster.ID == nUnicID)
      {
         return undefined;
      }
      var _loc3_ = this._dataProvider.findFirstItem("ID",nUnicID);
      if(_loc3_ == undefined || _loc3_.index == -1)
      {
         return undefined;
      }
      var _loc4_ = dofus.datacenter.Item(_loc3_.item);
      this.fillContainersWithItem(dofus.datacenter.evenemential.ItemUpgrader.MASTER_INDEX,_loc4_);
      this.removeFromInventory(_loc4_,1);
   }
   function placeFragment(nUnicID)
   {
      var _loc3_ = this._dataProvider.findFirstItem("ID",nUnicID);
      if(_loc3_ == undefined || _loc3_.index == -1)
      {
         return undefined;
      }
      var _loc4_ = dofus.datacenter.Item(_loc3_.item);
      this.fillContainersWithItem(dofus.datacenter.evenemential.ItemUpgrader.FRAGMENT_INDEX,_loc4_);
      this.removeFromInventory(_loc4_,_loc4_.Quantity);
   }
   function getTierFromItem(oItem)
   {
      if(oItem.level <= 30)
      {
         return 1;
      }
      if(oItem.level > 30 && oItem.level <= 60)
      {
         return 2;
      }
      if(oItem.level > 60 && oItem.level <= 90)
      {
         return 3;
      }
      if(oItem.level > 90 && oItem.level <= 120)
      {
         return 4;
      }
      if(oItem.level > 120 && oItem.level <= 150)
      {
         return 5;
      }
      if(oItem.level > 150 && oItem.level <= 180)
      {
         return 6;
      }
      return 7;
   }
   function getTierLabel(oItem)
   {
      return this.aTierLabels[this.getTierFromItem(oItem) - 1];
   }
   function getBonusFromRelic(oItem)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.aTierRelics.length)
      {
         if(this.aTierRelics[_loc3_] == oItem.unicID)
         {
            return 30 + _loc3_ * 10;
         }
         _loc3_ = _loc3_ + 1;
      }
      return 0;
   }
   function isFragUsableForItem(oFrag, oItem)
   {
      var _loc4_ = this.getTierFromItem(oItem) - 1;
      while(_loc4_ < this.aTierFragments.length)
      {
         if(this.aTierFragments[_loc4_] == oFrag.unicID)
         {
            return true;
         }
         _loc4_ = _loc4_ + 1;
      }
      return false;
   }
   function isFragment(oItem)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.aTierFragments.length)
      {
         if(this.aTierFragments[_loc3_] == oItem.unicID)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function isRelic(oItem)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.aTierRelics.length)
      {
         if(this.aTierRelics[_loc3_] == oItem.unicID)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function isFusionReady()
   {
      return this._itemMaster != undefined && (this._item1 != undefined && (this._item2 != undefined && this._frag != undefined));
   }
}
