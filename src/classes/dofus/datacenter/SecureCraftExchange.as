class dofus.datacenter.SecureCraftExchange extends dofus.datacenter.Exchange
{
   var _eaCoopGarbage;
   var _eaPayGarbage;
   var _eaPayIfSuccessGarbage;
   var dispatchEvent;
   var _nPayKama = 0;
   var _nPayIfSuccessKama = 0;
   function SecureCraftExchange(nDistantPlayerID)
   {
      super();
      this.initialize(nDistantPlayerID);
   }
   function get coopGarbage()
   {
      return this._eaCoopGarbage;
   }
   function get payIfSuccessGarbage()
   {
      return this._eaPayIfSuccessGarbage;
   }
   function get payGarbage()
   {
      return this._eaPayGarbage;
   }
   function set payKama(nKama)
   {
      this._nPayKama = nKama;
      this.dispatchEvent({type:"payKamaChange",value:nKama});
   }
   function get payKama()
   {
      return this._nPayKama;
   }
   function set payIfSuccessKama(nKama)
   {
      this._nPayIfSuccessKama = nKama;
      this.dispatchEvent({type:"payIfSuccessKamaChange",value:nKama});
   }
   function get payIfSuccessKama()
   {
      return this._nPayIfSuccessKama;
   }
   function initialize(nDistantPlayerID)
   {
      super.initialize(nDistantPlayerID);
      this._eaCoopGarbage = new ank.utils.ExtendedArray();
      this._eaPayIfSuccessGarbage = new ank.utils.ExtendedArray();
      this._eaPayGarbage = new ank.utils.ExtendedArray();
   }
   function clearCoopGarbage()
   {
      this._eaCoopGarbage.removeAll();
   }
   function clearPayIfSuccessGarbage()
   {
      this._eaPayIfSuccessGarbage.removeAll();
   }
   function clearPayGarbage()
   {
      this._eaPayGarbage.removeAll();
   }
}
