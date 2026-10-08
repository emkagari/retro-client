class dofus.datacenter.TemporisInfos extends Object
{
   var _aTemporisUIComponents;
   var _nCurrentTempokens;
   var _nMaxTempokens;
   var _nTemporisVersion;
   var _sTemporisName;
   var api;
   var dispatchEvent;
   function TemporisInfos(nMaxTempokens)
   {
      super();
      this.api = _global.API;
      mx.events.EventDispatcher.initialize(this);
      this.initialize(false,nMaxTempokens);
   }
   function get temporisName()
   {
      return this._sTemporisName;
   }
   function get temporisVersion()
   {
      return this._nTemporisVersion;
   }
   function get temporisUIComponents()
   {
      return this._aTemporisUIComponents;
   }
   function get currentTempokens()
   {
      return this._nCurrentTempokens;
   }
   function get maxTempokens()
   {
      return this._nMaxTempokens;
   }
   function initialize(bUpdate, nMaxTempokens)
   {
      this._nMaxTempokens = nMaxTempokens;
      this._nTemporisVersion = this.api.lang.getConfigText("TEMPORIS_CURRENT_VERSION");
      this._sTemporisName = this.api.lang.getText("TEMPORIS_" + this._nTemporisVersion + "_NAME");
      this._aTemporisUIComponents = this.api.lang.getConfigText("TEMPORIS_" + this._nTemporisVersion + "_UI_COMPONENTS");
      this._nCurrentTempokens = this.api.datacenter.Player.Inventory.findFirstItem("unicID",12001).item.Quantity;
      if(bUpdate)
      {
         this.dispatchEvent({type:"modelChanged",eventName:"infosUpdate"});
      }
   }
}
