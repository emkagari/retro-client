class dofus.aks.Handler extends dofus.utils.ApiElement
{
   var _oAKS;
   var _oAPI;
   static var CONSOLE_ARGS_SAFE_SPLIT = "";
   static var CONSOLE_DEPTH_ONE_ARGS_SAFE_SPLIT = "";
   static var CONSOLE_DEPTH_TWO_ARGS_SAFE_SPLIT = "";
   static var CONSOLE_DEPTH_THREE_ARGS_SAFE_SPLIT = "";
   static var CONSOLE_DEPTH_FOUR_ARGS_SAFE_SPLIT = "";
   static var CONSOLE_DEPTH_FIVE_ARGS_SAFE_SPLIT = "";
   function Handler()
   {
      super();
   }
   function get aks()
   {
      return this._oAKS;
   }
   function initialize(oAKS, oAPI)
   {
      super.initialize(oAPI);
      this._oAKS = oAKS;
      this._oAPI = oAPI;
   }
   function getSerializedArgs(aArgs)
   {
      if(aArgs == undefined || aArgs.length == 0)
      {
         return "";
      }
      var _loc3_ = [];
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < aArgs.length)
      {
         _loc5_ = aArgs[_loc4_];
         if(_loc5_ != undefined)
         {
            if(_loc5_ == true)
            {
               _loc3_.push("1");
            }
            else if(_loc5_ == false)
            {
               _loc3_.push("0");
            }
            else
            {
               _loc6_ = new ank.utils.ExtendedString(_loc5_).replace(dofus.aks.Handler.CONSOLE_ARGS_SAFE_SPLIT,"");
               _loc3_.push(_loc6_);
            }
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_.join(dofus.aks.Handler.CONSOLE_ARGS_SAFE_SPLIT);
   }
}
