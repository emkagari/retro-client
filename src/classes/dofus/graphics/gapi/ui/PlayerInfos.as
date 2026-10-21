class dofus.graphics.gapi.ui.PlayerInfos extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClose;
   var _lstEffects;
   var _oData;
   var _winBackground;
   var addToQueue;
   var unloadThis;
   static var CLASS_NAME = "PlayerInfos";
   function PlayerInfos()
   {
      super();
   }
   function set data(oData)
   {
      this._oData = oData;
   }
   function get data()
   {
      return this._oData;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.PlayerInfos.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
   }
   function initData()
   {
      if(this._oData != undefined)
      {
         this._winBackground.title = this.api.lang.getText("EFFECTS") + " " + this._oData.name + " (" + this.api.lang.getText("LEVEL_SMALL") + this._oData.Level + ")";
         this._lstEffects.dataProvider = this._oData.EffectsManager.getEffects();
      }
   }
   function quit()
   {
      this.unloadThis();
   }
   function click(oEvent)
   {
      this.unloadThis();
   }
}
