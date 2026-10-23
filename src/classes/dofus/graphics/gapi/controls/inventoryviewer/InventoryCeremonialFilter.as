class dofus.graphics.gapi.controls.inventoryviewer.InventoryCeremonialFilter implements dofus.graphics.gapi.controls.inventoryviewer.IInventoryFilter
{
   function InventoryCeremonialFilter()
   {
   }
   function isItemListed(item_)
   {
      return item_.isCeremonial;
   }
}
