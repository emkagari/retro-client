class dofus.graphics.gapi.controls.encyclopedia.filters.FilterTagViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _btnClose;
   var _lblText;
   var _oData;
   var addToQueue;
   var dispatchEvent;
   function FilterTagViewer()
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
      this.dispatchEvent({type:"filterClosed",value:this.data});
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
      this._lblText.text = this.data.text;
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
   }
   function click(oEvent_)
   {
      this.dispatchEvent({type:"filterClosed",value:this.data});
   }
}
