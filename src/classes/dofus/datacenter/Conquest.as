651351098 - 1;
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
      this._cbdAlignBonus = new ank.utils.ExtendedArray();
      this._eaPlayers = new ank.utils.ExtendedArray();
   }
   function get alignBonus()
   {
      return this._cbdAlignMalus;
   }
   function set alignBonus(cbd)
   {
      this._cbdAlignMalus = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get alignMalus()
   {
      return this._cbdRankMultiplicator;
   }
   function set alignMalus(cbd)
   {
      this._cbdRankMultiplicator = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get rankMultiplicator()
   {
      return this._cwdDatas;
   }
   function set rankMultiplicator(cbd)
   {
      this._cwdDatas = cbd;
      this.dispatchEvent({type:"bonusChanged"});
   }
   function get players()
   {
      return this._cbdAlignBonus;
   }
   function set players(value)
   {
      this._cbdAlignBonus = value;
   }
   function get attackers()
   {
      return this._eaPlayers;
   }
   function set attackers(value)
   {
      this._eaPlayers = value;
   }
   function get worldDatas()
   {
      return this._eaAttackers;
   }
   function set worldDatas(value_)
   {
      this._eaAttackers = value_;
      this.dispatchEvent({type:"worldDataChanged",value:value_});
   }
}
