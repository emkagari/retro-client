class dofus.datacenter.GuildRights extends Object
{
   var _nRights;
   function GuildRights(nRights)
   {
      super();
      this._nRights = nRights;
   }
   function get value()
   {
      return this._nRights;
   }
   function set value(nValue)
   {
      this._nRights = nValue;
   }
   function get isBossValue()
   {
      return 1;
   }
   function get isBoss()
   {
      return (this._nRights & this.isBossValue) == this.isBossValue;
   }
   function get canManageBoostValue()
   {
      return 2;
   }
   function get canManageBoost()
   {
      return this.isBoss || (this._nRights & this.canManageBoostValue) == this.canManageBoostValue;
   }
   function get canManageRightsValue()
   {
      return 4;
   }
   function get canManageRights()
   {
      return this.isBoss || (this._nRights & this.canManageRightsValue) == this.canManageRightsValue;
   }
   function get canInviteValue()
   {
      return 8;
   }
   function get canInvite()
   {
      return this.isBoss || (this._nRights & this.canInviteValue) == this.canInviteValue;
   }
   function get canBannValue()
   {
      return 16;
   }
   function get canBann()
   {
      return this.isBoss || (this._nRights & this.canBannValue) == this.canBannValue;
   }
   function get canManageXPContributionValue()
   {
      return 32;
   }
   function get canManageXPContribution()
   {
      return this.isBoss || (this._nRights & this.canManageXPContributionValue) == this.canManageXPContributionValue;
   }
   function get canManageRanksValue()
   {
      return 64;
   }
   function get canManageRanks()
   {
      return this.isBoss || (this._nRights & this.canManageRanksValue) == this.canManageRanksValue;
   }
   function get canHireTaxCollectorValue()
   {
      return 128;
   }
   function get canHireTaxCollector()
   {
      return this.isBoss || (this._nRights & this.canHireTaxCollectorValue) == this.canHireTaxCollectorValue;
   }
   function get canManageOwnXPContributionValue()
   {
      return 256;
   }
   function get canManageOwnXPContribution()
   {
      return this.isBoss || (this._nRights & this.canManageOwnXPContributionValue) == this.canManageOwnXPContributionValue;
   }
   function get canCollectValue()
   {
      return 512;
   }
   function get canCollect()
   {
      return this.isBoss || (this._nRights & this.canCollectValue) == this.canCollectValue;
   }
   function get canUseMountParkValue()
   {
      return 4096;
   }
   function get canUseMountPark()
   {
      return this.isBoss || (this._nRights & this.canUseMountParkValue) == this.canUseMountParkValue;
   }
   function get canArrangeMountParkValue()
   {
      return 8192;
   }
   function get canArrangeMountPark()
   {
      return this.isBoss || (this._nRights & this.canArrangeMountParkValue) == this.canArrangeMountParkValue;
   }
   function get canManageOtherMountValue()
   {
      return 16384;
   }
   function get canManageOtherMount()
   {
      return this.isBoss || (this._nRights & this.canManageOtherMountValue) == this.canManageOtherMountValue;
   }
   function get canPriorityDefendTaxCollectorValue()
   {
      return 32768;
   }
   function get canPriorityDefendTaxCollector()
   {
      return this.isBoss || (this._nRights & this.canPriorityDefendTaxCollectorValue) == this.canPriorityDefendTaxCollectorValue;
   }
   function get canCollectOwnTaxCollectorValue()
   {
      return 65536;
   }
   function get canCollectOwnTaxCollector()
   {
      return this.isBoss || (this._nRights & this.canCollectOwnTaxCollectorValue) == this.canCollectOwnTaxCollectorValue;
   }
   function get canEditGuildNotesValue()
   {
      return 131072;
   }
   function get canEditGuildNotes()
   {
      return this.isBoss || (this._nRights & this.canEditGuildNotesValue) == this.canEditGuildNotesValue;
   }
   function get canEditGuildInformationsValue()
   {
      return 262144;
   }
   function get canEditGuildInformations()
   {
      return this.isBoss || (this._nRights & this.canEditGuildInformationsValue) == this.canEditGuildInformationsValue;
   }
}
