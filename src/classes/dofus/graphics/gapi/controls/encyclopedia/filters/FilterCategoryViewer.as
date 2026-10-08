class dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategoryViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _cbList;
   var _oData;
   var _parent;
   var addToQueue;
   var dispatchEvent;
   function FilterCategoryViewer()
   {
      super();
   }
   function get data()
   {
      return this._oData;
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function select(nValue_)
   {
      for(var sSelectableID in this._cbList.dataProvider)
      {
         if(this._cbList.dataProvider[sSelectableID].id == nValue_)
         {
            this._cbList.selectedIndex = Number(sSelectableID);
            break;
         }
      }
      this._oData.selectedValue = nValue_;
      this.dispatchEvent({type:"filterChanged",value:this});
   }
   function reset()
   {
      this._cbList.selectedIndex = 0;
      this._oData.selectedValue = dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID;
   }
   function close()
   {
      this._cbList.closeList();
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initData()
   {
      this._cbList.mcListParent = String(this._parent._parent._parent);
      this._cbList.listLeftMargin = 6;
      this._cbList.dataProvider = this._oData.list;
      this._cbList.selectedIndex = 0;
      var _loc2_ = {x:0,y:0};
      this._cbList.localToGlobal(_loc2_);
      var _loc3_ = Math.floor((432 - _loc2_.y - this._cbList.height) / this._cbList.rowHeight);
      this._cbList.rowCount = Math.max(1,Math.min(this._cbList.rowCount,_loc3_));
   }
   function addListeners()
   {
      this._cbList.addEventListener("itemSelected",this);
   }
   function itemSelected(oEvent_)
   {
      this._oData.selectedValue = this._cbList.selectedItem.id;
      this.dispatchEvent({type:"filterChanged",value:oEvent_});
   }
}
