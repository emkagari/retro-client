class dofus.datacenter.GuildRanks
{
   var _oNameList;
   var api;
   function GuildRanks()
   {
      this._oNameList = {};
      this.api = _global.API;
   }
   function setRankCustomName(nID, sName)
   {
      this._oNameList[nID] = sName;
   }
   function resetAllRankCustomName()
   {
      this._oNameList = {};
   }
   function resetRankCustomName(nID)
   {
      this._oNameList[nID] = undefined;
   }
   function getRankName(nID)
   {
      var _loc3_ = this.api.lang.getRankInfos(nID);
      if(this._oNameList[nID] != undefined)
      {
         return this._oNameList[nID];
      }
      return _loc3_.n;
   }
}
