class dofus.graphics.gapi.controls.encyclopedia.filters.FilterSearchViewer extends dofus.graphics.gapi.controls.encyclopedia.filters.UIBasicFilter
{
   var _oData;
   var _tiSearch;
   var addToQueue;
   var api;
   var dispatchEvent;
   function FilterSearchViewer()
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
      this._tiSearch.text = "";
      this._oData.currentSearch = this._tiSearch.text;
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initText});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function initText()
   {
      this._tiSearch.placeholder = ank.utils.PatternDecoder.combine(this.api.lang.getText("SEARCH_MINIMUM_CHARACTERS",[dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS]),null,dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS <= 1);
      this._tiSearch.restrict = dofus.Constants.INV_SEARCH_RESTRICT;
   }
   function addListeners()
   {
      this._tiSearch.addEventListener("change",this);
   }
   function change(oEvent_)
   {
      var _loc3_ = this._oData.currentSearch;
      var _loc4_ = this._tiSearch.text;
      if(_loc4_ == _loc3_)
      {
         return undefined;
      }
      this._oData.currentSearch = _loc4_;
      if(_loc3_.length < dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS && _loc4_.length < dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS)
      {
         return undefined;
      }
      this.dispatchEvent({type:"filterChanged",value:oEvent_,closeTag:true});
   }
}
