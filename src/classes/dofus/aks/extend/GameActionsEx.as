247520502 - 1;
class dofus.aks.extend.GameActionsEx
{
   var _parent;
   var api;
   function GameActionsEx(oAPI, parent)
   {
      this.api = oAPI;
      this._parent = parent;
   }
   function onActionEx(sExtraData, nActionType, sSenderID, oSeq, sParams, oContext)
   {
      var _loc8_ = true;
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
      var _loc28_;
      var _loc29_;
      var _loc30_;
      var _loc31_;
      var _loc32_;
      var _loc33_;
      var _loc34_;
      var _loc35_;
      var _loc36_;
      var _loc37_;
      var _loc38_;
      var _loc39_;
      var _loc40_;
      var _loc41_;
      var _loc42_;
      var _loc43_;
      var _loc44_;
      var _loc45_;
      var _loc46_;
      var _loc47_;
      var _loc48_;
      var _loc49_;
      var _loc50_;
      var _loc51_;
      var _loc52_;
      var _loc53_;
      var _loc54_;
      var _loc55_;
      var _loc56_;
      var _loc57_;
      var _loc58_;
      var _loc59_;
      var _loc60_;
      var _loc61_;
      var _loc62_;
      var _loc63_;
      var _loc64_;
      var _loc65_;
      var _loc66_;
      var _loc67_;
      var _loc68_;
      var _loc69_;
      var _loc70_;
      var _loc71_;
      var _loc72_;
      var _loc73_;
      var _loc74_;
      var _loc75_;
      var _loc76_;
      var _loc77_;
      var _loc78_;
      var _loc79_;
      var _loc80_;
      var _loc81_;
      var _loc82_;
      var _loc83_;
      var _loc84_;
      var _loc85_;
      var _loc86_;
      var _loc87_;
      var _loc88_;
      var _loc89_;
      var _loc90_;
      var _loc91_;
      var _loc92_;
      var _loc93_;
      var _loc94_;
      var _loc95_;
      var _loc96_;
      var _loc97_;
      var _loc98_;
      var _loc99_;
      var _loc100_;
      var _loc101_;
      var _loc102_;
      var _loc103_;
      var _loc104_;
      var _loc105_;
      var _loc106_;
      var _loc107_;
      var _loc108_;
      var _loc109_;
      var _loc110_;
      var _loc111_;
      var _loc112_;
      var _loc113_;
      var _loc114_;
      var _loc115_;
      var _loc116_;
      var _loc117_;
      var _loc118_;
      var _loc119_;
      var _loc120_;
      var _loc121_;
      var _loc122_;
      var _loc123_;
      var _loc124_;
      var _loc125_;
      var _loc126_;
      var _loc127_;
      var _loc128_;
      switch(nActionType)
      {
         case 1:
            _loc9_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            if(!this.api.gfx.isMapBuild)
            {
               _loc8_ = false;
               break;
            }
            if(dofus.Constants.USE_JS_LOG && (_global.CONFIG.isNewAccount && !this.api.datacenter.Basics.first_movement))
            {
               getURL("JavaScript:WriteLog(\'Mouvement\')","_self");
               this.api.datacenter.Basics.first_movement = true;
            }
            if(sSenderID == this.api.datacenter.Player.ID && (this.api.datacenter.Game.isFight && this.api.datacenter.Game.isRunning))
            {
               oSeq.addAction(35,false,this.api.gfx,this.api.gfx.setInteraction,[ank.battlefield.Constants.INTERACTION_CELL_NONE]);
            }
            _loc10_ = ank.battlefield.utils.Compressor.extractFullPath(this.api.gfx.mapHandler,sParams);
            if(_loc9_.hasCarriedParent() && !_loc9_.uncarryingSprite)
            {
               _loc9_.uncarryingSprite = true;
               _loc10_.shift();
               oSeq.addAction(174,false,this.api.gfx,this.api.gfx.uncarriedSprite,[sSenderID,_loc10_[0],true,oSeq]);
               oSeq.addAction(36,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[sSenderID,_loc9_.circleFilePath,dofus.Constants.TEAMS_COLOR[_loc9_.Team]]);
            }
            _loc11_ = _loc9_.forceRun;
            _loc12_ = _loc9_.forceWalk;
            _loc13_ = !this.api.datacenter.Game.isFight ? (!(_loc9_ instanceof dofus.datacenter.Character) ? 6 : 3) : 3;
            if(this.api.datacenter.Game.isRunning)
            {
               oSeq.addAction(175,false,this.api.gfx,this.api.gfx.moveSpriteWithUncompressedPath,[sSenderID,_loc10_,oSeq,false,_loc11_,_loc12_,_loc13_]);
            }
            else
            {
               if(sSenderID == this.api.datacenter.Player.ID)
               {
                  if((this.api.datacenter.Game.nTransmittingStates & dofus.datacenter.Game.STATE_MOVE_BIT) == dofus.datacenter.Game.STATE_NONE)
                  {
                     this.api.datacenter.Player._nGatherStat++;
                  }
                  this.api.datacenter.Game.nTransmittingStates &= dofus.datacenter.Game.STATE_MOVE_BIT ^ -1;
               }
               this.api.gfx.moveSpriteWithUncompressedPath(sSenderID,_loc10_,oSeq,true,_loc11_,_loc12_,_loc13_);
            }
            break;
         case 2:
            if(oSeq == undefined)
            {
               this.api.gfx.clear();
               this.api.datacenter.clearGame();
               if(!this.api.kernel.TutorialManager.isTutorialMode)
               {
                  this.api.ui.loadUIComponent("CenterText","CenterTextMap",{text:this.api.lang.getText("LOADING_MAP"),timer:40000},{bForceLoad:true});
               }
            }
            else
            {
               oSeq.addAction(38,false,this.api.gfx,this.api.gfx.clear);
               oSeq.addAction(39,false,this.api.datacenter,this.api.datacenter.clearGame);
               if(sParams.length == 0)
               {
                  oSeq.addAction(40,true,this.api.ui,this.api.ui.loadUIComponent,["CenterText","CenterTextMap",{text:this.api.lang.getText("LOADING_MAP"),timer:40000},{bForceLoad:true}]);
               }
               else
               {
                  oSeq.addAction(41,true,this.api.ui,this.api.ui.loadUIComponent,["Cinematic","Cinematic",{file:dofus.Constants.CINEMATICS_PATH + sParams + ".swf",sequencer:oSeq,background:true,banner:true,npc:true,frameToStart:1}]);
               }
            }
            break;
         case 4:
            _loc14_ = sParams.split(",");
            _loc15_ = _loc14_[0];
            _loc16_ = Number(_loc14_[1]);
            _loc17_ = this.api.datacenter.Sprites.getItemAt(_loc15_);
            _loc18_ = _loc17_.mc;
            oSeq.addAction(42,false,_loc18_,_loc18_.setPosition,[_loc16_]);
            break;
         case 5:
            _loc19_ = sParams.split(",");
            _loc20_ = _loc19_[0];
            _loc21_ = Number(_loc19_[1]);
            _loc22_ = _loc19_[2];
            switch(_loc22_)
            {
               case "0":
                  _loc22_ = "static";
                  break;
               case "1":
                  _loc22_ = "walk";
                  break;
               case "2":
                  _loc22_ = "run";
            }
            this.api.gfx.slideSprite(_loc20_,_loc21_,oSeq,_loc22_);
            break;
         case 501:
            _loc23_ = sParams.split(",");
            _loc24_ = _loc23_[0];
            _loc25_ = Number(_loc23_[1]);
            _loc26_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc27_ = _loc23_[2] != undefined ? "anim" + _loc23_[2] : _loc26_.ToolAnimation;
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               if((this.api.datacenter.Game.nTransmittingStates & dofus.datacenter.Game.STATE_GATHER_BIT) == dofus.datacenter.Game.STATE_NONE)
               {
                  this.api.datacenter.Player.haveFakeAlignment++;
               }
               this.api.datacenter.Game.nTransmittingStates &= dofus.datacenter.Game.STATE_GATHER_BIT ^ -1;
            }
            oSeq.addAction(111,false,this.api.gfx,this.api.gfx.autoCalculateSpriteDirection,[sSenderID,_loc24_]);
            oSeq.addAction(112,sSenderID == this.api.datacenter.Player.ID,this.api.gfx,this.api.gfx.setSpriteLoopAnim,[sSenderID,_loc27_,_loc25_],_loc25_,true);
            break;
         case 617:
            oContext.bSequence = false;
            _loc28_ = sParams.split(",");
            _loc29_ = this.api.datacenter.Sprites.getItemAt(Number(_loc28_[0]));
            _loc30_ = this.api.datacenter.Sprites.getItemAt(Number(_loc28_[1]));
            _loc31_ = _loc28_[2];
            this.api.gfx.addSpriteBubble(_loc31_,this.api.lang.getText("A_ASK_MARRIAGE_B",[_loc29_.name,_loc30_.name]));
            if(_loc29_.id == this.api.datacenter.Player.ID)
            {
               this.api.kernel.showMessage(this.api.lang.getText("MARRIAGE"),this.api.lang.getText("A_ASK_MARRIAGE_B",[_loc29_.name,_loc30_.name]),"CAUTION_YESNO",{name:"Marriage",listener:this._parent,params:{spriteID:_loc29_.id,refID:sSenderID}});
            }
            break;
         case 618:
         case 619:
            oContext.bSequence = false;
            _loc32_ = sParams.split(",");
            _loc33_ = this.api.datacenter.Sprites.getItemAt(Number(_loc32_[0]));
            _loc34_ = this.api.datacenter.Sprites.getItemAt(Number(_loc32_[1]));
            _loc35_ = _loc32_[2];
            _loc36_ = nActionType != 618 ? "A_NOT_MARRIED_B" : "A_MARRIED_B";
            this.api.gfx.addSpriteBubble(_loc35_,this.api.lang.getText(_loc36_,[_loc33_.name,_loc34_.name]));
            break;
         case 900:
            oContext.bSequence = false;
            _loc37_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc38_ = this.api.datacenter.Sprites.getItemAt(Number(sParams));
            if(_loc37_ == undefined || (_loc38_ == undefined || (this.api.ui.getUIComponent("AskCancelChallenge") != undefined || this.api.ui.getUIComponent("AskYesNoIgnoreChallenge") != undefined)))
            {
               this._parent.refuseChallenge(sSenderID);
               _loc8_ = false;
               break;
            }
            this.api.kernel.showMessage(undefined,this.api.lang.getText("A_CHALENGE_B",[this.api.kernel.ChatManager.getLinkName(_loc37_.id,_loc37_.name),this.api.kernel.ChatManager.getLinkName(_loc38_.id,_loc38_.name)]),"INFO_CHAT");
            if(_loc37_.id == this.api.datacenter.Player.ID)
            {
               this.api.kernel.showMessage(this.api.lang.getText("CHALENGE"),this.api.lang.getText("YOU_CHALENGE_B",[_loc38_.name]),"INFO_CANCEL",{name:"Challenge",listener:this._parent,params:{spriteID:_loc37_.id}});
            }
            if(_loc38_.id == this.api.datacenter.Player.ID)
            {
               if(this.api.kernel.ChatManager.isBlacklisted(_loc37_.name))
               {
                  this._parent.refuseChallenge(_loc37_.id);
                  _loc8_ = false;
                  break;
               }
               this.api.electron.makeNotification(this.api.lang.getText("A_CHALENGE_YOU",[_loc37_.name]));
               this.api.kernel.showMessage(this.api.lang.getText("CHALENGE"),this.api.lang.getText("A_CHALENGE_YOU",[_loc37_.name]),"CAUTION_YESNOIGNORE",{name:"Challenge",player:_loc37_.name,listener:this._parent,params:{spriteID:_loc37_.id,player:_loc37_.name}});
               this.api.sounds.events.onGameInvitation();
            }
            break;
         case 901:
            oContext.bSequence = false;
            if(sSenderID == this.api.datacenter.Player.ID || Number(sParams) == this.api.datacenter.Player.ID)
            {
               this.api.ui.unloadUIComponent("AskCancelChallenge");
            }
            break;
         case 902:
            oContext.bSequence = false;
            this.api.ui.unloadUIComponent("AskYesNoIgnoreChallenge");
            this.api.ui.unloadUIComponent("AskCancelChallenge");
            break;
         case 903:
            oContext.bSequence = false;
            switch(sParams)
            {
               case "c":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CHALENGE_FULL"),"ERROR_CHAT");
                  break;
               case "t":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("TEAM_FULL"),"ERROR_CHAT");
                  break;
               case "a":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("TEAM_DIFFERENT_ALIGNMENT"),"ERROR_CHAT");
                  break;
               case "g":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_DO_BECAUSE_GUILD"),"ERROR_CHAT");
                  break;
               case "l":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_DO_TOO_LATE"),"ERROR_CHAT");
                  break;
               case "m":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_U_ARE_MUTANT"),"ERROR_CHAT");
                  break;
               case "p":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_MAP"),"ERROR_CHAT");
                  break;
               case "r":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_BECAUSE_ON_RESPAWN"),"ERROR_CHAT");
                  break;
               case "o":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_YOU_R_OCCUPED"),"ERROR_CHAT");
                  break;
               case "z":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_YOU_OPPONENT_OCCUPED"),"ERROR_CHAT");
                  break;
               case "h":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_FIGHT"),"ERROR_CHAT");
                  break;
               case "i":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_FIGHT_NO_RIGHTS"),"ERROR_CHAT");
                  break;
               case "s":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("ERROR_21"),"ERROR_CHAT");
                  break;
               case "n":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("SUBSCRIPTION_OUT"),"ERROR_CHAT");
                  break;
               case "b":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("A_NOT_SUBSCRIB"),"ERROR_CHAT");
                  break;
               case "f":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("TEAM_CLOSED"),"ERROR_CHAT");
                  break;
               case "d":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("NO_ZOMBIE_ALLOWED"),"ERROR_CHAT");
                  break;
               case "x":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_TARGET_NOT_IN_HOUSE"),"ERROR_CHAT");
                  break;
               case "k":
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_TARGET_SAME_ALIGN"),"ERROR_CHAT");
            }
            break;
         case 905:
            this.api.ui.loadUIComponent("CenterText","CenterText",{text:this.api.lang.getText("YOU_ARE_ATTAC"),background:true,timer:2000},{bForceLoad:true});
            break;
         case 906:
            _loc39_ = sParams;
            _loc40_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc41_ = this.api.datacenter.Sprites.getItemAt(_loc39_);
            _loc42_ = _loc40_.name;
            _loc43_ = _loc41_.name;
            if(_loc42_ == undefined || _loc43_ == undefined)
            {
               break;
            }
            this.api.kernel.showMessage(undefined,this.api.lang.getText("A_ATTACK_B",[this.api.kernel.ChatManager.getLinkName(_loc40_.id,_loc42_),this.api.kernel.ChatManager.getLinkName(_loc41_.id,_loc43_)]),"INFO_CHAT");
            if(_loc39_ == this.api.datacenter.Player.ID)
            {
               this.api.electron.makeNotification(this.api.lang.getText("A_ATTACK_B",[_loc42_,_loc43_]));
               this.api.ui.loadUIComponent("CenterText","CenterText",{text:this.api.lang.getText("YOU_ARE_ATTAC"),background:true,timer:2000},{bForceLoad:true});
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_AGRESSED);
            }
            else
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_AGRESS);
            }
            break;
         case 909:
            _loc44_ = sParams;
            _loc45_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc46_ = this.api.datacenter.Sprites.getItemAt(_loc44_);
            this.api.kernel.showMessage(undefined,this.api.lang.getText("A_ATTACK_B",[_loc45_.name,_loc46_.name]),"INFO_CHAT");
            break;
         case 950:
            _loc47_ = sParams.split(",");
            _loc48_ = _loc47_[0];
            _loc49_ = this.api.datacenter.Sprites.getItemAt(_loc48_);
            _loc50_ = Number(_loc47_[1]);
            _loc51_ = Number(_loc47_[2]) != 1 ? false : true;
            if(_loc50_ == 8 && (!_loc51_ && (_loc49_.hasCarriedParent() && !_loc49_.uncarryingSprite)))
            {
               _loc49_.uncarryingSprite = true;
               oSeq.addAction(173,false,this.api.gfx,this.api.gfx.uncarriedSprite,[sSenderID,_loc49_.cellNum,false,oSeq]);
               oSeq.addAction(113,false,this.api.gfx,this.api.gfx.addSpriteExtraClip,[_loc48_,_loc49_.circleFilePath,dofus.Constants.TEAMS_COLOR[_loc49_.Team]]);
            }
            oSeq.addAction(114,false,_loc49_,_loc49_.setState,[this.api,_loc50_,_loc51_]);
            _loc52_ = !_loc51_ ? "EXIT_STATE" : "ENTER_STATE";
            oSeq.addAction(115,false,this.api.kernel.ChatManager.feMessagesBuffer,this.api.kernel.ChatManager.feMessagesBuffer.addFightEventMessage,[nActionType,[_loc52_],[this.api.lang.getStateText(_loc50_)],_loc49_.id,_loc49_.name]);
            if(_loc48_ == this.api.datacenter.Player.ID)
            {
               _loc53_ = this.api.ui.getUIComponent("Banner");
               oSeq.addAction(116,false,_loc53_,_loc53_.statesChanged,[]);
            }
            break;
         case 998:
            _loc54_ = sExtraData.split(",");
            _loc55_ = _loc54_[0];
            _loc56_ = _loc54_[0];
            _loc57_ = _loc54_[2];
            _loc58_ = _loc54_[3];
            _loc59_ = _loc54_[4];
            _loc60_ = _loc54_[6];
            _loc61_ = _loc54_[7];
            _loc62_ = new dofus.datacenter.Effect(undefined,Number(_loc56_),Number(_loc57_),Number(_loc58_),Number(_loc59_),"",Number(_loc60_),Number(_loc61_));
            _loc63_ = this.api.datacenter.Sprites.getItemAt(_loc55_);
            _loc63_.EffectsManager.addEffect(_loc62_);
            break;
         case 300:
            _loc64_ = sParams.split(",");
            _loc65_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc66_ = Number(_loc64_[0]);
            _loc67_ = Number(_loc64_[1]);
            _loc68_ = _loc64_[2];
            _loc69_ = Number(_loc64_[3]);
            _loc70_ = Number(_loc64_[4]);
            if(!(_loc64_[5] == "-1" || _loc64_[5] == "-2"))
            {
               _loc71_ = !_loc65_.creatureModeApplied ? (!_global.isNaN(Number(_loc64_[5])) ? "anim" + _loc64_[5] : String(_loc64_[5]).split("~")) : "anim1";
            }
            _loc72_ = false;
            if(Number(_loc64_[5]) == -2)
            {
               _loc72_ = true;
            }
            _loc73_ = _loc64_[6] != "1" ? false : true;
            _loc74_ = new ank.battlefield.datacenter.VisualEffect();
            _loc74_.file = dofus.Constants.SPELLS_PATH + _loc68_ + ".swf";
            _loc74_.level = _loc69_;
            _loc74_.bInFrontOfSprite = _loc73_;
            _loc74_.params = new dofus.datacenter.Spell(_loc66_,_loc69_).elements;
            oSeq.addAction(88,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_LAUNCH_SPELL",[_loc65_.name,this.api.lang.getSpellText(_loc66_).n]),"INFO_FIGHT_CHAT"]);
            if(_loc71_ != undefined || _loc72_)
            {
               if(!this.api.datacenter.Player.isSkippingFightAnimations)
               {
                  this.api.gfx.spriteLaunchVisualEffect(sSenderID,_loc74_,_loc67_,_loc70_,_loc71_);
               }
            }
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               _loc75_ = this.api.datacenter.Player.SpellsManager;
               _loc76_ = this.api.gfx.mapHandler.getCellData(_loc67_).spriteOnID;
               _loc77_ = new dofus.datacenter.LaunchedSpell(_loc66_,_loc76_);
               _loc75_.addLaunchedSpell(_loc77_);
            }
            break;
         case 301:
            _loc78_ = Number(sParams);
            oSeq.addAction(89,false,this.api.sounds.events,this.api.sounds.events.onGameCriticalHit,[]);
            oSeq.addAction(90,false,this.api.kernel,this.api.kernel.showMessage,[undefined,"(" + this.api.lang.getText("CRITICAL_HIT") + ")","INFO_FIGHT_CHAT"]);
            if(!this.api.datacenter.Player.isSkippingFightAnimations && (this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideCriticalHit")))
            {
               oSeq.addAction(91,false,this.api.gfx,this.api.gfx.addSpriteExtraClipOnTimer,[sSenderID,dofus.Constants.CRITICAL_HIT_XTRA_FILE,undefined,true,dofus.Constants.CRITICAL_HIT_DURATION]);
            }
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_OWNER);
            }
            else
            {
               _loc79_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
               _loc80_ = this.api.datacenter.Sprites.getItemAt(Number(sSenderID)).Team;
               if(_loc79_ == _loc80_)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_ALLIED);
               }
               else
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_ENEMY);
               }
            }
            break;
         case 302:
            _loc81_ = Number(sParams);
            _loc82_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            oSeq.addAction(92,false,this.api.sounds.events,this.api.sounds.events.onGameCriticalMiss,[]);
            oSeq.addAction(93,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_LAUNCH_SPELL",[_loc82_.name,this.api.lang.getSpellText(_loc81_).n]),"INFO_FIGHT_CHAT"]);
            oSeq.addAction(94,false,this.api.kernel,this.api.kernel.showMessage,[undefined,"(" + this.api.lang.getText("CRITICAL_MISS") + ")","INFO_FIGHT_CHAT"]);
            oSeq.addAction(95,false,this.api.gfx,this.api.gfx.addSpriteBubble,[sSenderID,this.api.lang.getText("CRITICAL_MISS")]);
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_OWNER);
            }
            else
            {
               _loc83_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
               _loc84_ = this.api.datacenter.Sprites.getItemAt(Number(sSenderID)).Team;
               if(_loc83_ == _loc84_)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_ALLIED);
               }
               else
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_ENEMY);
               }
            }
            break;
         case 303:
            _loc85_ = sParams.split(";");
            _loc86_ = _loc85_[0].split(",");
            _loc87_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc88_ = _loc87_.mc;
            _loc89_ = !_loc87_.creatureModeApplied ? _loc87_.ToolAnimation : "anim1";
            _loc90_ = Number(_loc86_[0]);
            _loc91_ = _loc86_[1];
            _loc92_ = Number(_loc86_[2]);
            _loc93_ = _loc86_[3] != "1" ? false : true;
            _loc94_ = new dofus.datacenter.CloseCombat(new dofus.datacenter.Item(undefined,_loc85_[1]),_loc87_.Guild);
            oSeq.addAction(96,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_ATTACK_CC_NAME",[_loc87_.name,_loc85_[1] != 0 ? _loc94_.name : this.api.lang.getSpellText(0).n]),"INFO_FIGHT_CHAT"]);
            _loc95_ = new ank.battlefield.datacenter.VisualEffect();
            _loc95_.file = dofus.Constants.SPELLS_PATH + _loc91_ + ".swf";
            _loc95_.level = 1;
            _loc95_.bInFrontOfSprite = _loc93_;
            _loc95_.params = _loc94_.elements;
            this.api.gfx.spriteLaunchVisualEffect(sSenderID,_loc95_,_loc90_,_loc92_,_loc89_);
            break;
         case 304:
            _loc96_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc97_ = _loc96_.mc;
            oSeq.addAction(99,false,this.api.sounds.events,this.api.sounds.events.onGameCriticalHit,[]);
            oSeq.addAction(100,false,this.api.kernel,this.api.kernel.showMessage,[undefined,"(" + this.api.lang.getText("CRITICAL_HIT") + ")","INFO_FIGHT_CHAT"]);
            if(!this.api.datacenter.Player.isSkippingFightAnimations && (this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideHit")))
            {
               oSeq.addAction(101,false,this.api.gfx,this.api.gfx.addSpriteExtraClipOnTimer,[sSenderID,dofus.Constants.CRITICAL_HIT_XTRA_FILE,undefined,true,dofus.Constants.CRITICAL_HIT_DURATION]);
            }
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_OWNER);
            }
            else
            {
               _loc98_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
               _loc99_ = this.api.datacenter.Sprites.getItemAt(Number(sSenderID)).Team;
               if(_loc98_ == _loc99_)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_ALLIED);
               }
               else
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_CC_ENEMY);
               }
            }
            break;
         case 305:
            _loc100_ = sParams.split(";");
            _loc101_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc102_ = _loc100_[0] != 0 ? new dofus.datacenter.CloseCombat(new dofus.datacenter.Item(undefined,_loc100_[0]),_loc101_.Guild) : this.api.lang.getSpellText(0).n;
            oSeq.addAction(102,false,this.api.sounds.events,this.api.sounds.events.onGameCriticalMiss,[]);
            oSeq.addAction(103,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_ATTACK_CC_NAME",[_loc101_.name,_loc102_.name]),"INFO_FIGHT_CHAT"]);
            oSeq.addAction(104,false,this.api.kernel,this.api.kernel.showMessage,[undefined,"(" + this.api.lang.getText("CRITICAL_MISS") + ")","INFO_FIGHT_CHAT"]);
            oSeq.addAction(105,false,this.api.gfx,this.api.gfx.addSpriteBubble,[sSenderID,this.api.lang.getText("CRITICAL_MISS")]);
            if(sSenderID == this.api.datacenter.Player.ID)
            {
               this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_OWNER);
            }
            else
            {
               _loc103_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Player.ID).Team;
               _loc104_ = this.api.datacenter.Sprites.getItemAt(Number(sSenderID)).Team;
               if(_loc103_ == _loc104_)
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_ALLIED);
               }
               else
               {
                  this.api.kernel.SpeakingItemsManager.triggerEvent(dofus.managers.SpeakingItemsManager.SPEAK_TRIGGER_EC_ENEMY);
               }
            }
            break;
         case 306:
            _loc105_ = sParams.split(",");
            _loc106_ = Number(_loc105_[0]);
            _loc107_ = Number(_loc105_[1]);
            _loc108_ = _loc105_[2];
            _loc109_ = Number(_loc105_[3]);
            _loc110_ = _loc105_[4] != "1" ? false : true;
            _loc111_ = Number(_loc105_[5]);
            _loc112_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc113_ = this.api.datacenter.Sprites.getItemAt(_loc111_);
            _loc114_ = new ank.battlefield.datacenter.VisualEffect();
            _loc114_.id = _loc106_;
            _loc114_.file = dofus.Constants.SPELLS_PATH + _loc108_ + ".swf";
            _loc114_.level = _loc109_;
            _loc114_.bInFrontOfSprite = _loc110_;
            oSeq.addAction(106,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_START_TRAP",[_loc112_.name,this.api.lang.getSpellText(_loc114_.id).n,_loc113_.name]),"INFO_FIGHT_CHAT"]);
            oSeq.addAction(107,false,this.api.gfx,this.api.gfx.addVisualEffectOnSprite,[_loc111_,_loc114_,_loc107_,11],1000);
            break;
         case 307:
            _loc115_ = sParams.split(",");
            _loc116_ = Number(_loc115_[0]);
            _loc117_ = Number(_loc115_[1]);
            _loc118_ = Number(_loc115_[3]);
            _loc119_ = Number(_loc115_[5]);
            _loc120_ = this.api.datacenter.Sprites.getItemAt(sSenderID);
            _loc121_ = this.api.datacenter.Sprites.getItemAt(_loc119_);
            _loc122_ = new dofus.datacenter.Spell(_loc116_,_loc118_);
            oSeq.addAction(108,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_START_GLIPH",[_loc120_.name,_loc122_.name,_loc121_.name]),"INFO_FIGHT_CHAT"]);
            break;
         case 308:
            _loc123_ = sParams.split(",");
            _loc124_ = this.api.datacenter.Sprites.getItemAt(Number(_loc123_[0]));
            _loc125_ = Number(_loc123_[1]);
            oSeq.addAction(109,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_DODGE_AP",[_loc124_.name,_loc125_]),"INFO_FIGHT_CHAT"]);
            break;
         case 309:
            _loc126_ = sParams.split(",");
            _loc127_ = this.api.datacenter.Sprites.getItemAt(Number(_loc126_[0]));
            _loc128_ = Number(_loc126_[1]);
            oSeq.addAction(110,false,this.api.kernel,this.api.kernel.showMessage,[undefined,this.api.lang.getText("HAS_DODGE_MP",[_loc127_.name,_loc128_]),"INFO_FIGHT_CHAT"]);
      }
      return _loc8_;
   }
}
