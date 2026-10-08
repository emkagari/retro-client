class dofus.managers.ChatManager extends dofus.utils.ApiElement
{
   var _aBlacklist;
   var _aItemsBuffer;
   var _aMessages;
   var _aRawMessages;
   var _feMessagesBuffer;
   var _nMessageCounterInfo;
   var _nRefreshVisuallyTimeout;
   var _oCensorDictionnary;
   static var _sSelf = null;
   static var TYPE_INFOS = 0;
   static var TYPE_ERRORS = 1;
   static var TYPE_MESSAGES = 2;
   static var TYPE_WISP = 3;
   static var TYPE_GUILD = 4;
   static var TYPE_PVP = 5;
   static var TYPE_RECRUITMENT = 6;
   static var TYPE_TRADE = 7;
   static var TYPE_MEETIC = 8;
   static var TYPE_ADMIN = 9;
   static var TYPE_GAME_EVENTS = 10;
   static var MAX_ALL_LENGTH = 150;
   static var MAX_RAW_MESSAGES_LENGTH = 1000;
   static var MAX_INFOS_LENGTH = 50;
   static var MAX_VISIBLE = 30;
   static var EMPTY_ZONE_LENGTH = 31;
   static var STOP_SCROLL_LENGTH = 6;
   static var MAX_ITEM_BUFFER_LENGTH = 75;
   static var MAX_POS_REPLACE = 6;
   static var ADMIN_BUFFER_MULTIPLICATOR = 5;
   static var HTML_NB_PASS_MAX = 300;
   var _aVisibleTypes = [true,true,true,true,true,true,true,true,true,true,true];
   var _nItemsBufferIDs = 0;
   var _bFirstErrorCatched = false;
   var _bUseInWordCensor = false;
   static var CENSORSHIP_CHAR = ["%","&","§","#","+","?"];
   static var PONCTUATION = [".","!","?","~"];
   static var LINK_FILTERS = ["WWW","HTTP","@",".COM",".FR",".INFO","HOTMAIL","MSN","GMAIL","FTP"];
   static var WHITE_LIST = [".DOFUS.COM",".ANKAMA-GAMES.COM",".GOOGLE.COM",".DOFUS.FR",".DOFUS.DE",".DOFUS.ES",".DOFUS.CO.UK",".WAKFU.COM",".ANKAMA-SHOP.COM",".ANKAMA.COM",".ANKAMA-EDITIONS.COM",".ANKAMA-WEB.COM",".ANKAMA-EVENTS.COM",".DOFUS-ARENA.COM",".MUTAFUKAZ.COM",".MANGA-DOFUS.COM",".LABANDEPASSANTE.FR","@_@",".ANKAMA-PLAY.COM"];
   var _nFileOutput = 0;
   function ChatManager(oAPI)
   {
      super();
      dofus.managers.ChatManager._sSelf = this;
      this.initialize(oAPI);
   }
   function get feMessagesBuffer()
   {
      return this._feMessagesBuffer;
   }
   function get visibleTypes()
   {
      return this._aVisibleTypes;
   }
   function get fileOutput()
   {
      return this._nFileOutput;
   }
   function set fileOutput(nFileOutput)
   {
      this._nFileOutput = nFileOutput;
   }
   static function getInstance()
   {
      return dofus.managers.ChatManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this._aItemsBuffer = [];
      this._aRawMessages = [];
      this._feMessagesBuffer = new dofus.managers.chat.FightEventsMessagesBuffer(oAPI);
      this._nItemsBufferIDs = 0;
      this._aBlacklist = [];
      this.updateRigth();
      this.clear();
      this.api.electron.retroChatRefresh(this._aVisibleTypes,this.api.kernel.OptionsManager.getOption("TimestampInChat"));
   }
   function addRawMessage(nMapId, sMessageType, sRawFullMessage, sTimestamp)
   {
      var _loc6_ = {};
      _loc6_.mapId = nMapId;
      _loc6_.messageType = sMessageType;
      _loc6_.timestamp = sTimestamp;
      _loc6_.rawFullMessage = sRawFullMessage;
      if(this._aRawMessages.length > dofus.managers.ChatManager.MAX_RAW_MESSAGES_LENGTH)
      {
         this._aRawMessages.shift();
      }
      this._aRawMessages.push(_loc6_);
   }
   function getJailDialog()
   {
      var _loc2_ = "";
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < this._aRawMessages.length)
      {
         _loc4_ = this._aRawMessages[_loc3_];
         if(_loc4_.messageType == "MESSAGE_CHAT")
         {
            if(dofus.datacenter.DofusMap.isJail(_loc4_.mapId))
            {
               _loc2_ += "\n" + _loc4_.timestamp + " " + _loc4_.rawFullMessage;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      return _loc2_.length <= 0 ? _loc2_ : _loc2_.substring(1);
   }
   function updateRigth()
   {
      if(this.api.datacenter.Player.isAuthorized)
      {
         dofus.managers.ChatManager.MAX_ALL_LENGTH *= dofus.managers.ChatManager.ADMIN_BUFFER_MULTIPLICATOR;
         dofus.managers.ChatManager.MAX_ITEM_BUFFER_LENGTH *= dofus.managers.ChatManager.ADMIN_BUFFER_MULTIPLICATOR;
      }
   }
   function clear()
   {
      this._aMessages = [];
      this._aRawMessages = [];
      this._nMessageCounterInfo = 0;
   }
   function setTypes(aTypes)
   {
      this._aVisibleTypes = aTypes;
      this.refresh(true);
   }
   function isTypeVisible(nType)
   {
      return this._aVisibleTypes[nType];
   }
   function setTypeVisible(nType, bVisible)
   {
      this._aVisibleTypes[nType] = bVisible;
      this.api.electron.retroChatRefresh(this._aVisibleTypes);
      this.refresh(true);
   }
   function initCensorDictionnary()
   {
      var _loc2_;
      if(this._oCensorDictionnary == undefined)
      {
         this._oCensorDictionnary = {};
         _loc2_ = this.api.lang.getCensoredWords();
         for(var j in _loc2_)
         {
            this._oCensorDictionnary[String(_loc2_[j].c).toUpperCase()] = {weight:Number(_loc2_[j].l),id:Number(j),parseWord:_loc2_[j].d};
            if(_loc2_[j].d)
            {
               this._bUseInWordCensor = true;
            }
         }
      }
   }
   function applyOutputCensorship(sText)
   {
      if(this.api.datacenter.Player.isAuthorized)
      {
         return true;
      }
      if(!this.api.lang.getConfigText("CENSORSHIP_ENABLE_OUTPUT"))
      {
         return true;
      }
      this.initCensorDictionnary();
      var _loc3_ = -1;
      var _loc4_ = 0;
      var _loc5_ = -1;
      var _loc6_ = this.avoidPonctuation(sText.toUpperCase()).split(" ");
      for(var i in _loc6_)
      {
         if(this._oCensorDictionnary[_loc6_[i]] != undefined)
         {
            if(Number(this._oCensorDictionnary[_loc6_[i]].weight) > _loc3_)
            {
               _loc3_ = Number(this._oCensorDictionnary[_loc6_[i]].weight);
               _loc4_ = Number(this._oCensorDictionnary[_loc6_[i]].id);
            }
         }
         else if(this._bUseInWordCensor)
         {
            for(var j in this._oCensorDictionnary)
            {
               _loc5_ = _loc6_[i].indexOf(j);
               if(_loc5_ != -1 && this._oCensorDictionnary[j].parseWord)
               {
                  if(Number(this._oCensorDictionnary[j].weight) > _loc3_)
                  {
                     _loc3_ = Number(this._oCensorDictionnary[j].weight);
                     _loc4_ = Number(this._oCensorDictionnary[j].id);
                  }
               }
            }
         }
      }
      if(_loc3_ >= this.api.lang.getConfigText("SEND_CENSORSHIP_SINCE"))
      {
         this.api.network.Basics.sanctionMe(_loc3_,_loc4_);
      }
      if(_loc3_ > 0)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("PLEASE_RESTRAIN_TO_A_POLITE_VOCABULARY"),"ERROR_CHAT");
         return false;
      }
      return true;
   }
   function applyInputCensorship(sText)
   {
      if(!this.api.kernel.OptionsManager.getOption("CensorshipFilter") || !this.api.lang.getConfigText("CENSORSHIP_ENABLE_INPUT"))
      {
         return sText;
      }
      this.initCensorDictionnary();
      var _loc3_ = [];
      var _loc4_ = sText.split(" ");
      var _loc5_ = this.avoidPonctuation(sText.toUpperCase()).split(" ");
      var _loc6_ = -1;
      for(var i in _loc5_)
      {
         _loc6_ = -1;
         if(this._oCensorDictionnary[_loc5_[i]] != undefined)
         {
            _loc3_.push(this.getCensoredWord(_loc5_[i]));
            _loc6_ = 0;
         }
         else if(this._bUseInWordCensor)
         {
            for(var j in this._oCensorDictionnary)
            {
               _loc6_ = _loc5_[i].indexOf(j);
               if(_loc6_ != -1 && this._oCensorDictionnary[j].parseWord)
               {
                  _loc3_.push(this.getCensoredWord(_loc5_[i]));
                  break;
               }
               _loc6_ = -1;
            }
         }
         if(_loc6_ == -1)
         {
            _loc3_.push(_loc4_[i]);
         }
      }
      _loc3_.reverse();
      return _loc3_.join(" ");
   }
   function avoidPonctuation(sWord)
   {
      var _loc3_ = new String();
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < sWord.length)
      {
         _loc5_ = sWord.charCodeAt(_loc4_);
         if(_loc5_ > 47 && _loc5_ < 58 || (_loc5_ > 64 && _loc5_ < 91 || _loc5_ == 32))
         {
            _loc3_ += sWord.charAt(_loc4_);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function getCensoredWord(sWord)
   {
      var _loc3_ = new String();
      var _loc4_ = new String();
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      while(_loc5_ < sWord.length)
      {
         _loc6_ = sWord.charCodeAt(_loc5_);
         if(_loc6_ > 47 && _loc6_ < 58 || (_loc6_ > 64 && _loc6_ < 91 || _loc6_ > 96 && _loc6_ < 123))
         {
            _loc7_ = new String();
            do
            {
               _loc7_ = dofus.managers.ChatManager.CENSORSHIP_CHAR[Math.floor(Math.random() * dofus.managers.ChatManager.CENSORSHIP_CHAR.length)];
            }
            while(_loc7_ == _loc4_);
            _loc3_ += _loc4_ = _loc7_;
         }
         else
         {
            _loc3_ += _loc4_ = sWord.charAt(_loc5_);
         }
         _loc5_ = _loc5_ + 1;
      }
      return _loc3_;
   }
   function addLinkWarning(sText)
   {
      var _loc3_ = sText.toUpperCase();
      if(_loc3_.indexOf("</A>") > -1)
      {
         _loc3_ = _loc3_.substr(_loc3_.indexOf("</A>"));
      }
      var _loc4_ = _loc3_.split(" ");
      var _loc5_ = false;
      var _loc6_ = 0;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc6_ < _loc4_.length)
      {
         _loc7_ = false;
         _loc8_ = 0;
         while(_loc8_ < dofus.managers.ChatManager.LINK_FILTERS.length)
         {
            if(_loc4_[_loc6_].indexOf(dofus.managers.ChatManager.LINK_FILTERS[_loc8_]) > -1)
            {
               _loc7_ = true;
               break;
            }
            _loc8_ = _loc8_ + 1;
         }
         if(_loc7_)
         {
            _loc9_ = 0;
            while(_loc9_ < dofus.managers.ChatManager.WHITE_LIST.length)
            {
               if(_loc4_[_loc6_].indexOf(dofus.managers.ChatManager.WHITE_LIST[_loc9_]) > -1)
               {
                  _loc7_ = false;
                  break;
               }
               _loc9_ = _loc9_ + 1;
            }
         }
         if(_loc7_)
         {
            _loc5_ = true;
            break;
         }
         _loc6_ = _loc6_ + 1;
      }
      if(_loc5_)
      {
         sText += " [<font color=\"#006699\"><u><b><a href=\"asfunction:onHref,ShowLinkWarning,CHAT_LINK_WARNING_TEXT\">" + this.api.lang.getText("CHAT_LINK_WARNING") + "</a></b></u></font>]";
      }
      return sText;
   }
   function addText(sText, sColor, bSound, sUniqId)
   {
      if(bSound == undefined)
      {
         bSound = true;
      }
      var _loc6_ = "";
      var _loc9_ = false;
      var _loc7_;
      var _loc8_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      switch(sColor)
      {
         case dofus.Constants.MSG_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_MESSAGES;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.EMOTE_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_MESSAGES;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.THINK_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_MESSAGES;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.GROUP_CHAT_COLOR:
         case dofus.Constants.MSGCHUCHOTE_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_WISP;
            _loc9_ = true;
            _loc8_ = true;
            if(bSound)
            {
               this.api.sounds.events.onChatWisper();
            }
            break;
         case dofus.Constants.INFO_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_INFOS;
            this._nMessageCounterInfo = this._nMessageCounterInfo + 1;
            _loc8_ = false;
            break;
         case dofus.Constants.ERROR_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_ERRORS;
            _loc8_ = true;
            if(bSound)
            {
               if(this._bFirstErrorCatched)
               {
                  this.api.sounds.events.onError();
               }
               else
               {
                  this._bFirstErrorCatched = true;
               }
            }
            break;
         case dofus.Constants.GUILD_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_GUILD;
            _loc9_ = true;
            _loc8_ = true;
            if(bSound && this.api.kernel.OptionsManager.getOption("GuildMessageSound"))
            {
               this.api.sounds.events.onChatWisper();
            }
            break;
         case dofus.Constants.PVP_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_PVP;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.TRADE_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_TRADE;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.RECRUITMENT_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_RECRUITMENT;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.MEETIC_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_MEETIC;
            _loc9_ = true;
            _loc8_ = true;
            break;
         case dofus.Constants.GAME_EVENTS_CHAT:
            _loc10_ = sText.split(",");
            _loc11_ = _loc10_[0];
            _loc10_.shift();
            _loc12_ = _loc11_.split("_")[3];
            if(_loc12_ > 29 && _loc12_ < 40)
            {
               _loc13_ = _loc10_[0].toString().split("/");
               if(_loc13_.length > 1)
               {
                  _loc14_ = String(_loc13_.pop());
                  _loc10_[0] = _loc13_.join(", ") + " " + this.api.lang.getText("AND") + " " + _loc14_;
               }
               else
               {
                  _loc10_[0] = _loc13_[0];
               }
               _loc10_[1] = this.getLinkAchievement(_loc10_[1]);
            }
            sText = "(" + this.api.lang.getText("GAME_EVENTS_CHANNEL") + ") : " + this.api.lang.getText(_loc11_,_loc10_);
            _loc7_ = dofus.managers.ChatManager.TYPE_GAME_EVENTS;
            _loc9_ = false;
            _loc8_ = true;
            sText = this.api.kernel.DebugManager.getFormattedMessage(sText,";");
            if(this._aVisibleTypes[_loc7_] == true)
            {
               this.api.electron.makeNotification(sText);
            }
            break;
         case dofus.Constants.GAME_HUNT_CHAT:
            _loc7_ = dofus.managers.ChatManager.TYPE_ERRORS;
            this.api.electron.makeNotification(sText);
            if(sUniqId == "START_CONFIRMATION" && bSound)
            {
               this.api.sounds.events.onStartHunt();
            }
            break;
         case dofus.Constants.ADMIN_CHAT_COLOR:
         case dofus.Constants.COMMANDS_CHAT_COLOR:
            _loc7_ = dofus.managers.ChatManager.TYPE_ADMIN;
            _loc8_ = true;
            break;
         default:
            ank.utils.Logger.err("[Chat] Erreur : mauvaise couleur " + sText);
            return undefined;
      }
      var _loc15_ = sText;
      if(_loc9_)
      {
         sText = this.addLinkWarning(sText);
         sText = this.applyInputCensorship(sText.substring(0,sText.length - 4)) + sText.substring(sText.length - 4);
      }
      if(_loc8_ && this.api.kernel.NightManager.time.length)
      {
         _loc6_ = "[" + this.api.kernel.NightManager.time + "] ";
      }
      this.api.electron.chatPrint(sText,sColor,sUniqId,_loc7_,_loc6_);
      if(this._nFileOutput > 0)
      {
         this.api.electron.chatLog(_loc15_);
         if(this._nFileOutput == 2)
         {
            return undefined;
         }
      }
      if(this.api.electron.isShowingWidescreenPanel && this.api.electron.getWidescreenPanelId() == dofus.Electron.WIDESCREEN_PANEL_CHAT)
      {
         return undefined;
      }
      var _loc16_ = "\n<font color=\"#" + sColor + "\">";
      var _loc17_ = "</font>";
      this._aMessages.push({textStyleLeft:_loc16_,text:sText,textStyleRight:_loc17_,type:_loc7_,uniqId:sUniqId,timestamp:_loc6_,lf:false});
      if(this._aMessages.length > dofus.managers.ChatManager.MAX_ALL_LENGTH)
      {
         this._aMessages.shift();
      }
      this.refresh();
   }
   function refresh(bForceRefresh)
   {
      if(this._nRefreshVisuallyTimeout != undefined)
      {
         _global.clearTimeout(this._nRefreshVisuallyTimeout);
      }
      var _loc3_ = _global.setTimeout(this,"realRefresh",dofus.Constants.DELAYED_CHAT_VISUAL_REFRESH,bForceRefresh);
      this._nRefreshVisuallyTimeout = _loc3_;
   }
   function realRefresh(bForceRefresh)
   {
      var _loc3_ = this._aMessages.length;
      var _loc4_ = new String();
      var _loc5_ = 0;
      if(_loc3_ == 0 && !bForceRefresh)
      {
         return undefined;
      }
      var _loc6_ = _loc3_ - 1;
      var _loc7_;
      var _loc8_;
      while(_loc5_ < dofus.managers.ChatManager.MAX_VISIBLE && _loc6_ >= 0)
      {
         _loc7_ = this._aMessages[_loc6_];
         if(this._aVisibleTypes[_loc7_.type] == true)
         {
            _loc5_ = _loc5_ + 1;
            if(!_loc7_.htmlSyntaxChecked)
            {
               _loc8_ = dofus.managers.ChatManager.safeHtml(_loc7_.text);
               _loc7_.lf = _loc7_.lf;
               _loc7_.text = _loc8_.t;
               _loc7_.htmlSyntaxChecked = true;
            }
            if(this.api.kernel.OptionsManager.getOption("TimestampInChat"))
            {
               _loc4_ = (!_loc7_.lf ? "" : "\n") + _loc7_.textStyleLeft + _loc7_.timestamp + _loc7_.text + _loc7_.textStyleRight + _loc4_;
            }
            else
            {
               _loc4_ = (!_loc7_.lf ? "" : "\n") + _loc7_.textStyleLeft + _loc7_.text + _loc7_.textStyleRight + _loc4_;
            }
         }
         _loc6_ = _loc6_ - 1;
      }
      this.api.ui.getUIComponent("Banner").setChatText(_loc4_);
   }
   static function safeHtml(s)
   {
      var _loc3_ = true;
      var _loc4_ = [];
      var _loc5_ = [];
      var _loc6_ = s;
      var _loc7_ = 0;
      var _loc9_ = 0;
      var _loc8_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      while((_loc8_ = _loc6_.indexOf("<")) > -1 && _loc7_++ < dofus.managers.ChatManager.HTML_NB_PASS_MAX)
      {
         _loc10_ = _loc6_.indexOf(">",_loc8_) + 1;
         _loc11_ = _loc6_.substring(_loc8_,_loc10_);
         _loc12_ = _loc11_.indexOf("/");
         _loc13_ = _loc12_ == 1;
         _loc14_ = _loc12_ == _loc11_.length - 2;
         _loc15_ = !_loc13_ ? _loc11_.substring(1,_loc11_.length - 1) : _loc11_.substring(2,_loc11_.length - 1);
         _loc16_ = _loc15_.indexOf(" ");
         _loc15_ = _loc15_.substring(0,_loc16_ <= -1 ? _loc15_.length : _loc16_);
         _loc5_[_loc9_] = {c:_loc13_,b:_loc15_};
         if(_loc14_)
         {
            _loc5_[_loc9_ = _loc9_ + 1] = {c:!_loc13_,b:_loc15_};
         }
         _loc6_ = _loc6_.substring(_loc10_);
         _loc9_ = _loc9_ + 1;
      }
      if(_loc7_ >= dofus.managers.ChatManager.HTML_NB_PASS_MAX)
      {
         _loc3_ = false;
      }
      var _loc17_;
      var _loc18_;
      if(_loc3_)
      {
         _loc17_ = 0;
         while(_loc17_ < _loc5_.length)
         {
            _loc18_ = _loc5_[_loc17_];
            if(_loc18_.c)
            {
               if(_loc4_[_loc18_.b] == undefined || _loc4_[_loc18_.b] == 0)
               {
                  _loc3_ = false;
                  break;
               }
               _loc4_[_loc18_.b] -= 1;
            }
            else
            {
               if(_loc4_[_loc18_.b] == undefined)
               {
                  _loc4_[_loc18_.b] = 0;
               }
               _loc4_[_loc18_.b] += 1;
            }
            _loc17_ = _loc17_ + 1;
         }
         for(var i in _loc4_)
         {
            if(_loc4_[i] > 0)
            {
               _loc3_ = false;
               break;
            }
         }
      }
      if(_loc3_)
      {
         return {v:_loc3_,t:s};
      }
      return {v:_loc3_,t:s.split("<").join("&lt;").split(">").join("&gt;")};
   }
   function parseInlineItems(sMessage, aItems, bHtml)
   {
      if(bHtml == undefined)
      {
         bHtml = true;
      }
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      while(_loc5_ < aItems.length)
      {
         _loc6_ = Number(aItems[_loc5_]);
         _loc7_ = aItems[_loc5_ + 1];
         _loc8_ = new dofus.datacenter.Item(0,_loc6_,1,1,_loc7_,1);
         _loc9_ = "°" + _loc5_ / 2;
         _loc10_ = this.getLinkItem(_loc8_,bHtml);
         _loc11_ = sMessage.indexOf(_loc9_);
         if(_loc11_ != -1)
         {
            _loc12_ = sMessage.split("");
            _loc12_.splice(_loc11_,_loc9_.length,_loc10_);
            sMessage = _loc12_.join("");
         }
         _loc5_ += 2;
      }
      return sMessage;
   }
   function parseInlinePos(sMessage)
   {
      var _loc3_ = sMessage;
      var _loc4_ = 0;
      var _loc6_ = 0;
      var _loc7_ = 0;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc5_;
      while(_loc3_.indexOf("[") > -1 && (_loc4_++ < dofus.managers.ChatManager.HTML_NB_PASS_MAX && _loc6_ < dofus.managers.ChatManager.MAX_POS_REPLACE))
      {
         _loc8_ = _loc3_.indexOf("[");
         _loc9_ = _loc3_.indexOf("]",_loc8_) + 1;
         if(_loc9_ <= 0)
         {
            break;
         }
         _loc10_ = _loc3_.substring(_loc8_ + 1,_loc9_ - 1).indexOf(", ") != -1 ? ", " : ",";
         _loc11_ = _loc3_.substring(_loc8_ + 1,_loc9_ - 1).split(_loc10_);
         if(_loc11_.length == 2)
         {
            if(!_global.isNaN(_loc11_[0]) && !_global.isNaN(new ank.utils.ExtendedString(_loc11_[0]).trim().toString()))
            {
               _loc12_ = Number(_loc11_[0]);
               _loc13_ = Number(_loc11_[1]);
               if(Math.abs(_loc12_) < 150 && Math.abs(_loc13_) < 150)
               {
                  _loc5_ = sMessage.split(_loc3_.substring(_loc8_,_loc9_));
                  _loc6_ += _loc5_.length;
                  if(_loc6_ > dofus.managers.ChatManager.MAX_POS_REPLACE)
                  {
                     break;
                  }
                  sMessage = _loc5_.join(this.getLinkCoord(_loc12_,_loc13_));
               }
            }
         }
         _loc3_ = _loc3_.substring(_loc9_);
         _loc7_ = _loc7_ + 1;
      }
      return sMessage;
   }
   function parseSecretsEmotes(sMessage)
   {
      if(!this.api.lang.getConfigText("CHAT_USE_SECRETS_EMOTES"))
      {
         return sMessage;
      }
      if(sMessage.indexOf("[love]") != -1)
      {
         sMessage = sMessage.split("[love]").join("");
         if(!this.api.datacenter.Game.isFight)
         {
            this.api.network.GameActions.onActions(";208;" + this.api.datacenter.Player.ID + ";" + this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).cellNum + ",2914,11,8,1");
         }
      }
      if(sMessage.indexOf("[rock]") != -1)
      {
         sMessage = sMessage.split("[rock]").join("");
         if(!this.api.datacenter.Game.isFight)
         {
            this.api.network.GameActions.onActions(";208;" + this.api.datacenter.Player.ID + ";" + this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).cellNum + ",2069,10,1,1");
            this.api.network.GameActions.onActions(";208;" + this.api.datacenter.Player.ID + ";" + (this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).cellNum + 1) + ",2904,11,8,3");
            this.api.network.GameActions.onActions(";208;" + this.api.datacenter.Player.ID + ";" + (this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).cellNum - 1) + ",2904,11,8,3");
            this.api.network.Chat.onSmiley(this.api.datacenter.Player.ID + "|1");
            this.api.kernel.AudioManager.playSound("SPEAK_TRIGGER_LEVEL_UP");
            this.api.network.Chat.onMessage(true,this.api.datacenter.Player.ID + "|" + this.api.datacenter.Player.Name + "|" + sMessage);
         }
         sMessage = "";
      }
      return sMessage;
   }
   function parseInlineAchievements(sMessage)
   {
      var _loc3_ = sMessage.split("a[");
      var _loc4_ = 1;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].indexOf("]");
         if(_loc5_ != -1)
         {
            _loc6_ = _loc3_[_loc4_].substr(0,_loc5_);
            _loc7_ = this.getLinkAchievement(_loc6_);
            _loc3_[_loc4_] = _loc7_ + _loc3_[_loc4_].substr(_loc5_ + 1);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_.join("");
   }
   function parseInlineMonsters(sMessage)
   {
      var _loc3_ = sMessage.split(dofus.datacenter.Monster.CHAT_PREFIX + "[");
      var _loc4_ = 1;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].indexOf("]");
         if(_loc5_ != -1)
         {
            _loc6_ = _loc3_[_loc4_].substr(0,_loc5_);
            _loc7_ = this.getLinkMonster(_loc6_);
            _loc3_[_loc4_] = _loc7_ + _loc3_[_loc4_].substr(_loc5_ + 1);
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_.join("");
   }
   function getLinkName(sPlayerID, sPlayerName)
   {
      if(sPlayerID == undefined)
      {
         sPlayerID = "";
      }
      return "<b><a href=\"asfunction:onHref,ShowPlayerPopupMenu," + sPlayerID + "," + sPlayerName + "\">" + sPlayerName + "</a></b>";
   }
   function getLinkCoord(nX, nY)
   {
      return "<b><a href=\"asfunction:onHref,updateCompass," + nX + "," + nY + "\">[" + nX + "," + nY + "]</a></b>";
   }
   function getLinkAchievement(sId)
   {
      var _loc3_ = this.api.datacenter.Player.Achievements.getOrInitAchievement(sId);
      if(_loc3_ == undefined)
      {
         return "";
      }
      return "<b><a href=\"asfunction:onHref,viewAchievement," + sId + "\">[" + _loc3_.name + "]</a></b>";
   }
   function getLinkMonster(sId)
   {
      var _loc3_ = new dofus.datacenter.Monster(sId);
      if(_loc3_.name == undefined)
      {
         return "";
      }
      return "<b><a href=\"asfunction:onHref,viewBestiary," + sId + "\">[" + _loc3_.name + "]</a></b>";
   }
   function getLinkItem(oItem, bHtml)
   {
      if(bHtml == undefined)
      {
         bHtml = true;
      }
      var _loc4_ = this.addItemToBuffer(oItem);
      return bHtml ? "<b>[<a href=\"asfunction:onHref,ShowItemViewer," + String(_loc4_) + "\">" + oItem.name + "</a>]</b>" : "[" + oItem.name + "]";
   }
   function addItemToBuffer(oItem)
   {
      if(this._nItemsBufferIDs == undefined || _global.isNaN(this._nItemsBufferIDs))
      {
         this._nItemsBufferIDs = 0;
      }
      this._nItemsBufferIDs = this._nItemsBufferIDs + 1;
      if(this._aItemsBuffer == undefined)
      {
         this._aItemsBuffer = [];
      }
      if(this._aItemsBuffer.length > dofus.managers.ChatManager.MAX_ITEM_BUFFER_LENGTH)
      {
         this._aItemsBuffer.shift();
      }
      this._aItemsBuffer.push({id:this._nItemsBufferIDs,data:oItem});
      return this._nItemsBufferIDs;
   }
   function getItemFromBuffer(nItemID)
   {
      var _loc3_ = this._aItemsBuffer.length;
      while(_loc3_ >= 0)
      {
         if(this._aItemsBuffer[_loc3_].id == nItemID)
         {
            return this._aItemsBuffer[_loc3_].data;
         }
         _loc3_ = _loc3_ - 1;
      }
      return undefined;
   }
   static function isPonctuation(sChar)
   {
      var _loc3_ = 0;
      while(_loc3_ < dofus.managers.ChatManager.PONCTUATION.length)
      {
         if(dofus.managers.ChatManager.PONCTUATION[_loc3_] == sChar)
         {
            return true;
         }
         _loc3_ = _loc3_ + 1;
      }
      return false;
   }
   function addToBlacklist(sName, nClass)
   {
      if(sName != this.api.datacenter.Player.Name && !this.isBlacklisted(sName))
      {
         this._aBlacklist.push({sName:sName,nClass:nClass});
      }
   }
   function removeToBlacklist(sName)
   {
      for(var i in this._aBlacklist)
      {
         if(sName == this._aBlacklist[i].sName || sName == "*" + this._aBlacklist[i].sName)
         {
            this._aBlacklist[i] = undefined;
            this.api.ui.getUIComponent("Friends").updateIgnoreList();
            this.api.kernel.showMessage(undefined,this.api.lang.getText("TEMPORARY_NOMORE_BLACKLISTED",[sName]),"INFO_CHAT");
            return undefined;
         }
      }
   }
   function getBlacklist()
   {
      return this._aBlacklist;
   }
   function isBlacklisted(sName)
   {
      for(var i in this._aBlacklist)
      {
         if(sName.toLowerCase() == this._aBlacklist[i].sName.toLowerCase())
         {
            return true;
         }
      }
      return false;
   }
   function getMessageFromId(sUniqId)
   {
      for(var i in this._aMessages)
      {
         if(this._aMessages[i].uniqId == sUniqId)
         {
            return this._aMessages[i].text;
         }
      }
      return undefined;
   }
}
