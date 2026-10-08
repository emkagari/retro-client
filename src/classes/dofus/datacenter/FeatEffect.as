class dofus.datacenter.FeatEffect extends Object
{
   var _aParams;
   var _nIndex;
   var _sFeatEffectInfos;
   var api;
   function FeatEffect(nIndex, aParams)
   {
      super();
      this.api = _global.API;
      this.initialize(nIndex,aParams);
   }
   function get index()
   {
      return this._nIndex;
   }
   function set index(nIndex)
   {
      this._nIndex = nIndex;
   }
   function get description()
   {
      return ank.utils.PatternDecoder.getDescription(this._sFeatEffectInfos,this._aParams);
   }
   function set params(aParams)
   {
      this._aParams = aParams;
   }
   function get params()
   {
      return this._aParams;
   }
   function initialize(nIndex, aParams)
   {
      this._nIndex = nIndex;
      this._aParams = aParams;
      this._sFeatEffectInfos = this.api.lang.getAlignmentFeatEffect(nIndex);
   }
}
