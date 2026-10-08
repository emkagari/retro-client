class dofus.datacenter.States
{
   static var STATE_TEMPORIS_1_NEW_SRAM = 1073;
   static var STATE_TEMPORIS_1_NEW_SRAM_MASS = 1074;
   static var STATE_TEMPORIS_1_NEW_PANDAWA = 1075;
   function States()
   {
   }
   static function onStateAdded(api, oSprite, nStateId)
   {
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      switch(nStateId)
      {
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_SRAM:
            _loc5_ = oSprite.CharacteristicsManager;
            if(_loc5_ != null)
            {
               _loc6_ = - api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_SRAM_1_STATE_RESISTANCES_MODIFICATOR);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT,_loc6_);
            }
            break;
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_SRAM_MASS:
            _loc7_ = oSprite.CharacteristicsManager;
            if(_loc7_ != null)
            {
               _loc8_ = - api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_SRAM_1_STATE_RESISTANCES_MODIFICATOR_MASS);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT,_loc8_);
            }
            break;
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_PANDAWA:
            _loc9_ = oSprite.CharacteristicsManager;
            if(_loc9_ != null)
            {
               _loc10_ = - api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_PANDAWA_1_FINAL_DAMAGES_BONUSES_PERCENT);
               _loc9_.setModeratorValue(dofus.managers.CharacteristicsManager.FINAL_DAMAGES_PERCENT,_loc10_);
            }
         default:
            return;
      }
   }
   static function onStateRemoved(api, oSprite, nStateId)
   {
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      switch(nStateId)
      {
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_SRAM:
            _loc5_ = oSprite.CharacteristicsManager;
            if(_loc5_ != null)
            {
               _loc6_ = api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_SRAM_1_STATE_RESISTANCES_MODIFICATOR);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT,_loc6_);
               _loc5_.setModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT,_loc6_);
            }
            break;
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_SRAM_MASS:
            _loc7_ = oSprite.CharacteristicsManager;
            if(_loc7_ != null)
            {
               _loc8_ = api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_SRAM_1_STATE_RESISTANCES_MODIFICATOR_MASS);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.EARTH_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.FIRE_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.WATER_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.AIR_ELEMENT_PERCENT,_loc8_);
               _loc7_.setModeratorValue(dofus.managers.CharacteristicsManager.NEUTRAL_ELEMENT_PERCENT,_loc8_);
            }
            break;
         case dofus.datacenter.States.STATE_TEMPORIS_1_NEW_PANDAWA:
            _loc9_ = oSprite.CharacteristicsManager;
            if(_loc9_ != null)
            {
               _loc10_ = api.kernel.TemporisConfigManager.getIntegerValue(dofus.datacenter.TemporisConfigKeys.NEW_PANDAWA_1_FINAL_DAMAGES_BONUSES_PERCENT);
               _loc9_.setModeratorValue(dofus.managers.CharacteristicsManager.FINAL_DAMAGES_PERCENT,_loc10_);
            }
         default:
            return;
      }
   }
}
