class dofus.datacenter.LaunchedSpell
{
   var _nRemainingTurn;
   var _oSpell;
   var _sSpriteOnID;
   function LaunchedSpell(nSpellID, sSpriteOnID)
   {
      this.initialize(nSpellID,sSpriteOnID);
   }
   function set remainingTurn(nRemainingTurn)
   {
      this._nRemainingTurn = Number(nRemainingTurn);
   }
   function get remainingTurn()
   {
      return this._nRemainingTurn;
   }
   function get spriteOnID()
   {
      return this._sSpriteOnID;
   }
   function get spell()
   {
      return this._oSpell;
   }
   function initialize(nSpellID, sSpriteOnID)
   {
      this._oSpell = _global.API.datacenter.Player.Spells.findFirstItem("ID",nSpellID).item;
      this._sSpriteOnID = sSpriteOnID;
      var _loc4_ = this._oSpell.delayBetweenLaunch;
      if(_loc4_ == undefined)
      {
         _loc4_ = 0;
      }
      if(_loc4_ >= 63)
      {
         this._nRemainingTurn = Number.MAX_VALUE;
      }
      else
      {
         this._nRemainingTurn = _loc4_;
      }
   }
}
