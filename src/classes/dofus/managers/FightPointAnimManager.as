class dofus.managers.FightPointAnimManager
{
   var _api;
   var _nPrintAllTimeout;
   var _oPlayersBuffer;
   static var LIFE_POINT = 0;
   static var ACTION_POINT = 1;
   static var MOVEMENT_POINT = 2;
   function FightPointAnimManager(api)
   {
      this._api = api;
      this._oPlayersBuffer = {};
   }
   function addLifePointAnim(id, nValue)
   {
      this.addPointAnim(id,nValue,dofus.managers.FightPointAnimManager.LIFE_POINT);
   }
   function addActionPointAnim(id, nValue)
   {
      this.addPointAnim(id,nValue,dofus.managers.FightPointAnimManager.ACTION_POINT);
   }
   function addMovePointAnim(id, nValue)
   {
      this.addPointAnim(id,nValue,dofus.managers.FightPointAnimManager.MOVEMENT_POINT);
   }
   function playPointAnim(id, nValue, nType)
   {
      if(nValue == 0)
      {
         return undefined;
      }
      var _loc5_ = nValue > 0;
      var _loc6_ = this.getAnimType(_loc5_,nType);
      var _loc7_ = (!_loc5_ ? " " : "+") + String(nValue);
      this._api.gfx.addSpritePoints(id,_loc7_,_loc6_);
   }
   function getAnimType(bPositive, nType)
   {
      switch(nType)
      {
         case dofus.managers.FightPointAnimManager.LIFE_POINT:
            if(bPositive)
            {
               return dofus.Constants.CLIP_POINT_TYPE_HEALTH;
            }
            return dofus.Constants.CLIP_POINT_TYPE_DAMAGE;
            break;
         case dofus.managers.FightPointAnimManager.ACTION_POINT:
            return dofus.Constants.CLIP_POINT_TYPE_ACTION;
         case dofus.managers.FightPointAnimManager.MOVEMENT_POINT:
            return dofus.Constants.CLIP_POINT_TYPE_MOVEMENT;
         default:
            return;
      }
   }
   function addPointAnim(id, nValue, nType)
   {
      if(nValue == 0)
      {
         return undefined;
      }
      var _loc5_;
      var _loc6_;
      if(this._api.kernel.OptionsManager.getOption("RegroupDamage"))
      {
         if(this._oPlayersBuffer[id] == undefined)
         {
            this._oPlayersBuffer[id] = {};
         }
         _loc5_ = this._oPlayersBuffer[id];
         if(_loc5_[nType] == undefined)
         {
            _loc5_[nType] = 0;
         }
         _loc5_[nType] += nValue;
         if(this._nPrintAllTimeout != undefined)
         {
            _global.clearTimeout(this._nPrintAllTimeout);
         }
         _loc6_ = _global.setTimeout(this,"playAllPointAnim",50);
         this._nPrintAllTimeout = _loc6_;
      }
      else
      {
         this.playPointAnim(id,nValue,nType);
      }
   }
   function playAllPointAnim()
   {
      var _loc2_;
      var _loc3_;
      for(var sId in this._oPlayersBuffer)
      {
         _loc2_ = this._oPlayersBuffer[sId];
         _loc3_ = dofus.managers.FightPointAnimManager.LIFE_POINT;
         while(_loc3_ <= dofus.managers.FightPointAnimManager.MOVEMENT_POINT)
         {
            if(_loc2_[_loc3_] != undefined && _loc2_[_loc3_] != 0)
            {
               this.playPointAnim(sId,_loc2_[_loc3_],_loc3_);
            }
            _loc3_ = _loc3_ + 1;
         }
      }
      this._oPlayersBuffer = {};
   }
}
