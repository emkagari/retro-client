class dofus.graphics.gapi.controls.InventoryViewerWithAllFilter extends dofus.graphics.gapi.controls.InventoryViewer
{
   var _aSelectedSuperTypes;
   var _btnFilterAll;
   var _btnSearch;
   var _btnSelectedFilterButton;
   var _iifFilter;
   var _nCurrentFilterID;
   var api;
   var dispatchEvent;
   static var DEFAULT_FILTER = 3;
   static var FILTER_ID_ALL = 3;
   static var FILTER_ALL = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,true,true,true];
   function InventoryViewerWithAllFilter()
   {
      super();
   }
   function setFilter(nFilter)
   {
      if(nFilter == this._nCurrentFilterID)
      {
         return undefined;
      }
      if(nFilter == dofus.graphics.gapi.controls.InventoryViewerWithAllFilter.FILTER_ID_ALL)
      {
         this.click({target:this._btnFilterAll});
         this._btnFilterAll.selected = true;
      }
      else
      {
         super.setFilter(nFilter);
      }
   }
   function createChildren()
   {
      super.createChildren();
   }
   function addListeners()
   {
      super.addListeners();
      this._btnFilterAll.addEventListener("click",this);
      this._btnFilterAll.addEventListener("over",this);
      this._btnFilterAll.addEventListener("out",this);
   }
   function getDefaultFilter()
   {
      return dofus.graphics.gapi.controls.InventoryViewerWithAllFilter.FILTER_ID_ALL;
   }
   function setPreferedFilter()
   {
      this.setFilter(this.getDefaultFilter());
   }
   function click(oEvent)
   {
      if(oEvent.target == this._btnFilterAll)
      {
         if(oEvent.target != this._btnSelectedFilterButton)
         {
            this._btnSelectedFilterButton.selected = false;
            this._btnSelectedFilterButton = oEvent.target;
            this._aSelectedSuperTypes = dofus.graphics.gapi.controls.InventoryViewerWithAllFilter.FILTER_ALL;
            this._nCurrentFilterID = dofus.graphics.gapi.controls.InventoryViewerWithAllFilter.FILTER_ID_ALL;
            this._iifFilter = undefined;
            if(this._btnSearch.selected)
            {
               this.enableSearch(false);
               this._btnSearch.selected = false;
            }
            this.updateData();
         }
         else
         {
            oEvent.target.selected = true;
         }
      }
      else
      {
         super.click(oEvent);
      }
      this.dispatchEvent({type:"filterChanged"});
   }
   function over(oEvent)
   {
      if(oEvent.target == this._btnFilterAll)
      {
         this.api.ui.showTooltip(this.api.lang.getText("ALL"));
      }
      else
      {
         super.over(oEvent);
      }
   }
}
