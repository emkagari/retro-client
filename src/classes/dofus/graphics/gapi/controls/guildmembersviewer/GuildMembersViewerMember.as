class dofus.graphics.gapi.controls.guildmembersviewer.GuildMembersViewerMember extends ank.gapi.core.UIBasicComponent
{
   var _btnBann;
   var _btnProfil;
   var _lblAchievementScore;
   var _lblLevel;
   var _lblName;
   var _lblPercentXP;
   var _lblRank;
   var _lblWinXP;
   var _ldrAlignement;
   var _ldrGuild;
   var _ldrIcon;
   var _mcFight;
   var _mcList;
   var _mcOffline;
   var _mcOver;
   var _nOriginalLblX;
   var _oItem;
   var _parent;
   var addToQueue;
   var attachMovie;
   var _nIconOffset = 15;
   var ftgt = 150;
   function GuildMembersViewerMember()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      var _loc5_ = _global.API;
      var _loc6_;
      var _loc7_;
      if(bUsed)
      {
         this._oItem = oItem;
         _loc6_ = this._mcList.gapi.api.datacenter.Player.guildInfos.playerRights;
         _loc7_ = oItem.rights.isBoss;
         this._lblName.text = oItem.name;
         this._lblRank.text = this._mcList.gapi.api.datacenter.Player.guildInfos.getRankName(oItem.rank);
         this._lblLevel.text = oItem.level;
         this._lblPercentXP.text = oItem.percentxp + "%";
         this._lblWinXP.text = new ank.utils.ExtendedString(oItem.winxp).addMiddleChar(_loc5_.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         this._btnBann._visible = oItem.isLocalPlayer || _loc6_.canBann;
         this._btnProfil._visible = true;
         this._ldrGuild.contentPath = dofus.Constants.GUILDS_MINI_PATH + oItem.gfx + ".swf";
         this._mcFight._visible = oItem.state == 2;
         this._mcOffline._visible = oItem.state == 0;
         this._lblAchievementScore.text = new ank.utils.ExtendedString(oItem.achievementScore).addMiddleChar(_loc5_.lang.getConfigText("THOUSAND_SEPARATOR"),3);
         this._mcOver.hint = oItem.lastConnection;
         if(_loc7_)
         {
            this._lblRank._x = this._nOriginalLblX + this._nIconOffset;
            this.attachMovie("GAPILoader","_ldrIcon",100,{_x:this._nOriginalLblX - 8,_y:this._lblRank._y - 5,_height:15,_width:15,contentPath:"GuildMemberCrown",centerContent:true,scaleContent:true});
         }
         else
         {
            this._ldrIcon.removeMovieClip();
            this._lblRank._x = this._nOriginalLblX;
         }
         this._ldrAlignement.contentPath = dofus.Constants.ALIGNMENTS_MINI_PATH + oItem.alignement + ".swf";
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblRank.text = "";
         this._lblLevel.text = "";
         this._lblPercentXP.text = "";
         this._lblWinXP.text = "";
         this._btnBann._visible = false;
         this._btnProfil._visible = false;
         this._ldrGuild.contentPath = "";
         this._ldrAlignement.contentPath = "";
         this._mcFight._visible = false;
         this._mcOffline._visible = false;
         this._ldrIcon.removeMovieClip();
         this._lblRank._x = this._nOriginalLblX;
         this._lblAchievementScore.text = "";
      }
   }
   function init()
   {
      super.init(false);
      this._btnBann._visible = false;
      this._btnProfil._visible = false;
      this._mcFight._visible = false;
      this._mcOffline._visible = false;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this._nOriginalLblX = this._lblRank._x;
   }
   function addListeners()
   {
      this._btnBann.addEventListener("click",this);
      this._btnProfil.addEventListener("click",this);
      this._mcFight.onRollOver = function()
      {
         this._parent.over({target:this});
      };
      this._mcFight.onRollOut = function()
      {
         this._parent.out({target:this});
      };
      this._mcFight.onRelease = function()
      {
         this._parent.click({target:this});
      };
   }
   function click(oEvent)
   {
      var _loc3_ = this._mcList.gapi.api;
      var _loc4_;
      switch(oEvent.target._name)
      {
         case "_btnBann":
            _loc4_ = _loc3_.datacenter.Player.guildInfos.members.length;
            if(this._oItem.rights.isBoss && _loc4_ > 1)
            {
               this._mcList.gapi.api.kernel.showMessage(undefined,_loc3_.lang.getText("GUILD_BOSS_CANT_BE_BANN"),"ERROR_BOX");
            }
            else if(this._oItem.isLocalPlayer)
            {
               _loc3_.kernel.showMessage(undefined,_loc3_.lang.getText("DO_U_DELETE_YOU") + (_loc4_ <= 1 ? "\n" + _loc3_.lang.getText("DELETE_GUILD_CAUTION") : ""),"CAUTION_YESNO",{name:"DeleteMember",listener:this,params:{name:this._oItem.name}});
            }
            else
            {
               _loc3_.kernel.showMessage(undefined,_loc3_.lang.getText("DO_U_DELETE_MEMBER",[this._oItem.name]),"CAUTION_YESNO",{name:"DeleteMember",listener:this,params:{name:this._oItem.name}});
            }
            break;
         case "_btnProfil":
            this._mcList.gapi.loadUIComponent("GuildMemberInfos","GuildMemberInfos",{member:this._oItem});
            break;
         case "_mcFight":
            _loc3_.network.GameActions.joinChallengeAsSpectator(0,this._oItem.id);
         default:
            return;
      }
   }
   function yes(oEvent)
   {
      this._mcList.gapi.api.network.Guild.bann(oEvent.params.name);
   }
   function over(oEvent)
   {
      var _loc3_ = this._mcList.gapi.api;
      var _loc0_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      var _loc13_;
      if((_loc0_ = oEvent.target._name) !== "_mcFight")
      {
         if(this._oItem.state != 0)
         {
            return undefined;
         }
         _loc4_ = this._oItem.lastConnection;
         _loc5_ = Math.floor(_loc4_ / (24 * 31));
         _loc4_ -= _loc5_ * 24 * 31;
         _loc6_ = Math.floor(_loc4_ / 24);
         _loc4_ -= _loc6_ * 24;
         _loc7_ = _loc4_;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
         }
         _loc8_ = " " + _loc3_.lang.getText("AND") + " ";
         _loc9_ = "";
         if(_loc5_ > 0)
         {
            if(_loc6_ == 0)
            {
               _loc10_ = ank.utils.PatternDecoder.combine(_loc3_.lang.getText("MONTHS"),"m",_loc5_ == 1);
               _loc9_ += _loc5_ + " " + _loc10_;
            }
            else
            {
               _loc11_ = ank.utils.PatternDecoder.combine(_loc3_.lang.getText("MONTHS"),"m",_loc5_ == 1);
               _loc12_ = ank.utils.PatternDecoder.combine(_loc3_.lang.getText("DAYS"),"m",_loc6_ == 1);
               _loc9_ += _loc5_ + " " + _loc11_ + _loc8_ + _loc6_ + " " + _loc12_;
            }
         }
         else if(_loc6_ != 0)
         {
            _loc13_ = ank.utils.PatternDecoder.combine(_loc3_.lang.getText("DAYS"),"m",_loc6_ == 1);
            _loc9_ += _loc6_ + " " + _loc13_;
         }
         else
         {
            _loc9_ += _loc3_.lang.getText("A_CONNECTED_TODAY");
         }
         _loc3_.ui.showTooltip(_loc3_.lang.getText("GUILD_LAST_CONNECTION",[_loc9_]));
      }
      else
      {
         _loc3_.ui.showTooltip(_loc3_.lang.getText("CLICK_TO_JOIN_AS_SPECTATOR"));
      }
   }
   function out(oEvent)
   {
      this._mcList.gapi.api.ui.hideTooltip();
   }
}
