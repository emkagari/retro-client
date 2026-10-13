class dofus.graphics.gapi.ui.Debug extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnClear;
   var _btnClose;
   var _btnCopy;
   var _btnMinimize;
   var _cLogs;
   var _fps;
   var _lblPrompt;
   var _nRefreshVisuallyTimeout;
   var _parent;
   var _sCommand;
   var _srCommandLineBack;
   var _srLogsBack;
   var _tiCommandLine;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var initialized;
   var unloadThis;
   static var _nAutoCompleteTimeout;
   static var CONSOLE_MEDIUM = 0;
   static var CONSOLE_MINIMIZED = 1;
   static var CONSOLE_MAXSIZE = 2;
   static var CLASS_NAME = "Debug";
   static var MIDDLE_SIZE = 200;
   static var BIG_SIZE = 370;
   static var FILE_OUTPUT_STATE = 0;
   function Debug()
   {
      super();
   }
   function set tiCommandLine(sText_)
   {
      this._tiCommandLine.text = sText_;
   }
   function setPrompt(sPrompt)
   {
      if(this._lblPrompt.text == undefined)
      {
         return undefined;
      }
      this._lblPrompt.text = sPrompt + " > ";
      this._tiCommandLine._x = this._lblPrompt._x + this._lblPrompt.textWidth + 2;
      this._lblPrompt.setPreferedSize("left");
   }
   function setLogsText(sLogs)
   {
      if(this._cLogs.text == undefined)
      {
         return undefined;
      }
      this._cLogs.text = sLogs;
   }
   function set command(sCommand)
   {
      this._sCommand = sCommand;
      if(this.initialized)
      {
         this.initCommand();
      }
   }
   function refresh()
   {
      if(this._nRefreshVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nRefreshVisuallyTimeout);
      }
      var _loc2_ = _global.setTimeout(this,"realRefresh",dofus.Constants.DELAYED_DEBUG_CONSOLE_VISUAL_REFRESH);
      this._nRefreshVisuallyTimeout = _loc2_;
   }
   function realRefresh()
   {
      this.initData(true);
   }
   function clear()
   {
      this.api.datacenter.Basics.aks_a_logs = "";
      this.setLogsText("");
   }
   function showFps()
   {
      if(this._fps == undefined)
      {
         this.attachMovie("fpsWindow","_fps",this.getNextHighestDepth(),{_x:96,_y:140});
      }
      else
      {
         this._fps.removeMovieClip();
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Debug.CLASS_NAME);
   }
   function destroy()
   {
      this.api.datacenter.Basics.aks_debug_command_line = this._tiCommandLine.text;
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.applySizeIndex});
      this.addToQueue({object:this,method:this.initCommand});
      this.addToQueue({object:this,method:this.listenFocus});
   }
   function listenFocus()
   {
      this._tiCommandLine.onSetFocus = function()
      {
         this._parent.onSetFocus();
      };
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnClear.addEventListener("click",this);
      this._btnCopy.addEventListener("click",this);
      this._btnMinimize.addEventListener("click",this);
      this._cLogs.addEventListener("href",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initFocus()
   {
      this._tiCommandLine.setFocus();
   }
   function initData(bRefresh)
   {
      if(bRefresh == undefined)
      {
         bRefresh = false;
      }
      if(this._cLogs.text == undefined)
      {
         return undefined;
      }
      this._cLogs.text = this.api.datacenter.Basics.aks_a_logs;
      this.setPrompt(this.api.datacenter.Basics.aks_a_prompt);
      if(!bRefresh)
      {
         this._tiCommandLine.text = this.api.datacenter.Basics.aks_debug_command_line;
      }
   }
   function initCommand()
   {
      this._tiCommandLine.text = this._sCommand;
      this.initFocus();
      this.addToQueue({objet:this,method:this.placeCursorAtTheEnd});
   }
   function placeCursorAtTheEnd()
   {
      this._tiCommandLine.setFocus();
      Selection.setSelection(this._tiCommandLine.text.length,1000);
   }
   function applySizeIndex(bSetFocus)
   {
      if(bSetFocus == undefined)
      {
         bSetFocus = true;
      }
      switch(this.api.kernel.OptionsManager.getOption("DebugSizeIndex"))
      {
         case 0:
            this.maximize(dofus.graphics.gapi.ui.Debug.MIDDLE_SIZE);
            break;
         case 1:
            this.minimize();
            break;
         case 2:
            this.maximize(dofus.graphics.gapi.ui.Debug.BIG_SIZE);
      }
      if(bSetFocus)
      {
         this.initFocus();
      }
   }
   function minimize()
   {
      this._cLogs._visible = false;
      this._srLogsBack.setSize(undefined,20);
      this._srCommandLineBack._y = this._tiCommandLine._y = this._lblPrompt._y = this._cLogs._y;
   }
   function maximize(nHeight)
   {
      this._cLogs._visible = true;
      this._cLogs.setSize(undefined,nHeight);
      this._srLogsBack.setSize(undefined,nHeight + 20);
      this._srCommandLineBack._y = this._tiCommandLine._y = this._lblPrompt._y = this._cLogs._y + nHeight;
   }
   function onSetFocus()
   {
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   static function doConsoleHistoryUp(api)
   {
      var _loc3_ = dofus.graphics.gapi.ui.Debug(api.ui.getUIComponent("Debug"));
      var _loc4_ = api.kernel.DebugConsole.getHistoryUp().value;
      if(_loc3_ != undefined)
      {
         _loc3_._tiCommandLine.text = _loc4_;
         _loc3_.addToQueue({object:_loc3_,method:_loc3_.placeCursorAtTheEnd});
      }
      api.electron.retroConsoleSetPromptText(_loc4_);
   }
   static function doConsoleHistoryDown(api)
   {
      var _loc3_ = dofus.graphics.gapi.ui.Debug(api.ui.getUIComponent("Debug"));
      var _loc4_ = api.kernel.DebugConsole.getHistoryDown().value;
      if(_loc3_ != undefined)
      {
         _loc3_._tiCommandLine.text = _loc4_;
         _loc3_.addToQueue({object:_loc3_,method:_loc3_.placeCursorAtTheEnd});
      }
      api.electron.retroConsoleSetPromptText(_loc4_);
   }
   static function askShowAutoCompleteResult(api, sText)
   {
      Selection.setFocus(null);
      if(dofus.graphics.gapi.ui.Debug._nAutoCompleteTimeout != undefined)
      {
         _global.clearTimeout(dofus.graphics.gapi.ui.Debug._nAutoCompleteTimeout);
      }
      var _loc4_ = _global.setTimeout(api.kernel.DebugConsole,"doConsoleAutoComplete",100,api,sText);
      dofus.graphics.gapi.ui.Debug._nAutoCompleteTimeout = _loc4_;
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(sShortcut)
      {
         case "HISTORY_UP":
            if(this.isFocused())
            {
               dofus.graphics.gapi.ui.Debug.doConsoleHistoryUp(this.api);
               _loc3_ = false;
            }
            break;
         case "HISTORY_DOWN":
            if(this.isFocused())
            {
               dofus.graphics.gapi.ui.Debug.doConsoleHistoryDown(this.api);
               _loc3_ = false;
            }
            break;
         case "AUTOCOMPLETE":
            if(this.isFocused())
            {
               dofus.graphics.gapi.ui.Debug.askShowAutoCompleteResult(this.api,this._tiCommandLine.text);
               _loc3_ = false;
            }
            break;
         case "TEAM_MESSAGE":
            if(this.isFocused())
            {
               _loc4_ = this.api.kernel.OptionsManager.getOption("DebugSizeIndex") + 1;
               _loc4_ %= 3;
               this.api.kernel.OptionsManager.setOption("DebugSizeIndex",_loc4_);
               this.applySizeIndex();
            }
            break;
         case "ACCEPT_CURRENT_DIALOG":
            if(this.isFocused())
            {
               _loc5_ = new ank.utils.ExtendedString(this._tiCommandLine.text).trim().toString();
               if(_loc5_.length == 0)
               {
                  if(this.api.electron.isShowingWidescreenPanel)
                  {
                     _loc3_ = false;
                     this.api.electron.focusWidescreenPanelIfPossible();
                  }
                  break;
               }
               _loc3_ = false;
               if(this._tiCommandLine.text != undefined)
               {
                  this._tiCommandLine.text = "";
               }
               this.api.kernel.DebugConsole.process(_loc5_);
            }
            else
            {
               _loc6_ = dofus.graphics.gapi.ui.Banner(this.gapi.getUIComponent("Banner"));
               if(Selection.getFocus() != undefined && !(_loc6_ != undefined && (_loc6_.isChatFocus() && !_loc6_.chatInputHasText())))
               {
                  break;
               }
               _loc3_ = false;
               this._tiCommandLine.setFocus();
            }
      }
      return _loc3_;
   }
   function isFocused()
   {
      return this._tiCommandLine.focused;
   }
   function commandInputHasText()
   {
      return this._tiCommandLine.text != undefined && this._tiCommandLine.text != "";
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnClear:
            this.clear();
            break;
         case this._btnCopy:
            System.setClipboard(this._cLogs.text);
            break;
         case this._btnMinimize:
            this.changeSize();
         default:
            return;
      }
   }
   function changeSize()
   {
      var _loc2_ = this.api.kernel.OptionsManager.getOption("DebugSizeIndex") + 1;
      _loc2_ %= 3;
      this.api.kernel.OptionsManager.setOption("DebugSizeIndex",_loc2_);
      this.applySizeIndex();
   }
   function href(oEvent, api)
   {
      dofus.graphics.gapi.ui.Debug.onHref(oEvent,this.api);
   }
   static function onHref(oEvent, api, oCustomPopupPosition)
   {
      var _loc5_ = oEvent.params.split(",");
      var _loc6_ = String(_loc5_.shift());
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
      switch(_loc6_)
      {
         case "AppendReportPenal":
            _loc7_ = dofus.graphics.gapi.ui.MakeReport(api.ui.getUIComponent("MakeReport"));
            if(_loc7_ == undefined)
            {
               api.kernel.showMessage(undefined,"MakeReport UI not found","COMMANDS_CHAT");
            }
            else
            {
               _loc8_ = api.datacenter.Temporary.Report;
               _loc9_ = _global.unescape(_loc5_[0]);
               if(_loc8_.penal == undefined)
               {
                  _loc8_.penal = _loc9_;
               }
               else
               {
                  _loc8_.penal += "\n" + _loc9_;
               }
               _loc7_.update(true);
            }
            break;
         case "AppendReportDescription":
            _loc10_ = dofus.graphics.gapi.ui.MakeReport(api.ui.getUIComponent("MakeReport"));
            if(_loc10_ == undefined)
            {
               api.kernel.showMessage(undefined,"MakeReport UI not found","COMMANDS_CHAT");
            }
            else
            {
               _loc11_ = api.datacenter.Temporary.Report;
               _loc12_ = _global.unescape(_loc5_[0]);
               if(_loc11_.description == undefined)
               {
                  _loc11_.description = _loc12_;
               }
               else
               {
                  _loc11_.description += "\n" + _loc12_;
               }
               _loc10_.update(true);
            }
            break;
         case "AppendReportComplementary":
            _loc13_ = dofus.graphics.gapi.ui.MakeReport(api.ui.getUIComponent("MakeReport"));
            if(_loc13_ == undefined)
            {
               api.kernel.showMessage(undefined,"MakeReport UI not found","COMMANDS_CHAT");
            }
            else
            {
               _loc14_ = api.datacenter.Temporary.Report;
               _loc15_ = _global.unescape(_loc5_[0]);
               if(_loc14_.complementary == undefined)
               {
                  _loc14_.complementary = _loc15_;
               }
               else
               {
                  _loc14_.complementary += "\n" + _loc15_;
               }
               _loc13_.update(true);
            }
            break;
         case "ShowPlayerPopupMenu":
            if(api.datacenter.Basics.inGame)
            {
               api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerID:_global.unescape(_loc5_[0]),sPlayerName:_global.unescape(_loc5_[1]),oCustomPopupPosition:oCustomPopupPosition});
            }
            break;
         case "ExecCmd":
            _loc16_ = _loc5_.shift() == "true";
            _loc17_ = _global.unescape(_loc5_.join(","));
            if(_loc16_)
            {
               api.kernel.AdminManager.sendCommand(_loc17_);
            }
            else
            {
               api.kernel.AdminManager.prepareCommand(_loc17_);
            }
         default:
            return;
      }
   }
}
