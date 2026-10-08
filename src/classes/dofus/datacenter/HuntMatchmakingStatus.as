class dofus.datacenter.HuntMatchmakingStatus
{
   var _bActive;
   var _sCurrentStatus;
   function HuntMatchmakingStatus(bActive, sCurrentStatus)
   {
      this._bActive = bActive;
      this._sCurrentStatus = sCurrentStatus;
   }
   function get isActive()
   {
      return this._bActive;
   }
   function get currentStatus()
   {
      return this._sCurrentStatus;
   }
}
