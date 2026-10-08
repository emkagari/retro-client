class dofus.graphics.gapi.ui.ItemFound extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _alpha;
   var _ldrItem;
   var _nItemId;
   var _nQty;
   var _nRessourceId;
   var _txtDescription;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "ItemFound";
   var _nTimer = 0;
   function ItemFound()
   {
      super();
   }
   function set itemId(nRessourceId)
   {
      this._nRessourceId = nRessourceId;
   }
   function set qty(nQty)
   {
      this._nQty = nQty;
   }
   function set foundItemId(nFoundItemID)
   {
      this._nItemId = nFoundItemID;
   }
   function set timer(nTimer)
   {
      this._nTimer = nTimer;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.ItemFound.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      if(this._nTimer != 0)
      {
         ank.utils.Timer.setTimer(this,"itemFound",this,this.hide,this._nTimer);
      }
   }
   function initTexts()
   {
      var _loc2_ = new dofus.datacenter.Item(0,this._nRessourceId,this._nQty);
      var _loc3_ = new dofus.datacenter.Item(0,this._nItemId,1);
      this._ldrItem.contentPath = _loc2_.iconFile;
      this._txtDescription.text = this.api.lang.getText("ITEM_FOUND",[this._nQty,_loc2_.name,_loc3_.name]);
   }
   function hide()
   {
      this._alpha -= 5;
      if(this._alpha < 1)
      {
         this.unloadThis();
         return undefined;
      }
      this.addToQueue({object:this,method:this.hide});
   }
}
