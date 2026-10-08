class dofus.datacenter.ttg.TtgCardFamily
{
   var _nFamilyCompletionPercentage;
   var _nFamilyFoilCompletionPercentage;
   var _nFamilyID;
   var api;
   var familyName;
   function TtgCardFamily(nFamilyID, nFamilyCompletionPercentage, nFamilyFoilCompletionPercentage)
   {
      this.api = _global.API;
      this._nFamilyID = nFamilyID;
      this.familyName = this.api.lang.getTtgFamilyObject(this._nFamilyID).n;
      this._nFamilyCompletionPercentage = nFamilyCompletionPercentage;
      this._nFamilyFoilCompletionPercentage = nFamilyFoilCompletionPercentage;
   }
   function get familyID()
   {
      return this._nFamilyID;
   }
   function get iconFile()
   {
      return "CardFamily";
   }
   function get forceReloadOnContainer()
   {
      return true;
   }
   function get params()
   {
      return {familyID:this.familyID,familyCompletionPercentage:this._nFamilyCompletionPercentage,familyFoilCompletionPercentage:this._nFamilyFoilCompletionPercentage};
   }
}
