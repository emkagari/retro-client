class dofus.managers.GameActionsManager extends dofus.utils.ApiElement
{
   var _bNextAction;
   var _currentType;
   var _data;
   var _nGenericID;
   var _state;
   static var STATE_TRANSMITTING = 2;
   static var STATE_IN_PROGRESS = 1;
   static var STATE_READY = 0;
   function GameActionsManager(d, oAPI)
   {
      super();
      this.initialize(d,oAPI);
   }
   function initialize(d, oAPI)
   {
      super.initialize(oAPI);
      this._data = d;
      this.clear();
   }
   function clear(Void)
   {
      this._nGenericID = undefined;
      this._bNextAction = false;
      this._state = dofus.managers.GameActionsManager.STATE_READY;
      this._currentType = null;
   }
   function transmittingMove(type, params)
   {
      if(!this.isWaiting())
      {
         this.api.datacenter.Game.nTransmittingStates |= dofus.datacenter.Game.STATE_MOVE_BIT;
         this.api.network.GameActions.sendActions(type,params);
         this._state = dofus.managers.GameActionsManager.STATE_TRANSMITTING;
         this._currentType = type;
      }
      else if(this.canCancel(type))
      {
         this.cancel(this._data.cellNum);
         this.transmittingMove(type,params);
      }
      else
      {
         ank.utils.Logger.err("L\'état de l\'action ne permet pas de faire ceci");
      }
   }
   function isOnUncancelableAction(type)
   {
      return this.isWaiting() && !this.canCancel(type);
   }
   function transmittingOther(type, params)
   {
      if(!this.isWaiting())
      {
         this.api.network.GameActions.sendActions(type,params);
         this._state = dofus.managers.GameActionsManager.STATE_TRANSMITTING;
         this._currentType = type;
      }
      else
      {
         ank.utils.Logger.err("L\'état de l\'action ne permet pas de faire ceci " + type + " " + params);
      }
   }
   function onServerResponse(id)
   {
      var _loc3_ = this._state;
      this._nGenericID = id;
      this._state = dofus.managers.GameActionsManager.STATE_IN_PROGRESS;
      return _loc3_;
   }
   function cancel(params, bForceStatic)
   {
      this._currentType = null;
      var _loc4_;
      var _loc5_;
      if(this.canCancel())
      {
         this.api.network.GameActions.actionCancel(this._nGenericID,params);
         _loc4_ = this._data.sequencer;
         _loc5_ = this._data.mc;
         _loc4_.clearAllNextActions();
         if(bForceStatic == true)
         {
            _loc4_.addAction(125,false,_loc5_,_loc5_.setAnim,["Static"]);
         }
         this.clear();
      }
   }
   function end(bIAmSender)
   {
      if(this._bNextAction == false || !bIAmSender)
      {
         this.clear();
      }
      else
      {
         this._state = dofus.managers.GameActionsManager.STATE_TRANSMITTING;
         this._nGenericID = undefined;
      }
   }
   function ack(idAction)
   {
      this.api.network.GameActions.actionAck(idAction);
      this.end(true);
   }
   function isWaiting(Void)
   {
      switch(this._state)
      {
         case dofus.managers.GameActionsManager.STATE_READY:
            return false;
         case dofus.managers.GameActionsManager.STATE_TRANSMITTING:
         case dofus.managers.GameActionsManager.STATE_IN_PROGRESS:
            return true;
         default:
            return false;
      }
   }
   function canCancel(type)
   {
      if(type != this._currentType)
      {
         return false;
      }
      if(this._nGenericID == undefined)
      {
         return false;
      }
      switch(this._state)
      {
         case dofus.managers.GameActionsManager.STATE_TRANSMITTING:
            return false;
         case dofus.managers.GameActionsManager.STATE_READY:
         case dofus.managers.GameActionsManager.STATE_IN_PROGRESS:
            return true;
         default:
            return false;
      }
   }
}
