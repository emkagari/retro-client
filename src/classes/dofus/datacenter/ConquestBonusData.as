class dofus.datacenter.ConquestBonusData extends Object
{
   var _nDrop;
   var _nRecolte;
   var _nXp;
   function ConquestBonusData(xp, drop, recolte)
   {
      super();
      this._nXp = xp;
      this._nDrop = drop;
      this._nRecolte = recolte;
   }
   function get xp()
   {
      return this._nXp;
   }
   function set xp(value)
   {
      this._nXp = value;
   }
   function get drop()
   {
      return this._nDrop;
   }
   function set drop(value)
   {
      this._nDrop = value;
   }
   function get drop_()
   {
      return this._nRecolte;
   }
   function set drop_(value)
   {
      this._nRecolte = value;
   }
}
