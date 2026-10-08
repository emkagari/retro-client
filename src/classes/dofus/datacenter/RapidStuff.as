class dofus.datacenter.RapidStuff extends Object
{
   var _aItems;
   var _bRide;
   var _nID;
   var _nIcon;
   var _sName;
   function RapidStuff(nIcon, nID, sName_, aItems, bRide)
   {
      super();
      this._nIcon = nIcon;
      this._nID = nID;
      this._sName = sName_;
      if(this._nIcon == undefined || this._nIcon == -1)
      {
         this._nIcon = 0;
      }
      if(this._sName == undefined)
      {
         this._sName = "";
      }
      this._aItems = aItems;
      this._bRide = bRide;
   }
   static function createEmptyRapidStuff(nID)
   {
      return new dofus.datacenter.RapidStuff(undefined,nID);
   }
   function get api()
   {
      return _global.API;
   }
   function get isEmptyRapidStuff()
   {
      return this._nIcon <= 0;
   }
   function get iconID()
   {
      return this._nIcon;
   }
   function get iconFile()
   {
      return dofus.Constants.CUSTOM_SET_ICONS + this._nIcon + ".swf";
   }
   function get id()
   {
      return this._nID;
   }
   function get name()
   {
      return this._sName;
   }
   function get isCustomSet()
   {
      return true;
   }
   function get items()
   {
      return this._aItems;
   }
   function get ride()
   {
      return this._bRide;
   }
}
