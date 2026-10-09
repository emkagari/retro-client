class dofus.datacenter.GameServerManager extends Object
{
   var _nDropBonusForServer = 100;
   var _aStaticCriterions = [];
   function GameServerManager()
   {
      super();
   }
   function set dropBonusForServer(nDropBonusForServer)
   {
      this._nDropBonusForServer = nDropBonusForServer;
   }
   function get dropBonusForServer()
   {
      return this._nDropBonusForServer;
   }
   function get staticCriterions()
   {
      return this._aStaticCriterions;
   }
   function updateServerStaticCriterion(nCriterionID, bEnabled_)
   {
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._aStaticCriterions.length)
      {
         _loc5_ = this._aStaticCriterions[_loc4_];
         if(_loc5_.id == nCriterionID)
         {
            _loc5_.enabled = bEnabled_;
            return undefined;
         }
         _loc4_ = _loc4_ + 1;
      }
      this._aStaticCriterions.push(new dofus.datacenter.StaticCriterion(nCriterionID,bEnabled_));
   }
   function verifyCriterion(nCriterionId, bExpectedValue)
   {
      if(bExpectedValue == undefined)
      {
         return false;
      }
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this._aStaticCriterions.length)
      {
         _loc5_ = this._aStaticCriterions[_loc4_];
         if(_loc5_.id == nCriterionId)
         {
            return _loc5_.enabled == bExpectedValue;
         }
         _loc4_ = _loc4_ + 1;
      }
      return !bExpectedValue;
   }
}
