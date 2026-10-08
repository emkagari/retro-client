class dofus.datacenter.Game extends Object
{
   var _aFightMonsters;
   var _bRunning;
   var _bSpectator;
   var _nCurrentTableTurn;
   var _nFightType;
   var _nInteractionType;
   var _nPlayerCount;
   var _nState;
   var _oResults;
   var _sCurrentPlayerID;
   var _sCurrentPlayerWithGlowID;
   var _sLastPlayerID;
   var api;
   var dispatchEvent;
   static var INTERACTION_TYPE_MOVE = 1;
   static var INTERACTION_TYPE_SPELL = 2;
   static var INTERACTION_TYPE_CC = 3;
   static var INTERACTION_TYPE_PLACE = 4;
   static var INTERACTION_TYPE_TARGET = 5;
   static var INTERACTION_TYPE_FLAG = 6;
   static var _bTacticMode = false;
   static var _bBlockSpectator = false;
   static var _bNeedHelp = false;
   static var _bLockFight = false;
   static var _bCreatureMode = false;
   static var _bLogMapDisconnections = false;
   static var _aResults = new ank.utils.ExtendedArray();
   var _bFirstTurn = false;
   var _aTurnSequence = true;
   var nTransmittingStates = 0;
   static var STATE_NONE = 0;
   static var STATE_MOVE_BIT = 1;
   static var STATE_GATHER_BIT = 2;
   function Game()
   {
      super();
      this.initialize();
   }
   function get isLoggingMapDisconnections()
   {
      return dofus.datacenter.Game._bLogMapDisconnections;
   }
   function set isLoggingMapDisconnections(bTacticMode)
   {
      dofus.datacenter.Game._bLogMapDisconnections = bTacticMode;
   }
   function get isFirstTurn()
   {
      return this._aTurnSequence;
   }
   function set isFirstTurn(aTurnSequence)
   {
      this._aTurnSequence = aTurnSequence;
   }
   function get passiveTurn()
   {
      return this.currentTableTurn == 0;
   }
   function get isTacticMode()
   {
      return dofus.datacenter.Game._bTacticMode;
   }
   function set isTacticMode(bLogMapDisconnections)
   {
      dofus.datacenter.Game._bTacticMode = bLogMapDisconnections;
   }
   function get isSpectatorBlocked()
   {
      return dofus.datacenter.Game._bBlockSpectator;
   }
   function set isSpectatorBlocked(bBlockSpectator)
   {
      dofus.datacenter.Game._bBlockSpectator = bBlockSpectator;
   }
   function get isNeedingHelp()
   {
      return dofus.datacenter.Game._bNeedHelp;
   }
   function set isNeedingHelp(bNeedHelp)
   {
      dofus.datacenter.Game._bNeedHelp = bNeedHelp;
   }
   function get isFightBlocked()
   {
      return dofus.datacenter.Game._bLockFight;
   }
   function set isFightBlocked(bLockFight)
   {
      dofus.datacenter.Game._bLockFight = bLockFight;
   }
   function get isCreatureMode()
   {
      return dofus.datacenter.Game._bCreatureMode;
   }
   function set isCreatureMode(bCreatureMode)
   {
      dofus.datacenter.Game._bCreatureMode = bCreatureMode;
   }
   function set playerCount(bSpectator)
   {
      this._bSpectator = Number(bSpectator);
   }
   function get playerCount()
   {
      return this._bSpectator;
   }
   function set currentTableTurn(nPlayerCount)
   {
      this._nPlayerCount = Number(nPlayerCount);
   }
   function get currentTableTurn()
   {
      return this._nPlayerCount;
   }
   function set currentPlayerID(nCurrentTableTurn)
   {
      this._nCurrentTableTurn = nCurrentTableTurn;
   }
   function get currentPlayerID()
   {
      return this._nCurrentTableTurn;
   }
   function set lastPlayerID(bRunning)
   {
      this._bRunning = bRunning;
   }
   function get lastPlayerID()
   {
      return this._bRunning;
   }
   function set currentPlayerWithGlowID(sCurrentPlayerWithGlowID)
   {
      this._sCurrentPlayerWithGlowID = sCurrentPlayerWithGlowID;
   }
   function get currentPlayerWithGlowID()
   {
      return this._sCurrentPlayerWithGlowID;
   }
   function set state(nState)
   {
      this._nState = Number(nState);
      this.dispatchEvent({type:"stateChanged",value:this._nState});
   }
   function get state()
   {
      return this._nState;
   }
   function set fightType(nFightType)
   {
      this._nFightType = nFightType;
   }
   function get fightType()
   {
      return this._nFightType;
   }
   function set isSpectator(sLastPlayerID)
   {
      this._sLastPlayerID = sLastPlayerID;
   }
   function get isSpectator()
   {
      return this._sLastPlayerID;
   }
   function set turnSequence(sCurrentPlayerID)
   {
      this._sCurrentPlayerID = sCurrentPlayerID;
   }
   function get turnSequence()
   {
      return this._sCurrentPlayerID;
   }
   function set results(oResults)
   {
      this._oResults = oResults;
   }
   function get results()
   {
      return this._oResults;
   }
   function get resultsArray()
   {
      return dofus.datacenter.Game._aResults;
   }
   function storeFightResults(oResults)
   {
      if(dofus.datacenter.Game._aResults.length >= this.api.lang.getConfigText("MAX_FIGHT_HISTORY"))
      {
         dofus.datacenter.Game._aResults.pop();
      }
      dofus.datacenter.Game._aResults.unshift(oResults);
   }
   function get fightMonsters()
   {
      return this._aFightMonsters;
   }
   function set fightMonsters(afightMonsters)
   {
      return this._aFightMonsters = afightMonsters;
   }
   function set isRunning(bFirstTurn)
   {
      this._bFirstTurn = bFirstTurn;
   }
   function get isRunning()
   {
      return this._bFirstTurn;
   }
   function get isFight()
   {
      return this._nState != undefined && this._nState > 1;
   }
   function get interactionType()
   {
      return this._nInteractionType;
   }
   function initialize()
   {
      mx.events.EventDispatcher.initialize(this);
      this.api = _global.API;
      this._bFirstTurn = false;
      this._bSpectator = 0;
      this._nCurrentTableTurn = null;
      this._bRunning = null;
      this._nState = 0;
      this._sCurrentPlayerID = [];
      this._oResults = {};
      this._nInteractionType = 0;
      this._nPlayerCount = 0;
      this.api.electron.addEventListener("onWindowFocusChanged",this);
   }
   function setInteractionType(sType)
   {
      switch(sType)
      {
         case "move":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_MOVE;
            break;
         case "spell":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_SPELL;
            break;
         case "cc":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_CC;
            break;
         case "place":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_PLACE;
            break;
         case "target":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_TARGET;
            break;
         case "flag":
            this._nInteractionType = dofus.datacenter.Game.INTERACTION_TYPE_FLAG;
         default:
            return;
      }
   }
   function destroy()
   {
      this.api.electron.removeEventListener("onWindowFocusChanged",this);
   }
   function onWindowFocusChanged(oEvent_)
   {
      if(!this.isRunning)
      {
         return undefined;
      }
      if(this.api.kernel.OptionsManager.getOption("AntiLagHideSpritesFight"))
      {
         !oEvent_.isFocused ? this.api.gfx.spriteHandler.maskAllSprites() : this.api.gfx.spriteHandler.unmaskAllSprites();
      }
   }
}
