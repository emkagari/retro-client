class dofus.graphics.gapi.ui.customset.CustomSet extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnEdit;
   var _btnPreview;
   var _btnSave;
   var _cgCustomSets;
   var _ctr8;
   var _ctr16;
   var _ctrJob1;
   var _ctrJob2;
   var _ctrMount;
   var _ctrPet;
   var _ctrSpe0;
   var _ctrSpe1;
   var _eaDatas;
   var _lblAP;
   var _lblAgility;
   var _lblAgilityValue;
   var _lblChance;
   var _lblChanceValue;
   var _lblCustomSet;
   var _lblForce;
   var _lblForceValue;
   var _lblIntelligence;
   var _lblIntelligenceValue;
   var _lblLP;
   var _lblLPValue;
   var _lblMP;
   var _lblVitality;
   var _lblVitalityValue;
   var _lblWisdom;
   var _lblWisdomValue;
   var _mcAboutModulatedLevel;
   var _mcCharacter;
   var _mcMountCross;
   var _mcOverEnergy;
   var _mcPetCross;
   var _mcPreview;
   var _oSelectedRapidStuff;
   var addToQueue;
   var api;
   var gapi;
   static var CLASS_NAME = "CustomSet";
   static var MAX_CONTAINER = 10;
   static var MAX_CONTAINER_PREVIEW = 16;
   function CustomSet()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.customset.CustomSet.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.hideTooltip();
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.initData});
      this.showPreview(false);
      this._ctrMount = this._ctr16;
      this._ctrPet = this._ctr8;
   }
   function addListeners()
   {
      this._btnSave.addEventListener("over",this);
      this._btnSave.addEventListener("out",this);
      this._btnSave.addEventListener("click",this);
      this._btnPreview.addEventListener("over",this);
      this._btnPreview.addEventListener("out",this);
      this._btnPreview.addEventListener("click",this);
      this._btnEdit.addEventListener("over",this);
      this._btnEdit.addEventListener("out",this);
      this._btnEdit.addEventListener("click",this);
      this.api.datacenter.Player.data.addListener(this);
      this.api.datacenter.Player.addEventListener("lpChanged",this);
      this.api.datacenter.Player.addEventListener("lpMaxChanged",this);
      this.api.datacenter.Player.addEventListener("apChanged",this);
      this.api.datacenter.Player.addEventListener("mpChanged",this);
      this.api.datacenter.Player.addEventListener("initiativeChanged",this);
      this.api.datacenter.Player.addEventListener("discernmentChanged",this);
      this.api.datacenter.Player.addEventListener("forceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("vitalityXtraChanged",this);
      this.api.datacenter.Player.addEventListener("wisdomXtraChanged",this);
      this.api.datacenter.Player.addEventListener("chanceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("agilityXtraChanged",this);
      this.api.datacenter.Player.addEventListener("intelligenceXtraChanged",this);
      this.api.datacenter.Player.addEventListener("rapidStuffPut",this);
      this._lblLP.addEventListener("over",this);
      this._lblLP.addEventListener("out",this);
      this._lblLP.enableOverEvents = true;
      this._lblAP.addEventListener("over",this);
      this._lblAP.addEventListener("out",this);
      this._lblAP.enableOverEvents = true;
      this._lblMP.addEventListener("over",this);
      this._lblMP.addEventListener("out",this);
      this._lblMP.enableOverEvents = true;
      this._ctrJob1.addEventListener("over",this);
      this._ctrJob1.addEventListener("out",this);
      this._ctrJob1.enableOverEvents = true;
      this._lblVitality.addEventListener("over",this);
      this._lblVitality.addEventListener("out",this);
      this._lblVitality.enableOverEvents = true;
      this._ctrSpe0.addEventListener("over",this);
      this._ctrSpe0.addEventListener("out",this);
      this._ctrSpe0.enableOverEvents = true;
      this._mcAboutModulatedLevel.addEventListener("over",this);
      this._mcAboutModulatedLevel.addEventListener("out",this);
      this._mcAboutModulatedLevel.enableOverEvents = true;
      this._lblForce.addEventListener("over",this);
      this._lblForce.addEventListener("out",this);
      this._lblForce.enableOverEvents = true;
      this._lblIntelligence.addEventListener("over",this);
      this._lblIntelligence.addEventListener("out",this);
      this._lblIntelligence.enableOverEvents = true;
      this._lblChance.addEventListener("over",this);
      this._lblChance.addEventListener("out",this);
      this._lblChance.enableOverEvents = true;
      this._lblAgility.addEventListener("over",this);
      this._lblAgility.addEventListener("out",this);
      this._lblAgility.enableOverEvents = true;
      this._cgCustomSets.addEventListener("dropItem",this);
      this._cgCustomSets.addEventListener("dragItem",this);
      this._cgCustomSets.addEventListener("selectItem",this);
      this._cgCustomSets.addEventListener("overItem",this);
      this._cgCustomSets.addEventListener("outItem",this);
      this._cgCustomSets.addEventListener("dblClickItem",this);
      this._cgCustomSets.multipleContainerSelectionEnabled = false;
      var _loc2_;
      var _loc3_;
      var _loc4_;
      for(var a in dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE)
      {
         _loc2_ = dofus.graphics.gapi.ui.Inventory.CONTAINER_BY_TYPE[a];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = this[_loc2_[_loc3_]];
            _loc4_.addEventListener("over",this);
            _loc4_.addEventListener("out",this);
            if(_loc4_.toolTipText == undefined)
            {
               _loc4_.toolTipText = this.api.lang.getText(_loc4_ != this._ctrMount ? "INVENTORY_" + a.toUpperCase() : "MOUNT");
            }
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function initTexts()
   {
      this._lblLP.text = this.api.lang.getText("LP");
      this._lblAP.text = this.api.lang.getText("AP");
      this._lblMP.text = this.api.lang.getText("MP");
      this._ctrJob1.text = this.api.lang.getText("INITIATIVE");
      this._lblVitality.text = this.api.lang.getText("DISCERNMENT");
      this._lblForce.text = this.api.lang.getText("FORCE");
      this._ctrSpe0.text = this.api.lang.getText("VITALITY");
      this._mcAboutModulatedLevel.text = this.api.lang.getText("WISDOM");
      this._lblChance.text = this.api.lang.getText("CHANCE");
      this._lblAgility.text = this.api.lang.getText("AGILITY");
      this._lblIntelligence.text = this.api.lang.getText("INTEL");
      this._lblCustomSet.text = this.api.lang.getText("CUSTOM_SET_CHOOSE_SET");
   }
   function initData()
   {
      this._btnPreview.enabled = false;
      this._btnSave.enabled = false;
      this._btnEdit.enabled = false;
      var _loc2_ = this.api.datacenter.Player;
      this._eaDatas = new ank.utils.ExtendedArray();
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ < dofus.datacenter.LocalPlayer.MAX_RAPID_STUFFS_COUNT)
      {
         _loc4_ = _loc2_.getRapidStuff(_loc3_);
         this._eaDatas.push(_loc4_);
         _loc3_ = _loc3_ + 1;
      }
      this._cgCustomSets.dataProvider = this._eaDatas;
      this.lpChanged({value:_loc2_.LP});
      this.lpMaxChanged({value:_loc2_.LPmax});
      this.apChanged({value:_loc2_.AP});
      this.mpChanged({value:_loc2_.MP});
      this.initiativeChanged({value:_loc2_.Initiative});
      this.discernmentChanged({value:_loc2_.Discernment});
      this.forceXtraChanged({value:_loc2_.ForceXtra});
      this.vitalityXtraChanged({value:_loc2_.VitalityXtra});
      this.wisdomXtraChanged({value:_loc2_.WisdomXtra});
      this.chanceXtraChanged({value:_loc2_.ChanceXtra});
      this.agilityXtraChanged({value:_loc2_.AgilityXtra});
      this.intelligenceXtraChanged({value:_loc2_.IntelligenceXtra});
   }
   function askLoadSet(oRapidStuff, bPopup)
   {
      if(this._oSelectedRapidStuff == undefined || oRapidStuff.isEmptyRapidStuff)
      {
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_INVALID_LOAD"),"ERROR_CHAT");
         return undefined;
      }
      var _loc4_;
      if(bPopup)
      {
         _loc4_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoLoad",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CUSTOM_SET_CONFIRM_LOAD")});
         _loc4_.addEventListener("yes",this);
      }
      else
      {
         this.api.network.RapidStuff.loadRapidStuff(this._oSelectedRapidStuff.id);
         this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_LOADED",[this._oSelectedRapidStuff.name]),"INFO_CHAT");
      }
   }
   function showPreview(bShow_)
   {
      this._mcPreview._visible = bShow_;
      this._mcCharacter._visible = bShow_;
      this._lblLP._visible = this._lblAP._visible = this._lblMP._visible = this._ctrJob1._visible = this._lblVitality._visible = this._ctrSpe0._visible = this._mcAboutModulatedLevel._visible = this._lblForce._visible = this._lblIntelligence._visible = this._lblChance._visible = this._lblAgility._visible = !bShow_;
      this.addToQueue({object:this,method:this.resetPreviewContainer,params:[bShow_]});
      if(bShow_)
      {
         this.addToQueue({object:this,method:this.setPreviewContainer});
      }
   }
   function resetPreviewContainer(bShow_)
   {
      var _loc3_ = 0;
      var _loc4_;
      while(_loc3_ <= dofus.graphics.gapi.ui.customset.CustomSet.MAX_CONTAINER_PREVIEW)
      {
         _loc4_ = this["_ctr" + _loc3_];
         _loc4_._visible = bShow_;
         _loc4_.contentData = undefined;
         _loc3_ = _loc3_ + 1;
      }
      this._mcPetCross._visible = false;
      this._mcMountCross._visible = false;
   }
   function setPreviewContainer()
   {
      var _loc2_ = this._oSelectedRapidStuff.items;
      var _loc3_ = 0;
      var _loc4_;
      var _loc5_;
      while(_loc3_ <= dofus.graphics.gapi.ui.customset.CustomSet.MAX_CONTAINER_PREVIEW)
      {
         _loc4_ = _loc2_[_loc3_];
         if(_loc4_ != undefined)
         {
            _loc5_ = this["_ctr" + _loc4_.position];
            _loc5_.contentData = _loc4_;
            if(_loc5_ == this._ctrPet)
            {
               this._mcMountCross._visible = true;
            }
         }
         _loc3_ = _loc3_ + 1;
      }
      if(this._oSelectedRapidStuff.ride)
      {
         this._ctrMount.contentPath = "UI_InventoryMountIcon";
         this._mcPetCross._visible = true;
      }
   }
   function lpChanged(oEvent)
   {
      this._lblLPValue.text = this.api.datacenter.Player.LP + "/" + this.api.datacenter.Player.LPmax;
   }
   function lpMaxChanged(oEvent)
   {
      this._lblLPValue.text = this.api.datacenter.Player.LP + "/" + this.api.datacenter.Player.LPmax;
   }
   function apChanged(oEvent)
   {
      this._ctrSpe1.text = String(Math.max(0,oEvent.value));
   }
   function mpChanged(oEvent)
   {
      this._mcOverEnergy.text = String(Math.max(0,oEvent.value));
   }
   function initiativeChanged(oEvent)
   {
      this._lblWisdom.text = String(oEvent.value);
   }
   function discernmentChanged(oEvent)
   {
      this._ctrJob2.text = String(oEvent.value);
   }
   function forceXtraChanged(oEvent)
   {
      this._lblForceValue.text = this.api.datacenter.Player.Force + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function vitalityXtraChanged(oEvent)
   {
      this._lblVitalityValue.text = this.api.datacenter.Player.Vitality + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function wisdomXtraChanged(oEvent)
   {
      this._lblWisdomValue.text = this.api.datacenter.Player.Wisdom + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function chanceXtraChanged(oEvent)
   {
      this._lblChanceValue.text = this.api.datacenter.Player.Chance + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function agilityXtraChanged(oEvent)
   {
      this._lblAgilityValue.text = this.api.datacenter.Player.Agility + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function intelligenceXtraChanged(oEvent)
   {
      this._lblIntelligenceValue.text = this.api.datacenter.Player.Intelligence + (oEvent.value == 0 ? "" : (oEvent.value <= 0 ? " (" : " (+") + String(oEvent.value) + ")");
   }
   function rapidStuffPut(oEvent)
   {
      var _loc3_ = oEvent.value;
      if(_loc3_ == undefined)
      {
         return undefined;
      }
      this._eaDatas.updateItem(_loc3_.id,_loc3_);
      if(this._oSelectedRapidStuff != undefined && this._oSelectedRapidStuff.id == _loc3_.id)
      {
         this.onSelectedRapidStuff(_loc3_);
      }
   }
   function unSelectAll()
   {
      this._cgCustomSets.unSelectAll();
      this._btnPreview.enabled = false;
      this._btnSave.enabled = false;
      this._btnEdit.enabled = false;
   }
   function dragItem(oEvent_)
   {
      if(oEvent_.target.contentData == undefined || oEvent_.target.contentData.isEmptyRapidStuff)
      {
         return undefined;
      }
      this.gapi.removeCursor();
      if(!this.api.datacenter.Player.checkCanMoveItem())
      {
         return undefined;
      }
      this.gapi.setCursor(oEvent_.target.contentData);
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnSave:
            if(this._oSelectedRapidStuff == undefined)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_INVALID_SAVE"),"ERROR_CHAT");
               return undefined;
            }
            _loc3_ = this.gapi.loadUIComponent("AskYesNo","AskYesNoSave",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("CONFIRM_CUSTOM_SET",[this._oSelectedRapidStuff.name])});
            _loc3_.addEventListener("yes",this);
            return;
            break;
         case this._btnPreview:
            this.showPreview(this._btnPreview.selected);
            return;
         case this._btnEdit:
            if(this._oSelectedRapidStuff == undefined)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_INVALID_EDIT"),"ERROR_CHAT");
               return undefined;
            }
            _loc4_ = this.api.ui.loadUIComponent("CustomSetEdit","CustomSetEdit",{rapidStuff:this._oSelectedRapidStuff});
            return;
            break;
         default:
            this.selectItem(oEvent);
            return;
      }
   }
   function selectItem(oEvent)
   {
      var _loc3_;
      var _loc4_;
      if(oEvent.target.contentData instanceof dofus.datacenter.RapidStuff)
      {
         this.unSelectAll();
         oEvent.target.selected = true;
         _loc3_ = oEvent.target;
         _loc4_ = dofus.datacenter.RapidStuff(_loc3_.contentData);
         this.onSelectedRapidStuff(_loc4_);
      }
      else
      {
         this.api.ui.getUIComponent("Inventory").selectItem(oEvent);
      }
   }
   function onSelectedRapidStuff(oRapidStuff)
   {
      if(oRapidStuff != undefined)
      {
         this._btnSave.enabled = !oRapidStuff.isEmptyRapidStuff;
         this._btnPreview.selected = this._btnPreview.selected && !oRapidStuff.isEmptyRapidStuff;
         this._btnPreview.enabled = !oRapidStuff.isEmptyRapidStuff;
         this._lblCustomSet.text = oRapidStuff.name.length <= 0 ? this.api.lang.getText("CUSTOM_SET_EMPTY_SLOT") : oRapidStuff.name;
      }
      else
      {
         this._btnSave.enabled = false;
         this._btnPreview.selected = false;
         this._btnPreview.enabled = false;
         this._lblCustomSet.text = this.api.lang.getText("CUSTOM_SET_EMPTY_SLOT");
      }
      this.showPreview(this._btnPreview.selected);
      this._oSelectedRapidStuff = oRapidStuff;
      this._btnEdit.enabled = true;
   }
   function overItem(oEvent)
   {
      var _loc3_ = oEvent.target.contentData;
      if(_loc3_ != undefined && !_loc3_.isEmptyRapidStuff)
      {
         this.gapi.showTooltip(this.api.lang.getText("CUSTOM_SET_EQUIP"));
      }
      else
      {
         this.gapi.showTooltip(this.api.lang.getText("CUSTOM_SET_SELECT_SLOT"));
      }
   }
   function over(oEvent_)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent_.target)
      {
         case this._btnSave:
            this.gapi.showTooltip(this.api.lang.getText("CUSTOM_SET_SAVE_BTN"));
            return;
         case this._btnPreview:
            this.gapi.showTooltip(this.api.lang.getText("CHARACTER_PREVIEW",[this._lblCustomSet.text]));
            return;
         case this._btnEdit:
            this.gapi.showTooltip(this.api.lang.getText("CUSTOM_SET_EDIT_BTN"));
            return;
         case this._ctrSpe0:
            this.gapi.showTooltip(this.api.lang.getText("HELP_VITALITY"));
            return;
         case this._mcAboutModulatedLevel:
            this.gapi.showTooltip(this.api.lang.getText("HELP_WISDOM"));
            return;
         case this._lblIntelligence:
            this.gapi.showTooltip(this.api.lang.getText("HELP_INTELLIGENCE"));
            return;
         case this._lblForce:
            this.gapi.showTooltip(this.api.lang.getText("HELP_FORCE"));
            return;
         case this._lblChance:
            this.gapi.showTooltip(this.api.lang.getText("HELP_CHANCE"));
            return;
         case this._lblAgility:
            this.gapi.showTooltip(this.api.lang.getText("HELP_AGILITY"));
            return;
         case this._lblLP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_LIFE"));
            return;
         case this._lblAP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_ACTIONPOINTS"));
            return;
         case this._lblMP:
            this.gapi.showTooltip(this.api.lang.getText("HELP_MOVEPOINTS"));
            return;
         case this._ctrJob1:
            this.gapi.showTooltip(this.api.lang.getText("HELP_INITIATIVE"));
            return;
         case this._lblVitality:
            this.gapi.showTooltip(this.api.lang.getText("HELP_DISCERNMENT"));
            return;
         default:
            if(oEvent_.target.contentData != undefined)
            {
               _loc3_ = oEvent_.target;
               _loc4_ = dofus.datacenter.Item(_loc3_.contentData);
               _loc4_.showStatsTooltip(_loc4_.style);
            }
            else
            {
               this.gapi.showTooltip(oEvent_.target.toolTipText);
            }
            return;
      }
   }
   function outItem(oEvent_)
   {
      this.gapi.hideTooltip();
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function yes(oEvent)
   {
      switch(oEvent.target._name)
      {
         case "AskYesNoSave":
            this.api.network.RapidStuff.saveRapidStuff(this._oSelectedRapidStuff.id);
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_SAVED",[this._oSelectedRapidStuff.name]),"INFO_CHAT");
            break;
         case "AskYesNoLoad":
            this.api.network.RapidStuff.loadRapidStuff(this._oSelectedRapidStuff.id);
            this.api.kernel.showMessage(undefined,this.api.lang.getText("CUSTOM_SET_LOADED",[this._oSelectedRapidStuff.name]),"INFO_CHAT");
         default:
            return;
      }
   }
   function dblClickItem(oEvent)
   {
      this.selectItem(oEvent);
      var _loc3_ = oEvent.target.contentData;
      this.askLoadSet(_loc3_,false);
   }
}
