class dofus.datacenter.Specialization extends Object
{
   var _eaFeats;
   var _nIndex;
   var _oSpecInfos;
   var api;
   function Specialization(nIndex)
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
      return this._oSpecInfos.n;
   }
   function get description()
   {
      return this._oSpecInfos.d;
   }
   function get order()
   {
      return new dofus.datacenter.Order(this._oSpecInfos.o);
   }
   function get alignment()
   {
      return new dofus.datacenter.Alignment(this.order.alignment.index,this._oSpecInfos.av);
   }
   function get feats()
   {
      return this._eaFeats;
   }
   function initialize(nIndex)
   {
      this._nIndex = nIndex;
      this._oSpecInfos = this.api.lang.getAlignmentSpecialization(nIndex);
      this._eaFeats = new ank.utils.ExtendedArray();
      var _loc3_ = this._oSpecInfos.f;
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         this._eaFeats.push(new dofus.datacenter.Feat(_loc3_[_loc4_][0],_loc3_[_loc4_][1],_loc3_[_loc4_][2]));
         _loc4_ = _loc4_ + 1;
      }
   }
}
