class dofus.graphics.gapi.controls.encyclopedia.filters.FilterPropertyValueViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _cbList;
   var _lblInterval;
   var _oData;
   var _parent;
   var _tiValue;
   var addToQueue;
   var dispatchEvent;
   function FilterPropertyValueViewer()
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
   function reset()
   {
      this.setValues(0,this._oData.defaultSelection);
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
      this._lblInterval.text = "≥";
      this._cbList.mcListParent = String(this._parent._parent._parent);
      this._cbList.dataProvider = this._oData.list;
      this._cbList.selectedIndex = 0;
      this._cbList.listLeftMargin = 6;
      var _loc2_ = {x:0,y:0};
      this._cbList.localToGlobal(_loc2_);
      var _loc3_ = Math.floor((432 - _loc2_.y - this._cbList.height) / this._cbList.rowHeight);
      this._cbList.rowCount = Math.max(1,Math.min(this._cbList.rowCount,_loc3_));
      this.setValues(0,this._oData.defaultSelection);
   }
   function addListeners()
   {
      this._cbList.addEventListener("itemSelected",this);
      this._tiValue.addEventListener("change",this);
   }
   function setValues(nInputValue, sPropertyValue)
   {
      this._tiValue.text = "";
      this._tiValue.placeholder = "" + nInputValue;
      this._tiValue.updateFocus();
      this._oData.value = nInputValue;
      this._oData.selectedProperty = sPropertyValue;
      var _loc4_ = 0;
      while(_loc4_ < this._cbList.dataProvider.length)
      {
         if(this._cbList.dataProvider[_loc4_].id == sPropertyValue)
         {
            this._cbList.selectedIndex = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
   }
   function itemSelected(oEvent_)
   {
      this._oData.selectedProperty = this._cbList.selectedItem.id;
      this.dispatchEvent({type:"filterChanged",value:oEvent_});
   }
   function change(oEvent_)
   {
      var _loc3_ = this._tiValue.text == "" ? 0 : Number(this._tiValue.text);
      if(this._oData.value == _loc3_)
      {
         return undefined;
      }
      if(_loc3_ > 999)
      {
         _loc3_ = 999;
      }
      if(_loc3_ < 0)
      {
         _loc3_ = 0;
      }
      this._oData.value = _loc3_;
      this.dispatchEvent({type:"filterChanged",value:oEvent_});
   }
}
