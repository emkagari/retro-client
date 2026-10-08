649530823 - 1;
class dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheckViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _btnCheck;
   var _lblContent;
   var _oData;
   var addToQueue;
   var api;
   var dispatchEvent;
   function FilterCheckViewer()
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
      this._btnCheck.selected = this.data.defaultValue;
      this.data.checked = this.data.defaultValue;
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
      this._lblContent.text = this.api.lang.getText(this.data.text);
      this._btnCheck.selected = this.data.checked;
   }
   function addListeners()
   {
      this._btnCheck.addEventListener("click",this);
   }
   function click(oEvent_)
   {
      this.data.checked = oEvent_.target.selected;
      this.dispatchEvent({type:"filterChanged",value:oEvent_});
   }
}
