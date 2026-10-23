class dofus.datacenter.spellscollection.SpellsDeck
{
   var _eoSpells;
   var _nID;
   var _sName;
   static var DECK_CAPACITY = 14;
   function SpellsDeck(eoSpells, sName, nID)
   {
      this._eoSpells = eoSpells;
      this._sName = sName;
      this._nID = nID;
   }
   static function createEmptySpellsDeck(nID)
   {
      return new dofus.datacenter.spellscollection.SpellsDeck(undefined,undefined,nID);
   }
   function get eoSpells()
   {
      return this._eoSpells;
   }
   function get name()
   {
      return this._sName;
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function get ID()
   {
      return this._nID;
   }
}
