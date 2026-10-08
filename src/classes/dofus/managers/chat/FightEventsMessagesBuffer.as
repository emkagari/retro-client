class dofus.managers.chat.FightEventsMessagesBuffer
{
   var _aMessagesBuffer;
   var _api;
   var _nPrintAllTimeout;
   function FightEventsMessagesBuffer(api)
   {
      this._api = api;
      this._aMessagesBuffer = [];
   }
   function get api()
   {
      return this._api;
   }
   function addFightEventMessage(nActionId, aPermanentArgs, aEvolutiveArgsToAppend, sPlayerId, sPlayerName)
   {
      var _loc7_ = this.getFightEventMessage(nActionId);
      if(_loc7_ == undefined)
      {
         _loc7_ = new dofus.datacenter.chat.FightEventMessage(this.api,nActionId,aPermanentArgs);
         this._aMessagesBuffer.push(_loc7_);
      }
      _loc7_.addPlayer(sPlayerId,sPlayerName);
      _loc7_.appendEvolutiveArgs(aEvolutiveArgsToAppend);
      if(this._nPrintAllTimeout != undefined)
      {
         _global.clearTimeout(this._nPrintAllTimeout);
      }
      var _loc8_ = _global.setTimeout(this,"printAll",50);
      this._nPrintAllTimeout = _loc8_;
   }
   function getFightEventMessage(nActionId)
   {
      var _loc3_ = this._aMessagesBuffer;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_.actionId == nActionId)
         {
            return _loc5_;
         }
         _loc4_ = _loc4_ + 1;
      }
      return undefined;
   }
   function printAll()
   {
      if(this._nPrintAllTimeout != undefined)
      {
         _global.clearTimeout(this._nPrintAllTimeout);
         this._nPrintAllTimeout = undefined;
      }
      if(this._aMessagesBuffer.length == 0)
      {
         return undefined;
      }
      var _loc2_ = this._aMessagesBuffer;
      this._aMessagesBuffer = [];
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = new ank.utils.ExtendedObject();
      var _loc5_ = this.api.datacenter.Sprites;
      var _loc6_;
      var _loc7_;
      for(var i in _loc5_.getItems())
      {
         _loc6_ = _loc5_.getItemAt(i);
         _loc7_ = _loc6_.Team;
         if(_loc7_ != undefined)
         {
            if(_loc7_ == 0)
            {
               _loc3_.addItemAt(_loc6_.id,_loc6_);
            }
            else if(_loc7_ == 1)
            {
               _loc4_.addItemAt(_loc6_.id,_loc6_);
            }
         }
      }
      var _loc8_ = 0;
      var _loc9_;
      var _loc10_;
      while(_loc8_ < _loc2_.length)
      {
         _loc9_ = _loc2_[_loc8_];
         _loc10_ = _loc9_.getPrintableString(_loc3_,_loc4_);
         if(!(_loc10_ == undefined || _loc10_.length == 0))
         {
            this.api.kernel.showMessage(undefined,_loc10_,"INFO_FIGHT_CHAT");
         }
         _loc8_ = _loc8_ + 1;
      }
   }
}
