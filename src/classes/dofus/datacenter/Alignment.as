class dofus.datacenter.Alignment implements com.ankamagames.interfaces.IComparable
{
   var _nIndex;
   var _nValue;
   var api;
   var fallenAngelDemon = false;
   function Alignment(nIndex, nValue)
   {
      this.api = _global.API;
      this.initialize(nIndex,nValue);
   }
   function get index()
   {
      return this._nIndex;
   }
   function set index(nIndex)
   {
      this._nIndex = !(_global.isNaN(nIndex) || nIndex == undefined) ? nIndex : 0;
   }
   function get name()
   {
      if(this._nIndex == -1)
      {
         return "";
      }
      return this.api.lang.getAlignment(this._nIndex).n;
   }
   function get value()
   {
      return this._nValue;
   }
   function set value(nValue)
   {
      this._nValue = !(_global.isNaN(nValue) || nValue == undefined) ? nValue : 0;
   }
   function get frame()
   {
      if(this._nValue <= 20)
      {
         return 1;
      }
      if(this._nValue <= 40)
      {
         return 2;
      }
      if(this._nValue <= 60)
      {
         return 3;
      }
      if(this._nValue <= 80)
      {
         return 4;
      }
      return 5;
   }
   function get iconFile()
   {
      return dofus.Constants.ALIGNMENTS_PATH + this._nIndex + ".swf";
   }
   function initialize(nIndex, nValue)
   {
      this._nIndex = !(_global.isNaN(nIndex) || nIndex == undefined) ? nIndex : 0;
      this._nValue = !(_global.isNaN(nValue) || nValue == undefined) ? nValue : 0;
   }
   function clone()
   {
      return new dofus.datacenter.Alignment(this._nIndex,this._nValue);
   }
   function compareTo(obj)
   {
      var _loc3_ = dofus.datacenter.Alignment(obj);
      if(_loc3_.index == this._nIndex)
      {
         return 0;
      }
      return -1;
   }
}
