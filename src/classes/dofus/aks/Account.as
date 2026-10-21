class dofus.aks.Account extends dofus.aks.Handler
{
   var WaitQueueTimer;
   var aks;
   var api;
   static var ACTION_LOGIN_WITH_ZAAP_TOKEN = "#Z";
   static var ACTION_LOGIN_WITH_CHARACTER_SWITCH_TICKET = "#S";
   function Account(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
      this.WaitQueueTimer = {};
   }
   function logon(sLogin, sPassword, bZaapConnect, bCharacterSwitch)
   {
      if(this.api.datacenter.Basics.connexionKey == undefined)
      {
         this.onLogin(false,"n");
         return undefined;
      }
      if(sLogin == undefined)
      {
         sLogin = this.api.datacenter.Basics.login;
      }
      else
      {
         this.api.datacenter.Basics.login = sLogin;
      }
      if(sPassword == undefined)
      {
         sPassword = this.api.datacenter.Basics.password;
      }
      else
      {
         this.api.datacenter.Basics.password = sPassword;
      }
      var _loc6_ = dofus.Constants.VERSION + "." + dofus.Constants.SUBVERSION + "." + dofus.Constants.SUBSUBVERSION + (dofus.Constants.BETAVERSION <= 0 ? "" : "." + dofus.Constants.BETAVERSION) + (!this.api.electron.enabled ? "" : "e") + (!this.api.config.isStreaming ? "" : "s");
      var _loc7_ = _loc6_;
      _loc7_ += "|" + this.api.config.language;
      this.aks.send(_loc7_,true,this.api.lang.getText("CONNECTING"));
      var _loc8_;
      var _loc9_;
      if(bCharacterSwitch)
      {
         this.aks.send(sLogin + "\n" + sPassword);
      }
      else if(bZaapConnect)
      {
         this.aks.send(sLogin + "\n" + sPassword);
      }
      else if(this.api.lang.getConfigText("CRYPTO_METHOD") == 2)
      {
         _loc8_ = new ank.utils.Md5();
         _loc9_ = "#2" + _loc8_.hex_md5(_loc8_.hex_md5(sPassword) + this.api.datacenter.Basics.connexionKey);
         this.aks.send(sLogin + "\n" + _loc9_);
      }
      else
      {
         this.aks.send(sLogin + "\n" + ank.utils.Crypt.cryptPassword(sPassword,this.api.datacenter.Basics.connexionKey));
      }
   }
   function logOnWithCharacterSwitchTicket(sCharacterSwitchTicket)
   {
      var _loc3_ = dofus.aks.Account.ACTION_LOGIN_WITH_CHARACTER_SWITCH_TICKET;
      this.api.datacenter.Basics.login = _loc3_;
      var _loc4_ = dofus.Constants.VERSION + "." + dofus.Constants.SUBVERSION + "." + dofus.Constants.SUBSUBVERSION + (dofus.Constants.BETAVERSION <= 0 ? "" : "." + dofus.Constants.BETAVERSION) + (!this.api.electron.enabled ? "" : "e") + (!this.api.config.isStreaming ? "" : "s");
      var _loc5_ = _loc4_;
      _loc5_ += "|" + this.api.config.language;
      this.aks.send(_loc5_,true,this.api.lang.getText("CONNECTING"));
      this.aks.send(_loc3_ + "\n" + sCharacterSwitchTicket);
   }
   function setNickName(sNickName)
   {
      this.aks.send(sNickName,true,this.api.lang.getText("WAITING_MSG_LOADING"));
   }
   function getCharacters()
   {
      this.aks.send("AL",true,this.api.lang.getText("CONNECTING"));
   }
   function getCharactersForced()
   {
      this.aks.send("ALf",true,this.api.lang.getText("CONNECTING"));
   }
   function getServersList()
   {
      this.aks.send("Ax",true,this.api.lang.getText("WAITING_MSG_LOADING"));
   }
   function setServer(nServerID)
   {
      if(nServerID == undefined)
      {
         return undefined;
      }
      this.api.datacenter.Basics.aks_incoming_server_id = nServerID;
      this.aks.send("AX" + nServerID,true,this.api.lang.getText("WAITING_MSG_LOADING"));
   }
   function searchForFriend(sNick)
   {
      this.aks.send("AF" + sNick);
   }
   function setCharacter(sCharacID)
   {
      this.aks.send("AS" + sCharacID,true,this.api.lang.getText("WAITING_MSG_LOADING"));
      this.api.ui.unloadUIComponent("ChooseCharacter");
      this.getQueuePosition();
   }
   function editCharacterName(sName)
   {
      this.aks.send("AEn" + sName,true);
   }
   function editCharacterColors(nColor1, nColor2, nColor3)
   {
      this.aks.send("AEc" + nColor1 + "|" + nColor2 + "|" + nColor3,true);
   }
   function addCharacter(sName, nClass, nColor1, nColor2, nColor3, nSex)
   {
      this.aks.send("AA" + sName + "|" + nClass + "|" + nSex + "|" + nColor1 + "|" + nColor2 + "|" + nColor3,true,this.api.lang.getText("WAITING_MSG_RECORDING"));
   }
   function deleteCharacter(nCharacID, sSecretAnswer)
   {
      if(nCharacID == undefined)
      {
         return undefined;
      }
      if(sSecretAnswer == undefined)
      {
         sSecretAnswer = "";
      }
      var _loc4_ = new ank.utils.ExtendedString(_global.escape(sSecretAnswer));
      this.aks.send("AD" + nCharacID + "|" + _loc4_.replace(["|","\r","\n",String.fromCharCode(0)],["","","",""]),true,this.api.lang.getText("WAITING_MSG_DELETING"));
   }
   function resetCharacter(nCharacID)
   {
      this.aks.send("AR" + nCharacID);
   }
   function boost(nBonusID, nQuantity)
   {
      this.aks.send("AB" + nBonusID + "|" + nQuantity);
   }
   function sendTicket(sTicket)
   {
      this.aks.send("AT" + sTicket);
   }
   function rescue(sTicket)
   {
      var _loc3_ = "";
      if(this.api.datacenter.Game.isFight)
      {
         _loc3_ = !this.api.datacenter.Game.isRunning ? "|0" : "|1";
      }
      this.aks.send("Ar" + sTicket + _loc3_);
   }
   function getGifts()
   {
      this.aks.send("Ag" + this.api.config.language);
   }
   function attributeGiftToCharacter(nGiftID, nCharacterID)
   {
      this.aks.send("AG" + nGiftID + "|" + nCharacterID);
   }
   function getQueuePosition()
   {
      this.aks.send("Af",false);
      ank.utils.Timer.setTimer(this.WaitQueueTimer,"WaitQueue",this,this.getQueuePosition,Number(this.api.lang.getConfigText("DELAY_WAIT_QUEUE_REFRESH")));
   }
   function getRandomCharacterName()
   {
      this.aks.send("AP",false);
   }
   function useKey(nKeyID)
   {
      this.aks.send("Ak" + dofus.aks.Aks.HEX_CHARS[nKeyID],false);
   }
   function requestRegionalVersion()
   {
      this.aks.send("AV",true,this.api.lang.getText("WAITING_MSG_LOADING"));
   }
   function sendConfiguredPort()
   {
      this.aks.send("Ap" + this.api.datacenter.Basics.aks_connection_server_port,false);
   }
   function sendIdentity()
   {
      var _loc2_;
      var _loc3_;
      var _loc4_;
      if(this.api.electron.enabled)
      {
         _loc2_ = this.api.network.getRandomNetworkKey();
      }
      else
      {
         dofus.managers.UIdManager.getInstance().update();
         _loc3_ = ank.utils.SharedObjectFix.getLocal(dofus.Constants.GLOBAL_SO_IDENTITY_NAME);
         _loc4_ = _loc3_.data.identityVersion;
         _loc2_ = _loc3_.data.identity;
         if(!this.api.network.isValidNetworkKey(_loc2_,_loc4_))
         {
            _loc4_ = dofus.aks.Aks.CURRENT_IDENTITY_VERSION;
            _loc2_ = this.api.network.getRandomNetworkKey();
            _loc3_.data.identityVersion = _loc4_;
            _loc3_.data.identity = _loc2_;
            _loc3_.flush();
         }
         _loc3_.close();
      }
      if(this.api.datacenter.Basics.aks_identity != _loc2_)
      {
         this.api.datacenter.Basics.aks_identity = _loc2_;
      }
      this.aks.send("Ai" + this.api.datacenter.Basics.aks_identity,false,undefined,true);
   }
   function validCharacterMigration(nCharacterID, sName)
   {
      this.aks.send("AM" + nCharacterID + ";" + sName,false);
   }
   function deleteCharacterMigration(nCharacterID)
   {
      this.aks.send("AM-" + nCharacterID,false);
   }
   function askCharacterMigration(nCharacterID, sName)
   {
      this.aks.send("AM?" + nCharacterID + ";" + sName,false);
   }
   function lockCharacterXp(bLock)
   {
      this.aks.send("Au" + (!bLock ? "0" : "1"),false);
   }
   function askResetDemoMode()
   {
      this.aks.send("An",false);
   }
   function onRegionalVersion(sExtraData)
   {
      var _loc3_ = this.api.lang.getConfigText("MAXIMUM_ALLOWED_VERSION");
      var _loc4_ = Number(sExtraData);
      var _loc5_;
      if(_loc3_ > 0)
      {
         if((_loc4_ <= 0 || _loc4_ > _loc3_) && !this.api.datacenter.Player.isAuthorized)
         {
            _loc5_ = {name:"SwitchToEnglish",listener:this};
            this.api.kernel.showMessage(undefined,this.api.lang.getText("SWITCH_TO_ENGLISH"),"CAUTION_YESNO",_loc5_);
            return undefined;
         }
      }
      this.api.datacenter.Basics.aks_current_regional_version = !(_loc4_ > 0 && !_global.isNaN(_loc4_)) ? Number.MAX_VALUE : _loc4_;
      this.getGifts();
      this.getCharacters();
      this.api.network.Account.getQueuePosition();
   }
   function onCharacterDelete(bSuccess, sExtraData)
   {
      if(!bSuccess)
      {
         this.api.ui.unloadUIComponent("WaitingMessage");
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CHARACTER_DELETION_FAILED"),"ERROR_BOX");
      }
   }
   function onSecretQuestion(sExtraData)
   {
      this.api.datacenter.Basics.aks_secret_question = sExtraData;
   }
   function onKey(sExtraData)
   {
      var _loc3_ = _global.parseInt(sExtraData.substr(0,1),16);
      var _loc4_ = sExtraData.substr(1);
      this.aks.addKeyToCollection(_loc3_,_loc4_);
      this.useKey(_loc3_);
      this.aks.startUsingKey(_loc3_);
   }
   function onDofusPseudo(sExtraData)
   {
      this.api.datacenter.Basics.dofusPseudo = sExtraData;
   }
   function onCommunity(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      if(_loc3_ >= 0)
      {
         this.api.datacenter.Basics.communityId = _loc3_;
      }
   }
   function onLogin(bSuccess, sExtraData)
   {
      ank.utils.Timer.removeTimer(this.WaitQueueTimer,"WaitQueue");
      this.api.ui.unloadUIComponent("CenterText");
      this.api.ui.unloadUIComponent("WaitingMessage");
      this.api.ui.unloadUIComponent("WaitingQueue");
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc8_;
      var _loc7_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      if(bSuccess)
      {
         this.api.datacenter.Basics.isLogged = true;
         this.api.ui.unloadUIComponent("Login");
         this.api.ui.unloadUIComponent("ChooseNickName");
         _loc4_ = sExtraData == "1";
         this.api.datacenter.Player.isAuthorized = _loc4_;
         this.api.electron.setWidescreenPanelId(!_loc4_ ? dofus.Electron.WIDESCREEN_PANEL_CHAT : dofus.Electron.WIDESCREEN_PANEL_CONSOLE);
         _root._loader.loadXtra();
      }
      else
      {
         _loc5_ = sExtraData.charAt(0);
         _loc6_ = this.api.lang.getText("LOGIN");
         _loc8_ = false;
         switch(_loc5_)
         {
            case "n":
               _loc7_ = this.api.lang.getText("CONNECT_NOT_FINISHED");
               break;
            case "a":
               _loc7_ = this.api.lang.getText("ALREADY_LOGGED");
               break;
            case "c":
               _loc7_ = this.api.lang.getText("ALREADY_LOGGED_GAME_SERVER");
               break;
            case "v":
               _loc7_ = this.api.lang.getText("BAD_VERSION",[dofus.Constants.VERSION + "." + dofus.Constants.SUBVERSION + "." + dofus.Constants.SUBSUBVERSION + (dofus.Constants.BETAVERSION <= 0 ? "" : " Beta " + dofus.Constants.BETAVERSION),sExtraData.substr(1)]);
               _loc8_ = true;
               break;
            case "p":
               _loc7_ = this.api.lang.getText("NOT_PLAYER");
               break;
            case "b":
               _loc7_ = this.api.lang.getText("BANNED");
               break;
            case "d":
               _loc7_ = this.api.lang.getText("U_DISCONNECT_ACCOUNT");
               break;
            case "k":
               _loc9_ = sExtraData.substr(1).split("|");
               _loc10_ = _loc9_.slice(0,3);
               _loc11_ = _loc9_.slice(3);
               _loc12_ = 0;
               while(_loc12_ < _loc10_.length)
               {
                  if(_loc10_[_loc12_] == 0)
                  {
                     _loc10_[_loc12_] = undefined;
                  }
                  _loc12_ = _loc12_ + 1;
               }
               _loc7_ = ank.utils.PatternDecoder.getDescription(this.api.lang.getText("KICKED"),_loc10_);
               if(_loc11_ != undefined && _loc11_.length >= 2)
               {
                  _loc13_ = _loc11_[0];
                  if(_loc13_.length > 0)
                  {
                     _loc6_ = _loc13_;
                  }
                  _loc14_ = _loc11_[1];
                  if(_loc11_.length >= 3)
                  {
                     _loc11_ = _loc11_.slice(2,_loc11_.length);
                     _loc15_ = "\n" + _loc11_.join("|");
                  }
                  _loc7_ += "\n\n" + this.api.lang.getText("SRV_MSG_18",[_loc14_,!(_loc15_ == undefined || _loc15_.length == 0) ? _loc15_ : ""]);
               }
               break;
            case "w":
               _loc7_ = this.api.lang.getText("SERVER_FULL");
               break;
            case "o":
               _loc7_ = this.api.lang.getText("OLD_ACCOUNT",[this.api.datacenter.Basics.login]);
               break;
            case "O":
               _loc7_ = this.api.lang.getText("OTP_TIME_FAILED");
               break;
            case "e":
               _loc7_ = this.api.lang.getText("OLD_ACCOUNT_USE_NEW",[this.api.datacenter.Basics.login]);
               break;
            case "m":
               _loc7_ = this.api.lang.getText("MAINTAIN_ACCOUNT");
               break;
            case "r":
               this.api.ui.loadUIComponent("ChooseNickName","ChooseNickName");
               return undefined;
            case "s":
               this.api.ui.getUIComponent("ChooseNickName").nickAlreadyUsed = true;
               return undefined;
            case "i":
               _loc7_ = this.api.lang.getText("LOGIN_ERROR_ANONYMOUS_IP");
               break;
            case "f":
               if(this.api.config.isStreaming)
               {
                  _loc7_ = this.api.lang.getText("ACCESS_DENIED_MINICLIP");
                  break;
               }
            default:
               _loc7_ = this.api.lang.getText("ACCESS_DENIED");
         }
         if(dofus.Constants.USE_JS_LOG && _global.CONFIG.isNewAccount)
         {
            getURL("JavaScript:WriteLog(\'LoginError;" + _loc7_ + "\')","_self");
         }
         this.aks.disconnect(false,false);
         _loc16_ = this.api.ui.loadUIComponent("AskOk",!_loc8_ ? "AskOkOnLogin" : "AskOkOnLoginCloseClient",{title:_loc6_,text:_loc7_});
         _loc16_.addEventListener("ok",this);
         this.api.kernel.manualLogon();
      }
   }
   function onServersList(bSuccess, sExtraData)
   {
      this.api.ui.unloadUIComponent("WaitingMessage");
      var _loc4_ = this.api.datacenter.Basics.aks_servers;
      var _loc5_ = 0;
      while(_loc5_ < _loc4_.length)
      {
         _loc4_[_loc5_].charactersCount = 0;
         _loc5_ = _loc5_ + 1;
      }
      this.api.ui.getUIComponent("MainMenu").quitMode = "menu";
      var _loc6_ = sExtraData.split("|");
      var _loc7_ = Number(_loc6_[0]);
      var _loc8_ = -1;
      this.api.datacenter.Player.subscriber = _loc7_ > 0;
      this.api.ui.getUIComponent("MainMenu").updateSubscribeButton();
      var _loc9_ = 0;
      var _loc10_ = 1;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      while(_loc10_ < _loc6_.length)
      {
         _loc11_ = _loc6_[_loc10_].split(",");
         _loc12_ = Number(_loc11_[0]);
         _loc13_ = Number(_loc11_[1]);
         if(_loc13_ > 0)
         {
            _loc8_ = _loc12_;
         }
         _loc9_ += _loc13_;
         _loc14_ = 0;
         while(_loc14_ < _loc4_.length)
         {
            if(_loc4_[_loc14_].id == _loc12_)
            {
               _loc4_[_loc14_].charactersCount = _loc13_;
               break;
            }
            _loc14_ = _loc14_ + 1;
         }
         _loc10_ = _loc10_ + 1;
      }
      if(_loc8_ == -1)
      {
         _loc8_ = _loc4_[Math.floor(Math.random() * (_loc4_.length - 1))].id;
         if(!_loc8_)
         {
            _loc8_ = -1;
         }
      }
      this.api.ui.unloadUIComponent("ServerList");
      this.api.ui.unloadUIComponent("ServerInformations");
      this.api.ui.unloadUIComponent("CreateCharacter");
      this.api.ui.unloadUIComponent("ChooseCharacter");
      this.api.ui.unloadUIComponent("AutomaticServer");
      this.api.ui.unloadUIComponent("ChooseServer");
      this.api.network.Basics.onAuthorizedCommandPrompt("Connection Server");
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      if(dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST != undefined)
      {
         _loc15_ = dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST;
         _loc16_ = _loc15_.serverId;
         _loc18_ = 0;
         while(_loc18_ < _loc4_.length)
         {
            _loc19_ = _loc4_[_loc18_];
            if(_loc19_.id == _loc16_)
            {
               if(!(_loc19_.state != dofus.datacenter.Server.SERVER_ONLINE || !_loc19_.isAllowed))
               {
                  _loc17_ = _loc19_;
                  break;
               }
            }
            _loc18_ = _loc18_ + 1;
         }
         if(_loc17_ != undefined)
         {
            if(_loc17_.charactersCount != 0)
            {
               if(_loc15_.isServerSet)
               {
                  return undefined;
               }
               _loc15_.isServerSet = true;
               this.api.datacenter.Basics.aks_current_server = _loc17_;
               this.api.network.Account.setServer(_loc17_.id);
               return undefined;
            }
            this.api.kernel.onFastServerSwitchFail("You do not have any character on server " + _loc16_);
         }
         else
         {
            this.api.kernel.onFastServerSwitchFail("Server " + _loc16_ + " is not available now.");
         }
      }
      var _loc20_;
      if(!this.api.datacenter.Basics.forceAutomaticServerSelection && (_loc9_ > 0 || (this.api.config.isStreaming || this.api.datacenter.Basics.forceManualServerSelection)))
      {
         if(this.api.datacenter.Basics.forceManualServerSelection)
         {
            this.api.datacenter.Basics.hasForcedManualSelection = true;
         }
         else if(_loc8_ != -1 && this.api.config.isStreaming)
         {
            _loc20_ = new dofus.datacenter.Server(_loc8_,1,0);
            if(_loc20_.isAllowed())
            {
               this.api.datacenter.Basics.aks_current_server = _loc20_;
               this.api.network.Account.setServer(_loc8_);
               return undefined;
            }
         }
         this.api.datacenter.Basics.forceManualServerSelection = false;
         this.api.ui.loadUIComponent("ChooseServer","ChooseServer",{servers:_loc4_,remainingTime:_loc7_});
      }
      else
      {
         this.api.datacenter.Basics.forceAutomaticServerSelection = false;
         this.api.ui.loadUIComponent("ChooseServer","ChooseServer",{servers:_loc4_,remainingTime:_loc7_});
      }
   }
   function onHosts(sExtraData)
   {
      var _loc3_ = this.api.datacenter.Basics.aks_servers;
      var _loc4_ = [];
      var _loc5_ = sExtraData.split("|");
      var _loc6_ = Number(_loc5_.shift()) == 1;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc7_ < _loc5_.length)
      {
         _loc8_ = _loc5_[_loc7_].split(";");
         _loc9_ = Number(_loc8_[0]);
         _loc10_ = Number(_loc8_[1]);
         _loc11_ = Number(_loc8_[2]);
         _loc12_ = _loc8_[3] == "1";
         _loc13_ = _loc8_[4] == "1";
         _loc14_ = new dofus.datacenter.Server(_loc9_,_loc10_,_loc11_,_loc12_,_loc13_);
         if(!(_global.CONFIG.onlyHardcore && _loc14_.typeNum != dofus.datacenter.Server.SERVER_HARDCORE))
         {
            _loc15_ = _loc3_.findFirstItem("id",_loc9_).item;
            if(_loc15_ != undefined)
            {
               _loc14_.charactersCount = _loc15_.charactersCount;
            }
            _loc4_.push(_loc14_);
         }
         _loc7_ = _loc7_ + 1;
      }
      this.api.datacenter.Basics.aks_servers.removeAll();
      this.api.datacenter.Basics.aks_servers.pushAll(_loc4_);
      this.api.datacenter.Basics.isCoLimited = _loc6_;
   }
   function onCharactersList(bSuccess, sExtraData, bIsMigration)
   {
      if(this.api.electron.enabled)
      {
         this.api.electron.eventClient("connect");
      }
      if(this.api.datacenter.Player.isAuthorized)
      {
         this.api.electron.setWidescreenPanelId(dofus.Electron.WIDESCREEN_PANEL_CHAT);
      }
      this.api.ui.unloadUIComponent("WaitingMessage");
      this.api.ui.unloadUIComponent("WaitingQueue");
      var _loc5_ = [];
      var _loc6_ = sExtraData.split("|");
      var _loc7_ = Number(_loc6_[0]);
      this.api.datacenter.Player.subscriber = _loc7_ > 0;
      this.api.ui.getUIComponent("MainMenu").updateSubscribeButton();
      var _loc8_ = Number(_loc6_[1]);
      var _loc9_ = [];
      this.api.datacenter.Sprites.clear();
      var _loc10_ = 2;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc10_ < _loc6_.length)
      {
         _loc11_ = _loc6_[_loc10_].split(";");
         _loc12_ = {};
         _loc13_ = _loc11_[0];
         _loc14_ = _loc11_[1];
         _loc12_.level = _loc11_[2];
         _loc12_.gfxID = _loc11_[3];
         _loc12_.color1 = _loc11_[4];
         _loc12_.color2 = _loc11_[5];
         _loc12_.color3 = _loc11_[6];
         _loc12_.accessories = _loc11_[7];
         _loc12_.merchant = _loc11_[8];
         _loc12_.serverID = _loc11_[9];
         _loc12_.xpMultiplicator = _loc11_[10];
         _loc12_.isDead = _loc11_[11];
         _loc12_.deathCount = _loc11_[12];
         _loc12_.lvlMax = _loc11_[13];
         _loc15_ = this.api.kernel.CharactersManager.createCharacter(_loc13_,_loc14_,_loc12_);
         _loc15_.sortID = Number(_loc13_);
         _loc5_.push(_loc15_);
         _loc9_.push(Number(_loc13_));
         _loc10_ = _loc10_ + 1;
      }
      this.api.ui.unloadUIComponent("ChooseCharacter");
      this.api.ui.unloadUIComponent("CreateCharacter");
      this.api.ui.unloadUIComponent("ChooseServer");
      this.api.ui.unloadUIComponent("AutomaticServer");
      ank.utils.Timer.removeTimer(this.WaitQueueTimer,"WaitQueue");
      this.api.ui.getUIComponent("MainMenu").quitMode = "menu";
      var _loc16_;
      var _loc17_;
      var _loc18_;
      if(this.api.datacenter.Basics.hasCreatedCharacter)
      {
         this.api.datacenter.Basics.hasCreatedCharacter = false;
         if(this.api.datacenter.Basics.oldCharList == undefined && _loc9_.length == 1 || this.api.datacenter.Basics.oldCharList.length + 1 == _loc9_.length)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc9_.length)
            {
               _loc17_ = false;
               _loc18_ = 0;
               while(_loc18_ < this.api.datacenter.Basics.oldCharList.length)
               {
                  if(_loc9_[_loc16_] == this.api.datacenter.Basics.oldCharList[_loc18_])
                  {
                     _loc17_ = true;
                     break;
                  }
                  _loc18_ = _loc18_ + 1;
               }
               if(!_loc17_)
               {
                  this.setCharacter(_loc9_[_loc16_]);
                  return undefined;
               }
               _loc16_ = _loc16_ + 1;
            }
         }
      }
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      if(dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST != undefined)
      {
         _loc19_ = dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST;
         _loc20_ = _loc19_.playerName;
         _loc21_ = 0;
         while(_loc21_ < _loc5_.length)
         {
            _loc22_ = _loc5_[_loc21_];
            if(_loc22_.name == _loc20_)
            {
               this.setCharacter(_loc22_.id);
               return undefined;
            }
            _loc21_ = _loc21_ + 1;
         }
         this.api.kernel.onFastServerSwitchFail("Could not find " + _loc20_ + " on this characters list !");
      }
      this.api.datacenter.Basics.oldCharList = _loc9_;
      if((!bIsMigration || this.api.datacenter.Basics.ignoreMigration) && ((this.api.datacenter.Basics.createCharacter || !_loc8_) && !this.api.datacenter.Basics.ignoreCreateCharacter))
      {
         this.api.ui.loadUIComponent("CreateCharacter","CreateCharacter",{remainingTime:_loc7_});
      }
      else
      {
         this.api.ui.unloadUIComponent("CharactersMigration");
         if(!bIsMigration || this.api.datacenter.Basics.ignoreMigration)
         {
            this.api.datacenter.Basics.createCharacter = false;
            this.api.ui.loadUIComponent("ChooseCharacter","ChooseCharacter",{spriteList:_loc5_,remainingTime:_loc7_,characterCount:_loc8_},{bForceLoad:true});
         }
         else
         {
            this.api.datacenter.Basics.ignoreMigration = false;
            this.api.datacenter.Basics.createCharacter = false;
            this.api.ui.loadUIComponent("CharactersMigration","CharactersMigration",{spriteList:_loc5_,remainingTime:_loc7_,characterCount:_loc8_},{bForceLoad:true});
         }
      }
   }
   function onMiniClipInfo()
   {
      this.api.datacenter.Basics.first_connection_from_miniclip = true;
   }
   function onCharacterAdd(bSuccess, sExtraData)
   {
      var _loc4_ = dofus.graphics.gapi.ui.Gifts(this.api.ui.getUIComponent("Gifts"));
      if(_loc4_ == undefined || !_loc4_.isAttributingGifts)
      {
         this.api.ui.unloadUIComponent("WaitingMessage");
      }
      if(dofus.Constants.USE_JS_LOG && _global.CONFIG.isNewAccount)
      {
         getURL("JavaScript:WriteLog(\'CharacterValidation;" + bSuccess + "\')","_self");
      }
      if(!bSuccess)
      {
         switch(sExtraData)
         {
            case "s":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SUBSCRIPTION_OUT"),"ERROR_BOX",{name:"CreateNameExists"});
               break;
            case "f":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CREATE_CHARACTER_FULL"),"ERROR_BOX",{name:"CreateNameExists"});
               break;
            case "a":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NAME_ALEREADY_EXISTS"),"ERROR_BOX",{name:"CreateNameExists"});
               break;
            case "n":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CREATE_CHARACTER_BAD_NAME"),"ERROR_BOX",{name:"CreateNameExists"});
               break;
            default:
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CREATE_CHARACTER_ERROR"),"ERROR_BOX",{name:"CreateNameExists"});
         }
      }
      else
      {
         this.api.datacenter.Basics.createCharacter = false;
      }
   }
   function onSelectServerMinimal(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      var _loc4_ = new dofus.datacenter.Server(_loc3_,1,0);
      this.api.datacenter.Basics.aks_current_server = _loc4_;
      this.api.network.Basics.onAuthorizedCommandPrompt(this.api.datacenter.Basics.aks_current_server.label);
   }
   function onSelectServer(bSuccess, bUseIp, sExtraData)
   {
      this.api.ui.unloadUIComponent("WaitingMessage");
      var _loc8_;
      var _loc9_;
      var _loc7_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc5_;
      var _loc6_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      if(bSuccess)
      {
         if(bUseIp)
         {
            _loc8_ = sExtraData.substr(0,8);
            _loc9_ = sExtraData.substr(8,3);
            _loc7_ = sExtraData.substr(11);
            _loc10_ = [];
            _loc11_ = 0;
            while(_loc11_ < 8)
            {
               _loc12_ = _loc8_.charCodeAt(_loc11_) - 48;
               _loc13_ = _loc8_.charCodeAt(_loc11_ + 1) - 48;
               _loc10_.push((_loc12_ & 0x0F) << 4 | _loc13_ & 0x0F);
               _loc11_ += 2;
            }
            _loc5_ = _loc10_.join(".");
            _loc6_ = (ank.utils.Compressor.decode64(_loc9_.charAt(0)) & 0x3F) << 12 | (ank.utils.Compressor.decode64(_loc9_.charAt(1)) & 0x3F) << 6 | ank.utils.Compressor.decode64(_loc9_.charAt(2)) & 0x3F;
         }
         else
         {
            _loc14_ = sExtraData.split(";");
            _loc15_ = _loc14_[0].split(":");
            _loc5_ = _loc15_[0];
            _loc6_ = _loc15_[1];
            _loc7_ = _loc14_[1];
         }
         _loc16_ = this.api.config.getCustomIP(this.api.datacenter.Basics.aks_incoming_server_id);
         if(_loc16_ != undefined)
         {
            _loc5_ = _loc16_.ip;
            _loc6_ = _loc16_.port;
         }
         this.api.datacenter.Basics.aks_ticket = _loc7_;
         this.api.datacenter.Basics.aks_gameserver_ip = _loc5_;
         this.api.datacenter.Basics.aks_gameserver_port = _loc6_;
         this.api.datacenter.Basics.ignoreMigration = false;
         this.api.datacenter.Basics.ignoreCreateCharacter = false;
         this.api.ui.unloadUIComponent("ChooseServer");
         this.api.ui.unloadUIComponent("AutomaticServer");
         this.api.ui.loadUIComponent("Waiting","Waiting");
         this.aks.softDisconnect();
         this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("CONNECTING")},{bAlwaysOnTop:true,bForceLoad:true});
         this.api.network.Basics.onAuthorizedCommandPrompt(this.api.datacenter.Basics.aks_current_server.label);
         if(_global.CONFIG.delay != undefined)
         {
            ank.utils.Timer.setTimer(this,"connect",this.aks,this.aks.connect,_global.CONFIG.delay,[_loc5_,_loc6_,false]);
         }
         else
         {
            this.aks.connect(_loc5_,_loc6_,false);
         }
      }
      else
      {
         delete this.api.datacenter.Basics.aks_current_server;
         this.api.datacenter.Basics.createCharacter = false;
         switch(sExtraData.charAt(0))
         {
            case "d":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_CHOOSE_CHARACTER_SERVER_DOWN"),"ERROR_BOX");
               break;
            case "f":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SERVER_IS_FULL_NOT_FULL_MEMBER"),"ERROR_BOX");
               break;
            case "F":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SERVER_FULL"),"ERROR_BOX");
               break;
            case "s":
               _loc17_ = this.api.lang.getServerInfos(Number(sExtraData.substr(1))).n;
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_CHOOSE_CHARACTER_SHOP_OTHER_SERVER",[_loc17_]),"ERROR_BOX");
               break;
            case "r":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_SELECT_THIS_SERVER"),"ERROR_BOX");
            default:
               return;
         }
      }
   }
   function onRescue(bSuccess)
   {
      this.api.datacenter.Player.data.GameActionsManager.clear();
      this.api.ui.unloadUIComponent("WaitingMessage");
      this.api.ui.unloadUIComponent("WaitingQueue");
      ank.utils.Timer.removeTimer(this.WaitQueueTimer,"WaitQueue");
      if(!bSuccess)
      {
         this.api.datacenter.Basics.aks_rescue_count = -1;
         this.aks.disconnect(false,true);
      }
   }
   function onTicketResponse(bSuccess, sExtraData)
   {
      this.api.ui.unloadUIComponent("WaitingMessage");
      var _loc4_;
      if(bSuccess)
      {
         _loc4_ = _global.parseInt(sExtraData.substr(0,1),16);
         if(_global.isNaN(_loc4_))
         {
            _loc4_ = -1;
         }
         if(_loc4_ > 0)
         {
            this.aks.addKeyToCollection(_loc4_,sExtraData.substr(1));
            this.useKey(_loc4_);
            this.aks.startUsingKey(_loc4_);
         }
         else if(_loc4_ == 0)
         {
            this.useKey(0);
         }
         else if(_loc4_ == -1)
         {
         }
         this.api.datacenter.Basics.aks_current_regional_version = Number.POSITIVE_INFINITY;
         this.requestRegionalVersion();
      }
      else
      {
         this.aks.disconnect(false,true);
      }
   }
   function onCharacterSelected(bSuccess, sExtraData)
   {
      this.api.datacenter.Basics.inGame = true;
      if(bSuccess && this.api.datacenter.Player.isAuthorized)
      {
         this.api.kernel.AdminManager.characterSelected();
      }
      this.api.ui.unloadUIComponent("WaitingMessage");
      this.api.ui.unloadUIComponent("ChooseCharacter");
      this.api.ui.unloadUIComponent("WaitingQueue");
      ank.utils.Timer.removeTimer(this.WaitQueueTimer,"WaitQueue");
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(bSuccess)
      {
         _loc4_ = sExtraData.split("|");
         _loc5_ = {};
         _loc6_ = Number(_loc4_[0]);
         _loc7_ = _loc4_[1];
         _loc5_.level = _loc4_[2];
         _loc5_.guild = _loc4_[3];
         _loc5_.sex = _loc4_[4];
         _loc5_.gfxID = _loc4_[5];
         _loc5_.color1 = _loc4_[6];
         _loc5_.color2 = _loc4_[7];
         _loc5_.color3 = _loc4_[8];
         _loc5_.items = _loc4_[9];
         this.api.kernel.CharactersManager.setLocalPlayerData(_loc6_,_loc7_,_loc5_);
         this.aks.Game.create();
         if(this.api.datacenter.Player.isAuthorized)
         {
            this.api.kernel.AdminManager.characterEnteringGame();
         }
         this.api.electron.updateWindowTitle(_loc7_);
         this.api.electron.setIngameDiscordActivity();
      }
      else
      {
         this.aks.disconnect(false,true);
      }
   }
   function onStats(sExtraData)
   {
      this.api.ui.unloadUIComponent("WaitingMessage");
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = this.api.datacenter.Player;
      var _loc5_ = _loc3_[0].split(",");
      _loc4_.XP = _loc5_[0];
      _loc4_.XPlow = _loc5_[1];
      _loc4_.XPhigh = _loc5_[2];
      _loc4_.Kama = _loc3_[1];
      _loc4_.BonusPoints = _loc3_[2];
      _loc4_.BonusPointsSpell = _loc3_[3];
      _loc5_ = _loc3_[4].split(",");
      var _loc6_ = 0;
      var _loc7_;
      if(_loc5_[0].indexOf("~"))
      {
         _loc7_ = _loc5_[0].split("~");
         _loc4_._nCriticalHitBonus = _loc7_[0] != _loc7_[1];
         _loc6_ = Number(_loc7_[1]);
         _loc5_[0] = _loc7_[0];
      }
      var _loc8_ = Number(_loc5_[0]);
      var _loc9_ = Number(_loc5_[1]);
      _loc4_.alignment = new dofus.datacenter.Alignment(_loc8_,_loc9_);
      _loc4_.fakeAlignment = new dofus.datacenter.Alignment(_loc6_,_loc9_);
      _loc4_.data.alignment = _loc4_.alignment.clone();
      var _loc10_ = Number(_loc5_[2]);
      var _loc11_ = Number(_loc5_[3]);
      var _loc12_ = Number(_loc5_[4]);
      var _loc13_ = _loc5_[5] != "1" ? false : true;
      var _loc14_ = _loc4_.rank.disgrace;
      _loc4_.rank = new dofus.datacenter.Rank(_loc10_,_loc11_,_loc12_,_loc13_);
      _loc4_.data.rank = _loc4_.rank.clone();
      if(_loc14_ != undefined && (_loc14_ != _loc12_ && _loc12_ > 0))
      {
         this.api.kernel.GameManager.showDisgraceSanction();
      }
      _loc5_ = _loc3_[5].split(",");
      _loc4_.LP = _loc5_[0];
      _loc4_.data.LP = _loc5_[0];
      _loc4_.LPmax = _loc5_[1];
      _loc4_.data.LPmax = _loc5_[1];
      _loc5_ = _loc3_[6].split(",");
      _loc4_.EnergyMax = _loc5_[1];
      _loc4_.Energy = _loc5_[0];
      _loc4_.Initiative = _loc3_[7];
      _loc4_.Discernment = _loc3_[8];
      var _loc15_ = [];
      var _loc16_ = 3;
      while(_loc16_ > -1)
      {
         _loc15_[_loc16_] = [];
         _loc16_ = _loc16_ - 1;
      }
      var _loc17_ = 9;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      while(_loc17_ < 53)
      {
         _loc5_ = _loc3_[_loc17_].split(",");
         _loc18_ = Number(_loc5_[0]);
         _loc19_ = Number(_loc5_[1]);
         _loc20_ = Number(_loc5_[2]);
         _loc21_ = Number(_loc5_[3]);
         _loc22_ = _loc5_[4] != undefined ? Number(_loc5_[4]) : 0;
         switch(_loc17_)
         {
            case 9:
               _loc15_[0].push({id:_loc17_,o:7,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"Star"});
               if(!this.api.datacenter.Game.isRunning)
               {
                  _loc4_.AP = _loc18_ + _loc19_ + _loc20_;
               }
               break;
            case 10:
               _loc15_[0].push({id:_loc17_,o:8,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconMP"});
               if(!this.api.datacenter.Game.isRunning)
               {
                  _loc4_.MP = _loc18_ + _loc19_ + _loc20_;
               }
               break;
            case 11:
               _loc15_[0].push({id:_loc17_,o:3,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconEarthBonus"});
               _loc4_.Force = _loc18_;
               _loc4_.ForceXtra = _loc19_ + _loc20_;
               break;
            case 12:
               _loc15_[0].push({id:_loc17_,o:1,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconVita"});
               _loc4_.Vitality = _loc18_;
               _loc4_.VitalityXtra = _loc19_ + _loc20_;
               break;
            case 13:
               _loc15_[0].push({id:_loc17_,o:2,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWisdom"});
               _loc4_.Wisdom = _loc18_;
               _loc4_.WisdomXtra = _loc19_ + _loc20_;
               break;
            case 14:
               _loc15_[0].push({id:_loc17_,o:5,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWaterBonus"});
               _loc4_.Chance = _loc18_;
               _loc4_.ChanceXtra = _loc19_ + _loc20_;
               break;
            case 15:
               _loc15_[0].push({id:_loc17_,o:6,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconAirBonus"});
               _loc4_.Agility = _loc18_;
               _loc4_.AgilityXtra = _loc19_ + _loc20_;
               _loc4_.AgilityTotal = _loc18_ + _loc19_ + _loc20_ + _loc21_;
               break;
            case 16:
               _loc15_[0].push({id:_loc17_,o:4,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconFireBonus"});
               _loc4_.Intelligence = _loc18_;
               _loc4_.IntelligenceXtra = _loc19_ + _loc20_;
               break;
            case 17:
               _loc15_[0].push({id:_loc17_,o:9,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"Range"});
               _loc4_.RangeModerator = _loc18_ + _loc19_ + _loc20_;
               break;
            case 18:
               _loc15_[0].push({id:_loc17_,o:10,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"Summon"});
               _loc4_.MaxSummonedCreatures = _loc18_ + _loc19_ + _loc20_;
               break;
            case 19:
               _loc15_[1].push({id:_loc17_,o:1,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"Damage"});
               break;
            case 20:
               _loc15_[1].push({id:_loc17_,o:2,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"DamagePhysical"});
               break;
            case 21:
               _loc15_[1].push({id:_loc17_,o:3,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"DamageWeapon"});
               break;
            case 22:
               _loc15_[1].push({id:_loc17_,o:4,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"DamagePercent"});
               break;
            case 23:
               _loc15_[1].push({id:_loc17_,o:7,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"HealBonus"});
               break;
            case 24:
               _loc15_[1].push({id:_loc17_,o:5,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"DamageTrap"});
               break;
            case 25:
               _loc15_[1].push({id:_loc17_,o:6,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"DamageTrapPercent"});
               break;
            case 26:
               _loc15_[1].push({id:_loc17_,o:8,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"ReflectDamage"});
               break;
            case 27:
               _loc15_[1].push({id:_loc17_,o:9,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"CriticalHit"});
               _loc4_.CriticalHitBonus = _loc18_ + _loc19_ + _loc20_ + _loc21_;
               break;
            case 28:
               _loc15_[1].push({id:_loc17_,o:10,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"CriticalFailure"});
               break;
            case 29:
               _loc15_[1].push({id:_loc17_,o:11,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"Star"});
               break;
            case 30:
               _loc15_[1].push({id:_loc17_,o:12,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconMP"});
               break;
            case 31:
               _loc15_[2].push({id:_loc17_,o:1,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconNeutralAlt"});
               break;
            case 32:
               _loc15_[2].push({id:_loc17_,o:2,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconNeutral"});
               break;
            case 33:
               _loc15_[3].push({id:_loc17_,o:11,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconNeutralAlt"});
               break;
            case 34:
               _loc15_[3].push({id:_loc17_,o:12,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconNeutral"});
               break;
            case 35:
               _loc15_[2].push({id:_loc17_,o:3,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconEarthAlt"});
               break;
            case 36:
               _loc15_[2].push({id:_loc17_,o:4,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconEarth"});
               break;
            case 37:
               _loc15_[3].push({id:_loc17_,o:13,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconEarthAlt"});
               break;
            case 38:
               _loc15_[3].push({id:_loc17_,o:14,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconEarth"});
               break;
            case 39:
               _loc15_[2].push({id:_loc17_,o:7,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWaterAlt"});
               break;
            case 40:
               _loc15_[2].push({id:_loc17_,o:8,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWater"});
               break;
            case 41:
               _loc15_[3].push({id:_loc17_,o:17,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWaterAlt"});
               break;
            case 42:
               _loc15_[3].push({id:_loc17_,o:18,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconWater"});
               break;
            case 43:
               _loc15_[2].push({id:_loc17_,o:9,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconAirAlt"});
               break;
            case 44:
               _loc15_[2].push({id:_loc17_,o:10,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconAir"});
               break;
            case 45:
               _loc15_[3].push({id:_loc17_,o:19,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconAirAlt"});
               break;
            case 46:
               _loc15_[3].push({id:_loc17_,o:20,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconAir"});
               break;
            case 47:
               _loc15_[2].push({id:_loc17_,o:5,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconFireAlt"});
               break;
            case 48:
               _loc15_[2].push({id:_loc17_,o:6,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconFire"});
               break;
            case 49:
               _loc15_[3].push({id:_loc17_,o:15,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconFireAlt"});
               break;
            case 50:
               _loc15_[3].push({id:_loc17_,o:16,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"IconFire"});
               break;
            case 51:
               _loc15_[1].push({id:_loc17_,o:13,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"FinalDamageInflicted"});
               break;
            case 52:
               _loc15_[1].push({id:_loc17_,o:14,s:_loc18_,i:_loc19_,d:_loc20_,b:_loc21_,a:_loc22_,p:"FinalDamageReceived"});
         }
         _loc17_ = _loc17_ + 1;
      }
      _loc4_.ShowedLevel = _loc3_[54] != undefined ? Number(_loc3_[54]) : -1;
      _loc4_.FullStats = _loc15_;
      if(getTimer() - this.api.datacenter.Basics.lastDateUpdate > 60000)
      {
         this.api.network.Basics.getDate();
      }
   }
   function onNewLevel(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.api.datacenter.Player.Level = _loc3_;
      this.api.datacenter.Player.data.Level = _loc3_;
      this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_GAIN_LEVEL);
      if(this.api.datacenter.Basics.inDemoMode && _loc3_ == 1)
      {
         return undefined;
      }
      this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("NEW_LEVEL",[_loc3_]),"ERROR_BOX",{name:"NewLevel"});
   }
   function onRestrictions(sExtraData)
   {
      this.api.datacenter.Player.restrictions = _global.parseInt(sExtraData,36);
   }
   function onGiftsList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2];
      var _loc7_ = _loc3_[3];
      var _loc8_ = _loc3_[4];
      var _loc9_ = Number(_loc3_[5]);
      var _loc10_ = _loc3_[6];
      var _loc11_ = "";
      var _loc12_;
      var _loc13_;
      var _loc14_;
      if(_loc9_ != -1)
      {
         _loc12_ = new Date(_loc9_ * 1000);
         _loc13_ = (_loc12_.getDate() < 10 ? "0" : "") + _loc12_.getDate();
         _loc14_ = (_loc12_.getMonth() + 1 < 10 ? "0" : "") + (_loc12_.getMonth() + 1);
         _loc11_ = _loc13_ + "/" + _loc14_ + "/" + _loc12_.getFullYear();
      }
      var _loc15_ = new LoadVars();
      _loc15_.decode("&text=" + _loc6_);
      var _loc16_ = _loc15_.text;
      _loc15_ = new LoadVars();
      _loc15_.decode("&desc=" + _loc7_);
      var _loc17_ = _loc15_.desc;
      _loc15_ = new LoadVars();
      _loc15_.decode("&gfxurl=" + _loc8_);
      var _loc18_ = _loc15_.gfxurl;
      var _loc19_ = new ank.utils.ExtendedArray();
      var _loc20_ = _loc10_.split(";");
      var _loc21_ = 0;
      var _loc22_;
      while(_loc21_ < _loc20_.length)
      {
         if(_loc20_[_loc21_] != "")
         {
            _loc22_ = this.api.kernel.CharactersManager.getItemObjectFromData(_loc20_[_loc21_]);
            _loc19_.push(_loc22_);
         }
         _loc21_ = _loc21_ + 1;
      }
      var _loc23_ = new dofus.datacenter.Gift();
      _loc23_.type = _loc4_;
      _loc23_.id = _loc5_;
      _loc23_.title = _loc16_;
      _loc23_.desc = _loc17_;
      _loc23_.gfxUrl = _loc18_;
      _loc23_.items = _loc19_;
      _loc23_.date = _loc11_;
      this.api.datacenter.Basics.aks_gifts_stack.push(_loc23_);
   }
   function onGiftStored(bSuccess)
   {
      var _loc3_ = dofus.graphics.gapi.ui.Gifts(this.api.ui.getUIComponent("Gifts"));
      if(_loc3_ == undefined)
      {
         this.api.ui.unloadUIComponent("WaitingMessage");
      }
      else
      {
         this.api.ui.getUIComponent("Gifts").checkNextGift();
      }
   }
   function onQueue(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      if(_loc3_ > 1)
      {
         this.api.ui.loadUIComponent("WaitingMessage","WaitingMessage",{text:this.api.lang.getText("CONNECTING") + " ( " + this.api.lang.getText("WAIT_QUEUE_POSITION",[_loc3_]) + " )"},{bAlwaysOnTop:true,bForceLoad:true});
      }
   }
   function onNewQueue(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = Number(_loc3_[2]);
      var _loc7_;
      switch(_loc3_[3])
      {
         case "0":
            _loc7_ = false;
            break;
         case "1":
            _loc7_ = true;
      }
      var _loc8_ = Number(_loc3_[4]);
      if(_loc4_ > 1)
      {
         this.api.ui.loadUIComponent("WaitingQueue","WaitingQueue",{queueInfos:{position:_loc4_,totalAbo:_loc5_,totalNonAbo:_loc6_,subscriber:_loc7_,queueId:_loc8_}},{bAlwaysOnTop:true,bForceLoad:true});
      }
   }
   function onCharacterNameGenerated(bSuccess, sCharacterNameOrError)
   {
      if(bSuccess)
      {
         if(this.api.ui.getUIComponent("CreateCharacter"))
         {
            this.api.ui.getUIComponent("CreateCharacter").characterName = sCharacterNameOrError;
         }
         if(this.api.ui.getUIComponent("CharactersMigration"))
         {
            this.api.ui.getUIComponent("CharactersMigration").setNewName = sCharacterNameOrError;
         }
         if(this.api.ui.getUIComponent("EditPlayer"))
         {
            this.api.ui.getUIComponent("EditPlayer").characterName = sCharacterNameOrError;
         }
      }
      else
      {
         switch(sCharacterNameOrError)
         {
            case "1":
            case "2":
               this.api.datacenter.Basics.aks_can_generate_names = false;
               if(this.api.ui.getUIComponent("CreateCharacter"))
               {
                  this.api.ui.getUIComponent("CreateCharacter").hideGenerateRandomName();
               }
               if(this.api.ui.getUIComponent("CharactersMigration"))
               {
                  this.api.ui.getUIComponent("CharactersMigration").hideGenerateRandomName();
               }
            default:
               return;
         }
      }
   }
   function onCharactersMigrationAskConfirm(sData)
   {
      var _loc3_ = sData.split(";");
      var _loc4_ = _global.parseInt(_loc3_[0],10);
      var _loc5_ = _loc3_[1];
      var _loc6_ = {name:"ConfirmMigration",params:{nCharacterID:_loc4_,sName:_loc5_},listener:this};
      this.api.kernel.showMessage(undefined,this.api.lang.getText("CONFIRM_MIGRATION",[_loc5_]),"CAUTION_YESNO",_loc6_);
   }
   function onFriendServerList(sData)
   {
      var _loc3_ = sData.split(";");
      var _loc4_ = [];
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < _loc3_.length)
      {
         _loc6_ = _loc3_[_loc5_].split(",");
         _loc4_.push({server:_loc6_[0],count:_loc6_[1]});
         _loc5_ = _loc5_ + 1;
      }
      this.api.ui.getUIComponent("ServerList").setSearchResult(_loc4_);
   }
   function onDemoMode(sData)
   {
      this.api.ui.loadUIComponent("DemoMode","DemoMode");
      this.api.datacenter.Basics.inDemoMode = true;
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoSwitchToEnglish":
            this.api.config.language = "en";
            this.api.kernel.clearCache();
            break;
         case "AskYesNoConfirmMigration":
            this.validCharacterMigration(oEvent.target.params.nCharacterID,oEvent.target.params.sName);
         default:
            return;
      }
   }
   function no(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target._name) === "AskYesNoSwitchToEnglish")
      {
         this.api.kernel.changeServer(true);
      }
   }
   function onLockCharacterXp(sData)
   {
      this.api.datacenter.Player.isXpLocked = sData == "1";
      if(this.api.ui.getUIComponent("StatsJob"))
      {
         this.api.ui.getUIComponent("StatsJob").xpLockedChanged(this.api.datacenter.Player.isXpLocked);
      }
   }
}
