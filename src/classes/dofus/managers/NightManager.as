class dofus.managers.NightManager
{
   var _aMonths;
   var _aSequence;
   var _cdDate;
   var _mcBattlefield;
   var _nDay;
   var _nIntervalID;
   var _nMonth;
   var _nYear;
   var _nYearOffset;
   var _oApi;
   static var STATE_COLORS = [undefined,dofus.Constants.NIGHT_COLOR];
   static var _sSelf = null;
   function NightManager(oApi)
   {
      dofus.managers.NightManager._sSelf = this;
      this._oApi = oApi;
   }
   function get time()
   {
      var _loc2_ = this.getCurrentTime();
      if(new ank.utils.ExtendedString(_loc2_[1]).addLeftChar("0",2) == "undefined")
      {
         return "";
      }
      return new ank.utils.ExtendedString(_loc2_[0]).addLeftChar("0",2) + ":" + new ank.utils.ExtendedString(_loc2_[1]).addLeftChar("0",2);
   }
   function get date()
   {
      return this.getCurrentDateString();
   }
   function initialize(tz, aMonths, nYearOffset, b)
   {
      this._aSequence = tz;
      this._aMonths = aMonths;
      this._nYearOffset = nYearOffset;
      this._mcBattlefield = b;
   }
   function setReferenceTime(nTime, bUseDayNightSystem, currentMap)
   {
      this._cdDate = new ank.utils.CustomDate(nTime,this._aMonths,this._nYearOffset);
      if(bUseDayNightSystem && (currentMap && currentMap.bOutdoor))
      {
         this.clear();
         this.setState();
      }
      else
      {
         this.noEffects();
      }
   }
   function setReferenceDate(nYear, nMonth, nDay)
   {
      this._nYear = nYear;
      this._nDay = nMonth;
      this._nMonth = nDay;
   }
   function clear()
   {
      _global.clearInterval(this._nIntervalID);
   }
   function noEffects()
   {
      this.clear();
      this._mcBattlefield.setColor();
   }
   function getCurrentTime()
   {
      return this._cdDate.getCurrentTime();
   }
   function getCurrentDateString()
   {
      var _loc2_ = this._cdDate.getCurrentDate();
      if(getTimer() - this._oApi.datacenter.Basics.lastDateUpdate > 60000)
      {
         this._oApi.network.Basics.getDate();
      }
      var _loc3_ = this._nYear == undefined ? _loc2_[2] + " " + _loc2_[1] + " " + _loc2_[0] : this._nMonth + " " + this._aMonths[11 - this._nDay][1] + " " + this._nYear;
      return _loc3_;
   }
   function getDiffDate(nTime)
   {
      return this._cdDate.getDiffDate(nTime);
   }
   static function getInstance()
   {
      return dofus.managers.NightManager._sSelf;
   }
   function setState()
   {
      var _loc2_ = this._cdDate.getCurrentMillisInDay();
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ < this._aSequence.length)
      {
         _loc4_ = this._aSequence[_loc3_][1];
         if(_loc2_ < _loc4_)
         {
            _loc5_ = this._aSequence[_loc3_][2];
            this.applyState(_loc5_,_loc4_ - _loc2_,_loc4_);
            return undefined;
         }
         _loc3_ = _loc3_ + 1;
      }
      ank.utils.Logger.err("[setState] ... heu la date " + _loc2_ + " n\'est pas dans la séquence");
   }
   function applyState(oStateColor, nDelay, nEndTime)
   {
      this._mcBattlefield.setColor(oStateColor);
      this.clear();
      this._nIntervalID = _global.setInterval(this,"setState",nDelay,nEndTime);
   }
}
