class dofus.graphics.gapi.ui.Gifts extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aSpriteList;
   var _bAttributingGifts;
   var _btnArrowLeft;
   var _btnArrowRight;
   var _btnClose;
   var _btnSelect;
   var _btnViewAllGifts;
   var _cgGifts;
   var _itvItemViewer;
   var _lblDateGift;
   var _lblItems_;
   var _lblTitleGift;
   var _ldrGfx;
   var _mcArrowLeft;
   var _mcArrowRight;
   var _mcGiftsWarning;
   var _nCharacterStartIndex;
   var _nLastAttributionCharacterID;
   var _nSaveLastClick;
   var _nSelectedIndex;
   var _pgBtnCheckAll;
   var _pgBtnChooseCharacter;
   var _pgBtnClose;
   var _pgHeaderRectangle;
   var _pgHidder;
   var _pgLblCheckedCount;
   var _pgLstGifts;
   var _pgMovieClips;
   var _pgTxtInfos;
   var _pgWinBackground;
   var _target;
   var _txtDescription;
   var _visible;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "Gifts";
   var _aPendingAttributionGifts = [];
   var _nCurrentGiftsToAttributeCount = 0;
   var _nTotalGiftsToAttributeCount = 0;
   function Gifts()
   {
      super();
   }
   function get firstGiftInStack()
   {
      var _loc2_ = this.api.datacenter.Basics.aks_gifts_stack;
      return _loc2_[0];
   }
   function set spriteList(aSpriteList)
   {
      this._aSpriteList = aSpriteList;
   }
   function get isAttributingGifts()
   {
      return this._bAttributingGifts;
   }
   function checkNextGift()
   {
      var _loc2_;
      if(!this._bAttributingGifts && (this._nCurrentGiftsToAttributeCount > 1 && this._nCurrentGiftsToAttributeCount == this._nTotalGiftsToAttributeCount))
      {
         _loc2_ = this["_ccs" + this._nSelectedIndex].data.name;
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("GIFTS_MASS_DISTRIBUTION_FINISHED_SUCCESS",[_loc2_,this._nTotalGiftsToAttributeCount]),"ERROR_BOX");
      }
      var _loc3_;
      if(this._bAttributingGifts && this._nCurrentGiftsToAttributeCount < this._nTotalGiftsToAttributeCount)
      {
         _loc3_ = _global.setTimeout(this,"attributeGiftToCharacter",200,this._nLastAttributionCharacterID);
      }
      else if(this.api.datacenter.Basics.aks_gifts_stack.length != 0)
      {
         this.api.ui.unloadUIComponent("WaitingMessage");
         this.gapi.loadUIComponent("Gifts","Gifts",{spriteList:this._aSpriteList},{bForceLoad:true});
      }
      else
      {
         this.api.ui.unloadUIComponent("WaitingMessage");
         this.gapi.getUIComponent("ChooseCharacter")._visible = true;
         this.gapi.getUIComponent("CreateCharacter")._visible = true;
         this.gapi.getUIComponent("ChooseCharacter")._btnViewAllGifts._visible = false;
         this.unloadThis();
      }
      this.gapi.getUIComponent("ChooseCharacter")._mcGiftsWarning._visible = this.firstGiftInStack.date != "";
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Gifts.CLASS_NAME);
   }
   function callClose()
   {
      if(this._pgWinBackground._visible)
      {
         this.closePendingGiftsAndUpdateSelected();
         return true;
      }
      this.gapi.getUIComponent("ChooseCharacter")._visible = true;
      this.gapi.getUIComponent("CreateCharacter")._visible = true;
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this._pgMovieClips = [this._pgWinBackground,this._pgHeaderRectangle,this._pgLstGifts,this._pgBtnClose,this._pgTxtInfos,this._pgBtnCheckAll,this._pgLblCheckedCount,this._pgBtnChooseCharacter,this._pgHidder];
      this._visible = false;
      this.showViewPendingGifts(false);
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 5)
      {
         _loc3_ = this["_ccs" + _loc2_];
         _loc3_.params = {index:_loc2_};
         _loc3_.addEventListener("select",this);
         _loc2_ = _loc2_ + 1;
      }
      this._cgGifts.addEventListener("selectItem",this);
      this._cgGifts.multipleContainerSelectionEnabled = false;
      this._btnClose.addEventListener("click",this);
      this._btnSelect.addEventListener("click",this);
      this._btnViewAllGifts.addEventListener("click",this);
      this._pgBtnClose.addEventListener("click",this);
      this._pgBtnChooseCharacter.addEventListener("click",this);
      this._pgBtnCheckAll.addEventListener("click",this);
      this._pgBtnCheckAll.addEventListener("over",this);
      this._pgBtnCheckAll.addEventListener("out",this);
      this._cgGifts.addEventListener("overItem",this);
      this._cgGifts.addEventListener("outItem",this);
      this._lblDateGift.addEventListener("over",this);
      this._lblDateGift.addEventListener("out",this);
      var ref = this;
      this._mcGiftsWarning.onRollOver = function()
      {
         ref.over({target:this});
      };
      this._mcGiftsWarning.onRollOut = function()
      {
         ref.out({target:this});
      };
      this._btnArrowLeft.onRelease = function()
      {
         ref.click({target:this});
      };
      this._btnArrowRight.onRelease = function()
      {
         ref.click({target:this});
      };
      ank.utils.MouseEvents.addListener(this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initTexts()
   {
      this._pgBtnCheckAll.label = this.api.lang.getText("SELECT_UNSELECT_ALL_BUTTON");
      this._ldrGfx.text = this.api.lang.getText("THE_GIFT");
      this._btnClose.label = this.api.lang.getText("CLOSE");
      this._btnViewAllGifts.label = this.api.lang.getText("MY_GIFTS");
      this._btnSelect.label = this.api.lang.getText("SELECT");
      this._pgWinBackground.title = this.api.lang.getText("MY_GIFTS");
      this._pgTxtInfos.text = this.api.lang.getText("GIFTS_VIEWER_INFOS");
   }
   function closePendingGiftsAndUpdateSelected()
   {
      if(this._aPendingAttributionGifts.length == 0)
      {
         this._aPendingAttributionGifts.push(this.firstGiftInStack);
         this._aPendingAttributionGifts[0].playerWantsAttribution = true;
      }
      this.refreshGiftsSelected();
      this.showViewPendingGifts(false);
   }
   function openPendingGiftsAndUpdateSelected()
   {
      this.refreshGiftsList();
      this.showViewPendingGifts(true);
   }
   function showViewPendingGifts(bShow)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._pgMovieClips.length)
      {
         _loc4_ = this._pgMovieClips[_loc3_];
         _loc4_._visible = bShow;
         _loc3_ = _loc3_ + 1;
      }
   }
   function initData()
   {
      this._mcArrowLeft._visible = this._btnArrowLeft._visible = this._mcArrowRight._visible = this._btnArrowRight._visible = this._aSpriteList.length > 5;
      this._nCharacterStartIndex = 0;
      if(this._btnArrowRight._visible && this._nCharacterStartIndex < this._aSpriteList.length - 5)
      {
         this._btnArrowRight.gotoAndStop("on");
      }
      this._aPendingAttributionGifts = [];
      this._aPendingAttributionGifts.push(this.firstGiftInStack);
      this._aPendingAttributionGifts[0].playerWantsAttribution = true;
      this.refreshGiftsList();
      this.refreshGiftsSelected();
   }
   function refreshGiftsSelected()
   {
      this._visible = true;
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = [];
      var _loc4_ = this._aPendingAttributionGifts.length;
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc4_)
      {
         _loc6_ = this._aPendingAttributionGifts[_loc5_];
         _loc2_.pushAll(_loc6_.items);
         _loc5_ = _loc5_ + 1;
      }
      var _loc7_ = 0;
      var _loc8_;
      while(_loc7_ < _loc2_.length)
      {
         _loc8_ = _loc2_[_loc7_];
         _loc3_.push(_loc8_.name);
         _loc7_ = _loc7_ + 1;
      }
      this._cgGifts.dataProvider = _loc2_;
      this._cgGifts.selectedIndex = 0;
      this._itvItemViewer.itemData = _loc2_[0];
      var _loc9_;
      if(_loc3_.length > 1)
      {
         this._lblItems_.text = this.api.lang.getText("GIFTS_UI_TITLE_ON_MASS",[_loc4_]);
         this._txtDescription.text = this.api.lang.getText("GIFTS_MASS_DISTRIBUTION_HELP",[_loc4_,_loc3_.join("\n- ")]);
      }
      else
      {
         this._lblItems_.text = this.api.lang.getText("GIFTS_TITLE");
         _loc9_ = _loc3_[0];
         this._txtDescription.text = _loc9_ == undefined ? "" : this.api.lang.getText("GIFT_DISTRIBUTION_HELP",[_loc9_]);
      }
      this.updateCharactersList();
   }
   function refreshGiftsList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.Basics.aks_gifts_stack;
      var _loc4_ = false;
      var _loc5_ = 0;
      this._aPendingAttributionGifts = [];
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < _loc3_.length)
      {
         _loc7_ = _loc3_[_loc6_];
         _loc7_.addEventListener("giftAttributionStateChanged",this);
         if(_loc7_.playerWantsAttribution)
         {
            _loc5_ = _loc5_ + 1;
            this._aPendingAttributionGifts.push(_loc7_);
         }
         if(_loc7_.date != "")
         {
            _loc4_ = true;
         }
         _loc7_.indexOnGiftsStack = _loc6_;
         _loc2_.push(_loc7_);
         _loc6_ = _loc6_ + 1;
      }
      this._pgLstGifts.dataProvider = _loc2_;
      this._lblTitleGift.text = this.api.lang.getText("GIFTS_SELECT_RECEIVER");
      this._pgBtnChooseCharacter.label = this.api.lang.getText("GIFTS_SELECT_CHARACTER_MASS_GIFTS",[_loc5_]);
      this._mcGiftsWarning._visible = _loc4_;
      this.refreshGiftsSelected();
   }
   function autoSelectUnselectAllGifts()
   {
      var _loc2_ = this.api.datacenter.Basics.aks_gifts_stack;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._aPendingAttributionGifts.length == _loc2_.length)
      {
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc4_.playerWantsAttribution = false;
            _loc3_ = _loc3_ + 1;
         }
      }
      else
      {
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc6_.playerWantsAttribution = true;
            _loc5_ = _loc5_ + 1;
         }
      }
      this.refreshGiftsList();
   }
   function updateCharactersList()
   {
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 5)
      {
         _loc3_ = this["_ccs" + _loc2_];
         _loc3_.data = this._aSpriteList[_loc2_ + this._nCharacterStartIndex];
         _loc3_.enabled = this._aSpriteList[_loc2_ + this._nCharacterStartIndex] != undefined;
         _loc2_ = _loc2_ + 1;
      }
   }
   function giftAttributionStateChanged(oEvent)
   {
      this.refreshGiftsList();
   }
   function select(oEvent)
   {
      var _loc3_ = oEvent.target.params.index;
      this["_ccs" + this._nSelectedIndex].selected = false;
      if(this._nSelectedIndex == _loc3_)
      {
         delete this._nSelectedIndex;
      }
      else
      {
         this._nSelectedIndex = _loc3_;
      }
      if(getTimer() - this._nSaveLastClick < ank.gapi.Gapi.DBLCLICK_DELAY)
      {
         this._nSelectedIndex = _loc3_;
         this.click({target:this._btnSelect});
         return undefined;
      }
      this._nSaveLastClick = getTimer();
   }
   function selectItem(oEvent)
   {
      this._itvItemViewer.itemData = oEvent.target.contentData;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(oEvent.target)
      {
         case this._btnArrowLeft:
            if(this._nCharacterStartIndex > 0)
            {
               this._btnArrowLeft.gotoAndStop("on");
               this._btnArrowRight.gotoAndStop("on");
               this._nCharacterStartIndex = this._nCharacterStartIndex - 1;
               if(this._nCharacterStartIndex <= 0)
               {
                  this._nCharacterStartIndex = 0;
                  this._btnArrowLeft.gotoAndStop("off");
               }
               this.updateCharactersList();
            }
            break;
         case this._btnArrowRight:
            if(this._nCharacterStartIndex < this._aSpriteList.length - 5)
            {
               this._btnArrowLeft.gotoAndStop("on");
               this._btnArrowRight.gotoAndStop("on");
               this._nCharacterStartIndex = this._nCharacterStartIndex + 1;
               if(this._nCharacterStartIndex >= this._aSpriteList.length - 5)
               {
                  this._nCharacterStartIndex = this._aSpriteList.length - 5;
                  this._btnArrowRight.gotoAndStop("off");
               }
               this.updateCharactersList();
            }
            break;
         case this._pgBtnCheckAll:
            this.autoSelectUnselectAllGifts();
            break;
         case this._pgBtnClose:
         case this._pgBtnChooseCharacter:
            this.closePendingGiftsAndUpdateSelected();
            break;
         case this._btnViewAllGifts:
            if(this._pgWinBackground._visible)
            {
               this.closePendingGiftsAndUpdateSelected();
            }
            else
            {
               this.openPendingGiftsAndUpdateSelected();
            }
            break;
         case this._btnClose:
            this.callClose();
            break;
         case this._btnSelect:
            if(!_global.isNaN(this._nSelectedIndex))
            {
               _loc3_ = this._aPendingAttributionGifts.length;
               _loc4_ = this["_ccs" + this._nSelectedIndex].data.name;
               _loc5_ = _loc3_ > 1;
               if(_loc5_)
               {
                  this.api.kernel.showMessage(this.api.lang.getText("MY_GIFTS"),this.api.lang.getText("GIFT_MASS_ATTRIBUTION_CONFIRMATION",[_loc3_,_loc4_]),"CAUTION_YESNO",{name:"GiftAttribution",listener:this,params:{charId:this["_ccs" + this._nSelectedIndex].data.id}});
               }
               else
               {
                  _loc6_ = dofus.datacenter.Item(this._aPendingAttributionGifts[0].items[0]);
                  this.api.kernel.showMessage(this.api.lang.getText("THE_GIFT"),this.api.lang.getText("GIFT_ATTRIBUTION_CONFIRMATION",[_loc6_.name,_loc4_]),"CAUTION_YESNO",{name:"GiftAttribution",listener:this,params:{charId:this["_ccs" + this._nSelectedIndex].data.id}});
               }
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SELECT_CHARACTER"),"ERROR_BOX",{name:"NoSelect"});
            }
         default:
            return;
      }
   }
   function over(oEvent)
   {
      switch(oEvent.target)
      {
         case this._pgBtnCheckAll:
            this.api.ui.showTooltip(this.api.lang.getText("SELECT_UNSELECT_ALL_BUTTON_HELP"));
            break;
         case this._lblDateGift:
            this.api.ui.showTooltip(this.api.lang.getText("EXPIRATION_GIFT",[this.firstGiftInStack.date]));
            break;
         case this._mcGiftsWarning:
            this.api.ui.showTooltip(this.api.lang.getText("EXPIRATION_GIFTS",[this.firstGiftInStack.date]));
         default:
            return;
      }
   }
   function out(oEvent)
   {
      switch(oEvent.target)
      {
         case this._pgBtnCheckAll:
         case this._lblDateGift:
         case this._mcGiftsWarning:
            this.api.ui.hideTooltip();
         default:
            return;
      }
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target;
      var _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
      _loc4_.showStatsTooltip(_loc4_.style);
   }
   function outItem(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoGiftAttribution")
      {
         this.attributeGiftToCharacter(oEvent.params.charId);
      }
   }
   function attributeGiftToCharacter(nCharID)
   {
      if(!this._bAttributingGifts)
      {
         this._bAttributingGifts = true;
         this._nCurrentGiftsToAttributeCount = 0;
         this._nTotalGiftsToAttributeCount = this._aPendingAttributionGifts.length;
      }
      var _loc3_ = dofus.datacenter.Gift(this._aPendingAttributionGifts.shift());
      var _loc4_ = 0;
      while(_loc4_ < this.api.datacenter.Basics.aks_gifts_stack.length)
      {
         if(this.api.datacenter.Basics.aks_gifts_stack[_loc4_].id == _loc3_.id)
         {
            this.api.datacenter.Basics.aks_gifts_stack.splice(_loc4_,1);
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._nLastAttributionCharacterID = nCharID;
      this._nCurrentGiftsToAttributeCount = this._nCurrentGiftsToAttributeCount + 1;
      if(this._nCurrentGiftsToAttributeCount == this._nTotalGiftsToAttributeCount)
      {
         this._bAttributingGifts = false;
      }
      this.api.network.Account.attributeGiftToCharacter(_loc3_.id,nCharID);
      this._visible = false;
      this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("WAITING_MSG_RECORDING") + " (" + this.api.lang.getText("GIFT") + " " + this._nCurrentGiftsToAttributeCount + "/" + this._nTotalGiftsToAttributeCount + ")"},{bAlwaysOnTop:true,bForceLoad:true});
   }
   function onMouseWheel(nDelta, mc_)
   {
      if(this._pgWinBackground._visible || dofus.graphics.gapi.ui.Zoom.isZooming())
      {
         return undefined;
      }
      var _loc4_;
      if(String(mc_._target).indexOf(this._target) != -1)
      {
         _loc4_ = nDelta <= 0 ? {target:this._btnArrowRight} : {target:this._btnArrowLeft};
         this.click(_loc4_);
      }
   }
   function onShortcut(sShortcut)
   {
      if(this._pgWinBackground._visible || Selection.getFocus() != null)
      {
         return undefined;
      }
      if(sShortcut == "CODE_PREVIOUS")
      {
         this.click({target:this._btnArrowLeft});
      }
      else if(sShortcut == "CODE_NEXT")
      {
         this.click({target:this._btnArrowRight});
      }
   }
}
