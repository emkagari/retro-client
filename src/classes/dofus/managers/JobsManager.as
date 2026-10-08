class dofus.managers.JobsManager extends dofus.utils.ApiElement
{
   static var _sSelf = null;
   function JobsManager()
   {
      super();
      dofus.managers.JobsManager._sSelf = this;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.JobsManager._sSelf;
   }
   function getUIActivity(nId_)
   {
      var _loc0_;
      if((_loc0_ = nId_) !== 2)
      {
         return undefined;
      }
      return "JobLumberjack";
   }
}
