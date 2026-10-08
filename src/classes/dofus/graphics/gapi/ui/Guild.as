class dofus.graphics.gapi.ui.Guild extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _btnClose;
   var _btnEdit;
   var _btnSave;
   var _btnTabBoosts;
   var _btnTabGuildHouses;
   var _btnTabInformations;
   var _btnTabMembers;
   var _btnTabMountParks;
   var _btnTabTaxCollectors;
   var _eEmblem;
   var _lblLastModified;
   var _lblLevel;
   var _lblValid;
   var _mcCaution;
   var _mcEditMode;
   var _mcPlacer;
   var _mcTabViewer;
   var _pbXP;
   var _taGuildNote;
   var _winBg;
   var _y;
   var addToQueue;
   var attachMovie;
   var gapi;
   var getNextHighestDepth;
   var unloadThis;
   static var CLASS_NAME = "Guild";
   var _sCurrentTab = "Members";
   function Guild()
   {
      super();
   }
   function set currentTab(sTab)
   {
      this._sCurrentTab = sTab;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Guild.CLASS_NAME);
   }
   function destroy()
   {
      this.gapi.unloadUIComponent("GuildMemberInfos");
      this.gapi.hideTooltip();
      this.api.datacenter.Player.guildInfos.removeEventListener("modelChanged",this);
      this.api.datacenter.Player.guildInfos.removeEventListener("rightsChanged",this);
      this.checkIfLocalPlayerIsDefender();
      if(this._sCurrentTab == "TaxCollectors")
      {
         this.api.network.Guild.leaveTaxInterface();
      }
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
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this.api.network.Guild,method:this.api.network.Guild.getInfosGeneral});
      this.addToQueue({object:this,method:this.setCurrentTab,params:[this._sCurrentTab]});
      this._mcPlacer._visible = false;
      this._mcCaution._visible = this._lblValid._visible = false;
   }
   function initTexts()
   {
      this._btnTabMembers.label = this.api.lang.getText("GUILD_MEMBERS");
      this._btnTabInformations.label = this.api.lang.getText("INFORMATIONS");
      this._btnTabBoosts.label = this.api.lang.getText("GUILD_BOOSTS");
      this._btnTabTaxCollectors.label = this.api.lang.getText("GUILD_TAXCOLLECTORS");
      this._btnTabMountParks.label = this.api.lang.getText("MOUNT_PARK");
      this._btnTabGuildHouses.label = this.api.lang.getText("HOUSES_WORD");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnTabMembers.addEventListener("click",this);
      this._btnTabInformations.addEventListener("click",this);
      this._btnTabBoosts.addEventListener("click",this);
      this._btnTabTaxCollectors.addEventListener("click",this);
      this._btnTabMountParks.addEventListener("click",this);
      this._btnTabGuildHouses.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnSave.addEventListener("click",this);
      this._btnEdit.addEventListener("click",this);
      this.api.datacenter.Player.guildInfos.addEventListener("modelChanged",this);
      this.api.datacenter.Player.guildInfos.addEventListener("rightsChanged",this);
      this._pbXP.addEventListener("over",this);
      this._pbXP.addEventListener("out",this);
      this.toggleInfosEditor(false);
      this._btnEdit.enabled = this.api.datacenter.Player.guildInfos.playerRights.canEditGuildNotes || this.api.datacenter.Player.guildInfos.playerRights.isBoss;
   }
   function initData()
   {
      var _loc2_ = this.api.datacenter.Player.guildInfos;
      var _loc3_ = _loc2_.emblem;
      this._eEmblem.backID = _loc3_.backID;
      this._eEmblem.backColor = _loc3_.backColor;
      this._eEmblem.upID = _loc3_.upID;
      this._eEmblem.upColor = _loc3_.upColor;
      this._winBg.title = this.api.lang.getText("GUILD") + " \'" + _loc2_.name + "\'";
      this._taGuildNote.restrict = dofus.Constants.CHAT_ALLOWED_CHARACTERS;
   }
   function updateCurrentTabInformations()
   {
      this._mcTabViewer.removeMovieClip();
      switch(this._sCurrentTab)
      {
         case "Members":
            this.attachMovie("GuildMembersViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.datacenter.Player.guildInfos.members.removeAll();
            this.api.network.Guild.getInfosMembers();
            break;
         case "Informations":
            this.attachMovie("GuildInformationsViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.network.Guild.getInformationsGuild();
            break;
         case "Boosts":
            this.attachMovie("GuildBoostsViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.network.Guild.getInfosBoosts();
            break;
         case "TaxCollectors":
            this.attachMovie("TaxCollectorsViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.datacenter.Player.guildInfos.taxCollectors.removeAll();
            this.api.network.Guild.getInfosTaxCollector();
            break;
         case "MountParks":
            this.attachMovie("GuildMountParkViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.network.Guild.getInfosMountPark();
            break;
         case "GuildHouses":
            this.attachMovie("GuildHousesViewer","_mcTabViewer",this.getNextHighestDepth(),{_x:this._mcPlacer._x,_y:this._mcPlacer._y});
            this.api.network.Guild.getInfosGuildHouses();
         default:
            return;
      }
   }
   function setCurrentTab(sNewTab)
   {
      if(this._sCurrentTab == "TaxCollectors")
      {
         this.api.network.Guild.leaveTaxInterface();
      }
      var _loc3_ = this["_btnTab" + this._sCurrentTab];
      var _loc4_ = this["_btnTab" + sNewTab];
      _loc3_.selected = true;
      _loc3_.enabled = true;
      _loc4_.selected = false;
      _loc4_.enabled = false;
      this._sCurrentTab = sNewTab;
      this.updateCurrentTabInformations();
   }
   function checkIfLocalPlayerIsDefender()
   {
      var _loc2_ = this.api.datacenter.Player.guildInfos;
      if(_loc2_.isLocalPlayerDefender)
      {
         this.api.network.Guild.leaveTaxCollector(_loc2_.defendedTaxCollectorID);
         this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("AUTO_DISJOIN_TAX"),"ERROR_BOX");
      }
   }
   function toggleInfosEditor(bEnabled)
   {
      this._taGuildNote.editable = bEnabled;
      this._taGuildNote.html = !bEnabled;
      this._btnCancel._visible = bEnabled;
      this._btnSave._visible = bEnabled;
      this._mcEditMode._visible = bEnabled;
      this._btnEdit._visible = !bEnabled;
      if(bEnabled)
      {
         this._taGuildNote.setFocus(false);
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnClose:
            this.callClose();
            break;
         case this._btnTabMembers:
            this.setCurrentTab("Members");
            break;
         case this._btnTabInformations:
            this.setCurrentTab("Informations");
            break;
         case this._btnTabBoosts:
            if(this.api.datacenter.Player.guildInfos.isValid)
            {
               this.setCurrentTab("Boosts");
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_BOX");
               oEvent.target.selected = true;
            }
            break;
         case this._btnTabTaxCollectors:
            if(this.api.datacenter.Player.guildInfos.isValid)
            {
               this.setCurrentTab("TaxCollectors");
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_BOX");
               oEvent.target.selected = true;
            }
            break;
         case this._btnTabMountParks:
            if(this.api.datacenter.Player.guildInfos.isValid)
            {
               this.setCurrentTab("MountParks");
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_BOX");
               oEvent.target.selected = true;
            }
            break;
         case this._btnTabGuildHouses:
            if(this.api.datacenter.Player.guildInfos.isValid)
            {
               this.setCurrentTab("GuildHouses");
            }
            else
            {
               this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_BOX");
               oEvent.target.selected = true;
            }
            break;
         case this._btnEdit:
            this.toggleInfosEditor(true);
            break;
         case this._btnCancel:
            this.toggleInfosEditor(false);
            break;
         case this._btnSave:
            this.toggleInfosEditor(false);
            this.api.network.Guild.editNote(this._taGuildNote.text);
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._pbXP)
      {
         this.gapi.showTooltip(new ank.utils.ExtendedString(this._pbXP.value).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3) + " / " + new ank.utils.ExtendedString(this._pbXP.maximum).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function modelChanged(oEvent)
   {
      var _loc3_;
      var _loc0_;
      var _loc4_;
      switch(oEvent.eventName)
      {
         case "infosUpdate":
            this.initData();
            break;
         case "general":
            _loc3_ = this.api.datacenter.Player.guildInfos;
            this._lblLevel.text = this.api.lang.getText("LEVEL") + " " + _loc3_.level;
            this._pbXP.minimum = _loc3_.xpmin;
            this._pbXP.maximum = _loc3_.level != 200 ? _loc3_.xpmax : -1;
            this._pbXP.value = _loc3_.xp;
            if(_loc3_.isValid)
            {
               this._y = 0;
               var _temp_2 = this._mcCaution;
               var _temp_1 = "_visible";
               this._lblValid._visible = _loc0_ = false;
               _temp_2[_temp_1] = _loc0_;
            }
            else
            {
               this._y = -20;
               var _temp_4 = this._mcCaution;
               var _temp_3 = "_visible";
               this._lblValid._visible = _loc0_ = true;
               _temp_4[_temp_3] = _loc0_;
               this._lblValid.text = this.api.lang.getText("GUILD_INVALID_INFOS");
            }
            break;
         case "rank":
         case "members":
            if(this._sCurrentTab == "Members")
            {
               this._mcTabViewer.members = this.api.datacenter.Player.guildInfos.members;
            }
            break;
         case "boosts":
            if(this._sCurrentTab == "Boosts")
            {
               this._mcTabViewer.updateData();
            }
            break;
         case "taxcollectors":
            if(this._sCurrentTab == "TaxCollectors")
            {
               this._mcTabViewer.taxCollectors = this.api.datacenter.Player.guildInfos.taxCollectors;
            }
            break;
         case "noboosts":
         case "notaxcollectors":
            this.api.kernel.showMessage(undefined,this.api.lang.getText("NOT_ENOUGHT_MEMBERS_IN_GUILD"),"ERROR_BOX");
            this.setCurrentTab("Members");
            break;
         case "mountParks":
            if(this._sCurrentTab == "MountParks")
            {
               this._mcTabViewer.mountParks = this.api.datacenter.Player.guildInfos.mountParks;
            }
            break;
         case "houses":
            if(this._sCurrentTab == "GuildHouses")
            {
               this._mcTabViewer.houses = this.api.datacenter.Player.guildInfos.houses;
            }
            break;
         case "note":
            _loc4_ = this.api.datacenter.Player.guildInfos;
            this._taGuildNote.text = _loc4_.note;
            this._lblLastModified.text = this.api.lang.getText("MESSAGE_EDITED",[_loc4_.noteFormatedLastModification,_loc4_.noteMember]);
            this._lblLastModified._visible = _loc4_.noteMember != "";
            break;
         case "informations":
            if(this._sCurrentTab == "Informations")
            {
               this._mcTabViewer.updateData();
            }
         default:
            return;
      }
   }
   function rightsChanged(oEvent)
   {
      this._btnEdit.enabled = this.api.datacenter.Player.guildInfos.playerRights.canEditGuildNotes || this.api.datacenter.Player.guildInfos.playerRights.isBoss;
   }
}
