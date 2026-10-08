class dofus.managers.AchievementDescriptionManager
{
   function AchievementDescriptionManager()
   {
   }
   static function getDescription(nType, sRawDescription, aParams)
   {
      var _loc5_ = _global.API;
      var _loc6_ = [];
      var _loc7_;
      switch(nType)
      {
         case 1:
            _loc6_[0] = _loc5_.lang.getFightChallenge(aParams[0]).n;
            _loc6_[1] = _loc5_.lang.getMonstersText(aParams[1]).n;
            break;
         case 3:
            _loc6_ = [_loc5_.lang.getMonstersText(aParams[0]).n];
            break;
         case 11:
         case 27:
            _loc6_ = [aParams];
            break;
         case 18:
            _loc6_[0] = aParams[0];
            _loc7_ = aParams[1];
            _loc6_[1] = _loc7_;
            break;
         default:
            _loc7_ = aParams[0];
            _loc6_[0] = _loc7_;
      }
      var _loc8_ = ank.utils.PatternDecoder.getDescription(sRawDescription,_loc6_);
      if(_loc8_ != null && !_global.isNaN(_loc7_))
      {
         _loc8_ = ank.utils.PatternDecoder.combine(_loc8_,"n",_loc7_ < 2);
      }
      return _loc8_;
   }
}
