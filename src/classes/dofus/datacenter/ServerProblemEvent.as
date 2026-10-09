class dofus.datacenter.ServerProblemEvent extends Object
{
   var _bTranslated;
   var _nID;
   var _nTimestamp;
   var _sContent;
   var _sHour;
   var _sTitle;
   function ServerProblemEvent(nTimestamp, nEventID, bTranslated, sContent)
   {
      super();
      this._nTimestamp = nTimestamp;
      this._nID = nEventID;
      this._bTranslated = bTranslated;
      this._sContent = sContent;
      var _loc7_ = _global.API;
      this._sTitle = _loc7_.lang.getText("STATUS_EVENT_" + this._nID);
      var _loc8_ = _loc7_.lang.getConfigText("HOUR_FORMAT");
      var _loc9_ = _loc7_.config.language;
      var _loc10_ = new Date(this._nTimestamp);
      this._sHour = org.utils.SimpleDateFormatter.formatDate(_loc10_,_loc8_,_loc9_);
   }
   function get timestamp()
   {
      return this._nTimestamp;
   }
   function get hour()
   {
      return this._sHour;
   }
   function get id()
   {
      return this._nID;
   }
   function get title()
   {
      return this._sTitle;
   }
   function get translated()
   {
      return this._bTranslated;
   }
   function get content()
   {
      return this._sContent;
   }
}
