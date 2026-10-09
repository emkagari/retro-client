class dofus.graphics.gapi.controls.MountViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _alpha;
   var _btnAncestors;
   var _btnPregnant;
   var _btnTabCapacities;
   var _btnTabEffects;
   var _btnTabGeneral;
   var _btnTabStats;
   var _lblAgressivity;
   var _lblEnergy;
   var _lblLevel;
   var _lblLove;
   var _lblMaturity;
   var _lblModel;
   var _lblModelValue;
   var _lblMountable;
   var _lblMountableValue;
   var _lblName;
   var _lblNameValue;
   var _lblPregnant;
   var _lblSerenity;
   var _lblSex;
   var _lblSexValue;
   var _lblStamina;
   var _lblTired;
   var _lblWild;
   var _lblWildValue;
   var _lblXP;
   var _ldrAgressivity;
   var _ldrEnergy;
   var _ldrLove;
   var _ldrLove2;
   var _ldrMaturity;
   var _ldrMaturity2;
   var _ldrSerenity;
   var _ldrSprite;
   var _ldrStamina;
   var _ldrStamina2;
   var _lstList;
   var _mcEnergy;
   var _mcLove;
   var _mcMaturity;
   var _mcReproductions;
   var _mcSerenity;
   var _mcStamina;
   var _mcTired;
   var _mcXP;
   var _mcZone1;
   var _mcZone2;
   var _mcZone3;
   var _oMount;
   var _parent;
   var _pbEnergy;
   var _pbLove;
   var _pbMaturity;
   var _pbReproductions;
   var _pbSerenity;
   var _pbStamina;
   var _pbTired;
   var _pbXP;
   var addToQueue;
   var api;
   var gapi;
   var gotoAndStop;
   var initialized;
   var unloadThis;
   static var CLASS_NAME = "MountViewer";
   var _sCurrentTab = "General";
   function MountViewer()
   {
      super();
   }
   function set mount(oMount)
   {
      this._oMount = oMount;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function get mount()
   {
      return this._oMount;
   }
   function get isMyMount()
   {
      return this._oMount.ID == this.api.datacenter.Player.mount.ID && this._oMount.ID != undefined;
   }
   function get currentTab()
   {
      return this._sCurrentTab;
   }
   function set currentTab(sTab)
   {
      this._sCurrentTab = sTab;
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(sNewTab != undefined)
      {
         _loc3_ = this["_btnTab" + this._sCurrentTab];
         _loc4_ = this["_btnTab" + sNewTab];
         _loc3_.selected = true;
         _loc3_.enabled = true;
         _loc4_.selected = false;
         _loc4_.enabled = false;
         this._sCurrentTab = sNewTab;
         this.selectTab(this["_btnTab" + sNewTab]);
      }
      else
      {
         _loc5_ = this["_btnTab" + this._sCurrentTab];
         _loc5_.selected = false;
         _loc5_.enabled = false;
         this.selectTab(_loc5_);
      }
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.MountViewer.CLASS_NAME);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
   }
   function addListeners()
   {
      this._ldrSprite.addEventListener("initialization",this);
      this._btnPregnant.addEventListener("over",this);
      this._btnPregnant.addEventListener("out",this);
      this._btnTabGeneral.addEventListener("click",this);
      this._btnTabStats.addEventListener("click",this);
      this._btnTabCapacities.addEventListener("click",this);
      this._btnTabEffects.addEventListener("click",this);
      this._btnAncestors.addEventListener("click",this);
      this._btnAncestors.addEventListener("over",this);
      this._btnAncestors.addEventListener("out",this);
      this._mcXP.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.xp).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.xpMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcXP.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._lblAgressivity.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.energy).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.energyMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._lblAgressivity.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._mcTired.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.tired).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.tiredMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcTired.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._mcReproductions.onRollOver = function()
      {
         if(this._parent._oMount.reprodMax > -1)
         {
            this._parent.gapi.showTooltip(this._parent.api.lang.getText("REPRODUCTIONS") + ": " + new ank.utils.ExtendedString(this._parent._oMount.reprod).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.reprodMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
         }
         else
         {
            this._parent.gapi.showTooltip(this._parent.api.lang.getText("REPRODUCTIONS") + ": " + this._parent.api.lang.getText("UNLIMITED_WORD"));
         }
      };
      this._mcReproductions.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
   }
   function initTexts()
   {
      this._lblXP.text = this.api.lang.getText("EXPERIMENT");
      this._lblModel.text = this.api.lang.getText("TYPE");
      this._lblEnergy.text = this.api.lang.getText("ENERGY");
      this._lblSexValue.text = this.api.lang.getText("TIRE");
      this._btnTabGeneral.label = this.api.lang.getText("OPTIONS_GENERAL");
      this._btnTabStats.label = this.api.lang.getText("STATS");
      this._btnTabCapacities.label = this.api.lang.getText("CAPACITIES");
      this._btnTabEffects.label = this.api.lang.getText("EFFECTS");
   }
   function updateData()
   {
      var _loc2_;
      var _loc3_;
      if(this._oMount != undefined)
      {
         this._oMount.addEventListener("nameChanged",this);
         this._ldrSprite.forceNextLoad();
         this._ldrSprite.contentPath = this._oMount.gfxFile;
         _loc2_ = new ank.battlefield.datacenter.Sprite("-1",undefined,"",0,0);
         _loc2_.mount = this._oMount;
         this.api.colors.addSprite(this._ldrSprite,_loc2_);
         this._oMount.level = this._oMount.level;
         this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + this._oMount.level.toString();
         this._pbXP.minimum = this._oMount.xpMin;
         this._pbXP.maximum = this._oMount.xpMax;
         this._pbXP.value = this._oMount.xp;
         this._pbEnergy.maximum = this._oMount.energyMax;
         this._pbEnergy.value = this._oMount.energy;
         this._pbTired.maximum = this._oMount.tiredMax;
         this._pbTired.value = this._oMount.tired;
         this._pbReproductions.maximum = this._oMount.reprodMax <= -1 ? 0 : this._oMount.reprodMax;
         this._pbReproductions.value = this._oMount.reprodMax <= -1 ? 0 : this._oMount.reprod;
         this._ldrMaturity.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "94.swf";
         this._lblMountableValue.text = this._oMount.modelName;
         _loc3_ = this._oMount.fecondation > 0;
         if(_loc3_)
         {
            this._lblPregnant._visible = true;
            this._btnPregnant._visible = true;
            this._btnPregnant.icon = "Oeuf";
            this._lblPregnant.styleName = "RedLeftMediumBoldLabel";
            this._lblPregnant.text = this.api.lang.getText("PREGNANT_SINCE",[this._oMount.fecondation]);
            this._lblPregnant._x = 110;
            this._mcReproductions._visible = false;
            this._pbReproductions._visible = false;
         }
         else if(this._oMount.fecondable)
         {
            this._lblPregnant._visible = true;
            this._btnPregnant._visible = false;
            this._lblPregnant.styleName = "GreenLeftMediumBoldLabel";
            this._lblPregnant.text = this.api.lang.getText("FECONDABLE");
            this._lblPregnant._x = 90;
            this._mcReproductions._visible = true;
            this._pbReproductions._visible = true;
         }
         else if(this._oMount.reprodMax == this._oMount.reprod)
         {
            this._btnPregnant._visible = false;
            this._lblPregnant._visible = true;
            this._lblPregnant.styleName = "RedLeftMediumBoldLabel";
            this._lblPregnant.text = this.api.lang.getText("STERILE");
            this._lblPregnant._x = 90;
            this._mcReproductions._visible = false;
            this._pbReproductions._visible = false;
         }
         else if(this._oMount.reprod == -1)
         {
            this._btnPregnant._visible = false;
            this._lblPregnant._visible = true;
            this._lblPregnant.styleName = "RedLeftMediumBoldLabel";
            this._lblPregnant.text = this.api.lang.getText("CASTRATED");
            this._lblPregnant._x = 90;
            this._mcReproductions._visible = false;
            this._pbReproductions._visible = false;
         }
         else
         {
            this._btnPregnant._visible = false;
            this._lblPregnant._visible = true;
            this._lblPregnant.styleName = "BrownLeftMediumBoldLabel";
            this._lblPregnant.text = this.api.lang.getText("REPRODUCTIONS");
            this._lblPregnant._x = 90;
            this._mcReproductions._visible = true;
            this._pbReproductions._visible = true;
         }
         this.addToQueue({object:this,method:this.setCurrentTab});
      }
   }
   function selectTab(btnTab, bNoReload)
   {
      switch(btnTab)
      {
         case this._btnTabGeneral:
            this.gotoAndStop("general");
            this.addToQueue({object:this,method:this.switchToGeneralTab});
            break;
         case this._btnTabStats:
            this.gotoAndStop("statsTab");
            this.addToQueue({object:this,method:this.switchToStatsTab});
            break;
         case this._btnTabCapacities:
            this.gotoAndStop("capacities");
            this.addToQueue({object:this,method:this.switchToCapacitiesTab});
            break;
         case this._btnTabEffects:
            this.gotoAndStop("effects");
            this.addToQueue({object:this,method:this.switchToEffectsTab});
         default:
            return;
      }
   }
   function switchToGeneralTab()
   {
      this._lblName.text = this.api.lang.getText("NAME_BIG");
      this._lblNameValue.text = this._oMount.name;
      this._lblTired.text = this.api.lang.getText("CREATE_SEX");
      this._lblWild.text = !this._oMount.sex ? this.api.lang.getText("ANIMAL_MEN") : this.api.lang.getText("ANIMAL_WOMEN");
      this._lblSerenity.text = this.api.lang.getText("MOUNTABLE");
      this._lblSex.text = !this._oMount.mountable ? this.api.lang.getText("NO") : this.api.lang.getText("YES");
      this._ldrAgressivity.text = this.api.lang.getText("WILD");
      this._ldrEnergy.text = !this._oMount.wild ? this.api.lang.getText("NO") : this.api.lang.getText("YES");
   }
   function switchToStatsTab()
   {
      this._ldrStamina2.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "98.swf";
      this._ldrLove2.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "99.swf";
      this._ldrMaturity2.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "97.swf";
      this._ldrSerenity.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "97.swf";
      this._mcLove.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "96.swf";
      this._mcMaturity.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "96.swf";
      this._mcEnergy.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "95.swf";
      this._ldrStamina.contentPath = dofus.Constants.SMILEYS_ICONS_PATH + "95.swf";
      this._lblMountable.text = this.api.lang.getText("AGRESSIVITY");
      this._lblWildValue.text = this.api.lang.getText("SERENITY");
      this._lblMaturity.text = this.api.lang.getText("MATURITY");
      this._lblStamina.text = this.api.lang.getText("STAMINA");
      this._lblLove.text = this.api.lang.getText("LOVE");
      this._pbSerenity.minimum = this._oMount.serenityMin;
      this._pbSerenity.maximum = this._oMount.serenityMax;
      this._pbSerenity.value = this._oMount.serenity;
      this._pbLove.maximum = this._oMount.loveMax;
      this._pbLove.value = this._oMount.love;
      this._pbMaturity.maximum = this._oMount.maturityMax;
      this._pbMaturity.value = this._oMount.maturity;
      this._pbStamina.maximum = this._oMount.staminaMax;
      this._pbStamina.value = this._oMount.stamina;
      this._mcSerenity.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.serenityMin).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.serenity).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.serenityMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcSerenity.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._lblModelValue.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.love).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.loveMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._lblModelValue.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._ldrLove.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.maturity).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.maturityMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._ldrLove.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._mcStamina.onRollOver = function()
      {
         this._parent.gapi.showTooltip(new ank.utils.ExtendedString(this._parent._oMount.stamina).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._parent._oMount.staminaMax).addMiddleChar(this._parent.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      };
      this._mcStamina.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._mcZone1.onRollOver = function()
      {
         this._alpha = 100;
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_ZONE1"));
      };
      this._mcZone1.onRollOut = function()
      {
         this._alpha = 0;
         this._parent.gapi.hideTooltip();
      };
      this._mcZone2.onRollOver = function()
      {
         this._alpha = 100;
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_ZONE2"));
      };
      this._mcZone2.onRollOut = function()
      {
         this._alpha = 0;
         this._parent.gapi.hideTooltip();
      };
      this._mcZone3.onRollOver = function()
      {
         this._alpha = 100;
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_ZONE3"));
      };
      this._mcZone3.onRollOut = function()
      {
         this._alpha = 0;
         this._parent.gapi.hideTooltip();
      };
      this._mcZone1._alpha = 0;
      this._mcZone2._alpha = 0;
      this._mcZone3._alpha = 0;
      this._lblMaturity.onRollOver = function()
      {
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_MATURITY"));
      };
      this._lblMaturity.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._lblStamina.onRollOver = function()
      {
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_STAMINA"));
      };
      this._lblStamina.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
      this._lblLove.onRollOver = function()
      {
         this._parent.gapi.showTooltip(this._parent.api.lang.getText("MOUNT_VIEWER_TOOLTIP_LOVE"));
      };
      this._lblLove.onRollOut = function()
      {
         this._parent.gapi.hideTooltip();
      };
   }
   function switchToCapacitiesTab()
   {
      this._lstList.addEventListener("itemRollOver",this);
      this._lstList.addEventListener("itemRollOut",this);
      var _loc2_;
      if(this._oMount.capacities.length > 0)
      {
         this._lstList.dataProvider = this._oMount.capacities;
      }
      else
      {
         _loc2_ = new ank.utils.ExtendedArray();
         _loc2_.push({label:this.api.lang.getText("NO_CONDITIONS")});
         this._lstList.dataProvider = _loc2_;
      }
   }
   function switchToEffectsTab()
   {
      this._lstList.removeEventListener("itemRollOver",this);
      this._lstList.removeEventListener("itemRollOut",this);
      var _loc2_;
      if(this._oMount.effects.length > 0)
      {
         this._lstList.dataProvider = ank.utils.ExtendedArray(this._oMount.effects);
      }
      else
      {
         _loc2_ = new ank.utils.ExtendedArray();
         _loc2_.push({label:this.api.lang.getText("NONE")});
         this._lstList.dataProvider = _loc2_;
      }
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target.content;
      _loc3_.attachMovie("staticR_front","anim_front",11);
      _loc3_.attachMovie("staticR_back","anim_back",10);
   }
   function click(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) !== this._btnAncestors)
      {
         this.setCurrentTab(oEvent.target._name.substr(7));
      }
      else
      {
         this.gapi.loadUIComponent("MountAncestorsViewer","MountAncestorsViewer",{mount:this._oMount});
      }
   }
   function nameChanged(oEvent)
   {
      var _loc3_ = this.api.datacenter.Player.mount;
      this._lblNameValue.text = _loc3_.name;
   }
   function over(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._btnAncestors:
            this.gapi.showTooltip(this.api.lang.getText("MOUNT_ANCESTORS"));
            break;
         case this._btnPregnant:
            _loc3_ = this.api.lang.getText(this._oMount.fecondation <= 0 ? "FECONDABLE" : "PREGNANT_SINCE",[this._oMount.fecondation]);
            this.gapi.showTooltip(_loc3_);
         default:
            return;
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function itemRollOver(oEvent)
   {
      var _loc0_;
      var _loc3_;
      if((_loc0_ = oEvent.target) === this._lstList)
      {
         if(this._btnTabCapacities.selected == false)
         {
            _loc3_ = this.api.lang.getMountCapacity(oEvent.row.item.data).d;
            if(_loc3_ != undefined && _loc3_.length > 0)
            {
               this.gapi.showTooltip(_loc3_);
            }
         }
      }
   }
   function itemRollOut(oEvent)
   {
      this.out();
   }
}
