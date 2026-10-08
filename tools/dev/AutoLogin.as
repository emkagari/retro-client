/**
 * Automatic login, in dev builds only (node tools/dev.mjs — never in src/ nor
 * in a normal build). Starts by itself when the class is defined.
 *
 * Reads hot/dev.txt, written by tools/dev.mjs from retro.local.json's "dev":
 * "login=…&password=…&server=<id>&character=<name>". Then, each time one of
 * these screens appears, does what a click would:
 * - Login: the client's own autoLogin (fills the fields, clicks OK);
 * - ChooseServer: selectServer(<server>, else the first one);
 * - ChooseCharacter: Account.setCharacter(<character>, else the first one).
 */
class dofus.dev.AutoLogin
{
   static var POLL_MS = 500;
   static var _oConfig;
   static var _bReading = false;
   static var _oDone = {};
   static var _nTimer = _global.setInterval(function()
   {
      dofus.dev.AutoLogin.poll();
   },dofus.dev.AutoLogin.POLL_MS);
   static function poll()
   {
      if(dofus.dev.AutoLogin._oConfig == undefined)
      {
         if(!dofus.dev.AutoLogin._bReading)
         {
            dofus.dev.AutoLogin._bReading = true;
            dofus.dev.AutoLogin.readConfig();
         }
         return undefined;
      }
      var cfg = dofus.dev.AutoLogin._oConfig;
      if(cfg.login == undefined || cfg.login == "")
      {
         return undefined;
      }
      var api = _global.API;
      var ui = api.ui.getUIComponent("Login");
      if(dofus.dev.AutoLogin.firstTime("Login",ui) && ui.isLoaded())
      {
         dofus.dev.AutoLogin.done("Login",ui);
         ui.autoLogin(cfg.login,cfg.password);
      }
      ui = api.ui.getUIComponent("ChooseServer");
      if(dofus.dev.AutoLogin.firstTime("ChooseServer",ui) && api.datacenter.Basics.aks_servers.length > 0)
      {
         dofus.dev.AutoLogin.done("ChooseServer",ui);
         var server = cfg.server != undefined && cfg.server != "" ? Number(cfg.server) : api.datacenter.Basics.aks_servers[0].id;
         ui.selectServer(server);
      }
      ui = api.ui.getUIComponent("ChooseCharacter");
      if(dofus.dev.AutoLogin.firstTime("ChooseCharacter",ui) && ui._aSpriteList.length > 0)
      {
         dofus.dev.AutoLogin.done("ChooseCharacter",ui);
         var list = ui._aSpriteList;
         var chosen = list[0];
         var i = 0;
         while(i < list.length)
         {
            if(cfg.character != undefined && String(list[i].name).toLowerCase() == String(cfg.character).toLowerCase())
            {
               chosen = list[i];
            }
            i = i + 1;
         }
         api.network.Account.setCharacter(chosen.id);
      }
   }
   /** A screen not handled yet: each new instance of it gets one go (log out, log in again: again). */
   static function firstTime(sName, ui)
   {
      return ui != undefined && dofus.dev.AutoLogin._oDone[sName] != ui;
   }
   static function done(sName, ui)
   {
      dofus.dev.AutoLogin._oDone[sName] = ui;
   }
   static function readConfig()
   {
      var lv = new LoadVars();
      lv.onLoad = function(bSuccess)
      {
         // No file (or no "dev" settings): nothing to do, ever.
         dofus.dev.AutoLogin._oConfig = !bSuccess ? {} : {login:this.login,password:this.password,server:this.server,character:this.character};
      };
      lv.load("hot/dev.txt");
   }
}
