class dofus.managers.TutorialManager extends dofus.utils.ApiElement
{
   var _oCurrentWaitingBloc;
   var _oSequencer;
   var _oTutorial;
   var _oVars;
   var addToQueue;
   var api;
   var _bInTutorialMode = false;
   static var _sSelf = null;
   function TutorialManager(oAPI)
   {
      super();
      dofus.managers.TutorialManager._sSelf = this;
      this.initialize(oAPI);
   }
   function get isTutorialMode()
   {
      return this._bInTutorialMode;
   }
   function get isTutorialModeInFight()
   {
      return this._bInTutorialMode && this.api.ui.getUIComponent("Banner").giveUpButtonVisible;
   }
   function get vars()
   {
      var _loc2_ = new String();
      for(var k in this._oVars)
      {
         _loc2_ += k + ":" + this._oVars[k] + "\n";
      }
      return _loc2_;
   }
   static function getInstance()
   {
      return dofus.managers.TutorialManager._sSelf;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
      this._oSequencer = new ank.utils.Sequencer();
   }
   function clear()
   {
      this._bInTutorialMode = false;
      ank.utils.Timer.removeTimer(this,"tutorial");
      this.api.gfx.spriteHandler.hideSprites(false,2);
      this.api.gfx.spriteHandler.hideSprites(false,3);
      this.api.gfx.spriteHandler.hideSprites(false,4);
      this.api.ui.getUIComponent("GameResult")._visible = true;
      this.api.ui.getUIComponent("GameResultLight")._visible = true;
      this.api.ui.getUIComponent("AchievementRewards")._visible = true;
      this._oVars = {};
   }
   function start(oTutorial)
   {
      this._bInTutorialMode = true;
      this._oVars = {};
      this._oTutorial = oTutorial;
      var _loc3_ = oTutorial.getRootBloc();
      this.executeBloc(_loc3_);
      if(this._oTutorial.canCancel || this.api.datacenter.Player.isAuthorized)
      {
         this.api.ui.loadUIComponent("Tutorial","Tutorial");
      }
      this.api.ui.getUIComponent("GameResult")._visible = false;
      this.api.ui.getUIComponent("GameResultLight")._visible = false;
      this.api.ui.getUIComponent("AchievementRewards")._visible = false;
   }
   function cancel()
   {
      var _loc2_ = this._oTutorial.getRootExitBloc();
      if(_loc2_ == undefined)
      {
         this.terminate(0);
      }
      else
      {
         this.executeBloc(_loc2_);
      }
   }
   function terminate(nActionListID)
   {
      this.clear();
      var _loc3_ = this.api.datacenter.Player.data.cellNum;
      var _loc4_ = this.api.datacenter.Player.data.direction;
      this.api.network.Tutorial.end(nActionListID,_loc3_,_loc4_);
      this.api.ui.unloadUIComponent("Indicator");
      this.api.ui.unloadUIComponent("Tutorial");
   }
   function forceTerminate()
   {
      this.clear();
      var _loc2_ = this.api.datacenter.Player.data.cellNum;
      var _loc3_ = this.api.datacenter.Player.data.direction;
      this.api.ui.unloadUIComponent("Indicator");
      this.api.ui.unloadUIComponent("Tutorial");
   }
   function executeBloc(oBloc)
   {
      ank.utils.Timer.removeTimer(this,"tutorial");
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      for(var i in oBloc.params)
      {
         if(typeof oBloc.params[i] == "string")
         {
            _loc3_ = String(oBloc.params[i]);
            if(_loc3_.substr(0,16) == "!LOCALIZEDSTRING" && _loc3_.substr(_loc3_.length - 1,1) == "!")
            {
               _loc4_ = Number(_loc3_.substring(16,_loc3_.length - 1));
               if(!_global.isNaN(_loc4_))
               {
                  oBloc.params[i] = this.api.lang.getTutorialText(_loc4_);
               }
            }
         }
         else if(typeof oBloc.params[i] == "object")
         {
            for(var s in oBloc.params[i])
            {
               if(typeof oBloc.params[i][s] == "string")
               {
                  _loc5_ = String(oBloc.params[i][s]);
                  if(_loc5_.substr(0,16) == "!LOCALIZEDSTRING" && _loc5_.substr(_loc5_.length - 1,1) == "!")
                  {
                     _loc6_ = Number(_loc5_.substring(16,_loc5_.length - 1));
                     if(!_global.isNaN(_loc6_))
                     {
                        oBloc.params[i][s] = this.api.lang.getTutorialText(_loc6_);
                     }
                  }
               }
            }
         }
      }
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
      var _loc40_;
      var _loc41_;
      var _loc42_;
      var _loc43_;
      switch(oBloc.type)
      {
         case dofus.datacenter.TutorialBloc.TYPE_ACTION:
            if(!(oBloc instanceof dofus.datacenter.TutorialAction))
            {
               ank.utils.Logger.err("[executeBloc] le type ne correspond pas");
               return undefined;
            }
            if(!oBloc.keepLastWaitingBloc)
            {
               delete this._oCurrentWaitingBloc;
            }
            switch(oBloc.actionCode)
            {
               case "VAR_ADD":
                  this._oSequencer.addAction(126,false,this,this.addToVariable,oBloc.params);
                  break;
               case "VAR_SET":
                  this._oSequencer.addAction(127,false,this,this.setToVariable,oBloc.params);
                  break;
               case "CHAT":
                  this._oSequencer.addAction(128,false,this.api.kernel,this.api.kernel.showMessage,[undefined,oBloc.params[0],oBloc.params[1]]);
                  break;
               case "HIDE_NPC":
                  this.api.gfx.spriteHandler.hideSprites(oBloc.params,2);
                  break;
               case "HIDE_MONSTER":
                  this.api.gfx.spriteHandler.hideSprites(oBloc.params,3);
                  break;
               case "HIDE_OTHER_PLAYERS":
                  this.api.gfx.spriteHandler.hideSprites(oBloc.params,4);
                  break;
               case "GFX_CLEAN_MAP":
                  this._oSequencer.addAction(129,false,this.api.gfx,this.api.gfx.cleanMap,[undefined,true]);
                  break;
               case "GFX_SELECT":
                  this._oSequencer.addAction(130,false,this.api.gfx,this.api.gfx.select,[oBloc.params[0],oBloc.params[1]]);
                  break;
               case "GFX_UNSELECT":
                  this._oSequencer.addAction(131,false,this.api.gfx,this.api.gfx.unSelect,[oBloc.params[0],oBloc.params[1]]);
                  break;
               case "GFX_ALPHA":
                  _loc7_ = this.getSpriteIDFromData(oBloc.params[0]);
                  this._oSequencer.addAction(132,false,this.api.gfx,this.api.gfx.setSpriteAlpha,[_loc7_,oBloc.params[1]]);
                  break;
               case "GFX_GRID":
                  if(oBloc.params[0] == true)
                  {
                     this._oSequencer.addAction(133,false,this.api.gfx,this.api.gfx.drawGrid,[false]);
                  }
                  else
                  {
                     this._oSequencer.addAction(134,false,this.api.gfx,this.api.gfx.removeGrid,[]);
                  }
                  break;
               case "GFX_ADD_INDICATOR":
                  _loc8_ = this.api.gfx.mapHandler.getCellData(oBloc.params[0]).mc;
                  if(_loc8_ == undefined)
                  {
                     ank.utils.Logger.err("[GFX_ADD_INDICATOR] la cellule n\'existe pas");
                     break;
                  }
                  _loc9_ = {x:_loc8_._x,y:_loc8_._y};
                  _loc8_._parent.localToGlobal(_loc9_);
                  _loc10_ = _loc9_.x;
                  _loc11_ = _loc9_.y;
                  this._oSequencer.addAction(135,false,this.api.ui,this.api.ui.unloadUIComponent,["Indicator"]);
                  this._oSequencer.addAction(136,false,this.api.ui,this.api.ui.loadUIComponent,["Indicator","Indicator",{coordinates:[_loc10_,_loc11_],offset:oBloc.params[1],rotate:false},{bAlwaysOnTop:true}]);
                  break;
               case "GFX_ADD_PLAYER_SPRITE":
                  _loc12_ = this.api.datacenter.Player.data;
                  this._oSequencer.addAction(137,false,this.api.gfx,this.api.gfx.addSprite,[_loc12_.id,_loc12_]);
                  break;
               case "GFX_ADD_SPRITE":
                  _loc13_ = new dofus.datacenter.PlayableCharacter(oBloc.params[0],ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + oBloc.params[1] + ".swf",oBloc.params[2],oBloc.params[3],oBloc.params[1]);
                  _loc13_.name = oBloc.params[4] != undefined ? oBloc.params[4] : "";
                  _loc13_.color1 = oBloc.params[5] != undefined ? oBloc.params[5] : -1;
                  _loc13_.color2 = oBloc.params[6] != undefined ? oBloc.params[6] : -1;
                  _loc13_.color3 = oBloc.params[7] != undefined ? oBloc.params[7] : -1;
                  this._oSequencer.addAction(138,false,this.api.gfx,this.api.gfx.addSprite,[_loc13_.id,_loc13_]);
                  break;
               case "GFX_REMOVE_SPRITE":
                  this._oSequencer.addAction(139,false,this.api.gfx,this.api.gfx.removeSprite,[oBloc.params[0],false]);
                  break;
               case "GFX_MOVE_SPRITE":
                  _loc14_ = this.getSpriteIDFromData(oBloc.params[0]);
                  _loc15_ = this.api.datacenter.Sprites.getItemAt(_loc14_);
                  _loc16_ = ank.battlefield.utils.Pathfinding.pathFind(this.api,this.api.gfx.mapHandler,_loc15_.cellNum,oBloc.params[1],{bAllDirections:false,bIgnoreSprites:true,bCellNumOnly:true,bWithBeginCellNum:true});
                  if(_loc16_ != null)
                  {
                     this.api.gfx.spriteHandler.moveSprite(_loc15_.id,_loc16_,this._oSequencer,false,undefined,false,false);
                  }
                  break;
               case "GFX_ADD_SPRITE_BUBBLE":
                  _loc17_ = this.getSpriteIDFromData(oBloc.params[0]);
                  this._oSequencer.addAction(140,true,this.api.gfx,this.api.gfx.removeSpriteBubble,[_loc17_],200);
                  this._oSequencer.addAction(141,false,this.api.gfx,this.api.gfx.addSpriteBubble,[_loc17_,oBloc.params[1]]);
                  break;
               case "GFX_CLEAR_SPRITE_BUBBLES":
                  this._oSequencer.addAction(142,false,this.api.gfx.textHandler,this.api.gfx.textHandler.clear,[]);
                  break;
               case "GFX_SPRITE_DIR":
                  _loc18_ = this.getSpriteIDFromData(oBloc.params[0]);
                  this._oSequencer.addAction(143,false,this.api.gfx,this.api.gfx.setSpriteDirection,[_loc18_,oBloc.params[1]]);
                  break;
               case "GFX_SPRITE_POS":
                  _loc19_ = this.getSpriteIDFromData(oBloc.params[0]);
                  this._oSequencer.addAction(144,false,this.api.gfx,this.api.gfx.setSpritePosition,[_loc19_,oBloc.params[1]]);
                  break;
               case "GFX_SPRITE_VISUALEFFECT":
                  _loc20_ = this.getSpriteIDFromData(oBloc.params[0]);
                  _loc21_ = new ank.battlefield.datacenter.VisualEffect();
                  _loc21_.file = dofus.Constants.SPELLS_PATH + oBloc.params[1] + ".swf";
                  _loc21_.level = !_global.isNaN(Number(oBloc.params[3])) ? Number(oBloc.params[3]) : 1;
                  _loc21_.bInFrontOfSprite = true;
                  this._oSequencer.addAction(145,false,this.api.gfx,this.api.gfx.addVisualEffectOnSprite,[_loc20_,_loc21_,oBloc.params[2],oBloc.params[4]]);
                  break;
               case "GFX_SPRITE_ANIM":
                  _loc22_ = this.getSpriteIDFromData(oBloc.params[0]);
                  this._oSequencer.addAction(146,false,this.api.gfx,this.api.gfx.setSpriteAnim,[_loc22_,oBloc.params[1]]);
                  break;
               case "GFX_SPRITE_EXEC_FUNCTION":
                  _loc23_ = this.getSpriteIDFromData(oBloc.params[0]);
                  _loc24_ = this.api.datacenter.Sprites.getItemAt(_loc23_);
                  _loc25_ = _loc24_[oBloc.params[1]];
                  if(typeof _loc25_ != "function")
                  {
                     ank.utils.Logger.err("[GFX_SPRITE_EXEC_FUNCTION] la fonction n\'existe pas");
                     break;
                  }
                  this._oSequencer.addAction(147,false,_loc24_,_loc25_,oBloc.params[2]);
                  break;
               case "GFX_SPRITE_SET_PROPERTY":
                  _loc26_ = this.getSpriteIDFromData(oBloc.params[0]);
                  _loc27_ = this.api.datacenter.Sprites.getItemAt(_loc26_);
                  this._oSequencer.addAction(148,false,this,this.setObjectPropertyValue,[_loc27_,oBloc.params[1],oBloc.params[2]]);
                  break;
               case "GFX_DRAW_ZONE":
                  this._oSequencer.addAction(149,false,this.api.gfx,this.api.gfx.drawZone,oBloc.params);
                  break;
               case "GFX_CLEAR_ALL_ZONES":
                  this._oSequencer.addAction(150,false,this.api.gfx,this.api.gfx.clearAllZones,[]);
                  break;
               case "GFX_ADD_POINTER_SHAPE":
                  this._oSequencer.addAction(151,false,this.api.gfx,this.api.gfx.addPointerShape,oBloc.params);
                  break;
               case "GFX_CLEAR_POINTER":
                  this._oSequencer.addAction(152,false,this.api.gfx,this.api.gfx.clearPointer,[]);
                  break;
               case "GFX_HIDE_POINTER":
                  this._oSequencer.addAction(153,false,this.api.gfx,this.api.gfx.hidePointer,[]);
                  break;
               case "GFX_DRAW_POINTER":
                  this._oSequencer.addAction(154,false,this.api.gfx,this.api.gfx.drawPointer,oBloc.params);
                  break;
               case "GFX_OBJECT2_INTERACTIVE":
                  this._oSequencer.addAction(155,false,this.api.gfx,this.api.gfx.setObject2Interactive,[oBloc.params[0],oBloc.params[1],1]);
                  break;
               case "GFX_OBJECT2_SETFRAME":
                  this._oSequencer.addAction(170,false,this.api.gfx,this.api.gfx.setObject2Frame,[oBloc.params[0],oBloc.params[1],1]);
                  break;
               case "INTERAC_SET":
                  this._oSequencer.addAction(156,false,this.api.gfx,this.api.gfx.setInteraction,[ank.battlefield.Constants[oBloc.params[0]]]);
                  break;
               case "INTERAC_SET_ONCELLS":
                  this._oSequencer.addAction(157,false,this.api.gfx,this.api.gfx.setInteractionOnCells,[oBloc.params[0],ank.battlefield.Constants[oBloc.params[1]]]);
                  break;
               case "UI_ADD_INDICATOR":
                  _loc28_ = this.api.ui.getUIComponent(oBloc.params[0]);
                  _loc29_ = eval(_loc28_ + "." + oBloc.params[1]);
                  _loc30_ = _loc29_.getBounds();
                  _loc31_ = _loc30_.xMax - _loc30_.xMin;
                  _loc32_ = _loc30_.yMax - _loc30_.yMin;
                  _loc33_ = _loc31_ / 2 + _loc29_._x + _loc30_.xMin;
                  _loc34_ = _loc32_ / 2 + _loc29_._y + _loc30_.yMin;
                  _loc35_ = {x:_loc33_,y:_loc34_};
                  _loc29_._parent.localToGlobal(_loc35_);
                  _loc33_ = _loc35_.x;
                  _loc34_ = _loc35_.y;
                  _loc36_ = Math.sqrt(Math.pow(_loc31_,2) + Math.pow(_loc32_,2)) / 2;
                  if(_loc28_._name == "Banner")
                  {
                     _loc37_ = dofus.graphics.gapi.ui.Banner(this.api.ui.getUIComponent("Banner"));
                     if(_loc37_.isButtonInMorePanel(oBloc.params[1]))
                     {
                        _loc37_.showMoreButtons();
                     }
                  }
                  this._oSequencer.addAction(158,false,this.api.ui,this.api.ui.unloadUIComponent,["Indicator"]);
                  this._oSequencer.addAction(159,false,this.api.ui,this.api.ui.loadUIComponent,["Indicator","Indicator",{coordinates:[_loc33_,_loc34_],offset:_loc36_},{bAlwaysOnTop:true}]);
                  break;
               case "UI_REMOVE_INDICATOR":
                  this._oSequencer.addAction(160,false,this.api.ui,this.api.ui.unloadUIComponent,["Indicator"]);
                  break;
               case "UI_OPEN":
                  this._oSequencer.addAction(161,false,this.api.ui,this.api.ui.loadUIComponent,[oBloc.params[0],oBloc.params[0],oBloc.params[1],oBloc.params[2]]);
                  break;
               case "UI_OPEN_AUTOHIDE":
                  this.api.ui.getUIComponent("Banner").hideMoreButtons();
                  this._oSequencer.addAction(162,false,this.api.ui,this.api.ui.loadUIAutoHideComponent,[oBloc.params[0],oBloc.params[0],oBloc.params[1],oBloc.params[2]]);
                  break;
               case "UI_CLOSE":
                  this.api.ui.getUIComponent("Banner").hideMoreButtons();
                  this._oSequencer.addAction(163,false,this.api.ui,this.api.ui.unloadUIComponent,[oBloc.params[0]]);
                  break;
               case "UI_EXEC_FUNCTION":
                  _loc38_ = this.api.ui.getUIComponent(oBloc.params[0]);
                  _loc39_ = _loc38_[oBloc.params[1]];
                  if(typeof _loc39_ != "function")
                  {
                     ank.utils.Logger.err("[UI_EXEC_FUNCTION] la fonction n\'existe pas");
                     break;
                  }
                  this._oSequencer.addAction(164,false,_loc38_,_loc39_,oBloc.params[2]);
                  break;
               case "ADD_SPELL":
                  _loc40_ = new dofus.datacenter.Spell(oBloc.params[0],oBloc.params[1],oBloc.params[2]);
                  this._oSequencer.addAction(165,false,this.api.datacenter.Player,this.api.datacenter.Player.updateSpellPosition,[_loc40_]);
                  break;
               case "SET_SPELLS":
                  this._oSequencer.addAction(166,false,this.api.network.Spells,this.api.network.Spells.onList,[oBloc.params.join(";")]);
                  break;
               case "REMOVE_SPELL":
                  this._oSequencer.addAction(167,false,this.api.datacenter.Player,this.api.datacenter.Player.removeSpell,oBloc.params);
                  break;
               case "END":
                  this._oSequencer.addAction(168,false,this,this.terminate,oBloc.params);
                  if(!this._oSequencer.isPlaying())
                  {
                     this._oSequencer.execute(true);
                  }
                  return undefined;
               default:
                  ank.utils.Logger.err("[executeBloc] Code action " + oBloc.actionCode + " inconnu");
                  return undefined;
            }
            this._oSequencer.addAction(169,false,this,this.callNextBloc,[oBloc.nextBlocID]);
            if(!this._oSequencer.isPlaying())
            {
               this._oSequencer.execute(true);
            }
            return;
            break;
         case dofus.datacenter.TutorialBloc.TYPE_WAITING:
            this._oCurrentWaitingBloc = oBloc;
            if(!(oBloc instanceof dofus.datacenter.TutorialWaiting))
            {
               ank.utils.Logger.log("[executeBloc] le type ne correspond pas");
               return undefined;
            }
            ank.utils.Timer.removeTimer(this,"tutorial");
            if(oBloc.timeout != 0)
            {
               ank.utils.Timer.setTimer(this,"tutorial",this,this.onWaitingTimeout,oBloc.timeout,[oBloc]);
            }
            return;
            break;
         case dofus.datacenter.TutorialBloc.TYPE_IF:
            if(!(oBloc instanceof dofus.datacenter.TutorialIf))
            {
               ank.utils.Logger.log("[executeBloc] le type ne correspond pas");
               return undefined;
            }
            _loc41_ = this.extractValue(oBloc.left);
            _loc42_ = this.extractValue(oBloc.right);
            _loc43_ = false;
            switch(oBloc.operator)
            {
               case "=":
                  _loc43_ = _loc41_ == _loc42_;
                  break;
               case "<":
                  _loc43_ = _loc41_ < _loc42_;
                  break;
               case ">":
                  _loc43_ = _loc41_ > _loc42_;
            }
            if(_loc43_)
            {
               this._oSequencer.addAction(170,false,this,this.callNextBloc,[oBloc.right_]);
            }
            else
            {
               this._oSequencer.addAction(171,false,this,this.callNextBloc,[oBloc.nextBlocFalseID]);
            }
            if(!this._oSequencer.isPlaying())
            {
               this._oSequencer.execute(true);
            }
            return;
            break;
         default:
            ank.utils.Logger.log("[executeBloc] mauvais type");
            return;
      }
   }
   function callNextBloc(mNextBlocID)
   {
      ank.utils.Timer.removeTimer(this,"tutorial");
      var _loc3_;
      if(typeof mNextBlocID == "object")
      {
         _loc3_ = mNextBlocID[random(mNextBlocID.length)];
      }
      else
      {
         _loc3_ = mNextBlocID;
      }
      this.addToQueue({object:this,method:this.executeBloc,params:[this._oTutorial.getBloc(_loc3_)]});
   }
   function callCurrentBlocDefaultCase()
   {
      var _loc2_ = this._oCurrentWaitingBloc.cases[dofus.datacenter.TutorialWaitingCase.CASE_DEFAULT];
      if(_loc2_ != undefined)
      {
         this.callNextBloc(_loc2_.nextBlocID);
      }
   }
   function setObjectPropertyValue(oObject, sProperty, mValue)
   {
      if(oObject == undefined)
      {
         ank.utils.Logger.err("[setObjectPropertyValue] l\'objet n\'existe pas");
         return undefined;
      }
      oObject[sProperty] = mValue;
   }
   function getSpriteIDFromData(mIDorCellNum)
   {
      if(typeof mIDorCellNum == "number")
      {
         return mIDorCellNum != 0 ? mIDorCellNum : this.api.datacenter.Player.ID;
      }
      if(typeof mIDorCellNum == "string")
      {
         return this.api.datacenter.Map.data[mIDorCellNum.substr(1)].spriteOnID;
      }
   }
   function setToVariable(sVarName, nValue)
   {
      sVarName = this.extractVarName(sVarName);
      this._oVars[sVarName] = nValue;
   }
   function addToVariable(sVarName, nValue)
   {
      sVarName = this.extractVarName(sVarName);
      if(this._oVars[sVarName] == undefined)
      {
         this._oVars[sVarName] = nValue;
      }
      else
      {
         this._oVars[sVarName] += nValue;
      }
   }
   function extractVarName(sVarName)
   {
      var _loc3_ = sVarName.split("|");
      var _loc4_;
      if(_loc3_.length != 0)
      {
         sVarName = _loc3_[0];
         _loc4_ = 1;
         while(_loc4_ < _loc3_.length)
         {
            sVarName += "_" + this._oVars[_loc3_[_loc4_]];
            _loc4_ = _loc4_ + 1;
         }
      }
      return sVarName;
   }
   function extractValue(mVarOrValue)
   {
      if(typeof mVarOrValue == "string")
      {
         return this._oVars[this.extractVarName(mVarOrValue)];
      }
      return mVarOrValue;
   }
   function onWaitingTimeout(oBloc)
   {
      this.callNextBloc(oBloc.cases[dofus.datacenter.TutorialWaitingCase.CASE_TIMEOUT].nextBlocID);
   }
   function onWaitingCase(oEvent)
   {
      var _loc3_ = oEvent.code;
      var _loc4_ = oEvent.params;
      var _loc5_ = this._oCurrentWaitingBloc.cases[_loc3_];
      var _loc6_;
      var _loc7_;
      if(_loc5_ != undefined)
      {
         switch(_loc5_.code)
         {
            case "CELL_RELEASE":
            case "CELL_OVER":
            case "CELL_OUT":
            case "SPRITE_RELEASE":
            case "SPELL_CONTAINER_SELECT":
            case "OBJECT_CONTAINER_SELECT":
               _loc6_ = 0;
               while(_loc6_ < _loc5_.params.length)
               {
                  if(_loc4_[0] == _loc5_.params[_loc6_][0])
                  {
                     this.callNextBloc(_loc5_.nextBlocID[_loc6_] != undefined ? _loc5_.nextBlocID[_loc6_] : _loc5_.nextBlocID);
                     return undefined;
                  }
                  _loc6_ = _loc6_ + 1;
               }
               break;
            case "OBJECT_RELEASE":
               _loc7_ = 0;
               while(_loc7_ < _loc5_.params.length)
               {
                  if(_loc4_[0] == _loc5_.params[_loc7_][0] && _loc4_[1] == _loc5_.params[_loc7_][1])
                  {
                     this.callNextBloc(_loc5_.nextBlocID[_loc7_] != undefined ? _loc5_.nextBlocID[_loc7_] : _loc5_.nextBlocID);
                     return undefined;
                  }
                  _loc7_ = _loc7_ + 1;
               }
               break;
            default:
               this.callNextBloc(_loc5_.nextBlocID);
               return undefined;
         }
         this.callCurrentBlocDefaultCase();
      }
      else
      {
         this.callCurrentBlocDefaultCase();
      }
   }
}
