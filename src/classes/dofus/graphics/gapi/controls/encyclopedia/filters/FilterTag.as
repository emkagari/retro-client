class dofus.graphics.gapi.controls.encyclopedia.filters.FilterTag implements dofus.graphics.gapi.controls.encyclopedia.filters.IFilterComposant
{
   var _aValues;
   var _sLabel;
   var _sProperty;
   function FilterTag(sLabel_, sProperty, aValues)
   {
      this._sLabel = sLabel_;
      this._sProperty = sProperty;
      this._aValues = aValues;
   }
   function get composantName()
   {
      return "FilterTagViewer";
   }
   function get text()
   {
      return this._sLabel;
   }
   function isObjectValid(oObject)
   {
      for(var i in this._aValues)
      {
         if(this.isObjectValidForValue(oObject,this._aValues[i]))
         {
            return true;
         }
      }
      return false;
   }
   function isObjectValidForValue(oObject, nValue_)
   {
      if(oObject[this._sProperty] instanceof Array)
      {
         for(var i in oObject[this._sProperty])
         {
            if(Number(oObject[this._sProperty][i]) == nValue_)
            {
               return true;
            }
         }
         return false;
      }
      return Number(oObject[this._sProperty]) == nValue_;
   }
}
