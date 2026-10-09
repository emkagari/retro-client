453983170 - 1;
class dofus.graphics.gapi.controls.inventoryviewer.InventoryEquipmentFilter implements dofus.graphics.gapi.controls.inventoryviewer.IInventoryFilter
{
   function InventoryEquipmentFilter()
   {
   }
   function isItemListed(item_)
   {
      return !item_.isCeremonial;
   }
}
