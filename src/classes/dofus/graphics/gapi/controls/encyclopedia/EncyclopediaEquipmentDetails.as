class dofus.graphics.gapi.controls.encyclopedia.EncyclopediaEquipmentDetails extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bInitialized;
   var _bShowBaseEffects;
   var _bgh;
   var _btnAction;
   var _btnClose;
   var _btnTabCharacteristics;
   var _btnTabConditions;
   var _btnTabEffects;
   var _ctrIcon;
   var _lblCategory;
   var _lblLevel;
   var _lblName;
   var _lblSetName;
   var _lblWeight;
   var _ldrWarning;
   var _lstInfos;
   var _mcBackground;
   var _mcItemSetViewer;
   var _mcTitleBackground;
   var _oItem;
   var _parent;
   var _sEffects;
   var _txtDescription;
   var addToQueue;
   var removeMovieClip;
   var _bEmbeded = false;
   var _sCurrentTab = "Effects";
   function EncyclopediaEquipmentDetails()
   {
      super();
   }
   function set itemID(nItemID)
   {
      var _loc3_ = this._sEffects == undefined ? String(this.api.lang.getItemStats(nItemID)) : this._sEffects;
      var _loc4_ = new dofus.datacenter.Item(undefined,nItemID,1,undefined,_loc3_);
      this._oItem = _loc4_;
      if(this._bInitialized)
      {
         this.initTexts();
         this.initData();
      }
   }
   function set effects(sEffects)
   {
      this._sEffects = sEffects;
   }
   function set embeded(bEmbeded)
   {
      this._bEmbeded = bEmbeded;
      this._bgh._visible = !bEmbeded;
      this._btnClose._visible = !bEmbeded;
      this._mcTitleBackground._visible = !bEmbeded;
      this._mcBackground._visible = !bEmbeded;
   }
   function set displayWarning(bDisplay)
   {
      if(bDisplay)
      {
         this._ldrWarning.autoLoad = true;
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this._mcItemSetViewer._visible = false;
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function close()
   {
      this.removeMovieClip();
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._ctrIcon.addEventListener("over",this);
      this._ctrIcon.addEventListener("out",this);
      this._ctrIcon.addEventListener("click",this);
      this._btnTabEffects.addEventListener("click",this);
      this._btnTabCharacteristics.addEventListener("click",this);
      this._btnTabConditions.addEventListener("click",this);
      this._ldrWarning.addEventListener("over",this);
      this._ldrWarning.addEventListener("out",this);
      this._btnAction.addEventListener("click",this);
   }
   function initTexts()
   {
      this._lblName.text = this._oItem.name + (!dofus.Constants.DEBUG ? "" : " (GFX : " + this._oItem.type + "/" + this._oItem.gfx + ")");
      this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL") + this._oItem.level;
      this._lblCategory.text = this._oItem.typeText;
      this._txtDescription.text = ank.utils.PatternDecoder.getDescription(this.api.lang.fetchString(this.api.lang.getItemUnicText(this._oItem.unicID).d),this.api.lang.getItemUnicStringText());
      this._lblWeight.text = this._oItem.weight + " " + ank.utils.PatternDecoder.combine(this._parent.api.lang.getText("PODS"),"m",this._oItem.weight < 2);
      this._btnTabEffects.label = this.api.lang.getText("EFFECTS");
      this._btnTabConditions.label = this.api.lang.getText("CONDITIONS");
      this._btnTabCharacteristics.label = this.api.lang.getText("CHARACTERISTICS");
   }
   function initData()
   {
      this._ctrIcon.contentData = this._oItem;
      this._ctrIcon.cornerIcon = !this._oItem.needTwoHands ? "" : "ItemViewerTwoHand";
      if(this._oItem.superType == 2 && !this._oItem.isCeremonial)
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
      this.updateCurrentTabInformations();
      this._lblName.styleName = this._oItem.style != "" ? this._oItem.style + "LeftMediumBoldLabel" : "WhiteLeftMediumBoldLabel";
      var _loc2_;
      var _loc3_;
      if(this._oItem.isFromItemSet)
      {
         _loc2_ = this.api.lang.getItemSetText(this._oItem.itemSetID).i;
         _loc3_ = new dofus.datacenter.ItemSet(this._oItem.itemSetID,_loc2_);
         this._mcItemSetViewer._visible = true;
         this._mcItemSetViewer.itemSet = _loc3_;
         this._lblSetName.text = _loc3_.name;
      }
      else
      {
         this._lblSetName.text = "";
         this._mcItemSetViewer._visible = false;
      }
   }
   function updateCurrentTabInformations()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(this._sCurrentTab)
      {
         case "Effects":
            _loc3_ = this._oItem.visibleEffects;
            for(var s in _loc3_)
            {
               _loc2_.push(_loc3_[s]);
            }
            break;
         case "Characteristics":
            _loc4_ = this._oItem.characteristics;
            for(var s in _loc4_)
            {
               if(_loc4_[s].length > 0)
               {
                  _loc2_.push(_loc4_[s]);
               }
            }
            break;
         case "Conditions":
            _loc5_ = this._oItem.conditions;
            for(var s in _loc5_)
            {
               if(_loc5_[s].length > 0)
               {
                  _loc2_.push(_loc5_[s]);
               }
            }
      }
      _loc2_.reverse();
      this._lstInfos.dataProvider = _loc2_;
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
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(bShowBaseEffects)
      {
         if(this._sCurrentTab == "Effects")
         {
            _loc3_ = dofus.datacenter.Item.getBaseItemEffects(this._oItem.unicID);
            _loc4_ = dofus.datacenter.Item.getItemDescriptionEffects(_loc3_,_loc3_,true,this._oItem.isReallyEnhanceable);
            _loc5_ = new ank.utils.ExtendedArray();
            for(var s in _loc4_)
            {
               if(_loc4_[s].description.length > 0)
               {
                  _loc5_.push(_loc4_[s]);
               }
            }
            _loc5_.reverse();
            this._lstInfos.dataProvider = _loc5_;
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
   function createActionPopupMenu()
   {
      var _loc2_ = this.api.ui.createPopupMenu();
      _loc2_.addStaticItem(this._oItem.name);
      _loc2_.addItem(this.api.lang.getText("CLICK_TO_INSERT"),this.api.kernel.GameManager,this.api.kernel.GameManager.insertItemInChat,[this._oItem]);
      _loc2_.addItem(this.api.lang.getText("ASSOCIATE_RECEIPTS"),this.api.ui,this.api.ui.loadUIComponent,["ItemUtility","ItemUtility",{item:this._oItem},{bAlwaysOnTop:true}]);
      if(this._oItem.isSearchableInEncyclopedia && this._bEmbeded)
      {
         _loc2_.addItem(this.api.lang.getText("VIEW_IN_ENCYCLOPEDIA"),dofus.graphics.gapi.ui.Encyclopedia,dofus.graphics.gapi.ui.Encyclopedia.openEncyclopediaForItem,[this._oItem]);
      }
      if(this._oItem.isDroppable)
      {
         _loc2_.addItem(this.api.lang.getText("DISPLAY_MONSTERS_WHO_DROP_ITEM"),this,this.displayMonsterWhoDrops);
      }
      if(this.api.datacenter.Player.isAuthorized && dofus.Constants.DEBUG)
      {
         _loc2_.addItem("[Debug] Give item",this.api.network.Basics,this.api.network.Basics.autorisedCommand,["item * " + this._oItem.unicID + " 1"]);
      }
      _loc2_.show(_root._xmouse,_root._ymouse);
   }
   function displayMonsterWhoDrops()
   {
      var _loc2_ = this.api.ui.getUIComponent("Encyclopedia");
      var _loc3_ = dofus.datacenter.Item.droppedFromMonstersWithEnabledCriterions(this._oItem.unicID);
      if(_loc2_ != undefined)
      {
         _loc2_.setCurrentTab("Bestiary",_loc3_);
      }
      else
      {
         this.api.ui.loadUIAutoHideComponent("Encyclopedia","Encyclopedia",{_sCurrentTab:"Bestiary",_aSearchedIDs:_loc3_},{bStayIfPresent:true});
      }
   }
   function click(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target)
      {
         case this._btnClose:
            this.close();
            break;
         case this._btnAction:
            this.createActionPopupMenu();
            break;
         case this._btnTabEffects:
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
         case this._btnTabCharacteristics:
            this.setCurrentTab("Characteristics");
            break;
         case this._btnTabConditions:
            this.setCurrentTab("Conditions");
            break;
         case this._ctrIcon:
            if(this._oItem != undefined && Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
            {
               this.api.kernel.GameManager.insertItemInChat(this._oItem);
            }
         default:
            return;
      }
   }
   function over(oEvent_)
   {
      switch(oEvent_.target)
      {
         case this._ctrIcon:
            if(this._oItem.needTwoHands)
            {
               this.api.ui.showTooltip(this.api.lang.getText("TWO_HANDS_WEAPON"));
            }
            break;
         case this._ldrWarning:
            this.api.ui.showTooltip(this.api.lang.getText("ITEMS_CHAT_WARNING_ROLLOVER"));
         default:
            return;
      }
   }
   function out(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
   function outItem(oEvent_)
   {
      this.api.ui.hideTooltip();
   }
}
