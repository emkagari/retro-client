class dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _bDefault;
   var _bValue;
   var _nMode;
   var _sLabel;
   var _sProperty;
   static var MODE_SHOW = 0;
   static var MODE_INCLUDE = 1;
   static var MODE_FILTER = 2;
   function FilterCheck(sLabel_, sProperty, bDefault, nMode)
   {
      this._sLabel = sLabel_;
      this._sProperty = sProperty;
      this._bValue = bDefault;
      this._bDefault = bDefault;
      this._nMode = nMode;
   }
   function get composantName()
   {
      return "FilterCheckViewer";
   }
   function get text()
   {
      return this._sLabel;
   }
   function set checked(bValue)
   {
      this._bValue = bValue;
   }
   function get checked()
   {
      return this._bValue;
   }
   function get defaultValue()
   {
      return this._bDefault;
   }
   function isObjectValid(oObject)
   {
      var _loc3_ = !!oObject[this._sProperty];
      switch(this._nMode)
      {
         case dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_SHOW:
            return _loc3_ == this._bValue;
         case dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_INCLUDE:
            return _loc3_ == this._bValue || _loc3_ == false;
         case dofus.graphics.gapi.controls.encyclopedia.filters.FilterCheck.MODE_FILTER:
            return _loc3_ == this._bValue || this._bValue == false;
         default:
            return;
      }
   }
}
