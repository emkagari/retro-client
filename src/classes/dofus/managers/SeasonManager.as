class dofus.managers.SeasonManager extends Object
{
   var api;
   var eaRewards;
   var nScore = 0;
   function SeasonManager()
   {
      super();
      this.api = _global.API;
   }
   function get hasData()
   {
      return this.eaRewards != null && this.eaRewards.length > 0;
   }
   function set rewards(eaData)
   {
      this.eaRewards = eaData;
   }
   function get rewards()
   {
      return this.eaRewards;
   }
   function set score(nValue)
   {
      this.nScore = nValue;
   }
   function get score()
   {
      return this.nScore;
   }
}
