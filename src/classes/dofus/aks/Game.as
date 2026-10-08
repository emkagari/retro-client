class dofus.aks.Game extends dofus.aks.Handler
{
   var aks;
   var api;
   var extendIn;
   static var TYPE_SOLO = 1;
   static var TYPE_FIGHT = 2;
   var _bIsBusy = false;
   var nLastMapIdReceived = -1;
   function Game(oAKS, oAPI)
   {
      super.initialize(oAKS,oAPI);
      this.extendIn = new dofus.aks.extend.GameIn(oAKS,oAPI);
   }
   function get isBusy()
   {
      return this._bIsBusy;
   }
   function set isBusy(bIsBusy)
   {
      this._bIsBusy = bIsBusy;
   }
   function create()
   {
      this.aks.send("GC" + dofus.aks.Game.TYPE_SOLO);
   }
   function leave(sSpriteID)
   {
      this.aks.send("GQ" + (sSpriteID != undefined ? sSpriteID : ""));
   }
   function setPlayerPosition(nCellNum)
   {
      this.aks.send("Gp" + nCellNum,true);
   }
   function ready(bReady)
   {
      this.aks.send("GR" + (!bReady ? "0" : "1"));
   }
   function getMapData(nMapID)
   {
      if(this.api.lang.getConfigText("ENABLE_CLIENT_MAP_REQUEST"))
      {
         this.aks.send("GD" + (nMapID == undefined ? "" : String(nMapID)));
      }
   }
   function getExtraInformations()
   {
      var _loc2_ = "G";
      if(!this.aks.bMachineStateSent)
      {
         if(this.api.electron.getSystemInformation("virtual"))
         {
            _loc2_ += "i";
         }
         else
         {
            _loc2_ += "І";
         }
         this.aks.bMachineStateSent = true;
      }
      else
      {
         _loc2_ += "I";
      }
      this.aks.send(_loc2_);
   }
   function turnEnd()
   {
      if(this.api.datacenter.Player.isCurrentPlayer)
      {
         this.aks.send("Gt",false);
      }
   }
   function turnOk(sSpriteID)
   {
      this.aks.send("GT" + (sSpriteID == undefined ? "" : sSpriteID),false);
   }
   function turnOk2(sSpriteID)
   {
      this.aks.send("GT" + (sSpriteID == undefined ? "" : sSpriteID),false);
   }
   function askDisablePVPMode()
   {
      this.aks.send("GP*",false);
   }
   function enabledPVPMode(bEnabled)
   {
      this.aks.send("GP" + (!bEnabled ? "-" : "+"),false);
   }
   function freeMySoul()
   {
      this.aks.send("GF",false);
   }
   function setFlag(nCellID)
   {
      this.aks.send("Gf" + nCellID,false);
   }
   function showFightChallengeTarget(challengeId)
   {
      this.aks.send("Gdi" + challengeId,false);
   }
   function event(sTag)
   {
      this.aks.send("Ge" + sTag);
      if(this.api.electron.waitingClose)
      {
         this.api.electron.askClose();
      }
   }
   function onCreate(bSuccess, sExtraData)
   {
      if(!bSuccess)
      {
         ank.utils.Logger.err("[onCreate] Impossible de créer la partie");
         return undefined;
      }
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = Number(_loc4_[0]);
      if(_loc5_ != 1)
      {
         ank.utils.Logger.err("[onCreate] Type incorrect");
         return undefined;
      }
      this.api.datacenter.Game = new dofus.datacenter.Game();
      this.api.datacenter.Game.state = _loc5_;
      var _loc6_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      dofus.graphics.gapi.ui.banner.BannerGauge.showGaugeMode(_loc6_);
      _loc6_.chat.removeTemporaryReplacementPanel();
      var _loc7_ = _loc6_.chat.shortcutsReplacementPanel;
      if(_loc7_ != undefined)
      {
         _loc7_.showMiniMap(true);
         _loc7_.updateSprite(undefined);
      }
      this.api.datacenter.Player.data.initAP(false);
      this.api.datacenter.Player.data.initMP(false);
      this.api.datacenter.Player.SpellsManager.clear();
      this.api.datacenter.Player.data.CharacteristicsManager.initialize();
      this.api.datacenter.Player.data.EffectsManager.initialize();
      this.api.datacenter.Player.clearSummon();
      this.api.gfx.cleanMap(1);
      this.onCreateSolo();
   }
   function onJoin(sExtraData)
   {
      this.api.datacenter.Player.guildInfos.defendedTaxCollectorID = undefined;
      if(this.api.gfx.spriteHandler.isPlayerSpritesHidden)
      {
         this.api.gfx.spriteHandler.hideSprites(false);
      }
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = Number(_loc3_[0]);
      var _loc5_ = _loc3_[1] != "0" ? true : false;
      var _loc6_ = _loc3_[2] != "0" ? true : false;
      var _loc7_ = _loc3_[3] != "0" ? true : false;
      var _loc8_ = Number(_loc3_[4]);
      var _loc9_ = Number(_loc3_[5]);
      this.api.datacenter.Game = new dofus.datacenter.Game();
      this.api.datacenter.Game.state = _loc4_;
      this.api.datacenter.Game.fightType = _loc9_;
      var _loc10_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
      _loc10_.redrawChrono();
      _loc10_.updateEye();
      this.api.datacenter.Game.isSpectator = _loc7_;
      if(!_loc7_)
      {
         this.api.datacenter.Player.data.initAP(false);
         this.api.datacenter.Player.data.initMP(false);
         this.api.datacenter.Player.SpellsManager.clear();
      }
      this.api.gfx.cleanMap(1);
      if(this.api.datacenter.Game.isTacticMode)
      {
         this.api.gfx.activateTacticMode(this.api,true);
      }
      if(_loc6_)
      {
         this.api.ui.loadUIComponent("ChallengeMenu","ChallengeMenu",{labelReady:this.api.lang.getText("READY"),labelCancel:this.api.lang.getText("CANCEL_SMALL"),cancelButton:_loc5_,ready:false},{bStayIfPresent:true});
      }
      if(!_global.isNaN(_loc8_))
      {
         _loc10_.startTimer(_loc8_ / 1000);
      }
      this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_OBJECT_NONE);
      this.api.ui.unloadLastUIAutoHideComponent();
      this.api.ui.unloadUIComponent("FightsInfos");
      this.api.ui.unloadUIComponent("GameResult");
      this.api.ui.unloadUIComponent("GameResultLight");
      this.api.ui.getUIComponent("GladiatroolShop").windowHidder(true);
      this.api.ui.getUIComponent("AchievementRewards")._visible = false;
   }
   function onPositionStart(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1];
      var _loc6_ = Number(_loc3_[2]);
      this.api.datacenter.Basics.aks_current_team = _loc6_;
      this.api.datacenter.Basics.aks_team1_starts = [];
      this.api.datacenter.Basics.aks_team2_starts = [];
      this.api.kernel.StreamingDisplayManager.onFightStart();
      this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_NONE);
      this.api.datacenter.Game.setInteractionType("place");
      var _loc7_ = this.api.ui.getUIComponent("Banner");
      _loc7_.showOverweightPods(false);
      if(_loc6_ == undefined)
      {
         ank.utils.Logger.err("[onPositionStart] Impossible de trouver l\'équipe du joueur local !");
      }
      this.api.gfx.mapHandler.showFightCells(_loc4_,_loc5_);
      var _loc8_ = 0;
      var _loc9_;
      while(_loc8_ < _loc4_.length)
      {
         _loc9_ = ank.utils.Compressor.decode64(_loc4_.charAt(_loc8_)) << 6;
         _loc9_ += ank.utils.Compressor.decode64(_loc4_.charAt(_loc8_ + 1));
         this.api.datacenter.Basics.aks_team1_starts.push(_loc9_);
         if(_loc6_ == 0)
         {
            this.api.gfx.setInteractionOnCell(_loc9_,ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
         }
         _loc8_ += 2;
      }
      var _loc10_ = 0;
      var _loc11_;
      while(_loc10_ < _loc5_.length)
      {
         _loc11_ = ank.utils.Compressor.decode64(_loc5_.charAt(_loc10_)) << 6;
         _loc11_ += ank.utils.Compressor.decode64(_loc5_.charAt(_loc10_ + 1));
         this.api.datacenter.Basics.aks_team2_starts.push(_loc11_);
         if(_loc6_ == 1)
         {
            this.api.gfx.setInteractionOnCell(_loc11_,ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
         }
         _loc10_ += 2;
      }
      if(this.api.ui.getUIComponent("FightOptionButtons") == undefined)
      {
         this.api.ui.loadUIComponent("FightOptionButtons","FightOptionButtons");
      }
      this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_FIGHT_PLACEMENT);
   }
   function onPlayersCoordinates(sExtraData)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(sExtraData != "e")
      {
         _loc3_ = sExtraData.split("|");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_].split(";");
            _loc6_ = _loc5_[0];
            _loc7_ = Number(_loc5_[1]);
            this.api.gfx.setSpritePosition(_loc6_,_loc7_);
            _loc4_ = _loc4_ + 1;
         }
      }
      else
      {
         this.api.sounds.events.onError();
      }
   }
   function onReady(sExtraData)
   {
      var _loc3_ = sExtraData.charAt(0) == "1";
      var _loc4_ = sExtraData.substr(1);
      if(_loc3_)
      {
         this.api.gfx.addSpriteExtraClip(_loc4_,dofus.Constants.READY_FILE,undefined,true);
      }
      else
      {
         this.api.gfx.removeSpriteExtraClip(_loc4_,true);
      }
      if(_loc4_ == this.api.datacenter.Player.ID)
      {
         this.api.ui.getUIComponent("ChallengeMenu").ready = _loc3_;
      }
   }
   function onStartToPlay()
   {
      this.api.ui.getUIComponent("Banner").stopTimer();
      this.aks.GameActions.onActionsFinish(this.api.datacenter.Player.ID);
      this.api.sounds.events.onGameStart(this.api.datacenter.Map.musics);
      this.api.kernel.StreamingDisplayManager.onFightStartEnd();
      var _loc2_ = this.api.ui.getUIComponent("Banner");
      _loc2_.showGiveUpButton(true);
      if(this.api.ui.getUIComponent("FightOptionButtons") == undefined)
      {
         this.api.ui.loadUIComponent("FightOptionButtons","FightOptionButtons");
      }
      var _loc3_;
      if(!this.api.datacenter.Game.isSpectator)
      {
         _loc3_ = this.api.datacenter.Player.data;
         _loc3_.initAP();
         _loc3_.initMP();
         _loc2_.showPoints(true);
         _loc2_.showNextTurnButton(true);
         this.api.ui.loadUIComponent("CenterText","CenterText",{text:this.api.lang.getText("GAME_LAUNCH"),background:true,timer:2000},{bForceLoad:true});
         this.api.ui.getUIComponent("FightOptionButtons").onGameRunning();
         _loc2_.shortcuts.setCurrentTab("Spells");
      }
      else
      {
         _loc2_.shortcuts.updateCurrentTabInformations();
      }
      this.api.ui.loadUIComponent("Timeline","Timeline");
      this.api.ui.unloadUIComponent("ChallengeMenu");
      this.api.gfx.unSelect(true);
      this.api.gfx.mapHandler.showingFightCells = false;
      if(!this.api.gfx.gridHandler.bGridVisible)
      {
         this.api.gfx.drawGrid();
      }
      this.api.datacenter.Game.setInteractionType("move");
      this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_NONE);
      this.api.kernel.GameManager.signalFightActivity();
      this.api.datacenter.Game.isRunning = true;
      var _loc4_ = this.api.datacenter.Sprites.getItems();
      var _loc5_;
      for(var k in _loc4_)
      {
         _loc5_ = _loc4_[k];
         this.api.gfx.addSpriteExtraClip(k,_loc5_.circleFilePath,dofus.Constants.TEAMS_COLOR[_loc5_.Team]);
      }
      this.api.datacenter.Game.onWindowFocusChanged({isFocused:this.api.electron.isWindowFocused});
      if(this.api.datacenter.Game.isTacticMode)
      {
         this.api.gfx.activateTacticMode(this.api,true);
      }
      if(this.api.datacenter.Game.isCreatureMode)
      {
         this.api.kernel.GameManager.applyCreatureModeFight(true);
      }
   }
   function onTurnStart(sExtraData)
   {
      var _loc3_;
      if(this.api.datacenter.Game.isFirstTurn)
      {
         this.api.datacenter.Game.isFirstTurn = false;
         _loc3_ = this.api.gfx.spriteHandler.getSprites().getItems();
         for(var sID in _loc3_)
         {
            this.api.gfx.removeSpriteExtraClip(sID,true);
         }
      }
      var _loc4_ = sExtraData.split("|");
      var _loc5_ = _loc4_[0];
      var _loc6_ = Number(_loc4_[1]) / 1000;
      var _loc7_ = Number(_loc4_[2]);
      var _loc8_ = _loc4_.length > 3 && _loc4_[3] == "1";
      this.api.datacenter.Game.currentTableTurn = _loc7_;
      var _loc9_ = this.api.datacenter.Sprites.getItemAt(_loc5_);
      _loc9_.GameActionsManager.clear();
      this.api.gfx.unSelect(true);
      this.api.datacenter.Game.currentPlayerID = _loc5_;
      this.api.kernel.GameManager.cleanPlayer(this.api.datacenter.Game.lastPlayerID);
      this.api.ui.getUIComponent("Timeline").nextTurn(_loc5_);
      if(this.api.datacenter.Player.isCurrentPlayer)
      {
         this.api.electron.makeNotification(this.api.lang.getText("PLAYER_TURN",[this.api.datacenter.Player.Name]));
         if(!this.api.datacenter.Game.passiveTurn && this.api.kernel.OptionsManager.getOption("StartTurnSound"))
         {
            this.api.sounds.events.onTurnStart();
         }
         if(this.api.kernel.GameManager.autoSkip && this.api.datacenter.Game.isFight)
         {
            this.api.network.Game.turnEnd();
         }
         this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE_OVER_OUT);
         if(!_loc8_)
         {
            this.api.datacenter.Player.SpellsManager.nextTurn();
         }
         this.api.ui.getUIComponent("Banner").startTimer(_loc6_);
         this.api.kernel.GameManager.startInactivityDetector();
         if(this.api.gfx.rollOverMcSprite == undefined)
         {
            dofus.DofusCore.getInstance().forceMouseOver();
         }
         this.api.gfx.mapHandler.resetEmptyCells();
      }
      else
      {
         this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_NONE);
         this.api.ui.getUIComponent("Timeline").startChrono(_loc6_);
         if(this.api.datacenter.Game.isSpectator && this.api.kernel.OptionsManager.getOption("SpriteInfos"))
         {
            this.api.ui.getUIComponent("Banner").showRightPanel("BannerSpriteInfos",{data:_loc9_},true);
         }
      }
      var _loc10_;
      if(!this.api.datacenter.Game.passiveTurn && (this.api.kernel.OptionsManager.getOption("StringCourse") && (this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHideStringCourse"))))
      {
         _loc10_ = [];
         _loc10_[1] = _loc9_.color1;
         _loc10_[2] = _loc9_.color2;
         _loc10_[3] = _loc9_.color3;
         this.api.ui.loadUIComponent("StringCourse","StringCourse",{gfx:_loc9_.artworkFile,name:_loc9_.name,level:this.api.lang.getText("LEVEL_SMALL") + " " + _loc9_.Level,colors:_loc10_,gfxID:_loc9_.gfxID,glowFilter:_loc9_.glowFilter},{bForceLoad:true});
      }
      if(this.api.kernel.OptionsManager.getOption("GlowOnCurrentPlayer") && !this.api.datacenter.Game.passiveTurn)
      {
         if(this.api.datacenter.Game.currentPlayerWithGlowID != undefined)
         {
            this.api.gfx.removeGlowOnPlayer(this.api.datacenter.Game.currentPlayerWithGlowID);
         }
         this.api.gfx.setGlowOnPlayer(_loc5_,dofus.Constants.TEAMS_COLOR[_loc9_.Team]);
         this.api.datacenter.Game.currentPlayerWithGlowID = _loc5_;
      }
      var _loc11_;
      var _loc12_;
      if(this.api.electron.isWindowFocused && (_loc9_ instanceof dofus.datacenter.Character && !this.api.datacenter.Game.passiveTurn))
      {
         _loc11_ = new ank.battlefield.datacenter.VisualEffect();
         _loc11_.file = dofus.Constants.HIGHLIGHT_FILE;
         _loc11_.bInFrontOfSprite = false;
         _loc12_ = _loc9_.cellNum;
         this.api.gfx.spriteLaunchVisualEffect(_loc5_,_loc11_,_loc12_,10);
      }
      this.api.kernel.GameManager.cleanUpGameArea(true);
      ank.utils.Timer.setTimer(this.api.network.Ping,"GameDecoDetect",this.api.network,this.api.network.quickPing,_loc6_ * 1000);
      this.api.kernel.TipsManager.showNewTip(dofus.managers.TipsManager.TIP_FIGHT_START);
   }
   function onTurnFinish(sExtraData)
   {
      var _loc3_ = sExtraData;
      var _loc4_ = this.api.datacenter.Sprites.getItemAt(_loc3_);
      if(this.api.datacenter.Player.isCurrentPlayer)
      {
         this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_NONE);
         this.api.kernel.GameManager.stopInactivityDetector();
         this.api.kernel.GameManager.onTurnEnd();
      }
      this.api.datacenter.Game.lastPlayerID = this.api.datacenter.Game.currentPlayerID;
      this.api.datacenter.Game.currentPlayerID = undefined;
      this.api.ui.getUIComponent("Banner").stopTimer();
      this.api.ui.getUIComponent("Timeline").stopChrono();
      this.api.kernel.GameManager.cleanUpGameArea(true);
   }
   function onTurnlist(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      this.api.datacenter.Game.turnSequence = _loc3_;
      this.api.ui.getUIComponent("Timeline").update();
   }
   function onTurnMiddle(sExtraData)
   {
      if(!this.api.datacenter.Game.isRunning)
      {
         ank.utils.Logger.err("[innerOnTurnMiddle] on est pas en combat");
         return undefined;
      }
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = {};
      var _loc5_ = 0;
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
      for(; _loc5_ < _loc3_.length; _loc5_ = _loc5_ + 1)
      {
         _loc6_ = _loc3_[_loc5_].split(";");
         if(_loc6_.length != 0)
         {
            _loc7_ = _loc6_[0];
            _loc8_ = _loc6_[1] != "1" ? false : true;
            _loc9_ = Number(_loc6_[2]);
            _loc10_ = Number(_loc6_[3]);
            _loc11_ = Number(_loc6_[4]);
            _loc12_ = Number(_loc6_[5]);
            _loc13_ = Number(_loc6_[6]);
            _loc14_ = Number(_loc6_[7]);
            _loc4_[_loc7_] = true;
            _loc15_ = this.api.datacenter.Sprites.getItemAt(_loc7_);
            if(_loc15_ != undefined)
            {
               _loc16_ = _loc15_.sequencer;
               if(_loc8_)
               {
                  if(_loc16_.isPlaying())
                  {
                     continue;
                  }
                  _loc15_.mc.clear();
                  this.api.gfx.removeSpriteOverHeadLayer(_loc7_,"text");
               }
               else
               {
                  _loc15_.LP = _loc9_;
                  _loc15_.LPmax = _loc14_;
                  _loc15_.AP = _loc10_;
                  _loc15_.MP = _loc11_;
                  if(_loc16_.isPlaying())
                  {
                     continue;
                  }
                  if(!_global.isNaN(_loc12_) && !_loc15_.hasCarriedParent())
                  {
                     this.api.gfx.setSpritePosition(_loc7_,_loc12_);
                  }
                  if(_loc15_.hasCarriedChild())
                  {
                     _loc15_.carriedChild.updateCarriedPosition();
                  }
               }
            }
            else
            {
               ank.utils.Logger.err("[onTurnMiddle] le sprite n\'existe pas");
            }
         }
      }
      var _loc17_ = this.api.datacenter.Sprites.getItems();
      for(var k in _loc17_)
      {
         if(!_loc4_[k])
         {
            _loc17_[k].mc.clear();
            this.api.datacenter.Sprites.removeItemAt(k);
         }
      }
      this.api.ui.getUIComponent("Timeline").timelineControl.updateCharacters();
   }
   function prepareTurnEnd()
   {
      if(!this.api.datacenter.Game.isRunning || (!this.api.datacenter.Game.isFight || !this.api.datacenter.Player.isCurrentPlayer))
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Player.data.sequencer;
      if(_loc2_.containsAction(this,this.turnEnd))
      {
         return undefined;
      }
      _loc2_.addAction(24,false,this,this.turnEnd,[]);
      _loc2_.execute();
   }
   function onTurnReady(sExtraData)
   {
      var _loc3_ = sExtraData;
      var _loc4_ = this.api.datacenter.Sprites.getItemAt(_loc3_);
      var _loc5_;
      if(_loc4_ != undefined)
      {
         _loc5_ = _loc4_.sequencer;
         _loc5_.addAction(25,false,this,this.turnOk);
         _loc5_.execute();
      }
      else
      {
         ank.utils.Logger.err("[onTurnReday] le sprite " + _loc3_ + " n\'existe pas");
         this.turnOk2();
      }
   }
   function onMapData(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = _loc3_[1];
      var _loc6_ = _loc3_[2];
      if(Number(_loc4_) == this.api.datacenter.Map.id)
      {
         this.api.gfx.onMapLoaded();
         return undefined;
      }
      this.api.gfx.showContainer(false);
      this.nLastMapIdReceived = _global.parseInt(_loc4_,10);
      this.api.kernel.MapsServersManager.loadMap(_loc4_,_loc5_,_loc6_);
      if(this.api.electron.enabled)
      {
         this.api.electron.eventClient("eventMapLoaded");
      }
   }
   function onMapLoaded()
   {
      this.api.gfx.showContainer(true);
      this.api.kernel.GameManager.applyCreatureMode();
      if(dofus.Constants.SAVING_THE_WORLD)
      {
         dofus.SaveTheWorld.getInstance().nextAction();
      }
      if(this.api.datacenter.Game.isRunning && this.api.datacenter.Game.isTacticMode)
      {
         this.api.gfx.activateTacticMode(this.api,true);
      }
   }
   function onMonsterList(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = [];
      var _loc5_ = 0;
      while(_loc5_ < _loc3_.length)
      {
         _loc4_.push(Number(_loc3_[_loc5_]));
         _loc5_ = _loc5_ + 1;
      }
      this.api.datacenter.Game.fightMonsters = _loc4_;
   }
   function onCreateSolo()
   {
      this.api.datacenter.Player.InteractionsManager.setState(false);
      this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_OBJECT_RELEASE_OVER_OUT);
      this.api.ui.removeCursor();
      this.api.ui.getUIComponent("Banner").shortcuts.setCurrentTab("Items");
      this.api.datacenter.Basics.gfx_isSpritesHidden = false;
      this.api.gfx.spriteHandler.unmaskAllSprites();
      var _loc2_;
      if(this.api.ui.getUIComponent("Banner") == undefined)
      {
         this.api.kernel.OptionsManager.applyAllOptions();
         this.api.ui.loadUIComponent("Banner","Banner",{data:this.api.datacenter.Player},{bAlwaysOnTop:true});
         this.api.ui.getUIComponent("AchievementRewards")._visible = true;
         this.api.ui.setScreenSize(742,432);
      }
      else
      {
         _loc2_ = this.api.ui.getUIComponent("Banner");
         _loc2_.showPoints(false);
         _loc2_.showNextTurnButton(false);
         _loc2_.showGiveUpButton(false);
         _loc2_.shortcuts.updateCurrentTabInformations();
         this.api.ui.unloadUIComponent("FightOptionButtons");
         this.api.ui.unloadUIComponent("ChallengeMenu");
         this.api.ui.getUIComponent("AchievementRewards")._visible = true;
      }
      this.api.gfx.cleanMap(2);
      this.api.datacenter.Game.fightMonsters = undefined;
   }
   function onPVP(sExtraData, bEnabled)
   {
      var _loc4_;
      if(!bEnabled)
      {
         _loc4_ = Number(sExtraData);
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ASK_DISABLE_PVP",[_loc4_]),"CAUTION_YESNO",{name:"DisabledPVP",listener:this});
      }
      else
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("ASK_ENABLED_PVP"),"CAUTION_YESNO",{name:"EnabledPVP",listener:this});
      }
   }
   function onHuntInfos(sExtraData)
   {
      var _loc3_ = sExtraData.substring(1);
      var _loc4_ = _loc3_.split("|");
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      switch(sExtraData.charAt(0))
      {
         case "I":
            if(_loc3_ == undefined || _loc3_.length == 0)
            {
               this.api.datacenter.Basics.pvpHuntedSpriteID = undefined;
            }
            else
            {
               this.api.datacenter.Basics.pvpHuntedSpriteID = _loc3_;
            }
            break;
         case "S":
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_[1];
            _loc7_ = _loc5_ != _loc6_;
            _loc8_ = true;
            switch(_loc6_)
            {
               case "WAITING_FOR_TARGET":
                  if(_loc5_ == "WAITING_FOR_START_CONFIRMATION")
                  {
                     this.api.kernel.showMessage(undefined,this.api.lang.getText("HUNT_NOT_AVAILABLE_ANYMORE"),"HUNT_CHAT");
                  }
                  else if(_loc5_ == "NOT_IN_MATCHMAKING")
                  {
                     this.api.kernel.showMessage(undefined,this.api.lang.getText("HUNT_LOOKING_FOR_TARGET_ALIGN_" + this.api.datacenter.Player.alignment.index),"HUNT_CHAT");
                  }
                  break;
               case "WAITING_FOR_START_CONFIRMATION_TIMEOUT":
                  _loc8_ = false;
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("HUNT_REQUEST_TIMEOUT"),"HUNT_CHAT");
                  break;
               case "PLAYER_LEFT_MATCHMAKING":
                  _loc8_ = false;
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("HUNTER_HAS_LEFT_MATCHMAKING"),"HUNT_CHAT");
                  break;
               case "HUNT_STARTED":
                  _loc8_ = false;
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("HUNT_STARTED"),"HUNT_CHAT");
                  break;
               case "WAITING_FOR_START_CONFIRMATION":
                  _loc9_ = this.api.lang.getText("HUNT_FOUND_PART_1_ALIGN_" + this.api.datacenter.Player.alignment.index);
                  _loc10_ = Number(_loc4_[2]);
                  if(_loc10_ == 1)
                  {
                     _loc9_ += this.api.lang.getText("HUNT_FOUND_PART_2_AFTER_WIN");
                  }
                  else if(_loc10_ == 2)
                  {
                     _loc9_ += this.api.lang.getText("HUNT_FOUND_PART_2_AFTER_DEFEAT");
                  }
                  _loc9_ += ". ";
                  _loc9_ += this.api.lang.getText("HUNT_FOUND_PART_3");
                  this.api.kernel.showMessage(undefined,_loc9_,"HUNT_CHAT",undefined,"START_CONFIRMATION");
            }
            this.api.datacenter.Player.huntMatchmakingStatus = new dofus.datacenter.HuntMatchmakingStatus(_loc8_,_loc6_);
         default:
            return;
      }
   }
   function hunterAcceptPvPHunt()
   {
      this.aks.send("GhA");
   }
   function toggleHunterMatchmakingRegister()
   {
      if(this.api.datacenter.Player.isHuntMatchmakingActive())
      {
         this.api.network.Game.hunterMatchmakingUnregister();
      }
      else
      {
         this.api.network.Game.hunterMatchmakingRegister();
      }
   }
   function hunterMatchmakingRegister()
   {
      this.aks.send("Ghr");
   }
   function hunterMatchmakingUnregister()
   {
      this.aks.send("Ghu");
   }
   function onFlag(sExtraData)
   {
      var _loc3_ = sExtraData.split("|");
      var _loc4_ = _loc3_[0];
      var _loc5_ = Number(_loc3_[1]);
      var _loc6_ = this.api.datacenter.Sprites.getItemAt(_loc4_);
      var _loc7_ = new ank.battlefield.datacenter.VisualEffect();
      _loc7_.file = dofus.Constants.CLIPS_PATH + "flag.swf";
      _loc7_.bInFrontOfSprite = true;
      _loc7_.bTryToBypassContainerColor = true;
      this.api.kernel.showMessage(undefined,this.api.lang.getText("PLAYER_SET_FLAG",[_loc6_.name,"<a href=\"asfunction:onHref,highlightCell," + _loc5_ + "\">" + _loc5_ + "</a>"]),"INFO_CHAT");
      this.api.gfx.spriteLaunchVisualEffect(_loc4_,_loc7_,_loc5_,11,undefined,undefined,undefined,true);
   }
   function onFightChallenge(sExtraData)
   {
      var _loc3_ = sExtraData.split(";");
      if(!this.api.ui.getUIComponent("FightChallenge"))
      {
         this.api.ui.loadUIComponent("FightChallenge","FightChallenge");
      }
      var _loc4_ = Number(_loc3_.shift());
      var _loc5_ = _loc3_.shift() == "1";
      var _loc6_ = Number(_loc3_.shift());
      var _loc7_ = Number(_loc3_.shift());
      var _loc8_ = Number(_loc3_.shift());
      var _loc9_ = new dofus.datacenter.FightChallengeData(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc3_);
      var _loc10_ = dofus.graphics.gapi.ui.FightChallenge(this.api.ui.getUIComponent("FightChallenge"));
      _loc10_.addChallenge(_loc9_);
   }
   function onFightChallengeUpdate(sExtraData, success)
   {
      var _loc4_ = Number(sExtraData);
      dofus.graphics.gapi.ui.FightChallenge(dofus.graphics.gapi.ui.FightChallenge(this.api.ui.getUIComponent("FightChallenge"))).updateChallenge(_loc4_,success);
      var _loc5_ = !success ? this.api.lang.getText("FIGHT_CHALLENGE_FAILED") : this.api.lang.getText("FIGHT_CHALLENGE_DONE");
      _loc5_ += " : " + this.api.lang.getFightChallenge(_loc4_).n;
      var _loc6_ = this.api.datacenter.Sprites.getItemAt(this.api.datacenter.Game.currentPlayerID).sequencer;
      if(_loc6_ != undefined)
      {
         _loc6_.addAction(3133,false,this.api.kernel,this.api.kernel.showMessage,[undefined,_loc5_,"INFO_CHAT"],0);
         return undefined;
      }
      this.api.kernel.showMessage(undefined,_loc5_,"INFO_CHAT");
   }
   function cancel(oEvent)
   {
      var _loc0_ = oEvent.target._name;
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoEnabledPVP":
            this.api.network.Game.enabledPVPMode(true);
            break;
         case "AskYesNoDisabledPVP":
            this.api.network.Game.enabledPVPMode(false);
         default:
            return;
      }
   }
   function no(oEvent)
   {
      var _loc0_ = oEvent.target._name;
   }
}
