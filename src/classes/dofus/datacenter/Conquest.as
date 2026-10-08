class dofus.datacenter.Conquest extends Object
{
   var _cbdAlignBonus;
   var _cbdAlignMalus;
   var _cbdRankMultiplicator;
   var _cwdDatas;
   var _eaAttackers;
   var _eaPlayers;
   var dispatchEvent;
   function Conquest()
   {
      super();
      this.clear();
      mx.events.EventDispatcher.initialize(this);
   }
   function clear()
   {
      this._cwdDatas = new ank.utils.ExtendedArray();
      this._cbdRankMultiplicator = new ank.utils.ExtendedArray();
   }
   function get alignBonus()
   {
      return this._eaAttackers;
   }
   function set alignBonus(cbd)
   {
      this._eaAttackers = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get alignMalus()
   {
      return this._cbdAlignBonus;
   }
   function set alignMalus(cbd)
   {
      this._cbdAlignBonus = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get rankMultiplicator()
   {
      return this._eaPlayers;
   }
   function set rankMultiplicator(cbd)
   {
      this._eaPlayers = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get players()
   {
      return this._cwdDatas;
   }
   function set players(value)
   {
      this._cwdDatas = value;
   }
   function get attackers()
   {
      return this._cbdRankMultiplicator;
   }
   function set attackers(value)
   {
      this._cbdRankMultiplicator = value;
   }
   function get worldDatas()
   {
      return this._cbdAlignMalus;
   }
   function set worldDatas(value_)
   {
      this._cbdAlignMalus = value_;
      this.dispatchEvent({type:"worldDataChanged",value:value_});
   }
}
