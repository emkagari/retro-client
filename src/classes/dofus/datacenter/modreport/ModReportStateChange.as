class dofus.datacenter.modreport.ModReportStateChange
{
   var _nCreationInstant;
   var _sIssuerAccountPseudo;
   var _sIssuerCustomNote;
   var _sState;
   function ModReportStateChange(nCreationInstant, sIssuerAccountPseudo, sState, sIssuerCustomNote)
   {
      this._nCreationInstant = nCreationInstant;
      this._sIssuerAccountPseudo = sIssuerAccountPseudo;
      this._sState = sState;
      this._sIssuerCustomNote = sIssuerCustomNote;
   }
   function get creationInstant()
   {
      return this._nCreationInstant;
   }
   function get creationInstantString()
   {
      return new ank.utils.ExtendedDate(this.creationInstant).getFullDateTimeString();
   }
   function get issuerAccountPseudo()
   {
      return this._sIssuerAccountPseudo;
   }
   function get state()
   {
      return this._sState;
   }
   function get issuerCustomNote()
   {
      return this._sIssuerCustomNote;
   }
   function get isToProcessState()
   {
      return this.state == dofus.datacenter.modreport.ModReportStates.STATE_PENDING || this.state == dofus.datacenter.modreport.ModReportStates.STATE_STUDYING;
   }
   function get isAlreadyProcessedState()
   {
      return this.state == dofus.datacenter.modreport.ModReportStates.STATE_INVALID || (this.state == dofus.datacenter.modreport.ModReportStates.STATE_CONFIRMED || this.state == dofus.datacenter.modreport.ModReportStates.STATE_IGNORED);
   }
}
