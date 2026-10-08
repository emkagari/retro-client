class dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _eaData;
   var _nSelectedValue;
   var _sProperty;
   static var NO_CHOICE_ID = -1;
   function FilterCategory(sProperty, eaData)
   {
      this._sProperty = sProperty;
      this._eaData = eaData;
      this._nSelectedValue = dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID;
   }
   function get composantName()
   {
      return "FilterCategoryViewer";
   }
   function get list()
   {
      return this._eaData;
   }
   function set selectedValue(nSelectedValue)
   {
      this._nSelectedValue = nSelectedValue;
   }
   function isObjectValid(oObject)
   {
      if(this._nSelectedValue == dofus.graphics.gapi.controls.encyclopedia.filters.FilterCategory.NO_CHOICE_ID)
      {
         return true;
      }
      if(oObject[this._sProperty] instanceof Array)
      {
         for(var i in oObject[this._sProperty])
         {
            if(Number(oObject[this._sProperty][i]) == this._nSelectedValue)
            {
               return true;
            }
         }
         return false;
      }
      return Number(oObject[this._sProperty]) == this._nSelectedValue;
   }
}
