class ank.utils.Sequencer extends Object
{
   var _aActions;
   var _bPlaying;
   var _nActionIndex;
   var _nTimeout;
   var _unicID;
   var onSequenceEnd;
   var _nTimeModerator = 1;
   function Sequencer(timeout)
   {
      super();
      this.initialize(timeout);
   }
   function initialize(nTimeout)
   {
      this._nTimeout = nTimeout != undefined ? nTimeout : 10000;
      this._unicID = String(getTimer()) + random(10000);
      this._nActionIndex = 0;
      this.clear();
   }
   function clear()
   {
      this._aActions = [];
      this._bPlaying = false;
      this._nTimeModerator = 1;
      ank.utils.Timer.removeTimer(this,"sequencer");
   }
   function setTimeModerator(nTimeModerator)
   {
      this._nTimeModerator = nTimeModerator;
   }
   function addAction(nDebugId, bWaitEnd, mRefObject, fFunction, aParams, nDuration, bForceTimeout)
   {
      var _loc9_ = {};
      _loc9_.debugId = nDebugId;
      _loc9_.id = this.getActionIndex();
      _loc9_.waitEnd = bWaitEnd;
      _loc9_.object = mRefObject;
      _loc9_.fn = fFunction;
      _loc9_.parameters = aParams;
      _loc9_.duration = nDuration;
      _loc9_.forceTimeout = bWaitEnd && (bForceTimeout != undefined && bForceTimeout);
      _loc9_.functionApplied = false;
      this._aActions.push(_loc9_);
   }
   function printActions()
   {
      var _loc2_ = _global.API;
      var _loc3_ = "Actions : (" + this._aActions.length + ")";
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._aActions.length)
      {
         _loc5_ = this._aActions[_loc4_];
         _loc3_ += "\ni : " + _loc4_ + "\n" + "DebugID : " + _loc5_.debugId + "\n" + "Wait End : " + _loc5_.waitEnd + "\n" + "Force Timeout : " + _loc5_.forceTimeout + "\n" + "Parameters : " + _loc5_.parameters.toString();
         _loc4_ = _loc4_ + 1;
      }
      _loc2_.kernel.showMessage(undefined,_loc3_,"DEBUG_LOG");
   }
   function getCurrentAction()
   {
      return this._aActions[0];
   }
   function containsAction(mRefObject, fFunction)
   {
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._aActions.length)
      {
         _loc5_ = this._aActions[_loc4_];
         if(_loc5_.object == mRefObject && _loc5_.fn == fFunction)
         {
            return true;
         }
         _loc4_ = _loc4_ + 1;
      }
      return false;
   }
   function execute(bForced)
   {
      if(this._bPlaying && !bForced)
      {
         return undefined;
      }
      this._bPlaying = true;
      var _loc3_ = true;
      var _loc4_;
      while(_loc3_)
      {
         if(this._aActions.length > 0)
         {
            _loc4_ = this._aActions[0];
            if(_loc4_.waitEnd)
            {
               _loc4_.object[this._unicID] = _loc4_.id;
            }
            _loc4_.fn.apply(_loc4_.object,_loc4_.parameters);
            _loc4_.functionApplied = true;
            if(!_loc4_.waitEnd)
            {
               this.onActionEnd(true);
            }
            else
            {
               _loc3_ = false;
               ank.utils.Timer.setTimer(_loc4_.object,"sequencer",this,this.onActionTimeOut,_loc4_.duration == undefined ? this._nTimeout : _loc4_.duration * this._nTimeModerator,[_loc4_]);
            }
         }
         else
         {
            _loc3_ = false;
            this.stop();
         }
      }
   }
   function stop()
   {
      this._bPlaying = false;
   }
   function isPlaying()
   {
      return this._bPlaying;
   }
   function clearAllNextActions(Void)
   {
      this._aActions.splice(1);
      ank.utils.Timer.removeTimer(this,"sequencer");
   }
   function onActionTimeOut(oAction)
   {
      if(oAction != undefined && this._aActions[0].id != oAction.id)
      {
         return undefined;
      }
      this.onActionEnd(false,true);
   }
   function onActionEnd(bDontCallExecute, bTimeout)
   {
      if(bTimeout == undefined)
      {
         bTimeout = false;
      }
      if(this._aActions.length == 0)
      {
         return undefined;
      }
      if(this._aActions[0].forceTimeout && !bTimeout)
      {
         return undefined;
      }
      if(this._aActions[0].waitEnd)
      {
         ank.utils.Timer.removeTimer(this._aActions[0].object,"sequencer");
      }
      this._aActions.shift();
      if(this._aActions.length == 0)
      {
         this.clear();
         this.onSequenceEnd();
      }
      else if(bDontCallExecute != true)
      {
         if(this._bPlaying)
         {
            this.execute(true);
         }
      }
   }
   function toString()
   {
      return "Sequencer unicID:" + this._unicID + " playing:" + this._bPlaying + " actionsCount:" + this._aActions.length + " currentActionID:" + this._aActions[0].id + " currentActionObject:" + this._aActions[0].object + " currentActionParam:" + this._aActions[0].parameters.toString() + " currentActionBlocking:" + this._aActions[0].waitEnd + " currentActionForceTimeout:" + this._aActions[0].forceTimeout;
   }
   function getActionIndex(Void)
   {
      this._nActionIndex = this._nActionIndex + 1;
      if(this._nActionIndex > 10000)
      {
         this._nActionIndex = 0;
      }
      return this._nActionIndex;
   }
}
