class dofus.ZaapConnect extends dofus.utils.ApiElement
{
   var _api;
   var _bConnected;
   var _bDebug;
   var _sDisabledOnErrorLangKey;
   static var ZAAP_HASH_LENGTH = 36;
   static var ENABLED = true;
   static var instance = null;
   var _nPort = null;
   var _authToken = null;
   var _bDisabledOnError = false;
   function ZaapConnect()
   {
      super();
      this._api = _global.API;
   }
   static function newInstance()
   {
      if(!dofus.ZaapConnect.isEnabled())
      {
         return null;
      }
      if(dofus.ZaapConnect.instance != null)
      {
         delete dofus.ZaapConnect.instance;
      }
      dofus.ZaapConnect.instance = new dofus.ZaapConnect();
      return dofus.ZaapConnect.instance;
   }
   static function getInstance()
   {
      return dofus.ZaapConnect.instance;
   }
   function set sessionToken(sToken)
   {
      this._nPort = sToken;
   }
   function get sessionToken()
   {
      return this._nPort;
   }
   static function isEnabled()
   {
      return dofus.ZaapConnect.ENABLED && (_global.CONFIG.zaapConnectPort != undefined && _global.CONFIG.zaapConnectPort > 0);
   }
   function get isDisabledOnError()
   {
      return this._bDisabledOnError;
   }
   function get disabledOnErrorLangKey()
   {
      return this._sDisabledOnErrorLangKey;
   }
   function isDebug()
   {
      return this._bDebug;
   }
   function isConnected()
   {
      return this._bConnected;
   }
   function setConnected(bConnected)
   {
      this._bConnected = bConnected;
   }
   function renewAuthKey()
   {
      if(this.isConnected() && this.sessionToken != undefined)
      {
         this.askAuthToken();
      }
      else
      {
         this.connect();
      }
   }
   function consumeAuthToken()
   {
      var _loc2_ = this._authToken;
      if(_loc2_ == undefined)
      {
         return null;
      }
      delete this._authToken;
      return _loc2_;
   }
   function disconnect()
   {
      this._nPort = "";
      this._authToken = "";
   }
   function disable(sErrorLangKey)
   {
      this.disconnect();
      this.debugLog("Now disabled until client restart");
      this._sDisabledOnErrorLangKey = sErrorLangKey;
      this._bDisabledOnError = true;
      this.refreshUiLogin();
   }
   function refreshUiLogin()
   {
      var _loc2_ = dofus.graphics.gapi.ui.Login(this.api.ui.getUIComponent("Login"));
      if(_loc2_ != undefined)
      {
         _loc2_.refreshAutoLoginUi();
      }
   }
   function debugLog(sMessage)
   {
      if(!this.isDebug() || sMessage == null)
      {
         return undefined;
      }
      sMessage = "[ZaapConnect] " + sMessage;
      this.api.kernel.showMessage(undefined,sMessage,"DEBUG_LOG");
      this.api.electron.log(sMessage);
   }
   function connect()
   {
      this.api.ui.loadUIComponent("Waiting","Waiting",undefined,{bStayIfPresent:true});
      this.debugLog("Connection to zaap V2");
      this.api.electron.zaapConnect();
   }
   function onConnect(sSessionToken, bSuccess)
   {
      this.api.ui.unloadUIComponent("Waiting");
      if(!bSuccess)
      {
         this.debugLog("Could not connect to the launcher");
         this.disable("ERROR_ZAAP_CONNECT_CONNECTION_FAILED");
         return undefined;
      }
      this.sessionToken = sSessionToken;
      this.debugLog("Connected to the zaap V2");
      this.debugLog("New Session Token : " + this.sessionToken);
      this.refreshUiLogin();
      this.askAuthToken();
   }
   function askAuthToken()
   {
      this.debugLog("Authentification to the zaap V2");
      this.api.electron.zaapAksAuthToken(this.sessionToken);
   }
   function onAuthToZaap(sAuthToken)
   {
      this._authToken = sAuthToken;
      this.debugLog("New Auth Token : " + this._authToken);
      this.doAutoLogin();
   }
   function doAutoLogin()
   {
      if(this._authToken == undefined)
      {
         this.debugLog("Invalid auth token");
         this.disable("ERROR_ZAAP_CONNECT_INVALID_AUTH_TOKEN");
         return undefined;
      }
      if(this.api.network.isConnected)
      {
         this.debugLog("Already connected to the login server");
         return undefined;
      }
      var _loc2_ = dofus.graphics.gapi.ui.Login(this.api.ui.getUIComponent("Login"));
      if(_loc2_ == undefined)
      {
         this.debugLog("UI Login not found");
         return undefined;
      }
      if(!_loc2_.isLoaded())
      {
         this.debugLog("UI Login is not fully loaded, can\'t auto login now");
         return undefined;
      }
      this.debugLog("Let\'s login automatically...");
      _loc2_.zaapAutoLogin(true);
   }
}
