class dofus.graphics.gapi.controls.MouseShortcuts extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnTabItems;
   var _btnTabSpells;
   var _ctr1;
   var _ctr2;
   var _ctr3;
   var _ctr4;
   var _ctr5;
   var _ctr6;
   var _ctr7;
   var _ctr8;
   var _ctr9;
   var _ctr10;
   var _ctr11;
   var _ctr12;
   var _ctr13;
   var _ctr14;
   var _ctrCC;
   var _currentOverContainer;
   var addToQueue;
   var gapi;
   var setMovieClipTransform;
   static var TAB_SPELLS = "Spells";
   static var TAB_ITEMS = "Items";
   static var CLASS_NAME = "MouseShortcuts";
   static var MAX_CONTAINER = 31;
   static var WRONG_STATE_TRANSFORM = {ra:50,rb:0,ga:50,gb:0,ba:70,bb:0};
   var _sCurrentTab = "Items";
   function MouseShortcuts()
   {
      super();
   }
   function get currentOverItem()
   {
      if(this._currentOverContainer != undefined && this._currentOverContainer.contentData != undefined)
      {
         return this._currentOverContainer.contentData;
      }
      return undefined;
   }
   function get currentTab()
   {
      return this._sCurrentTab;
   }
   function set meleeVisible(b)
   {
      this._ctrCC._visible = b;
   }
   function set tabVisible(b_)
   {
      this._btnTabItems._visible = b_;
      this._btnTabSpells._visible = b_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.MouseShortcuts.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
   }
   function getContainer(nID)
   {
      return this["_ctr" + nID];
   }
   function setContainer(nID, cContainer)
   {
      this["_ctr" + nID] = cContainer;
   }
   function spellMove(nSpellID, nPosition)
   {
      var _loc4_ = this.api.datacenter.Player.Spells;
      var _loc5_ = _loc4_.findFirstItem("ID",nSpellID).item;
      if(_loc5_ == undefined)
      {
         return undefined;
      }
      var _loc6_ = _loc4_.findFirstItem("position",nPosition).item;
      if(_loc6_ != undefined)
      {
         _loc6_.position = undefined;
      }
      _loc5_.position = nPosition;
      if(this._sCurrentTab != "Spells")
      {
         return undefined;
      }
      this.getContainer(nPosition).contentData = _loc5_;
      this.addToQueue({object:this,method:this.setSpellStateOnAllContainers});
   }
   function spellRemove(nPosition)
   {
      var _loc3_ = this.api.datacenter.Player.Spells;
      var _loc4_ = _loc3_.findFirstItem("position",nPosition).item;
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      _loc4_.position = undefined;
      if(this._sCurrentTab != "Spells")
      {
         return undefined;
      }
      this.getContainer(nPosition).contentData = undefined;
      this.addToQueue({object:this,method:this.setSpellStateOnAllContainers});
   }
   function initData()
   {
   }
   function initTexts()
   {
      this._btnTabSpells.label = this.api.lang.getText("BANNER_TAB_SPELLS");
      this._btnTabItems.label = this.api.lang.getText("BANNER_TAB_ITEMS");
   }
   function addListeners()
   {
      this._btnTabSpells.addEventListener("click",this);
      this._btnTabItems.addEventListener("click",this);
      this._btnTabSpells.addEventListener("over",this);
      this._btnTabItems.addEventListener("over",this);
      this._btnTabSpells.addEventListener("out",this);
      this._btnTabItems.addEventListener("out",this);
      var _loc2_ = 1;
      var _loc3_;
      while(_loc2_ < dofus.graphics.gapi.controls.MouseShortcuts.MAX_CONTAINER)
      {
         _loc3_ = this["_ctr" + _loc2_];
         _loc3_.addEventListener("click",this);
         _loc3_.addEventListener("dblClick",this);
         _loc3_.addEventListener("over",this);
         _loc3_.addEventListener("out",this);
         _loc3_.addEventListener("drag",this);
         _loc3_.addEventListener("drop",this);
         _loc3_.addEventListener("onContentLoaded",this);
         _loc3_.params = {position:_loc2_};
         _loc2_ = _loc2_ + 1;
      }
      this._ctrCC.addEventListener("click",this);
      this._ctrCC.addEventListener("over",this);
      this._ctrCC.addEventListener("out",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
      this.api.datacenter.Player.Spells.addEventListener("modelChanged",this);
      this.api.datacenter.Player.Inventory.addEventListener("modelChanged",this);
      this.api.datacenter.Player.InventoryShortcuts.addEventListener("modelChanged",this);
      this.api.datacenter.Player.SpellsManager.addEventListener("spellLaunched",this);
      this.api.datacenter.Player.SpellsManager.addEventListener("nextTurn",this);
      this.api.kernel.OptionsManager.addEventListener("optionChanged",this);
   }
   function clearSpellStateOnAllContainers()
   {
      var _loc2_ = this.api.datacenter.Player.Spells;
      var _loc3_;
      for(var k in _loc2_)
      {
         if(!_global.isNaN(_loc2_[k].position))
         {
            _loc3_ = this["_ctr" + _loc2_[k].position];
            _loc3_.showLabel = false;
            this.setMovieClipTransform(_loc3_.content,dofus.Constants.NO_TRANSFORM);
         }
      }
      this.setMovieClipTransform(this._ctrCC.content,dofus.Constants.NO_TRANSFORM);
   }
   function setSpellStateOnAllContainers()
   {
      if(this._sCurrentTab != "Spells")
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Player.Spells;
      for(var k in _loc2_)
      {
         if(!_global.isNaN(_loc2_[k].position))
         {
            this.setSpellStateOnContainer(_loc2_[k].position);
         }
      }
      this.setSpellStateOnContainer(0);
   }
   function setItemStateOnAllContainers()
   {
      if(this._sCurrentTab != "Items")
      {
         return undefined;
      }
      var _loc2_ = this.api.datacenter.Player.InventoryShortcuts.getItems();
      var _loc3_;
      for(var k in _loc2_)
      {
         _loc3_ = _loc2_[k].position;
         if(!(_global.isNaN(_loc3_) && _loc3_ < 1))
         {
            this.setItemStateOnContainer(_loc3_);
         }
      }
      this.setSpellStateOnContainer(0);
   }
   function updateSpells()
   {
      if(this._sCurrentTab != "Spells")
      {
         return undefined;
      }
      this._ctrCC.contentData = new dofus.datacenter.Spell(dofus.datacenter.CloseCombat.CLOSE_COMBAT_SPELL_ID,1);
      if(this._ctrCC.contentLoaded)
      {
         this._ctrCC.content.applyColors();
      }
      var _loc2_ = [];
      var _loc3_ = 1;
      while(_loc3_ < dofus.graphics.gapi.controls.MouseShortcuts.MAX_CONTAINER)
      {
         _loc2_[_loc3_] = true;
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = this.api.datacenter.Player.Spells;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      for(var k in _loc4_)
      {
         _loc5_ = _loc4_[k];
         _loc6_ = _loc5_.position;
         if(!_global.isNaN(_loc6_))
         {
            _loc7_ = this["_ctr" + _loc6_];
            _loc7_.contentData = _loc5_;
            if(_loc7_.contentLoaded)
            {
               _loc7_.content.applyColors();
            }
            _loc2_[_loc6_] = false;
         }
      }
      var _loc8_ = 1;
      while(_loc8_ < dofus.graphics.gapi.controls.MouseShortcuts.MAX_CONTAINER)
      {
         if(_loc2_[_loc8_])
         {
            this["_ctr" + _loc8_].contentData = undefined;
         }
         _loc8_ = _loc8_ + 1;
      }
      this.addToQueue({object:this,method:this.setSpellStateOnAllContainers});
   }
   function updateItems()
   {
      if(this._sCurrentTab != "Items")
      {
         return undefined;
      }
      var _loc2_ = [];
      var _loc3_ = 1;
      while(_loc3_ < dofus.graphics.gapi.controls.MouseShortcuts.MAX_CONTAINER)
      {
         _loc2_[_loc3_] = true;
         _loc3_ = _loc3_ + 1;
      }
      var _loc4_ = this.api.datacenter.Player.InventoryShortcuts.getItems();
      var _loc5_;
      var _loc6_;
      var _loc7_;
      for(var k in _loc4_)
      {
         _loc5_ = _loc4_[k];
         if(!_global.isNaN(_loc5_.position))
         {
            _loc6_ = _loc5_.position;
            _loc7_ = this["_ctr" + _loc6_];
            if(_loc7_.contentData != _loc5_)
            {
               _loc7_.contentData = _loc5_;
            }
            _loc7_.label = _loc5_.label;
            _loc7_.cornerIcon = _loc5_.cornerIconFile;
            this.setMovieClipTransform(_loc7_.content,!(_loc5_.isCustomSet || _loc5_.realLinkedItem != undefined) ? dofus.Constants.INACTIVE_TRANSFORM : dofus.Constants.NO_TRANSFORM);
            _loc2_[_loc6_] = false;
         }
      }
      var _loc8_ = 1;
      while(_loc8_ < dofus.graphics.gapi.controls.MouseShortcuts.MAX_CONTAINER)
      {
         if(_loc2_[_loc8_])
         {
            this["_ctr" + _loc8_].contentData = undefined;
         }
         _loc8_ = _loc8_ + 1;
      }
      this.addToQueue({object:this,method:this.setItemStateOnAllContainers});
   }
   function setSpellStateOnContainer(nIndex)
   {
      var _loc3_ = nIndex != 0 ? this["_ctr" + nIndex] : this._ctrCC;
      var _loc4_ = nIndex != 0 ? _loc3_.contentData : this.api.datacenter.Player.Spells[0];
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      var _loc5_;
      if(this.api.kernel.TutorialManager.isTutorialMode)
      {
         _loc5_.can = true;
      }
      else
      {
         _loc5_ = this.api.datacenter.Player.SpellsManager.checkCanLaunchSpellReturnObject(_loc4_.ID);
      }
      if(_loc5_.can == false)
      {
         switch(_loc5_.type)
         {
            case "NOT_IN_REQUIRED_STATE":
            case "IN_FORBIDDEN_STATE":
               this.setMovieClipTransform(_loc3_.content,dofus.graphics.gapi.controls.MouseShortcuts.WRONG_STATE_TRANSFORM);
               if(_loc5_.params[1])
               {
                  _loc3_.showLabel = true;
                  _loc3_.label = _loc5_.params[1];
               }
               else
               {
                  _loc3_.showLabel = false;
               }
               break;
            case "NOT_ENOUGH_AP":
            case "CANT_SUMMON_MORE_CREATURE":
            case "CANT_LAUNCH_MORE":
            case "CANT_RELAUNCH":
            case "NOT_IN_FIGHT":
               _loc3_.showLabel = false;
               this.setMovieClipTransform(_loc3_.content,dofus.Constants.INACTIVE_TRANSFORM);
               break;
            case "CANT_LAUNCH_BEFORE":
               this.setMovieClipTransform(_loc3_.content,dofus.Constants.INACTIVE_TRANSFORM);
               _loc3_.showLabel = true;
               _loc3_.label = _loc5_.params[0];
         }
      }
      else
      {
         _loc3_.showLabel = false;
         this.setMovieClipTransform(_loc3_.content,dofus.Constants.NO_TRANSFORM);
      }
   }
   function setItemStateOnContainer(nIndex)
   {
      var _loc3_ = this["_ctr" + nIndex];
      var _loc4_ = dofus.datacenter.InventoryShortcutItem(_loc3_.contentData);
      if(_loc4_ == undefined)
      {
         return undefined;
      }
      this.setMovieClipTransform(_loc3_.content,!(!this.api.datacenter.Game.isRunning && (_loc4_.isCustomSet || _loc4_.realLinkedItem != undefined)) ? dofus.Constants.INACTIVE_TRANSFORM : dofus.Constants.NO_TRANSFORM);
      _loc3_.showLabel = _loc4_.label != undefined;
   }
   function updateCurrentTabInformations()
   {
      switch(this._sCurrentTab)
      {
         case "Spells":
            this.updateSpells();
            this._ctrCC._visible = !this.api.datacenter.Player.isMutant;
            break;
         case "Items":
            this.updateItems();
            this._ctrCC._visible = false;
         default:
            return;
      }
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_;
      var _loc4_;
      if(sNewTab != this._sCurrentTab)
      {
         _loc3_ = this["_btnTab" + this._sCurrentTab];
         _loc4_ = this["_btnTab" + sNewTab];
         _loc3_.selected = true;
         _loc3_.enabled = true;
         _loc4_.selected = false;
         _loc4_.enabled = false;
         this._sCurrentTab = sNewTab;
         this.updateCurrentTabInformations();
      }
   }
   function castSpellOnSelf(oSpell)
   {
      if(oSpell.rangeMin != 0)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_CAST_SPELL_ON_SELF_RANGE",[oSpell.name]),"ERROR_CHAT");
         return undefined;
      }
      if(this.api.datacenter.Game.currentPlayerID != this.api.datacenter.Player.ID)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CANT_CAST_SPELL_RIGHT_NOW"),"ERROR_CHAT");
         return undefined;
      }
      if(!this.api.kernel.GameManager.checkSpriteStateCanLaunchSpell())
      {
         return undefined;
      }
      if(!this.api.kernel.GameManager.checkCanLaunchSpell(oSpell))
      {
         return undefined;
      }
      var _loc3_ = this.api.datacenter.Player.data.cellNum;
      var _loc4_ = this.api.gfx.mapHandler.getCellData(_loc3_);
      this.api.datacenter.Game.setInteractionType("spell");
      this.api.datacenter.Player.currentUseObject = oSpell;
      this.api.datacenter.Basics.gfx_canLaunch = true;
      this.api.gfx.onCellRelease(_loc4_.mc);
   }
   function onShortcut(sShortcut)
   {
      var _loc3_ = true;
      switch(sShortcut)
      {
         case "SWAP":
            this.setCurrentTab(this._sCurrentTab != "Spells" ? "Spells" : "Items");
            _loc3_ = false;
            break;
         case "SH0":
            this.click({target:this._ctrCC});
            _loc3_ = false;
            break;
         case "SH1":
            this.click({target:this._ctr1,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH2":
            this.click({target:this._ctr2,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH3":
            this.click({target:this._ctr3,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH4":
            this.click({target:this._ctr4,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH5":
            this.click({target:this._ctr5,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH6":
            this.click({target:this._ctr6,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH7":
            this.click({target:this._ctr7,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH8":
            this.click({target:this._ctr8,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH9":
            this.click({target:this._ctr9,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH10":
            this.click({target:this._ctr10,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH11":
            this.click({target:this._ctr11,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH12":
            this.click({target:this._ctr12,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH13":
            this.click({target:this._ctr13,keyBoard:true});
            _loc3_ = false;
            break;
         case "SH14":
            this.click({target:this._ctr14,keyBoard:true});
            _loc3_ = false;
      }
      return _loc3_;
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      switch(oEvent.target)
      {
         case this._btnTabSpells:
            this.api.sounds.events.onBannerSpellItemButtonClick();
            this.setCurrentTab("Spells");
            return;
         case this._btnTabItems:
            this.api.sounds.events.onBannerSpellItemButtonClick();
            this.setCurrentTab("Items");
            return;
         case this._ctrCC:
            if(this._ctrCC._visible)
            {
               if(this.api.kernel.TutorialManager.isTutorialMode)
               {
                  this.api.kernel.TutorialManager.onWaitingCase({code:"CC_CONTAINER_SELECT"});
                  return;
               }
               this.api.kernel.GameManager.switchToSpellLaunch(this.api.datacenter.Player.Spells[0],false);
            }
            return;
         default:
            switch(this._sCurrentTab)
            {
               case "Spells":
                  this.api.sounds.events.onBannerSpellSelect();
                  if(this.api.kernel.TutorialManager.isTutorialMode)
                  {
                     this.api.kernel.TutorialManager.onWaitingCase({code:"SPELL_CONTAINER_SELECT",params:[Number(oEvent.target._name.substr(4))]});
                     break;
                  }
                  if(this.gapi.getUIComponent("Spells") != undefined)
                  {
                     return undefined;
                  }
                  _loc3_ = oEvent.target.contentData;
                  if(_loc3_ == undefined)
                  {
                     return undefined;
                  }
                  this.api.kernel.GameManager.switchToSpellLaunch(_loc3_,true);
                  break;
               case "Items":
                  if(this.api.kernel.TutorialManager.isTutorialMode)
                  {
                     this.api.kernel.TutorialManager.onWaitingCase({code:"OBJECT_CONTAINER_SELECT",params:[Number(oEvent.target._name.substr(4))]});
                     break;
                  }
                  _loc4_ = oEvent.target.contentData;
                  _loc5_ = _loc4_ == undefined ? undefined : _loc4_.realLinkedItem;
                  if(_loc5_ == undefined && !_loc4_.isCustomSet)
                  {
                     return undefined;
                  }
                  if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && !_loc4_.isCustomSet)
                  {
                     this.api.kernel.GameManager.insertItemInChat(_loc5_);
                     return undefined;
                  }
                  _loc6_ = this.gapi.getUIComponent("Inventory");
                  if(_loc6_ != undefined)
                  {
                     _loc6_.showItemInfos(_loc5_);
                  }
                  else
                  {
                     if(!this.api.datacenter.Player.checkCanMoveItem())
                     {
                        return undefined;
                     }
                     if(oEvent.keyBoard)
                     {
                        if(_loc4_ != undefined && _loc4_.isCustomSet)
                        {
                           _loc7_ = _loc4_.linkedCustomSet;
                           this.api.network.RapidStuff.loadRapidStuff(_loc7_.id);
                           this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_LOADED",[_loc7_.name]),"INFO_CHAT");
                           break;
                        }
                        if(_loc5_.isEquiped)
                        {
                           this.api.network.Items.movement(_loc5_.ID,-1);
                           return undefined;
                        }
                        if(this.api.network.Items.equipItem(_loc5_))
                        {
                           return undefined;
                        }
                     }
                     if(this.api.datacenter.Player.canUseObject)
                     {
                        if(_loc5_.canTarget)
                        {
                           this.api.kernel.GameManager.switchToItemTarget(_loc5_);
                        }
                        else if(_loc5_.canUse && oEvent.keyBoard)
                        {
                           if(Key.isDown(Key.CONTROL) || Key.isDown(Key.SHIFT))
                           {
                              dofus.graphics.gapi.ui.Inventory.askBatchUseItem(this.api,_loc5_);
                           }
                           else
                           {
                              this.api.network.Items.use(_loc5_.ID);
                           }
                        }
                     }
                  }
            }
            return;
      }
   }
   function dblClick(oEvent)
   {
      var _loc0_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(this._sCurrentTab)
      {
         case "Spells":
            if((_loc0_ = oEvent.target._name) !== "_ctrCC")
            {
               _loc3_ = oEvent.target.contentData;
            }
            else
            {
               _loc3_ = this.api.datacenter.Player.Spells[0];
            }
            if(_loc3_ == undefined)
            {
               return undefined;
            }
            this.gapi.loadUIAutoHideComponent("SpellInfos","SpellInfos",{spell:_loc3_},{bStayIfPresent:true});
            break;
         case "Items":
            if(!this.api.datacenter.Player.checkCanMoveItem())
            {
               return undefined;
            }
            _loc4_ = oEvent.target.contentData;
            if(_loc4_.isCustomSet)
            {
               _loc5_ = oEvent.target.contentData.linkedCustomSet;
               this.api.network.RapidStuff.loadRapidStuff(_loc5_.id);
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_LOADED",[_loc5_.name]),"INFO_CHAT");
            }
            else
            {
               _loc6_ = _loc4_ == undefined ? undefined : _loc4_.realLinkedItem;
               if(_loc6_ == undefined)
               {
                  return undefined;
               }
               if(!_loc6_.isEquiped)
               {
                  if(!_loc6_.canUse || !this.api.datacenter.Player.canUseObject)
                  {
                     this.api.network.Items.equipItem(_loc6_);
                  }
                  else if(Key.isDown(Key.CONTROL) || Key.isDown(Key.SHIFT))
                  {
                     dofus.graphics.gapi.ui.Inventory.askBatchUseItem(this.api,_loc6_);
                  }
                  else
                  {
                     this.api.network.Items.use(_loc6_.ID);
                  }
               }
               else
               {
                  this.api.network.Items.movement(_loc6_.ID,-1);
               }
            }
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = oEvent.target) !== this._ctrCC)
      {
         switch(this._sCurrentTab)
         {
            case "Spells":
               this._currentOverContainer = oEvent.target;
               _loc6_ = oEvent.target.contentData;
               if(_loc6_ != undefined && this.gapi.isCursorHidden())
               {
                  _loc7_ = "<b>" + _loc6_.name + "</b> - ";
                  _loc7_ += (_loc6_.apCost >= 1 ? _loc6_.apCost : "1") + " " + this.api.lang.getText("AP");
                  _loc7_ += _loc6_.actualCriticalHit <= 0 ? "" : "\n(" + this.api.lang.getText("ACTUAL_CRITICAL_CHANCE") + ": 1/" + _loc6_.actualCriticalHit + ")";
                  _loc7_ += !(_loc6_.rangeMin == 0 && this.api.kernel.OptionsManager.getOption("RightClickToCast")) ? "" : "\n\n" + this.api.lang.getText("RIGHT_CLICK_TO_CAST_SPELL_ON_SELF");
                  this.gapi.showTooltip(_loc7_);
               }
               break;
            case "Items":
               this._currentOverContainer = oEvent.target;
               _loc8_ = oEvent.target.contentData;
               if(_loc8_ != undefined && this.gapi.isCursorHidden())
               {
                  _loc9_ = "<b>" + _loc8_.name + "</b>";
                  if(this.gapi.getUIComponent("Inventory") == undefined)
                  {
                     if(_loc8_.isEquipable || _loc8_.isCustomSet)
                     {
                        _loc9_ += "\n" + this.api.lang.getText("HELP_SHORTCUT_DBLCLICK_EQUIP");
                     }
                     else if(_loc8_.canUse)
                     {
                        if(_loc8_.canTarget)
                        {
                           _loc9_ += "\n" + this.api.lang.getText("HELP_SHORTCUT_DBLCLICK_CLICK");
                        }
                        else
                        {
                           _loc9_ += "\n" + this.api.lang.getText("HELP_SHORTCUT_DBLCLICK");
                        }
                     }
                     else if(_loc8_.canTarget)
                     {
                        _loc9_ += "\n" + this.api.lang.getText("HELP_SHORTCUT_CLICK");
                     }
                  }
                  this.gapi.showTooltip(_loc9_,_loc8_.style);
               }
         }
      }
      else
      {
         if(!this.gapi.isCursorHidden())
         {
            return undefined;
         }
         _loc3_ = this.api.datacenter.Player.Spells[0];
         _loc4_ = this.api.kernel.GameManager.getCriticalHitChance(_loc3_.criticalHit);
         _loc5_ = "<b>" + _loc3_.name + "</b> - ";
         _loc5_ += !_loc3_.isUnusable ? _loc3_.apCost + " " + this.api.lang.getText("AP") : this.api.lang.getText("UNUSABLE");
         _loc5_ += _global.isNaN(_loc4_) ? "\n\n" : "\n" + "(" + this.api.lang.getText("ACTUAL_CRITICAL_CHANCE") + ": 1/" + _loc4_ + ")" + "\n\n";
         _loc5_ += _loc3_.descriptionVisibleEffects;
         this.gapi.showTooltip(_loc5_);
      }
   }
   function out(oEvent)
   {
      this._currentOverContainer = undefined;
      this.gapi.hideTooltip();
   }
   function drag(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      switch(this._sCurrentTab)
      {
         case "Spells":
            if(this.gapi.getUIComponent("Spells") == undefined && !Key.isDown(Key.SHIFT))
            {
               return undefined;
            }
            break;
         case "Items":
            if(this.gapi.getUIComponent("Inventory") == undefined && !Key.isDown(Key.SHIFT))
            {
               return undefined;
            }
      }
      this.gapi.removeCursor();
      this.gapi.setCursor(_loc3_,undefined,this._sCurrentTab == "Spells");
   }
   function onContentLoaded(oEvent)
   {
      if(this._sCurrentTab != "Spells")
      {
         return undefined;
      }
      var _loc3_ = oEvent.content;
      _loc3_.applyColors();
   }
   function drop(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      switch(this._sCurrentTab)
      {
         case "Spells":
            if(this.gapi.getUIComponent("Spells") == undefined && !Key.isDown(Key.SHIFT))
            {
               return undefined;
            }
            _loc3_ = this.gapi.getCursor();
            if(_loc3_ == undefined)
            {
               return undefined;
            }
            this.gapi.removeCursor();
            _loc4_ = _loc3_.position;
            _loc5_ = oEvent.target.params.position;
            if(_loc4_ == _loc5_)
            {
               return undefined;
            }
            this.api.network.Spells.moveToUsed(_loc3_.ID,_loc5_);
            break;
         case "Items":
            if(this.gapi.getUIComponent("Inventory") == undefined && !Key.isDown(Key.SHIFT))
            {
               return undefined;
            }
            _loc6_ = this.gapi.getCursor();
            if(_loc6_ == undefined)
            {
               return undefined;
            }
            this.gapi.removeCursor();
            _loc7_ = oEvent.target.params.position;
            if(_loc6_.isShortcut && _loc6_.position == _loc7_)
            {
               return undefined;
            }
            if(_loc6_.isShortcut)
            {
               this.api.network.InventoryShortcuts.sendInventoryShortcutMove(_loc6_.position,_loc7_);
            }
            else if(_loc6_.isCustomSet)
            {
               _loc8_ = _loc6_.id;
               if(_loc6_.isEmptyRapidStuff)
               {
                  return undefined;
               }
               this.api.network.InventoryShortcuts.sendInventoryShortcutQuickAdd(_loc7_,_loc8_);
            }
            else
            {
               _loc9_ = _loc6_.ID;
               if(_loc9_ == undefined || _loc9_ == -1)
               {
                  return undefined;
               }
               this.api.network.InventoryShortcuts.sendInventoryShortcutAdd(_loc7_,_loc9_);
            }
      }
   }
   function modelChanged(oEvent)
   {
      switch(oEvent.eventName)
      {
         case "updateOne":
         case "updateAll":
      }
      if(oEvent.target == this.api.datacenter.Player.Spells)
      {
         this.updateSpells();
      }
      else
      {
         this.updateItems();
      }
   }
   function spellLaunched(oEvent_)
   {
      this.setSpellStateOnContainer(oEvent_.spell.position);
   }
   function nextTurn(oEvent_)
   {
      this.setSpellStateOnAllContainers();
   }
   function optionChanged(oEvent_)
   {
      if(oEvent_.key == "HideInventoryItemsCornerIcon")
      {
         this.updateItems();
      }
   }
}
