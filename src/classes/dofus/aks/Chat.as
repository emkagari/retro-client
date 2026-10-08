class dofus.aks.Chat extends dofus.aks.Handler
{
   var aks;
   var api;
   function Chat(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
   }
   function send(sMessage, sDest, oParams)
   {
      if(this.api.datacenter.Game.isSpectator && sDest == "*")
      {
         sDest = "#";
      }
      if(sDest.toLowerCase() == this.api.datacenter.Player.Name.toLowerCase())
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_WISP_YOURSELF"),"ERROR_CHAT");
         return undefined;
      }
      if(this.api.kernel.ChatManager.isBlacklisted(sDest))
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_WISP_BLACKLISTED"),"ERROR_CHAT");
         return undefined;
      }
      sMessage = new ank.utils.ExtendedString(sMessage).replace(["|"],[""]);
      var _loc5_ = this.api.kernel.ChatManager.applyOutputCensorship(sMessage);
      if(!_loc5_)
      {
         return undefined;
      }
      if(this.api.datacenter.Player.zaapToken == undefined && (sMessage.indexOf(this.api.datacenter.Player.login) > -1 || sMessage.indexOf(this.api.datacenter.Player.password) > -1))
      {
         if(sMessage != undefined && (this.api.datacenter.Player.login != undefined && this.api.datacenter.Player.password != undefined))
         {
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_SAY_YOUR_PASSWORD"),"ERROR_CHAT");
            return undefined;
         }
      }
      if(sMessage.length == 0)
      {
         return undefined;
      }
      var _loc6_ = new String();
      var _loc7_ = oParams.items;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      if(_loc7_.length > 0)
      {
         _loc8_ = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc10_ = _loc7_[_loc9_];
            _loc11_ = "[" + _loc10_.name + "]";
            _loc12_ = sMessage.indexOf(_loc11_);
            if(_loc12_ != -1)
            {
               _loc13_ = "°" + _loc8_;
               _loc8_ = _loc8_ + 1;
               _loc14_ = sMessage.split("");
               _loc14_.splice(_loc12_,_loc11_.length,_loc13_);
               sMessage = _loc14_.join("");
               if(_loc6_.length > 0)
               {
                  _loc6_ += "!";
               }
               _loc15_ = _loc10_.compressedEffects;
               _loc6_ += _loc10_.unicID + "!" + (_loc15_ == undefined ? "." : _loc15_);
            }
            _loc9_ = _loc9_ + 1;
         }
      }
      var _loc16_ = new String();
      var _loc17_ = oParams.achievements;
      var _loc18_;
      var _loc19_;
      var _loc20_;
      var _loc21_;
      var _loc22_;
      var _loc23_;
      if(_loc17_.length > 0)
      {
         _loc18_ = 0;
         while(_loc18_ < _loc17_.length)
         {
            _loc19_ = _loc17_[_loc18_];
            _loc20_ = "[" + _loc19_.name + "]";
            _loc21_ = sMessage.indexOf(_loc20_);
            if(_loc21_ != -1)
            {
               _loc22_ = "a[" + _loc19_.ID + "]";
               _loc23_ = sMessage.split("");
               _loc23_.splice(_loc21_,_loc20_.length,_loc22_);
               sMessage = _loc23_.join("");
            }
            _loc18_ = _loc18_ + 1;
         }
      }
      var _loc24_ = new String();
      var _loc25_ = oParams.monsters;
      var _loc26_;
      var _loc27_;
      var _loc28_;
      var _loc29_;
      var _loc30_;
      var _loc31_;
      if(_loc25_.length > 0)
      {
         _loc26_ = 0;
         while(_loc26_ < _loc25_.length)
         {
            _loc27_ = _loc25_[_loc26_];
            _loc28_ = "[" + _loc27_.name + "]";
            _loc29_ = sMessage.indexOf(_loc28_);
            if(_loc29_ != -1)
            {
               _loc30_ = dofus.datacenter.Monster.CHAT_PREFIX + "[" + _loc27_.id + "]";
               _loc31_ = sMessage.split("");
               _loc31_.splice(_loc29_,_loc28_.length,_loc30_);
               sMessage = _loc31_.join("");
            }
            _loc26_ = _loc26_ + 1;
         }
      }
      var _loc32_ = _loc6_;
      if(_loc32_.length > dofus.Constants.MAX_DATA_LENGTH)
      {
         _loc32_ = _loc32_.substring(0,dofus.Constants.MAX_DATA_LENGTH - 1);
      }
      if(sMessage.length > dofus.Constants.MAX_MESSAGE_LENGTH && !(dofus.Constants.ALPHA && this.api.datacenter.Player.isAuthorized))
      {
         sMessage = sMessage.substring(0,dofus.Constants.MAX_MESSAGE_LENGTH);
      }
      this.aks.send("BM" + sDest + "|" + sMessage + "|" + _loc32_,true,undefined,true);
   }
   function reportMessage(sCharacterID, sMessageUniqId, sMessage, nReason)
   {
      this.aks.send("BR" + sCharacterID + "|" + sMessage + "|" + sMessageUniqId + "|" + nReason,false);
   }
   function subscribeChannels(nChannel, bSubscribe)
   {
      if(!this.api.datacenter.Basics.inGame)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("SRV_MSG_7"),"ERROR_CHAT");
         return undefined;
      }
      var _loc4_ = "";
      switch(nChannel)
      {
         case 0:
            _loc4_ = "i";
            break;
         case 2:
            _loc4_ = "*";
            break;
         case 3:
            _loc4_ = "#$p";
            break;
         case 4:
            _loc4_ = "%";
            break;
         case 5:
            _loc4_ = "!";
            break;
         case 6:
            _loc4_ = "?";
            break;
         case 7:
            _loc4_ = ":";
            break;
         case 8:
            _loc4_ = "^";
            break;
         case 10:
            _loc4_ = "e";
      }
      this.aks.send("cC" + (!bSubscribe ? "-" : "+") + _loc4_,true);
   }
   function useSmiley(nSmileyID)
   {
      if(getTimer() - this.api.datacenter.Basics.aks_chat_lastActionTime < dofus.Constants.CLICK_MIN_DELAY)
      {
         return undefined;
      }
      this.api.datacenter.Basics.aks_chat_lastActionTime = getTimer();
      this.aks.send("BS" + nSmileyID,true);
   }
   function onSubscribeChannel(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "+";
      var _loc4_ = sExtraData.substr(1).split("");
      var _loc5_ = 0;
      var _loc6_;
      for(; _loc5_ < _loc4_.length; _loc5_ = _loc5_ + 1)
      {
         _loc6_ = 0;
         switch(_loc4_[_loc5_])
         {
            case "i":
               _loc6_ = 0;
               break;
            case "*":
               _loc6_ = 2;
               break;
            case "#":
               _loc6_ = 3;
               break;
            case "$":
               _loc6_ = 3;
               break;
            case "p":
               _loc6_ = 3;
               break;
            case "%":
               _loc6_ = 4;
               break;
            case "!":
               _loc6_ = 5;
               break;
            case "?":
               _loc6_ = 6;
               break;
            case ":":
               _loc6_ = 7;
               break;
            case "^":
               _loc6_ = 8;
               break;
            case "@":
               _loc6_ = 9;
               break;
            case "e":
               _loc6_ = 10;
               break;
            default:
               continue;
         }
         this.api.ui.getUIComponent("Banner").chat.selectFilter(_loc6_,_loc3_);
         this.api.kernel.ChatManager.setTypeVisible(_loc6_,_loc3_);
         this.api.datacenter.Basics.chat_type_visible[_loc6_] = _loc3_;
      }
   }
   function onMessage(bSuccess, sExtraData)
   {
      if(!bSuccess)
      {
         switch(sExtraData.charAt(0))
         {
            case "S":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("SYNTAX_ERROR",[" /w <" + this.api.lang.getText("NAME") + "> <" + this.api.lang.getText("MSG") + ">"]),"ERROR_CHAT");
               break;
            case "f":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("USER_NOT_CONNECTED",[sExtraData.substr(1)]),"ERROR_CHAT");
               break;
            case "e":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("USER_NOT_CONNECTED_BUT_TRY_SEND_EXTERNAL",[sExtraData.substr(1)]),"ERROR_CHAT");
               break;
            case "n":
               this.api.kernel.showMessage(undefined,this.api.lang.getText("USER_NOT_CONNECTED_EXTERNAL_NACK",[sExtraData.substr(1)]),"ERROR_CHAT");
         }
         return undefined;
      }
      var _loc4_ = sExtraData.charAt(0);
      sExtraData = _loc4_ != "|" ? sExtraData.substr(2) : sExtraData.substr(1);
      var _loc5_ = sExtraData.split("|");
      var _loc6_ = _loc5_[2];
      var _loc7_ = _loc5_[1];
      var _loc8_ = _loc5_[0];
      var _loc9_ = _loc5_[3];
      if(this.api.kernel.ChatManager.isBlacklisted(_loc7_))
      {
         return undefined;
      }
      var _loc10_ = _loc6_;
      var _loc11_;
      if(_loc4_ != "e")
      {
         if(_loc9_.length > 0)
         {
            _loc11_ = _loc9_.split("!");
            _loc6_ = this.api.kernel.ChatManager.parseInlineItems(_loc6_,_loc11_,true);
            _loc10_ = this.api.kernel.ChatManager.parseInlineItems(_loc10_,_loc11_,false);
         }
         _loc6_ = this.api.kernel.ChatManager.parseInlinePos(_loc6_);
         _loc6_ = this.api.kernel.ChatManager.parseInlineAchievements(_loc6_);
         _loc6_ = this.api.kernel.ChatManager.parseInlineMonsters(_loc6_);
      }
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
      var _loc28_;
      switch(_loc4_)
      {
         case "F":
            _loc12_ = "WHISP_CHAT";
            _loc6_ = this.api.kernel.ChatManager.parseSecretsEmotes(_loc6_);
            if(!_loc6_.length)
            {
               return undefined;
            }
            _loc13_ = this.api.lang.getText("FROM") + " " + _loc7_ + " : ";
            this.api.electron.makeNotification(_loc13_ + this.api.kernel.ChatManager.applyInputCensorship(_loc6_));
            _loc6_ = this.api.lang.getText("FROM") + " <i>" + this.getLinkName(_loc8_,_loc7_) + "</i> : " + this.getLinkMessage(_loc8_,_loc7_,_loc13_,_loc10_,_loc6_);
            this.api.kernel.Console.pushWhisper("/w " + _loc7_ + " ");
            break;
         case "T":
            _loc12_ = "WHISP_CHAT";
            _loc14_ = this.api.lang.getText("TO_DESTINATION") + " " + _loc7_ + " : ";
            _loc6_ = this.api.lang.getText("TO_DESTINATION") + " " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc14_,_loc10_,_loc6_);
            break;
         case "#":
            if(this.api.datacenter.Game.isFight)
            {
               _loc12_ = "WHISP_CHAT";
               if(this.api.datacenter.Game.isSpectator)
               {
                  _loc15_ = "(" + this.api.lang.getText("SPECTATOR") + ")";
               }
               else
               {
                  _loc15_ = "(" + this.api.lang.getText("TEAM") + ")";
               }
               _loc16_ = _loc15_ + " " + _loc7_ + " : ";
               _loc6_ = _loc15_ + " " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc16_,_loc10_,_loc6_);
            }
            break;
         case "%":
            _loc12_ = "GUILD_CHAT_SOUND";
            _loc17_ = "(" + this.api.lang.getText("GUILD") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("GUILD") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc17_,_loc10_,_loc6_);
            break;
         case "$":
            _loc12_ = "PARTY_CHAT";
            _loc18_ = "(" + this.api.lang.getText("PARTY") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("PARTY") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc18_,_loc10_,_loc6_);
            break;
         case "!":
            _loc12_ = "PVP_CHAT";
            _loc19_ = "(" + this.api.lang.getText("ALIGNMENT") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("ALIGNMENT") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc19_,_loc10_,_loc6_);
            break;
         case "?":
            _loc12_ = "RECRUITMENT_CHAT";
            _loc20_ = "(" + this.api.lang.getText("RECRUITMENT") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("RECRUITMENT") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc20_,_loc10_,_loc6_);
            break;
         case ":":
            _loc12_ = "TRADE_CHAT";
            _loc21_ = "(" + this.api.lang.getText("TRADE") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("TRADE") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc21_,_loc10_,_loc6_);
            break;
         case "^":
            _loc12_ = "MEETIC_CHAT";
            _loc22_ = "(" + this.api.lang.getText("MEETIC") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("MEETIC") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc22_,_loc10_,_loc6_);
            break;
         case "e":
            _loc12_ = "GAME_EVENTS_CHAT";
            _loc23_ = _loc10_.split(";");
            _loc6_ = "EVENT_" + String(_loc23_[0]) + "," + _loc23_[1];
            break;
         case "@":
            _loc12_ = "ADMIN_CHAT";
            _loc24_ = "(" + this.api.lang.getText("PRIVATE_CHANNEL") + ") " + _loc7_ + " : ";
            _loc6_ = "(" + this.api.lang.getText("PRIVATE_CHANNEL") + ") " + this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc24_,_loc10_,_loc6_);
            break;
         default:
            if(this.api.lang.getConfigText("EMOTES_ENABLED") && (_loc6_.charAt(0) == dofus.Constants.EMOTE_CHAR && _loc6_.charAt(_loc6_.length - 1) == dofus.Constants.EMOTE_CHAR))
            {
               if(!this.api.datacenter.Game.isRunning && this.api.kernel.ChatManager.isTypeVisible(2))
               {
                  _loc25_ = !(_loc6_.charAt(_loc6_.length - 2) == "." && _loc6_.charAt(_loc6_.length - 3) != ".") ? _loc6_ : _loc6_.substr(0,_loc6_.length - 2) + dofus.Constants.EMOTE_CHAR;
                  _loc25_ = dofus.Constants.EMOTE_CHAR + _loc25_.charAt(1).toUpperCase() + _loc25_.substr(2);
                  this.api.gfx.addSpriteBubble(_loc8_,this.api.kernel.ChatManager.applyInputCensorship(_loc25_));
               }
               _loc12_ = "EMOTE_CHAT";
               _loc6_ = _loc6_.substr(1,_loc6_.length - 2);
               if(!dofus.managers.ChatManager.isPonctuation(_loc6_.charAt(_loc6_.length - 1)))
               {
                  _loc6_ += ".";
               }
               _loc6_ = "<i>" + this.getLinkName(_loc8_,_loc7_) + " " + _loc6_.charAt(0).toLowerCase() + _loc6_.substr(1) + "</i>";
               break;
            }
            if(_loc6_.substr(0,7) == "!THINK!")
            {
               _loc6_ = _loc6_.substr(7);
               if(!this.api.datacenter.Game.isRunning && this.api.kernel.ChatManager.isTypeVisible(2))
               {
                  this.api.gfx.addSpriteBubble(_loc8_,this.api.kernel.ChatManager.applyInputCensorship(_loc6_),ank.battlefield.TextHandler.BUBBLE_TYPE_THINK);
               }
               _loc12_ = "THINK_CHAT";
               _loc26_ = _loc7_ + " " + this.api.lang.getText("THINKS_WORD") + " : ";
               _loc6_ = "<i>" + this.getLinkName(_loc8_,_loc7_) + " " + this.api.lang.getText("THINKS_WORD") + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc26_,_loc10_,_loc6_) + "</i>";
               break;
            }
            if(!this.api.datacenter.Game.isRunning && this.api.kernel.ChatManager.isTypeVisible(2))
            {
               this.api.gfx.addSpriteBubble(_loc8_,this.api.kernel.ChatManager.applyInputCensorship(_loc6_));
            }
            _loc12_ = "MESSAGE_CHAT";
            _loc27_ = _loc7_ + " : ";
            _loc6_ = this.getLinkName(_loc8_,_loc7_) + " : " + this.getLinkMessage(_loc8_,_loc7_,_loc27_,_loc10_,_loc6_);
            if(this.api.datacenter.Player.isAuthorized)
            {
               _loc28_ = this.api.kernel.DebugManager.getTimestamp();
               this.api.kernel.ChatManager.addRawMessage(this.api.datacenter.Map.id,_loc12_,this.getRawFullMessage(_loc27_,_loc10_),_loc28_);
            }
      }
      this.api.kernel.showMessage(undefined,_loc6_,_loc12_);
   }
   function getRawFullMessage(sPreMessage, sRawMessage)
   {
      return sPreMessage + sRawMessage;
   }
   function getLinkMessage(sPlayerID, sPlayerName, sPreMessage, sRawMessage, sMessage)
   {
      var _loc7_ = this.api.kernel.DebugManager.getTimestamp() + " ";
      sMessage = this.api.kernel.ChatManager.applyInputCensorship(sMessage);
      return "<a href=\"asfunction:onHref,ShowMessagePopupMenu," + sPlayerID + "," + sPlayerName + "," + _global.escape(_loc7_ + sPreMessage + sRawMessage) + "\">" + sMessage + "</a>";
   }
   static function getLinkHighlightSprite(sPlayerID, sLinkName)
   {
      return "<a href=\"asfunction:onHref,highlightSprite," + sPlayerID + "\">" + sLinkName + "</a>";
   }
   static function getLinkHighlightSprites(aSpritesIDs, sLinkName)
   {
      return dofus.aks.Chat.getLinkHighlightSprite(aSpritesIDs.join(","),sLinkName);
   }
   function getLinkName(sPlayerID, sPlayerName, bNoBold)
   {
      if(sPlayerID == undefined)
      {
         sPlayerID = "";
      }
      var _loc5_ = "<b>";
      var _loc6_ = "</b>";
      if(bNoBold)
      {
         _loc5_ = "";
         _loc6_ = "";
      }
      return _loc5_ + "<a href=\"asfunction:onHref,ShowPlayerPopupMenu," + sPlayerID + "," + sPlayerName + "\">" + sPlayerName + "</a>" + _loc6_;
   }
   function onServerMessage(sExtraData)
   {
      if(sExtraData != undefined)
      {
         this.api.kernel.showMessage(undefined,sExtraData,"INFO_CHAT");
      }
   }
   function onSmiley(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = Number(_loc3_[1]);
      if(!this.api.datacenter.Game.isFight && !this.api.datacenter.Game.isRunning)
      {
         if(_loc4_ != this.api.datacenter.Player.ID && this.api.gfx.spriteHandler.isPlayerSpritesHidden || this.api.kernel.ChatManager.isBlacklisted(this.api.datacenter.Sprites.getItemAt(_loc4_).name))
         {
            return undefined;
         }
      }
      this.api.gfx.addSpriteOverHeadItem(_loc4_,"smiley",dofus.graphics.battlefield.SmileyOverHead,[_loc5_],dofus.Constants.SMILEY_DELAY);
   }
}
