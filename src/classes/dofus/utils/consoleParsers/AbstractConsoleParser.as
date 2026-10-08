class dofus.utils.consoleParsers.AbstractConsoleParser
{
   var _aConsoleHistory;
   var _nConsoleHistoryPointer;
   var _oAPI;
   function AbstractConsoleParser()
   {
   }
   function get api()
   {
      return this._oAPI;
   }
   function set api(oApi)
   {
      this._oAPI = oApi;
   }
   function initialize(oAPI)
   {
      this._oAPI = oAPI;
      this._aConsoleHistory = [];
      this._nConsoleHistoryPointer = 0;
   }
   function process(sCmd, oParams)
   {
      this.pushHistory({value:sCmd,params:oParams});
   }
   function pushHistory(oCommand)
   {
      var _loc3_ = this._aConsoleHistory.slice(-1);
      var _loc4_;
      if(_loc3_[0].value != oCommand.value)
      {
         _loc4_ = this._aConsoleHistory.push(oCommand);
         if(_loc4_ > 50)
         {
            this._aConsoleHistory.shift();
         }
      }
      this.initializePointers();
   }
   function getHistoryUp()
   {
      if(this._nConsoleHistoryPointer > 0)
      {
         this._nConsoleHistoryPointer = this._nConsoleHistoryPointer - 1;
      }
      var _loc2_ = this._aConsoleHistory[this._nConsoleHistoryPointer];
      return _loc2_;
   }
   function getHistoryDown()
   {
      if(this._nConsoleHistoryPointer < this._aConsoleHistory.length)
      {
         this._nConsoleHistoryPointer = this._nConsoleHistoryPointer + 1;
      }
      var _loc2_ = this._aConsoleHistory[this._nConsoleHistoryPointer];
      return _loc2_;
   }
   function autoCompletion(aList, sCmd)
   {
      return ank.utils.ConsoleUtils.autoCompletion(aList,sCmd);
   }
   function doConsoleAutoComplete(api, sText)
   {
      var _loc4_;
      if(sText.charAt(0) == "/")
      {
         _loc4_ = api.kernel.Console.autoCompletion(dofus.utils.consoleParsers.ConsoleCommand.commandNames,sText.substring(1,sText.length));
      }
      else
      {
         _loc4_ = api.kernel.Console.autoCompletion(api.datacenter.Basics.allowedAdminCommands,sText);
      }
      if(!_loc4_.isFull)
      {
         if(_loc4_.list == undefined || _loc4_.list.length == 0)
         {
            api.sounds.events.onError();
         }
         else
         {
            api.ui.showTooltip(_loc4_.list.sort().join(", "));
         }
      }
      var _loc5_ = (sText.charAt(0) != "/" ? "" : "/") + _loc4_.result + (!_loc4_.isFull ? "" : " ");
      var _loc6_ = dofus.graphics.gapi.ui.Debug(api.ui.getUIComponent("Debug"));
      if(_loc6_ != undefined)
      {
         _loc6_.tiCommandLine = _loc5_;
         _loc6_.placeCursorAtTheEnd();
      }
      api.electron.retroConsoleSetPromptText(_loc5_);
   }
   function initializePointers()
   {
      this._nConsoleHistoryPointer = this._aConsoleHistory.length;
   }
}
