class dofus.graphics.gapi.controls.encyclopedia.filters.FilterLabelViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _lblText;
   var _oData;
   var addToQueue;
   var api;
   function FilterLabelViewer()
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
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
   }
   function initData()
   {
      this._lblText.text = this.api.lang.getText(this._oData.text);
   }
}
