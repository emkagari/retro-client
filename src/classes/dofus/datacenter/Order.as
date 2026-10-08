class dofus.datacenter.Order extends Object
{
   var _nIndex;
   var _oOrderInfos;
   var api;
   function Order(nIndex)
   {
      super();
      this.api = _global.API;
      this.initialize(nIndex);
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
      return this._oOrderInfos.n;
   }
   function get alignment()
   {
      return new dofus.datacenter.Alignment(this._oOrderInfos.a);
   }
   function get iconFile()
   {
      return dofus.Constants.ORDERS_PATH + this._nIndex + ".swf";
   }
   function initialize(nIndex)
   {
      this._nIndex = nIndex;
      this._oOrderInfos = this.api.lang.getAlignmentOrder(nIndex);
   }
}
