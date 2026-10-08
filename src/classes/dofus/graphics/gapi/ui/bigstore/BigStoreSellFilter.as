class dofus.graphics.gapi.ui.bigstore.BigStoreSellFilter implements dofus.graphics.gapi.controls.inventoryviewer.IInventoryFilter
{
   var _nMaximalLevel = null;
   var _aAllowedTypes = null;
   var _bShowCeremonials = false;
   var _bShowEquipment = false;
   function BigStoreSellFilter(maximalLevel, allowedTypes, bShowCeremonials, bShowEquipment)
   {
      this._nMaximalLevel = maximalLevel;
      this._aAllowedTypes = allowedTypes;
      this._bShowCeremonials = bShowCeremonials;
      this._bShowEquipment = bShowEquipment;
   }
   function isItemListed(item)
   {
      if(!item.canBeExchange)
      {
         return false;
      }
      if(this._nMaximalLevel != null && item.level > this._nMaximalLevel)
      {
         return false;
      }
      if(item.isAssociateWithLivingItem)
      {
         return false;
      }
      var _loc3_ = false;
      for(var i in this._aAllowedTypes)
      {
         if(item._bIsSkineable == Number(this._aAllowedTypes[i]))
         {
            _loc3_ = true;
            break;
         }
      }
      if(!_loc3_)
      {
         return false;
      }
      if(this._bShowCeremonials && !item.isCeremonial)
      {
         return false;
      }
      if(this._bShowEquipment && item.isCeremonial)
      {
         return false;
      }
      return true;
   }
}
