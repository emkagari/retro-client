class dofus.graphics.gapi.ui.GladiatroolShop extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bgHidder;
   var _btnBuy;
   var _btnHide;
   var _btnReset;
   var _btnSell;
   var _ctr0;
   var _ctr1;
   var _ctr2;
   var _ctr3;
   var _ctr4;
   var _ctr5;
   var _ctr6;
   var _ctr7;
   var _ctr8;
   var _ctr9;
   var _ctr10;
   var _lblBonus;
   var _lblPrice0;
   var _lblPrice1;
   var _lblPrice2;
   var _lblPrice3;
   var _lblPrice4;
   var _lblPrice5;
   var _lblResetInfos;
   var _lblTokens;
   var _ldrHelp;
   var _lstInfos;
   var _mcArrow;
   var _mcPassive;
   var _mcProgressClip;
   var _nCurrentIndex;
   var _nCurrentRoom;
   var _oCurrentOverItem;
   var _winBackgroundSmall;
   var _winItemOwnedViewer;
   var _winItemViewerProgress;
   var _winShopViewer;
   var addToQueue;
   var gapi;
   var getDepth;
   var getNextHighestDepth;
   var nBaseDepth;
   var swapDepths;
   static var CLASS_NAME = "GladiatroolShop";
   static var CTR_LENGTH = 11;
   static var CTR_FIRST_INV_IDX = 6;
   var bIsFirstRefresh = true;
   var _bIsDisplayed = true;
   function GladiatroolShop()
   {
      super();
   }
   function get currentOverItem()
   {
      return this._oCurrentOverItem;
   }
   function get currentIndex()
   {
      return this._nCurrentIndex;
   }
   function getContainer(nIdx)
   {
      switch(nIdx)
      {
         case 0:
            return this._ctr0;
         case 1:
            return this._ctr1;
         case 2:
            return this._ctr2;
         case 3:
            return this._ctr3;
         case 4:
            return this._ctr4;
         case 5:
            return this._ctr5;
         case 6:
            return this._ctr6;
         case 7:
            return this._ctr7;
         case 8:
            return this._ctr8;
         case 9:
            return this._ctr9;
         case 10:
            return this._ctr10;
         default:
            return;
      }
   }
   function getLabel(sName_, nIdx)
   {
      var _loc0_;
      if((_loc0_ = sName_) === "price")
      {
         switch(nIdx)
         {
            case 0:
               return this._lblPrice0;
            case 1:
               return this._lblPrice1;
            case 2:
               return this._lblPrice2;
            case 3:
               return this._lblPrice3;
            case 4:
               return this._lblPrice4;
            case 5:
               return this._lblPrice5;
            default:
               return;
         }
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.GladiatroolShop.CLASS_NAME);
   }
   function callClose()
   {
      this.gapi.hideTooltip();
      if(this._bIsDisplayed)
      {
         this.windowHidder(true);
         return true;
      }
      return false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnHide.addEventListener("click",this);
      this._btnSell.addEventListener("click",this);
      this._btnBuy.addEventListener("click",this);
      this._btnReset.addEventListener("click",this);
      this._btnSell.addEventListener("over",this);
      this._btnSell.addEventListener("out",this);
      this._ldrHelp.addEventListener("over",this);
      this._ldrHelp.addEventListener("out",this);
      var _loc2_ = 0;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_LENGTH)
      {
         _loc3_ = this.getContainer(_loc2_);
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("dblClick",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc2_ = _loc2_ + 1;
      }
      this.api.datacenter.Gladiatrool.addEventListener("shopChanged",this);
      this.api.datacenter.Gladiatrool.addEventListener("inventoryChanged",this);
      this.api.datacenter.Gladiatrool.addEventListener("shopBought",this);
   }
   function initTexts()
   {
      this._winBackgroundSmall._visible = false;
      this._winItemViewerProgress.title = this.api.lang.getText("YOUR_PROGRESS");
      this._winShopViewer.title = this.api.lang.getText("SHOP");
      this._winBackgroundSmall.title = this.api.lang.getText("SHOP");
      this._winItemOwnedViewer.title = this.api.lang.getText("INVENTORY");
      this._lblBonus.text = this.api.lang.getText("WIN_BONUS");
      this._btnReset.label = this.api.lang.getText("RESET_SHOP");
      this._btnBuy.label = this.api.lang.getText("BUY");
      this._btnSell.label = this.api.lang.getText("SELL");
      var _loc2_ = this.api.datacenter.Gladiatrool.tokens;
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < _loc2_.length)
      {
         _loc4_ = ank.gapi.controls.Label(this._mcProgressClip["_lblTokens" + _loc3_]);
         _loc4_.text = _loc2_[_loc3_];
         _loc3_ = _loc3_ + 1;
      }
   }
   function initData()
   {
      this.updateInventory();
      this.updateShop();
   }
   function animateProgression(nCurrentRoom)
   {
      this._mcProgressClip.gotoAndStop(nCurrentRoom);
      this._mcProgressClip._anim.gotoAndPlay(1);
   }
   function resetSelectedIdx()
   {
      var _loc2_ = this.getContainer(this._nCurrentIndex);
      _loc2_.selected = false;
      this._nCurrentIndex = -1;
      this._btnBuy.enabled = false;
      this._btnSell.enabled = false;
      this._btnSell.label = this.api.lang.getText("SELL");
   }
   function setRouletteSoldOut(nRouletteIndex)
   {
      var _loc3_ = MovieClip(this["_mcRoulette" + nRouletteIndex]);
      _loc3_.gotoAndStop("soldOut");
      var _loc4_ = ank.gapi.controls.Label(this["_lblTonic" + nRouletteIndex]);
      _loc4_.text = this.api.lang.getText("SOLD_OUT");
      var _loc5_ = this.getLabel("price",nRouletteIndex);
      _loc5_.text = "-";
      _loc3_.soldOut = true;
   }
   function canBeBuy(oItem_)
   {
      return oItem_ != undefined && oItem_.realItem.unicID != -1 && oItem_.price <= this.api.datacenter.Gladiatrool.shopTokens;
   }
   function windowHidder(bIsDisplayed)
   {
      if(bIsDisplayed != this._bIsDisplayed && bIsDisplayed != undefined)
      {
         this._bIsDisplayed = bIsDisplayed;
      }
      if(this._bIsDisplayed)
      {
         this._bIsDisplayed = false;
         this._btnHide.backgroundDown = "ButtonMaximizeDown";
         this._btnHide.backgroundUp = "ButtonMaximizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 188;
         this._btnHide._y = 417;
         this.nBaseDepth = this.getDepth();
         this.swapDepths(0);
      }
      else
      {
         this._bIsDisplayed = true;
         this._btnHide.backgroundDown = "ButtonMinimizeDown";
         this._btnHide.backgroundUp = "ButtonMinimizeUp";
         this._btnHide.styleName = "OrangeButton";
         this._btnHide._x = 354.55;
         this._btnHide._y = 166;
         this.swapDepths(this.nBaseDepth);
      }
      this._bgHidder._visible = this._bIsDisplayed;
      this._winBackgroundSmall._visible = !this._bIsDisplayed;
      this._winItemViewerProgress._visible = this._bIsDisplayed;
      this._mcProgressClip._visible = this._bIsDisplayed;
      this._winItemOwnedViewer._visible = this._bIsDisplayed;
      var _loc3_ = dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX;
      var _loc4_;
      while(_loc3_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_LENGTH)
      {
         _loc4_ = MovieClip(this.getContainer(_loc3_));
         _loc4_._visible = this._bIsDisplayed;
         _loc3_ = _loc3_ + 1;
      }
      this._mcPassive._visible = this._bIsDisplayed;
      this._lblBonus._visible = this._bIsDisplayed;
      this._lblTokens._visible = this._bIsDisplayed;
      this._lstInfos._visible = this._bIsDisplayed;
      this._btnSell._visible = this._bIsDisplayed;
      this._ldrHelp._visible = this._bIsDisplayed;
      this._lblResetInfos._visible = this._bIsDisplayed;
      this._winShopViewer._visible = this._bIsDisplayed;
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      while(_loc5_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
      {
         _loc6_ = MovieClip(this["_hidder" + _loc5_]);
         _loc6_._visible = this._bIsDisplayed;
         _loc7_ = MovieClip(this["_lblTonic" + _loc5_]);
         _loc7_._visible = this._bIsDisplayed;
         _loc8_ = MovieClip(this.getContainer(_loc5_));
         _loc8_._visible = this._bIsDisplayed;
         _loc9_ = MovieClip(this["_mcRoulette" + _loc5_]);
         _loc9_._visible = this._bIsDisplayed;
         _loc10_ = MovieClip(this.getLabel("price",_loc5_));
         _loc10_._visible = this._bIsDisplayed;
         _loc5_ = _loc5_ + 1;
      }
      this._btnReset._visible = this._bIsDisplayed;
      this._btnBuy._visible = this._bIsDisplayed;
      var _loc11_ = 0;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc11_ < 9)
      {
         _loc12_ = MovieClip(this["_mcCadre" + _loc11_]);
         _loc12_._visible = this._bIsDisplayed;
         _loc13_ = MovieClip(this["_mcBgPrice" + _loc11_]);
         _loc13_._visible = this._bIsDisplayed;
         _loc14_ = MovieClip(this["_mcToken" + _loc11_]);
         _loc14_._visible = this._bIsDisplayed;
         _loc11_ = _loc11_ + 1;
      }
      this._mcArrow._visible = this._bIsDisplayed;
   }
   function updateShop()
   {
      this.resetSelectedIdx();
      var _loc2_ = this.api.datacenter.Gladiatrool.shopItems;
      this._btnReset.enabled = this.api.datacenter.Gladiatrool.shopTokens >= this.api.datacenter.Gladiatrool.resetPrice && this.api.datacenter.Gladiatrool.resetNumber > 0;
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
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      while(_loc3_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
      {
         _loc4_ = _loc2_[_loc3_];
         _loc5_ = _loc4_.realItem;
         _loc6_ = _loc4_.fakeItems;
         _loc7_ = _loc4_.price;
         _loc8_ = MovieClip(this["_mcRoulette" + _loc3_]);
         if(_loc5_.unicID == -1 || _loc5_.unicID == undefined)
         {
            this.setRouletteSoldOut(_loc3_);
         }
         else
         {
            _loc9_ = this.getContainer(_loc3_);
            _loc9_.contentData = _loc5_;
            _loc10_ = ank.gapi.controls.Label(this["_lblTonic" + _loc3_]);
            _loc10_.text = _loc5_.name;
            _loc11_ = this.getLabel("price",_loc3_);
            _loc11_.text = _loc7_;
            if(this.bIsFirstRefresh)
            {
               ank.gapi.controls.Loader(_loc8_._mcRealIcon.attachMovie("GAPILoader","_ldrRealIcon",this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc5_.iconFile}));
               ank.gapi.controls.Loader(_loc8_._mcRealIconRestart.attachMovie("GAPILoader","_ldrRealIconRestart",this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc5_.iconFile}));
               ank.gapi.controls.Loader(_loc8_._mcRouletteBackground1.attachMovie("GAPILoader","_ldrRouletteBackground1",this.getNextHighestDepth(),{autoLoad:true,contentPath:"Roulette" + _loc8_.rouletteStyle + "_1"}));
               ank.gapi.controls.Loader(_loc8_._mcRouletteBackground2.attachMovie("GAPILoader","_ldrRouletteBackground2",this.getNextHighestDepth(),{autoLoad:true,contentPath:"Roulette" + _loc8_.rouletteStyle + "_2"}));
            }
            else
            {
               _loc12_ = ank.gapi.controls.Loader(_loc8_._mcRealIcon._ldrRealIcon);
               ank.gapi.controls.Loader(_loc8_._mcRealIconRestart._ldrRealIconRestart.contentPath = _loc12_.contentPath);
               _loc12_.contentPath = _loc5_.iconFile;
            }
            _loc13_ = 0;
            while(_loc13_ < dofus.aks.ChooseReward.ICONS_NEEDED)
            {
               _loc14_ = _loc6_[_loc13_];
               _loc15_ = _loc8_["_mcFakeIcon" + _loc13_];
               if(this.bIsFirstRefresh)
               {
                  ank.gapi.controls.Loader(_loc15_.attachMovie("GAPILoader","_ldrFakeIcon" + _loc13_,this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc14_.iconFile}));
                  if(_loc13_ == 0)
                  {
                     ank.gapi.controls.Loader(_loc8_._mcFakeIconRestart.attachMovie("GAPILoader","_ldrFakeIconRestart",this.getNextHighestDepth(),{_width:34,_height:34,_x:-17,_y:-17,scaleContent:true,autoLoad:true,contentPath:_loc14_.iconFile}));
                  }
               }
               else
               {
                  _loc16_ = _loc15_["_ldrFakeIcon" + _loc13_];
                  if(_loc13_ == 0)
                  {
                     ank.gapi.controls.Loader(_loc8_._mcFakeIconRestart._ldrFakeIconRestart.contentPath = _loc16_.contentPath);
                  }
                  _loc16_.contentPath = _loc14_.iconFile;
               }
               _loc13_ = _loc13_ + 1;
            }
            if(_loc8_.soldOut)
            {
               _loc8_.soldOut = false;
               _loc8_.gotoAndPlay("restartNoStock");
            }
            else
            {
               _loc8_.gotoAndPlay(!this.bIsFirstRefresh ? "restart" : 1);
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      this.bIsFirstRefresh = false;
      this._lblResetInfos.text = this.api.lang.getText("GT_SHOP_RESET_INFOS",[this.api.datacenter.Gladiatrool.resetPrice,this.api.datacenter.Gladiatrool.resetNumber]);
   }
   function updateInventory()
   {
      if(this._nCurrentRoom != this.api.datacenter.Gladiatrool.currentRoom)
      {
         this._nCurrentRoom = this.api.datacenter.Gladiatrool.currentRoom;
         this.animateProgression(this._nCurrentRoom);
      }
      this._lblTokens.text = "" + this.api.datacenter.Gladiatrool.shopTokens;
      this._lstInfos.clear();
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = this.api.datacenter.Gladiatrool.effects.visibleEffects;
      for(var s in _loc3_)
      {
         _loc2_.push(_loc3_[s]);
      }
      _loc2_.reverse();
      this._lstInfos.dataProvider = _loc2_;
      this._btnReset.enabled = this.api.datacenter.Gladiatrool.shopTokens >= this.api.datacenter.Gladiatrool.resetPrice && this.api.datacenter.Gladiatrool.resetNumber > 0;
      var _loc4_ = this.api.datacenter.Gladiatrool.items;
      var _loc5_ = 0;
      var _loc6_ = dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc6_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_LENGTH)
      {
         _loc7_ = this.getContainer(_loc6_);
         _loc8_ = _loc4_[_loc5_++];
         _loc9_ = _loc8_.realItem;
         if(_loc9_.unicID == -1)
         {
            _loc7_.contentData = undefined;
         }
         else
         {
            _loc7_.contentData = _loc9_;
         }
         _loc6_ = _loc6_ + 1;
      }
   }
   function shopBought(oEvent_)
   {
      var _loc3_ = oEvent_.idx;
      var _loc4_ = this.getContainer(_loc3_);
      _loc4_.contentData = undefined;
      this.setRouletteSoldOut(_loc3_);
   }
   function shopChanged(oEvent_)
   {
      this.updateShop();
   }
   function inventoryChanged(oEvent_)
   {
      this.updateInventory();
   }
   function out(oEvent_)
   {
      this._oCurrentOverItem = undefined;
      this.api.ui.hideTooltip();
   }
   function over(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._btnSell:
            _loc3_ = this.api.datacenter.Gladiatrool.items[this.currentIndex - dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX];
            if(_loc3_ != undefined && _loc3_.realItem.unicID != -1)
            {
               this.api.ui.showTooltip(this.api.lang.getText("SELL_SHOP_TOOLTIP",[_loc3_.price]));
            }
            return;
         case this._ldrHelp:
            this.api.ui.showTooltip(this.api.lang.getText("GT_HELP_1"));
            return;
         default:
            if(oEvent_.target instanceof ank.gapi.controls.Container)
            {
               _loc4_ = dofus.datacenter.Item(oEvent_.target.contentData);
               if(_loc4_ != undefined)
               {
                  _loc4_.showStatsTooltip(_loc4_.style,this.api.lang.getText("RIGHT_CLICK_ITEM_DETAILS"));
               }
               this._oCurrentOverItem = _loc4_;
            }
            return;
      }
   }
   function click(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      switch(oEvent_.target)
      {
         case this._btnHide:
            this.resetSelectedIdx();
            this.windowHidder();
            return;
         case this._btnBuy:
            if(this.api.datacenter.Game.isFight)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
               return;
            }
            _loc3_ = this.currentIndex;
            this.resetSelectedIdx();
            this.api.network.ChooseReward.sendBuyReward(_loc3_);
            this._oCurrentOverItem = undefined;
            return;
            break;
         case this._btnSell:
            if(this.api.datacenter.Game.isFight)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
               return;
            }
            _loc4_ = this.currentIndex;
            this.resetSelectedIdx();
            this.api.network.ChooseReward.sendSellTonic(_loc4_);
            this._oCurrentOverItem = undefined;
            return;
            break;
         case this._btnReset:
            if(this.api.datacenter.Game.isFight)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_BUSY"),"ERROR_CHAT");
               return;
            }
            this.resetSelectedIdx();
            this.api.network.ChooseReward.sendResetShop();
            return;
            break;
         default:
            _loc5_ = Number(oEvent_.target._name.substr(4));
            if(_loc5_ == undefined)
            {
               return undefined;
            }
            this._nCurrentIndex = _loc5_;
            _loc6_ = 0;
            while(_loc6_ < dofus.graphics.gapi.ui.GladiatroolShop.CTR_LENGTH)
            {
               _loc7_ = this.getContainer(_loc6_);
               _loc7_.selected = this.currentIndex == _loc6_;
               _loc6_ = _loc6_ + 1;
            }
            if(this.currentIndex >= dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
            {
               this._btnBuy.enabled = false;
               _loc8_ = this.api.datacenter.Gladiatrool.items[this.currentIndex - dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX];
               if(_loc8_.realItem.unicID == -1)
               {
                  this._btnSell.label = this.api.lang.getText("SELL");
               }
               else
               {
                  this._btnSell.label = this.api.lang.getText("SELL") + " (" + _loc8_.price + ")";
               }
               this._btnSell.enabled = _loc8_.realItem.unicID != -1;
            }
            if(this.currentIndex > -1 && this.currentIndex < dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
            {
               this._btnSell.enabled = false;
               this._btnSell.label = this.api.lang.getText("SELL");
               _loc9_ = this.api.datacenter.Gladiatrool.shopItems[this.currentIndex];
               this._btnBuy.enabled = this.canBeBuy(_loc9_);
               return;
            }
            return;
      }
   }
   function dblClick(oEvent_)
   {
      var _loc3_ = Number(oEvent_.target._name.substr(4));
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this._nCurrentIndex = _loc3_;
      var _loc4_;
      var _loc5_;
      if(this._nCurrentIndex >= dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
      {
         _loc4_ = this.api.datacenter.Gladiatrool.items[this.currentIndex - dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX];
         if(_loc4_.realItem.unicID != -1)
         {
            this.click({target:this._btnSell});
         }
      }
      else if(this._nCurrentIndex > -1 && this._nCurrentIndex < dofus.graphics.gapi.ui.GladiatroolShop.CTR_FIRST_INV_IDX)
      {
         _loc5_ = this.api.datacenter.Gladiatrool.shopItems[this.currentIndex];
         if(this.canBeBuy(_loc5_) && _loc5_.realItem.unicID != -1)
         {
            this.click({target:this._btnBuy});
         }
      }
   }
}
