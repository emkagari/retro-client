class dofus.graphics.gapi.ui.gameresult.GameResultTeamLight extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _eaDataProvider;
   var _lstPlayers;
   var _sTitle;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "GameResultTeamLight";
   function GameResultTeamLight()
   {
      super();
   }
   function set title(sTitle)
   {
      this._sTitle = sTitle;
   }
   function set dataProvider(eaDataProvider)
   {
      this._eaDataProvider = eaDataProvider;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.gameresult.GameResultTeamLight.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this._lstPlayers._visible = false;
   }
   function addListeners()
   {
   }
   function initData()
   {
      var _loc2_ = this._eaDataProvider.length;
      this._lstPlayers.dataProvider = this._eaDataProvider;
      this._lstPlayers.setSize(undefined,Math.min(_loc2_,1) * this._lstPlayers.rowHeight);
      this._lstPlayers._visible = true;
   }
   function itemRollOver(oEvent)
   {
   }
   function itemRollOut(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
