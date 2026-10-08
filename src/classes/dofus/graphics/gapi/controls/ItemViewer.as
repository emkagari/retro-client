class dofus.graphics.gapi.controls.ItemViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bDesc;
   var _bPrice;
   var _bShowBaseEffects;
   var _btnAction;
   var _btnDialog;
   var _btnTabCharacteristics;
   var _btnTabConditions;
   var _btnTabEffects;
   var _btnUnlink;
   var _cgInfos;
   var _lblLevel;
   var _lblName;
   var _lblWeight;
   var _ldrExtraIcon;
   var _ldrIcon;
   var _ldrMoneyIcon;
   var _ldrTwoHanded;
   var _lstInfos;
   var _mcKamaSymbol;
   var _mcTitle;
   var _nDisplayWidth;
   var _oItem;
   var _parent;
   var _pbEthereal;
   var _txtDescription;
   var _txtPriceLabel;
   var addToQueue;
   var dispatchEvent;
   var gapi;
   var setMovieClipTransform;
   static var CLASS_NAME = "ItemViewer";
   static var KEYCHAIN_ITEM_ID = 10207;
   var _bDestroyButton = false;
   var _bTargetButton = false;
   var _bUseButton = false;
   var _sCurrentTab = "Effects";
   function ItemViewer()
   {
      super();
   }
   function set destroyButton(bDestroyButton)
   {
      this._bDestroyButton = bDestroyButton;
   }
   function get destroyButton()
   {
      return this._bDestroyButton;
   }
   function set targetButton(bTargetButton)
   {
      this._bTargetButton = bTargetButton;
   }
   function get targetButton()
   {
      return this._bTargetButton;
   }
   function set useButton(bUseButton)
   {
      this._bUseButton = bUseButton;
   }
   function get useButton()
   {
      return this._bUseButton;
   }
   function set displayPrice(bDisplayPrice)
   {
      this._bPrice = bDisplayPrice;
   }
   function get displayPrice()
   {
      return this._bPrice;
   }
   function set showBaseEffects(bShowBaseEffects)
   {
      this._bShowBaseEffects = bShowBaseEffects;
   }
   function get showBaseEffects()
   {
      return this._bShowBaseEffects;
   }
   function set hideDesc(bDisplayDesc)
   {
      this._bDesc = !bDisplayDesc;
      this._txtDescription._visible = this._bDesc;
      this._txtDescription.scrollBarRight = this._bDesc;
   }
   function get hideDesc()
   {
      return this._bDesc;
   }
   function set itemData(oItem)
   {
      this._oItem = oItem;
      this.addToQueue({object:this,method:this.showItemData,params:[oItem]});
   }
   function get itemData()
   {
      return this._oItem;
   }
   function set displayWidth(nDisplayWidth)
   {
      this._nDisplayWidth = nDisplayWidth + 2;
   }
   function get cornerIconFile()
   {
      if(this._oItem.isLock)
      {
         return "Favorite";
      }
      if(this._oItem.hasCeremonialSkinItem || (this._oItem.hasCustomSkinItem || this._oItem.isAssociateWithLivingItem))
      {
         return "Ceremonial";
      }
      if(!this._oItem.canBeExchange)
      {
         return "Chaine_Lock";
      }
      return "";
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.ItemViewer.CLASS_NAME);
   }
   function arrange()
   {
      this._lstInfos._width = this._nDisplayWidth - this._lstInfos._x;
      this._txtDescription._width = this._nDisplayWidth - this._txtDescription._x - 1;
      this._mcTitle._width = this._nDisplayWidth - this._mcTitle._x;
      this._lblLevel._x = this._nDisplayWidth - (316 - this._lblLevel._x);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this._btnTabCharacteristics._visible = false;
      this._pbEthereal._visible = false;
      this._ldrTwoHanded._visible = false;
      this._ldrExtraIcon._visible = false;
      this._btnUnlink._visible = false;
   }
   function initTexts()
   {
      this._btnTabEffects.label = this.api.lang.getText("EFFECTS");
      this._btnTabConditions.label = this.api.lang.getText("CONDITIONS");
      this._btnTabCharacteristics.label = this.api.lang.getText("CHARACTERISTICS");
   }
   function addListeners()
   {
      this._btnAction.addEventListener("click",this);
      this._btnAction.addEventListener("over",this);
      this._btnAction.addEventListener("out",this);
      this._btnDialog.addEventListener("over",this);
      this._btnDialog.addEventListener("out",this);
      this._btnUnlink.addEventListener("click",this);
      this._btnTabEffects.addEventListener("click",this);
      this._btnTabCharacteristics.addEventListener("click",this);
      this._btnTabConditions.addEventListener("click",this);
      this._pbEthereal.addEventListener("over",this);
      this._pbEthereal.addEventListener("out",this);
      this._ldrTwoHanded.addEventListener("over",this);
      this._ldrTwoHanded.addEventListener("out",this);
      this._ldrExtraIcon.addEventListener("over",this);
      this._ldrExtraIcon.addEventListener("out",this);
      this._cgInfos.addEventListener("overItem",this);
      this._cgInfos.addEventListener("outItem",this);
      this._cgInfos.addEventListener("scrollGrid",this);
   }
   function showItemData(oItem)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(oItem != undefined)
      {
         this._lblName.text = oItem.name;
         if(oItem.style == "")
         {
            this._lblName.styleName = "WhiteLeftMediumBoldLabel";
         }
         else
         {
            this._lblName.styleName = oItem.style + "LeftMediumBoldLabel";
         }
         this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL") + oItem.level;
         this._txtDescription.text = oItem.description;
         this._ldrIcon.contentParams = oItem.params;
         this._ldrIcon.contentPath = oItem.iconFile;
         this.getItemEffects(this._bShowBaseEffects);
         if(oItem.superType == 2 && !oItem.isCeremonial)
         {
            this._btnTabCharacteristics._visible = true;
         }
         else
         {
            if(this._sCurrentTab == "Characteristics")
            {
               this.setCurrentTab("Effects");
            }
            this._btnTabCharacteristics._visible = false;
         }
         this._txtPriceLabel._visible = this._bPrice;
         if(this._bPrice)
         {
            _loc3_ = oItem.price != undefined ? this.api.lang.getText("UNIT_PRICE") + " : " + new ank.utils.ExtendedString(oItem.price).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) : "";
            if(oItem.averagePrice != undefined && oItem.averagePrice != -1)
            {
               _loc3_ = "<u>Avg</u> : " + new ank.utils.ExtendedString(oItem.averagePrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + ", " + _loc3_;
            }
         }
         if(!oItem.hasCustomMoneyItemId)
         {
            this._mcKamaSymbol._visible = this._bPrice;
            this._ldrMoneyIcon._visible = false;
         }
         else
         {
            this._mcKamaSymbol._visible = false;
            this._ldrMoneyIcon._visible = this._bPrice;
            if(this._bPrice)
            {
               _loc4_ = new dofus.datacenter.Item(0,oItem.customMoneyItemId);
               this._ldrMoneyIcon.contentParams = _loc4_.params;
               this._ldrMoneyIcon.contentPath = _loc4_.iconFile;
               _loc3_ = _loc3_ + "x " + _loc4_.name;
            }
         }
         if(this._bPrice)
         {
            this._txtPriceLabel.text = _loc3_;
         }
         this._lblWeight.text = oItem.weight + " " + ank.utils.PatternDecoder.combine(this._parent.api.lang.getText("PODS"),"m",oItem.weight < 2);
         if(dofus.Constants.DEBUG)
         {
            _loc5_ = " (" + oItem.type + "/" + oItem.gfx;
            _loc5_ += ")";
            this._lblWeight.text += _loc5_;
         }
         if(oItem.durability != -1 && oItem.durability != undefined)
         {
            this._pbEthereal.maximum = oItem.durabilityMax;
            this._pbEthereal.value = oItem.durability;
            this._pbEthereal._visible = true;
            if(this._pbEthereal.value / this._pbEthereal.maximum < 0.2)
            {
               this._pbEthereal.styleName = "EtherealCriticalProgressBar";
            }
            else
            {
               this._pbEthereal.styleName = "EtherealNormalProgressBar";
            }
            this._pbEthereal._width = !(oItem.hasCeremonialSkinItem || oItem.hasCustomSkinItem) ? 62 : 40;
         }
         else if(oItem.skinDurability != -1 && oItem.skinDurability != undefined)
         {
            this._pbEthereal.maximum = oItem.skinDurabilityMax;
            this._pbEthereal.value = oItem.skinDurability;
            this._pbEthereal._visible = true;
            if(this._pbEthereal.value / this._pbEthereal.maximum < 0.2)
            {
               this._pbEthereal.styleName = "SkinDurabilityCriticalProgressBar";
            }
            else
            {
               this._pbEthereal.styleName = "SkinDurabilityNormalProgressBar";
            }
            this._pbEthereal._width = !(oItem.hasCeremonialSkinItem || oItem.hasCustomSkinItem) ? 62 : 40;
         }
         else
         {
            this._pbEthereal._visible = false;
         }
         this._btnUnlink._visible = oItem.ID != 0 && (oItem.hasCeremonialSkinItem || oItem.hasCustomSkinItem);
         this._ldrTwoHanded.contentPath = "ItemViewerTwoHand";
         this._ldrExtraIcon.contentPath = this.cornerIconFile;
         this._ldrTwoHanded._visible = oItem.needTwoHands;
         this._ldrExtraIcon._visible = this._ldrExtraIcon.contentPath != "";
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblLevel.text = "";
         this._txtDescription.text = "";
         this._ldrIcon.contentPath = "";
         this._ldrMoneyIcon.contentPath = "";
         this._lstInfos.removeAll();
         this._cgInfos.clear();
         this._txtPriceLabel.text = "";
         this._lblWeight.text = "";
         this._pbEthereal._visible = false;
         this._ldrTwoHanded._visible = false;
         this._ldrExtraIcon._visible = false;
         this._mcKamaSymbol._visible = false;
         this._ldrMoneyIcon._visible = false;
         this._txtPriceLabel._visible = false;
      }
   }
   function updateCurrentTabInformations()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      switch(this._sCurrentTab)
      {
         case "Effects":
            if(this._oItem.unicID == dofus.graphics.gapi.controls.ItemViewer.KEYCHAIN_ITEM_ID)
            {
               _loc3_ = this._oItem.visibleEffects;
               for(var s in _loc3_)
               {
                  _loc4_ = _loc3_[s];
                  _loc5_ = new dofus.datacenter.Item(undefined,_loc4_.param1);
                  _loc5_.isEmptyKey = _loc4_.param3 == 0;
                  _loc2_.push(_loc5_);
               }
            }
            else
            {
               _loc6_ = this._oItem.visibleEffects;
               for(var s in _loc6_)
               {
                  _loc2_.push(_loc6_[s]);
               }
            }
            break;
         case "Characteristics":
            _loc7_ = this._oItem.characteristics;
            for(var s in _loc7_)
            {
               if(_loc7_[s].length > 0)
               {
                  _loc2_.push(_loc7_[s]);
               }
            }
            break;
         case "Conditions":
            _loc8_ = this._oItem.conditions;
            for(var s in _loc8_)
            {
               if(_loc8_[s].length > 0)
               {
                  _loc2_.push(_loc8_[s]);
               }
            }
      }
      var _loc9_;
      if(this._oItem.unicID == dofus.graphics.gapi.controls.ItemViewer.KEYCHAIN_ITEM_ID && this._sCurrentTab == "Effects")
      {
         _loc9_ = function(a_, b_)
         {
            return a_.level - b_.level;
         };
         _loc2_.sort(_loc9_);
         this._cgInfos.dataProvider = _loc2_;
         this.addToQueue({object:this,method:this.updateKeyGrid});
      }
      else
      {
         _loc2_.reverse();
         this._lstInfos.dataProvider = _loc2_;
      }
   }
   function updateKeyGrid()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._cgInfos.dataProvider.length)
      {
         _loc3_ = this._cgInfos.getContainer(_loc2_);
         if(_loc3_.contentData != undefined && _loc3_.contentData.isEmptyKey)
         {
            this.setMovieClipTransform(_loc3_.content,dofus.Constants.INACTIVE_TRANSFORM);
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      if(sNewTab != "Effects")
      {
         _loc4_.enabled = false;
      }
      this._sCurrentTab = sNewTab;
      this.getItemEffects(this._bShowBaseEffects);
   }
   function getItemEffects(bShowBaseEffects)
   {
      var _loc3_ = this._oItem.unicID == dofus.graphics.gapi.controls.ItemViewer.KEYCHAIN_ITEM_ID && this._sCurrentTab == "Effects";
      this._lstInfos._visible = !_loc3_;
      this._cgInfos._visible = _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(bShowBaseEffects)
      {
         if(this._sCurrentTab == "Effects")
         {
            _loc4_ = dofus.datacenter.Item.getBaseItemEffects(this._oItem.unicID);
            _loc5_ = dofus.datacenter.Item.getItemDescriptionEffects(_loc4_,_loc4_,true,this._oItem.isReallyEnhanceable);
            _loc6_ = new ank.utils.ExtendedArray();
            for(var s in _loc5_)
            {
               if(_loc5_[s].description.length > 0)
               {
                  _loc6_.push(_loc5_[s]);
               }
            }
            _loc6_.reverse();
            this._lstInfos.dataProvider = _loc6_;
         }
         else
         {
            this.updateCurrentTabInformations();
         }
      }
      else
      {
         this.updateCurrentTabInformations();
      }
   }
   function getOverExtraIconText()
   {
      switch(this._ldrExtraIcon.contentPath)
      {
         case "Favorite":
            return "FAV_LOCK_INFORMATIONS";
         case "Ceremonial":
            return "CEREMONIAL_INFORMATIONS";
         case "Chaine_Lock":
            return "ITEM_LOCK_INFORMATIONS";
         default:
            return;
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      switch(oEvent.target._name)
      {
         case "_btnTabEffects":
            if(this._sCurrentTab == "Effects")
            {
               _loc3_ = this["_btnTab" + this._sCurrentTab];
               _loc3_.selected = false;
               this._bShowBaseEffects = !this._bShowBaseEffects;
               this.getItemEffects(this._bShowBaseEffects);
            }
            else
            {
               this.setCurrentTab("Effects");
            }
            break;
         case "_btnTabCharacteristics":
            this.setCurrentTab("Characteristics");
            break;
         case "_btnTabConditions":
            this.setCurrentTab("Conditions");
            break;
         case "_btnAction":
            this.createActionPopupMenu(this._oItem);
            break;
         case "_btnUnlink":
            if(this.api.ui.getUIComponent("Inventory") == undefined)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
            }
            else if(this._oItem.hasCustomSkinItem)
            {
               this.dispatchEvent({type:"destroyMimibiote",item:this._oItem});
            }
            else if(this._oItem.hasCeremonialSkinItem)
            {
               this.dispatchEvent({type:"unlinkSkinItem",item:this._oItem});
            }
         default:
            return;
      }
   }
   function createActionPopupMenu(oItem)
   {
      var _loc3_ = this.api.ui.createPopupMenu();
      _loc3_.addStaticItem(oItem.name);
      if(this._bDestroyButton && oItem.canUse)
      {
         _loc3_.addItem(this.api.lang.getText("CLICK_TO_USE"),this,this.dispatchEvent,[{type:"useItem",item:oItem}]);
         _loc3_.addItem(this.api.lang.getText("CLICK_TO_BATCH_USE"),this,this.dispatchEvent,[{type:"batchUseItem",item:oItem}]);
      }
      if(oItem.canBeUnlock && (oItem.ID != 0 && !this.api.datacenter.Player.isBusy))
      {
         _loc3_.addItem(this.api.lang.getText("UNFAV_ITEM"),this,this.dispatchEvent,[{type:"unlockItem",item:oItem}],true);
      }
      else if(oItem.canBeLock && (oItem.ID != 0 && !this.api.datacenter.Player.isBusy))
      {
         _loc3_.addItem(this.api.lang.getText("FAV_ITEM"),this,this.dispatchEvent,[{type:"lockItem",item:oItem,delay:-1}],true);
      }
      _loc3_.addItem(this.api.lang.getText("CLICK_TO_INSERT"),this.api.kernel.GameManager,this.api.kernel.GameManager.insertItemInChat,[oItem]);
      if(this._bUseButton && oItem.canTarget)
      {
         _loc3_.addItem(this.api.lang.getText("CLICK_TO_TARGET"),this,this.dispatchEvent,[{type:"targetItem",item:oItem}]);
      }
      _loc3_.addItem(this.api.lang.getText("ASSOCIATE_RECEIPTS"),this.api.ui,this.api.ui.loadUIComponent,["ItemUtility","ItemUtility",{item:oItem},{bAlwaysOnTop:true}]);
      if(oItem.isSearchableInEncyclopedia)
      {
         _loc3_.addItem(this.api.lang.getText("VIEW_IN_ENCYCLOPEDIA"),dofus.graphics.gapi.ui.Encyclopedia,dofus.graphics.gapi.ui.Encyclopedia.openEncyclopediaForItem,[oItem]);
      }
      if(this._bTargetButton && oItem.ID != 0)
      {
         if(oItem.canDestroy || oItem.isUndestroyable)
         {
            _loc3_.addItem(this.api.lang.getText("CLICK_TO_DESTROY"),this,this.dispatchEvent,[{type:"destroyItem",item:oItem}],!oItem.isUndestroyable);
         }
         if(oItem.hasCustomSkinItem)
         {
            _loc3_.addItem(this.api.lang.getText("CLICK_TO_DESTROY_MIMIBIOTE"),this,this.dispatchEvent,[{type:"destroyMimibiote",item:oItem}],true);
         }
         if(oItem.hasCeremonialSkinItem)
         {
            _loc3_.addItem(this.api.lang.getText("REMOVE_CEREMONIAL"),this,this.dispatchEvent,[{type:"unlinkSkinItem",item:oItem}],true);
         }
         if(oItem.isAssociateWithLivingItem)
         {
            _loc3_.addItem(this.api.lang.getText("DISSOCIATE"),this,this.dispatchEvent,[{type:"unlinkLivingItem",item:oItem}],true);
         }
         if(oItem.canBeReinitializedByPlayer)
         {
            _loc3_.addItem(this.api.lang.getText("RESET_PET"),this,this.dispatchEvent,[{type:"reinitializeItem",item:oItem}]);
         }
      }
      if(oItem.isMountCertificate)
      {
         _loc3_.addItem(this.api.lang.getText("VIEW_MOUNT_DETAILS"),this.api.network.Mount,this.api.network.Mount.data,oItem.mountCertificateDetails);
      }
      if(this.api.datacenter.Player.isAuthorized && dofus.Constants.DEBUG)
      {
         _loc3_.addItem("[Debug] Voir JSON",this.api.network.Basics,this.api.network.Basics.autorisedCommand,["view-json " + oItem.unicID]);
      }
      _loc3_.show(_root._xmouse,_root._ymouse);
   }
   function over(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      switch(oEvent.target)
      {
         case this._pbEthereal:
            if(this._oItem.durability != -1 && this._oItem.durability != undefined)
            {
               _loc3_ = 812;
               _loc4_ = this._oItem.durability;
               _loc5_ = this._oItem.durabilityMax;
            }
            else
            {
               _loc3_ = 2149;
               _loc4_ = this._oItem.skinDurability;
               _loc5_ = this._oItem.skinDurabilityMax;
            }
            _loc6_ = this.api.lang.getEffectText(_loc3_).d;
            _loc7_ = ank.utils.PatternDecoder.getDescription(_loc6_,[undefined,_loc4_,_loc5_]);
            this.gapi.showTooltip(_loc7_);
            break;
         case this._ldrTwoHanded:
            this.gapi.showTooltip(this.api.lang.getText("TWO_HANDS_WEAPON"));
            break;
         case this._btnDialog:
            this.gapi.showTooltip(this._oItem.description);
            break;
         case this._ldrExtraIcon:
            this.gapi.showTooltip(this.api.lang.getText(this.getOverExtraIconText()));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function overItem(oEvent_)
   {
      var _loc3_ = oEvent_.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      if(!_loc4_.isEmptyKey)
      {
         _loc4_.showStatsTooltip(_loc4_.style);
      }
   }
   function outItem(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function scrollGrid(oEvent_)
   {
      this.addToQueue({object:this,method:this.updateKeyGrid});
      this.gapi.hideTooltip();
   }
}
