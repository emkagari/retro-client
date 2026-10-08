class dofus.graphics.gapi.ui.craft.SecureForgemagusCraft extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSelectedSuperTypes;
   var _bFiligraneVisible;
   var _bIsLooping;
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
   var _btnValidate;
   var _cbTypes;
   var _cgCoop;
   var _cgCraft;
   var _cgGrid;
   var _ctrItem;
   var _ctrRune;
   var _ctrSignature;
   var _currentOverContainer;
   var _eaBagDataProvider;
   var _eaCraftDataProvider;
   var _eaDataProvider;
   var _eaReadyDataProvider;
   var _iifFilter;
   var _isLocked;
   var _itvItemViewer;
   var _lblKama;
   var _lblRuneTitle;
   var _lblSignature;
   var _lblSignatureTitle;
   var _lblSkill;
   var _mcArrow_;
   var _mcPayIfSuccessKama;
   var _nCurrentKama;
   var _nForgemagusItemType;
   var _nJobLevel;
   var _nSkillId;
   var _nUpdateCraftDataVisuallyTimeout;
   var _nUpdateFullDataVisuallyTimeout;
   var _sSourceDrag;
   var _srSearch;
   var _tiSearch;
   var _winCoopInventory;
   var _winHistory;
   var _winInventory;
   var _winItemViewer;
   var addToQueue;
   var api;
   var gapi;
   var setMovieClipTransform;
   static var CLASS_NAME = "ForgemagusCraft";
   static var GRID_CONTAINER_WIDTH = 38;
   static var READY_COLOR = {ra:70,rb:0,ga:70,gb:0,ba:70,bb:0};
   static var NON_READY_COLOR = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0};
   static var TYPES_ALLOWED_AS_COMPONENT = [26,78];
   static var ITEMS_ALLOWED_AS_SIGNATURE = [7508];
   var _nSelectedTypeID = 0;
   var _sCurrentItemSearch = "";
   function SecureForgemagusCraft()
   {
      super();
      this._winHistory._visible = false;
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
   function set skillId(nSkillId)
   {
      this._nSkillId = Number(nSkillId);
      this._nForgemagusItemType = this.api.lang.getSkillForgemagus(this._nSkillId);
   }
   function set jobLevel(nJobLevel)
   {
      this._nJobLevel = nJobLevel;
   }
   function get _cgPay()
   {
      return this.api.datacenter.Basics.aks_exchange_echangeType == 13;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider = eaDataProvider;
   }
   function set bagDataProvider(eaBagDataProvider)
   {
      this._eaBagDataProvider = eaBagDataProvider;
   }
   function set craftDataProvider(eaCraftDataProvider)
   {
      this._eaCraftDataProvider = eaCraftDataProvider;
   }
   function set _lblDistantKama(eaReadyDataProvider)
   {
      this._eaReadyDataProvider = eaReadyDataProvider;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.CLASS_NAME);
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
      this._btnSelectedFilterButton = this._btnFilterRunes;
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addListeners});
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
      this._cgCoop.addEventListener("dblClickItem",this);
      this._cgCoop.addEventListener("dropItem",this);
      this._cgCoop.addEventListener("dragItem",this);
      this._cgCoop.addEventListener("selectItem",this);
      this._cgCoop.addEventListener("overItem",this);
      this._cgCoop.addEventListener("outItem",this);
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
      this._btnValidate.addEventListener("click",this);
      this._btnSearch.addEventListener("click",this);
      this._btnSearch.addEventListener("over",this);
      this._btnSearch.addEventListener("out",this);
      this.api.datacenter.Player.addEventListener("kamaChanged",this);
      this.api.datacenter.Exchange.addEventListener("payKamaChange",this);
      this.addToQueue({object:this,method:this.kamaChanged,params:[{value:this.api.datacenter.Player.Kama}]});
      this._cbTypes.addEventListener("itemSelected",this);
      this._tiSearch.addEventListener("change",this);
      this._cgGrid.multipleContainerSelectionEnabled = false;
      this._cgCoop.multipleContainerSelectionEnabled = false;
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this._eaReadyDataProvider.addEventListener("modelChanged",this);
      this._eaCraftDataProvider.addEventListener("modelChanged",this);
      this._eaBagDataProvider.addEventListener("modelChanged",this);
      this._eaDataProvider.addEventListener("modelChanged",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
   }
   function initTexts()
   {
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winCoopInventory.title = this.api.lang.getText("SHARED_CRAFT_BAG");
      this._lblSkill.text = this.api.lang.getText("SKILL") + " : " + this.api.lang.getSkillText(this._nSkillId).d + " (" + this.api.lang.getText("LEVEL") + " : " + this._nJobLevel + ")";
      this._lblRuneTitle.text = this.api.lang.getText("FM_CRAFT_ITEM");
      this._lblSignatureTitle.text = this.api.lang.getText("FM_CRAFT_RUNE");
      this._lblSignature.text = this.api.lang.getText("FM_CRAFT_SIGNATURE");
      this._btnOneShot.label = this.api.lang.getText("APPLY_ONE_RUNE");
      this._btnLoop.label = this.api.lang.getText("APPLY_MULTIPLE_RUNES");
      if(this._cgPay)
      {
         this._btnValidate.label = this.api.lang.getText("VALIDATE");
      }
      else
      {
         this._btnValidate.label = this.api.lang.getText("TERMINATE_WORD");
      }
      this._mcArrow_.text = this.api.lang.getText("PAY");
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("NAME_MINIMUM_CHARACTERS",[dofus.Constants.INV_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.INV_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function initData()
   {
      this._aSelectedSuperTypes = dofus.Constants.FILTER_RUNES;
      this.dataProvider = this.api.datacenter.Exchange.inventory;
      this.bagDataProvider = this.api.datacenter.Exchange.coopGarbage;
      this.craftDataProvider = this.api.datacenter.Exchange.distantGarbage;
      this._lblDistantKama = this.api.datacenter.Exchange.readyStates;
      this.updateCraftData();
      this.updateBagData();
      this.updateBagStateChange();
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
      var _loc3_ = this.api.datacenter.Basics[dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name];
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
   function updateCraftDataVisually()
   {
      if(this._nUpdateCraftDataVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nUpdateCraftDataVisuallyTimeout);
         this._nUpdateCraftDataVisuallyTimeout = undefined;
      }
      var _loc2_ = false;
      var _loc3_ = false;
      var _loc4_ = false;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < this._eaCraftDataProvider.length)
      {
         _loc6_ = false;
         if(this.isSignature(this._eaCraftDataProvider[_loc5_]))
         {
            _loc4_ = true;
            this._ctrSignature.contentData = this._eaCraftDataProvider[_loc5_];
            _loc6_ = true;
         }
         if(this.isComponent(this._eaCraftDataProvider[_loc5_]))
         {
            _loc3_ = true;
            this._ctrRune.contentData = this._eaCraftDataProvider[_loc5_];
            _loc6_ = true;
         }
         if(!_loc6_)
         {
            _loc2_ = true;
            this._ctrItem.contentData = this._eaCraftDataProvider[_loc5_];
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
   function updateCraftData()
   {
      if(this._nUpdateCraftDataVisuallyTimeout != undefined)
      {
         return undefined;
      }
      var _loc2_ = _global.setTimeout(this,"updateCraftDataVisually",50);
      this._nUpdateCraftDataVisuallyTimeout = _loc2_;
   }
   function updateBagData()
   {
      this._cgCoop.dataProvider = this._eaBagDataProvider;
   }
   function updateBagStateChange()
   {
      this._isLocked = !this._cgPay ? this._eaReadyDataProvider[1] : this._eaReadyDataProvider[0];
      this._mcPayIfSuccessKama.enabled = this._cgPay && !this._isLocked;
      if(this._cgPay)
      {
         this._cgGrid.enabled = !this._isLocked;
         this._cgCoop.enabled = !this._isLocked;
         this._btnOneShot.enabled = false;
         this._btnLoop.enabled = false;
         this._ctrSignature.enabled = false;
         this._ctrRune.enabled = false;
         this._ctrItem.enabled = false;
         if(this._isLocked)
         {
            this._btnValidate.label = this.api.lang.getText("TERMINATE_WORD");
            this.updateUIState(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.READY_COLOR,dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.NON_READY_COLOR);
         }
         else
         {
            this._btnValidate.label = this.api.lang.getText("VALIDATE");
            this.updateUIState(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.NON_READY_COLOR,dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.READY_COLOR);
         }
      }
      else
      {
         this._btnValidate.label = this.api.lang.getText("TERMINATE_WORD");
         this._btnValidate.enabled = this._isLocked;
         this._cgGrid.enabled = this._isLocked;
         this._cgCoop.enabled = this._isLocked;
         this._ctrSignature.enabled = this._isLocked;
         this._ctrRune.enabled = this._isLocked;
         this._ctrItem.enabled = this._isLocked;
         this._btnOneShot.enabled = this._isLocked;
         this._btnLoop.enabled = this._isLocked;
         if(this._isLocked)
         {
            this.updateUIState(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.NON_READY_COLOR,dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.NON_READY_COLOR);
         }
         else
         {
            this.updateUIState(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.READY_COLOR,dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.READY_COLOR);
         }
      }
   }
   function updateUIState(oInvColor, oCraftColor)
   {
      this.setMovieClipTransform(this._winCoopInventory,oInvColor);
      this.setMovieClipTransform(this._cgCoop,oInvColor);
      this.setMovieClipTransform(this._winInventory,oInvColor);
      this.setMovieClipTransform(this._cgGrid,oInvColor);
      this.setMovieClipTransform(this._cgCraft,oCraftColor);
      this.setMovieClipTransform(this._ctrItem,oCraftColor);
      this.setMovieClipTransform(this._ctrRune,oCraftColor);
      this.setMovieClipTransform(this._ctrSignature,oCraftColor);
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
   }
   function validateDrop(sTargetGrid, sSourceGrid, oItem_, nValue_)
   {
      if(nValue_ < 1 || nValue_ == undefined)
      {
         return undefined;
      }
      if(nValue_ > oItem_.Quantity)
      {
         nValue_ = oItem_.Quantity;
      }
      switch(sTargetGrid)
      {
         case "_cgGrid":
            if(this._cgPay && (sSourceGrid == "_cgCoop" && !this._isLocked))
            {
               this.api.network.SecureForgemagusCraft.askRemoveItem(oItem_.ID,nValue_);
            }
            if(!this._cgPay && (sSourceGrid == "_ctrSignature" && (this._isLocked && !this._bIsLooping)))
            {
               this.api.network.SecureForgemagusCraft.askRemoveItem(oItem_.ID,nValue_);
            }
            break;
         case "_cgCoop":
            if(this._cgPay)
            {
               if(sSourceGrid == "_cgGrid" && !this._isLocked)
               {
                  this.api.network.SecureForgemagusCraft.askAddItem(oItem_.ID,nValue_);
               }
            }
            else
            {
               if(!this._isLocked)
               {
                  return;
               }
               if(sSourceGrid == "_ctrRune" || sSourceGrid == "_ctrItem")
               {
                  this.api.network.SecureForgemagusCraft.askMoveItem(false,oItem_.ID,nValue_);
               }
            }
            break;
         case "_ctrItem":
         case "_ctrRune":
            if(!(!this._isLocked || this._cgPay))
            {
               if(sSourceGrid == "_cgCoop")
               {
                  this.api.network.SecureForgemagusCraft.askMoveItem(true,oItem_.ID,nValue_);
               }
            }
            break;
         case "_ctrSignature":
            if(!(!this._isLocked || this._cgPay))
            {
               if(sSourceGrid == "_cgGrid")
               {
                  if(this.getCurrentCraftLevel() < 100)
                  {
                     this.api.kernel.showMessage(undefined,this.api.lang.getText("CRAFT_LEVEL_DOESNT_ALLOW_A_SIGNATURE"),"ERROR_CHAT");
                  }
                  this.api.network.SecureForgemagusCraft.askAddItem(oItem_.ID,nValue_);
               }
            }
         default:
            return;
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
   function setBagStatus(bLock)
   {
      if(!this._cgPay && bLock)
      {
         return undefined;
      }
      this.api.network.SecureForgemagusCraft.askLockBag(bLock);
   }
   function craft()
   {
      this.api.network.Exchange.ready();
   }
   function autoCraft(bAutoCraft)
   {
      if(this._cgPay || !this._isLocked)
      {
         return undefined;
      }
      this.api.network.SecureForgemagusCraft.askAutoCraft(bAutoCraft);
   }
   function validateKama(nValue_)
   {
      if(nValue_ > this.api.datacenter.Player.Kama)
      {
         nValue_ = this.api.datacenter.Player.Kama;
      }
      this.api.network.Exchange.movementPayKama(1,nValue_);
   }
   function isEquip(oItem_)
   {
      return this._nForgemagusItemType == oItem_.type && oItem_.enhanceable;
   }
   function isComponent(oItem_)
   {
      var _loc3_ = 0;
      while(_loc3_ < dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT.length)
      {
         if(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.TYPES_ALLOWED_AS_COMPONENT[_loc3_] == oItem_.type)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function isSignature(oItem_)
   {
      var _loc3_ = 0;
      while(_loc3_ < dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE.length)
      {
         if(dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.ITEMS_ALLOWED_AS_SIGNATURE[_loc3_] == oItem_.unicID)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
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
   function kamaChanged(oEvent_)
   {
      this._lblKama.text = new ank.utils.ExtendedString(oEvent_.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
   }
   function payKamaChange(oEvent_)
   {
      this._nCurrentKama = oEvent_.value;
      this._bFiligraneVisible.text = new ank.utils.ExtendedString(oEvent_.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      if(this._cgPay)
      {
         this._lblKama.text = "" + new ank.utils.ExtendedString(this.api.datacenter.Player.Kama - oEvent_.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3);
      }
   }
   function modelChanged(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._eaCraftDataProvider:
            this.updateCraftData();
            return;
         case this._eaDataProvider:
            if(!this._bIsLooping)
            {
               this.updateData();
               if(this._sCurrentItemSearch != "")
               {
                  this.searchItem(this._sCurrentItemSearch);
               }
            }
            return;
         case this._eaBagDataProvider:
            if(!this._bIsLooping)
            {
               this.updateBagData();
            }
            return;
         case this._eaReadyDataProvider:
            this.updateBagStateChange();
            return;
         default:
            if(!this._bIsLooping)
            {
               this.updateData();
               this.updateCraftData();
               this.updateBagData();
            }
            return;
      }
   }
   function over(oEvent_)
   {
      switch(oEvent_.target)
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
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function onCraftLoopEnd()
   {
      this._bIsLooping = false;
      this._btnLoop.label = this.api.lang.getText("APPLY_MULTIPLE_RUNES");
      if(this._isLocked && !this._cgPay)
      {
         this._btnOneShot.enabled = true;
      }
   }
   function onCraftLoopStart()
   {
      this._bIsLooping = true;
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
            this.craft();
            _loc3_ = false;
         }
      }
      return _loc3_;
   }
   function click(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._btnValidate:
            this.setBagStatus(!this._isLocked);
            return;
         case this._btnClose:
            this.callClose();
            return;
         case this._btnOneShot:
            if(this.checkIsBaka())
            {
               return undefined;
            }
            this.craft();
            return;
            break;
         case this._btnLoop:
            if(!this._bIsLooping && this.checkIsBaka())
            {
               return undefined;
            }
            this.autoCraft(!this._bIsLooping);
            return;
            break;
         case this._ctrItem:
         case this._ctrRune:
         case this._ctrSignature:
            if(oEvent_.target.contentData == undefined)
            {
               this.hideItemViewer(true);
            }
            else
            {
               if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
               {
                  this.api.kernel.GameManager.insertItemInChat(oEvent_.target.contentData);
                  return undefined;
               }
               this.hideItemViewer(false);
               this._itvItemViewer.itemData = oEvent_.target.contentData;
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
            if(oEvent_.target != this._btnSelectedFilterButton)
            {
               this._btnSelectedFilterButton.selected = false;
               this._btnSelectedFilterButton = oEvent_.target;
               this._iifFilter = undefined;
               if(this._btnSearch.selected)
               {
                  this.enableSearch(false);
                  this._btnSearch.selected = false;
               }
               switch(oEvent_.target)
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
               oEvent_.target.selected = true;
            }
            return;
      }
   }
   function dblClick(oEvent_)
   {
      this.dblClickItem(oEvent_);
   }
   function drag(oEvent_)
   {
      this.dragItem(oEvent_);
   }
   function drop(oEvent_)
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
      if(this._cgPay && this._isLocked)
      {
         return undefined;
      }
      if(!this._cgPay && (this._sSourceDrag == "_cgGrid" && oEvent_.target != this._ctrSignature))
      {
         return undefined;
      }
      var _loc4_ = false;
      switch(oEvent_.target)
      {
         case this._ctrItem:
            if(!this.isEquip(_loc3_))
            {
               return undefined;
            }
            _loc4_ = true;
            break;
         case this._ctrRune:
            if(!this.isComponent(_loc3_))
            {
               return undefined;
            }
            break;
         case this._ctrSignature:
            if(!this.isSignature(_loc3_))
            {
               return undefined;
            }
            _loc4_ = true;
      }
      var _loc5_;
      if(!_loc4_ && _loc3_.Quantity > 1)
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc3_.Quantity,params:{targetType:"item",oItem:_loc3_,targetGrid:oEvent_.target._name}});
         _loc5_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(oEvent_.target._name,this._sSourceDrag,_loc3_,1);
      }
   }
   function overItem(oEvent_)
   {
      var _loc3_ = oEvent_.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
      this._currentOverContainer = _loc3_;
   }
   function outItem(oEvent_)
   {
      this.gapi.hideTooltip();
      this._currentOverContainer = undefined;
   }
   function dblClickItem(oEvent_)
   {
      if(this._cgPay && this._isLocked)
      {
         return undefined;
      }
      if(!this._cgPay && !this._isLocked)
      {
         return undefined;
      }
      var _loc3_ = oEvent_.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = _loc3_.Quantity;
      var _loc5_ = oEvent_.owner._name;
      if(_loc5_ == undefined)
      {
         _loc5_ = oEvent_.target._name;
      }
      var _loc6_;
      switch(_loc5_)
      {
         case "_cgGrid":
            if(this._isLocked && (!this._bIsLooping && !this._cgPay))
            {
               if(this.isSignature(_loc3_))
               {
                  this.validateDrop("_ctrSignature",_loc5_,_loc3_,_loc4_);
               }
            }
            if(!this._isLocked && this._cgPay)
            {
               this.validateDrop("_cgCoop",_loc5_,_loc3_,_loc4_);
            }
            break;
         case "_cgCoop":
            if(this._isLocked && (!this._bIsLooping && !this._cgPay))
            {
               if(this.isComponent(_loc3_))
               {
                  _loc6_ = "_ctrRune";
               }
               if(_loc6_ == undefined)
               {
                  _loc6_ = "_ctrItem";
               }
               this.validateDrop(_loc6_,_loc5_,_loc3_,_loc4_);
            }
            if(!this._isLocked && this._cgPay)
            {
               this.validateDrop("_cgGrid",_loc5_,_loc3_,_loc4_);
            }
            break;
         case "_ctrItem":
         case "_ctrRune":
            if(this._isLocked && (!this._bIsLooping && !this._cgPay))
            {
               this.validateDrop("_cgCoop",_loc5_,_loc3_,_loc4_);
            }
            break;
         case "_ctrSignature":
            if(this._isLocked && (!this._bIsLooping && !this._cgPay))
            {
               this.validateDrop("_cgGrid",_loc5_,_loc3_,_loc4_);
            }
         default:
            return;
      }
   }
   function dragItem(oEvent_)
   {
      if(oEvent_.target != this._ctrItem && (oEvent_.target != this._ctrRune && oEvent_.target != this._ctrSignature))
      {
         this._sSourceDrag = oEvent_.target._parent._parent._name;
      }
      else
      {
         this._sSourceDrag = oEvent_.target._name;
      }
      this.gapi.removeCursor();
      if(oEvent_.target.contentData == undefined)
      {
         return undefined;
      }
      this.gapi.setCursor(oEvent_.target.contentData);
   }
   function dropItem(oEvent_)
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
      var _loc4_ = oEvent_.target._parent._parent._name;
      if(!this._cgPay && this._sSourceDrag == "_cgGrid")
      {
         return undefined;
      }
      var _loc5_;
      if(_loc3_.Quantity > 1)
      {
         _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc3_.Quantity,params:{targetType:"item",oItem:_loc3_,targetGrid:_loc4_}});
         _loc5_.addEventListener("validate",this);
      }
      else
      {
         this.validateDrop(_loc4_,this._sSourceDrag,_loc3_,1);
      }
   }
   function selectItem(oEvent_)
   {
      if(oEvent_.target.contentData == undefined)
      {
         this.hideItemViewer(true);
      }
      else
      {
         if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
         {
            this.api.kernel.GameManager.insertItemInChat(oEvent_.target.contentData);
            return undefined;
         }
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent_.target.contentData;
      }
   }
   function validate(oEvent_)
   {
      switch(oEvent_.params.targetType)
      {
         case "item":
            this.validateDrop(oEvent_.params.targetGrid,this._sSourceDrag,oEvent_.params.oItem,oEvent_.value);
            break;
         case "kama":
            this.validateKama(oEvent_.value);
         default:
            return;
      }
   }
   function itemSelected(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target._name) === "_cbTypes")
      {
         this._nSelectedTypeID = this._cbTypes.selectedItem.id;
         this.api.datacenter.Basics[dofus.graphics.gapi.ui.craft.SecureForgemagusCraft.CLASS_NAME + "_subfilter_" + this._btnSelectedFilterButton._name] = this._nSelectedTypeID;
         this.updateData();
      }
   }
   function askKamaQuantity(nPayBar)
   {
      var _loc3_ = 0;
      var _loc4_ = this.api.datacenter.Player.Kama;
      var _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:this._nCurrentKama,min:0,max:_loc4_,params:{targetType:"kama"}});
      _loc5_.addEventListener("validate",this);
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
