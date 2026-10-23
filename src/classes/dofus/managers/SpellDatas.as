class dofus.managers.SpellDatas
{
   var spellIDByLevelID;
   function SpellDatas()
   {
   }
   function getSpellFromLevelID(nLevelID)
   {
      if(this.spellIDByLevelID == undefined)
      {
         this.initSpellsDictionnary();
      }
      return this.spellIDByLevelID[nLevelID];
   }
   function initSpellsDictionnary()
   {
      this.spellIDByLevelID = {};
      var _loc2_ = _global.API.lang.getSpells();
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var i in _loc2_)
      {
         _loc3_ = _loc2_[i];
         _loc4_ = 1;
         while(_loc4_ <= 6)
         {
            _loc5_ = _loc3_["l" + _loc4_];
            if(_loc5_ != undefined)
            {
               _loc6_ = _loc5_[20];
               this.spellIDByLevelID[_loc6_] = {id:i,level:_loc4_};
            }
            _loc4_ = _loc4_ + 1;
         }
      }
   }
}
