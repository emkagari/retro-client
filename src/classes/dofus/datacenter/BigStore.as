class dofus.datacenter.BigStore extends dofus.datacenter.Shop
{
   var _aTypes;
   var _eaInventory2;
   var _nMaxItemCount;
   var _nMaxLevel;
   var _nQuantity1;
   var _nQuantity2;
   var _nQuantity3;
   var _nTax;
   var dispatchEvent;
   function BigStore()
   {
      super();
      this.initialize();
   }
   function set quantity1(nQuantity1)
   {
      this._nQuantity1 = nQuantity1;
   }
   function get quantity1()
   {
      return this._nQuantity1;
   }
   function set quantity2(nQuantity2)
   {
      this._nQuantity2 = nQuantity2;
   }
   function get quantity2()
   {
      return this._nQuantity2;
   }
   function set quantity3(nQuantity3)
   {
      this._nQuantity3 = nQuantity3;
   }
   function get quantity3()
   {
      return this._nQuantity3;
   }
   function set types(aTypes)
   {
      this._aTypes = aTypes;
   }
   function get types()
   {
      return this._aTypes;
   }
   function get typesObj()
   {
      var _loc2_ = {};
      for(var k in this._aTypes)
      {
         _loc2_[this._aTypes[k]] = true;
      }
      return _loc2_;
   }
   function set tax(nTax)
   {
      this._eaInventory2 = nTax;
   }
   function get tax()
   {
      return this._eaInventory2;
   }
   function set maxLevel(nMaxLevel)
   {
      this._nMaxLevel = nMaxLevel;
   }
   function get maxLevel()
   {
      return this._nMaxLevel;
   }
   function set maxItemCount(nMaxItemCount)
   {
      this._nMaxItemCount = nMaxItemCount;
   }
   function get maxItemCount()
   {
      return this._nMaxItemCount;
   }
   function set inventory2(eaInventory)
   {
      this._nTax = eaInventory;
      this.dispatchEvent({type:"modelChanged2"});
   }
   function get inventory2()
   {
      return this._nTax;
   }
   function refreshInventory(sEventType)
   {
      this.dispatchEvent({type:sEventType});
   }
}
