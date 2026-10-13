class dofus.datacenter.spellscollection.SpellsCollectionItemObject
{
   var _oSpell;
   function SpellsCollectionItemObject(oSpell)
   {
      this._oSpell = oSpell;
   }
   function get spell()
   {
      return this._oSpell;
   }
   function get iconFile()
   {
      return "SpellsCollectionItem";
   }
   function get forceReloadOnContainer()
   {
      return true;
   }
   function get params()
   {
      return {spell:this._oSpell};
   }
}
