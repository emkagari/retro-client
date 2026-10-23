class dofus.graphics.gapi.controls.encyclopedia.filters.FilterInterval implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _nDefaultMax;
   var _nDefaultMin;
   var _nMax;
   var _nMin;
   var _sLabel;
   var _sPropertyMax;
   var _sPropertyMin;
   function FilterInterval(sLabel_, sPropertyMin, sPropertyMax, nDefaultMin, nDefaultMax)
   {
      this._sLabel = sLabel_;
      this._sPropertyMin = sPropertyMin;
      this._sPropertyMax = sPropertyMax;
      this._nDefaultMin = nDefaultMin;
      this._nDefaultMax = nDefaultMax;
      this._nMin = nDefaultMin;
      this._nMax = nDefaultMax;
   }
   function get composantName()
   {
      return "FilterIntervalViewer";
   }
   function get propertyMin()
   {
      return this._sPropertyMin;
   }
   function get propertyMax()
   {
      return this._sPropertyMax;
   }
   function get label()
   {
      return this._sLabel;
   }
   function get defaultMax()
   {
      return this._nDefaultMax;
   }
   function get defaultMin()
   {
      return this._nDefaultMin;
   }
   function set max(nMax)
   {
      this._nMax = nMax;
   }
   function get max()
   {
      return this._nMax;
   }
   function set min(nMin)
   {
      this._nMin = nMin;
   }
   function get min()
   {
      return this._nMin;
   }
   function isObjectValid(oObject)
   {
      var _loc3_ = Number(oObject[this.propertyMin]);
      var _loc4_ = Number(oObject[this.propertyMax]);
      return _loc3_ >= this._nMin && _loc4_ <= this._nMax;
   }
}
