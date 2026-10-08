class dofus.graphics.gapi.ui.gameresult.GameResultTeam extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _eaDataProvider;
   var _lblGuildXP;
   var _lblItems;
   var _lblKama;
   var _lblLevel;
   var _lblMountXP;
   var _lblName;
   var _lblWinLoose;
   var _lblXP;
   var _lstPlayers;
   var _sTitle;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "GameResultTeam";
   function GameResultTeam()
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
      super.init(false,dofus.graphics.gapi.ui.gameresult.GameResultTeam.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
      this._lstPlayers._visible = false;
   }
   function addListeners()
   {
   }
   function initTexts()
   {
      this._lblWinLoose.text = this._sTitle;
      this._lblName.text = this.api.lang.getText("NAME_BIG");
      this._lblLevel.text = this.api.lang.getText("LEVEL_SMALL");
      this._lblKama.text = this.api.lang.getText("KAMAS");
      this._lblXP.text = this.api.lang.getText("WIN_XP");
      this._lblMountXP.text = this.api.lang.getText("XP_MOUNT");
      this._lblGuildXP.text = this.api.lang.getText("XP_GUILD");
      this._lblItems.text = this.api.lang.getText("WIN_ITEMS");
   }
   function initData()
   {
      var _loc2_ = this._eaDataProvider.length;
      this._lstPlayers.dataProvider = this._eaDataProvider;
      this._lstPlayers.setSize(undefined,Math.min(_loc2_,dofus.graphics.gapi.ui.GameResult.MAX_VISIBLE_PLAYERS_IN_TEAM) * this._lstPlayers.rowHeight);
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
