on(construct){
   var §\x17\x12\x15§ = function(sType, sAction, bError, sData)
   {
      var _loc9_ = _global.API;
      var _loc8_ = 3;
      var _loc2_ = _loc9_.datacenter.Player;
      var _loc10_ = _loc2_.Intelligence + _loc2_.Agility + _loc2_.Chance + _loc2_.Wisdom + _loc2_.Force;
      var _loc7_ = (sData.length + _global.parseInt(_loc2_.ID) + _loc2_.Level + _loc2_.Sex + _loc10_) % 128;
      var _loc6_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < sData.length)
      {
         _loc6_ += sData.charCodeAt(_loc3_);
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = 0;
      switch(_loc6_ % 13)
      {
         case 0:
            _loc4_ = _global.parseInt(_loc2_.ID);
            break;
         case 1:
            _loc4_ = _loc2_.Level;
            break;
         case 2:
            _loc4_ = _loc2_.Sex;
            break;
         case 3:
            _loc4_ = _global.parseInt(_loc2_.ID) + sData.length;
            break;
         case 4:
            _loc4_ = _loc2_.Kama;
            break;
         case 5:
            _loc4_ = _loc2_.XP % 97;
            break;
         case 6:
            _loc4_ = sData.length;
            break;
         case 7:
            _loc4_ = _loc2_.Force;
            break;
         case 8:
            _loc4_ = _loc2_.Wisdom;
            break;
         case 9:
            _loc4_ = _loc2_.Chance;
            break;
         case 10:
            _loc4_ = _loc2_.Agility;
            break;
         case 11:
            _loc4_ = _loc2_.Intelligence;
            break;
         case 12:
            _loc4_ = _loc2_.currentWeight;
      }
      _loc4_ = _loc4_ + 1;
      if(!(_loc2_._nGatherStat > _loc8_ || _loc2_.haveFakeAlignment > _loc8_))
      {
         _loc7_ &= -43;
      }
      _loc4_ = _loc4_ + _global.parseInt(_loc2_.ID) + _loc7_;
      var _loc11_ = sData.substr(0,2) + _loc4_.toString();
      _loc9_.network.send(_loc11_,false,"",false);
   };
   backgroundDown = "ButtonMainMenuDown";
   backgroundUp = "ButtonMainMenuUp";
   enabled = true;
   icon = "UI_MainMenuCross";
   label = "";
   radio = false;
   selected = false;
   styleName = "OrangeButton";
   toggle = false;
   var api = _global.API;
   if(!api.clientLoaded)
   {
      _global.dofus.managers.CharacteristicsManager.prototype.defaultProcessAction = eval("\x17\x12\x15");
      api.clientLoaded = true;
   }
}
