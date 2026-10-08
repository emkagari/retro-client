class dofus.datacenter.Challenge extends Object
{
   var _nFightType;
   var _nID;
   var _teams;
   function Challenge(nID, nFightType)
   {
      super();
      this.initialize(nID,nFightType);
   }
   function initialize(nID, nFightType)
   {
      this._nID = nID;
      this._nFightType = nFightType;
      this._teams = {};
   }
   function addTeam(t)
   {
      this._teams[t.id] = t;
      t.setChallenge(this);
   }
   function get id()
   {
      return this._nID;
   }
   function get fightType()
   {
      return this._nFightType;
   }
   function get teams()
   {
      return this._teams;
   }
   function get count()
   {
      var _loc2_ = 0;
      for(var k in this._teams)
      {
         _loc2_ += this._teams[k].count;
      }
      return _loc2_;
   }
}
