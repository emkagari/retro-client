class dofus.graphics.gapi.ui.ChooseReward extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _aItems;
   var _aTokens;
   var _bgHidder;
   var _btnHide;
   var _btnValidate;
   var _ctr0;
   var _ctr1;
   var _ctr2;
   var _hidder0;
   var _hidder1;
   var _hidder2;
   var _itvItemViewer;
   var _itvItemViewerBonus;
   var _lblBonus;
   var _lblEffects;
   var _lblTonic0;
   var _lblTonic1;
   var _lblTonic2;
   var _mcProgressClip;
   var _mcRoulette0;
   var _mcRoulette1;
   var _mcRoulette2;
   var _nCurrentRoom;
   var _nIndex;
   var _winBackgroundSmall;
   var _winItemViewer;
   var _winItemViewerProgress;
   var addToQueue;
   var api;
   var gapi;
   var getDepth;
   var getNextHighestDepth;
   var swapDepths;
   var unloadThis;
   static var CLASS_NAME = "ChooseReward";
   static var SLOT_CHOICES = 3;
   static var ITEM_TYPE = 126;
   var _bIsDisplayed = true;
   function ChooseReward()
   {
      super();
   }
   function set items(aItems)
   {
      this._aItems = aItems;
   }
   function set tokens(aTokens)
   {
      this._aTokens = aTokens;
   }
   function set currentRoom(nCurrentRoom)
   {
      this._nCurrentRoom = nCurrentRoom;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ChooseReward.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnValidate.addEventListener("click",this);
      this._btnHide.addEventListener("click",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.ChooseReward.SLOT_CHOICES)
      {
         _loc3_ = ank.gapi.controls.Container(this["_ctr" + _loc2_]);
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("dblClick",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
   }
   function initTexts()
   {
      this._winBackgroundSmall._visible = false;
      this._winItemViewerProgress.title = this.api.lang.getText("YOUR_PROGRESS");
      this._winBackgroundSmall.title = this.api.lang.getText("CHOOSE_LOOT");
      this._winItemViewer.title = this.api.lang.getText("CHOOSE_LOOT");
      this._btnValidate.label = this.api.lang.getText("VALIDATE");
      this._lblEffects.text = this.api.lang.getText("EFFECTS") + " :";
      this._lblBonus.text = this.api.lang.getText("BONUS_CHOOSEREWARD") + " : ";
      this.setTonicName(0);
      this.setTonicName(1);
      this.setTonicName(2);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < this._aTokens.length)
      {
         _loc3_ = ank.gapi.controls.Label(this._mcProgressClip["_lblTokens" + _loc2_]);
         _loc3_.text = this._aTokens[_loc2_];
         _loc2_ = _loc2_ + 1;
      }
      this.animateProgression(this._nCurrentRoom);
   }
   function initData()
   {
      this.setItemsSlots(this._aItems);
   }
   function validateReward(nIndex)
   {
      this.api.network.Items.selectRouletteItem(nIndex);
   }
   function setTonicName(nIndex)
   {
      var _loc3_ = ank.gapi.controls.Label(this["_lblTonic" + nIndex]);
      _loc3_.text = this._aItems[nIndex].realItem.name;
   }
   function animateProgression(nCurrentRoom)
   {
      this._mcProgressClip.gotoAndStop(nCurrentRoom);
   }
   function windowHidder()
   {
      if(this._bIsDisplayed)
      {
         this._bIsDisplayed = false;
         this._btnHide.backgroundDown = "ButtonMaximizeDown";
         this._btnHide.backgroundUp = "ButtonMaximizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 188;
         this._btnHide._y = 417;
         this.swapDepths(this.getDepth() - 666);
      }
      else
      {
         this._bIsDisplayed = true;
         this._btnHide.backgroundDown = "ButtonMinimizeDown";
         this._btnHide.backgroundUp = "ButtonMinimizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 574;
         this._btnHide._y = 157;
         this.swapDepths(this.getDepth() + 666);
      }
      this._lblEffects._visible = this._bIsDisplayed;
      this._btnValidate._visible = this._bIsDisplayed;
      this._ctr0._visible = this._bIsDisplayed;
      this._ctr1._visible = this._bIsDisplayed;
      this._ctr2._visible = this._bIsDisplayed;
      this._lblBonus._visible = this._bIsDisplayed;
      this._winItemViewer._visible = this._bIsDisplayed;
      this._winItemViewerProgress._visible = this._bIsDisplayed;
      this._lblTonic0._visible = this._bIsDisplayed;
      this._lblTonic1._visible = this._bIsDisplayed;
      this._lblTonic2._visible = this._bIsDisplayed;
      this._itvItemViewer._visible = this._bIsDisplayed;
      this._itvItemViewerBonus._visible = this._bIsDisplayed;
      this._mcRoulette0._visible = this._bIsDisplayed;
      this._mcRoulette1._visible = this._bIsDisplayed;
      this._mcRoulette2._visible = this._bIsDisplayed;
      this._hidder0._visible = this._bIsDisplayed;
      this._hidder1._visible = this._bIsDisplayed;
      this._hidder2._visible = this._bIsDisplayed;
      this._bgHidder._visible = this._bIsDisplayed;
      this._mcProgressClip._visible = this._bIsDisplayed;
      this._winBackgroundSmall._visible = !this._bIsDisplayed;
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < 7)
      {
         _loc3_ = MovieClip(this["_mcCadre" + _loc2_]);
         _loc3_._visible = this._bIsDisplayed;
         _loc2_ = _loc2_ + 1;
      }
   }
   function setItemsSlots(aItems)
   {
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      while(_loc3_ < dofus.graphics.gapi.ui.ChooseReward.SLOT_CHOICES)
      {
         _loc4_ = aItems[_loc3_];
         _loc5_ = _loc4_.realItem;
         _loc6_ = _loc4_.fakeItems;
         _loc7_ = _loc4_.bonusEffects;
         _loc8_ = ank.gapi.controls.Container(this["_ctr" + _loc3_]);
         _loc8_.contentData = _loc5_;
         this["_oBonus" + _loc3_] = _loc7_;
         _loc9_ = MovieClip(this["_mcRoulette" + _loc3_]);
         ank.gapi.controls.Loader(_loc9_._mcRealIcon.attachMovie("GAPILoader","_ldrRealIcon",this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc5_.iconFile}));
         _loc10_ = 0;
         while(_loc10_ < dofus.aks.ChooseReward.ICONS_NEEDED)
         {
            _loc11_ = _loc6_[_loc10_];
            _loc12_ = _loc9_["_mcFakeIcon" + _loc10_];
            ank.gapi.controls.Loader(_loc12_.attachMovie("GAPILoader","_ldrFakeIcon" + _loc10_,this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc11_.iconFile}));
            _loc10_ = _loc10_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      switch(oEvent.target)
      {
         case this._btnHide:
            this.windowHidder();
            return;
         case this._btnValidate:
            _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoLoot",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CONFIRM_LOOT",[this["_ctr" + this._nIndex].contentData.name])});
            _loc3_.addEventListener("yes",this);
            return;
         default:
            this._nIndex = oEvent.target._name.substr(4);
            if(this._nIndex == undefined)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("PLEASE_SELECT"),"ERROR_CHAT");
               return undefined;
            }
            if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY))
            {
               this.api.kernel.GameManager.insertItemInChat(oEvent.target.contentData);
               return undefined;
            }
            _loc4_ = 0;
            while(_loc4_ < dofus.graphics.gapi.ui.ChooseReward.SLOT_CHOICES)
            {
               _loc5_ = ank.gapi.controls.Container(this["_ctr" + _loc4_]);
               _loc5_.selected = this._nIndex == _loc4_;
               _loc4_ = _loc4_ + 1;
            }
            this._btnValidate.enabled = true;
            this._itvItemViewer.itemData = oEvent.target.contentData;
            this._itvItemViewerBonus.itemData = this["_oBonus" + this._nIndex];
            return;
      }
   }
   function dblClick(oEvent)
   {
      this._nIndex = oEvent.target._name.substr(4);
      if(this._nIndex == undefined)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("PLEASE_SELECT"),"ERROR_CHAT");
         return undefined;
      }
      var _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoLoot",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CONFIRM_LOOT",[this["_ctr" + this._nIndex].contentData.name])});
      _loc3_.addEventListener("yes",this);
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoLoot")
      {
         this.validateReward(this._nIndex);
         this.unloadThis();
      }
   }
}
