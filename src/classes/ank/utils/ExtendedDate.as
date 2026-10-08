class ank.utils.ExtendedDate extends Date
{
   function ExtendedDate(nTime)
   {
      super();
      if(nTime != undefined)
      {
         this.setTime(nTime);
      }
   }
   function getDofusFullYear(api)
   {
      return super.getFullYear() + api.lang.getTimeZoneText().z;
   }
   function getDatePadded()
   {
      return this.ensureTwoDigits(super.getDate());
   }
   function getMonthPadded()
   {
      return this.ensureTwoDigits(super.getMonth() + 1);
   }
   function getHoursPadded()
   {
      return this.ensureTwoDigits(super.getHours());
   }
   function getMinutesPadded()
   {
      return this.ensureTwoDigits(super.getMinutes());
   }
   function getSecondsPadded()
   {
      return this.ensureTwoDigits(super.getSeconds());
   }
   function getMillisecondsPadded()
   {
      return new ank.utils.ExtendedString(super.getMilliseconds()).addLeftChar("0",3);
   }
   function ensureTwoDigits(nUnpaddedNumber)
   {
      var _loc3_ = nUnpaddedNumber >= 10 ? "" : "0";
      _loc3_ += nUnpaddedNumber;
      return _loc3_;
   }
   function getFullDateTimeString()
   {
      return super.getFullYear() + "-" + this.getMonthPadded() + "-" + this.getDatePadded() + " " + this.getHoursPadded() + ":" + this.getMinutesPadded() + ":" + this.getSecondsPadded();
   }
}
