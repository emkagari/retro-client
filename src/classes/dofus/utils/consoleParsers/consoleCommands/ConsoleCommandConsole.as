class dofus.utils.consoleParsers.consoleCommands.ConsoleCommandConsole
{
   function ConsoleCommandConsole()
   {
   }
   static function consoleClose(oContext, aTmp)
   {
      oContext.api.ui.getUIComponent("Debug").callClose();
   }
   static function consoleMaxSize(oContext, aTmp)
   {
      var _loc4_;
      if(oContext.api.kernel.OptionsManager.getOption("DebugSizeIndex") != dofus.graphics.gapi.ui.Debug.CONSOLE_MAXSIZE)
      {
         oContext.api.kernel.OptionsManager.setOption("DebugSizeIndex",dofus.graphics.gapi.ui.Debug.CONSOLE_MAXSIZE);
         _loc4_ = dofus.graphics.gapi.ui.Debug(oContext.api.ui.getUIComponent("Debug"));
         if(_loc4_ != undefined)
         {
            _loc4_.applySizeIndex(false);
         }
      }
   }
   static function consoleMinimized(oContext, aTmp)
   {
      var _loc4_;
      if(oContext.api.kernel.OptionsManager.getOption("DebugSizeIndex") != dofus.graphics.gapi.ui.Debug.CONSOLE_MINIMIZED)
      {
         oContext.api.kernel.OptionsManager.setOption("DebugSizeIndex",dofus.graphics.gapi.ui.Debug.CONSOLE_MINIMIZED);
         _loc4_ = dofus.graphics.gapi.ui.Debug(oContext.api.ui.getUIComponent("Debug"));
         if(_loc4_ != undefined)
         {
            _loc4_.applySizeIndex(false);
         }
      }
   }
   static function consoleMedium(oContext, aTmp)
   {
      var _loc4_;
      if(oContext.api.kernel.OptionsManager.getOption("DebugSizeIndex") != dofus.graphics.gapi.ui.Debug.CONSOLE_MEDIUM)
      {
         oContext.api.kernel.OptionsManager.setOption("DebugSizeIndex",dofus.graphics.gapi.ui.Debug.CONSOLE_MEDIUM);
         _loc4_ = dofus.graphics.gapi.ui.Debug(oContext.api.ui.getUIComponent("Debug"));
         if(_loc4_ != undefined)
         {
            _loc4_.applySizeIndex(false);
         }
      }
   }
}
