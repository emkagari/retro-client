class dofus.aks.Basics extends dofus.aks.Handler
{
   var aks;
   var api;
   var nReferenceTime;
   static var MULTIPLE_ADMIN_COMMANDS_SPLIT_STR = " ; ";
   function Basics(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function get lastReceivedReferenceTime()
   {
      return this.nReferenceTime;
   }
   function autorisedCommand(sCommand)
   {
      this.aks.send("BA" + sCommand,false,undefined,true);
   }
   function autorisedMoveCommand(nX, nY)
   {
      this.aks.send("BaM" + nX + "," + nY,false);
   }
   function autorisedKickCommand(sPlayerName, nTempo, sMessage)
   {
      this.aks.send("BaK" + sPlayerName + "|" + nTempo + "|" + sMessage,false);
   }
   function whoAmI()
   {
      this.whoIs("");
   }
   function whoIs(sName)
   {
      this.aks.send("BW" + sName);
   }
   function kick(nCellNum)
   {
      this.aks.send("BQ" + nCellNum,false);
   }
   function away()
   {
      this.aks.send("BYA",false);
   }
   function invisible()
   {
      this.aks.send("BYI",false);
   }
   function getDate()
   {
      this.aks.send("BD",false);
   }
   function fileCheckAnswer(nCheckID, nFileSize)
   {
      this.aks.send("BC" + nCheckID + ";" + nFileSize,false);
   }
   function sanctionMe(nSanctionID, nWordID)
   {
      this.aks.send("BK" + nSanctionID + "|" + nWordID,false);
   }
   function averagePing()
   {
      this.aks.send("Bp" + this.api.network.getAveragePing() + "|" + this.api.network.getAveragePingPacketsCount() + "|" + this.api.network.getAveragePingBufferSize(),false);
   }
   function askReportInfos(nStep, sTargets, bAllAccounts)
   {
      this.aks.send("Br" + nStep + "|" + sTargets + "|" + (!bAllAccounts ? "0" : "1"),false,undefined,true);
   }
   function onReportInfos(sExtraData)
   {
      var _loc3_ = this.api.datacenter.Temporary.Report;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      var _loc4_ = sExtraData.charAt(0);
      var _loc5_ = sExtraData.substring(1);
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      switch(_loc4_)
      {
         case "t":
            _loc6_ = _loc5_.split("|");
            if(_loc3_.targetAccountPseudo == undefined)
            {
               _loc3_.targetAccountPseudo = _loc6_[0];
               _loc3_.targetAccountId = _loc6_[1];
            }
            break;
         case "s":
            if(_loc3_.sanctionnatedAccounts == undefined)
            {
               _loc3_.sanctionnatedAccounts = _loc5_;
            }
            else
            {
               _loc3_.sanctionnatedAccounts += "\n\n" + _loc5_;
            }
            break;
         case "p":
            _loc3_.penal = _loc5_;
            break;
         case "f":
            _loc3_.findAccounts = _loc5_;
            break;
         case "#":
            this.api.ui.unloadUIComponent("FightsInfos");
            _loc7_ = dofus.graphics.gapi.ui.MakeReport(this.api.ui.getUIComponent("MakeReport"));
            if(_loc7_ == undefined)
            {
               _loc8_ = _loc3_.targetPseudos;
               _loc9_ = _loc3_.reason;
               _loc10_ = _loc3_.description;
               _loc11_ = _loc3_.complementary;
               _loc12_ = _loc3_.jailDialog;
               _loc13_ = _loc3_.isAllAccounts;
               _loc14_ = _loc3_.penal;
               _loc15_ = _loc3_.findAccounts;
               _loc3_.description = undefined;
               _loc3_.complementary = undefined;
               _loc3_.penal = undefined;
               _loc3_.findAccounts = undefined;
               this.api.ui.loadUIComponent("MakeReport","MakeReport",{targetPseudos:_loc8_,reason:_loc9_,description:_loc10_,complementary:_loc11_,jailDialog:_loc12_,isAllAccounts:_loc13_,penal:_loc14_,findAccounts:_loc15_});
               _loc16_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
               if(_loc16_ != undefined)
               {
                  _loc16_.chat.open(true);
               }
            }
            else
            {
               _loc7_.update(true);
            }
         default:
            return;
      }
   }
   function onPopupMessage(sExtraData)
   {
      var _loc3_ = sExtraData;
      if(_loc3_ != undefined && _loc3_.length > 0)
      {
         this.api.kernel.showMessage(undefined,_loc3_,"WAIT_BOX");
      }
   }
   function onAuthorizedInterfaceOpen(sExtraData)
   {
      this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("A_GIVE_U_RIGHTS",[sExtraData]),"ERROR_BOX");
      this.api.datacenter.Player.isAuthorized = true;
   }
   function onAuthorizedInterfaceClose(sExtraData)
   {
      this.api.ui.unloadUIComponent("Debug");
      this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("A_REMOVE_U_RIGHTS",[sExtraData]),"ERROR_BOX");
      this.api.datacenter.Player.isAuthorized = false;
   }
   function getAppendReportComplementaryLink(sCommand)
   {
      return "<a href=\"asfunction:onHref,AppendReportComplementary," + _global.escape(sCommand) + "\">" + "<font color=\"#f542e3\"><b>[Append To Current ModReport Complementary Infos]</b></font>" + "</a>";
   }
   function getAppendReportDescriptionLink(sCommand)
   {
      return "<a href=\"asfunction:onHref,AppendReportDescription," + _global.escape(sCommand) + "\">" + "<font color=\"#f542e3\"><b>[Append To Current ModReport Description]</b></font>" + "</a>";
   }
   function getAppendReportPenalLink(sCommand)
   {
      return "<a href=\"asfunction:onHref,AppendReportPenal," + _global.escape(sCommand) + "\">" + "<font color=\"#f542e3\"><b>[Append To Current ModReport Penal]</b></font>" + "</a>";
   }
   function onAutorizedCommandBuildGridObject(sGridData)
   {
      var _loc3_ = {};
      var _loc4_ = sGridData.split("");
      var _loc5_ = _loc4_[0];
      if(_loc5_.length > 0)
      {
         _loc5_ = new ank.utils.ExtendedString(_loc5_).replace("","|");
         _loc3_.beforeGridText = this.api.kernel.DebugManager.getFormattedMessage(_loc5_,"") + "<br/>";
      }
      var _loc6_ = _loc4_[1];
      if(_loc6_.length > 0)
      {
         _loc6_ = new ank.utils.ExtendedString(_loc6_).replace("","|");
         _loc3_.afterGridText = "<br/>" + this.api.kernel.DebugManager.getFormattedMessage(_loc6_,"");
      }
      var _loc7_ = _loc4_[2].split("");
      var _loc8_ = [];
      var _loc9_ = [];
      var _loc10_ = 0;
      var _loc11_;
      while(_loc10_ < _loc7_.length)
      {
         _loc11_ = _loc7_[_loc10_];
         _loc11_ = new ank.utils.ExtendedString(_loc11_).replace("","|");
         _loc8_.push(_loc11_);
         _loc10_ = _loc10_ + 1;
      }
      var _loc12_ = new ank.utils.ExtendedString(_loc4_[3]).externalInterfaceEscape();
      var _loc13_ = this.api.kernel.DebugManager.getFormattedMessage(_loc12_,"").split("");
      var _loc15_ = 0;
      var _loc14_;
      while(_loc15_ < _loc13_.length)
      {
         if(_loc15_ % _loc8_.length == 0)
         {
            if(_loc14_ != undefined)
            {
               _loc9_.push(_loc14_);
            }
            _loc14_ = [];
         }
         _loc14_.push(_loc13_[_loc15_]);
         _loc15_ = _loc15_ + 1;
      }
      if(_loc14_ != undefined)
      {
         _loc9_.push(_loc14_);
      }
      _loc3_.columns = _loc8_;
      _loc3_.entries = _loc9_;
      return _loc3_;
   }
   function onAuthorizedCommand(bSuccess, sExtraData)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      if(bSuccess)
      {
         _loc4_ = dofus.graphics.gapi.ui.Debug(this.api.ui.getUIComponent("Debug"));
         if(_loc4_ == undefined && (dofus.graphics.gapi.ui.Debug.FILE_OUTPUT_STATE < 2 && !(this.api.electron.isShowingWidescreenPanel && this.api.electron.getWidescreenPanelId() == dofus.Electron.WIDESCREEN_PANEL_CONSOLE)))
         {
            this.api.ui.loadUIComponent("Debug","Debug",undefined,{bStayIfPresent:true,bAlwaysOnTop:true});
         }
         _loc5_ = dofus.graphics.gapi.ui.Debug.FILE_OUTPUT_STATE;
         _loc6_ = sExtraData.split("|");
         _loc7_ = Number(_loc6_[0]);
         if(_loc7_ == 4)
         {
            if(this.api.electron.enabled)
            {
               _loc8_ = _loc6_[1];
            }
            _loc6_.splice(0,2);
            _loc7_ = Number(_loc6_[0].substring(3));
         }
         _loc9_ = Number(_loc6_[1]);
         _loc10_ = _loc6_[2];
         _loc6_.splice(0,3);
         _loc11_ = _loc6_.join("|");
         if(_loc7_ == undefined || (_loc9_ == undefined || (_loc10_ == undefined || _loc11_ == undefined)))
         {
            this.api.kernel.showMessage(undefined,"Erreur de protocole","DEBUG_ERROR");
            _loc12_ = 0;
            while(_loc12_ < _loc6_.length)
            {
               this.api.kernel.showMessage(undefined,_loc12_ + " : " + _loc6_[_loc12_],"DEBUG_ERROR");
               _loc12_ = _loc12_ + 1;
            }
            return undefined;
         }
         _loc13_ = "DEBUG_LOG";
         switch(_loc7_)
         {
            case 1:
               _loc13_ = "DEBUG_ERROR";
               break;
            case 2:
               _loc13_ = "DEBUG_INFO";
         }
         _loc11_ = this.api.kernel.DebugManager.getFormattedMessage(_loc11_,"");
         if(this.api.electron.enabled)
         {
            if(_loc10_.length > 0 && _loc9_ > 0)
            {
               _loc14_ = this.api.datacenter.Temporary.Report;
               if(_loc14_ != undefined)
               {
                  _loc15_ = this.api.kernel.AdminManager.pendingModReportAppendCommands;
                  if(_loc15_ != undefined)
                  {
                     _loc16_ = _loc15_.length - 1;
                     while(_loc16_ >= 0)
                     {
                        _loc17_ = _loc15_[_loc16_];
                        if(_loc17_.command == _loc10_)
                        {
                           _loc18_ = false;
                           _loc19_ = _loc17_.types;
                           if(_loc19_.length > 0)
                           {
                              _loc20_ = this.api.electron.getXmlEscapedString(this.api.electron.getHtmlStrippedString(_loc11_));
                              _loc21_ = 0;
                              while(_loc21_ < _loc19_.length)
                              {
                                 switch(_loc19_[_loc21_])
                                 {
                                    case 1:
                                       _loc18_ = true;
                                       if(_loc14_.description == undefined)
                                       {
                                          _loc14_.description = _loc20_;
                                       }
                                       else
                                       {
                                          _loc14_.description += "\n" + _loc20_;
                                       }
                                       break;
                                    case 2:
                                       _loc18_ = true;
                                       if(_loc14_.complementary == undefined)
                                       {
                                          _loc14_.complementary = _loc20_;
                                       }
                                       else
                                       {
                                          _loc14_.complementary += "\n" + _loc20_;
                                       }
                                 }
                                 _loc21_ = _loc21_ + 1;
                              }
                              if(_loc18_)
                              {
                                 _loc15_.splice(_loc16_,1);
                                 _loc22_ = dofus.graphics.gapi.ui.MakeReport(this.api.ui.getUIComponent("MakeReport"));
                                 if(_loc22_ != undefined)
                                 {
                                    _loc22_.update(false);
                                 }
                                 return undefined;
                              }
                           }
                        }
                        _loc16_ = _loc16_ - 1;
                     }
                  }
               }
            }
            if(_loc8_ != undefined)
            {
               _loc23_ = this.onAutorizedCommandBuildGridObject(_loc8_);
            }
            if(!_global.isNaN(_loc9_) && _loc9_ > 0)
            {
               if(_loc9_ == 1)
               {
                  _loc25_ = this.api.electron.getXmlEscapedString(this.api.electron.getHtmlStrippedString(_loc11_));
                  _loc24_ = "<br/>" + this.getAppendReportDescriptionLink(_loc25_) + " " + this.getAppendReportComplementaryLink(_loc25_);
                  _loc11_ += _loc24_;
               }
               else if(_loc9_ == 2)
               {
                  _loc26_ = this.api.electron.getXmlEscapedString(this.api.electron.getHtmlStrippedString(_loc11_));
                  _loc24_ = "<br/>" + this.getAppendReportPenalLink(_loc26_);
                  _loc11_ += _loc24_;
               }
               if(_loc24_ != undefined && _loc23_ != undefined)
               {
                  if(_loc23_.afterGridText != undefined)
                  {
                     _loc23_.afterGridText += _loc24_;
                  }
                  else
                  {
                     _loc23_.afterGridText = _loc24_;
                  }
               }
            }
            _loc27_ = new ank.utils.ExtendedString(_loc11_).externalInterfaceEscape();
            this.api.electron.consolePrint(_loc27_,_loc13_,_loc23_,true);
            if(_loc5_ != 0)
            {
               this.api.electron.consoleLog(_loc13_,_loc27_,true);
               if(_loc5_ == 2)
               {
                  return undefined;
               }
            }
         }
         if(!this.api.electron.isShowingWidescreenPanel || this.api.electron.getWidescreenPanelId() != dofus.Electron.WIDESCREEN_PANEL_CONSOLE)
         {
            this.api.kernel.showMessage(undefined,_loc11_,_loc13_);
         }
         if(dofus.Constants.SAVING_THE_WORLD)
         {
            if(_loc11_.indexOf("BotKick inactif") == 0)
            {
               dofus.SaveTheWorld.getInstance().nextAction();
            }
         }
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("UNKNOW_COMMAND",["/a"]),"ERROR_CHAT");
      }
   }
   function onAuthorizedCommandPrompt(sExtraData)
   {
      if(sExtraData == undefined || sExtraData.length == 0)
      {
         return undefined;
      }
      this.api.datacenter.Basics.aks_a_prompt = sExtraData;
      this.api.electron.retroConsoleSetHeaderLabel(sExtraData);
      this.api.ui.getUIComponent("Debug").setPrompt(sExtraData);
   }
   function onAuthorizedCommandClear()
   {
      this.api.ui.getUIComponent("Debug").clear();
   }
   function onAuthorizedCommandsListing(sExtraData)
   {
      this.api.datacenter.Basics.allowedAdminCommands = sExtraData.split("|");
   }
   function onAuthorizedLine(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = _loc3_[2];
      var _loc7_ = this.api.datacenter.Basics.aks_a_logs.split("<br/>");
      var _loc8_ = "<font color=\"#FFFFFF\">" + _loc6_ + "</font>";
      switch(_loc5_)
      {
         case 1:
            _loc8_ = "<font color=\"#FF0000\">" + _loc6_ + "</font>";
            break;
         case 2:
            _loc8_ = "<font color=\"#00FF00\">" + _loc6_ + "</font>";
      }
      if(!_global.isNaN(_loc4_) && _loc4_ < _loc7_.length)
      {
         _loc7_[_loc7_.length - _loc4_] = _loc8_;
         this.api.datacenter.Basics.aks_a_logs = _loc7_.join("<br/>");
         this.api.ui.getUIComponent("Debug").refresh();
      }
   }
   function onReferenceTime(sExtraData)
   {
      var _loc3_ = Number(sExtraData);
      this.nReferenceTime = _loc3_;
   }
   function onDate(sExtraData)
   {
      this.api.datacenter.Basics.lastDateUpdate = getTimer();
      var _loc3_ = sExtraData.split("|");
      this.api.kernel.NightManager.setReferenceDate(Number(_loc3_[0]),Number(_loc3_[1]),Number(_loc3_[2]));
   }
   function onWhoIs(bSuccess, sExtraData)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(bSuccess)
      {
         _loc4_ = sExtraData.split("|");
         if(_loc4_.length != 4)
         {
            return undefined;
         }
         _loc5_ = _loc4_[0];
         _loc6_ = _loc4_[1];
         _loc7_ = _loc4_[2];
         _loc8_ = Number(_loc4_[3]) == -1 ? this.api.lang.getText("UNKNOWN_AREA") : this.api.lang.getMapAreaText(Number(_loc4_[3])).n;
         if(_loc5_.toLowerCase() == this.api.datacenter.Basics.login)
         {
            switch(_loc6_)
            {
               case "1":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("I_AM_IN_SINGLE_GAME",[_loc7_,_loc5_,_loc8_]),"COMMANDS_CHAT");
                  break;
               case "2":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("I_AM_IN_GAME",[_loc7_,_loc5_,_loc8_]),"COMMANDS_CHAT");
            }
         }
         else
         {
            switch(_loc6_)
            {
               case "1":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("IS_IN_SINGLE_GAME",[_loc7_,_loc5_,_loc8_]) + "\n" + this.api.lang.getText("DATE") + " : " + this.api.kernel.NightManager.date + " - " + this.api.kernel.NightManager.time,"COMMANDS_CHAT");
                  break;
               case "2":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("IS_IN_GAME",[_loc7_,_loc5_,_loc8_]) + "\n" + this.api.lang.getText("DATE") + " : " + this.api.kernel.NightManager.date + " - " + this.api.kernel.NightManager.time,"COMMANDS_CHAT");
            }
         }
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_FIND_ACCOUNT_OR_CHARACTER",[sExtraData]),"ERROR_CHAT");
      }
   }
   function onFileCheck(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1];
      if(_loc5_.indexOf("bright.swf") == 0)
      {
         this.api.network.send("BC" + _loc4_ + ";-1",false);
         sExtraData = _loc5_.substr(10);
         this.onBrightCell(sExtraData);
      }
      else
      {
         dofus.utils.Api.getInstance().checkFileSize(_loc5_,_loc4_);
      }
   }
   function onBrightCell(sExtraData)
   {
      var _loc3_ = sExtraData.split("/");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc4_ == 0)
      {
         this.api.gfx.unSelect(true);
      }
      else if(sExtraData.charAt(0) == "-")
      {
         _loc5_ = _loc3_[0].substr(1).split(".");
         this.api.gfx.unSelect(false,_loc5_,"brightedPosition");
      }
      else
      {
         _loc6_ = _loc3_[0].split(".");
         _loc7_ = _global.parseInt(_loc3_[1],16);
         this.api.gfx.select(_loc6_,_loc7_,"brightedPosition");
      }
   }
   function onAveragePing(sExtraData)
   {
      this.averagePing();
   }
   function onSubscriberRestriction(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_;
      if(_loc3_)
      {
         _loc4_ = Number(sExtraData.substr(1));
         if(_loc4_ != 10)
         {
            this.api.ui.loadUIComponent("PayZoneDialog2","PayZoneDialog2",{dialogID:_loc4_,name:"El Pemy",gfx:"9059"});
         }
         else
         {
            this.api.ui.loadUIComponent("PayZone","PayZone",{dialogID:_loc4_},{bForceLoad:true});
            this.api.datacenter.Basics.payzone_isFirst = false;
         }
      }
      else
      {
         this.api.ui.unloadUIComponent("PayZone");
      }
   }
}
