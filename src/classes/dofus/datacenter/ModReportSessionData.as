class dofus.datacenter.ModReportSessionData
{
   var _bEnabled;
   var _eoModReportCategories;
   var _sDisabledReasonLangKey;
   static var DEFAULT_DISABLED_REASON_LANG_KEY = "ERROR_226";
   function ModReportSessionData()
   {
   }
   function initialize()
   {
      this._bEnabled = false;
      this._sDisabledReasonLangKey = undefined;
      this._eoModReportCategories = undefined;
   }
   function get isEnabled()
   {
      return this._bEnabled && (this._eoModReportCategories != undefined && this._eoModReportCategories.getLength() > 0);
   }
   function set isEnabled(bEnabled)
   {
      this._bEnabled = bEnabled;
   }
   function get disabledReasonLangKey()
   {
      return this._sDisabledReasonLangKey;
   }
   function get disabledReasonLangKeyWithFallback()
   {
      if(this._sDisabledReasonLangKey == undefined || this._sDisabledReasonLangKey.length == 0)
      {
         return dofus.datacenter.ModReportSessionData.DEFAULT_DISABLED_REASON_LANG_KEY;
      }
      return this._sDisabledReasonLangKey;
   }
   function set disabledReasonLangKey(sDisabledReasonLangKey)
   {
      this._sDisabledReasonLangKey = sDisabledReasonLangKey;
   }
   function get ModReportCategories()
   {
      return this._eoModReportCategories;
   }
   function set ModReportCategories(eoModReportCategories)
   {
      this._eoModReportCategories = eoModReportCategories;
   }
}
