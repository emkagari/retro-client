class dofus.datacenter.ttg.TtgCard
{
   var _bOwned;
   var _nCardID;
   var _nCorrespondingEntityID;
   var _nCorrespondingItemID;
   var _nFamilyID;
   var _nOwnedTimestamp;
   var _nVariant;
   var _ttgLinkedFoil;
   var api;
   static var CARD_IS_NOT_VARIANT = 0;
   static var CARD_VARIANT_FOIL = 1;
   static var CARD_RARITY_COMMON = 1;
   static var CARD_RARITY_RARE = 2;
   static var CARD_RARITY_EPIC = 3;
   static var CARD_RARITY_UNIC = 4;
   function TtgCard(nCardID, bOwned)
   {
      this.api = _global.API;
      this._nCardID = nCardID;
      this._bOwned = bOwned;
      var _loc4_ = this.api.lang.getTtgCardObject(this._nCardID);
      this._nCorrespondingItemID = _loc4_.o;
      this._nCorrespondingEntityID = _loc4_.e;
      this._nVariant = _loc4_.v;
      var _loc5_ = this.api.lang.getTtgEntityObject(this._nCorrespondingEntityID);
      this._nFamilyID = _loc5_.f;
   }
   function get linkedFoil()
   {
      return this._ttgLinkedFoil;
   }
   function set linkedFoil(ttgLinkedFoil)
   {
      this._ttgLinkedFoil = ttgLinkedFoil;
   }
   function get ownedTimestamp()
   {
      return this._nOwnedTimestamp;
   }
   function set ownedTimestamp(ownedTimestamp)
   {
      this._nOwnedTimestamp = ownedTimestamp;
   }
   function get ownedFoilTimestamp()
   {
      return this._ttgLinkedFoil != undefined ? this._ttgLinkedFoil.ownedTimestamp : undefined;
   }
   function get cardID()
   {
      return this._nCardID;
   }
   function get familyID()
   {
      return this._nFamilyID;
   }
   function get owned()
   {
      return this._bOwned;
   }
   function set owned(bOwned)
   {
      this._bOwned = bOwned;
   }
   function get ownedFoil()
   {
      return this._ttgLinkedFoil != undefined && this._ttgLinkedFoil.owned;
   }
   function get isFoil()
   {
      return this._nVariant == dofus.datacenter.ttg.TtgCard.CARD_VARIANT_FOIL;
   }
   function get rarity()
   {
      return this.api.lang.getTtgEntityObject(this._nCorrespondingEntityID).a;
   }
   function get entityID()
   {
      return this._nCorrespondingEntityID;
   }
   function get entityName()
   {
      return this.api.lang.getTtgEntityObject(this._nCorrespondingEntityID).n;
   }
   function get correspondingItemID()
   {
      return this._nCorrespondingItemID;
   }
   function get correspondingBoosterItemID()
   {
      return this.api.lang.getTtgFamilyObject(this._nFamilyID).o;
   }
   function get familyName()
   {
      return this.api.lang.getTtgFamilyObject(this._nFamilyID).n;
   }
   function get iconFile()
   {
      return "Card";
   }
   function get forceReloadOnContainer()
   {
      return true;
   }
   function get params()
   {
      return {ID:this.cardID,familyID:this.familyID,name:this.entityName,rarity:this.rarity,isUnlocked:this.owned,isFoil:this.ownedFoil,itemID:this.correspondingItemID};
   }
}
