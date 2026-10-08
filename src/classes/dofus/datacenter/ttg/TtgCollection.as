class dofus.datacenter.ttg.TtgCollection
{
   var _aTtgCardsIDs;
   var _eoCardsByFamilies;
   var _eoTtgCardsByCardID;
   var _eoTtgNonBrillantCardsByEntityID;
   var _sPlayerID;
   var _sPlayerName;
   var api;
   function TtgCollection(sPlayerID, sPlayerName, sHash)
   {
      this.api = _global.API;
      this._eoTtgCardsByCardID = new ank.utils.ExtendedObject();
      this._eoTtgNonBrillantCardsByEntityID = new ank.utils.ExtendedObject();
      this._aTtgCardsIDs = [];
      this._eoCardsByFamilies = new ank.utils.ExtendedObject();
      this._sPlayerID = sPlayerID;
      this._sPlayerName = sPlayerName;
      this.fillWithHash(sHash);
   }
   function get playerID()
   {
      return this._sPlayerID;
   }
   function get playerName()
   {
      return this._sPlayerName;
   }
   function getExtendedArrayForUX(fFilter, fSortFunction)
   {
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < this._aTtgCardsIDs.length)
      {
         _loc6_ = dofus.datacenter.ttg.TtgCard(this._eoTtgCardsByCardID.getItemAt(this._aTtgCardsIDs[_loc5_]));
         if(!_loc6_.isFoil)
         {
            if(!(fFilter != undefined && !fFilter.apply(this,[_loc6_])))
            {
               _loc4_.push(_loc6_);
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      if(fSortFunction != undefined)
      {
         _loc4_.sort(fSortFunction);
      }
      return _loc4_;
   }
   function getFilterFunctionByFamily(nFamily)
   {
      return function(nFamily)
      {
         return nFamily == nFamily.familyID;
      };
   }
   function getFilterFunctionByRarity(nRarity)
   {
      return function(nRarity)
      {
         return nRarity == nRarity.rarity;
      };
   }
   function getFilterFunctionByOwnedFoils()
   {
      return function(oTtg)
      {
         return oTtg.ownedFoil;
      };
   }
   function getFilterFunctionBySearch(sSearch)
   {
      return function(sSearch)
      {
         return new ank.utils.ExtendedString(sSearch.entityName).removeAccents().toLowerCase().indexOf(sSearch) > -1;
      };
   }
   function getFamiliesFoundByFilter(fFilter)
   {
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = this.getExtendedArrayForUX(fFilter);
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc3_.addItemAt(_loc6_.familyID,true);
         _loc5_ = _loc5_ + 1;
      }
      return _loc3_.getKeys();
   }
   function getFamiliesExtendedArrayForUX(ttgStats)
   {
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = this.getAllFamilies();
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         _loc7_ = ttgStats.getOwnedPercentageByFamilyID(_loc6_);
         _loc8_ = ttgStats.getOwnedFoilPercentageByFamilyID(_loc6_);
         _loc3_.push(new dofus.datacenter.ttg.TtgCardFamily(_loc6_,_loc7_,_loc8_));
         _loc5_ = _loc5_ + 1;
      }
      _loc3_.sortOn("familyName");
      return _loc3_;
   }
   function getCardsByFamily(nFamilyID)
   {
      var _loc3_ = Array(this._eoCardsByFamilies.getItemAt(nFamilyID));
      return _loc3_;
   }
   function getAllFamilies()
   {
      var _loc2_ = [];
      var _loc3_ = this._eoCardsByFamilies.getKeys();
      var _loc4_ = 0;
      while(_loc4_ < _loc3_.length)
      {
         _loc2_.push(_loc3_[_loc4_]);
         _loc4_ = _loc4_ + 1;
      }
      return _loc2_;
   }
   function isOwningTtgCard(nCardID)
   {
      var _loc3_ = dofus.datacenter.ttg.TtgCard(this._eoTtgCardsByCardID.getItemAt(nCardID));
      if(_loc3_ == undefined)
      {
         return false;
      }
      return _loc3_.owned;
   }
   function getTtgCard(nCardID)
   {
      return dofus.datacenter.ttg.TtgCard(this._eoTtgCardsByCardID.getItemAt(nCardID));
   }
   function getTtgCardsItems()
   {
      return this._eoTtgCardsByCardID.getItems();
   }
   function fillWithHash(sHash)
   {
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = [];
      var _loc5_ = new ank.utils.ExtendedObject();
      var _loc6_ = new ank.utils.ExtendedObject();
      var _loc7_ = [];
      var _loc8_ = this.api.lang.getTtgCards();
      for(var k in _loc8_)
      {
         _loc7_.push(_loc8_[k]);
      }
      var _loc9_ = _loc7_.length - 1;
      var _loc10_ = 0;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      while(_loc10_ < sHash.length)
      {
         _loc11_ = sHash.charAt(_loc10_);
         _loc12_ = ank.utils.Compressor.decode64(_loc11_);
         _loc13_ = 5;
         while(_loc13_ >= 0)
         {
            _loc14_ = _loc7_[_loc9_].i;
            if(_loc14_ != undefined)
            {
               _loc15_ = (_loc12_ >> _loc13_ & 1) == 1;
               _loc16_ = new dofus.datacenter.ttg.TtgCard(_loc14_,_loc15_);
               _loc17_ = _loc16_.familyID;
               _loc5_.addItemAt(_loc14_,_loc16_);
               _loc18_ = Array(_loc3_.getItemAt(_loc17_));
               if(_loc18_ == undefined)
               {
                  _loc18_ = [];
                  _loc3_.addItemAt(_loc17_,_loc18_);
               }
               _loc18_.push(_loc16_);
               if(!_loc16_.isFoil)
               {
                  _loc6_.addItemAt(_loc16_.entityID,_loc16_);
               }
               _loc4_.push(_loc14_);
               _loc9_ = _loc9_ - 1;
            }
            _loc13_ = _loc13_ - 1;
         }
         _loc10_ = _loc10_ + 1;
      }
      var _loc19_ = 0;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      while(_loc19_ < _loc4_.length)
      {
         _loc20_ = _loc4_[_loc19_];
         _loc21_ = dofus.datacenter.ttg.TtgCard(_loc5_.getItemAt(_loc20_));
         if(_loc21_.isFoil)
         {
            _loc22_ = dofus.datacenter.ttg.TtgCard(_loc6_.getItemAt(_loc21_.entityID));
            _loc22_.linkedFoil = _loc21_;
         }
         _loc19_ = _loc19_ + 1;
      }
      this._eoTtgCardsByCardID = _loc5_;
      this._eoTtgNonBrillantCardsByEntityID = _loc6_;
      this._aTtgCardsIDs = _loc4_;
      this._eoCardsByFamilies = _loc3_;
   }
}
