class dofus.datacenter.Rank extends Object
{
   var _bEnabled;
   var _nDisgrace;
   var _nHonour;
   var _nValue;
   var api;
   function Rank(nValue, nHonour, nDisgrace, bEnabled)
   {
      super();
      this.api = _global.API;
      this.initialize(nValue,nHonour,nDisgrace,bEnabled);
   }
   function get value()
   {
      return this._nValue;
   }
   function set value(v)
   {
      this._nValue = v;
   }
   function get honour()
   {
      return this._nHonour;
   }
   function set honour(v)
   {
      this._nHonour = v;
   }
   function get disgrace()
   {
      return this._nDisgrace;
   }
   function set disgrace(v)
   {
      this._nDisgrace = v;
   }
   function get enable()
   {
      return this._bEnabled;
   }
   function set enable(v)
   {
      this._bEnabled = v;
   }
   function initialize(nValue, nHonour, nDisgrace, bEnabled)
   {
      this._nValue = !(_global.isNaN(nValue) || nValue == undefined) ? nValue : 0;
      this._nHonour = !(_global.isNaN(nHonour) || nHonour == undefined) ? nHonour : 0;
      this._nDisgrace = !(_global.isNaN(nDisgrace) || nDisgrace == undefined) ? nDisgrace : 0;
      this._bEnabled = bEnabled != undefined ? bEnabled : false;
   }
   function clone()
   {
      return new dofus.datacenter.Rank(this._nValue,this._nHonour,this._nDisgrace,this._bEnabled);
   }
}
