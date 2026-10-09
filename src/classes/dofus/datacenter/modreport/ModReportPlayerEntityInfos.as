class dofus.datacenter.modreport.ModReportPlayerEntityInfos
{
   var _bIsOnline;
   var _sAccountPseudo;
   var _sCharacterID;
   var _sCharacterName;
   var _sContext;
   function ModReportPlayerEntityInfos(sCharacterID, sCharacterName_, sAccountPseudo, bIsOnline, nMapId, sContext)
   {
      this._sCharacterID = sCharacterID;
      this._sCharacterName = sCharacterName_;
      this._sAccountPseudo = sAccountPseudo;
      this._bIsOnline = bIsOnline;
      this._sContext = sContext;
   }
   function get characterID()
   {
      return this._sCharacterID;
   }
   function get accountPseudo()
   {
      return this._sAccountPseudo;
   }
   function get characterName()
   {
      return this._sCharacterName;
   }
   function get isOnline()
   {
      return this._bIsOnline;
   }
   function get context()
   {
      return this._sContext;
   }
   function toString()
   {
      return "Character Name : " + this.characterName + ", Account Pseudo : " + this.accountPseudo + ", Character ID : " + this.characterID;
   }
}
