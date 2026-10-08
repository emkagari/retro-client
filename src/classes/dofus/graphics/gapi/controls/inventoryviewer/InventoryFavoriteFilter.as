class dofus.graphics.gapi.controls.inventoryviewer.InventoryFavoriteFilter implements dofus.graphics.gapi.controls.inventoryviewer.IInventoryFilter
{
   function InventoryFavoriteFilter()
   {
   }
   function isItemListed(item_)
   {
      return item_.isLock && dofus.Constants.FILTER_EQUIPEMENT[item_.superType];
   }
}
