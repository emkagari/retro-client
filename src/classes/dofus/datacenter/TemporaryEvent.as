class dofus.datacenter.TemporaryEvent extends Object
{
   var _aRewards;
   var _date;
   var _nCurrentScore;
   var _nEventID;
   var _nTotalScore;
   var _sDescription;
   var _sTitle;
   var api;
   function TemporaryEvent(nEventID, sDescription_, date, nCurrentScore, nTotalScore, aRewards)
   {
      super();
      this.api = _global.API;
      this._nEventID = nEventID;
      this._sTitle = this.api.lang.getText("TEMPORARY_EVENT_" + nEventID);
      this._sDescription = sDescription_;
      this._date = date;
      this._nCurrentScore = nCurrentScore;
      this._nTotalScore = nTotalScore;
      this._aRewards = aRewards;
   }
   function get eventID()
   {
      return this._nEventID;
   }
   function get title()
   {
      return this._sTitle;
   }
   function get description()
   {
      return this._sDescription;
   }
   function get dateString()
   {
      return org.utils.SimpleDateFormatter.formatDate(this._date,this.api.lang.getConfigText("LONG_DATE_FORMAT_HOUR"),this.api.config.language);
   }
   function get currentScore()
   {
      return this._nCurrentScore;
   }
   function get totalScore()
   {
      return this._nTotalScore;
   }
   function get rewards()
   {
      return this._aRewards;
   }
}
