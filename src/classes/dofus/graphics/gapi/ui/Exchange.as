class dofus.graphics.gapi.ui.Exchange extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bValidateDelayed;
   var _btnClose;
   var _btnFilterCards;
   var _btnFilterCeremonials;
   var _btnFilterEquipement;
   var _btnFilterNonEquipement;
   var _btnFilterRessoureces;
   var _btnFilterRunes;
   var _btnFilterSoul;
   var _btnPrivateChat;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _btnValidate;
   var _cbTypes;
   var _cgDistant;
   var _cgGrid;
   var _cgLocal;
   var _currentOverContainer;
   var _eaDataProvider;
   var _eaDistantDataProvider;
   var _eaLocalDataProvider;
   var _eaReadyDataProvider;
   var _iifFilter;
   var _itvItemViewer;
   var _lblDistantKamaAmount;
   var _lblFilter;
   var _lblKama;
   var _mcBlink;
   var _mcBlink_TripleFramerate;
   var _srSearch;
   var _tiSearch;
   var _timerExchange;
   var _winDistant;
   var _winInventory;
   var _winItemViewer;
   var _winLocal;
   var addToQueue;
   var gapi;
   var setMovieClipTransform;
   static var CLASS_NAME = "Exchange";
   static var READY_COLOR = {ra:70,rb:0,ga:70,gb:0,ba:70,bb:0};
   static var NON_READY_COLOR = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0};
   static var DELAY_BEFORE_VALIDATE = 3000;
   var _bValidationDelayed = false;
   var _aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
   var _nSelectedTypeID = 0;
   var _sCurrentItemSearch = "";
   function Exchange()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return dofus.datacenter.Item(this._currentOverContainer.contentData);
      }
      return undefined;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider.removeEventListener("modelChanged",this);
      this._eaDataProvider = eaDataProvider;
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function set _nDistantReadyState(eaDistantDataProvider)
   {
      this._eaLocalDataProvider.removeEventListener("modelChange",this);
      this._eaLocalDataProvider = eaDistantDataProvider;
      this._eaLocalDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function set _mcBlinkPay(eaLocalDataProvider)
   {
      this._eaDistantDataProvider.removeEventListener("modelChange",this);
      this._eaDistantDataProvider = eaLocalDataProvider;
      this._eaDistantDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function set _winPay(eaReadyDataProvider)
   {
      this._eaReadyDataProvider.removeEventListener("modelChange",this);
      this._eaReadyDataProvider = eaReadyDataProvider;
      this._eaReadyDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Exchange.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this._btnSelectedFilterButton = this._btnFilterEquipement;
      this.addToQueue({object:this,method:this.initData});
      this.hideItemViewer(true);
      this.enableSearch(false);
      this.addToQueue({object:this,method:this.initTexts});
      this._btnPrivateChat._visible = this.api.datacenter.Exchange.distantPlayerID > 0;
      this.gapi.unloadLastUIAutoHideComponent();
   }
   function destroy()
   {
      if(this._timerExchange == undefined)
      {
         return undefined;
      }
      _global.clearTimeout(this._timerExchange);
   }
   function addListeners()
   {
      this._cgGrid.addEventListener("dblClickItem",this);
      this._cgGrid.addEventListener("dropItem",this);
      this._cgGrid.addEventListener("dragItem",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.addEventListener("overItem",this);
      this._cgGrid.addEventListener("outItem",this);
      this._cgLocal.addEventListener("dblClickItem",this);
      this._cgLocal.addEventListener("dropItem",this);
      this._cgLocal.addEventListener("dragItem",this);
      this._cgLocal.addEventListener("selectItem",this);
      this._cgLocal.addEventListener("overItem",this);
      this._cgLocal.addEventListener("outItem",this);
      this._cgDistant.addEventListener("selectItem",this);
      this._cgDistant.addEventListener("overItem",this);
      this._cgDistant.addEventListener("outItem",this);
      this._cgDistant.multipleContainerSelectionEnabled = false;
      this._btnFilterEquipement.addEventListener("click",this);
      this._btnFilterNonEquipement.addEventListener("click",this);
      this._btnFilterRessoureces.addEventListener("click",this);
      this._btnFilterSoul.addEventListener("click",this);
      this._btnFilterCards.addEventListener("click",this);
      this._btnFilterEquipement.addEventListener("over",this);
      this._btnFilterNonEquipement.addEventListener("over",this);
      this._btnFilterRessoureces.addEventListener("over",this);
      this._btnFilterSoul.addEventListener("over",this);
      this._btnFilterCards.addEventListener("over",this);
      this._btnFilterEquipement.addEventListener("out",this);
      this._btnFilterNonEquipement.addEventListener("out",this);
      this._btnFilterRessoureces.addEventListener("out",this);
      this._btnFilterSoul.addEventListener("out",this);
      this._btnFilterCards.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("over",this);
      this._btnFilterRunes.addEventListener("click",this);
      this._btnFilterCeremonials.addEventListener("click",this);
      this._btnFilterCeremonials.addEventListener("over",this);
      this._btnFilterCeremonials.addEventListener("out",this);
      this._btnSearch.addEventListener("click",this);
      this._btnSearch.addEventListener("over",this);
      this._btnSearch.addEventListener("out",this);
      this._btnClose.addEventListener("click",this);
      this.api.datacenter.Exchange.addEventListener("localKamaChange",this);
      this.api.datacenter.Exchange.addEventListener("distantKamaChange",this);
      this._btnValidate.addEventListener("click",this);
      this._btnPrivateChat.addEventListener("click",this);
      this._cbTypes.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
   }
   function initTexts()
   {
      this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winDistant.title = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name;
      this._btnValidate.label = this.api.lang.getText("ACCEPT");
      this._lblKama.text = new ank.utils.ExtendedString(this.api.datacenter.Player.Kama).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._btnPrivateChat.label = this.api.lang.getText("WISPER_MESSAGE");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function initData()
   {
      this.dataProvider = this.api.datacenter.Exchange.inventory;
      this._nDistantReadyState = this.api.datacenter.Exchange.localGarbage;
      this._mcBlinkPay = this.api.datacenter.Exchange.distantGarbage;
      this._winPay = this.api.datacenter.Exchange.readyStates;
   }
   function updateData(eaDataProvider)
   {
      var _loc3_ = this.api.datacenter.Basics[dofus.graphics.gapi.ui.Exchange.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name];
      this._nSelectedTypeID = _loc3_ != undefined ? _loc3_ : 0;
      if(eaDataProvider == undefined)
      {
         eaDataProvider = this._eaDataProvider;
      }
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = new ank.utils.ExtendedArray();
      var _loc6_ = {};
      var _loc7_;
      var _loc8_;
      for(var k in eaDataProvider)
      {
         _loc7_ = eaDataProvider[k];
         if(_loc7_.position == -1 && (this._aSelectedSuperTypes[_loc7_.superType] && (this._iifFilter == null || (this._iifFilter == undefined || this._iifFilter.isItemListed(_loc7_)))))
         {
            _loc8_ = _loc7_.type;
            if(!_loc6_[_loc8_])
            {
               _loc5_.push({label:this.api.lang.getItemTypeText(_loc8_).n,id:_loc8_});
               _loc6_[_loc8_] = true;
            }
            if(this._nSelectedTypeID == 0 || _loc8_ == this._nSelectedTypeID)
            {
               _loc4_.push(_loc7_);
            }
         }
      }
      _loc5_.sortOn("label");
      _loc5_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:0});
      this._cbTypes.dataProvider = _loc5_;
      this.setType(this._nSelectedTypeID);
      this._cgGrid.dataProvider = _loc4_;
   }
   function setType(nTypeID)
   {
      var _loc3_ = this._cbTypes.dataProvider;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         if(_loc3_[_loc4_].id == nTypeID)
         {
            this._cbTypes.selectedIndex = _loc4_;
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._nSelectedTypeID = 0;
      this._cbTypes.selectedIndex = this._nSelectedTypeID;
   }
   function onDataUpdated()
   {
      _global.clearTimeout(this._timerExchange);
      this._timerExchange = _global.setTimeout(this,"hideButtonValidate",dofus.graphics.gapi.ui.Exchange.DELAY_BEFORE_VALIDATE,false);
   }
   function updateLocalData()
   {
      this._cgLocal.dataProvider = this._eaLocalDataProvider;
      this.hideButtonValidate(true);
      this.onDataUpdated();
   }
   function updateDistantData()
   {
      this._cgDistant.dataProvider = this._eaDistantDataProvider;
      this.hideButtonValidate(true);
      this.onDataUpdated();
   }
   function updateReadyState()
   {
      var _loc2_ = !this._eaReadyDataProvider[0] ? dofus.graphics.gapi.ui.Exchange.NON_READY_COLOR : dofus.graphics.gapi.ui.Exchange.READY_COLOR;
      this.setMovieClipTransform(this._winLocal,_loc2_);
      this.setMovieClipTransform(this._btnValidate,_loc2_);
      this.setMovieClipTransform(this._cgLocal,_loc2_);
      _loc2_ = !this._eaReadyDataProvider[1] ? dofus.graphics.gapi.ui.Exchange.NON_READY_COLOR : dofus.graphics.gapi.ui.Exchange.READY_COLOR;
      this.setMovieClipTransform(this._winDistant,_loc2_);
      this.setMovieClipTransform(this._cgDistant,_loc2_);
   }
   function hideButtonValidate(bHide)
   {
      var _loc3_ = !bHide ? dofus.graphics.gapi.ui.Exchange.NON_READY_COLOR : dofus.graphics.gapi.ui.Exchange.READY_COLOR;
      this.setMovieClipTransform(this._btnValidate,_loc3_);
      this._btnValidate.enabled = !bHide;
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
   }
   function moveItems(aItems, bAdd)
   {
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
   function validateDrop(sTargetGrid, oItem, nValue)
   {
      if(nValue < 1 || nValue == undefined)
      {
         return undefined;
      }
      if(nValue > oItem.Quantity)
      {
         nValue = oItem.Quantity;
      }
      switch(sTargetGrid)
      {
         case "_cgGrid":
            this.api.network.Exchange.movementItem(false,oItem,nValue);
            break;
         case "_cgLocal":
            this.api.network.Exchange.movementItem(true,oItem,nValue);
         default:
            return;
      }
   }
   function validateKama(nQuantity)
   {
      if(nQuantity > this.api.datacenter.Player.Kama)
      {
         nQuantity = this.api.datacenter.Player.Kama;
      }
      this.api.network.Exchange.movementKama(nQuantity);
   }
   function askKamaQuantity()
   {
      var _loc2_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:this.api.datacenter.Exchange.localKama,max:this.api.datacenter.Player.Kama,min:0,params:{targetType:"kama"}});
      _loc2_.addEventListener("validate",this);
   }
   function enableSearch(bEnable)
   {
      if(bEnable)
      {
         this._tiSearch._visible = true;
         this._srSearch._visible = true;
         this._cbTypes._visible = false;
         this._cbTypes.closeList();
         this._tiSearch.setFocus();
      }
      else
      {
         this._tiSearch._visible = false;
         this._srSearch._visible = false;
         this._tiSearch.clearText();
         this._sCurrentItemSearch = "";
         this._cbTypes._visible = true;
      }
   }
   function searchItem(sText_)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this._aSelectedSuperTypes == dofus.Constants.FILTER_SOUL;
      sText_ = new ank.utils.ExtendedString(sText_).removeAccents().toUpperCase();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      for(var i in this._eaDataProvider)
      {
         _loc5_ = this._eaDataProvider[i];
         if(_loc4_)
         {
            _loc6_ = _loc5_.getMonsterList();
            if(!(!_loc6_ || _loc6_.length == 0))
            {
               _loc7_ = _loc6_.split("|");
               for(var k in _loc7_)
               {
                  _loc8_ = Number(_loc7_[k]);
                  if(!_global.isNaN(_loc8_))
                  {
                     _loc9_ = new ank.utils.ExtendedString(this.api.lang.getMonstersText(_loc8_).n).removeAccents().toUpperCase();
                     if(_loc9_.indexOf(sText_) != -1)
                     {
                        _loc3_.push(_loc5_);
                        break;
                     }
                  }
               }
            }
         }
         else if(_loc5_.nameUppercase.indexOf(sText_) != -1)
         {
            _loc3_.push(_loc5_);
         }
      }
      this.updateData(_loc3_);
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.target)
      {
         case this._eaReadyDataProvider:
            this.updateReadyState();
            return;
         case this._eaLocalDataProvider:
            this.updateLocalData();
            return;
         case this._eaDistantDataProvider:
            this.updateDistantData();
            return;
         case this._eaDataProvider:
            this.updateData();
            if(this._sCurrentItemSearch != "")
            {
               this.searchItem(this._sCurrentItemSearch);
            }
            return;
         default:
            this.updateData();
            this.updateLocalData();
            this.updateDistantData();
            return;
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            return;
         case this._btnValidate:
            this.api.network.Exchange.ready();
            return;
         case this._btnPrivateChat:
            if(this.api.datacenter.Exchange.distantPlayerID > 0)
            {
               this.api.kernel.GameManager.askPrivateMessage(this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Exchange.distantPlayerID).name);
            }
            return;
         case this._btnSearch:
            this.enableSearch(this._btnSearch.selected);
            if(!this._btnSearch.selected)
            {
               this.updateData(this._eaDataProvider);
            }
            return;
         default:
            if(oEvent.target != this._btnSelectedFilterButton)
            {
               this._btnSelectedFilterButton.selected = false;
               this._btnSelectedFilterButton = oEvent.target;
               this._iifFilter = undefined;
               if(this._btnSearch.selected)
               {
                  this.enableSearch(false);
                  this._btnSearch.selected = false;
               }
               switch(oEvent.target)
               {
                  case this._btnFilterEquipement:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
                     this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
                     this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
                     break;
                  case this._btnFilterNonEquipement:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
                     this._lblFilter.text = this.api.lang.getText("CONSUMABLES");
                     break;
                  case this._btnFilterRessoureces:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
                     this._lblFilter.text = this.api.lang.getText("RESSOURECES");
                     break;
                  case this._btnFilterSoul:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
                     this._lblFilter.text = this.api.lang.getText("SOUL");
                     break;
                  case this._btnFilterRunes:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
                     this._lblFilter.text = this.api.lang.getText("RUNES");
                     break;
                  case this._btnFilterCards:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
                     this._lblFilter.text = this.api.lang.getText("CARDS");
                     break;
                  case this._btnFilterCeremonials:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_EQUIPEMENT;
                     this._lblFilter.text = this.api.lang.getText("ITEM_TYPE_CEREMONIAL");
                     this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter();
               }
               this.updateData();
               return;
            }
            oEvent.target.selected = true;
            return;
      }
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
      var _loc3_ = oEvent.target.contentData;
      var _loc4_ = oEvent.targets;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = Key.isDown(dofus.Constants.SELECT_MULTIPLE_ITEMS_KEY);
      var _loc6_ = !_loc5_ ? 1 : _loc3_.Quantity;
      var _loc7_ = oEvent.owner._name;
      switch(_loc7_)
      {
         case "_cgGrid":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,true);
            }
            else
            {
               this.validateDrop("_cgLocal",_loc3_,_loc6_);
            }
            break;
         case "_cgLocal":
            if(_loc5_ && _loc4_.length > 1)
            {
               this.moveItems(_loc4_,false);
            }
            else
            {
               this.validateDrop("_cgGrid",_loc3_,_loc6_);
            }
         default:
            return;
      }
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
      var _loc4_ = oEvent.target._parent._parent._name;
      switch(_loc4_)
      {
         case "_cgGrid":
            if(_loc3_.position == -1)
            {
               return undefined;
            }
            break;
         case "_cgLocal":
            if(_loc3_.position == -2)
            {
               return undefined;
            }
      }
      var _loc5_;
      if(_loc3_.Quantity > 1)
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc3_.Quantity,params:{targetType:"item",oItem:_loc3_,targetGrid:_loc4_}});
         _loc5_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(_loc4_,_loc3_,1);
      }
   }
   function selectItem(oEvent)
   {
      if(oEvent.target.contentData == undefined)
      {
         this.hideItemViewer(true);
      }
      else
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
            return undefined;
         }
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.target.contentData;
      }
   }
   function validate(oEvent)
   {
      switch(oEvent.params.targetType)
      {
         case "item":
            this.validateDrop(oEvent.params.targetGrid,oEvent.params.oItem,oEvent.value);
            break;
         case "kama":
            this.validateKama(oEvent.value);
         default:
            return;
      }
   }
   function localKamaChange(oEvent)
   {
      this._bValidateDelayed.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this._lblKama.text = new ank.utils.ExtendedString(this.api.datacenter.Player.Kama - oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this.hideButtonValidate(true);
      this.onDataUpdated();
   }
   function distantKamaChange(oEvent)
   {
      if(dofus.Constants.TRIPLEFRAMERATE)
      {
         this._mcBlink_TripleFramerate.play();
      }
      else
      {
         this._mcBlink.play();
      }
      this._lblDistantKamaAmount.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      this.hideButtonValidate(true);
      this.onDataUpdated();
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_cbTypes")
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.ui.Exchange.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name] = this._nSelectedTypeID;
         this.updateData();
      }
   }
   function change(oEvent_)
   {
      var _loc3_ = this._tiSearch.text;
      if(_loc3_ == this._sCurrentItemSearch)
      {
         return undefined;
      }
      if(_loc3_.length >= dofus.Constants.INV_SEARCH_MIN_CHARACTERS)
      {
         this._sCurrentItemSearch = _loc3_;
         this.searchItem(_loc3_);
      }
      else
      {
         this._sCurrentItemSearch = "";
         this.updateData(this._eaDataProvider);
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnFilterEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("EQUIPEMENT"));
            break;
         case this._btnFilterNonEquipement:
            this.api.ui.showTooltip(this.api.lang.getText("CONSUMABLES"));
            break;
         case this._btnFilterRessoureces:
            this.api.ui.showTooltip(this.api.lang.getText("RESSOURECES"));
            break;
         case this._btnFilterSoul:
            this.api.ui.showTooltip(this.api.lang.getText("SOUL"));
            break;
         case this._btnFilterRunes:
            this.api.ui.showTooltip(this.api.lang.getText("RUNES"));
            break;
         case this._btnFilterCards:
            this.api.ui.showTooltip(this.api.lang.getText("CARDS"));
            break;
         case this._btnFilterCeremonials:
            this.api.ui.showTooltip(this.api.lang.getText("ITEM_TYPE_CEREMONIAL"));
            break;
         case this._btnSearch:
            this.api.ui.showTooltip(this.api.lang.getText("SEARCH"));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.api.ui.hideTooltip();
   }
   function optionChanged(oEvent_)
   {
      if(oEvent_.key == "HideInventoryItemsCornerIcon")
      {
         this.updateData();
         if(this._sCurrentItemSearch != "")
         {
            this.searchItem(this._sCurrentItemSearch);
         }
      }
   }
}
