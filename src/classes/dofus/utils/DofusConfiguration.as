class dofus.utils.DofusConfiguration
{
   var _aCacheAsBitmap;
   var _aDataServers;
   var _aLanguages;
   var _aLanguagesFullName;
   var _aXmlLanguages;
   var _bIsExpo;
   var _bSkipLanguageVerification;
   var _oAutoLogin;
   var _sStreamingMethod;
   var customServersIP;
   var _bIsStreaming = false;
   function DofusConfiguration()
   {
      if(_global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME] == undefined)
      {
         _global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME] = ank.utils.SharedObjectFix.getLocal(dofus.Constants.OPTIONS_SHAREDOBJECT_NAME);
      }
   }
   function set dataServers(aHosts)
   {
      this._aDataServers = aHosts;
   }
   function get dataServers()
   {
      return this._aDataServers;
   }
   function set language(sLanguage)
   {
      var _loc3_ = _global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME];
      _loc3_.data.language = sLanguage;
      _loc3_.flush();
   }
   function get language()
   {
      var _loc2_ = dofus.Electron.getLanguage();
      var _loc3_;
      var _loc4_;
      if(_loc2_ != undefined)
      {
         switch(_loc2_)
         {
            case "de":
            case "en":
            case "es":
            case "fr":
            case "it":
            case "nl":
            case "pt":
               return _loc2_;
            default:
               return "fr";
         }
      }
      else
      {
         _loc3_ = _global[dofus.Constants.GLOBAL_SO_OPTIONS_NAME].data.language;
         if(!(_loc3_ == undefined || (_loc3_ == "undefined" || _root.htmlLang != undefined)))
         {
            return _loc3_.toLowerCase();
         }
         if(_root.htmlLang != undefined)
         {
            _loc4_ = _root.htmlLang;
         }
         else
         {
            _loc4_ = System.capabilities.language;
         }
         switch(_loc4_)
         {
            case "fr":
            case "en":
            case "de":
            case "pt":
            case "ru":
            case "nl":
            case "es":
            case "it":
               return _loc4_;
            default:
               return "fr";
         }
      }
   }
   function set languages(aLanguages)
   {
      this._aLanguages = aLanguages;
   }
   function get languages()
   {
      var _loc2_ = [];
      var _loc3_;
      if(this._aXmlLanguages != undefined)
      {
         _loc3_ = 0;
         while(_loc3_ < this._aXmlLanguages.length)
         {
            _loc2_.push(this._aXmlLanguages[_loc3_]);
            _loc3_ = _loc3_ + 1;
         }
      }
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._aLanguages != undefined)
      {
         _loc4_ = 0;
         while(_loc4_ < this._aLanguages.length)
         {
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < this._aXmlLanguages.length)
            {
               if(this._aXmlLanguages[_loc6_] == this._aLanguages[_loc4_])
               {
                  _loc5_ = true;
               }
               _loc6_ = _loc6_ + 1;
            }
            if(!_loc5_)
            {
               _loc2_.push(this._aLanguages[_loc4_]);
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return _loc2_;
   }
   function set languagesFullName(aLanguagesFullName)
   {
      this._aLanguagesFullName = aLanguagesFullName;
   }
   function get languagesFullName()
   {
      return this._aLanguagesFullName;
   }
   function set xmlLanguages(a)
   {
      this._aXmlLanguages = a;
   }
   function get xmlLanguages()
   {
      return this._aXmlLanguages;
   }
   function set skipLanguageCheck(b)
   {
      this._bSkipLanguageVerification = b;
      return this.skipLanguageCheck;
   }
   function get skipLanguageCheck()
   {
      return this._bSkipLanguageVerification;
   }
   function set cacheAsBitmap(aCache)
   {
      this._aCacheAsBitmap = aCache;
   }
   function get cacheAsBitmap()
   {
      return this._aCacheAsBitmap;
   }
   function set isExpo(bExpo)
   {
      this._bIsExpo = bExpo;
   }
   function get isExpo()
   {
      return this._bIsExpo;
   }
   function set isStreaming(bStreaming)
   {
      this._bIsStreaming = bStreaming;
   }
   function get isStreaming()
   {
      return this._bIsStreaming;
   }
   function set autoLogin(oAutoLogin)
   {
      this._oAutoLogin = oAutoLogin;
   }
   function get autoLogin()
   {
      return this._oAutoLogin;
   }
   function set streamingMethod(sName)
   {
      this._sStreamingMethod = sName;
   }
   function get streamingMethod()
   {
      return this._sStreamingMethod;
   }
   function get isLinux()
   {
      return String(System.capabilities.version).indexOf("LNX") > -1;
   }
   function get isWindows()
   {
      return String(System.capabilities.version).indexOf("WIN") > -1;
   }
   function get isMac()
   {
      return String(System.capabilities.version).indexOf("MAC") > -1;
   }
   function getCustomIP(nServerID)
   {
      return this.customServersIP[nServerID];
   }
}
