class ank.utils.Logger
{
   var _errors;
   var _logs;
   static var LC = new LocalConnection();
   static var MAX_LOG_COUNT = 50;
   static var MAX_LOG_SIZE = 300;
   static var _instance = new ank.utils.Logger();
   function Logger()
   {
      this._logs = [];
      this._errors = [];
      ank.utils.Logger.LC.connect("loggerIn");
      ank.utils.Logger.LC.getLogs = function()
      {
         ank.utils.Logger.LC.send("loggerOut","log",ank.utils.Logger.logs);
      };
      ank.utils.Logger.LC.getErrors = function()
      {
         ank.utils.Logger.LC.send("loggerOut","err",ank.utils.Logger.errors);
      };
   }
   static function log(txt, sSource)
   {
      ank.utils.Logger.LC.send("loggerOut","log",txt);
      if(txt.length < ank.utils.Logger.MAX_LOG_SIZE)
      {
         ank.utils.Logger._instance._logs.push(sSource != undefined ? sSource + " :\n" + txt : txt);
      }
      if(ank.utils.Logger._instance._logs.length > ank.utils.Logger.MAX_LOG_COUNT)
      {
         ank.utils.Logger._instance._logs.shift();
      }
   }
   static function err(txt)
   {
      txt = "ERROR : " + txt;
      ank.utils.Logger.LC.send("loggerOut","err",txt);
      ank.utils.Logger._instance._errors.push(txt);
   }
   static function get logs()
   {
      return ank.utils.Logger._instance._logs.join("\n");
   }
   static function get errors()
   {
      return ank.utils.Logger._instance._errors.join("\n");
   }
}
