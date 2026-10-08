class dofus.datacenter.WantedParchment extends Object
{
   var _nID;
   var _oMonster;
   var api;
   function WantedParchment(nID)
   {
      super();
      this.initialize(nID);
   }
   function get wantedMonster()
   {
      return this._oMonster;
   }
   function get body()
   {
      return this.api.lang.getWantedParchment(this._nID).b;
   }
   function get description()
   {
      return this.api.lang.getWantedParchment(this._nID).d;
   }
   function get kamasReward()
   {
      return this.api.lang.getWantedParchment(this._nID).r;
   }
   function get questID()
   {
      return this.api.lang.getWantedParchment(this._nID).q;
   }
   function get difficultyValue()
   {
      return this.api.lang.getWantedParchment(this._nID).s;
   }
   function initialize(nID)
   {
      this.api = _global.API;
      this._nID = nID;
      var _loc3_ = this.api.lang.getWantedParchment(nID).m;
      var _loc4_ = this.api.lang.getMonstersText(Number(_loc3_)).g;
      this._oMonster = new dofus.datacenter.Monster(_loc3_,undefined,dofus.Constants.CLIPS_PERSOS_PATH + _loc4_ + ".swf");
   }
}
