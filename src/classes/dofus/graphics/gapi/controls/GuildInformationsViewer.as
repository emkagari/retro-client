596728509 - 1;
class dofus.graphics.gapi.controls.GuildInformationsViewer extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bEmptyTextField;
   var _btnCancel;
   var _btnEditInformations;
   var _btnSave;
   var _lblDescription;
   var _lblLatestUpdate;
   var _ldrHelp;
   var _mcEditMode;
   var _taConductRules;
   var _taGuildInformations;
   var addToQueue;
   var gapi;
   static var CLASS_NAME = "GuildMembersViewer";
   function GuildInformationsViewer()
   {
      super();
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.controls.GuildInformationsViewer.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.initData});
   }
   function addListeners()
   {
      this._btnEditInformations.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnSave.addEventListener("click",this);
      this._ldrHelp.addEventListener("over",this);
      this._ldrHelp.addEventListener("out",this);
      this.api.datacenter.Player.guildInfos.addEventListener("rightsChanged",this);
   }
   function initTexts()
   {
      this._lblDescription.text = this.api.lang.getText("GUILD_HOUSE_DISPLAY_EMBLEM_FOR_GUILD");
      this._taConductRules.text = this.api.lang.getText("GUILD_CONDUCT_RULES");
      this._btnEditInformations.label = this.api.lang.getText("MODIFY");
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      this._btnSave.label = this.api.lang.getText("SAVE");
   }
   function initData()
   {
      this._btnEditInformations.enabled = this.api.datacenter.Player.guildInfos.playerRights.canEditGuildInformations || this.api.datacenter.Player.guildInfos.playerRights.isBoss;
      this.toggleInfosEditor(false);
      this._taGuildInformations.restrict = dofus.Constants.CHAT_ALLOWED_CHARACTERS;
   }
   function updateData()
   {
      var _loc2_ = this.api.datacenter.Player.guildInfos;
      this.setTextArea(_loc2_.infos);
      this._lblLatestUpdate.text = this.api.lang.getText("MESSAGE_EDITED",[_loc2_.infosFormatedLastModification,_loc2_.infosMember]);
      this._lblLatestUpdate._visible = _loc2_.infosMember != "";
   }
   function setTextArea(sText)
   {
      if(sText.length == 0)
      {
         this._taGuildInformations.text = this.api.lang.getText("GUILD_INFORMATIONS_EMPTY");
         this._bEmptyTextField = true;
      }
      else
      {
         this._taGuildInformations.text = sText;
         this._bEmptyTextField = false;
      }
   }
   function toggleInfosEditor(bEnabled)
   {
      this._taGuildInformations.editable = bEnabled;
      this._taGuildInformations.html = !bEnabled;
      this._btnCancel._visible = bEnabled;
      this._btnSave._visible = bEnabled;
      this._mcEditMode._visible = bEnabled;
      this._btnEditInformations._visible = !bEnabled;
      if(bEnabled)
      {
         if(this._bEmptyTextField)
         {
            this._taGuildInformations.text = "";
         }
         this._taGuildInformations.setFocus(false);
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnEditInformations:
            this.toggleInfosEditor(true);
            break;
         case this._btnCancel:
            this.toggleInfosEditor(false);
            break;
         case this._btnSave:
            this.toggleInfosEditor(false);
            this.api.network.Guild.editInfos(this._taGuildInformations.text);
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._ldrHelp)
      {
         this.gapi.showTooltip(this.api.lang.getText("GUILD_INFORMATIONS_HELP"));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function rightsChanged(oEvent)
   {
      this._btnEditInformations.enabled = this.api.datacenter.Player.guildInfos.playerRights.canEditGuildInformations || this.api.datacenter.Player.guildInfos.playerRights.isBoss;
   }
}
