class dofus.datacenter.ConquestBonusData extends Object
{
   var _nDrop;
   var _nRecolte;
   var _nXp;
   function ConquestBonusData(xp, drop, recolte)
   {
      super();
      this._nRecolte = xp;
      this._nXp = drop;
      this._nDrop = recolte;
   }
   function get xp()
   {
      return this._nRecolte;
   }
   function set xp(value)
   {
      this._nRecolte = value;
   }
   function get drop()
   {
      return this._nXp;
   }
   function set drop(value)
   {
      this._nXp = value;
   }
   function get drop_()
   {
      return this._nDrop;
   }
   function set drop_(value)
   {
      this._nDrop = value;
   }
}
