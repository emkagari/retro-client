41318046 - 1;
class dofus.graphics.gapi.ui.PlayerShop extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnBuy;
   var _btnClose;
   var _btnViewNextMerchant;
   var _btnViewPreviousMerchant;
   var _colors;
   var _itvItemViewer;
   var _ldrArtwork;
   var _livInventory;
   var _livInventory2;
   var _mcBuyArrow;
   var _oData;
   var _oSelectedItem;
   var _timerSwitchMerchant;
   var _winInventory;
   var _winInventory2;
   var _winItemViewer;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "PlayerShop";
   static var DELAY_BEFORE_CAN_SWITCH_MERCHANT = 500;
   function PlayerShop()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function set colors(aColors)
   {
      this._colors = aColors;
   }
   function get currentOverItem()
   {
      if(this._livInventory != undefined && this._livInventory.currentOverItem != undefined)
      {
         return this._livInventory.currentOverItem;
      }
      if(this._livInventory2 != undefined && this._livInventory2.currentOverItem != undefined)
      {
         return this._livInventory2.currentOverItem;
      }
      return undefined;
   }
   function get itemViewer()
   {
      return this._itvItemViewer;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.PlayerShop.CLASS_NAME);
   }
   function callClose()
   {
      this.api.network.Exchange.leave();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.hideItemViewer(true);
      this.setBuyMode(false);
   }
   function destroy()
   {
      if(this._timerSwitchMerchant == undefined)
      {
         return undefined;
      }
      _global.clearTimeout(this._timerSwitchMerchant);
   }
   function activateSwitchMerchantButtons()
   {
      this._btnViewNextMerchant.enabled = true;
      this._btnViewPreviousMerchant.enabled = true;
   }
   function addListeners()
   {
      this._livInventory.addEventListener("selectedItem",this);
      this._livInventory2.addEventListener("selectedItem",this);
      this._btnBuy.addEventListener("click",this);
      this._btnViewNextMerchant.addEventListener("click",this);
      this._btnViewPreviousMerchant.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._ldrArtwork.addEventListener("complete",this);
      this._ldrArtwork.addEventListener("click",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      if(this._oData != undefined)
      {
         this._oData.addEventListener("modelChanged",this);
      }
      else
      {
         ank.utils.Logger.err("[PlayerShop] il n\'y a pas de data");
      }
      this._timerSwitchMerchant = _global.setTimeout(this,"activateSwitchMerchantButtons",dofus.graphics.gapi.ui.PlayerShop.DELAY_BEFORE_CAN_SWITCH_MERCHANT);
   }
   function initTexts()
   {
      this._btnBuy.label = this.api.lang.getText("BUY");
      this._btnViewNextMerchant.label = this.api.lang.getText("NEXT_WORD");
      this._btnViewPreviousMerchant.label = this.api.lang.getText("PREVIOUS_WORD");
      this._winInventory.title = this.api.datacenter.Player.data.name;
      this._winInventory2.title = this._oData.name;
   }
   function initData()
   {
      this._livInventory.dataProvider = this.api.datacenter.Player.Inventory;
      this._livInventory.kamasProvider = this.api.datacenter.Player;
      this._ldrArtwork.contentPath = dofus.Constants.ARTWORKS_BIG_PATH + this._oData.gfx + ".swf";
      this.modelChanged();
   }
   function hideItemViewer(bHide)
   {
      this._itvItemViewer._visible = !bHide;
      this._winItemViewer._visible = !bHide;
      if(bHide)
      {
         this._oSelectedItem = undefined;
      }
   }
   function setBuyMode(bActive)
   {
      this._btnBuy._visible = bActive;
      this._mcBuyArrow._visible = bActive;
   }
   function askQuantity(nQte, nPrice)
   {
      var _loc4_ = Math.floor(this.api.datacenter.Player.Kama / nPrice);
      if(_loc4_ > nQte)
      {
         _loc4_ = nQte;
      }
      var _loc5_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:_loc4_,min:1,isMaxButtonValidationEnabled:false});
      _loc5_.addEventListener("validate",this);
   }
   function validateBuy(nQuantity)
   {
      if(nQuantity <= 0)
      {
         return undefined;
      }
      nQuantity = Math.min(this._oSelectedItem.Quantity,nQuantity);
      if(this.api.datacenter.Player.Kama < this._oSelectedItem.price * nQuantity)
      {
         this.gapi.loadUIComponent("AskOk","AskOkNotRich",{title:this.api.lang.getText("ERROR_WORD"),text:this.api.lang.getText("NOT_ENOUGH_RICH")});
         return undefined;
      }
      var _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoBuy",{title:this.api.lang.getText("MERCHANT"),text:this.api.lang.getText("DO_U_BUY_ITEM_BIGSTORE",["x" + nQuantity + " " + this._oSelectedItem.name,new ank.utils.ExtendedString(this._oSelectedItem.price * nQuantity).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]),params:{id:this._oSelectedItem.ID,quantity:nQuantity,price:this._oSelectedItem.price}});
      _loc3_.addEventListener("yes",this);
      this.hideItemViewer(true);
      this.setBuyMode(false);
   }
   function yes(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoBuy")
      {
         this.api.network.Exchange.buy(oEvent.target.params.id,oEvent.target.params.quantity);
      }
   }
   function applyColor(mc, zone)
   {
      var _loc4_ = this._colors[zone];
      if(_loc4_ == -1 || _loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_ = (_loc4_ & 0xFF0000) >> 16;
      var _loc6_ = (_loc4_ & 0xFF00) >> 8;
      var _loc7_ = _loc4_ & 0xFF;
      var _loc8_ = new Color(mc);
      var _loc9_ = {};
      _loc9_ = {ra:0,ga:0,ba:0,rb:_loc5_,gb:_loc6_,bb:_loc7_};
      _loc8_.setTransform(_loc9_);
   }
   function switchMerchant(bPrevious)
   {
      var _loc3_ = this.api.datacenter.Temporary.Shop.id;
      var _loc4_ = [];
      var _loc5_ = this.api.gfx.spriteHandler.getSprites().getItems();
      var _loc6_;
      for(var sID in _loc5_)
      {
         _loc6_ = _loc5_[sID];
         if(_loc6_ instanceof dofus.datacenter.OfflineCharacter)
         {
            _loc4_.push({id:sID,cellNum:_loc6_.cellNum});
         }
      }
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(_loc4_.length > 1)
      {
         _loc4_.sortOn(["id"],Array.NUMERIC);
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc8_].id;
            if(_loc9_ == _loc3_)
            {
               if(bPrevious)
               {
                  if(_loc8_ - 1 >= 0)
                  {
                     _loc7_ = _loc4_[_loc8_ - 1];
                     break;
                  }
                  _loc7_ = _loc4_[_loc4_.length - 1];
                  break;
               }
               if(_loc8_ + 1 < _loc4_.length)
               {
                  _loc7_ = _loc4_[_loc8_ + 1];
                  break;
               }
               _loc7_ = _loc4_[0];
               break;
            }
            _loc8_ = _loc8_ + 1;
         }
      }
      if(_loc7_ == null)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("NO_OTHER_MERCHANT_ON_MAP"),"ERROR_CHAT");
         return undefined;
      }
      this._btnViewNextMerchant.enabled = false;
      this._btnViewPreviousMerchant.enabled = false;
      this.api.network.Exchange.leave();
      this.api.kernel.GameManager.startExchange(4,_loc7_.id,_loc7_.cellNum);
   }
   function modelChanged(oEvent)
   {
      this._livInventory2.dataProvider = this._oData.inventory;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._ldrArtwork:
            this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:this._oData.name,sPlayerID:this._oData.characterID});
            break;
         case this._btnViewPreviousMerchant:
            this.switchMerchant(true);
            break;
         case this._btnViewNextMerchant:
            this.switchMerchant(false);
            break;
         case this._btnBuy:
            if(this._oSelectedItem.Quantity > 1)
            {
               this.askQuantity(this._oSelectedItem.Quantity,this._oSelectedItem.price);
            }
            else
            {
               this.validateBuy(1);
            }
            break;
         case this._btnClose:
            this.callClose();
         default:
            return;
      }
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "CODE_NEXT" && this._btnViewNextMerchant.enabled)
      {
         this.switchMerchant(false);
         return false;
      }
      if(sShortcut == "CODE_PREVIOUS" && this._btnViewPreviousMerchant.enabled)
      {
         this.switchMerchant(true);
         return false;
      }
      return true;
   }
   function selectedItem(oEvent)
   {
      if(oEvent.item == undefined)
      {
         this.hideItemViewer(true);
         this.setBuyMode(false);
      }
      else
      {
         this._oSelectedItem = oEvent.item;
         this.hideItemViewer(false);
         this._itvItemViewer.itemData = oEvent.item;
         switch(oEvent.target._name)
         {
            case "_livInventory":
               this.setBuyMode(false);
               this._livInventory2.setFilter(this._livInventory.currentFilterID);
               break;
            case "_livInventory2":
               this.setBuyMode(true);
               this._livInventory.setFilter(this._livInventory2.currentFilterID);
            default:
               return;
         }
      }
   }
   function validate(oEvent)
   {
      this.validateBuy(oEvent.value);
   }
   function complete(oEvent)
   {
      var ref = this;
      this._ldrArtwork.content.stringCourseColor = function(mc_, nColorIndex)
      {
         ref.applyColor(mc_,nColorIndex);
      };
   }
}
