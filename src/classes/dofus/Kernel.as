815249399 - 1;
class dofus.Kernel extends dofus.utils.ApiElement
{
   var AdminManager;
   var AreasManager;
   var AudioManager;
   var CharactersManager;
   var ChatManager;
   var Console;
   var DebugConsole;
   var DebugManager;
   var DocumentsServersManager;
   var GameManager;
   var HouseManager;
   var JobsManager;
   var KeyManager;
   var MapsServersManager;
   var MountParkManager;
   var NightManager;
   var OptionsManager;
   var SpeakingItemsManager;
   var SpellsBoostsManager;
   var StreamingDisplayManager;
   var TemporisConfigManager;
   var TipsManager;
   var TutorialManager;
   var TutorialServersManager;
   var _dropTarget;
   var _sendScreenInfoTimer;
   var startDrag;
   var stopDrag;
   var XTRA_LANG_FILES_LOADED = false;
   static var FAST_SWITCHING_SERVER_REQUEST = undefined;
   function Kernel(oAPI)
   {
      super();
      this.initialize(oAPI);
      if(this.AudioManager == null)
      {
         dofus.sounds.AudioManager.initialize(_root.createEmptyMovieClip("audio_mc",99999),oAPI);
         this.AudioManager = dofus.sounds.AudioManager.getInstance();
      }
      if((this.CharactersManager = dofus.managers.CharactersManager.getInstance()) == null)
      {
         this.CharactersManager = new dofus.managers.CharactersManager(oAPI);
      }
      if((this.ChatManager = dofus.managers.ChatManager.getInstance()) == null)
      {
         this.ChatManager = new dofus.managers.ChatManager(oAPI);
      }
      if((this.MapsServersManager = dofus.managers.MapsServersManager.getInstance()) == null)
      {
         this.MapsServersManager = new dofus.managers.MapsServersManager();
      }
      if((this.DocumentsServersManager = dofus.managers.DocumentsServersManager.getInstance()) == null)
      {
         this.DocumentsServersManager = new dofus.managers.DocumentsServersManager();
      }
      if((this.TutorialServersManager = dofus.managers.TutorialServersManager.getInstance()) == null)
      {
         this.TutorialServersManager = new dofus.managers.TutorialServersManager();
      }
      if((this.GameManager = dofus.managers.GameManager.getInstance()) == null)
      {
         this.GameManager = new dofus.managers.GameManager(oAPI);
      }
      else
      {
         this.GameManager.initialize(oAPI);
      }
      if((this.KeyManager = dofus.managers.KeyManager.getInstance()) == null)
      {
         this.KeyManager = new dofus.managers.KeyManager(oAPI);
      }
      if((this.NightManager = dofus.managers.NightManager.getInstance()) == null)
      {
         this.NightManager = new dofus.managers.NightManager(oAPI);
      }
      if((this.AreasManager = dofus.managers.AreasManager.getInstance()) == null)
      {
         this.AreasManager = new dofus.managers.AreasManager();
      }
      if((this.TutorialManager = dofus.managers.TutorialManager.getInstance()) == null)
      {
         this.TutorialManager = new dofus.managers.TutorialManager(oAPI);
      }
      this.Console = new dofus.utils.consoleParsers.ChatConsoleParser(oAPI);
      this.DebugConsole = new dofus.utils.consoleParsers.DebugConsoleParser(oAPI);
      if((this.OptionsManager = dofus.managers.OptionsManager.getInstance()) == null)
      {
         this.OptionsManager = new dofus.managers.OptionsManager(oAPI);
      }
      if((this.AdminManager = dofus.managers.AdminManager.getInstance()) == null)
      {
         this.AdminManager = new dofus.managers.AdminManager(oAPI);
      }
      if((this.DebugManager = dofus.managers.DebugManager.getInstance()) == null)
      {
         this.DebugManager = new dofus.managers.DebugManager(oAPI);
      }
      if((this.TipsManager = dofus.managers.TipsManager.getInstance()) == null)
      {
         this.TipsManager = new dofus.managers.TipsManager(oAPI);
      }
      if((this.SpellsBoostsManager = dofus.managers.SpellsBoostsManager.getInstance()) == null)
      {
         this.SpellsBoostsManager = new dofus.managers.SpellsBoostsManager(oAPI);
      }
      if((this.SpeakingItemsManager = dofus.managers.SpeakingItemsManager.getInstance()) == null)
      {
         this.SpeakingItemsManager = new dofus.managers.SpeakingItemsManager(oAPI);
      }
      if((this.StreamingDisplayManager = dofus.managers.StreamingDisplayManager.getInstance()) == null)
      {
         this.StreamingDisplayManager = new dofus.managers.StreamingDisplayManager(oAPI);
      }
      if(this.TemporisConfigManager == undefined)
      {
         this.TemporisConfigManager = new dofus.managers.TemporisConfigManager(oAPI);
      }
      if((this.HouseManager = dofus.managers.HousesManager.getInstance()) == null)
      {
         this.HouseManager = new dofus.managers.HousesManager(oAPI);
      }
      if((this.MountParkManager = dofus.managers.MountParksManager.getInstance()) == null)
      {
         this.MountParkManager = new dofus.managers.MountParksManager(oAPI);
      }
      if((this.JobsManager = dofus.managers.JobsManager.getInstance()) == null)
      {
         this.JobsManager = new dofus.managers.JobsManager(oAPI);
      }
      dofus.managers.UIdManager.getInstance().update();
      this._sendScreenInfoTimer = _global.setInterval(this,"sendScreenInfo",1000);
   }
   function sendScreenInfo()
   {
      if(!this.api.datacenter.Basics.inGame || (this.api.datacenter.Game.isFight || this.api.datacenter.Game.isRunning))
      {
         return undefined;
      }
      _global.clearInterval(this._sendScreenInfoTimer);
      this.OptionsManager.setOption("sendResolution",true);
      this.api.network.Infos.sendScreenInfo();
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
   }
   function start()
   {
      this.api.ui.setScreenSize(742,556);
      if(this.getFlashVersion() > 8 && !this.api.electron.enabled)
      {
         Stage.showMenu = false;
      }
      if(!this.api.electron.enabled && (this.OptionsManager.getOption("DisplayStyle") == "medium" && (System.capabilities.screenResolutionY < 950 && System.capabilities.playerType != "StandAlone")))
      {
         this.OptionsManager.setOption("DisplayStyle","normal");
      }
      else if(this.OptionsManager.getOption("EnableWidescreenPanels") && this.api.electron.enabled)
      {
         this.OptionsManager.setOption("DisplayStyle",dofus.managers.OptionsManager.DISPLAY_STYLE_WIDESCREEN_PANELS);
         this.setDisplayStyle(dofus.managers.OptionsManager.DISPLAY_STYLE_WIDESCREEN_PANELS,true);
      }
      else
      {
         this.setDisplayStyle(this.OptionsManager.getOption("DisplayStyle"),true);
      }
      if(this.api.config.isStreaming)
      {
         if(this.api.config.streamingMethod == "explod")
         {
            this.api.gfx.setStreaming(true,dofus.Constants.GFX_OBJECTS_PATH,dofus.Constants.GFX_GROUNDS_PATH);
         }
         this.api.gfx.setStreamingMethod(this.api.config.streamingMethod);
      }
      this.setQuality(this.OptionsManager.getOption("DefaultQuality"));
      this.autoLogon();
   }
   function quit(bAsk)
   {
      if(bAsk == undefined)
      {
         bAsk = true;
      }
      if(!bAsk)
      {
         if(System.capabilities.playerType == "StandAlone")
         {
            fscommand("quit","");
         }
         else
         {
            _root._loader.closeBrowserWindow();
         }
      }
      else
      {
         this.showMessage(undefined,this.api.lang.getText("DO_U_QUIT"),"CAUTION_YESNO",{name:"Quit"});
      }
   }
   function disconnect()
   {
      this.showMessage(undefined,this.api.lang.getText("DO_U_DISCONNECT"),"CAUTION_YESNO",{name:"Disconnect"});
   }
   function reboot()
   {
      this.api.network.disconnect(false,false);
      if(this.api.electron.enabled)
      {
         this.api.electron.reboot();
      }
      else
      {
         this.addToQueue({object:_root._loader,method:_root._loader.reboot});
      }
   }
   function getFlashVersion()
   {
      return Number(getVersion().split(" ")[1].split(",")[0]);
   }
   function setQuality(quality)
   {
      _root._quality = quality;
   }
   function setDisplayStyle(sStyle, bDontShowError)
   {
      var _loc4_;
      if(this.api.electron.enabled)
      {
         _loc4_ = sStyle == dofus.managers.OptionsManager.DISPLAY_STYLE_WIDESCREEN_PANELS;
         this.OptionsManager.setOption("EnableWidescreenPanels",_loc4_);
         return undefined;
      }
      var _loc5_;
      if(System.capabilities.playerType == "StandAlone" && System.capabilities.os.indexOf("Windows") != -1)
      {
         _loc5_ = new ank.external.display.ScreenResolution();
         switch(sStyle)
         {
            case "normal":
               _loc5_.disable();
               break;
            case "medium":
               _loc5_.addEventListener("onScreenResolutionError",this);
               _loc5_.addEventListener("onScreenResolutionSuccess",this);
               if(bDontShowError != true)
               {
                  _loc5_.addEventListener("onExternalError",this);
               }
               _loc5_.enable(800,600,32);
               break;
            case "maximized":
               _loc5_.addEventListener("onScreenResolutionError",this);
               _loc5_.addEventListener("onScreenResolutionSuccess",this);
               if(bDontShowError != true)
               {
                  _loc5_.addEventListener("onExternalError",this);
               }
               _loc5_.enable(1024,768,32);
         }
      }
      else
      {
         _root._loader.setDisplayStyle(sStyle);
      }
   }
   function onFastServerSwitchFail(sMessage)
   {
      dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST = undefined;
      if(sMessage == undefined)
      {
         return undefined;
      }
      this.api.kernel.showMessage(undefined,"Fast server switching failed : " + sMessage,"ERROR_BOX");
   }
   function onFastServerSwitchSuccess(sMessage)
   {
      dofus.Kernel.FAST_SWITCHING_SERVER_REQUEST = undefined;
      this.api.kernel.showMessage(undefined,"<b>(Fast server switch)</b> : Welcome on <b>" + this.api.datacenter.Basics.aks_current_server.label + "</b>","COMMANDS_CHAT");
   }
   function changeServer(bNotConfirm)
   {
      var _loc3_;
      var _loc4_;
      if(bNotConfirm == true)
      {
         _loc3_ = false;
         if(this.api.network.isConnected)
         {
            _loc4_ = this.api.datacenter.Basics.aks_current_server;
            if(_loc4_ != undefined)
            {
               _loc3_ = true;
               this.api.network.askCharacterSwitchTicket();
            }
         }
         if(!_loc3_)
         {
            this.api.network.disconnect(true,false,true);
         }
      }
      else
      {
         this.showMessage(undefined,this.api.lang.getText("DO_U_SWITCH_CHARACTER"),"CAUTION_YESNO",{name:"ChangeCharacter"});
      }
   }
   function showMessage(sTitle, sMsg, sType, oParams, sUniqId)
   {
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      switch(sType)
      {
         case "CAUTION_YESNO":
            if(sTitle == undefined)
            {
               sTitle = this.api.lang.getText("CAUTION");
            }
            _loc7_ = this.api.ui.loadUIComponent("AskYesNo","AskYesNo" + (oParams.name == undefined ? "" : oParams.name),{title:sTitle,text:sMsg,params:oParams.params},{bForceLoad:true});
            _loc7_.addEventListener("yes",oParams.listener != undefined ? oParams.listener : this);
            _loc7_.addEventListener("no",oParams.listener != undefined ? oParams.listener : this);
            break;
         case "CAUTION_YESNOIGNORE":
            if(sTitle == undefined)
            {
               sTitle = this.api.lang.getText("CAUTION");
            }
            _loc8_ = this.api.ui.loadUIComponent("AskYesNoIgnore","AskYesNoIgnore" + (oParams.name == undefined ? "" : oParams.name),{title:sTitle,text:sMsg,player:oParams.player,params:oParams.params},{bForceLoad:true});
            _loc8_.addEventListener("yes",oParams.listener != undefined ? oParams.listener : this);
            _loc8_.addEventListener("no",oParams.listener != undefined ? oParams.listener : this);
            _loc8_.addEventListener("ignore",oParams.listener != undefined ? oParams.listener : this);
            break;
         case "ERROR_BOX":
            if(sTitle == undefined)
            {
               sTitle = this.api.lang.getText("ERROR_WORD");
            }
            this.api.ui.loadUIComponent("AskOK","AskOK" + (oParams.name == undefined ? "" : oParams.name),{title:sTitle,text:sMsg,params:oParams.params},{bForceLoad:true});
            break;
         case "WAIT_BOX":
            if(sTitle == undefined)
            {
               sTitle = this.api.lang.getText("CHAT_LINK_WARNING");
            }
            this.api.ui.loadUIComponent("AskOKWait","AskOKWait",{title:sTitle,text:sMsg,params:oParams.params},{bForceLoad:true});
            break;
         case "INFO_CANCEL":
            if(sTitle == undefined)
            {
               sTitle = this.api.lang.getText("INFORMATIONS");
            }
            _loc9_ = this.api.ui.loadUIComponent("AskCancel","AskCancel" + (oParams.name == undefined ? "" : oParams.name),{title:sTitle,text:sMsg,params:oParams.params},{bForceLoad:true});
            _loc9_.addEventListener("cancel",oParams.listener != undefined ? oParams.listener : this);
            break;
         case "ERROR_CHAT":
            this.ChatManager.addText(sTitle != undefined ? "<b>" + sTitle + "</b> : " + sMsg : sMsg,dofus.Constants.ERROR_CHAT_COLOR,true,sUniqId);
            break;
         case "MESSAGE_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.MSG_CHAT_COLOR,true,sUniqId);
            break;
         case "EMOTE_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.EMOTE_CHAT_COLOR,true,sUniqId);
            break;
         case "THINK_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.THINK_CHAT_COLOR,true,sUniqId);
            break;
         case "INFO_FIGHT_CHAT":
            this.ChatManager.feMessagesBuffer.printAll();
            if(!this.api.kernel.OptionsManager.getOption("ChatEffects"))
            {
               return undefined;
            }
            break;
         case "INFO_CHAT":
            break;
         case "PVP_CHAT":
            sMsg = this.api.kernel.ChatManager.parseInlinePos(sMsg);
            this.ChatManager.addText(sMsg,dofus.Constants.PVP_CHAT_COLOR,true,sUniqId);
            break;
         case "WHISP_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.MSGCHUCHOTE_CHAT_COLOR,true,sUniqId);
            break;
         case "PARTY_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.GROUP_CHAT_COLOR,true,sUniqId);
            break;
         case "GUILD_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.GUILD_CHAT_COLOR,false,sUniqId);
            break;
         case "GUILD_CHAT_SOUND":
            this.ChatManager.addText(sMsg,dofus.Constants.GUILD_CHAT_COLOR,true,sUniqId);
            break;
         case "RECRUITMENT_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.RECRUITMENT_CHAT_COLOR,false,sUniqId);
            break;
         case "TRADE_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.TRADE_CHAT_COLOR,false,sUniqId);
            break;
         case "MEETIC_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.MEETIC_CHAT_COLOR,false,sUniqId);
            break;
         case "GAME_EVENTS_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.GAME_EVENTS_CHAT,false,sUniqId);
            break;
         case "HUNT_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.GAME_HUNT_CHAT,true,sUniqId);
            break;
         case "ADMIN_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.ADMIN_CHAT_COLOR,false,sUniqId);
            break;
         case "COMMANDS_CHAT":
            this.ChatManager.addText(sMsg,dofus.Constants.COMMANDS_CHAT_COLOR,false,sUniqId);
            break;
         case "DEBUG_LOG":
            this.api.datacenter.Basics.aks_a_logs += "\n<font color=\"#FFFFFF\">" + sMsg + "</font>";
            _loc10_ = dofus.graphics.gapi.ui.Debug(this.api.ui.getUIComponent("Debug"));
            if(_loc10_ != undefined)
            {
               _loc10_.refresh();
            }
            break;
         case "DEBUG_ERROR":
            this.api.datacenter.Basics.aks_a_logs += "\n<font color=\"#FF0000\">" + sMsg + "</font>";
            _loc11_ = dofus.graphics.gapi.ui.Debug(this.api.ui.getUIComponent("Debug"));
            if(_loc11_ != undefined)
            {
               _loc11_.refresh();
            }
            break;
         case "DEBUG_INFO":
            this.api.datacenter.Basics.aks_a_logs += "\n<font color=\"#00FF00\">" + sMsg + "</font>";
            _loc12_ = dofus.graphics.gapi.ui.Debug(this.api.ui.getUIComponent("Debug"));
            if(_loc12_ != undefined)
            {
               _loc12_.refresh();
            }
         default:
            return;
      }
      this.ChatManager.addText(sMsg,dofus.Constants.INFO_CHAT_COLOR,true,sUniqId);
   }
   function manualLogon()
   {
      this.initLogon();
      this.addToQueue({object:this.api.ui,method:this.api.ui.loadUIComponent,params:["Login","Login",{language:this.api.config.language,canAutoLogOn:false},{bStayIfPresent:true}]});
      this.addToQueue({object:_root._loader,method:_root._loader.onCoreDisplayed});
   }
   function autoLogon()
   {
      this.initLogon();
      this.addToQueue({object:this.api.ui,method:this.api.ui.loadUIComponent,params:["Login","Login",{language:this.api.config.language,canAutoLogOn:true},{bStayIfPresent:true}]});
      this.addToQueue({object:_root._loader,method:_root._loader.onCoreDisplayed});
   }
   function initLogon()
   {
      this.api.electron.setInitialized();
      this.api.electron.updateWindowTitle();
      this.api.electron.setLoginDiscordActivity();
      this.api.ui.loadUIComponent("MainMenu","MainMenu",{quitMode:(!(System.capabilities.playerType == "PlugIn" && !this.api.electron.enabled) ? "quit" : "no")},{bStayIfPresent:true,bAlwaysOnTop:true});
   }
   function askClearCache()
   {
      this.showMessage(undefined,this.api.lang.getText("DO_U_CLEAR_CACHE"),"CAUTION_YESNO",{name:"ClearCache"});
   }
   function clearCache()
   {
      _root._loader.clearCache();
      this.reboot();
   }
   function findMovieClipPath()
   {
      var _loc2_;
      if(this.api.ui.getUIComponent("Dragger") != undefined)
      {
         this.api.ui.unloadUIComponent("Dragger");
      }
      else
      {
         _loc2_ = this.api.ui.loadUIComponent("Dragger","Dragger",undefined,{bForceLoad:true,bAlwaysOnTop:true});
         _loc2_.api = this.api;
         _loc2_.onRelease = function()
         {
            this.stopDrag();
            this.api.network.Basics.onAuthorizedCommand(true,"2|0||" + new ank.utils.ExtendedString(this._dropTarget).replace("/","."));
            this.startDrag(true);
         };
         _loc2_.startDrag(true);
      }
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoQuit":
            this.quit(false);
            break;
         case "AskYesNoDisconnect":
            this.api.electron.retroChatClear();
            this.api.network.disconnect(false,false);
            break;
         case "AskYesNoChangeCharacter":
            this.changeServer(true);
            break;
         case "AskYesNoClearCache":
            this.clearCache();
         default:
            return;
      }
   }
   function onInitAndLoginFinished()
   {
      this.MapsServersManager.initialize(this.api);
      this.DocumentsServersManager.initialize(this.api);
      this.TutorialServersManager.initialize(this.api);
      this.AreasManager.initialize(this.api);
      this.AdminManager.initialize(this.api);
      var _loc2_ = this.api.lang.getTimeZoneText();
      this.NightManager.initialize(_loc2_.tz.slice(),_loc2_.m.slice(),_loc2_.z,this.api.gfx);
      this.api.kernel.KeyManager.onSetChange(this.api.kernel.OptionsManager.getOption("ShortcutSet"));
      this.XTRA_LANG_FILES_LOADED = true;
      this.api.network.Account.sendConfiguredPort();
      this.api.network.Account.sendIdentity();
      this.api.network.Account.getServersList();
   }
   function onScreenResolutionError(oEvent)
   {
      var _loc3_ = ank.external.display.ScreenResolution(oEvent.target);
      _loc3_.removeListeners();
   }
   function onScreenResolutionSuccess(oEvent)
   {
      var _loc3_ = ank.external.display.ScreenResolution(oEvent.target);
      _loc3_.removeListeners();
   }
   function onExternalError(oEvent)
   {
   }
}
