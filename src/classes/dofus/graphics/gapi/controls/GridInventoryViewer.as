class dofus.graphics.gapi.controls.GridInventoryViewer extends dofus.graphics.gapi.controls.InventoryViewer
{
   var _bShowKamas;
   var _btnDragKama;
   var _cgGrid;
   var _currentOverContainer;
   var _lblKama;
   var _mcKamaSymbol;
   var _oDataViewer;
   var _oKamasProvider;
   var _parent;
   var addToQueue;
   var api;
   var dispatchEvent;
   var gapi;
   var kamaChanged;
   var modelChanged;
   static var CLASS_NAME = "GridInventoryViewer";
   var _bCheckMountPods = true;
   var _bCheckPlayerPods = false;
   var _mcKamaSymbol2 = false;
   function GridInventoryViewer()
   {
      super();
   }
   function get cgGrid()
   {
      return this._cgGrid;
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return dofus.datacenter.Item(this._currentOverContainer.contentData);
      }
      return undefined;
   }
   function get checkPlayerPods()
   {
      return this._bCheckPlayerPods;
   }
   function get checkMountPods()
   {
      return this._mcKamaSymbol2;
   }
   function set checkPlayerPods(bCheckPlayerPods)
   {
      this._bCheckPlayerPods = bCheckPlayerPods;
   }
   function set checkMountPods(bCheck)
   {
      this._mcKamaSymbol2 = bCheck;
   }
   function set showKamas(bShowKamas)
   {
      this._bCheckMountPods = bShowKamas;
      this._btnDragKama._visible = this._lblKama._visible = this._mcKamaSymbol._visible = this._bShowKamas._visible = bShowKamas;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.GridInventoryViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this._oDataViewer = this._cgGrid;
      this.addToQueue({object:this,method:this.addListeners});
      super.createChildren();
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      super.addListeners();
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgGrid.addEventListener("dblClickItem",this);
      this._btnDragKama.onRelease = function()
      {
         this._parent.askKamaQuantity();
      };
   }
   function initTexts()
   {
      super.initTexts();
   }
   function initData()
   {
      this.modelChanged();
      this.kamaChanged({value:this._oKamasProvider.Kama});
   }
   function validateDrop(targetGrid, oItem, nQuantity)
   {
      nQuantity = Number(nQuantity);
      if(nQuantity < 1 || _global.isNaN(nQuantity))
      {
         return undefined;
      }
      if(nQuantity > oItem.Quantity)
      {
         nQuantity = oItem.Quantity;
      }
      this.dispatchEvent({type:"dropItem",item:oItem,quantity:nQuantity,owner:this});
   }
   function validateKama(nQuantity)
   {
      nQuantity = Number(nQuantity);
      if(nQuantity < 1 || _global.isNaN(nQuantity))
      {
         return undefined;
      }
      if(nQuantity > this._oKamasProvider.Kama)
      {
         nQuantity = this._oKamasProvider.Kama;
      }
      this.dispatchEvent({type:"dragKama",quantity:nQuantity});
   }
   function askKamaQuantity()
   {
      var _loc2_ = this._oKamasProvider.Kama == undefined ? 0 : Number(this._oKamasProvider.Kama);
      var _loc3_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:_loc2_,max:_loc2_,params:{targetType:"kama"}});
      _loc3_.addEventListener("validate",this);
   }
   function showOneItem(nUnicID)
   {
      var _loc3_ = 0;
      while(_loc3_ < this._cgGrid.dataProvider.length)
      {
         if(nUnicID == this._cgGrid.dataProvider[_loc3_].unicID)
         {
            this._cgGrid.setVPosition(_loc3_ / this._cgGrid.visibleColumnCount);
            this._cgGrid.selectedIndex = _loc3_;
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
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
   function dropItem(oEvent)
   {
      var _loc3_ = this.gapi.getCursor();
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      if(_loc3_.isShortcut)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      var _loc4_ = _loc3_.Quantity;
      if(this.checkPlayerPods)
      {
         _loc4_ = this.api.datacenter.Player.getPossibleItemReceiveQuantity(_loc3_,false);
      }
      else if(this.checkMountPods)
      {
         _loc4_ = this.api.datacenter.Player.getPossibleItemReceiveQuantity(_loc3_,true);
      }
      var _loc5_;
      if(_loc4_ <= 0)
      {
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_6"),"ERROR_BOX",{name:undefined});
      }
      else if(_loc4_ > 1)
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc4_,params:{targetType:"item",oItem:_loc3_}});
         _loc5_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(this._cgGrid,_loc3_,1);
      }
   }
   function selectItem(oEvent)
   {
      if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && oEvent.target.contentData != undefined)
      {
         this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
         return undefined;
      }
      this.dispatchEvent({type:"selectedItem",item:oEvent.target.contentData});
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
      this._currentOverContainer = _loc3_;
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
      this._currentOverContainer = undefined;
   }
   function dblClickItem(oEvent)
   {
      this.dispatchEvent({type:oEvent.type,item:oEvent.target.contentData,target:this,targets:oEvent.targets,index:oEvent.target.id,owner:this});
   }
   function validate(oEvent)
   {
      switch(oEvent.params.targetType)
      {
         case "item":
            this.validateDrop(this._cgGrid,oEvent.params.oItem,oEvent.value);
            break;
         case "kama":
            this.validateKama(oEvent.value);
         default:
            return;
      }
   }
}
