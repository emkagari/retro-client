class dofus.utils.consoleParsers.consoleCommands.ConsoleCommandNetwork
{
   function ConsoleCommandNetwork()
   {
   }
   static function simulatePacket(oContext, aTmp, bCrypted)
   {
      var _loc5_;
      if(dofus.Constants.DEBUG)
      {
         _loc5_ = aTmp[0];
         aTmp.splice(0,1);
         switch(_loc5_)
         {
            case ">":
               if(bCrypted)
               {
                  oContext.api.network.send(aTmp.join(" "),false,undefined,false,true);
               }
               else
               {
                  oContext.api.network.send(aTmp.join(" "));
               }
               break;
            case "<":
               oContext.api.network.processCommand(aTmp.join(" "));
               break;
            default:
               oContext.showMessage(undefined,"Erreur syntaxe : /" + (!bCrypted ? "C" : "D") + " &lt;\'&lt;\'|\'&gt;\'&gt; &lt;packet&gt;","DEBUG_LOG");
         }
      }
      else
      {
         oContext.showMessage(undefined,"Erreur : Le mode debug n\'est pas activé sur ce client","DEBUG_LOG");
      }
   }
}
