class dofus.datacenter.ttg.TtgCollectionStats
{
   var _eoOwnedCountByFamilyID;
   var _eoOwnedCountByRarityID;
   var _eoOwnedFoilCountByFamilyID;
   var _eoTotalCountByFamilyID;
   var _eoTotalCountByRarityID;
   var _eoTotalFoilCountByFamilyID;
   var _nOwnedCardsCount;
   var _nOwnedFoilCardsCount;
   var _nTotalCardsCount;
   var _nTotalFoilCardsCount;
   var _ttgCollection;
   function TtgCollectionStats(ttgCollection)
   {
      this._ttgCollection = ttgCollection;
      this.initializeStats();
   }
   function initializeStats()
   {
      var _loc2_ = this._ttgCollection.getTtgCardsItems();
      var _loc3_ = new ank.utils.ExtendedObject();
      var _loc4_ = new ank.utils.ExtendedObject();
      var _loc5_ = new ank.utils.ExtendedObject();
      var _loc6_ = new ank.utils.ExtendedObject();
      var _loc7_ = new ank.utils.ExtendedObject();
      var _loc8_ = new ank.utils.ExtendedObject();
      var _loc9_ = 0;
      var _loc10_ = 0;
      var _loc11_ = 0;
      var _loc12_ = 0;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      for(var k in _loc2_)
      {
         _loc13_ = _loc2_[k];
         if(_loc13_ != undefined)
         {
            if(_loc13_.isFoil)
            {
               _loc10_ = _loc10_ + 1;
               _loc14_ = Number(_loc7_.getItemAt(_loc13_.familyID));
               if(_global.isNaN(_loc14_))
               {
                  _loc14_ = 0;
               }
               _loc14_ = _loc14_ + 1;
               _loc7_.addItemAt(_loc13_.familyID,_loc14_);
               if(_loc13_.owned)
               {
                  _loc12_ = _loc12_ + 1;
                  _loc15_ = Number(_loc5_.getItemAt(_loc13_.familyID));
                  if(_global.isNaN(_loc15_))
                  {
                     _loc15_ = 0;
                  }
                  _loc15_ = _loc15_ + 1;
                  _loc5_.addItemAt(_loc13_.familyID,_loc15_);
               }
            }
            else
            {
               _loc9_ = _loc9_ + 1;
               if(_loc13_.owned)
               {
                  _loc11_ = _loc11_ + 1;
               }
               _loc16_ = Number(_loc6_.getItemAt(_loc13_.familyID));
               _loc17_ = Number(_loc8_.getItemAt(_loc13_.rarity));
               if(_global.isNaN(_loc16_))
               {
                  _loc16_ = 0;
               }
               if(_global.isNaN(_loc17_))
               {
                  _loc17_ = 0;
               }
               _loc16_ = _loc16_ + 1;
               _loc17_ = _loc17_ + 1;
               _loc6_.addItemAt(_loc13_.familyID,_loc16_);
               _loc8_.addItemAt(_loc13_.rarity,_loc17_);
               if(_loc13_.owned)
               {
                  _loc18_ = Number(_loc3_.getItemAt(_loc13_.familyID));
                  _loc19_ = Number(_loc4_.getItemAt(_loc13_.rarity));
                  if(_global.isNaN(_loc18_))
                  {
                     _loc18_ = 0;
                  }
                  if(_global.isNaN(_loc19_))
                  {
                     _loc19_ = 0;
                  }
                  _loc18_ = _loc18_ + 1;
                  _loc19_ = _loc19_ + 1;
                  _loc3_.addItemAt(_loc13_.familyID,_loc18_);
                  _loc4_.addItemAt(_loc13_.rarity,_loc19_);
               }
            }
         }
      }
      this._nTotalCardsCount = _loc9_;
      this._nTotalFoilCardsCount = _loc10_;
      this._nOwnedCardsCount = _loc11_;
      this._nOwnedFoilCardsCount = _loc12_;
      this._eoTotalCountByFamilyID = _loc6_;
      this._eoTotalFoilCountByFamilyID = _loc7_;
      this._eoTotalCountByRarityID = _loc8_;
      this._eoOwnedCountByFamilyID = _loc3_;
      this._eoOwnedFoilCountByFamilyID = _loc5_;
      this._eoOwnedCountByRarityID = _loc4_;
   }
   function getOwnedPercentageByFamilyID(nFamilyID)
   {
      var _loc3_ = Math.floor(this.getOwnedCountByFamilyID(nFamilyID) / this.getTotalCountByFamilyID(nFamilyID) * 100);
      return _loc3_;
   }
   function getOwnedFoilPercentageByFamilyID(nFamilyID)
   {
      var _loc3_ = Math.floor(this.getOwnedFoilCountByFamilyID(nFamilyID) / this.getTotalFoilCountByFamilyID(nFamilyID) * 100);
      return _loc3_;
   }
   function getOwnedCountByFamilyID(nFamilyID)
   {
      var _loc3_ = Number(this._eoOwnedCountByFamilyID.getItemAt(nFamilyID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function getOwnedFoilCountByFamilyID(nFamilyID)
   {
      var _loc3_ = Number(this._eoOwnedFoilCountByFamilyID.getItemAt(nFamilyID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function getTotalCountByFamilyID(nFamilyID)
   {
      var _loc3_ = Number(this._eoTotalCountByFamilyID.getItemAt(nFamilyID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function getTotalFoilCountByFamilyID(nFamilyID)
   {
      var _loc3_ = Number(this._eoTotalFoilCountByFamilyID.getItemAt(nFamilyID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function getOwnedCountByRarity(nRarityID)
   {
      var _loc3_ = Number(this._eoOwnedCountByRarityID.getItemAt(nRarityID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function getTotalCountByRarity(nRarityID)
   {
      var _loc3_ = Number(this._eoTotalCountByRarityID.getItemAt(nRarityID));
      if(_global.isNaN(_loc3_))
      {
         return 0;
      }
      return _loc3_;
   }
   function get fullyOwnedFamiliesCount()
   {
      var _loc2_ = 0;
      var _loc3_ = this._eoOwnedCountByFamilyID.getItems();
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var k in _loc3_)
      {
         _loc4_ = Number(k);
         _loc5_ = this.getOwnedCountByFamilyID(_loc4_);
         _loc6_ = this.getTotalCountByFamilyID(_loc4_);
         if(_loc5_ >= _loc6_)
         {
            _loc2_ = _loc2_ + 1;
         }
      }
      return _loc2_;
   }
   function get familiesCount()
   {
      return this._eoTotalCountByFamilyID.getLength();
   }
   function get ttgCollection()
   {
      return this._ttgCollection;
   }
   function get totalCardsCount()
   {
      return this._nTotalCardsCount;
   }
   function get totalFoilCardsCount()
   {
      return this._nTotalFoilCardsCount;
   }
   function get ownedCardsCount()
   {
      return this._nOwnedCardsCount;
   }
   function get ownedFoilCardsCount()
   {
      return this._nOwnedFoilCardsCount;
   }
}
