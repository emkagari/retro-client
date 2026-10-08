class dofus.datacenter.InventoryShortcutItem extends Object
{
   var _nGenericID;
   var _nPosition;
   var _nType;
   var _oRealItem;
   var _oUnicInfos;
   var _sEffects;
   var api;
   static var OBJI_DEFAULT_FRAME = "H0";
   function InventoryShortcutItem(nObjectID, nPosition, nType, sEffects)
   {
      super();
      this.api = _global.API;
      this._nGenericID = nObjectID;
      this._nPosition = nPosition;
      this._sEffects = sEffects;
      this._nType = nType;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            this._oUnicInfos = this.api.lang.getItemUnicText(this._nGenericID);
            break;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            this._oUnicInfos = this.api.datacenter.Player.RapidStuffs.getItemAt(this._nGenericID);
         default:
            return;
      }
   }
   function getEquipedRealItem()
   {
      if(this._nType != dofus.Constants.ITEM_SHORTCUT)
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Player.InventoryByItemPositions.getItems();
      var _loc3_;
      for(var k in _loc2_)
      {
         _loc3_ = _loc2_[k];
         if(_loc3_.unicID == this._nGenericID)
         {
            if(_loc3_.compressedEffects == this._sEffects)
            {
               return _loc3_;
            }
         }
      }
      return undefined;
   }
   function getRealItem()
   {
      if(this._nType != dofus.Constants.ITEM_SHORTCUT)
      {
         return undefined;
      }
      var _loc2_;
      if(this._oRealItem != undefined)
      {
         if(!this._oRealItem.isEquiped)
         {
            _loc2_ = this.getEquipedRealItem();
            if(_loc2_ != undefined)
            {
               this._oRealItem = _loc2_;
               return this._oRealItem;
            }
         }
         if(!this._oRealItem.isRemovedFromInventory)
         {
            return this._oRealItem;
         }
      }
      var _loc3_ = this.api.datacenter.Player.Inventory;
      var _loc5_;
      var _loc4_;
      for(var k in _loc3_)
      {
         _loc5_ = _loc3_[k];
         if(_loc5_.unicID == this._nGenericID)
         {
            if(_loc5_.compressedEffects == this._sEffects)
            {
               _loc4_ = _loc5_;
               if(_loc5_.isEquiped)
               {
                  break;
               }
            }
         }
      }
      this._oRealItem = _loc4_;
      return this._oRealItem;
   }
   function get label()
   {
      if(this.isRealItemEquiped)
      {
         return "Eq";
      }
      var _loc2_ = this.Quantity;
      if(_loc2_ > 1)
      {
         return String(_loc2_);
      }
      return undefined;
   }
   function get realLinkedItem()
   {
      return this.getRealItem();
   }
   function get genericID()
   {
      return this._nGenericID;
   }
   function get position()
   {
      return this._nPosition;
   }
   function get compressedEffects()
   {
      return this._sEffects;
   }
   function get type()
   {
      var _loc2_ = this.getRealItem();
      return _loc2_ == undefined ? Number(this._oUnicInfos.t) : _loc2_.type;
   }
   function get gfx()
   {
      var _loc2_;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            _loc2_ = this.getRealItem();
            return _loc2_ == undefined ? this._oUnicInfos.g : _loc2_.gfx;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return this._oUnicInfos.iconID;
         default:
            return "";
      }
   }
   function get iconFile()
   {
      var _loc2_;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            _loc2_ = this.getRealItem();
            return _loc2_ == undefined ? dofus.Constants.ITEMS_PATH + this.type + "/" + this.gfx + ".swf" : _loc2_.iconFile;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return this._oUnicInfos.iconFile;
         default:
            return "";
      }
   }
   function get params()
   {
      if(this.getRealItem() != undefined)
      {
         return this._oRealItem.params;
      }
      return {frame:dofus.datacenter.InventoryShortcutItem.OBJI_DEFAULT_FRAME};
   }
   function get isRealItemEquiped()
   {
      return this.getRealItem() == undefined ? false : this._oRealItem.isEquiped;
   }
   function get ID()
   {
      var _loc2_;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            _loc2_ = this.getRealItem();
            return _loc2_ == undefined ? -1 : _loc2_.ID;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return this._oUnicInfos.id;
         default:
            return -1;
      }
   }
   function get Quantity()
   {
      var _loc2_;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            _loc2_ = this.getRealItem();
            return _loc2_ == undefined ? 0 : _loc2_.Quantity;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return 1;
         default:
            return 0;
      }
   }
   function get canUse()
   {
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            return this.getRealItem().canUse;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return true;
         default:
            return false;
      }
   }
   function get canTarget()
   {
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            return this.getRealItem().canTarget;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return false;
         default:
            return false;
      }
   }
   function get isWeapon()
   {
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            return this.getRealItem().isWeapon;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return false;
         default:
            return false;
      }
   }
   function get isSoulStone()
   {
      return this.getRealItem().isCaptureItem;
   }
   function get isEquipable()
   {
      return this.getRealItem().isEquipable;
   }
   function get name()
   {
      var _loc2_;
      switch(this._nType)
      {
         case dofus.Constants.ITEM_SHORTCUT:
            _loc2_ = ank.utils.PatternDecoder.getDescription(this.api.lang.fetchString(this._oUnicInfos.n),this.api.lang.getItemUnicStringText());
            if(dofus.Constants.DEBUG)
            {
               _loc2_ += " (" + this._nGenericID + ")";
            }
            return _loc2_;
         case dofus.Constants.CUSTOM_SET_SHORTCUT:
            return this._oUnicInfos.name;
         default:
            return "";
      }
   }
   function get style()
   {
      var _loc0_;
      var _loc2_;
      if((_loc0_ = this._nType) === dofus.Constants.ITEM_SHORTCUT)
      {
         _loc2_ = this.getRealItem();
         if(_loc2_ == undefined)
         {
            _loc2_ = new dofus.datacenter.Item(undefined,this._nGenericID);
         }
         if(_loc2_.style != "")
         {
            return _loc2_.style + "ToolTip";
         }
      }
      return "";
   }
   function get isShortcut()
   {
      return true;
   }
   function get isCustomSet()
   {
      return this._nType == dofus.Constants.CUSTOM_SET_SHORTCUT;
   }
   function updateCustomSet()
   {
      this._oUnicInfos = this.api.datacenter.Player.RapidStuffs.getItemAt(this._nGenericID);
   }
   function get linkedCustomSet()
   {
      return this._oUnicInfos;
   }
   function get cornerIconFile()
   {
      if(this._nType == dofus.Constants.CUSTOM_SET_SHORTCUT)
      {
         return "";
      }
      return this._oRealItem.cornerIconFile;
   }
}
