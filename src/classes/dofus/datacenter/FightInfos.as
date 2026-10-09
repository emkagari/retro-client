class dofus.datacenter.FightInfos extends Object
{
   var _eaTeam1Players;
   var _eaTeam2Players;
   var _nID;
   var _nTeam1AlignmentIndex;
   var _nTeam1Count;
   var _nTeam1Type;
   var _nTeam2AlignmentIndex;
   var _nTeam2Count;
   var _nTeam2Type;
   var api;
   var duration;
   function FightInfos(nID, nDuration)
   {
      super();
      this.initialize(nID,nDuration);
   }
   function get id()
   {
      return this._nID;
   }
   function get durationString()
   {
      return this.api.kernel.GameManager.getDurationString(this.duration);
   }
   function get hasTeamPlayers()
   {
      return this._eaTeam1Players != undefined && this._eaTeam2Players != undefined;
   }
   function get team1IconFile()
   {
      return dofus.Constants.getTeamFileFromType(this._nTeam1Type,this._nTeam1AlignmentIndex);
   }
   function get team1Count()
   {
      return this._nTeam1Count;
   }
   function get team1Players()
   {
      return this._eaTeam1Players;
   }
   function get team1Level()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this._eaTeam1Players.length)
      {
         _loc2_ += this._eaTeam1Players[_loc3_].level;
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function get team2IconFile()
   {
      return dofus.Constants.getTeamFileFromType(this._nTeam2Type,this._nTeam2AlignmentIndex);
   }
   function get team2Count()
   {
      return this._nTeam2Count;
   }
   function get team2Players()
   {
      return this._eaTeam2Players;
   }
   function get team2Level()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this._eaTeam2Players.length)
      {
         _loc2_ += this._eaTeam2Players[_loc3_].level;
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_;
   }
   function initialize(nID, nDuration)
   {
      this.api = _global.API;
      this._nID = nID;
      this.duration = nDuration;
   }
   function addTeam(nIndex, nType, nAlignmentIndex, nCount)
   {
      switch(nIndex)
      {
         case 1:
            this._nTeam1Type = nType;
            this._nTeam1AlignmentIndex = nAlignmentIndex;
            this._nTeam1Count = nCount;
            break;
         case 2:
            this._nTeam2Type = nType;
            this._nTeam2AlignmentIndex = nAlignmentIndex;
            this._nTeam2Count = nCount;
         default:
            return;
      }
   }
   function addPlayers(nIndex, eaPlayers)
   {
      switch(nIndex)
      {
         case 1:
            this._eaTeam1Players = eaPlayers;
            break;
         case 2:
            this._eaTeam2Players = eaPlayers;
         default:
            return;
      }
   }
}
