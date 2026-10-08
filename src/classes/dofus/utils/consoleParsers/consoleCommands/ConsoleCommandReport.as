class dofus.utils.consoleParsers.consoleCommands.ConsoleCommandReport
{
   function ConsoleCommandReport()
   {
   }
   static function sendModReports(oContext, aTmp)
   {
      if(!oContext.api.electron.enabled)
      {
         oContext.showMessage(undefined,"Fonctionne uniquement avec l\'interface electron","ERROR_CHAT");
         return undefined;
      }
      oContext.api.electron.modReportsSendDayReportsDocs(aTmp[0]);
   }
   static function mergeModReports(oContext, aTmp)
   {
      if(!oContext.api.electron.enabled)
      {
         oContext.showMessage(undefined,"Fonctionne uniquement avec l\'interface electron","ERROR_CHAT");
         return undefined;
      }
      oContext.api.electron.modReportsMergeDayReportsDocs(aTmp[0]);
   }
   static function printModReports(oContext, aTmp)
   {
      if(!oContext.api.electron.enabled)
      {
         oContext.showMessage(undefined,"This feature is not compatible on a Flash Projector","ERROR_CHAT");
         return undefined;
      }
      oContext.api.electron.modReportsPrintPendingReports();
   }
   static function makeReport(oContext, aTmp, sCmd_)
   {
      if(!oContext.api.electron.enabled)
      {
         oContext.showMessage(undefined,"This feature is not compatible on a Flash Projector","ERROR_CHAT");
         return undefined;
      }
      if(!dofus.managers.AdminManager.getInstance().isExecutingBatch)
      {
         oContext.showMessage(undefined,"You can\'t do this out of a batch execution.","ERROR_CHAT");
         return undefined;
      }
      var _loc5_ = sCmd_.split("|");
      var _loc6_ = _loc5_[0].split(" ")[1];
      var _loc7_ = _loc5_[1] == "allaccounts";
      var _loc8_ = _loc5_[2];
      var _loc9_ = _loc5_[3].split(",");
      if(_loc6_ == undefined || (_loc6_.length < 1 || (_loc8_ == undefined || _loc8_.length < 1)))
      {
         oContext.showMessage(undefined,"/makereport &lt;target pseudos|\'allaccounts\'|reason|[autocomplete action]&gt;","DEBUG_LOG");
         return undefined;
      }
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if(_loc9_ != undefined)
      {
         _loc12_ = 0;
         while(_loc12_ < _loc9_.length)
         {
            _loc13_ = _loc9_[_loc12_];
            switch(_loc13_)
            {
               case "chatmessage":
                  _loc10_ = oContext.api.kernel.GameManager.lastClickedMessage;
                  break;
               case "jaildialog":
                  _loc11_ = oContext.api.kernel.ChatManager.getJailDialog();
            }
            _loc12_ = _loc12_ + 1;
         }
      }
      var _loc14_ = dofus.graphics.gapi.ui.MakeReport(oContext.api.ui.getUIComponent("MakeReport"));
      var _loc15_;
      var _loc16_;
      if(_loc14_ == undefined)
      {
         oContext.api.datacenter.Temporary.Report = {};
         _loc15_ = oContext.api.datacenter.Temporary.Report;
         _loc15_.currentTargetPseudos = _loc6_;
         _loc15_.currentTargetIsAllAccounts = _loc7_;
         _loc15_.targetPseudos = _loc6_;
         _loc15_.description = _loc10_;
         _loc15_.jailDialog = _loc11_;
         _loc15_.isAllAccounts = _loc7_;
         _loc15_.reason = _loc8_;
      }
      else
      {
         _loc16_ = oContext.api.datacenter.Temporary.Report;
         _loc16_.currentTargetPseudos = _loc6_;
         _loc16_.currentTargetIsAllAccounts = _loc7_;
         _loc16_.targetPseudos += "," + _loc6_;
         _loc16_.description = _loc10_;
      }
      oContext.api.network.Basics.askReportInfos(1,_loc6_,_loc7_);
   }
}
