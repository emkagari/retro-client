592610070 - 1;
class dofus.datacenter.Server
{
   var _bCanLog;
   var _bIsLimited;
   var _nCachedTypeNum;
   var _nCharactersCount;
   var _nID;
   var _nState;
   var api;
   var completion;
   var populationWeight;
   static var SERVER_OFFLINE = 0;
   static var SERVER_ONLINE = 1;
   static var SERVER_STARTING = 2;
   static var SERVER_RULES_CLASSIC = 0;
   static var SERVER_RULES_HARDCORE = 1;
   static var SERVER_RULES_MONOACCOUNT = 2;
   static var SERVER_RULES_TEMPORIS = 3;
   static var SERVER_RULES_TOURNAMENT = 4;
   static var SERVER_RULES_SEASONAL = 5;
   static var SERVER_CLASSIC = 0;
   static var SERVER_HARDCORE = 1;
   static var SERVER_129 = 3;
   static var SERVER_RETRO = 4;
   static var SERVER_MONOACCOUNT = 5;
   static var SERVER_TEMPORIS = 6;
   static var SERVER_SEASONAL = 7;
   static var SERVER_SEASONAL_MONOACCOUNT = 8;
   static var SERVER_COMMUNITY_INTERNATIONAL = 2;
   function Server(nID, nState_, nCompletion, bCanLog, bIsLimited)
   {
      this.initialize(nID,nState_,nCompletion,bCanLog,bIsLimited);
      this._nCharactersCount = 0;
   }
   function set id(nID)
   {
      this._nID = nID;
   }
   function get id()
   {
      return this._nID;
   }
   function set charactersCount(nCount)
   {
      this._nCharactersCount = nCount;
   }
   function get charactersCount()
   {
      return this._nCharactersCount;
   }
   function set state(nState)
   {
      this._nState = nState;
   }
   function get state()
   {
      return this._nState;
   }
   function get stateStr()
   {
      switch(this._nState)
      {
         case dofus.datacenter.Server.SERVER_OFFLINE:
            return this.api.lang.getText("SERVER_OFFLINE");
         case dofus.datacenter.Server.SERVER_ONLINE:
            return this.api.lang.getText("SERVER_ONLINE");
         case dofus.datacenter.Server.SERVER_STARTING:
            return this.api.lang.getText("SERVER_STARTING");
         default:
            return "";
      }
   }
   function get stateStrShort()
   {
      switch(this._nState)
      {
         case dofus.datacenter.Server.SERVER_OFFLINE:
            return this.api.lang.getText("SERVER_OFFLINE_SHORT");
         case dofus.datacenter.Server.SERVER_ONLINE:
            if(this._bIsLimited)
            {
               return this.api.lang.getText("SERVER_ONLINE_LIMITED_SHORT");
            }
            return this.api.lang.getText("SERVER_ONLINE_SHORT");
            break;
         case dofus.datacenter.Server.SERVER_STARTING:
            return this.api.lang.getText("SERVER_STARTING_SHORT");
         default:
            return "";
      }
   }
   function set canLog(bCanLog)
   {
      this._bCanLog = bCanLog;
   }
   function get canLog()
   {
      return this._bCanLog;
   }
   function get label()
   {
      return this.api.lang.getServerInfos(this._nID).n;
   }
   function get description()
   {
      return this.api.lang.getServerInfos(this._nID).d;
   }
   function get language()
   {
      return this.api.lang.getServerInfos(this._nID).l;
   }
   function get population()
   {
      return Number(this.api.lang.getServerInfos(this._nID).p);
   }
   function get populationStr()
   {
      return this.api.lang.getServerPopulation(this.population);
   }
   function get community()
   {
      return Number(this.api.lang.getServerInfos(this._nID).c);
   }
   function get communityStr()
   {
      return this.api.lang.getServerCommunity(this.community);
   }
   function get date()
   {
      var _loc2_ = new Date(Number(this.api.lang.getServerInfos(this._nID).date));
      return _loc2_;
   }
   function get dateStr()
   {
      var _loc2_ = new Date(Number(this.api.lang.getServerInfos(this._nID).date));
      return org.utils.SimpleDateFormatter.formatDate(_loc2_,this.api.lang.getConfigText("LONG_DATE_FORMAT"),this.api.config.language);
   }
   function get type()
   {
      return this.api.lang.getText("SERVER_GAME_TYPE_" + this.typeNum);
   }
   function get typeNum()
   {
      if(this._nCachedTypeNum == undefined)
      {
         this._nCachedTypeNum = this.api.lang.getServerInfos(this._nID).t;
      }
      return this._nCachedTypeNum;
   }
   function get iconID()
   {
      return Number(this.api.lang.getServerInfos(this._nID).i);
   }
   function getRulesType()
   {
      var _loc2_ = this.typeNum;
      switch(_loc2_)
      {
         case dofus.datacenter.Server.SERVER_TEMPORIS:
            return dofus.datacenter.Server.SERVER_RULES_TEMPORIS;
         case dofus.datacenter.Server.SERVER_MONOACCOUNT:
            return dofus.datacenter.Server.SERVER_RULES_MONOACCOUNT;
         case dofus.datacenter.Server.SERVER_TEMPORIS:
            return dofus.datacenter.Server.SERVER_RULES_TEMPORIS;
         case dofus.datacenter.Server.SERVER_129:
         case dofus.datacenter.Server.SERVER_RETRO:
            return dofus.datacenter.Server.SERVER_RULES_CLASSIC;
         case dofus.datacenter.Server.SERVER_SEASONAL:
         case dofus.datacenter.Server.SERVER_SEASONAL_MONOACCOUNT:
            return dofus.datacenter.Server.SERVER_RULES_SEASONAL;
         default:
            return _loc2_;
      }
   }
   function isHardcore()
   {
      return this.typeNum == dofus.datacenter.Server.SERVER_HARDCORE;
   }
   function isTemporis()
   {
      return this.typeNum == dofus.datacenter.Server.SERVER_TEMPORIS;
   }
   function isSeasonal()
   {
      return this.typeNum == dofus.datacenter.Server.SERVER_SEASONAL || this.typeNum == dofus.datacenter.Server.SERVER_SEASONAL_MONOACCOUNT;
   }
   function initialize(nID, nState_, nCompletion, bCanLog, bIsLimited)
   {
      this.api = _global.API;
      this._nID = nID;
      this._nState = nState_;
      this._bCanLog = bCanLog;
      this._bIsLimited = bIsLimited;
      this.completion = nCompletion;
      this.populationWeight = Number(this.api.lang.getServerPopulationWeight(this.population));
   }
   function isAllowed()
   {
      if(this.api.datacenter.Player.isAuthorized)
      {
         return true;
      }
      var _loc2_ = this.api.lang.getServerInfos(this._nID).rlng;
      if(_loc2_ == undefined || (_loc2_.length == undefined || (_loc2_.length == 0 || this.api.config.skipLanguageCheck)))
      {
         return true;
      }
      var _loc3_ = 0;
      while(_loc3_ < _loc2_.length)
      {
         if(_loc2_[_loc3_].toUpperCase() == this.api.config.language.toUpperCase())
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function isMonoOldClientBlocked()
   {
      if(this.typeNum != dofus.datacenter.Server.SERVER_MONOACCOUNT && this.typeNum != dofus.datacenter.Server.SERVER_TEMPORIS)
      {
         return false;
      }
      if(this.api.datacenter.Player.isAuthorized)
      {
         return false;
      }
      return !this.api.electron.enabled;
   }
}
