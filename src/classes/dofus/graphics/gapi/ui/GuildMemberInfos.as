class dofus.graphics.gapi.ui.GuildMemberInfos extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnCancel;
   var _btnClose;
   var _btnEditGradeName;
   var _btnModify;
   var _btnPercentXP;
   var _btnResetAllRanks;
   var _btnResetRank;
   var _cbRanks;
   var _dgRights;
   var _eaRights;
   var _lblPercentXP;
   var _lblPercentXPValue;
   var _lblRank;
   var _lblRankValue;
   var _mcBackground;
   var _mcInteraction;
   var _mcMask;
   var _oMember;
   var _oMemberClone;
   var _oRankNames;
   var _parent;
   var _svCharacterViewer;
   var _winBg;
   var addToQueue;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "GuildMemberInfos";
   static var SIZE = 70;
   function GuildMemberInfos()
   {
      super();
   }
   function set member(oMember)
   {
      this._oMember = oMember;
      this._oMemberClone = {};
      this._oRankNames = {};
      this._oMemberClone.rank = this._oMember.rank;
      this._oMemberClone.percentxp = this._oMember.percentxp;
      this._oMemberClone.rights = new dofus.datacenter.GuildRights(this._oMember.rights.value);
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.GuildMemberInfos.CLASS_NAME);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.initTexts});
      this.addToQueue({object:this,method:this.addListeners});
      this.addToQueue({object:this,method:this.updateData});
      this._cbRanks._visible = false;
      this._btnPercentXP._visible = false;
      this._dgRights.enabled = false;
      this.showRankEditor(false);
   }
   function callClose()
   {
      this.unloadThis();
      return true;
   }
   function initTexts()
   {
      this._btnCancel.label = this.api.lang.getText("CANCEL_SMALL");
      this._btnModify.label = this.api.lang.getText("SAVE");
      this._lblRank.text = this.api.lang.getText("GUILD_RANK");
      this._lblPercentXP.text = this.api.lang.getText("PERCENT_XP_FULL");
   }
   function addListeners()
   {
      this._btnClose.addEventListener("click",this);
      this._btnCancel.addEventListener("click",this);
      this._btnModify.addEventListener("click",this);
      this._btnEditGradeName.addEventListener("click",this);
      this._btnResetRank.addEventListener("click",this);
      this._btnResetAllRanks.addEventListener("click",this);
      this._btnPercentXP.addEventListener("click",this);
      this._cbRanks.addEventListener("itemSelected",this);
      this._mcInteraction.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcInteraction.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this._mcInteraction.onRelease = function()
      {
         this._parent.click({target:this});
      };
      this.api.datacenter.Player.guildInfos.addEventListener("modelChanged",this);
   }
   function updateData()
   {
      this.updateRight();
      this._winBg.title = this._oMember.name + " (" + this.api.lang.getText("LEVEL_SMALL") + " " + this._oMember.level + ")";
      this._lblPercentXPValue.text = this._oMemberClone.percentxp + "%";
      var _loc2_ = this.api.datacenter.Player.guildInfos.playerRights;
      var _loc3_ = this._oMemberClone.rights;
      this._cbRanks.enabled = _loc2_.canManageRanks;
      this._btnPercentXP._visible = _loc2_.canManageXPContribution && !_loc3_.isBoss || (_loc2_.canManageOwnXPContribution && this._oMember.id == this.api.datacenter.Player.ID || this.api.datacenter.Player.guildInfos.playerRights.isBoss);
      this.showRankEditor(this.api.datacenter.Player.guildInfos.playerRights.isBoss);
      var _loc4_ = _loc2_.canManageRights && (!_loc3_.isBoss && this._oMember.id != this.api.datacenter.Player.ID);
      this._eaRights = new ank.utils.ExtendedArray();
      this._eaRights.push({name:"GUILD_RIGHTS_BOOST",hasRight:_loc3_.canManageBoost,canSetRight:_loc4_,rightValue:_loc3_.canManageBoostValue});
      this._eaRights.push({name:"GUILD_RIGHTS_RIGHTS",hasRight:_loc3_.canManageRights,canSetRight:_loc4_,rightValue:_loc3_.canManageRightsValue});
      this._eaRights.push({name:"GUILD_RIGHTS_INVIT",hasRight:_loc3_.canInvite,canSetRight:_loc4_,rightValue:_loc3_.canInviteValue});
      this._eaRights.push({name:"GUILD_RIGHTS_BANN",hasRight:_loc3_.canBann,canSetRight:_loc4_,rightValue:_loc3_.canBannValue});
      this._eaRights.push({name:"GUILD_RIGHTS_PERCENTXP",hasRight:_loc3_.canManageXPContribution,canSetRight:_loc4_,rightValue:_loc3_.canManageXPContributionValue});
      this._eaRights.push({name:"GUILD_RIGHT_MANAGE_OWN_XP",hasRight:_loc3_.canManageOwnXPContribution,canSetRight:_loc4_,rightValue:_loc3_.canManageOwnXPContributionValue});
      this._eaRights.push({name:"GUILD_RIGHTS_RANK",hasRight:_loc3_.canManageRanks,canSetRight:_loc4_,rightValue:_loc3_.canManageRanksValue});
      this._eaRights.push({name:"GUILD_RIGHTS_HIRETAX",hasRight:_loc3_.canHireTaxCollector,canSetRight:_loc4_,rightValue:_loc3_.canHireTaxCollectorValue});
      this._eaRights.push({name:"GUILD_RIGHTS_COLLECT",hasRight:_loc3_.canCollect,canSetRight:_loc4_,rightValue:_loc3_.canCollectValue});
      this._eaRights.push({name:"GUILD_RIGHTS_COLLECT_OWN",hasRight:_loc3_.canCollectOwnTaxCollector,canSetRight:_loc4_,rightValue:_loc3_.canCollectOwnTaxCollectorValue});
      this._eaRights.push({name:"GUILD_RIGHTS_DEFEND_TAX_PRIORITY",hasRight:_loc3_.canPriorityDefendTaxCollector,canSetRight:_loc4_,rightValue:_loc3_.canPriorityDefendTaxCollectorValue});
      this._eaRights.push({name:"GUILD_RIGHTS_MOUNT_PARK_USE",hasRight:_loc3_.canUseMountPark,canSetRight:_loc4_,rightValue:_loc3_.canUseMountParkValue});
      this._eaRights.push({name:"GUILD_RIGHTS_MOUNT_PARK_ARRANGE",hasRight:_loc3_.canArrangeMountPark,canSetRight:_loc4_,rightValue:_loc3_.canArrangeMountParkValue});
      this._eaRights.push({name:"GUILD_RIGHTS_MANAGE_OTHER_MOUNT",hasRight:_loc3_.canManageOtherMount,canSetRight:_loc4_,rightValue:_loc3_.canManageOtherMountValue});
      this._eaRights.push({name:"GUILD_RIGHTS_EDIT_GUILD_NOTES",hasRight:_loc3_.canEditGuildNotes,canSetRight:_loc4_,rightValue:_loc3_.canEditGuildNotesValue});
      this._eaRights.push({name:"GUILD_RIGHTS_EDIT_GUILD_INFOS",hasRight:_loc3_.canEditGuildInformations,canSetRight:_loc4_,rightValue:_loc3_.canEditGuildInformationsValue});
      this._dgRights.dataProvider = this._eaRights;
      var _loc5_ = _loc2_.isBoss || (_loc2_.canManageRights || (_loc2_.canManageRanks || (_loc2_.canManageXPContribution || _loc3_.canManageOwnXPContribution)));
      var _loc6_ = this._oMember.rank != this._oMemberClone.rank || (this._oMember.percentxp != this._oMemberClone.percentxp || (this._oMember.rights.value != this._oMemberClone.rights.value || this.rankNamesHasChanged()));
      this._btnModify.enabled = _loc5_ && _loc6_;
      this.updateRank();
      if(this._svCharacterViewer.spriteData == undefined)
      {
         this.initializeSprite();
      }
   }
   function updateRank()
   {
      var _loc2_ = this.api.datacenter.Player.guildInfos.playerRights;
      var _loc3_ = this._oMemberClone.rights;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      if(_loc2_.canManageRanks && !_loc3_.isBoss || this.api.datacenter.Player.guildInfos.playerRights.isBoss)
      {
         this._cbRanks._visible = true;
         _loc4_ = this.api.lang.getRanks().slice();
         _loc5_ = new ank.utils.ExtendedArray();
         _loc4_.sortOn("o",Array.NUMERIC);
         if(this.api.datacenter.Player.guildInfos.playerRights.isBoss)
         {
            _loc6_ = 1;
            _loc7_ = this.getRankName(_loc6_);
            _loc5_.push({label:_loc7_,id:_loc6_,icon:"GuildMemberCrown"});
            if(this._oMemberClone.rank == _loc6_)
            {
               this._cbRanks.selectedIndex = 0;
            }
         }
         _loc8_ = 1;
         while(_loc8_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc8_].i;
            _loc10_ = this.getRankName(_loc9_);
            _loc5_.push({label:_loc10_,id:_loc9_});
            if(this._oMemberClone.rank == _loc9_)
            {
               this._cbRanks.selectedIndex = _loc5_.length - 1;
            }
            _loc8_ = _loc8_ + 1;
         }
         this._cbRanks.dataProvider = _loc5_;
      }
      else
      {
         this._lblRankValue.text = this.api.datacenter.Player.guildInfos.getRankName(this._oMemberClone.rank);
      }
   }
   function updateRight()
   {
      var _loc2_ = 0;
      while(_loc2_ < this._eaRights.length)
      {
         if(this._eaRights[_loc2_].needsUpdate)
         {
            !this._eaRights[_loc2_].hasRight ? (this._oMemberClone.rights.value ^= this._eaRights[_loc2_].rightValue) : (this._oMemberClone.rights.value |= this._eaRights[_loc2_].rightValue);
         }
         _loc2_ = _loc2_ + 1;
      }
   }
   function setRank(nRank)
   {
      this._oMemberClone.rank = nRank;
      this._oMemberClone.rankOrder = this.api.lang.getRankInfos(nRank).o;
      this.updateData();
   }
   function rankNamesHasChanged()
   {
      return this.getRankChangesPacket().length > 0;
   }
   function setBoss()
   {
      this.api.kernel.showMessage(undefined,this.api.lang.getText("DO_U_GIVERIGHTS",[this._oMember.name]),"CAUTION_YESNO",{name:"GuildSetBoss",listener:this});
   }
   function showRankEditor(bEnabled)
   {
      this._btnEditGradeName._visible = bEnabled;
      this._btnResetRank._visible = bEnabled;
      this._btnResetAllRanks._visible = bEnabled;
   }
   function initializeSprite()
   {
      var _loc2_ = new ank.battlefield.datacenter.Sprite("viewer",ank.battlefield.mc.Sprite,dofus.Constants.CLIPS_PERSOS_PATH + this._oMember.gfx + ".swf",undefined,5);
      _loc2_.color1 = this._oMember.color1;
      _loc2_.color2 = this._oMember.color2;
      _loc2_.color3 = this._oMember.color3;
      _loc2_.accessories = this._oMember.accessories;
      this._svCharacterViewer.spriteData = _loc2_;
      this._svCharacterViewer.useSingleLoader = true;
      this._svCharacterViewer.spriteAnims = ["emoteStatic14R","emoteStatic14L"];
      this._svCharacterViewer.noDelay = true;
   }
   function zoomSprite(bEnabled)
   {
      if(bEnabled)
      {
         this._mcBackground._width = this._mcBackground._height = 70;
         this._svCharacterViewer.zoom = 130;
         this._svCharacterViewer._y = 14.15;
         this._svCharacterViewer._x = 200.75;
         this._mcMask._width = this._mcMask._height = 70;
         this._mcInteraction._width = this._mcInteraction._height = 70;
      }
      else
      {
         this._mcBackground._width = this._mcBackground._height = 50;
         this._svCharacterViewer.zoom = 100;
         this._svCharacterViewer._y = -3.25;
         this._svCharacterViewer._x = 190.75;
         this._mcMask._width = this._mcMask._height = 50;
         this._mcInteraction._width = this._mcInteraction._height = 50;
         this._svCharacterViewer.playNextAnim(0);
      }
   }
   function getRankChangesPacket()
   {
      var _loc2_ = "";
      var _loc3_ = false;
      var _loc4_;
      var _loc5_;
      for(var sRankId in this._oRankNames)
      {
         if(_loc3_)
         {
            _loc2_ += "|";
            _loc3_ = false;
         }
         _loc4_ = Number(sRankId);
         _loc5_ = this.getRankName(_loc4_);
         if(!(_loc5_ == "0" && this.api.datacenter.Player.guildInfos.getRankName(_loc4_) == this.api.lang.getRankInfos(_loc4_).n))
         {
            if(_loc5_ != this.api.datacenter.Player.guildInfos.getRankName(_loc4_))
            {
               _loc2_ += sRankId + ";" + this._oRankNames[sRankId];
               _loc3_ = true;
            }
         }
      }
      return _loc2_;
   }
   function getRankName(nRankId)
   {
      var _loc3_ = this.api.datacenter.Player.guildInfos.getRankName(nRankId);
      if(this._oRankNames[nRankId] != undefined)
      {
         if(this._oRankNames[nRankId] == "0")
         {
            _loc3_ = this.api.lang.getRankInfos(nRankId).n;
         }
         else
         {
            _loc3_ = this._oRankNames[nRankId];
         }
      }
      return _loc3_;
   }
   function itemSelected(oEvent)
   {
      if(this._cbRanks.selectedItem.id == 1 && this._oMember.rank != 1)
      {
         this.setBoss();
      }
      else
      {
         this.setRank(this._cbRanks.selectedItem.id);
      }
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._mcInteraction)
      {
         this.zoomSprite(true);
      }
   }
   function out(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._mcInteraction)
      {
         this.zoomSprite(false);
      }
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
         case this._btnCancel:
         case this._btnClose:
            this._oRankNames = {};
            this.callClose();
            break;
         case this._btnModify:
            this.updateRight();
            if(this._oMember.rank == this._oMemberClone.rank && (this._oMember.percentxp == this._oMemberClone.percentxp && (this._oMember.rights.value == this._oMemberClone.rights.value && !this.rankNamesHasChanged())))
            {
               return undefined;
            }
            _loc3_ = this.getRankChangesPacket();
            if(_loc3_.length > 0)
            {
               this.api.network.Guild.editRankName(_loc3_);
            }
            if(this.api.datacenter.Player.guildInfos.playerRights.isBoss && this._oMember.name == this.api.datacenter.Player.Name)
            {
               this._oMemberClone.rank = 1;
               this._oMember.rankOrder = this.api.lang.getRankInfos(1).o;
            }
            this._oMember.rank = this._oMemberClone.rank;
            this._oMember.rankOrder = this._oMemberClone.rankOrder;
            this._oMember.percentxp = this._oMemberClone.percentxp;
            this._oMember.rights.value = this._oMemberClone.rights.value;
            this.api.network.Guild.changeMemberProfil(this._oMember);
            this.api.datacenter.Player.guildInfos.setMembers();
            this.callClose();
            break;
         case this._btnPercentXP:
            _loc4_ = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:this._oMember.percentxp,max:90,min:0,params:{targetType:"percentXP"}});
            _loc4_.addEventListener("validate",this);
            break;
         case this._btnEditGradeName:
            _loc5_ = this.gapi.loadUIComponent("PopupText","PopupText",{value:this.getRankName(this._oMemberClone.rank),restrict:"a-z A-Z àáâãäåÀÁÂÃÄÅèéêëËÉÊÈìíîïÌÍÎÏðòóôõöøÐÒÓÔÕÖØùúûüÙÚÛÜýýÿÝÝŸçÇñÑšŠžŽ\'\\-",maxChars:20,params:{targetType:"rank"}});
            _loc5_.addEventListener("validate",this);
            break;
         case this._btnResetRank:
            _loc6_ = this.gapi.loadUIComponent("AskYesNo","AskYesResetRank",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("DO_U_RESET_RANK")});
            _loc6_.addEventListener("yes",this);
            break;
         case this._btnResetAllRanks:
            _loc7_ = this.gapi.loadUIComponent("AskYesNo","AskYesResetAllRanks",{title:this.api.lang.getText("QUESTION"),text:this.api.lang.getText("DO_U_RESET_ALL_RANKS")});
            _loc7_.addEventListener("yes",this);
            break;
         case this._mcInteraction:
            this._svCharacterViewer.playNextAnim();
         default:
            return;
      }
   }
   function validate(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.params.targetType)
      {
         case "percentXP":
            _loc3_ = oEvent.value;
            if(_global.isNaN(_loc3_))
            {
               return undefined;
            }
            if(_loc3_ > 90)
            {
               return undefined;
            }
            if(_loc3_ < 0)
            {
               return undefined;
            }
            this._oMemberClone.percentxp = _loc3_;
            break;
         case "rank":
            _loc4_ = oEvent.value;
            if(_loc4_.length < 3)
            {
               break;
            }
            this._oRankNames[this._oMemberClone.rank] = _loc4_;
      }
      this.updateData();
   }
   function yes(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target._name)
      {
         case "AskYesResetRank":
            this._oRankNames[this._oMemberClone.rank] = 0;
            this.updateRank();
            break;
         case "AskYesResetAllRanks":
            _loc3_ = this.api.lang.getRanks().slice();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               this._oRankNames[_loc4_] = 0;
               _loc4_ = _loc4_ + 1;
            }
            this.updateRank();
            break;
         default:
            this.setRank(1);
      }
      this.updateData();
   }
   function modelChanged(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.eventName) === "rank")
      {
         this.updateRank();
      }
   }
}
