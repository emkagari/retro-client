class dofus.datacenter.ItemSet extends Object
{
   var _aEffects;
   var _aItems;
   var _nID;
   var _sEffects;
   var api;
   function ItemSet(nID, aEnabledItemIDs)
   {
      super();
      this.initialize(nID,aEnabledItemIDs);
   }
   function get id()
   {
      return this._nID;
   }
   function get name()
   {
      var _loc2_ = this.api.lang.getItemSetText(this._nID).n;
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      return this.api.lang.getItemSetText(this._nID).d;
   }
   function get itemCount()
   {
      return this._aItems.length;
   }
   function get items()
   {
      return this._aItems;
   }
   function get effects()
   {
      return dofus.datacenter.Item.getItemDescriptionEffects(this._aEffects,undefined,true,false);
   }
   function initialize(nID, aEnabledItemIDs)
   {
      this.api = _global.API;
      var _loc4_ = this.api.datacenter.Player.equippedItems;
      if(_loc4_ == undefined)
      {
         _loc4_ = [];
      }
      if(aEnabledItemIDs == undefined)
      {
         aEnabledItemIDs = [];
      }
      var _loc5_ = aEnabledItemIDs.length;
      this._nID = nID;
      this.setItems(_loc4_,aEnabledItemIDs);
      this.updateEffects();
   }
   function updateEffects()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this._aItems.length)
      {
         if(this._aItems[_loc3_].isEnabled == true)
         {
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = this.api.lang.getItemSetText(this._nID).b["e" + _loc2_];
      if(_loc4_ == undefined)
      {
         _loc4_ = "";
      }
      this.setEffects(_loc4_);
   }
   function setEffects(compressedData)
   {
      this._sEffects = compressedData;
      this._aEffects = [];
      var _loc3_ = compressedData.split(",");
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split("#");
         _loc5_[0] = _global.parseInt(_loc5_[0],16);
         _loc5_[1] = _loc5_[1] != "0" ? _global.parseInt(_loc5_[1],16) : undefined;
         _loc5_[2] = _loc5_[2] != "0" ? _global.parseInt(_loc5_[2],16) : undefined;
         _loc5_[3] = _loc5_[3] != "0" ? _global.parseInt(_loc5_[3],16) : undefined;
         this._aEffects.push(_loc5_);
         _loc4_ = _loc4_ + 1;
      }
   }
   function setItems(aEquippedItemIDs, aEnabledItemIDs)
   {
      var _loc4_ = this.api.lang.getItemSetText(this._nID).i;
      this._aItems = [];
      var _loc5_ = {};
      for(var k in aEquippedItemIDs)
      {
         _loc5_[aEquippedItemIDs[k]] = true;
      }
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = Number(_loc4_[_loc6_]);
         if(!_global.isNaN(_loc7_))
         {
            if(_loc7_ < dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR)
            {
               _loc8_ = new dofus.datacenter.Item(0,_loc7_,1,-1,String(this.api.lang.getItemStats(_loc7_)));
               _loc9_ = _loc5_[_loc7_] == true || (_loc5_[_loc7_ + dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR] == true || _loc5_[_loc7_ + 2 * dofus.datacenter.evenemential.ItemUpgrader.UPGRADE_MULTIPLICATOR] == true);
               _loc10_ = false;
               _loc11_ = 0;
               while(_loc11_ < aEnabledItemIDs.length)
               {
                  if(_loc7_ == aEnabledItemIDs[_loc11_])
                  {
                     _loc10_ = true;
                     break;
                  }
                  _loc11_ = _loc11_ + 1;
               }
               this._aItems.push({isEquiped:_loc9_,isEnabled:_loc10_,item:_loc8_});
            }
         }
         _loc6_ = _loc6_ + 1;
      }
      this.updateEffects();
   }
}
