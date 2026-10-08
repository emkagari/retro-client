class dofus.managers.TemporisConfigManager extends dofus.utils.ApiElement
{
   var _aKeys;
   function TemporisConfigManager()
   {
      super();
      this.initialize();
   }
   function initialize()
   {
      this._aKeys = [];
   }
   function getIntegerValue(sKey)
   {
      var _loc3_ = Number(this._aKeys[sKey]);
      if(_loc3_ == undefined || _global.isNaN(_loc3_))
      {
         return -1;
      }
      return _loc3_;
   }
   function putIntegerValue(sKey, nValue)
   {
      this._aKeys[sKey] = nValue;
   }
}
