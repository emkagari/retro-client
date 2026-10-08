/**
 * Hot reload, in dev builds only (node tools/dev.mjs — never in src/ nor in
 * a normal build). Starts by itself when the class is defined.
 *
 * tools/dev.mjs compiles each saved class into hot/<n>.swf, next to the
 * loader, then writes hot/version.txt: "n=<n>&classes=<a.b.C>,…". Every
 * second this class reads it; on a new <n> it loads the patch and copies the
 * new code INTO the existing classes — their prototype, so objects already
 * created use it at once: methods, get/set, static functions, and static
 * CONSTANTS (UPPER_CASE names, the code's convention: WIDTH, CLASS_NAME).
 * Other static values (_instance, counters: the game's state) are kept.
 */
class dofus.dev.HotReload
{
   static var POLL_MS = 1000;
   static var TIMEOUT_MS = 10000;
   static var _nVersion = -1;
   static var _bBusy = false;
   // Methods may not be defined yet when static values are: call them later.
   static var _nTimer = _global.setInterval(function()
   {
      dofus.dev.HotReload.poll();
   },dofus.dev.HotReload.POLL_MS);
   static function poll()
   {
      if(dofus.dev.HotReload._bBusy)
      {
         return undefined;
      }
      var lv = new LoadVars();
      lv.onLoad = function(bSuccess)
      {
         if(!bSuccess)
         {
            return undefined;
         }
         var n = Number(this.n);
         // The first read is what the running build already has.
         if(dofus.dev.HotReload._nVersion == -1)
         {
            dofus.dev.HotReload._nVersion = n;
            return undefined;
         }
         if(n > dofus.dev.HotReload._nVersion)
         {
            dofus.dev.HotReload._nVersion = n;
            dofus.dev.HotReload.load(n,String(this.classes).split(","));
         }
      };
      lv.load("hot/version.txt");
   }
   /** The package object holding a class, and its short name. */
   static function find(sClass)
   {
      var parts = sClass.split(".");
      var pkg = _global;
      var i = 0;
      while(i < parts.length - 1)
      {
         pkg = pkg[parts[i]];
         i = i + 1;
      }
      return {pkg:pkg,name:parts[parts.length - 1]};
   }
   static function load(n, aClasses)
   {
      dofus.dev.HotReload._bBusy = true;
      var old = {};
      var i = 0;
      var c;
      while(i < aClasses.length)
      {
         c = dofus.dev.HotReload.find(aClasses[i]);
         old[aClasses[i]] = c.pkg[c.name];
         // A class definition only runs when the class is missing.
         c.pkg[c.name] = undefined;
         i = i + 1;
      }
      var mc = _root.createEmptyMovieClip("__hotReload" + n,_root.getNextHighestDepth());
      mc.loadMovie("hot/" + n + ".swf");
      var start = getTimer();
      var timer;
      timer = _global.setInterval(function()
      {
         var defined = true;
         var j = 0;
         var k;
         while(j < aClasses.length)
         {
            k = dofus.dev.HotReload.find(aClasses[j]);
            if(k.pkg[k.name] == undefined)
            {
               defined = false;
            }
            j = j + 1;
         }
         if(defined || getTimer() - start > dofus.dev.HotReload.TIMEOUT_MS)
         {
            _global.clearInterval(timer);
            dofus.dev.HotReload.merge(old,aClasses,defined);
            mc.removeMovieClip();
            dofus.dev.HotReload._bBusy = false;
         }
      },50);
   }
   static function merge(old, aClasses, bDefined)
   {
      var done = [];
      var i = 0;
      var c;
      var prev;
      var fresh;
      while(i < aClasses.length)
      {
         c = dofus.dev.HotReload.find(aClasses[i]);
         prev = old[aClasses[i]];
         fresh = c.pkg[c.name];
         if(prev == undefined)
         {
            // A new class: the fresh one is the class.
            done.push(aClasses[i] + " (new)");
         }
         else if(!bDefined || fresh == undefined)
         {
            c.pkg[c.name] = prev;
         }
         else
         {
            var n = dofus.dev.HotReload.copy(fresh,prev);
            // The old class object stays: registerClass, instanceof and other classes point at it.
            c.pkg[c.name] = prev;
            done.push(aClasses[i] + " (" + n.members + " members, " + n.statics + " statics)");
         }
         i = i + 1;
      }
      var msg = !bDefined ? "hot reload FAILED (patch not loaded): " + aClasses.join(", ") : "hot reload: " + done.join(", ");
      _global.API.kernel.showMessage(undefined,msg,"COMMANDS_CHAT");
      dofus.dev.HotReload.log(msg);
   }
   /** Also to the page's console (Electron's dev tools): the chat isn't there before login. */
   static function log(sMsg)
   {
      if(flash.external.ExternalInterface.available)
      {
         flash.external.ExternalInterface.call("console.log","[hot] " + sMsg);
      }
   }
   /** fresh's code into prev: prototype members and accessors, static functions and constants. Returns the counts. */
   static function copy(fresh, prev)
   {
      var counts = {members:0,statics:0};
      var p = fresh.prototype;
      var q = prev.prototype;
      _global.ASSetPropFlags(p,null,0,1);
      var props = {};
      var k;
      for(k in p)
      {
         if(k.substr(0,7) == "__get__" || k.substr(0,7) == "__set__")
         {
            props[k.substr(7)] = true;
         }
      }
      for(k in p)
      {
         // Own members only; accessor properties are registered again below (reading one would call its getter).
         if(p.hasOwnProperty(k) && k != "__proto__" && k != "constructor" && k != "__constructor__" && !props[k])
         {
            q[k] = p[k];
            counts.members = counts.members + 1;
         }
      }
      for(k in props)
      {
         q.addProperty(k,q["__get__" + k] != undefined ? q["__get__" + k] : function()
         {
         },q["__set__" + k] != undefined ? q["__set__" + k] : null);
      }
      _global.ASSetPropFlags(q,null,1);
      _global.ASSetPropFlags(fresh,null,0,1);
      for(k in fresh)
      {
         // Functions and constants; the rest (_instance…) is the running game's state.
         if(k != "prototype" && fresh.hasOwnProperty(k) && (typeof fresh[k] == "function" || dofus.dev.HotReload.isConstant(k)))
         {
            prev[k] = fresh[k];
            counts.statics = counts.statics + 1;
         }
      }
      return counts;
   }
   static function isConstant(sName)
   {
      return sName.length > 0 && sName == sName.toUpperCase() && sName.charAt(0) != "_";
   }
}
