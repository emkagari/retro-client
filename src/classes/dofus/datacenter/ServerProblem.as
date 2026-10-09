class dofus.datacenter.ServerProblem extends Object
{
   var _aHistory;
   var _aServers;
   var _nDate;
   var _nID;
   var _nStatus;
   var _nType;
   var _sDate;
   var _sStatus;
   var _sType;
   function ServerProblem(nID, nDate, nType, nStatus, aServers, aHistory)
   {
      super();
      this._nID = nID;
      this._nDate = nDate;
      this._nType = nType;
      this._nStatus = nStatus;
      this._aServers = aServers;
      this._aHistory = aHistory;
      var _loc9_ = _global.API;
      this._sType = _loc9_.lang.getText("STATUS_PROBLEM_" + this._nType);
      this._sStatus = _loc9_.lang.getText("STATUS_STATE_" + this._nStatus);
      var _loc10_ = _loc9_.lang.getConfigText("LONG_DATE_FORMAT");
      var _loc11_ = _loc9_.config.language;
      var _loc12_ = String(this._nDate);
      var _loc13_ = new Date(Number(_loc12_.substr(0,4)),Number(_loc12_.substr(4,2)) - 1,Number(_loc12_.substr(6,2)));
      this._sDate = org.utils.SimpleDateFormatter.formatDate(_loc13_,_loc10_,_loc11_);
   }
   function get id()
   {
      return this._nID;
   }
   function get date()
   {
      return this._sDate;
   }
   function get type()
   {
      return this._sType;
   }
   function get status()
   {
      return this._sStatus;
   }
   function get servers()
   {
      return this._aServers;
   }
   function get history()
   {
      return this._aHistory;
   }
}
