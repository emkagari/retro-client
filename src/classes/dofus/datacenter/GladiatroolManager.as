class dofus.datacenter.GladiatroolManager extends Object
{
   var _aItems;
   var _aShopItems;
   var _aTokens;
   var _nCurrentRoom;
   var _nResetNb;
   var _nResetPrice;
   var _nShopTokens;
   var _oWonEffects;
   var dispatchEvent;
   static var aIncarnations = [12782,12783,12784,12785,12786,12787,12788,12789,12790,12791,12792,12793,13205,13206,13207,13208,13209,13210,13211,13212,13213,13214,13215,13216];
   static var FIRST_GLADIATROOL_CONTAINER = 65;
   static var LAST_GLADIATROOL_CONTAINER = 96;
   function GladiatroolManager()
   {
      super();
      mx.events.EventDispatcher.initialize(this);
   }
   function set currentRoom(nCurrentRoom)
   {
      this._nCurrentRoom = nCurrentRoom;
   }
   function set tokens(aTokens)
   {
      this._aTokens = aTokens;
   }
   function set effects(oEffects)
   {
      this._oWonEffects = oEffects;
   }
   function set shopItems(aShopItems)
   {
      this._aShopItems = aShopItems;
      this.dispatchEvent({type:"shopChanged"});
   }
   function set shopTokens(nShopTokens)
   {
      this._nShopTokens = nShopTokens;
      this.dispatchEvent({type:"inventoryChanged"});
   }
   function set items(aItems)
   {
      this._aItems = aItems;
      this.dispatchEvent({type:"inventoryChanged"});
   }
   function set resetPrice(nPrice_)
   {
      this._nResetPrice = nPrice_;
   }
   function set resetNumber(nResetNb)
   {
      this._nResetNb = nResetNb;
   }
   function get currentRoom()
   {
      return this._nCurrentRoom;
   }
   function get tokens()
   {
      return this._aTokens;
   }
   function get shopItems()
   {
      return this._aShopItems;
   }
   function get shopTokens()
   {
      return this._nShopTokens;
   }
   function get items()
   {
      return this._aItems;
   }
   function get effects()
   {
      return this._oWonEffects;
   }
   function get resetPrice()
   {
      return this._nResetPrice;
   }
   function get resetNumber()
   {
      return this._nResetNb;
   }
   function removeShopItem(nIndex_)
   {
      this._aShopItems[nIndex_] = {realItem:-1,price:-1};
      this.dispatchEvent({type:"shopBought",idx:nIndex_});
   }
   function isIncarnation(nItemId)
   {
      var _loc3_ = 0;
      while(_loc3_ < dofus.datacenter.GladiatroolManager.aIncarnations.length)
      {
         if(dofus.datacenter.GladiatroolManager.aIncarnations[_loc3_] == nItemId)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function getTonicItems()
   {
      var _loc2_ = _global.API.datacenter.Player.InventoryByItemPositions;
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = dofus.datacenter.GladiatroolManager.FIRST_GLADIATROOL_CONTAINER;
      var _loc5_;
      while(_loc4_ < dofus.datacenter.GladiatroolManager.LAST_GLADIATROOL_CONTAINER + 1)
      {
         _loc5_ = _loc2_.getItemAt(_loc4_);
         if(_loc5_ != undefined)
         {
            _loc3_.push(_loc5_);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
}
