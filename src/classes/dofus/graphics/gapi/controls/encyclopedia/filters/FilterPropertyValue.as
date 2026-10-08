class dofus.graphics.gapi.controls.encyclopedia.filters.FilterPropertyValue implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _eaData;
   var _nValue;
   var _sDefaultSelection;
   var _sProperty;
   var _sSelectedProperty;
   function FilterPropertyValue(sProperty, sDefaultSelection, eaData)
   {
      this._sProperty = sProperty;
      this._eaData = eaData;
      this._nValue = 0;
      this._sSelectedProperty = sDefaultSelection;
      this._sDefaultSelection = sDefaultSelection;
   }
   function get composantName()
   {
      return "FilterPropertyValueViewer";
   }
   function get list()
   {
      return this._eaData;
   }
   function get defaultSelection()
   {
      return this._sDefaultSelection;
   }
   function set selectedProperty(sSelectedProperty)
   {
      this._sSelectedProperty = sSelectedProperty;
   }
   function set value(nValue_)
   {
      this._nValue = nValue_;
   }
   function get value()
   {
      return this._nValue;
   }
   function isObjectValid(oObject)
   {
      if(this._nValue == 0 || this._sSelectedProperty == "")
      {
         return true;
      }
      if(oObject[this._sProperty][this._sSelectedProperty] == undefined)
      {
         return false;
      }
      return Number(oObject[this._sProperty][this._sSelectedProperty]) >= this._nValue;
   }
}
