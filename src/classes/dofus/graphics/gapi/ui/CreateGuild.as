class dofus.graphics.gapi.ui.CreateGuild extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bEnabled;
   var _btnCancel;
   var _btnClose;
   var _btnCreate;
   var _btnTabBack;
   var _btnTabUp;
   var _cgGrid;
   var _cpColors;
   var _eEmblem;
   var _eaBacks;
   var _eaUps;
   var _itName;
   var _lblColors;
   var _lblEmblem;
   var _lblName;
   var _nBackColor;
   var _nBackID;
   var _nUpColor;
   var _nUpID;
   var _winBg;
   var addToQueue;
   var enabled;
   var gapi;
   static var CLASS_NAME = "CreateGuild";
   var _nBackDefaultColor = 14933949;
   var _nUpDefaultColor = 0;
   var _sCurrentTab = "Back";
   static var HEX_CHARS = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
   function CreateGuild()
   {
      super();
   }
   function init()
   {
      this._nBackColor = this._nBackDefaultColor;
      this._nUpColor = this._nUpDefaultColor;
      super.init(false,dofus.graphics.gapi.ui.CreateGuild.CLASS_NAME);
   }
   function callClose()
   {
      if(this._bEnabled)
      {
         this.api.network.Guild.leave();
         return true;
      }
      return false;
   }
   function createChildren()
   {
      this._eaBacks = new ank.utils.ExtendedArray();
      var _loc2_ = 1;
      while(_loc2_ <= dofus.Constants.EMBLEM_BACKS_COUNT)
      {
         this._eaBacks.push({iconFile:dofus.Constants.EMBLEMS_BACK_PATH + _loc2_ + ".swf"});
         _loc2_ = _loc2_ + 1;
      }
      this._eaUps = new ank.utils.ExtendedArray();
      var _loc3_ = 1;
      while(_loc3_ <= dofus.Constants.EMBLEM_UPS_COUNT)
      {
         this._eaUps.push({iconFile:dofus.Constants.EMBLEMS_UP_PATH + _loc3_ + ".swf"});
         _loc3_ = _loc3_ + 1;
      }
      this._nBackID = random(dofus.Constants.EMBLEM_BACKS_COUNT);
      this._nUpID = random(dofus.Constants.EMBLEM_UPS_COUNT);
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.setTextFocus});
      this.addToQueue({object:this,method:this.updateCurrentTabInformations});
      this.addToQueue({object:this,method:this.updateBack});
      this.addToQueue({object:this,method:this.updateUp});
   }
   function initTexts()
   {
      this._winBg.title = this.api.lang.getText("GUILD_CREATION");
      this._lblName.text = this.api.lang.getText("GUILD_NAME");
      this._lblEmblem.text = this.api.lang.getText("EMBLEM");
      this._lblColors.text = this.api.lang.getText("CREATE_COLOR");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      this._btnCreate.label = this.api.lang.getText("CREATE");
      this._btnTabBack.label = this.api.lang.getText("EMBLEM_BACK");
      this._btnTabUp.label = this.api.lang.getText("EMBLEM_UP");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnCreate.addEventListener("click",this);
      this._btnTabBack.addEventListener("click",this);
      this._btnTabUp.addEventListener("click",this);
      this._cpColors.addEventListener("change",this);
      this._cgGrid.addEventListener("selectItem",this);
      this._cgGrid.multipleContainerSelectionEnabled = false;
   }
   function setTextFocus()
   {
      this._itName.setFocus();
   }
   function updateCurrentTabInformations()
   {
      switch(this._sCurrentTab)
      {
         case "Back":
            this._cpColors.setColor(this._nBackColor);
            this._cgGrid.dataProvider = this._eaBacks;
            this._cgGrid.selectedIndex = this._nBackID - 1;
            break;
         case "Up":
            this._cpColors.setColor(this._nUpColor);
            this._cgGrid.dataProvider = this._eaUps;
            this._cgGrid.selectedIndex = this._nUpID - 1;
         default:
            return;
      }
   }
   function setCurrentTab(sNewTab)
   {
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this.updateCurrentTabInformations();
   }
   function updateBack()
   {
      this._eEmblem.backID = this._nBackID;
      this._eEmblem.backColor = this._nBackColor;
   }
   function updateUp()
   {
      this._eEmblem.upID = this._nUpID;
      this._eEmblem.upColor = this._nUpColor;
   }
   function setEnabled(bEnabled)
   {
      this._btnCancel.enabled = this._bEnabled;
      this._btnClose.enabled = this._bEnabled;
      this._btnCreate.enabled = this._bEnabled;
   }
   static function d2h(d)
   {
      if(d > 255)
      {
         d = 255;
      }
      return dofus.graphics.gapi.ui.CreateGuild.HEX_CHARS[Math.floor(d / 16)] + dofus.graphics.gapi.ui.CreateGuild.HEX_CHARS[d % 16];
   }
   function displayColorCode()
   {
      var _loc2_ = this._sCurrentTab != "Back" ? this._nUpColor : this._nBackColor;
      var _loc3_ = (_loc2_ & 0xFF0000) >> 16;
      var _loc4_ = (_loc2_ & 0xFF00) >> 8;
      var _loc5_ = _loc2_ & 0xFF;
      var _loc6_ = dofus.graphics.gapi.ui.CreateGuild.d2h(_loc3_) + dofus.graphics.gapi.ui.CreateGuild.d2h(_loc4_) + dofus.graphics.gapi.ui.CreateGuild.d2h(_loc5_);
      if(_loc2_ == undefined || _loc2_ == -1)
      {
         _loc6_ = "";
      }
      var _loc7_ = this.gapi.loadUIComponent("PopupHexa","PopupHexa",{value:_loc6_,params:{targetType:"colorCode"}});
      _loc7_.addEventListener("validate",this);
   }
   function resetColor()
   {
      if(this._sCurrentTab == "Back")
      {
         this._nBackColor = this._nBackDefaultColor;
         this._cpColors.setColor(this._nBackDefaultColor);
      }
      else
      {
         this._nUpColor = this._nUpDefaultColor;
         this._cpColors.setColor(this._nBackDefaultColor);
      }
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      switch(oEvent.target._name)
      {
         case "_btnClose":
         case "_btnCancel":
            this.api.network.Guild.leave();
            break;
         case "_btnCreate":
            _loc3_ = this._itName.text;
            if(_loc3_ == undefined || _loc3_.length < 3)
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("BAD_GUILD_NAME"),"ERROR_BOX");
               return undefined;
            }
            if(this._nBackID == undefined || this._nUpID == undefined)
            {
               return undefined;
            }
            if(this.api.lang.getConfigText("GUILD_NAME_FILTER"))
            {
               _loc4_ = new dofus.utils.nameChecker.NameChecker(_loc3_);
               _loc5_ = new dofus.utils.nameChecker.rules.NameCheckerGuildNameRules();
               _loc6_ = _loc4_.isValidAgainstWithDetails(_loc5_);
               if(!_loc6_.IS_SUCCESS)
               {
                  this.api.kernel.showMessage(undefined,this.api.lang.getText("INVALID_GUILD_NAME") + "\r\n" + _loc6_.toString("\r\n"),"ERROR_BOX");
                  return undefined;
               }
            }
            this.enabled = false;
            this.api.network.Guild.create(this._nBackID,this._nBackColor,this._nUpID,this._nUpColor,_loc3_);
            break;
         case "_btnTabBack":
            this.setCurrentTab("Back");
            break;
         case "_btnTabUp":
            this.setCurrentTab("Up");
         default:
            return;
      }
   }
   function change(oEvent)
   {
      switch(this._sCurrentTab)
      {
         case "Back":
            if(Key.isDown(Key.SHIFT))
            {
               this.displayColorCode();
            }
            else if(Key.isDown(Key.CONTROL))
            {
               this.resetColor();
            }
            else
            {
               this._nBackColor = oEvent.value;
            }
            this.updateBack();
            break;
         case "Up":
            if(Key.isDown(Key.SHIFT))
            {
               this.displayColorCode();
            }
            else if(Key.isDown(Key.CONTROL))
            {
               this.resetColor();
            }
            else
            {
               this._nUpColor = oEvent.value;
            }
            this.updateUp();
         default:
            return;
      }
   }
   function selectItem(oEvent)
   {
      switch(this._sCurrentTab)
      {
         case "Back":
            if(oEvent.owner.selectedIndex == undefined)
            {
               return undefined;
            }
            this._nBackID = oEvent.owner.selectedIndex + 1;
            this.updateBack();
            break;
         case "Up":
            if(oEvent.owner.selectedIndex == undefined)
            {
               return undefined;
            }
            this._nUpID = oEvent.owner.selectedIndex + 1;
            this.updateUp();
         default:
            return;
      }
   }
   function validate(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.params.targetType) === "colorCode")
      {
         if(!(_global.isNaN(oEvent.value) || (oEvent.value > 16777215 || oEvent.value == undefined)))
         {
            if(this._sCurrentTab == "Back")
            {
               this._nBackColor = oEvent.value;
               this.updateBack();
            }
            else
            {
               this._nUpColor = oEvent.value;
               this.updateUp();
            }
            this._cpColors.setColor(oEvent.value);
         }
      }
   }
}
