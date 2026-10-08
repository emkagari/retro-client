class dofus.graphics.gapi.controls.encyclopedia.filters.FilterSearch implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _sCurrentSearch;
   var _sProperty;
   function FilterSearch(sProperty)
   {
      this._sProperty = sProperty;
      this._sCurrentSearch = "";
   }
   function get composantName()
   {
      return "FilterSearchViewer";
   }
   function get property()
   {
      return this._sProperty;
   }
   function get currentSearch()
   {
      return this._sCurrentSearch;
   }
   function set currentSearch(sCurrentSearch)
   {
      this._sCurrentSearch = sCurrentSearch;
   }
   function isObjectValid(oObject)
   {
      if(this._sCurrentSearch == undefined || this._sCurrentSearch.length < dofus.Constants.ACHIEVEMENT_SEARCH_MIN_CHARACTERS)
      {
         return true;
      }
      var _loc3_ = new ank.utils.ExtendedString(this._sCurrentSearch).removeAccents().toUpperCase();
      var _loc4_ = oObject[this._sProperty];
      return _loc4_.indexOf(_loc3_) != -1;
   }
}
