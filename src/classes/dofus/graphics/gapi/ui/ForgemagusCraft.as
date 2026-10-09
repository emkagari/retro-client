class dofus.graphics.gapi.ui.ForgemagusCraft extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aGarbageMemory;
   var _bIsLooping;
   var _bMakeAll;
   var _btnClose;
   var _btnFilterCards;
   var _btnFilterEquipement;
   var _btnFilterNonEquipement;
   var _btnFilterRessoureces;
   var _btnFilterRunes;
   var _btnFilterSoul;
   var _btnLoop;
   var _btnOneShot;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _cbTypes;
   var _cgDistant;
   var _cgGrid;
   var _cgLocal;
   var _cgLocalSave;
   var _ctrItem;
   var _ctrRune;
   var _ctrSignature;
   var _currentOverContainer;
   var _eaDataProvider;
   var _eaDistantDataProvider;
   var _eaLocalDataProvider;
   var _iifFilter;
   var _itvItemViewer;
   var _lblKama;
   var _lblNewObject;
   var _lblRuneTitle;
   var _lblSignature;
   var _lblSignatureTitle;
   var _lblSkill;
   var _mcPlacer;
   var _nForgemagusItemType;
   var _nMaxItem;
   var _nSkillId;
   var _nUpdateFullDataVisuallyTimeout;
   var _nUpdateLocalDataVisuallyTimeout;
   var _srSearch;
   var _tiSearch;
   var _winInventory;
   var _winItemViewer;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "ForgemagusCraft";
   static var GRID_CONTAINER_WIDTH = 38;
   static var TYPES_ALLOWED_AS_COMPONENT = [26,78];
   static var ITEMS_ALLOWED_AS_SIGNATURE = [7508];
   var _bInvalidateDistant = false;
   var _aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
   var _nSelectedTypeID = 0;
   var _sCurrentItemSearch = "";
   var _nCurrentQuantity = 1;
   function ForgemagusCraft()
   {
      super();
      this._cgLocal._visible = false;
      this._cgDistant._visible = false;
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
   function set maxItem(nMaxItem)
   {
      this._nMaxItem = Number(nMaxItem);
   }
   function set skillId(nSkillId)
   {
      this._nSkillId = Number(nSkillId);
      this._nForgemagusItemType = _global.API.lang.getSkillForgemagus(this._nSkillId);
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
      this._eaLocalDataProvider.removeEventListener("modelChanged",this);
      this._eaLocalDataProvider = eaDistantDataProvider;
      this._eaLocalDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function set _mcBlinkPay(eaLocalDataProvider)
   {
      this._eaDistantDataProvider.removeEventListener("modelChanged",this);
      this._eaDistantDataProvider = eaLocalDataProvider;
      this._eaDistantDataProvider.addEventListener("modelChanged",this);
      this.modelChanged();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ForgemagusCraft.CLASS_NAME);
      this.api.datacenter.Basics.aks_exchange_isForgemagus = true;
   }
   function destroy()
   {
      this.gapi.hideTooltip();
      this.api.datacenter.Basics.aks_exchange_isForgemagus = false;
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this._bMakeAll = false;
      this._mcPlacer._visible = false;
      this.addToQueue({object:this,method:this.addListeners});
      this._btnSelectedFilterButton = this._btnFilterRunes;
      this.addToQueue({object:this,method:this.initData});
      this.hideItemViewer(true);
      this.addToQueue({object:this,method:this.initTexts});
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
      this._ctrItem.addEventListener("dblClick",this);
      this._ctrItem.addEventListener("drag",this);
      this._ctrItem.addEventListener("drop",this);
      this._ctrItem.addEventListener("click",this);
      this._ctrSignature.addEventListener("dblClick",this);
      this._ctrSignature.addEventListener("drag",this);
      this._ctrSignature.addEventListener("drop",this);
      this._ctrSignature.addEventListener("click",this);
      this._ctrRune.addEventListener("dblClick",this);
      this._ctrRune.addEventListener("drag",this);
      this._ctrRune.addEventListener("drop",this);
      this._ctrRune.addEventListener("click",this);
      this._cgDistant.addEventListener("selectItem",this);
      this._cgDistant.addEventListener("overItem",this);
      this._cgDistant.addEventListener("outItem",this);
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
      this._btnFilterRessoureces.addEventListener("out",this);
      this._btnFilterRunes.addEventListener("click",this);
      this._btnFilterRunes.addEventListener("over",this);
      this._btnFilterRunes.addEventListener("out",this);
      this._btnClose.addEventListener("click",this);
      this._btnOneShot.addEventListener("click",this);
      this._btnLoop.addEventListener("click",this);
      this._btnSearch.addEventListener("click",this);
      this._btnSearch.addEventListener("over",this);
      this._btnSearch.addEventListener("out",this);
      this.api.datacenter.Exchange.addEventListener("localKamaChange",this);
      this.api.datacenter.Exchange.addEventListener("distantKamaChange",this);
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
      this.addToQueue({object:this,method:this.kamaChanged,params:[{value:this.api.datacenter.Player.Kama}]});
      this._cbTypes.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
      this._cgDistant.multipleContainerSelectionEnabled = false;
      this._cgGrid.multipleContainerSelectionEnabled = false;
      this._cgLocal.multipleContainerSelectionEnabled = false;
      this._cgLocalSave.multipleContainerSelectionEnabled = false;
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._lblNewObject.text = this.api.lang.getText("CRAFTED_ITEM");
      this._lblSkill.text = this.api.lang.getText("SKILL") + " : " + this.api.lang.getSkillText(this._nSkillId).d;
      this._lblRuneTitle.text = this.api.lang.getText("FM_CRAFT_ITEM");
      this._lblSignatureTitle.text = this.api.lang.getText("FM_CRAFT_RUNE");
      this._lblSignature.text = this.api.lang.getText("FM_CRAFT_SIGNATURE");
      this._btnOneShot.label = this.api.lang.getText("APPLY_ONE_RUNE");
      this._btnLoop.label = this.api.lang.getText("APPLY_MULTIPLE_RUNES");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function initData()
   {
      this.dataProvider = this.api.datacenter.Exchange.inventory;
      this._nDistantReadyState = this.api.datacenter.Exchange.localGarbage;
      this._mcBlinkPay = this.api.datacenter.Exchange.distantGarbage;
      this.updateData(true);
   }
   function updateDataVisually(eaDataProvider)
   {
      if(this._bIsLooping)
      {
         return undefined;
      }
      if(eaDataProvider == undefined)
      {
         eaDataProvider = this._eaDataProvider;
      }
      var _loc3_ = this.api.datacenter.Basics[dofus.graphics.gapi.ui.ForgemagusCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name];
      this._nSelectedTypeID = _loc3_ != undefined ? _loc3_ : 0;
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = {};
      var _loc6_ = new ank.utils.ExtendedArray();
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      for(var k in eaDataProvider)
      {
         _loc7_ = eaDataProvider[k];
         if(_loc7_.position == -1 && this._aSelectedSuperTypes[_loc7_.superType])
         {
            _loc8_ = _loc7_.type;
            if(!_loc5_[_loc8_])
            {
               _loc4_.push({label:this.api.lang.getItemTypeText(_loc8_).n,id:_loc8_});
               _loc5_[_loc8_] = true;
            }
            _loc9_ = this._iifFilter == null || this._iifFilter.isItemListed(_loc7_);
            _loc10_ = _loc7_.type == this._nSelectedTypeID || this._nSelectedTypeID == 0;
            if(_loc9_ && _loc10_)
            {
               _loc6_.push(_loc7_);
            }
         }
      }
      _loc4_.sortOn("label");
      _loc4_.splice(0,0,{label:this.api.lang.getText("WITHOUT_TYPE_FILTER"),id:0});
      this._cbTypes.dataProvider = _loc4_;
      this.setType(this._nSelectedTypeID);
      this._cgGrid.dataProvider = _loc6_;
   }
   function updateData(bForceNow)
   {
      if(this._nUpdateFullDataVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nUpdateFullDataVisuallyTimeout);
      }
      if(bForceNow)
      {
         this.updateDataVisually();
         return undefined;
      }
      var _loc3_ = _global.setTimeout(this,"updateDataVisually",150);
      this._nUpdateFullDataVisuallyTimeout = _loc3_;
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
   function updateLocalDataVisually()
   {
      if(this._nUpdateLocalDataVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nUpdateLocalDataVisuallyTimeout);
         this._nUpdateLocalDataVisuallyTimeout = undefined;
      }
      this._cgLocal.dataProvider = this._eaLocalDataProvider;
      var _loc2_ = false;
      var _loc3_ = false;
      var _loc4_ = false;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc5_ < this._eaLocalDataProvider.length)
      {
         _loc6_ = false;
         _loc7_ = 0;
         while(_loc7_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
         {
            if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc7_] == this._eaLocalDataProvider[_loc5_].unicID)
            {
               _loc4_ = true;
               this._ctrSignature.contentData = this._eaLocalDataProvider[_loc5_];
               _loc6_ = true;
               break;
            }
            _loc7_ = _loc7_ + 1;
         }
         _loc8_ = 0;
         while(_loc8_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
         {
            if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc8_] == this._eaLocalDataProvider[_loc5_].type)
            {
               _loc3_ = true;
               this._ctrRune.contentData = this._eaLocalDataProvider[_loc5_];
               _loc6_ = true;
               break;
            }
            _loc8_ = _loc8_ + 1;
         }
         if(!_loc6_)
         {
            _loc2_ = true;
            this._ctrItem.contentData = this._eaLocalDataProvider[_loc5_];
            if(this._ctrItem.contentData != undefined)
            {
               this.hideItemViewer(false);
               this._itvItemViewer.itemData = dofus.datacenter.Item(this._ctrItem.contentData);
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      if(!_loc2_)
      {
         this._ctrItem.contentData = undefined;
      }
      if(!_loc3_)
      {
         this._ctrRune.contentData = undefined;
      }
      if(!_loc4_)
      {
         this._ctrSignature.contentData = undefined;
      }
   }
   function updateLocalData()
   {
      if(this._nUpdateLocalDataVisuallyTimeout != undefined)
      {
         return undefined;
      }
      var _loc2_ = _global.setTimeout(this,"updateLocalDataVisually",50);
      this._nUpdateLocalDataVisuallyTimeout = _loc2_;
   }
   function updateDistantData()
   {
      this._cgDistant.dataProvider = this._eaDistantDataProvider;
      var _loc2_ = dofus.datacenter.Item(this._cgDistant.getContainer(0).contentData);
      if(_loc2_ != undefined)
      {
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = _loc2_;
      }
      this._bInvalidateDistant = true;
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
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
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      switch(sTargetGrid)
      {
         case "_cgGrid":
            this.api.network.Exchange.movementItem(false,oItem,nValue);
            break;
         case "_cgLocal":
            this.api.network.Exchange.movementItem(true,oItem,nValue);
            break;
         case "_ctrItem":
         case "_ctrRune":
         case "_ctrSignature":
            _loc5_ = false;
            _loc6_ = false;
            switch(sTargetGrid)
            {
               case "_ctrItem":
                  if(this._nForgemagusItemType != oItem.type || !oItem.enhanceable)
                  {
                     return undefined;
                  }
                  _loc7_ = 0;
                  while(_loc7_ < this._eaLocalDataProvider.length)
                  {
                     _loc8_ = false;
                     _loc9_ = 0;
                     while(_loc9_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
                     {
                        if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc9_] == this._eaLocalDataProvider[_loc7_].unicID)
                        {
                           _loc8_ = true;
                        }
                        _loc9_ = _loc9_ + 1;
                     }
                     _loc10_ = 0;
                     while(_loc10_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
                     {
                        if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc10_] == this._eaLocalDataProvider[_loc7_].type)
                        {
                           _loc8_ = true;
                        }
                        _loc10_ = _loc10_ + 1;
                     }
                     if(!_loc8_)
                     {
                        this.api.network.Exchange.movementItem(false,this._eaLocalDataProvider[_loc7_],this._eaLocalDataProvider[_loc7_].Quantity);
                     }
                     _loc7_ = _loc7_ + 1;
                  }
                  _loc5_ = true;
                  break;
               case "_ctrRune":
                  _loc11_ = 0;
                  while(_loc11_ < this._eaLocalDataProvider.length)
                  {
                     _loc12_ = 0;
                     while(_loc12_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
                     {
                        if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc12_] == this._eaLocalDataProvider[_loc11_].type && this._eaLocalDataProvider[_loc11_].unicID != oItem.unicID)
                        {
                           this.api.network.Exchange.movementItem(false,this._eaLocalDataProvider[_loc11_],this._eaLocalDataProvider[_loc11_].Quantity);
                        }
                        _loc12_ = _loc12_ + 1;
                     }
                     _loc11_ = _loc11_ + 1;
                  }
                  break;
               case "_ctrSignature":
                  _loc13_ = 0;
                  while(_loc13_ < this._eaLocalDataProvider.length)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
                     {
                        if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc14_] == this._eaLocalDataProvider[_loc13_].unicID)
                        {
                           this.api.network.Exchange.movementItem(false,this._eaLocalDataProvider[_loc13_],this._eaLocalDataProvider[_loc13_].Quantity);
                        }
                        _loc14_ = _loc14_ + 1;
                     }
                     _loc13_ = _loc13_ + 1;
                  }
                  if(this.getCurrentCraftLevel() < 100)
                  {
                     _loc6_ = true;
                     this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_LEVEL_DOESNT_ALLOW_A_SIGNATURE"),"ERROR_CHAT");
                  }
                  _loc5_ = true;
            }
            if(!_loc6_)
            {
               this.api.network.Exchange.movementItem(true,oItem,!_loc5_ ? nValue : 1);
            }
      }
      if(this._bInvalidateDistant)
      {
         this.api.datacenter.Exchange.clearDistantGarbage();
         this._bInvalidateDistant = false;
      }
   }
   function getCurrentCraftLevel()
   {
      var _loc2_ = this.api.datacenter.Player.Jobs;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = 0;
         while(_loc4_ < _loc2_[_loc3_].skills.length)
         {
            if(dofus.datacenter.Skill(dofus.datacenter.Job(_loc2_[_loc3_]).skills[_loc4_]).id == this._nSkillId)
            {
               return dofus.datacenter.Job(_loc2_[_loc3_]).level;
            }
            _loc4_ = _loc4_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      return 0;
   }
   function setReady()
   {
      if(this.api.datacenter.Exchange.localGarbage.length == 0)
      {
         return undefined;
      }
      this.api.network.Exchange.ready();
   }
   function canDropInGarbage(oItem)
   {
      return true;
   }
   function recordGarbage()
   {
      this._aGarbageMemory = [];
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._eaLocalDataProvider.length)
      {
         _loc3_ = this._eaLocalDataProvider[_loc2_];
         this._aGarbageMemory.push({id:_loc3_.ID,quantity:_loc3_.Quantity});
         _loc2_ = _loc2_ + 1;
      }
   }
   function cleanGarbage()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._eaLocalDataProvider.length)
      {
         _loc3_ = this._eaLocalDataProvider[_loc2_];
         this.api.network.Exchange.movementItem(false,_loc3_,_loc3_.Quantity);
         _loc2_ = _loc2_ + 1;
      }
   }
   function recallGarbageMemory()
   {
      if(this._aGarbageMemory == undefined || this._aGarbageMemory.length == 0)
      {
         return false;
      }
      this.cleanGarbage();
      var _loc2_ = 0;
      var _loc3_;
      var _loc4_;
      while(_loc2_ < this._aGarbageMemory.length)
      {
         _loc3_ = this._aGarbageMemory[_loc2_];
         _loc4_ = this._eaDataProvider.findFirstItem("ID",_loc3_.id);
         if(_loc4_.index == -1)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_NO_RESOURCE"),"ERROR_BOX",{name:"NotEnougth"});
            return false;
         }
         if(_loc4_.item.Quantity < _loc3_.quantity)
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_NOT_ENOUGHT",[_loc4_.item.name]),"ERROR_BOX",{name:"NotEnougth"});
            return false;
         }
         this.api.network.Exchange.movementItem(true,_loc4_.item,_loc3_.quantity);
         _loc2_ = _loc2_ + 1;
      }
      return true;
   }
   function nextCraft()
   {
      ank.utils.Timer.setTimer(this,"doNextCraft",this,this.doNextCraft,250);
   }
   function doNextCraft()
   {
      if(this.recallGarbageMemory() == false)
      {
         this.stopMakeAll();
      }
   }
   function stopMakeAll()
   {
      ank.utils.Timer.removeTimer(this,"doNextCraft");
      this._bMakeAll = false;
      this._cgLocal.dataProvider = this.api.datacenter.Exchange.localGarbage;
      this.updateData();
      this.updateDistantData();
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
      this.updateDataVisually(_loc3_);
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
   function kamaChanged(oEvent)
   {
      this._lblKama.text = new ank.utils.ExtendedString(oEvent.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.target)
      {
         case this._eaLocalDataProvider:
            if(this._bMakeAll)
            {
               if(this._eaLocalDataProvider.length == 0)
               {
                  this.nextCraft();
               }
               else if(this._aGarbageMemory.length != undefined && this._aGarbageMemory.length == this._eaLocalDataProvider.length)
               {
                  this.setReady();
               }
            }
            else
            {
               this.updateLocalData();
            }
            return;
         case this._eaDistantDataProvider:
            if(!this._bMakeAll && !this._bIsLooping)
            {
               this.updateDistantData();
            }
            return;
         case this._eaDataProvider:
            if(!this._bMakeAll && !this._bIsLooping)
            {
               this.updateData();
               if(this._sCurrentItemSearch != "")
               {
                  this.searchItem(this._sCurrentItemSearch);
               }
            }
            return;
         default:
            if(!this._bMakeAll && !this._bIsLooping)
            {
               this.updateData();
               this.updateLocalData();
               this.updateDistantData();
            }
            return;
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
   function onCraftLoopEnd()
   {
      this._bIsLooping = false;
      this._nCurrentQuantity = 1;
      this._btnLoop.label = this.api.lang.getText("APPLY_MULTIPLE_RUNES");
      this._btnOneShot.enabled = true;
   }
   function repeatCraft()
   {
      var _loc2_ = this._ctrRune.contentData.Quantity - 1;
      if(_loc2_ <= 1)
      {
         return undefined;
      }
      this._bIsLooping = true;
      this.api.network.Exchange.repeatCraft(_loc2_);
      this._btnLoop.label = this.api.lang.getText("STOP_WORD");
      this._btnOneShot.enabled = false;
   }
   function checkIsBaka()
   {
      if(this._ctrItem.contentData == undefined || this._ctrRune.contentData == undefined)
      {
         this.api.kernel.showMessage(this.api.lang.getText("ERROR_WORD"),this.api.lang.getText("FM_ERROR_NO_ITEMS"),"ERROR_BOX");
         return true;
      }
      return false;
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      var _loc0_;
      if((_loc0_ = sShortcut) === "MERGE_RUNE")
      {
         if(this.checkIsBaka())
         {
            _loc3_ = false;
         }
         else
         {
            this.recordGarbage();
            this.setReady();
            _loc3_ = false;
         }
      }
      return _loc3_;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            return;
         case this._btnOneShot:
            if(this.checkIsBaka())
            {
               return undefined;
            }
            this.recordGarbage();
            this.setReady();
            return;
            break;
         case this._btnLoop:
            if(this._bIsLooping)
            {
               this.api.network.Exchange.stopRepeatCraft();
               return undefined;
            }
            if(this.checkIsBaka())
            {
               return undefined;
            }
            this.recordGarbage();
            this.setReady();
            this.addToQueue({object:this,method:this.repeatCraft});
            return;
            break;
         case this._ctrItem:
         case this._ctrRune:
         case this._ctrSignature:
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
            return;
         case this._btnSearch:
            this.enableSearch(this._btnSearch.selected);
            if(!this._btnSearch.selected)
            {
               this.updateDataVisually(this._eaDataProvider);
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
                     this._iifFilter = new dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter();
                     break;
                  case this._btnFilterNonEquipement:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_NONEQUIPEMENT;
                     break;
                  case this._btnFilterRessoureces:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_RESSOURCES;
                     break;
                  case this._btnFilterSoul:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_SOUL;
                     break;
                  case this._btnFilterRunes:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
                     break;
                  case this._btnFilterCards:
                     this._aSelectedSuperTypes = dofus.Constants.FILTER_CARDS;
               }
               this.updateData(true);
            }
            else
            {
               oEvent.target.selected = true;
            }
            return;
      }
   }
   function dblClick(oEvent)
   {
      oEvent.owner = this._cgLocal;
      this.dblClickItem(oEvent);
   }
   function drag(oEvent)
   {
      this.dragItem(oEvent);
   }
   function drop(oEvent)
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
      if(_loc3_.position == -2)
      {
         return undefined;
      }
      if(!this.canDropInGarbage(_loc3_))
      {
         return undefined;
      }
      var _loc4_ = false;
      var _loc5_ = false;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      switch(oEvent.target)
      {
         case this._ctrItem:
            _loc4_ = _loc5_ = true;
            _loc6_ = 0;
            while(_loc6_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
            {
               if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc6_] == _loc3_.type)
               {
                  _loc4_ = false;
               }
               _loc6_ = _loc6_ + 1;
            }
            _loc7_ = 0;
            while(_loc7_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
            {
               if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc7_] == _loc3_.unicID)
               {
                  _loc4_ = false;
               }
               _loc7_ = _loc7_ + 1;
            }
            break;
         case this._ctrRune:
            _loc8_ = 0;
            while(_loc8_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
            {
               if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc8_] == _loc3_.type)
               {
                  _loc4_ = true;
               }
               _loc8_ = _loc8_ + 1;
            }
            break;
         case this._ctrSignature:
            _loc9_ = 0;
            while(_loc9_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
            {
               if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc9_] == _loc3_.unicID)
               {
                  _loc4_ = true;
               }
               _loc9_ = _loc9_ + 1;
            }
            _loc5_ = true;
      }
      if(!_loc4_)
      {
         return undefined;
      }
      var _loc10_;
      if(!_loc5_ && _loc3_.Quantity > 1)
      {
         _loc10_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc3_.Quantity,params:{targetType:"item",oItem:_loc3_,targetGrid:oEvent.target._name}});
         _loc10_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(oEvent.target._name,_loc3_,1);
      }
   }
   function updateForgemagusResult(oItem)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      _loc3_.push(oItem);
      this._mcBlinkPay = _loc3_;
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
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = _loc3_.Quantity;
      var _loc5_ = oEvent.owner._name;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(_loc5_)
      {
         case "_cgGrid":
            if(this.canDropInGarbage(_loc3_))
            {
               _loc7_ = 0;
               while(_loc7_ < dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length && _loc6_ == undefined)
               {
                  if(dofus.graphics.gapi.ui.ForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc7_] == _loc3_.unicID)
                  {
                     _loc6_ = "_ctrSignature";
                  }
                  _loc7_ = _loc7_ + 1;
               }
               _loc8_ = 0;
               while(_loc8_ < dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length && _loc6_ == undefined)
               {
                  if(dofus.graphics.gapi.ui.ForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc8_] == _loc3_.type)
                  {
                     _loc6_ = "_ctrRune";
                  }
                  _loc8_ = _loc8_ + 1;
               }
               if(_loc6_ == undefined)
               {
                  _loc6_ = "_ctrItem";
               }
               this.validateDrop(_loc6_,_loc3_,_loc4_);
            }
            break;
         case "_cgLocal":
            this.validateDrop("_cgGrid",_loc3_,_loc4_);
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
            if(!this.canDropInGarbage(_loc3_))
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
      var _loc3_;
      switch(oEvent.params.targetType)
      {
         case "item":
            this.validateDrop(oEvent.params.targetGrid,oEvent.params.oItem,oEvent.value);
            break;
         case "repeat":
            _loc3_ = Number(oEvent.value);
            if(_loc3_ < 1 || (_loc3_ == undefined || _global.isNaN(_loc3_)))
            {
               _loc3_ = 1;
            }
            this._nCurrentQuantity = _loc3_;
         default:
            return;
      }
   }
   function itemSelected(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "_cbTypes")
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.ui.ForgemagusCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name] = this._nSelectedTypeID;
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
         this.updateDataVisually(this._eaDataProvider);
      }
   }
   function optionChanged(oEvent_)
   {
      if(oEvent_.key == "HideInventoryItemsCornerIcon")
      {
         this.updateData(true);
         if(this._sCurrentItemSearch != "")
         {
            this.searchItem(this._sCurrentItemSearch);
         }
      }
   }
}
