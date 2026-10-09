113440257 - 1;
class dofus.datacenter.evenemential.TemporisData
{
   var aDungeonLadderDate;
   var bInvadeActif;
   var eaDungeonRanks;
   var eaDungeons;
   var eaInvadeAreas;
   var eaInvadeRanks;
   var nActualInvade;
   var nCurrentAreaInvadeLevel;
   var nCurrentAreaInvadeTimer;
   var nInvadeTimer;
   var oActualUpgradeRecipe;
   var oDungeonPlayerInfo;
   var oInvadePlayerInfo;
   var aCursedMapDungeons = [20002,20000,20001,20034,20006,20036,20005,20004,20035,20003,20010,20009,20007,20008,20011,20037,20013,20012,20015,20014,20016,20038,20017,20021,20023,20018,20019,20025,20020,20039,20022,20027,20041,20026,20024,20040,20028,20031,20032,20042,20030,20029,20600,20601,20602,20033,20043,20133,20132,20131,20130,20129,20128,20127,20126,20125,20124,20123,20122,20121,20120,20119,20118,20117,20116,20115,20114,20113,20112,20111,20110,20109,20108,20107,20106,20105,20104,20103,20102,20101,20100];
   function TemporisData()
   {
   }
   function set invadeActif(actif)
   {
      this.bInvadeActif = actif;
   }
   function get invadeActif()
   {
      return this.bInvadeActif;
   }
   function set invadeTimer(nTime)
   {
      this.nInvadeTimer = nTime;
   }
   function get invadeTimer()
   {
      return this.nInvadeTimer;
   }
   function set invadeAreas(eaData)
   {
      this.eaInvadeAreas = eaData;
   }
   function get invadeAreas()
   {
      return this.eaInvadeAreas;
   }
   function set actualInvade(invadeID)
   {
      this.nActualInvade = invadeID;
   }
   function get actualInvade()
   {
      return this.nActualInvade;
   }
   function set invadeRanks(eaData)
   {
      this.eaInvadeRanks = eaData;
   }
   function get invadeRanks()
   {
      return this.eaInvadeRanks;
   }
   function set dungeonRanks(eaData)
   {
      this.eaDungeonRanks = eaData;
   }
   function get dungeonRanks()
   {
      return this.eaDungeonRanks;
   }
   function set dungeonLadderDate(aParams)
   {
      this.aDungeonLadderDate = aParams;
   }
   function get dungeonLadderDate()
   {
      return this.aDungeonLadderDate;
   }
   function set invadePlayerInfo(oData)
   {
      this.oInvadePlayerInfo = oData;
   }
   function get invadePlayerInfo()
   {
      return this.oInvadePlayerInfo;
   }
   function set dungeonPlayerInfo(oData)
   {
      this.oDungeonPlayerInfo = oData;
   }
   function get dungeonPlayerInfo()
   {
      return this.oDungeonPlayerInfo;
   }
   function get actualUpgradeRecipe()
   {
      return this.oActualUpgradeRecipe;
   }
   function set actualUpgradeRecipe(oRecipe)
   {
      this.oActualUpgradeRecipe = oRecipe;
   }
   function set dungeons(eaData)
   {
      this.eaDungeons = eaData;
   }
   function get dungeons()
   {
      return this.eaDungeons;
   }
   function set currentAreaInvadeTimer(nTimer)
   {
      this.nCurrentAreaInvadeTimer = nTimer;
   }
   function set currentAreaInvadeLevel(nLevel)
   {
      this.nCurrentAreaInvadeLevel = nLevel;
   }
   function get currentAreaInvadeTimer()
   {
      return this.nCurrentAreaInvadeTimer;
   }
   function get currentAreaInvadeLevel()
   {
      return this.nCurrentAreaInvadeLevel;
   }
   function isCursedDungeonMap(mapId)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.aCursedMapDungeons.length)
      {
         if(mapId == this.aCursedMapDungeons[_loc3_])
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
}
