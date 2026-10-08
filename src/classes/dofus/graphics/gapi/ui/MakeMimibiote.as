class dofus.graphics.gapi.ui.MakeMimibiote extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _btnValidate;
   var _cgItemToAttach;
   var _cgItemToEat;
   var _cgResult;
   var _ctrResult;
   var _ivInventoryViewer;
   var _lblName;
   var _mcFiligrane;
   var _winInventory;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "MakeMimibiote";
   function MakeMimibiote()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.MakeMimibiote.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnValidate.addEventListener("click",this);
      this._ivInventoryViewer.addEventListener("dblClickItem",this);
      this._ivInventoryViewer.addEventListener("dropItem",this);
      this._ivInventoryViewer.cgGrid.multipleContainerSelectionEnabled = false;
      this._cgItemToAttach.addEventListener("dblClickItem",this);
      this._cgItemToAttach.addEventListener("dropItem",this);
      this._cgItemToAttach.addEventListener("dragItem",this);
      this._cgItemToAttach.addEventListener("overItem",this);
      this._cgItemToAttach.addEventListener("outItem",this);
      this._cgItemToEat.addEventListener("dblClickItem",this);
      this._cgItemToEat.addEventListener("dropItem",this);
      this._cgItemToEat.addEventListener("dragItem",this);
      this._cgItemToEat.addEventListener("overItem",this);
      this._cgItemToEat.addEventListener("outItem",this);
      this._cgItemToAttach.multipleContainerSelectionEnabled = false;
      this._cgItemToEat.multipleContainerSelectionEnabled = false;
      this._ctrResult.addEventListener("over",this);
      this._ctrResult.addEventListener("out",this);
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._lblName.text = this.api.lang.getText("CUSTOMIZE");
      this._btnValidate.label = this.api.lang.getText("VALIDATE");
   }
   function initData()
   {
      this._ivInventoryViewer.hideNonEquipementFilters();
      this._ivInventoryViewer.showKamas = false;
      this._ivInventoryViewer.dataProvider = this.api.datacenter.Player.Inventory;
      this._cgItemToAttach.dataProvider = new ank.utils.ExtendedArray();
      this._cgItemToEat.dataProvider = new ank.utils.ExtendedArray();
      this._cgResult.dataProvider = new ank.utils.ExtendedArray();
      this.refreshPreview();
   }
   function putItem(ctr, oItem, bOverWriteIfPresent)
   {
      if(oItem != undefined && !this.canPutItem(oItem,ctr))
      {
         this.refreshPreview();
         return undefined;
      }
      var _loc5_ = new ank.utils.ExtendedArray();
      oItem = oItem.clone();
      oItem.Quantity = 1;
      if(!(!bOverWriteIfPresent && ctr.dataProvider.length > 0))
      {
         if(oItem != undefined)
         {
            _loc5_.push(oItem);
         }
      }
      ctr.dataProvider = _loc5_;
      this.refreshPreview();
   }
   function removeItem(ctr)
   {
      this.putItem(ctr,undefined,false);
   }
   function canPutItem(oItem, cgTarget)
   {
      if(!dofus.Constants.isItemSuperTypeSkinable(oItem.superType))
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ITEM_NOT_SKINABLE"),"ERROR_CHAT");
         return false;
      }
      if(oItem.hasCustomSkinItem || oItem.skineable)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ITEM_ALREADY_SKINED"),"ERROR_CHAT");
         return false;
      }
      var _loc4_;
      if(cgTarget == this._cgItemToEat)
      {
         _loc4_ = this._cgItemToAttach;
      }
      else
      {
         if(oItem.isCeremonial)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ITEM_NOT_SKINABLE"),"ERROR_CHAT");
            return false;
         }
         _loc4_ = this._cgItemToEat;
      }
      var _loc5_ = _loc4_.dataProvider[0];
      if(_loc5_ != undefined)
      {
         if(_loc5_.unicID == oItem.unicID)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ITEM_SAME_ID"),"ERROR_CHAT");
            return false;
         }
         if(_loc5_.type != oItem.type && ((!_loc5_.isItemTypeCloseCombat || !oItem.isItemTypeCloseCombat) && (!_loc5_.isItemTypeCape || !oItem.isItemTypeCape)))
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_ITEM_SHOULD_BE_SAME_TYPE"),"ERROR_CHAT");
            return false;
         }
         if(cgTarget == this._cgItemToEat)
         {
            if(oItem.level > this.api.datacenter.Player.Level)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_SKIN_ITEM_SHOULD_BE_LOWER_LEVEL"),"ERROR_CHAT");
               return false;
            }
            if(oItem.isUndestroyable)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_265"),"ERROR_CHAT");
               return false;
            }
         }
      }
      return true;
   }
   function refreshPreview()
   {
      var _loc2_ = false;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._cgItemToAttach.dataProvider.length > 0 && this._cgItemToEat.dataProvider.length > 0)
      {
         this._btnValidate.enabled = true;
         _loc3_ = this._cgItemToAttach.dataProvider[0];
         _loc4_ = this._cgItemToEat.dataProvider[0];
         if(this._ctrResult.contentPath == undefined)
         {
            return undefined;
         }
         _loc5_ = _loc3_.clone();
         _loc6_ = this.api.lang.getItemUnicText(_loc4_.unicID);
         _loc5_.skinItemInfos = _loc6_;
         if(_loc4_.realGfx != undefined)
         {
            _loc5_.gfx = _loc4_.realGfx;
         }
         else
         {
            _loc5_.gfx = _loc4_.gfx;
         }
         this._ctrResult.contentPath = _loc5_.iconFile;
         this._mcFiligrane.item = _loc5_;
         _loc2_ = true;
      }
      else
      {
         this._btnValidate.enabled = false;
      }
      if(!_loc2_)
      {
         this._ctrResult.contentPath = "";
      }
      this._mcFiligrane._visible = _loc2_;
      this._ctrResult._visible = _loc2_;
   }
   function yes(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoCreateMimibiote")
      {
         _loc3_ = this._cgItemToAttach.dataProvider[0];
         _loc4_ = this._cgItemToEat.dataProvider[0];
         if(!(_loc3_ == undefined || _loc4_ == undefined))
         {
            this.api.network.Items.associateMimibiote(_loc3_.ID,_loc4_.ID);
            this.unloadThis();
         }
      }
   }
   function click(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent.target) !== this._btnValidate)
      {
         this.callClose();
      }
      else
      {
         _loc3_ = this._cgItemToEat.dataProvider[0];
         _loc4_ = !_loc3_.isCeremonial ? "CONFIRM_MAKE_MIMIBIOTE" : "CONFIRM_MAKE_MIMIBIOTE_ON_CEREMONIAL";
         _loc5_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoCreateMimibiote",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText(_loc4_)});
         _loc5_.addEventListener("yes",this);
      }
   }
   function dblClickItem(oEvent)
   {
      var _loc3_;
      var _loc4_;
      if(oEvent.owner != undefined)
      {
         _loc3_ = oEvent.owner.dataProvider[0];
         if(_loc3_ == undefined)
         {
            return undefined;
         }
         _loc4_ = oEvent.owner._name;
         switch(_loc4_)
         {
            case "_cgItemToAttach":
               this.removeItem(this._cgItemToAttach);
               break;
            case "_cgItemToEat":
               this.removeItem(this._cgItemToEat);
         }
      }
      var _loc0_;
      var _loc5_;
      if(oEvent.target != undefined)
      {
         if((_loc0_ = oEvent.target) === this._ivInventoryViewer)
         {
            _loc5_ = oEvent.item;
            if(_loc5_ == undefined)
            {
               return undefined;
            }
            if(this._cgItemToAttach.dataProvider.length == 0)
            {
               this.putItem(this._cgItemToAttach,_loc5_,false);
            }
            else
            {
               this.putItem(this._cgItemToEat,_loc5_,true);
            }
         }
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._ctrResult)
      {
         _loc3_ = this._mcFiligrane.item;
         if(_loc3_ != undefined)
         {
            _loc3_.showStatsTooltip(_loc3_.style);
         }
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
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
   function dragItem(oEvent)
   {
      this.gapi.removeCursor();
      if(oEvent.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.setCursor(oEvent.target.contentData);
   }
   function dropItem(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(oEvent.item != undefined)
      {
         _loc3_ = oEvent.item;
         _loc4_ = this._cgItemToAttach.dataProvider[0];
         if(_loc4_ != undefined && _loc4_.ID == _loc3_.ID)
         {
            this.removeItem(this._cgItemToAttach);
            return undefined;
         }
         _loc5_ = this._cgItemToEat.dataProvider[0];
         if(_loc5_ != undefined && _loc5_.ID == _loc3_.ID)
         {
            this.removeItem(this._cgItemToEat);
            return undefined;
         }
         return undefined;
      }
      _loc3_ = dofus.datacenter.Item(this.gapi.getCursor());
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc6_ = oEvent.target._parent._parent;
      var _loc7_ = _loc6_._name;
      var _loc8_;
      var _loc9_;
      switch(_loc7_)
      {
         case "_cgItemToAttach":
            _loc8_ = this._cgItemToEat.dataProvider[0];
            if(_loc8_ != undefined && _loc8_.unicID == _loc3_.unicID)
            {
               this.removeItem(this._cgItemToEat);
            }
            this.putItem(_loc6_,_loc3_,true);
            break;
         case "_cgItemToEat":
            _loc9_ = this._cgItemToAttach.dataProvider[0];
            if(_loc9_ != undefined && _loc9_.unicID == _loc3_.unicID)
            {
               this.removeItem(this._cgItemToAttach);
            }
            this.putItem(_loc6_,_loc3_,true);
         default:
            return;
      }
   }
}
