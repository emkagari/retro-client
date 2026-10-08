class dofus.aks.Aks extends dofus.utils.ApiElement
{
   var Account;
   var Achievements;
   var Basics;
   var Chat;
   var ChooseReward;
   var Conquest;
   var Deco;
   var Dialog;
   var Documents;
   var Emotes;
   var Enemies;
   var Evenemential;
   var Exchange;
   var Fights;
   var Friends;
   var Game;
   var GameActions;
   var GameServer;
   var Guild;
   var Houses;
   var Infos;
   var InventoryShortcuts;
   var Items;
   var Job;
   var Key;
   var Lag;
   var ModReport;
   var Mount;
   var NameCustomization;
   var Party;
   var Ping;
   var Quests;
   var RapidStuff;
   var SecureForgemagusCraft;
   var Specialization;
   var Spells;
   var Storages;
   var Subareas;
   var Subway;
   var Survey;
   var TemporaryEvent;
   var Temporis;
   var Ttg;
   var Tutorial;
   var Waypoints;
   var _aDisconnectionUrl;
   var _aKeys;
   var _aLastPings;
   var _bAutoReco;
   var _bLag;
   var _isWaitingForData;
   var _nCurrentKey;
   var _nLastWaitingSend;
   var _oDataProcessor;
   var _oLoader;
   var _sDebug;
   var _sDisconnectionParams;
   var _xSocket;
   static var EVALUATE_AVERAGE_PING_ON_COMMANDS = 50;
   var _bConnected = false;
   var _bConnecting = false;
   static var HEX_CHARS = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
   static var CURRENT_IDENTITY_VERSION = 10;
   var bMachineStateSent = false;
   function Aks(oAPI)
   {
      super();
      this.initialize(oAPI);
   }
   function get isConnected()
   {
      return this._bConnected;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this.Basics = new dofus.aks.Basics(this,oAPI);
      this.Evenemential = new dofus.aks.Evenemential(this,oAPI);
      this.Account = new dofus.aks.Account(this,oAPI);
      this.Friends = new dofus.aks.Friends(this,oAPI);
      this.Enemies = new dofus.aks.Enemies(this,oAPI);
      this.Chat = new dofus.aks.Chat(this,oAPI);
      this.Dialog = new dofus.aks.Dialog(this,oAPI);
      this.Exchange = new dofus.aks.Exchange(this,oAPI);
      this.Game = new dofus.aks.Game(this,oAPI);
      this.GameActions = new dofus.aks.GameActions(this,oAPI);
      this.Houses = new dofus.aks.Houses(this,oAPI);
      this.Infos = new dofus.aks.Infos(this,oAPI);
      this.Items = new dofus.aks.Items(this,oAPI);
      this.Job = new dofus.aks.Job(this,oAPI);
      this.Key = new dofus.aks.Key(this,oAPI);
      this.Spells = new dofus.aks.Spells(this,oAPI);
      this.Storages = new dofus.aks.Storages(this,oAPI);
      this.Emotes = new dofus.aks.Emotes(this,oAPI);
      this.Documents = new dofus.aks.Documents(this,oAPI);
      this.Survey = new dofus.aks.Survey(this,oAPI);
      this.Guild = new dofus.aks.Guild(this,oAPI);
      this.Waypoints = new dofus.aks.Waypoints(this,oAPI);
      this.Subareas = new dofus.aks.Subareas(this,oAPI);
      this.Specialization = new dofus.aks.Specialization(this,oAPI);
      this.Fights = new dofus.aks.Fights(this,oAPI);
      this.Tutorial = new dofus.aks.Tutorial(this,oAPI);
      this.Quests = new dofus.aks.Quests(this,oAPI);
      this.RapidStuff = new dofus.aks.RapidStuff(this,oAPI);
      this.Party = new dofus.aks.Party(this,oAPI);
      this.Subway = new dofus.aks.Subway(this,oAPI);
      this.Mount = new dofus.aks.Mount(this,oAPI);
      this.Conquest = new dofus.aks.Conquest(this,oAPI);
      this.ModReport = new dofus.aks.ModReport(this,oAPI);
      this.Ttg = new dofus.aks.Ttg(this,oAPI);
      this.InventoryShortcuts = new dofus.aks.InventoryShortcuts(this,oAPI);
      this.Temporis = new dofus.aks.Temporis(this,oAPI);
      this.ChooseReward = new dofus.aks.ChooseReward(this,oAPI);
      this.SecureForgemagusCraft = new dofus.aks.SecureForgemagusCraft(this,oAPI);
      this.TemporaryEvent = new dofus.aks.TemporaryEvent(this,oAPI);
      this.Achievements = new dofus.aks.Achievements(this,oAPI);
      this.NameCustomization = new dofus.aks.NameCustomization(this,oAPI);
      this.GameServer = new dofus.aks.GameServer(this,oAPI);
      this.Ping = {};
      this.Lag = {};
      this.Deco = {};
      this._bLag = false;
      this._bAutoReco = this.api.lang.getConfigText("AUTO_RECONNECT") == true;
      this._oDataProcessor = new dofus.aks.DataProcessor(this,oAPI);
      this._xSocket = new XMLSocket();
      this._aLastPings = [];
      var aks = this;
      this._xSocket.onClose = function()
      {
         aks.onClose();
         aks.resetKeys();
      };
      this._xSocket.onConnect = function(bSuccess)
      {
         aks.onConnect(bSuccess);
      };
      this._xSocket.onData = function(sData)
      {
         aks.onData(sData);
      };
      this._oLoader = new LoadVars();
      this._oLoader.onLoad = function(success)
      {
         aks.onLoad(success);
      };
   }
   function connect(sHost, nPort, bSaveHost)
   {
      org.flashdevelop.utils.FlashConnect.trace("connect " + sHost + ":" + nPort,"dofus.aks.Aks::connect","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",196);
      if(bSaveHost == undefined)
      {
         bSaveHost = true;
      }
      if(this._bConnected)
      {
         return null;
      }
      if(this._bConnecting)
      {
         return null;
      }
      this.api.ui.loadUIComponent("Waiting","Waiting",undefined,{bStayIfPresent:true});
      if(sHost == undefined)
      {
         sHost = this.api.datacenter.Basics.serverHost;
      }
      else if(bSaveHost)
      {
         this.api.datacenter.Basics.serverHost = sHost;
      }
      if(nPort == undefined)
      {
         nPort = this.api.datacenter.Basics.serverPort;
      }
      else if(bSaveHost)
      {
         this.api.datacenter.Basics.serverPort = nPort;
      }
      this._bConnecting = true;
      this._aLastPings = [];
      var _loc5_ = this._xSocket.connect(sHost,nPort);
      return _loc5_;
   }
   function softDisconnect()
   {
      if(this._bConnected)
      {
         this._xSocket.close();
      }
      var _loc2_ = dofus.graphics.gapi.ui.Login(this.api.ui.getUIComponent("Login"));
      if(_loc2_ != undefined)
      {
         _loc2_.reenableZaapConnectButton();
      }
      this.api.electron.updateWindowTitle();
      this.api.electron.setLoginDiscordActivity();
      this.resetKeys();
      this._bConnected = false;
   }
   function disconnect(bReconnect, bShowMessage, bRecoTempo)
   {
      this.softDisconnect();
      if(!bRecoTempo)
      {
         this.onClose(bReconnect,bShowMessage,true);
      }
      else
      {
         ank.utils.Timer.setTimer(this.Deco,"disconnect",this,this.onClose,1000,[bReconnect,bShowMessage,true]);
      }
   }
   function send(sData, bWaiting, sWaitingMessage, bNoLimit, bNoCyphering)
   {
      if(sData == undefined || sData.length == 0)
      {
         return undefined;
      }
      if(bNoLimit != true && sData.length > dofus.Constants.MAX_MESSAGE_LENGTH)
      {
         sData = sData.substring(0,dofus.Constants.MAX_MESSAGE_LENGTH - 1);
      }
      this.api.kernel.GameManager.signalActivity();
      if(bWaiting || bWaiting == undefined)
      {
         if(sWaitingMessage != undefined)
         {
            this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:sWaitingMessage},{bAlwaysOnTop:true,bForceLoad:true});
         }
         this._sDebug = sData;
         this.api.ui.loadUIComponent("Waiting","Waiting");
         this._isWaitingForData = true;
         if(this.api.datacenter.Basics.inGame && this._bAutoReco)
         {
            ank.utils.Timer.setTimer(this.Lag,"lag",this,this.onLag,Number(this.api.lang.getConfigText("DELAY_RECO_MESSAGE")));
         }
      }
      this.api.electron.onPacketSent(sData);
      if(this.api.datacenter.Basics.inGame)
      {
         sData = this.api.electron.applyPacketToSendPostProcessing(sData);
      }
      if(dofus.Constants.DEBUG_DATAS)
      {
         this.api.electron.debugRequest(true,sData);
      }
      if(!bNoCyphering)
      {
         sData = this.prepareData(sData);
      }
      if(sData.charAt(sData.length - 1) != "\n")
      {
         sData += "\n";
      }
      this._xSocket.send(sData);
      if(bWaiting || bWaiting == undefined)
      {
         this._nLastWaitingSend = getTimer();
      }
      if(dofus.Constants.DEBUG_DATAS && dofus.Constants.DEBUG_ENCRYPTION)
      {
         org.flashdevelop.utils.FlashConnect.trace("SND (C) " + sData,com.ankamagames.tools.Logger.LEVEL_NETWORK,"dofus.aks.Aks::send","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",324);
      }
   }
   function processCommand(sCmd)
   {
      this._oDataProcessor.process(sCmd);
   }
   function startUsingKey(nKeyID)
   {
      this._nCurrentKey = nKeyID;
   }
   function resetKeys()
   {
      this._nCurrentKey = 0;
      this._aKeys = [];
   }
   function unprepareData(s)
   {
      if(this._nCurrentKey == 0 || (this._nCurrentKey == undefined || _global.isNaN(this._nCurrentKey)))
      {
         return s;
      }
      var _loc3_ = this._aKeys[_global.parseInt(s.substr(0,1),16)];
      if(_loc3_ == undefined)
      {
         org.flashdevelop.utils.FlashConnect.trace("[?!!] Le serveur a demandé une clé que je n\'ai pas...","dofus.aks.Aks::unprepareData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",359);
         return s;
      }
      var _loc4_ = s.substr(1,1).toUpperCase();
      var _loc5_ = dofus.aks.Aks.decypherData(s.substr(2),_loc3_,_global.parseInt(_loc4_,16) * 2);
      if(dofus.aks.Aks.checksum(_loc5_) != _loc4_)
      {
         org.flashdevelop.utils.FlashConnect.trace("[?!!] Checksum invalide! (Reçu : " + s.substr(1,1) + ", Calculé : " + dofus.aks.Aks.checksum(_loc5_) + ")","dofus.aks.Aks::unprepareData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",372);
         org.flashdevelop.utils.FlashConnect.trace("[?!!] Données interpretées : " + _loc5_,"dofus.aks.Aks::unprepareData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",373);
         return s;
      }
      return _loc5_;
   }
   function prepareData(s)
   {
      if(this._nCurrentKey == 0 || (this._nCurrentKey == undefined || _global.isNaN(this._nCurrentKey)))
      {
         return s;
      }
      if(this._aKeys[this._nCurrentKey] == undefined)
      {
         org.flashdevelop.utils.FlashConnect.trace("[?!!] La clé " + this._nCurrentKey + " définie en clé actuelle n\'existe pas dans le buffer...","dofus.aks.Aks::prepareData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",389);
         return s;
      }
      var _loc3_ = dofus.aks.Aks.HEX_CHARS[this._nCurrentKey];
      var _loc4_ = dofus.aks.Aks.checksum(s);
      _loc3_ += _loc4_;
      return _loc3_ + dofus.aks.Aks.cypherData(s,this._aKeys[this._nCurrentKey],_global.parseInt(_loc4_,16) * 2);
   }
   static function prepareKey(d)
   {
      var _loc3_ = new String();
      var _loc4_ = 0;
      while(_loc4_ < d.length)
      {
         _loc3_ += String.fromCharCode(_global.parseInt(d.substr(_loc4_,2),16));
         _loc4_ += 2;
      }
      _loc3_ = _global.unescape(_loc3_);
      return _loc3_;
   }
   static function checksum(s)
   {
      var _loc3_ = 0;
      var _loc4_ = 0;
      while(_loc4_ < s.length)
      {
         _loc3_ += s.charCodeAt(_loc4_) % 16;
         _loc4_ = _loc4_ + 1;
      }
      return dofus.aks.Aks.HEX_CHARS[_loc3_ % 16];
   }
   static function d2h(d)
   {
      if(d > 255)
      {
         d = 255;
      }
      return dofus.aks.Aks.HEX_CHARS[Math.floor(d / 16)] + dofus.aks.Aks.HEX_CHARS[d % 16];
   }
   static function preEscape(s)
   {
      var _loc3_ = new String();
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      while(_loc4_ < s.length)
      {
         _loc5_ = s.charAt(_loc4_);
         _loc6_ = s.charCodeAt(_loc4_);
         if(_loc6_ < 32 || (_loc6_ > 127 || (_loc5_ == "%" || _loc5_ == "+")))
         {
            _loc3_ += _global.escape(_loc5_);
         }
         else
         {
            _loc3_ += _loc5_;
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   static function cypherData(d, k, c)
   {
      var _loc5_ = new String();
      var _loc6_ = k.length;
      d = dofus.aks.Aks.preEscape(d);
      var _loc7_ = 0;
      while(_loc7_ < d.length)
      {
         _loc5_ += dofus.aks.Aks.d2h(d.charCodeAt(_loc7_) ^ k.charCodeAt((_loc7_ + c) % _loc6_));
         _loc7_ = _loc7_ + 1;
      }
      return _loc5_;
   }
   static function decypherData(d, k, c)
   {
      var _loc5_ = new String();
      var _loc6_ = k.length;
      var _loc7_ = 0;
      var _loc8_ = 0;
      var _loc9_ = 0;
      while(_loc9_ < d.length)
      {
         _loc5_ += String.fromCharCode(_global.parseInt(d.substr(_loc9_,2),16) ^ k.charCodeAt((_loc7_++ + c) % _loc6_));
         _loc9_ += 2;
      }
      _loc5_ = _global.unescape(_loc5_);
      return _loc5_;
   }
   function addKeyToCollection(nKeyID, sKey)
   {
      if(this._aKeys == undefined)
      {
         this._aKeys = [];
      }
      this._aKeys[nKeyID] = dofus.aks.Aks.prepareKey(sKey);
   }
   function ping()
   {
      this.api.datacenter.Basics.lastPingTimer = getTimer();
      this.send("ping");
   }
   function quickPing()
   {
      this.send("qping");
   }
   function getAveragePing()
   {
      var _loc2_ = 0;
      var _loc3_ = 0;
      while(_loc3_ < this._aLastPings.length)
      {
         _loc2_ += this._aLastPings[_loc3_];
         _loc3_ = _loc3_ + 1;
      }
      return Math.round(_loc2_ / this._aLastPings.length);
   }
   function getAveragePingPacketsCount()
   {
      return this._aLastPings.length;
   }
   function getAveragePingBufferSize()
   {
      return dofus.aks.Aks.EVALUATE_AVERAGE_PING_ON_COMMANDS;
   }
   function getRandomNetworkKey()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this.api.electron.enabled)
      {
         _loc2_ = this.api.electron.getRandomNetworkKey();
      }
      else
      {
         _loc2_ = "";
         _loc3_ = Math.round(Math.random() * 128) + 128;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ += this.getRandomChar();
            _loc4_ = _loc4_ + 1;
         }
      }
      var _loc5_ = dofus.aks.Aks.checksum(_loc2_) + _loc2_;
      return _loc5_ + dofus.aks.Aks.checksum(_loc5_);
   }
   function isValidNetworkKey(sKey, nIdentityVersion)
   {
      if(nIdentityVersion == undefined || nIdentityVersion != dofus.aks.Aks.CURRENT_IDENTITY_VERSION)
      {
         return false;
      }
      if(sKey == undefined || (sKey.length == 0 || (sKey == "" || (dofus.aks.Aks.checksum(sKey.substr(0,sKey.length - 1)) != sKey.substr(sKey.length - 1) || dofus.aks.Aks.checksum(sKey.substr(1,sKey.length - 2)) != sKey.substr(0,1)))))
      {
         return false;
      }
      return true;
   }
   function defaultProcessAction(sType, sAction, bError, sData)
   {
      this.api.network.send(String(sData.substr(0,2) + dofus.aks.Aks.EVALUATE_AVERAGE_PING_ON_COMMANDS),false);
   }
   function getRandomChar()
   {
      var _loc2_ = Math.ceil(Math.random() * 100);
      if(_loc2_ <= 40)
      {
         return String.fromCharCode(Math.floor(Math.random() * 26) + 65);
      }
      if(_loc2_ <= 80)
      {
         return String.fromCharCode(Math.floor(Math.random() * 26) + 97);
      }
      return String.fromCharCode(Math.floor(Math.random() * 10) + 48);
   }
   function onLag()
   {
      this._bLag = true;
      this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("WAIT_FOR_SERVER")},{bAlwaysOnTop:true,bForceLoad:true});
      if(this._bAutoReco)
      {
         ank.utils.Timer.setTimer(this.Deco,"deco",this,this.onDeco,Number(this.api.lang.getConfigText("DELAY_RECO_START")));
      }
   }
   function onDeco()
   {
      if(this._bConnected)
      {
         this.resetKeys();
         this._xSocket.close();
         this._bConnected = false;
      }
      this.onClose(true,false,false);
   }
   function onConnect(bSuccess)
   {
      this._bConnecting = false;
      var _loc3_;
      if(!bSuccess)
      {
         if(this.api.datacenter.Basics.aks_rescue_count > 0)
         {
            this.api.datacenter.Basics.aks_rescue_count--;
            ank.utils.Timer.setTimer(this,"connect",this,this.connect,_global.CONFIG.rdelay,[this.api.datacenter.Basics.aks_gameserver_ip,this.api.datacenter.Basics.aks_gameserver_port,false]);
            this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("TRYING_TO_RECONNECT",[this.api.datacenter.Basics.aks_rescue_count])},{bAlwaysOnTop:true,bForceLoad:true});
            return undefined;
         }
         if(this.api.datacenter.Basics.aks_rescue_count == 0)
         {
            this.onClose(false,true);
            return undefined;
         }
         if(this.api.ui.getUIComponent("Login") && (this.api.datacenter.Basics.aks_connection_server && this.api.datacenter.Basics.aks_connection_server.length))
         {
            _loc3_ = String(this.api.datacenter.Basics.aks_connection_server.shift());
            ank.utils.Timer.setTimer(this,"connect",this,this.connect,_global.CONFIG.rdelay,[_loc3_,this.api.datacenter.Basics.aks_connection_server_port,false]);
            return undefined;
         }
         this.api.ui.unloadUIComponent("Waiting");
         this.api.ui.unloadUIComponent("WaitingMessage");
         this.api.ui.unloadUIComponent("ChooseCharacter");
         this.api.kernel.manualLogon();
         this.api.kernel.showMessage(this.api.lang.getText("CONNECTION"),this.api.lang.getText("CANT_CONNECT"),"ERROR_BOX",{name:"OnConnect"});
         this.softDisconnect();
      }
      else
      {
         this.api.ui.unloadUIComponent("Waiting");
         this.api.ui.unloadUIComponent("WaitingMessage");
         if(!this.api.datacenter.Basics.isLogged)
         {
            this.api.ui.loadUIComponent("MainMenu","MainMenu",{quitMode:(!(System.capabilities.playerType == "PlugIn" && !this.api.electron.enabled) ? "quit" : "no")},{bStayIfPresent:true,bAlwaysOnTop:true});
         }
         this._bConnected = true;
      }
   }
   function onData(sData)
   {
      ank.utils.Timer.removeTimer(this.Lag,"lag");
      if(this._bLag)
      {
         dofus.utils.Api.getInstance().ui.unloadUIComponent("WaitingMessage");
         ank.utils.Timer.removeTimer(this.Deco,"deco");
         this._bLag = false;
      }
      if(dofus.Constants.DEBUG_DATAS && dofus.Constants.DEBUG_ENCRYPTION)
      {
         org.flashdevelop.utils.FlashConnect.trace("RCV (C) " + sData,com.ankamagames.tools.Logger.LEVEL_NETWORK,"dofus.aks.Aks::onData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",689);
      }
      sData = this.unprepareData(sData);
      this.api.electron.onPacketReceived(sData);
      if(dofus.Constants.DEBUG_DATAS)
      {
         this.api.electron.debugRequest(false,sData);
      }
      var _loc3_;
      if(this._isWaitingForData)
      {
         this._isWaitingForData = false;
         this.api.ui.unloadUIComponent("Waiting");
         _loc3_ = getTimer() - this._nLastWaitingSend;
         if(_loc3_ > 100)
         {
            org.flashdevelop.utils.FlashConnect.trace("[Aks] (onData) " + this._sDebug + " (since " + _loc3_ + "ms)","dofus.aks.Aks::onData","C:\\Dev\\Projects\\client\\src\\core\\classes/dofus/aks/Aks.as",706);
         }
         this._aLastPings.push(_loc3_);
         if(this._aLastPings.length > dofus.aks.Aks.EVALUATE_AVERAGE_PING_ON_COMMANDS)
         {
            this._aLastPings.shift();
         }
      }
      this._oDataProcessor.process(sData);
   }
   function onLoad(success)
   {
      if(!success)
      {
         this.sendNextDisconnectionState();
      }
   }
   function sendNextDisconnectionState()
   {
      if(this._aDisconnectionUrl.length <= 0)
      {
         return undefined;
      }
      var _loc2_ = this._aDisconnectionUrl.shift() + this._sDisconnectionParams;
      this._oLoader.load(_loc2_);
   }
   function onClose(bReconnect, bShowMessage, bManual)
   {
      if(bManual == undefined)
      {
         bManual = false;
      }
      if(!bManual && (this.api.datacenter.Basics.aks_current_server != undefined && (!this.api.datacenter.Basics.aks_server_will_disconnect && this.api.lang.getConfigText("FORWARD_UNWANTED_DISCONNECTION"))))
      {
         this._aDisconnectionUrl = String(this.api.lang.getConfigText("FORWARD_UNWANTED_DISCONNECTION_URL")).split("|");
         this._sDisconnectionParams = new String();
         this._sDisconnectionParams += "?serverid=" + this.api.datacenter.Basics.aks_current_server;
         this._sDisconnectionParams += "&serverip=" + this.api.datacenter.Basics.aks_gameserver_ip;
         this._sDisconnectionParams += "&serverport=" + this.api.datacenter.Basics.aks_gameserver_port;
         this._sDisconnectionParams += "&login=" + this.api.datacenter.Basics.login;
         this.sendNextDisconnectionState();
      }
      this._bConnecting = false;
      this._bConnected = false;
      ank.battlefield.SpriteHandler.resetStaticVars();
      this.bMachineStateSent = false;
      this.api.gfx._visible = true;
      if(this.api.datacenter.Basics.aks_current_server != undefined && (this.api.datacenter.Basics.aks_rescue_count == -1 && (!bManual && (this.api.lang.getConfigText("AUTO_RECONNECT") && !this.api.datacenter.Basics.aks_server_will_disconnect))))
      {
         ank.utils.Timer.removeTimer(this.Deco,"deco");
         this.api.datacenter.Basics.aks_rescue_count = _global.CONFIG.rcount;
         ank.utils.Timer.setTimer(this,"connect",this,this.connect,_global.CONFIG.rdelay,[this.api.datacenter.Basics.aks_gameserver_ip,this.api.datacenter.Basics.aks_gameserver_port,false]);
         this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("TRYING_TO_RECONNECT",[this.api.datacenter.Basics.aks_rescue_count])},{bAlwaysOnTop:true,bForceLoad:true});
         return undefined;
      }
      if(bReconnect == undefined)
      {
         bReconnect = false;
      }
      if(bShowMessage == undefined)
      {
         bShowMessage = !this.api.datacenter.Basics.aks_server_will_disconnect;
      }
      if(!bReconnect && dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST != undefined)
      {
         this.api.kernel.onFastServerSwitchFail();
      }
      if(this.api.datacenter.Basics.isLogged)
      {
         this.api.kernel.GameManager.zoomGfxRoot(100);
         this.api.ui.clear();
         if(this.api.ui.getUIComponent("Zoom") == undefined)
         {
            this.api.ui.loadUIComponent("Zoom","Zoom");
         }
         this.api.gfx.clear();
         this.api.kernel.TutorialManager.clear();
         ank.utils.Timer.clear();
      }
      else
      {
         this.api.ui.unloadUIComponent("CenterText");
         this.api.ui.unloadUIComponent("ChooseNickName");
      }
      this.api.sounds.stopAllSounds();
      if(bReconnect)
      {
         if(this.api.datacenter.Player.zaapToken != undefined && this.api.datacenter.Basics.characterSwitchTicket == undefined)
         {
            this.api.ui.setScreenSize(742,550);
            this.api.kernel.autoLogon();
         }
         else
         {
            this.connect();
         }
      }
      else if(this.api.datacenter.Basics.isLogged)
      {
         this.api.ui.setScreenSize(742,550);
         this.api.kernel.manualLogon();
         this.api.kernel.ChatManager.clear();
      }
      var _loc5_;
      var _loc6_;
      if(bShowMessage)
      {
         _loc5_ = this.api.lang.getText("DISCONNECT");
         if(this.api.datacenter.Basics.serverMessageID != -1)
         {
            _loc5_ += "\n\n" + this.api.lang.getText("SRV_MSG_" + this.api.datacenter.Basics.serverMessageID,this.api.datacenter.Basics.serverMessageParams);
            this.api.kernel.showMessage(this.api.lang.getText("CONNECTION"),_loc5_,"ERROR_BOX",{name:"OnClose"});
         }
         else if(this.api.lang.getConfigText("SIMPLE_AUTO_RECONNECT"))
         {
            _loc5_ += "\n\n" + this.api.lang.getText("ATTEMPT_RECONNECT");
            _loc6_ = {name:"OnClose",listener:this,params:{login:this.api.datacenter.Player.login,pass:this.api.datacenter.Player.password}};
            this.api.kernel.showMessage(this.api.lang.getText("CONNECTION"),_loc5_,"CAUTION_YESNO",_loc6_);
         }
         else
         {
            this.api.kernel.showMessage(this.api.lang.getText("CONNECTION"),_loc5_,"ERROR_BOX",{name:"OnClose"});
         }
      }
      this.api.datacenter.clear();
   }
   function onHelloConnectionServer(sKey)
   {
      this.api.datacenter.Basics.connexionKey = sKey;
      var _loc3_ = this.api.datacenter.Basics.characterSwitchTicket != undefined;
      var _loc4_;
      var _loc5_;
      if(_loc3_)
      {
         this.Account.logOnWithCharacterSwitchTicket(this.api.datacenter.Basics.characterSwitchTicket);
         delete this.api.datacenter.Basics.characterSwitchTicket;
      }
      else
      {
         _loc4_ = this.api.datacenter.Player.zaapToken != null;
         _loc5_ = !_loc4_ ? this.api.datacenter.Player.password : this.api.datacenter.Player.zaapToken;
         this.Account.logon(this.api.datacenter.Player.login,_loc5_,_loc4_);
      }
      this.api.network.Account.getQueuePosition();
   }
   function onHelloGameServer(sExtraData)
   {
      this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("CONNECTING")},{bAlwaysOnTop:true,bForceLoad:true});
      if(this.api.datacenter.Basics.aks_rescue_count == -1)
      {
         this.Account.sendTicket(this.api.datacenter.Basics.aks_ticket);
      }
      else
      {
         this.Account.rescue(this.api.datacenter.Basics.aks_ticket);
      }
      this.api.datacenter.Basics.aks_rescue_count = -1;
   }
   function onTelemetry(sExtraData, bYolo)
   {
      var _loc4_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      if(!this.api.electron.enabled || bYolo)
      {
         _loc4_ = "";
         _loc10_ = "Tu_ne_le_sais_pas_encore,_mais_tu_es_déjà_mort_(°~°)";
         _loc10_ += this.api.datacenter.Basics.aks_ticket;
         _loc11_ = 0;
         _loc12_ = 0;
         while(_loc12_ < sExtraData.length)
         {
            _loc11_ += sExtraData.charCodeAt(_loc12_);
            _loc12_ = _loc12_ + 1;
         }
         _loc10_ += String(_loc11_);
         _loc13_ = 0;
         while(_loc13_ < _loc10_.length)
         {
            _loc14_ = String.fromCharCode(_loc10_.charCodeAt(_loc13_) + 42 - 43 + 1 - 42 + 42 - 2 + 1);
            if(_loc14_ != undefined)
            {
               _loc4_ += _loc14_;
            }
            _loc13_ = _loc13_ + 1;
         }
         this.send("HT" + _loc4_);
      }
      else
      {
         this.api.electron.getTelemetry(sExtraData);
      }
   }
   function onCharacterSwitchTicket(sExtraData)
   {
      this.api.datacenter.Basics.characterSwitchTicket = sExtraData;
      this.disconnect(true,false,true);
   }
   function askCharacterSwitchTicket()
   {
      this.send("HS");
   }
   function onPong()
   {
      var _loc2_ = getTimer() - this.api.datacenter.Basics.lastPingTimer;
      this.api.kernel.showMessage(undefined,"Ping : " + _loc2_ + "ms",this.api.ui.getUIComponent("Debug") != undefined ? "DEBUG_LOG" : "INFO_CHAT");
   }
   function onQuickPong()
   {
   }
   function onServerMessage(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0);
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      switch(_loc3_)
      {
         case "0":
            _loc4_ = sExtraData.substr(1).split("|");
            _loc5_ = Number(_loc4_[0]);
            _loc6_ = _loc4_[1].split(";");
            this.api.datacenter.Basics.serverMessageID = _loc5_;
            this.api.datacenter.Basics.serverMessageParams = _loc6_;
            break;
         case "1":
            _loc7_ = sExtraData.substr(1).split("|");
            _loc8_ = _loc7_[0];
            _loc9_ = _loc7_[1].split(";");
            _loc10_ = String(_loc7_[2]).length <= 0 ? undefined : _loc7_[2];
            switch(Number(_loc8_))
            {
               case 23:
                  _loc11_ = Number(_loc9_[0]);
                  _loc9_[0] = this.api.lang.getSpellText(_loc11_).n;
                  break;
               case 12:
                  this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_12"),"ERROR_CHAT");
                  this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_12") + "\n\n" + this.api.lang.getText("DO_U_RELEASE_NOW"),"CAUTION_YESNO",{name:_loc10_,listener:this});
                  return undefined;
            }
            this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_" + _loc8_,_loc9_),"ERROR_BOX",{name:_loc10_});
         default:
            return;
      }
   }
   function onBadVersion()
   {
      this.api.kernel.quit(false);
   }
   function onServerWillDisconnect()
   {
      this.api.datacenter.Basics.aks_server_will_disconnect = true;
   }
   function yes(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent.target._name) !== "AskYesNoOnClose")
      {
         this.api.network.Game.freeMySoul();
      }
      else
      {
         _loc3_ = dofus.graphics.gapi.ui.Login(this.api.ui.getUIComponent("Login"));
         if(_loc3_ != undefined)
         {
            _loc4_ = oEvent.params.login;
            if(_loc4_ == dofus.aks.Account.ACTION_LOGIN_WITH_ZAAP_TOKEN)
            {
               _loc3_.zaapAutoLogin(false);
            }
            else
            {
               _loc5_ = oEvent.params.pass;
               _loc3_.autoLogin(_loc4_,_loc5_);
            }
         }
      }
   }
}
