class dofus.utils.consoleParsers.DebugConsoleParser extends dofus.utils.consoleParsers.AbstractConsoleParser
{
   var _bLogInTerminal = true;
   function DebugConsoleParser(oAPI)
   {
      super();
      this.initialize(oAPI);
   }
   function set logInTerminal(bActive)
   {
      this._bLogInTerminal = bActive;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
   }
   function process(sCmds)
   {
      super.process(sCmds);
      var _loc4_ = sCmds.split(dofus.aks.Basics.MULTIPLE_ADMIN_COMMANDS_SPLIT_STR);
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = _loc4_[_loc5_];
         this.processOneAdminCommand(_loc6_);
         _loc5_ = _loc5_ + 1;
      }
   }
   function processOneAdminCommand(sCmd_)
   {
      if(this._bLogInTerminal)
      {
         this.logCmdInTerminal(sCmd_);
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(sCmd_.charAt(0) == "/")
      {
         _loc3_ = sCmd_.split(" ");
         _loc4_ = _loc3_[0].substr(1).toUpperCase();
         _loc3_.splice(0,1);
         _loc5_ = dofus.utils.consoleParsers.ConsoleCommand.tryGetCommand(_loc4_);
         if(_loc5_ != undefined)
         {
            _loc5_.execute(this,_loc3_);
         }
         else
         {
            this.showMessage(undefined,this.api.lang.getText("UNKNOW_COMMAND",[_loc4_]),"DEBUG_ERROR");
         }
      }
      else if(this.api.datacenter.Basics.isLogged)
      {
         sCmd_ = this.analyseCmd(sCmd_);
         this.api.network.Basics.autorisedCommand(sCmd_);
      }
      else
      {
         this.showMessage(undefined,this.api.lang.getText("UNKNOW_COMMAND",[sCmd_]),"DEBUG_ERROR");
      }
   }
   function analyseCmd(sCmd_)
   {
      var _loc3_ = sCmd_.split(" ");
      var _loc4_ = _loc3_.length <= 0 ? "" : String(_loc3_[0]).toLowerCase();
      var _loc0_;
      if((_loc0_ = _loc4_) === "hash")
      {
         if(_loc3_.length > 1 && (_loc3_.length < 3 && String(_loc3_[1]).toUpperCase() == "ADD"))
         {
            sCmd_ = "";
            this.api.electron.getHash();
         }
      }
      return sCmd_;
   }
   function showMessage(sTitle_, sMsg, sType_)
   {
      var _loc5_ = dofus.graphics.gapi.ui.Debug.FILE_OUTPUT_STATE;
      var _loc6_;
      if(this.api.electron.enabled)
      {
         _loc6_ = new ank.utils.ExtendedString(sMsg).externalInterfaceEscape();
         this.api.electron.consolePrint(_loc6_,sType_,undefined,true);
         if(_loc5_ != 0)
         {
            this.api.electron.consoleLog(sType_,_loc6_,true);
            if(_loc5_ == 2)
            {
               return undefined;
            }
         }
      }
      if(!this.api.electron.isShowingWidescreenPanel || this.api.electron.getWidescreenPanelId() != dofus.Electron.WIDESCREEN_PANEL_CONSOLE)
      {
         this.api.kernel.showMessage(sTitle_,sMsg,sType_);
      }
   }
   function logCmdInTerminal(sCmd_)
   {
      var _loc3_ = dofus.graphics.gapi.ui.Debug.FILE_OUTPUT_STATE;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(this.api.electron.enabled)
      {
         if(sCmd_.charAt(0) == "/")
         {
            sCmd_ = "<font style=\"color:#fffb08\">" + "/" + "</font>" + sCmd_.substring(1,sCmd_.length);
         }
         _loc4_ = new Date();
         _loc5_ = "[" + (_loc4_.getHours() >= 10 ? _loc4_.getHours() : "0" + _loc4_.getHours()) + ":" + (_loc4_.getMinutes() >= 10 ? _loc4_.getMinutes() : "0" + _loc4_.getMinutes()) + "]";
         _loc6_ = "<font style=\"color:#BEBDAE\">" + _loc5_ + "</font> " + "<font color=\"#FFFFFF\">" + sCmd_ + "</font>";
         _loc7_ = new ank.utils.ExtendedString(_loc6_).externalInterfaceEscape();
         this.api.electron.consolePrint(_loc7_,"DEBUG_LOG",undefined,true);
         if(_loc3_ != 0)
         {
            this.api.electron.consoleLog("DEBUG_LOG",_loc7_,true);
            if(_loc3_ == 2)
            {
               return undefined;
            }
         }
      }
   }
}
