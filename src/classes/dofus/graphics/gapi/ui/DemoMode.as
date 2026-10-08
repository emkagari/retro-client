class dofus.graphics.gapi.ui.DemoMode extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnDemoReset;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "DemoMode";
   function DemoMode()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.DemoMode.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
   }
   function addListeners()
   {
      this._btnDemoReset.addEventListener("click",this);
   }
   function initTexts()
   {
      this._btnDemoReset.label = "Redémarrer la démo";
   }
   function click(oEvent_)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent_.target) === this._btnDemoReset)
      {
         _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoReset",{title:this.api.lang.getText("QUESTION"),text:"Voulez-vous redémarrer la démonstration du jeu depuis le début ?"});
         _loc3_.addEventListener("yes",this);
      }
   }
   function yes(oEvent_)
   {
      var _loc0_;
      if((_loc0_ = oEvent_.target._name) === "AskYesNoReset")
      {
         this.api.network.Account.askResetDemoMode();
      }
   }
}
