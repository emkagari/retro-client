class dofus.datacenter.ItemDrop extends dofus.datacenter.Item
{
   var _bHasDropConditions;
   var _nBaseDropRate;
   var _nDropPerMonsterCount;
   var _nMinimumProspection;
   var _nMonsterID;
   var _nUnicID;
   static var RARE_VALUE = 5;
   static var VERY_RARE_VALUE = 1;
   var _nFixedDropRate = 1;
   function ItemDrop(nMonsterID, nMonsterGrade, nItemID, nQuantity, sEffects)
   {
      super.initialize(undefined,nItemID,nQuantity,undefined,sEffects);
      this._nMonsterID = nMonsterID;
      this._nUnicID = nItemID;
      var _loc8_ = dofus.datacenter.Item.api.lang.getMonsterDrop(nMonsterID,nItemID);
      this._nMinimumProspection = _loc8_.pp;
      this._bHasDropConditions = _loc8_.c;
      if(_loc8_.sr != undefined)
      {
         this._nFixedDropRate = _loc8_.sr;
      }
      if(nMonsterGrade == undefined)
      {
         nMonsterGrade = 1;
      }
      this._nBaseDropRate = _loc8_.t[nMonsterGrade - 1];
      this._nDropPerMonsterCount = _loc8_.dc;
   }
   static function isEnabled(nMonsterID, nItemID)
   {
      var _loc4_ = dofus.datacenter.Item.api.lang.getMonsterDrop(nMonsterID,nItemID);
      var _loc5_ = _loc4_.sc;
      if(_loc5_ == undefined)
      {
         return true;
      }
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < _loc5_.length)
      {
         _loc7_ = _loc5_[_loc6_];
         if(!dofus.datacenter.Item.api.datacenter.GameServer.verifyCriterion(_loc7_.criterion,_loc7_.expected))
         {
            return false;
         }
         _loc6_ = _loc6_ + 1;
      }
      return true;
   }
   function get monsterID()
   {
      return this._nMonsterID;
   }
   function get itemID()
   {
      return super.realUnicId;
   }
   function get minimumProspection()
   {
      return this._nMinimumProspection;
   }
   function get hasDropConditions()
   {
      return this._bHasDropConditions;
   }
   function get dropPerMonsterCount()
   {
      return this._nDropPerMonsterCount;
   }
   function getDropInfosString()
   {
      var _loc3_ = [];
      var _loc4_ = this._bHasDropConditions;
      var _loc5_ = super.isQuest;
      if(_loc4_)
      {
         _loc3_.push("<b>" + dofus.datacenter.Item.api.lang.getText("LOOT_HAS_CONDITIONS") + "</b>");
      }
      if(_loc5_)
      {
         _loc3_.push("<b>" + dofus.datacenter.Item.api.lang.getText("QUEST_ITEM") + "</b>");
      }
      if(_loc4_ || _loc5_)
      {
         _loc3_.push("");
      }
      _loc3_.push(dofus.datacenter.Item.api.lang.getText("LOOT_DROP_BASE_RATE",[this.getDropRate(false)]));
      _loc3_.push(dofus.datacenter.Item.api.lang.getText("LOOT_DROP_PROSPECTING_RATE",[this.getDropRate(true)]));
      if(this._nMinimumProspection > 0)
      {
         _loc3_.push(dofus.datacenter.Item.api.lang.getText("LOOT_DROP_PROSPECTING_THRESHOLD",[this._nMinimumProspection]));
      }
      var _loc6_ = dofus.datacenter.Item.api.datacenter.Player.totalPartyProspection;
      var _loc7_ = dofus.datacenter.Item.api.lang.getText("TOTAL_PROSPECTING",[_loc6_]);
      var _loc8_;
      var _loc9_;
      if(dofus.datacenter.Item.api.datacenter.Player.inParty)
      {
         _loc8_ = dofus.datacenter.Item.api.datacenter.Player.getCharacValueByID(16);
         _loc9_ = _loc6_ - _loc8_;
         if(_loc9_ > 0)
         {
            _loc7_ += " (" + dofus.datacenter.Item.api.lang.getText("VALUE_PLUS_VALUE_FROM_PARTY",[_loc8_,_loc9_]) + ")";
         }
      }
      _loc3_.push(_loc7_);
      if(this._nDropPerMonsterCount != undefined)
      {
         _loc3_.push(dofus.datacenter.Item.api.lang.getText("LOOT_DROP_MAX_PER_MONSTER",[this._nDropPerMonsterCount]));
      }
      return _loc3_.join("\n");
   }
   function getDropRate(bApplyProspection)
   {
      var _loc3_ = dofus.datacenter.Item.api.datacenter.GameServer.dropBonusForServer / 100;
      var _loc4_ = Math.min(this._nBaseDropRate,100) * _loc3_;
      if(bApplyProspection)
      {
         _loc4_ = this.applyPlayerProspection(_loc4_);
      }
      _loc4_ = Math.min(_loc4_,100);
      if(this._nFixedDropRate > 1)
      {
         _loc4_ /= this._nFixedDropRate;
      }
      return _loc4_;
   }
   function applyPlayerProspection(nCurrentProba)
   {
      var _loc3_ = dofus.datacenter.Item.api.datacenter.Player.getCharacValueByID(16);
      return nCurrentProba * _loc3_ / 100;
   }
}
