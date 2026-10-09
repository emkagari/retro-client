class dofus.graphics.battlefield.DofusBattlefield extends ank.battlefield.Battlefield
{
   var _oAPI;
   var _rollOverMcObject;
   var _rollOverMcSprite;
   var dispatchEvent;
   var mapHandler;
   function DofusBattlefield()
   {
      super();
   }
   function get api()
   {
      return this._oAPI;
   }
   function get rollOverMcSprite()
   {
      return this._rollOverMcSprite;
   }
   function get rollOverMcObject()
   {
      return this._rollOverMcObject;
   }
   function set rollOverMcObject(rollOverMcObject)
   {
      this._rollOverMcObject = rollOverMcObject;
   }
   function initialize(oDatacenter, sGroundFile, sObjectFile, sAccessoriesPath, oAPI)
   {
      super.initialize(oDatacenter,sGroundFile,sObjectFile,sAccessoriesPath,oAPI);
      mx.events.EventDispatcher.initialize(this);
      this._oAPI = oAPI;
   }
   function addSpritePoints(sID, sValue, nTypePoint)
   {
      if(this.api.kernel.OptionsManager.getOption("PointsOverHead") && (this.api.electron.isWindowFocused || !this.api.kernel.OptionsManager.getOption("AntiLagHidePoints")))
      {
         super.addSpritePoints(sID,sValue,nTypePoint);
      }
   }
   function onInitError()
   {
      _root.onCriticalError(this.api.lang.getText("CRITICAL_ERROR_LOADING_BATTLEFIELD"));
   }
   function onMapLoaded()
   {
      this._rollOverMcObject = undefined;
      this._rollOverMcSprite = undefined;
      var _loc2_ = this.api.datacenter.Map;
      this.api.ui.unloadUIComponent("CenterText");
      this.api.ui.unloadUIComponent("CenterTextMap");
      this.api.ui.unloadUIComponent("FightsInfos");
      this.setInteraction(ank.battlefield.Constants.INTERACTION_NONE);
      this.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
      this.setInteraction(ank.battlefield.Constants.INTERACTION_SPRITE_RELEASE_OVER_OUT);
      if(this.api.datacenter.Game.isFight)
      {
         this.setInteraction(ank.battlefield.Constants.INTERACTION_OBJECT_NONE);
      }
      else
      {
         this.setInteraction(ank.battlefield.Constants.INTERACTION_OBJECT_RELEASE_OVER_OUT);
      }
      this.api.datacenter.Game.setInteractionType("move");
      this.api.network.Game.getExtraInformations();
      this.api.ui.unloadLastUIAutoHideComponent();
      if(_loc2_.isGladiatrool && _loc2_.id != 15080)
      {
         this.api.ui.getUIComponent("GladiatroolShop").windowHidder(false);
      }
      this.api.ui.removePopupMenu();
      this.api.ui.getUIComponent("MapInfos").update();
      var _loc3_ = _loc2_.subarea;
      var _loc4_ = _loc2_.mapName;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      if(_loc3_ != this.api.datacenter.Basics.gfx_lastSubarea || _loc4_ != this.api.datacenter.Basics.gfx_lastMapName && _loc4_ != undefined)
      {
         _loc5_ = this.api.datacenter.Subareas.getItemAt(_loc3_);
         _loc6_ = "";
         _loc7_ = this.api.lang.getMapSubAreaName(_loc3_);
         _loc8_ = this.api.lang.getMapAreaText(_loc2_.area).n;
         _loc6_ = _loc8_ + "\n";
         if(_loc4_ != undefined)
         {
            _loc6_ += "(" + _loc7_ + " - " + _loc4_ + ")\n";
         }
         else if(_loc8_ != _loc7_)
         {
            _loc6_ += "(" + _loc7_ + ")\n";
         }
         _loc6_ += _loc5_.alignment.name;
         if(!this.api.kernel.TutorialManager.isTutorialMode)
         {
            this.api.ui.loadUIComponent("CenterText","CenterText",{text:_loc6_,background:false,timer:2000},{bForceLoad:true});
         }
         this.api.datacenter.Basics.gfx_lastSubarea = _loc3_;
         this.api.datacenter.Basics.gfx_lastMapName = _loc4_;
      }
      if(this.api.kernel.OptionsManager.getOption("Grid") || this.api.datacenter.Game.isRunning)
      {
         this.api.gfx.drawGrid();
      }
      else
      {
         this.api.gfx.removeGrid();
      }
      if(dofus.Constants.DEBUG_SHOW_CELL_IDS)
      {
         this.updateCellIds();
      }
      this.api.ui.getUIComponent("Banner").circleXtra.setCircleXtraParams({currentCoords:[_loc2_.x,_loc2_.y]});
      if(!this.api.datacenter.Game.isRunning)
      {
         if(Number(_loc2_.ambianceID) > 0)
         {
            this.api.sounds.playEnvironment(_loc2_.ambianceID);
         }
         if(Number(_loc2_.musicID) > 0)
         {
            this.api.sounds.playMusic(_loc2_.musicID,true);
         }
      }
      var _loc9_ = Array(this.api.lang.getMapText(_loc2_.id).p);
      var _loc10_ = 0;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      while(_loc9_.length > _loc10_)
      {
         _loc11_ = _loc9_[_loc10_][0];
         _loc12_ = _loc9_[_loc10_][1];
         _loc13_ = _loc9_[_loc10_][2];
         if(!dofus.utils.criterions.CriterionManager.fillingCriterions(_loc13_))
         {
            _loc14_ = this.api.gfx.mapHandler.getCellData(_loc12_);
            _loc15_ = 0;
            while(_loc15_ < _loc11_.length)
            {
               if(_loc14_.layerObject1Num == _loc11_[_loc15_])
               {
                  _loc14_.mcObject1._visible = false;
               }
               if(_loc14_.layerObject2Num == _loc11_[_loc15_])
               {
                  _loc14_.mcObject2._visible = false;
               }
               _loc15_ = _loc15_ + 1;
            }
         }
         _loc10_ = _loc10_ + 1;
      }
      this.dispatchEvent({type:"mapLoaded",currentMap:_loc2_});
   }
   function onCellRelease(mcCell)
   {
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.api.kernel.TutorialManager.onWaitingCase({code:"CELL_RELEASE",params:[mcCell.num]});
         return false;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      switch(this.api.datacenter.Game.interactionType)
      {
         case 1:
            _loc3_ = this.api.datacenter.Player.data;
            _loc4_ = false;
            _loc5_ = this.api.datacenter.Player.canMoveInAllDirections;
            if(this.api.datacenter.Player.InteractionsManager.calculatePath(this.mapHandler,mcCell.num,true,this.api.datacenter.Game.isFight,false,_loc5_))
            {
               if(this.api.datacenter.Game.isFight)
               {
                  _loc4_ = true;
               }
               else
               {
                  _loc4_ = this.api.datacenter.Basics.interactionsManager_path[this.api.datacenter.Basics.interactionsManager_path.length - 1].num == mcCell.num;
               }
            }
            if(!this.api.datacenter.Game.isFight && !_loc4_)
            {
               if(this.api.datacenter.Player.InteractionsManager.calculatePath(this.mapHandler,mcCell.num,true,this.api.datacenter.Game.isFight,true,_loc5_))
               {
                  _loc4_ = true;
               }
            }
            if(_loc4_)
            {
               if(getTimer() - this.api.datacenter.Basics.gfx_lastActionTime < dofus.Constants.CLICK_MIN_DELAY && (_loc3_ == undefined || !_loc3_._bIsMerchant))
               {
                  ank.utils.Logger.err("T trop rapide du clic");
                  return null;
               }
               this.api.datacenter.Basics.gfx_lastActionTime = getTimer();
               if(this.api.datacenter.Basics.interactionsManager_path.length != 0)
               {
                  _loc6_ = ank.battlefield.utils.Compressor.compressPath(this.api.datacenter.Basics.interactionsManager_path);
                  if(_loc6_ != undefined)
                  {
                     if(this.api.datacenter.Game.isFight && this.api.datacenter.Game.isRunning)
                     {
                        _loc7_ = _loc3_.sequencer;
                        _loc7_.addAction(122,false,_loc3_.GameActionsManager,_loc3_.GameActionsManager.transmittingMove,[1,[_loc6_]]);
                        _loc7_.execute();
                     }
                     else
                     {
                        _loc3_.GameActionsManager.transmittingMove(1,[_loc6_]);
                     }
                     delete this.api.datacenter.Basics.interactionsManager_path;
                  }
               }
               return true;
            }
            return false;
            break;
         case 2:
            if(this.api.datacenter.Player.currentUseObject != null && this.api.datacenter.Basics.gfx_canLaunch)
            {
               _loc8_ = this.api.datacenter.Player.data;
               _loc9_ = _loc8_.sequencer;
               _loc9_.addAction(123,false,_loc8_.GameActionsManager,_loc8_.GameActionsManager.transmittingOther,[300,[this.api.datacenter.Player.currentUseObject.ID,mcCell.num]]);
               _loc9_.execute();
               this.api.datacenter.Player.currentUseObject = null;
            }
            else if(this.api.datacenter.Basics.spellManager_errorMsg != undefined)
            {
               this.api.kernel.showMessage(undefined,this.api.datacenter.Basics.spellManager_errorMsg,"ERROR_CHAT");
               delete this.api.datacenter.Basics.spellManager_errorMsg;
            }
            this.api.gfx.clearSpellPreview();
            this.api.kernel.GameManager.lastSpellLaunch = getTimer();
            this.api.datacenter.Game.setInteractionType("move");
            break;
         case 3:
            if(this.api.datacenter.Player.currentUseObject != null && this.api.datacenter.Basics.gfx_canLaunch)
            {
               _loc10_ = this.api.datacenter.Player.data;
               _loc11_ = _loc10_.sequencer;
               _loc11_.addAction(124,false,_loc10_.GameActionsManager,_loc10_.GameActionsManager.transmittingOther,[303,[mcCell.num]]);
               _loc11_.execute();
               this.api.datacenter.Player.currentUseObject = null;
            }
            this.api.gfx.clearSpellPreview();
            this.api.kernel.GameManager.lastSpellLaunch = getTimer();
            this.api.datacenter.Game.setInteractionType("move");
            break;
         case 4:
            _loc12_ = this.mapHandler.getCellData(mcCell.num).spriteOnID;
            if(_loc12_ == undefined)
            {
               this.api.network.Game.setPlayerPosition(mcCell.num);
            }
            break;
         case 5:
            if(this.api.datacenter.Player.currentUseObject != null && this.api.datacenter.Basics.gfx_canLaunch)
            {
               this.api.network.Items.use(this.api.datacenter.Player.currentUseObject.ID,this.mapHandler.getCellData(mcCell.num).spriteOnID,mcCell.num);
            }
            this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
            this.api.gfx.clearPointer();
            this.unSelect(true);
            this.api.datacenter.Player.reset();
            this.api.ui.removeCursor();
            this.api.datacenter.Game.setInteractionType("move");
            break;
         case 6:
            if(this.api.datacenter.Game.isFight)
            {
               if(mcCell.num != undefined)
               {
                  this.api.network.Game.setFlag(mcCell.num);
               }
               this.api.gfx.clearPointer();
               this.api.gfx.unSelectAllButOne("startPosition");
               this.api.ui.removeCursor();
               if(this.api.datacenter.Game.isRunning && this.api.datacenter.Game.currentPlayerID == this.api.datacenter.Player.ID)
               {
                  this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE_OVER_OUT);
                  this.api.datacenter.Game.setInteractionType("move");
               }
               else
               {
                  this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
                  this.api.datacenter.Game.setInteractionType("place");
               }
            }
         default:
            return;
      }
   }
   function onCellRollOver(mcCell)
   {
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.api.kernel.TutorialManager.onWaitingCase({code:"CELL_OVER",params:[mcCell.num]});
         return undefined;
      }
      if(this.api.datacenter.Game.isRunning && (!this.api.datacenter.Player.isCurrentPlayer && this.api.datacenter.Game.interactionType != 6))
      {
         return undefined;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      switch(this.api.datacenter.Game.interactionType)
      {
         case 1:
            _loc3_ = this.api.datacenter.Player;
            _loc4_ = _loc3_.data;
            _loc5_ = this.mapHandler.getCellData(mcCell.num).spriteOnID;
            _loc6_ = this.api.datacenter.Sprites.getItemAt(_loc5_);
            if(ank.battlefield.utils.Pathfinding.checkRange(this.mapHandler,_loc4_.cellNum,mcCell.num,false,0,_loc4_.MP,0))
            {
               this.api.datacenter.Player.InteractionsManager.setState(this.api.datacenter.Game.isFight);
               this.api.datacenter.Player.InteractionsManager.calculatePath(this.mapHandler,mcCell.num,false,this.api.datacenter.Game.isFight);
            }
            else
            {
               delete this.api.datacenter.Basics.interactionsManager_path;
            }
            break;
         case 2:
         case 3:
            _loc7_ = this.api.datacenter.Player;
            _loc8_ = _loc7_.data;
            _loc9_ = _loc8_.cellNum;
            _loc10_ = _loc7_.currentUseObject;
            _loc11_ = _loc7_.SpellsManager;
            _loc12_ = _loc10_.rangeModerator;
            this.api.gfx.mapHandler.resetEmptyCells();
            this.api.datacenter.Basics.gfx_canLaunch = _loc11_.checkCanLaunchSpellOnCell(this.mapHandler,_loc10_,this.mapHandler.getCellData(mcCell.num),_loc12_,false);
            if(this.api.datacenter.Basics.gfx_canLaunch)
            {
               this.api.ui.setCursorForbidden(false);
               this.drawPointer(mcCell.num);
            }
            else
            {
               this.api.ui.setCursorForbidden(true,dofus.Constants.FORBIDDEN_FILE);
            }
            break;
         case 5:
         case 6:
            this.api.datacenter.Basics.gfx_canLaunch = true;
            this.api.ui.setCursorForbidden(false);
            this.drawPointer(mcCell.num);
         default:
            return;
      }
   }
   function onCellRollOut(mcCell)
   {
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.api.kernel.TutorialManager.onWaitingCase({code:"CELL_OUT",params:[mcCell.num]});
         return undefined;
      }
      if(this.api.datacenter.Game.isRunning && (!this.api.datacenter.Player.isCurrentPlayer && this.api.datacenter.Game.interactionType != 6))
      {
         return undefined;
      }
      switch(this.api.datacenter.Game.interactionType)
      {
         case 1:
            this.hideSpriteInfos();
            this.unSelect(false,undefined,"move");
            break;
         case 2:
         case 3:
            this.api.ui.setCursorForbidden(true,dofus.Constants.FORBIDDEN_FILE);
            this.hidePointer();
            this.api.datacenter.Basics.gfx_canLaunch = false;
            this.hideSpriteInfos();
            break;
         case 5:
         case 6:
            this.api.ui.setCursorForbidden(true,dofus.Constants.FORBIDDEN_FILE);
            this.api.datacenter.Basics.gfx_canLaunch = false;
            this.hidePointer();
         default:
            return;
      }
   }
   function onSpriteRelease(mcSprite, bRightClick)
   {
      if(bRightClick == undefined)
      {
         bRightClick = false;
      }
      var _loc4_ = mcSprite.data;
      var _loc5_ = _loc4_.id;
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.api.kernel.TutorialManager.onWaitingCase({code:"SPRITE_RELEASE",params:[_loc4_.id]});
         return undefined;
      }
      if(_loc4_.hasParent)
      {
         this.onSpriteRelease(_loc4_.linkedParent.mc);
         return undefined;
      }
      var _loc0_;
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
      var _loc41_;
      var _loc40_;
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
      if((_loc0_ = this.api.datacenter.Game.interactionType) !== 5)
      {
         if(_loc4_ instanceof dofus.datacenter.Mutant && !_loc4_.showIsPlayer)
         {
            if(!this.api.datacenter.Game.isRunning)
            {
               if(this.api.datacenter.Player.isMutant)
               {
                  return undefined;
               }
            }
            _loc6_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
            this.onCellRelease(_loc6_);
         }
         else if(_loc4_ instanceof dofus.datacenter.Character || _loc4_ instanceof dofus.datacenter.Mutant && _loc4_.showIsPlayer)
         {
            if(this.api.datacenter.Game.isFight && (this.api.datacenter.Game.isRunning && !(this.api.datacenter.Player.isAuthorized && (this.api.datacenter.Game.interactionType == dofus.datacenter.Game.INTERACTION_TYPE_MOVE && this.api.datacenter.Player.currentUseObject == null))))
            {
               _loc7_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
               this.onCellRelease(_loc7_);
               return undefined;
            }
            if(Key.isDown(Key.CONTROL))
            {
               _loc8_ = this.mapHandler.getCellData(_loc4_.cellNum).allSpritesOn;
               this.api.kernel.GameManager.showCellPlayersPopupMenu(_loc8_);
            }
            else
            {
               this.api.kernel.GameManager.showPlayerPopupMenu(_loc4_);
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.NonPlayableCharacter)
         {
            if(this.api.datacenter.Player.cantSpeakNPC)
            {
               return undefined;
            }
            _loc9_ = _loc4_.actions;
            if(_loc9_ != undefined && _loc9_.length != 0)
            {
               _loc10_ = this.api.ui.createPopupMenu();
               _loc10_.addStaticItem(_loc4_.name);
               if(Key.isDown(Key.SHIFT) || bRightClick)
               {
                  _loc11_ = [6,3,1,2,4,5,7,8];
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_.length)
                  {
                     _loc13_ = _loc9_.findFirstItem("actionId",_loc11_[_loc12_]).item;
                     if(_loc13_ != undefined)
                     {
                        _loc14_ = _loc13_.action;
                        _loc15_ = _loc14_.method;
                        _loc16_ = _loc14_.object;
                        _loc17_ = _loc14_.params;
                        _loc15_.apply(_loc16_,_loc17_);
                        break;
                     }
                     _loc12_ = _loc12_ + 1;
                  }
               }
               else
               {
                  _loc18_ = _loc9_.length;
                  while(_loc18_-- > 0)
                  {
                     _loc19_ = _loc9_[_loc18_];
                     _loc20_ = _loc19_.actionId;
                     _loc21_ = _loc19_.action;
                     _loc22_ = _loc21_.method;
                     _loc23_ = _loc21_.object;
                     _loc24_ = _loc21_.params;
                     _loc10_.addItem(_loc19_.name,_loc23_,_loc22_,_loc24_);
                  }
                  _loc10_.show(_root._xmouse,_root._ymouse);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.Team)
         {
            _loc25_ = this.api.datacenter.Player.data.alignment.index;
            _loc26_ = _loc4_.alignment.index;
            _loc27_ = _loc4_.enemyTeam.alignment.index;
            _loc28_ = _loc4_.challenge.fightType;
            _loc29_ = false;
            switch(_loc28_)
            {
               case 0:
                  switch(_loc4_.type)
                  {
                     case 0:
                     case 2:
                        _loc29_ = this.api.datacenter.Player.canChallenge && (!this.api.datacenter.Player.isMutant || this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant);
                  }
                  break;
               case 1:
               case 2:
                  switch(_loc4_.type)
                  {
                     case 0:
                     case 1:
                        if(_loc25_ == _loc26_)
                        {
                           _loc29_ = !this.api.datacenter.Player.isMutant;
                        }
                        else
                        {
                           _loc29_ = this.api.lang.getAlignmentCanJoin(_loc25_,_loc26_) && (this.api.lang.getAlignmentCanAttack(_loc25_,_loc27_) && !this.api.datacenter.Player.isMutant);
                        }
                  }
                  break;
               case 3:
                  switch(_loc4_.type)
                  {
                     case 0:
                        _loc29_ = !this.api.datacenter.Player.isMutant || this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant;
                        break;
                     case 1:
                        _loc29_ = false;
                  }
                  break;
               case 4:
                  switch(_loc4_.type)
                  {
                     case 0:
                        _loc29_ = true;
                        break;
                     case 1:
                        _loc29_ = false;
                  }
                  break;
               case 5:
                  switch(_loc4_.type)
                  {
                     case 0:
                        _loc29_ = !this.api.datacenter.Player.isMutant && !this.api.datacenter.Player.cantInteractWithTaxCollector;
                        break;
                     case 3:
                        _loc29_ = false;
                  }
                  break;
               case 6:
                  switch(_loc4_.type)
                  {
                     case 0:
                        _loc29_ = !this.api.datacenter.Player.isMutant || this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant;
                        break;
                     case 2:
                        _loc29_ = this.api.datacenter.Player.isMutant && !this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant == true;
                  }
            }
            if(_loc29_)
            {
               _loc30_ = true;
               _loc31_ = this.api.ui.createPopupMenu();
               _loc31_.addStaticItem(this.api.lang.getText("FIGHT"));
               _loc32_ = this.api.lang.getMapMaxTeam(this.api.datacenter.Map.id);
               _loc33_ = this.api.lang.getMapMaxChallenge(this.api.datacenter.Map.id);
               if(_loc4_.challenge.count >= _loc33_)
               {
                  _loc31_.addItem(this.api.lang.getText("JOIN_SMALL") + " (" + this.api.lang.getText("CHALENGE_FULL") + ")",undefined,undefined,undefined,false);
               }
               else if(_loc4_.count >= _loc32_)
               {
                  _loc31_.addItem(this.api.lang.getText("JOIN_SMALL") + " (" + this.api.lang.getText("TEAM_FULL") + ")",undefined,undefined,undefined,false);
               }
               else if(Key.isDown(Key.SHIFT) || bRightClick)
               {
                  _loc30_ = false;
                  this.api.network.GameActions.joinChallenge(_loc4_.challenge.id,_loc4_.id);
                  this.api.ui.hideTooltip();
               }
               else
               {
                  _loc31_.addItem(this.api.lang.getText("JOIN_SMALL"),this.api.network.GameActions,this.api.network.GameActions.joinChallenge,[_loc4_.challenge.id,_loc4_.id]);
               }
               if(_loc30_)
               {
                  _loc31_.show(_root._xmouse,_root._ymouse);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.ParkMount)
         {
            if(_loc4_.ownerName == this.api.datacenter.Player.Name || this.api.datacenter.Map.firstMountPark.guildName == this.api.datacenter.Player.guildInfos.name && this.api.datacenter.Player.guildInfos.playerRights.canManageOtherMount)
            {
               if(Key.isDown(Key.SHIFT) || bRightClick)
               {
                  this.api.network.Mount.parkMountData(_loc4_.id);
               }
               else
               {
                  _loc34_ = this.api.ui.createPopupMenu();
                  _loc34_.addStaticItem(this.api.lang.getText("MOUNT_OF",[_loc4_.ownerName]));
                  _loc34_.addItem(this.api.lang.getText("VIEW_MOUNT_DETAILS"),this.api.network.Mount,this.api.network.Mount.parkMountData,[_loc4_.id]);
                  _loc34_.show(_root._xmouse,_root._ymouse);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.Creature)
         {
            _loc35_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
            this.onCellRelease(_loc35_);
         }
         else if(_loc4_ instanceof dofus.datacenter.MonsterGroup || _loc4_ instanceof dofus.datacenter.Monster)
         {
            if(_loc4_ instanceof dofus.datacenter.Monster && this.api.kernel.GameManager.isInMyTeam(_loc4_))
            {
               this.api.kernel.GameManager.showMonsterPopupMenu(_loc4_);
            }
            if(!this.api.datacenter.Player.isMutant || (this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant || this.api.datacenter.Player.canAttackMonstersAnywhereWhenMutant))
            {
               _loc36_ = this.mapHandler.getCellData(_loc4_.cellNum);
               _loc37_ = _loc36_.mc;
               if(!Key.isDown(Key.SHIFT) && (!bRightClick && (!this.api.datacenter.Game.isFight && _loc4_ instanceof dofus.datacenter.MonsterGroup)))
               {
                  _loc38_ = this.api.ui.createPopupMenu();
                  _loc39_ = this.api.lang.getText("MONSTER");
                  _loc39_ = _loc39_.charAt(0).toUpperCase() + _loc39_.substr(1);
                  _loc38_.addStaticItem(ank.utils.PatternDecoder.combine(_loc39_,null,_loc4_.count < 2));
                  _loc38_.addItem(this.api.lang.getText("ATTACK"),this,this.onCellRelease,[_loc37_]);
                  _loc38_.addItem(this.api.lang.getText("ENCYCLOPEDIA_BESTIARY"),this,this.openEncyclopediaForMonsterGroup,[_loc4_],_loc4_.isGroupInEncyclopedia);
                  _loc38_.show();
               }
               else
               {
                  this.onCellRelease(_loc37_);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.OfflineCharacter)
         {
            if(!this.api.datacenter.Player.isMutant || this.api.datacenter.Player.canAttackDungeonMonstersWhenMutant)
            {
               if(!this.api.datacenter.Player.canExchange)
               {
                  return undefined;
               }
               if(Key.isDown(Key.SHIFT) || bRightClick)
               {
                  this.api.kernel.GameManager.startExchange(4,_loc4_.id,_loc4_.cellNum);
               }
               else
               {
                  _loc41_ = _loc4_.name;
                  if(this.api.datacenter.Player.isAuthorized)
                  {
                     _loc40_ = this.api.kernel.AdminManager.getAdminPopupMenu(_loc41_,false);
                  }
                  else
                  {
                     _loc40_ = this.api.ui.createPopupMenu();
                  }
                  _loc40_.addStaticItem(this.api.lang.getText("SHOP") + " " + this.api.lang.getText("OF") + " " + _loc4_.name);
                  _loc40_.addItem(this.api.lang.getText("BUY"),this.api.kernel.GameManager,this.api.kernel.GameManager.startExchange,[4,_loc4_.id,_loc4_.cellNum]);
                  if(_loc4_.characterID != undefined && _loc4_.name != undefined)
                  {
                     _loc40_.addItem(this.api.lang.getText("REPORT_PLAYER"),this.api.kernel.GameManager,this.api.kernel.GameManager.reportPlayer,[_loc4_.characterID,_loc4_.name,true]);
                  }
                  _loc42_ = 3;
                  if(this.api.datacenter.Map.isMyHome)
                  {
                     _loc40_.addItem(this.api.lang.getText("KICKOFF"),this.api.network.Basics,this.api.network.Basics.kick,[_loc4_.cellNum]);
                     _loc42_ = _loc42_ + 1;
                  }
                  if(this.api.datacenter.Player.isAuthorized)
                  {
                     _loc43_ = 0;
                     while(_loc43_ < _loc42_)
                     {
                        _loc40_.items.unshift(_loc40_.items.pop());
                        _loc43_ = _loc43_ + 1;
                     }
                  }
                  _loc40_.show(_root._xmouse,_root._ymouse,true);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.TaxCollector)
         {
            if(!this.api.datacenter.Player.isMutant)
            {
               if(this.api.datacenter.Player.cantInteractWithTaxCollector)
               {
                  return undefined;
               }
               if(this.api.datacenter.Game.isFight)
               {
                  _loc44_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
                  this.onCellRelease(_loc44_);
               }
               else if(Key.isDown(Key.SHIFT) || bRightClick)
               {
                  this.api.network.Dialog.create(_loc5_);
               }
               else
               {
                  _loc45_ = this.api.datacenter.Player.guildInfos.playerRights;
                  _loc46_ = _loc4_.guildName == this.api.datacenter.Player.guildInfos.name;
                  _loc47_ = _loc45_.canCollect || _loc4_.isMine && _loc45_.canCollectOwnTaxCollector;
                  _loc48_ = this.api.ui.createPopupMenu();
                  _loc48_.addStaticItem(_loc4_.name);
                  _loc48_.addItem(this.api.lang.getText("SPEAK"),this.api.network.Dialog,this.api.network.Dialog.create,[_loc5_]);
                  _loc48_.addItem(this.api.lang.getText("COLLECT_TAX"),this.api.kernel.GameManager,this.api.kernel.GameManager.startExchange,[8,_loc5_],_loc46_ && _loc47_);
                  _loc48_.addItem(this.api.lang.getText("ATTACK"),this.api.network.GameActions,this.api.network.GameActions.attackTaxCollector,[[_loc5_]],!_loc46_);
                  _loc48_.show(_root._xmouse,_root._ymouse);
               }
            }
         }
         else if(_loc4_ instanceof dofus.datacenter.PrismSprite)
         {
            if(!this.api.datacenter.Player.isMutant)
            {
               if(this.api.datacenter.Game.isFight)
               {
                  _loc49_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
                  this.onCellRelease(_loc49_);
               }
               else
               {
                  _loc50_ = this.api.datacenter.Player.alignment.index == 0;
                  _loc51_ = this.api.datacenter.Player.alignment.compareTo(_loc4_.alignment) == 0;
                  if((Key.isDown(Key.SHIFT) || bRightClick) && _loc51_)
                  {
                     this.api.network.GameActions.usePrism([_loc5_]);
                  }
                  else
                  {
                     _loc52_ = this.api.ui.createPopupMenu();
                     _loc52_.addStaticItem(_loc4_.name);
                     _loc52_.addItem(this.api.lang.getText("USE_WORD"),this.api.network.GameActions,this.api.network.GameActions.usePrism,[[_loc5_]],_loc51_);
                     _loc52_.addItem(this.api.lang.getText("ATTACK"),this.api.network.GameActions,this.api.network.GameActions.attackPrism,[[_loc5_]],!_loc51_ && !_loc50_);
                     _loc52_.show(_root._xmouse,_root._ymouse);
                  }
               }
            }
         }
      }
      else
      {
         if(this.api.datacenter.Player.currentUseObject != null && this.api.datacenter.Basics.gfx_canLaunch)
         {
            this.api.network.Items.use(this.api.datacenter.Player.currentUseObject.ID,_loc4_.id,_loc4_.cellNum);
         }
         this.api.gfx.setInteraction(ank.battlefield.Constants.INTERACTION_CELL_RELEASE);
         this.api.gfx.clearPointer();
         this.unSelect(true);
         this.api.datacenter.Player.reset();
         this.api.ui.removeCursor();
         this.api.datacenter.Game.setInteractionType("move");
      }
   }
   function onSpriteRollOver(mcSprite, bFakeEvent)
   {
      if(!bFakeEvent)
      {
         this._rollOverMcSprite = mcSprite;
      }
      if(_root._xscale != 100)
      {
         return undefined;
      }
      var _loc6_ = mcSprite.data;
      if(_loc6_ == undefined)
      {
         return undefined;
      }
      var _loc7_ = dofus.Constants.OVERHEAD_TEXT_OTHER;
      if(!_loc6_.isVisible)
      {
         this.showSpriteInfos(_loc6_);
         return undefined;
      }
      if(_loc6_.isClear)
      {
         return undefined;
      }
      if(_loc6_.hasParent)
      {
         this.onSpriteRollOver(_loc6_.linkedParent.mc,bFakeEvent);
         return undefined;
      }
      var _loc9_;
      if(this.api.datacenter.Game.isRunning || this.api.datacenter.Game.interactionType == 5)
      {
         _loc9_ = this.mapHandler.getCellData(_loc6_.cellNum).mc;
         if(_loc6_.isVisible)
         {
            this.onCellRollOver(_loc9_);
         }
         this.api.ui.getUIComponent("Timeline").itemOver(_loc6_.id);
      }
      var _loc10_ = _loc6_.name;
      var _loc4_;
      var _loc11_;
      var _loc5_;
      var _loc8_;
      var _loc12_;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      if(_loc6_ instanceof dofus.datacenter.Mutant && _loc6_.showIsPlayer)
      {
         if(this.api.datacenter.Game.isRunning)
         {
            if(this.api.kernel.OptionsManager.getOption("ViewHPAsBar"))
            {
               _loc10_ = "";
               this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.HealthBarOverHead,[_loc6_,100]);
            }
            else
            {
               _loc10_ = _loc6_.playerName + " (" + _loc6_.LP + ")";
            }
            this.showSpriteInfos(_loc6_);
         }
         else
         {
            _loc10_ = _loc6_.playerName + " [" + _loc6_.monsterName + " (" + _loc6_.Level + ")]";
         }
      }
      else if(_loc6_ instanceof dofus.datacenter.Mutant || (_loc6_ instanceof dofus.datacenter.Creature || _loc6_ instanceof dofus.datacenter.Monster))
      {
         _loc7_ = dofus.Constants.NPC_ALIGNMENT_COLOR[_loc6_.alignment.index];
         if(this.api.datacenter.Game.isRunning)
         {
            if(this.api.kernel.OptionsManager.getOption("ViewHPAsBar"))
            {
               _loc10_ = "";
               this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.HealthBarOverHead,[_loc6_,100]);
            }
            else
            {
               _loc10_ += " (" + _loc6_.LP + ")";
            }
            this.showSpriteInfos(_loc6_);
         }
         else
         {
            _loc10_ += " (" + _loc6_.Level + ")";
         }
      }
      else if(_loc6_ instanceof dofus.datacenter.Character)
      {
         _loc7_ = dofus.Constants.OVERHEAD_TEXT_CHARACTER;
         _loc4_ = dofus.Constants.DEMON_ANGEL_FILE;
         if(_loc6_.alignment.fallenAngelDemon)
         {
            _loc4_ = dofus.Constants.FALLEN_DEMON_ANGEL_FILE;
         }
         _loc11_ = !_loc6_.haveFakeAlignement ? _loc6_.alignment.index : _loc6_.fakeAlignment.index;
         if(_loc6_.rank.value > 0)
         {
            if(_loc11_ == 1)
            {
               _loc5_ = _loc6_.rank.value;
            }
            else if(_loc11_ == 2)
            {
               _loc5_ = 10 + _loc6_.rank.value;
            }
            else if(_loc11_ == 3)
            {
               _loc5_ = 20 + _loc6_.rank.value;
            }
         }
         if(this.api.datacenter.Game.isRunning)
         {
            this.addSpriteOverHeadItem(_loc6_.id,"effects",dofus.graphics.battlefield.EffectsOverHead,[_loc6_]);
            if(this.api.kernel.OptionsManager.getOption("ViewHPAsBar"))
            {
               _loc10_ = "";
               this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.HealthBarOverHead,[_loc6_,100,_loc4_,_loc5_]);
            }
            else
            {
               _loc10_ += " (" + _loc6_.LP + ")";
            }
            this.showSpriteInfos(_loc6_);
         }
         else if(this.api.datacenter.Game.isFight)
         {
            _loc10_ += " (" + _loc6_.Level + ")";
         }
         _loc8_ = _loc6_.title;
         if(_loc6_.guildName != undefined && _loc6_.guildName.length != 0)
         {
            _loc10_ = "";
            this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.GuildOverHead,[_loc6_.guildName,_loc6_.name,_loc6_.emblem,_loc4_,_loc5_,_loc6_.pvpGain,_loc8_],undefined,true);
         }
      }
      else if(_loc6_ instanceof dofus.datacenter.TaxCollector)
      {
         if(this.api.datacenter.Game.isRunning)
         {
            if(this.api.kernel.OptionsManager.getOption("ViewHPAsBar"))
            {
               _loc10_ = "";
               this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.HealthBarOverHead,[_loc6_,100]);
            }
            else
            {
               _loc10_ += " (" + _loc6_.LP + ")";
            }
            this.showSpriteInfos(_loc6_);
         }
         else if(this.api.datacenter.Game.isFight)
         {
            _loc10_ += " (" + _loc6_.Level + ")";
         }
         else
         {
            _loc10_ = "";
            this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.GuildOverHead,[_loc6_.guildName,_loc6_.name,_loc6_.emblem]);
         }
      }
      else if(_loc6_ instanceof dofus.datacenter.PrismSprite)
      {
         _loc4_ = dofus.Constants.DEMON_ANGEL_FILE;
         if(_loc6_.alignment.value > 0)
         {
            if(_loc6_.alignment.index == 1)
            {
               _loc5_ = _loc6_.alignment.value;
            }
            else if(_loc6_.alignment.index == 2)
            {
               _loc5_ = 10 + _loc6_.alignment.value;
            }
            else if(_loc6_.alignment.index == 3)
            {
               _loc5_ = 20 + _loc6_.alignment.value;
            }
         }
         _loc7_ = dofus.Constants.NPC_ALIGNMENT_COLOR[_loc6_.alignment.index];
         this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.TextOverHead,[_loc10_,_loc4_,_loc7_,_loc5_]);
      }
      else if(_loc6_ instanceof dofus.datacenter.ParkMount)
      {
         _loc7_ = dofus.Constants.OVERHEAD_TEXT_CHARACTER;
         _loc10_ = this.api.lang.getText("MOUNT_PARK_OVERHEAD",[_loc6_.modelName,_loc6_.level,_loc6_.ownerName]);
         this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.TextOverHead,[_loc10_,_loc4_,_loc7_,_loc5_]);
      }
      else if(_loc6_ instanceof dofus.datacenter.OfflineCharacter)
      {
         _loc7_ = dofus.Constants.OVERHEAD_TEXT_CHARACTER;
         _loc10_ = "";
         this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.OfflineOverHead,[_loc6_]);
      }
      else if(_loc6_ instanceof dofus.datacenter.NonPlayableCharacter)
      {
         _loc12_ = this.api.datacenter.Map;
         _loc13_ = this.api.datacenter.Subareas.getItemAt(_loc12_.subarea);
         if(_loc13_ != undefined)
         {
            _loc7_ = dofus.Constants.NPC_ALIGNMENT_COLOR[_loc13_.alignment.index];
         }
      }
      else if(_loc6_ instanceof dofus.datacenter.MonsterGroup || _loc6_ instanceof dofus.datacenter.Team)
      {
         if(_loc6_.alignment.index != -1)
         {
            _loc7_ = dofus.Constants.NPC_ALIGNMENT_COLOR[_loc6_.alignment.index];
         }
         _loc14_ = _loc6_.challenge.fightType;
         if(_loc6_.isVisible && (_loc6_ instanceof dofus.datacenter.MonsterGroup || _loc6_.type == 1 && (_loc14_ == 2 || (_loc14_ == 3 || _loc14_ == 4))))
         {
            if(_loc10_ != "")
            {
               _loc15_ = dofus.Constants.OVERHEAD_TEXT_TITLE;
               this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.TextWithTitleOverHead,[_loc10_,_loc4_,_loc7_,_loc5_,this.api.lang.getText("LEVEL") + " " + _loc6_._bForceWalk,_loc15_,_loc6_.bonusValue]);
            }
            this.selectSprite(_loc6_.id,true);
            return undefined;
         }
      }
      if(_loc10_ != "")
      {
         this.addSpriteOverHeadItem(_loc6_.id,"text",dofus.graphics.battlefield.TextOverHead,[_loc10_,_loc4_,_loc7_,_loc5_,_loc6_,_loc8_]);
      }
      this.selectSprite(_loc6_.id,true);
   }
   function onSpriteRollOut(mcSprite, bFakeEvent)
   {
      if(!bFakeEvent)
      {
         this._rollOverMcSprite = undefined;
      }
      var _loc4_ = mcSprite.data;
      if(this.api.gfx.spriteHandler.isShowingMonstersTooltip && _loc4_ instanceof dofus.datacenter.MonsterGroup)
      {
         return undefined;
      }
      if(_loc4_.hasParent)
      {
         this.onSpriteRollOut(_loc4_.linkedParent.mc);
         return undefined;
      }
      var _loc5_;
      if(this.api.datacenter.Game.isRunning || this.api.datacenter.Game.interactionType == 5)
      {
         this.hideSpriteInfos();
         _loc5_ = this.mapHandler.getCellData(_loc4_.cellNum).mc;
         this.onCellRollOut(_loc5_);
         this.api.ui.getUIComponent("Timeline").itemOut(_loc4_.id);
      }
      this.removeSpriteOverHeadLayer(_loc4_.id,"text");
      this.removeSpriteOverHeadLayer(_loc4_.id,"effects");
      this.selectSprite(_loc4_.id,false);
   }
   function onObjectRelease(mcObject, bRightClick)
   {
      if(bRightClick == undefined)
      {
         bRightClick = false;
      }
      this.api.ui.hideTooltip();
      var _loc4_ = mcObject.cellData;
      var _loc5_ = _loc4_.mc;
      var _loc6_ = _loc4_.layerObject2Num;
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         this.api.kernel.TutorialManager.onWaitingCase({code:"OBJECT_RELEASE",params:[_loc4_.num,_loc6_]});
         return undefined;
      }
      var _loc7_ = _loc4_.layerObjectExternalData;
      var _loc8_;
      if(_loc7_ != undefined)
      {
         if(_loc7_.rideItemDurability != undefined)
         {
            if(this.api.datacenter.Map.firstMountPark.isMine(this.api))
            {
               _loc8_ = this.api.ui.createPopupMenu();
               _loc8_.addStaticItem(_loc7_.name);
               _loc8_.addItem(this.api.lang.getText("REMOVE"),this.api.network.Mount,this.api.network.Mount.removeObjectInPark,[_loc5_.num]);
               _loc8_.show(_root._xmouse,_root._ymouse);
               return undefined;
            }
         }
      }
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
      if(!_global.isNaN(_loc6_) && (this.api.datacenter.Player.canUseInteractiveObjects && this.api.datacenter.Game.interactionType != 5))
      {
         _loc9_ = this.api.lang.getInteractiveObjectDataByGfxText(_loc6_);
         _loc10_ = _loc9_.n;
         _loc11_ = _loc9_.sk;
         _loc12_ = _loc9_.t;
         switch(_loc12_)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 7:
            case 10:
            case 12:
            case 14:
            case 15:
               _loc13_ = _loc12_ == 1;
               if(_loc13_)
               {
                  _loc14_ = this.api.mouseClicksMemorizer.getMouseClickForGather(2);
                  if(_loc14_ != undefined)
                  {
                     _loc15_ = getTimer() - _loc14_.time;
                     _loc16_ = _loc15_ < dofus.Constants.CLICK_MIN_DELAY;
                     if(_loc16_)
                     {
                        _loc17_ = mcObject.hitTest(_loc14_.nX,_loc14_.nY,true);
                        if(_loc17_)
                        {
                           this.api.kernel.showMessage(undefined,this.api.lang.getText("SRV_MSG_0"),"ERROR_CHAT");
                           return undefined;
                        }
                     }
                  }
                  this.api.mouseClicksMemorizer.resetForGather();
               }
               _loc18_ = this.api.datacenter.Player.currentJobID != undefined;
               if(_loc18_)
               {
                  _loc19_ = this.api.datacenter.Player.Jobs.findFirstItem("id",this.api.datacenter.Player.currentJobID).item.skills;
               }
               else
               {
                  _loc19_ = new ank.utils.ExtendedArray();
               }
               _loc20_ = true;
               _loc21_ = this.api.ui.createPopupMenu();
               _loc21_.addStaticItem(_loc10_);
               for(var k in _loc11_)
               {
                  _loc22_ = _loc11_[k];
                  _loc23_ = new dofus.datacenter.Skill(_loc22_);
                  _loc24_ = _loc19_.findFirstItem("id",_loc22_).index != -1;
                  _loc25_ = this.api.datacenter.Player.Level <= dofus.Constants.NEWBIE_MAX_LEVEL;
                  _loc26_ = _loc23_.getState(_loc24_,false,false,false,false,_loc25_);
                  if(_loc26_ != "X")
                  {
                     _loc27_ = _loc26_ == "V";
                     if(_loc27_ && ((Key.isDown(Key.SHIFT) || bRightClick) && _loc12_ != 1))
                     {
                        this.api.kernel.GameManager.useRessource(_loc5_,_loc5_.num,_loc22_);
                        _loc20_ = false;
                        break;
                     }
                     if(_root._xscale != 100 && _loc12_ == 1)
                     {
                        return undefined;
                     }
                     _loc21_.addItem(_loc23_.description,this.api.kernel.GameManager,this.api.kernel.GameManager.useRessource,[_loc5_,_loc5_.num,_loc22_],_loc27_);
                  }
               }
               if(_loc20_)
               {
                  _loc21_.isGatherPopupMenu = _loc13_;
                  if(_loc21_.isGatherPopupMenu && _loc12_ == 1)
                  {
                     _loc21_.gatherCellNum = _loc5_.num;
                  }
                  _loc21_.show(_root._xmouse,_root._ymouse);
               }
               break;
            case 5:
               _loc28_ = this.api.lang.getHousesDoorText(this.api.datacenter.Map.id,_loc5_.num);
               this.api.kernel.HouseManager.openHouseMenu(_loc10_,_loc28_,_loc11_,_loc5_);
               break;
            case 6:
               _loc29_ = _loc5_.num;
               _loc30_ = this.api.datacenter.Storages.getItemAt(_loc29_);
               _loc31_ = _loc30_.isLocked;
               _loc32_ = this.api.datacenter.Map.isMyHome;
               _loc33_ = true;
               _loc34_ = this.api.ui.createPopupMenu();
               _loc34_.addStaticItem(_loc10_);
               for(var k in _loc11_)
               {
                  _loc35_ = _loc11_[k];
                  _loc36_ = new dofus.datacenter.Skill(_loc35_);
                  _loc37_ = _loc36_.getState(true,_loc32_,true,_loc31_);
                  if(_loc37_ != "X")
                  {
                     _loc38_ = _loc37_ == "V";
                     if(_loc38_ && ((Key.isDown(Key.SHIFT) || bRightClick) && (_loc35_ == 104 || _loc35_ == 153)))
                     {
                        this.api.kernel.GameManager.useRessource(_loc5_,_loc5_.num,_loc35_);
                        _loc33_ = false;
                        break;
                     }
                     _loc34_.addItem(_loc36_.description,this.api.kernel.GameManager,this.api.kernel.GameManager.useRessource,[_loc5_,_loc5_.num,_loc35_],_loc38_);
                  }
               }
               if(_loc33_)
               {
                  _loc34_.show(_root._xmouse,_root._ymouse);
               }
               break;
            case 13:
               _loc39_ = this.api.datacenter.Map.firstMountPark;
               this.api.kernel.MountParkManager.openMountParkMenu(_loc10_,_loc11_,_loc5_,_loc39_);
               break;
            default:
               this.onCellRelease(_loc5_);
         }
      }
      else
      {
         this.onCellRelease(_loc5_);
      }
   }
   function onObjectRollOver(mcObject)
   {
      this._rollOverMcObject = mcObject;
      if(_root._xscale != 100)
      {
         return undefined;
      }
      var _loc3_ = mcObject.cellData;
      var _loc4_ = _loc3_.mc;
      var _loc5_ = _loc3_.layerObject2Num;
      if(this.api.datacenter.Game.interactionType == 5)
      {
         _loc4_ = mcObject.cellData.mc;
         this.onCellRollOver(_loc4_);
      }
      mcObject.select(true);
      var _loc6_ = _loc3_.layerObjectExternalData;
      var _loc7_;
      var _loc8_;
      if(_loc6_ != undefined)
      {
         _loc7_ = _loc6_.name;
         if(_loc6_.rideItemDurability != undefined)
         {
            if(this.api.datacenter.Map.firstMountPark.isMine(this.api))
            {
               _loc7_ += "\n" + this.api.lang.getText("DURABILITY") + " : " + _loc6_.rideItemDurability + "/" + _loc6_.rideItemDurabilityMax;
            }
         }
         _loc8_ = new dofus.datacenter.Character("itemOnCell",ank.battlefield.mc.Sprite,"",_loc4_.num,0,0);
         this.api.datacenter.Sprites.addItemAt("itemOnCell",_loc8_);
         this.api.gfx.addSprite("itemOnCell");
         this.addSpriteOverHeadItem("itemOnCell","text",dofus.graphics.battlefield.TextOverHead,[_loc7_,"",dofus.Constants.OVERHEAD_TEXT_CHARACTER]);
      }
      var _loc9_ = this.api.lang.getInteractiveObjectDataByGfxText(_loc5_);
      var _loc10_ = _loc9_.n;
      var _loc11_ = _loc9_.sk;
      var _loc12_ = _loc9_.t;
      var _loc13_;
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc17_;
      var _loc18_;
      switch(_loc12_)
      {
         case 5:
            _loc13_ = this.api.lang.getHousesDoorText(this.api.datacenter.Map.id,_loc4_.num);
            _loc14_ = this.api.kernel.HouseManager.getHouseInstances(_loc13_);
            _loc15_ = new dofus.datacenter.Character("porte",ank.battlefield.mc.Sprite,"",_loc4_.num,0,0);
            this.api.datacenter.Sprites.addItemAt("porte",_loc15_);
            this.api.gfx.addSprite("porte");
            this.addSpriteOverHeadItem("porte","text",dofus.graphics.battlefield.PropertyOverHead,[_loc14_,"HouseIcon"]);
            break;
         case 13:
            _loc16_ = this.api.datacenter.Map.firstMountPark;
            _loc17_ = new dofus.datacenter.Character("enclos",ank.battlefield.mc.Sprite,"",_loc4_.num,0,0);
            this.api.datacenter.Sprites.addItemAt("enclos",_loc17_);
            this.api.gfx.addSprite("enclos");
            _loc18_ = this.api.datacenter.Map.mountParks;
            this.addSpriteOverHeadItem("enclos","text",dofus.graphics.battlefield.MountParkOverHead,[_loc18_,"FarmIcon"]);
         default:
            return;
      }
   }
   function onObjectRollOut(mcObject)
   {
      this._rollOverMcObject = undefined;
      this.api.ui.hideTooltip();
      var _loc3_;
      if(this.api.datacenter.Game.interactionType == 5)
      {
         _loc3_ = mcObject.cellData.mc;
         this.onCellRollOut(_loc3_);
      }
      mcObject.select(false);
      this.removeSpriteOverHeadLayer("enclos","text");
      this.removeSprite("enclos",false);
      this.removeSpriteOverHeadLayer("porte","text");
      this.removeSprite("porte",false);
      this.removeSpriteOverHeadLayer("itemOnCell","text");
      this.removeSprite("itemOnCell",false);
   }
   function showSpriteInfos(oSprite)
   {
      if(!this.api.datacenter.Game.isFight || (!this.api.kernel.OptionsManager.getOption("SpriteInfos") || oSprite == undefined))
      {
         return undefined;
      }
      if(this.api.kernel.OptionsManager.getOption("SpriteMove") && (oSprite.isVisible && this.api.ui.isCursorHidden()))
      {
         this.api.gfx.drawZone(oSprite.cellNum,0,oSprite.MP,"move",dofus.Constants.CELL_MOVE_RANGE_COLOR,"C".charCodeAt(0));
      }
      this.api.ui.getUIComponent("Banner").showRightPanel("BannerSpriteInfos",{data:oSprite},true,true);
   }
   function hideSpriteInfos()
   {
      this.api.ui.getUIComponent("Banner").hideRightPanel(false,true);
      this.api.gfx.clearZoneLayer("move");
   }
   function openEncyclopediaForMonsterGroup(oMonsterGroup)
   {
      if(oMonsterGroup instanceof dofus.datacenter.Monster || oMonsterGroup instanceof dofus.datacenter.MonsterGroup)
      {
         this.api.ui.loadUIAutoHideComponent("Encyclopedia","Encyclopedia",{_sCurrentTab:"Bestiary",_aSearchedIDs:oMonsterGroup._aIDList},{bStayIfPresent:true});
      }
   }
}
