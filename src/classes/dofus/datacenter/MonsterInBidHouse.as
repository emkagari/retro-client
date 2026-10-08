class dofus.datacenter.MonsterInBidHouse
{
   var _nBidHouseType;
   var _nMonsterID;
   var name;
   function MonsterInBidHouse(nMonsterID, nBidHouseType)
   {
      this._nMonsterID = nMonsterID;
      this._nBidHouseType = nBidHouseType;
      this.name = this.api.lang.getMonstersText(this._nMonsterID).n;
   }
   function get api()
   {
      return _global.API;
   }
   function get unicID()
   {
      return this._nMonsterID;
   }
   function get type()
   {
      return this.getAssociatedSoulStoneCategoryID();
   }
   function get label()
   {
      return this.name;
   }
   function get isMonsterInBidHouse()
   {
      return true;
   }
   function get style()
   {
      return "";
   }
   function getAssociatedSoulStoneCategoryID()
   {
      var _loc2_;
      if(this._nBidHouseType == undefined)
      {
         _loc2_ = new dofus.datacenter.Monster(String(this._nMonsterID));
         if(_loc2_.isArchmonster)
         {
            return dofus.datacenter.Item.TYPE_FULL_SOUL_STONE_ARCHI;
         }
         if(_loc2_.isBoss)
         {
            return dofus.datacenter.Item.TYPE_FULL_SOUL_STONE_BOSS;
         }
         return dofus.datacenter.Item.TYPE_FULL_SOUL_STONE_NORMAL;
      }
      return this._nBidHouseType;
   }
}
