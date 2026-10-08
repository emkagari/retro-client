class dofus.graphics.gapi.ui.friends.FriendsConnectedItem extends ank.gapi.core.UIBasicComponent
{
   var _btnEdit;
   var _btnRemove;
   var _lblLevel;
   var _lblName;
   var _ldrAlignement;
   var _ldrGuild;
   var _mcFight;
   var _mcList;
   var _oItem;
   var _parent;
   var addToQueue;
   var api;
   function FriendsConnectedItem()
   {
      super();
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblName.text = oItem.name;
         if(oItem.level != undefined)
         {
            this._lblLevel.text = oItem.level;
         }
         else
         {
            this._lblLevel.text = "";
         }
         this._mcFight._visible = oItem.state == "IN_MULTI";
         this._ldrGuild.contentPath = dofus.Constants.GUILDS_MINI_PATH + oItem.gfxID + ".swf";
         if(oItem.alignement != -1)
         {
            this._ldrAlignement.contentPath = dofus.Constants.ALIGNMENTS_MINI_PATH + oItem.alignement + ".swf";
         }
         else
         {
            this._ldrAlignement.contentPath = "";
         }
         this._btnRemove._visible = true;
         this._btnEdit._visible = oItem.type != undefined;
         this._btnEdit.enabled = oItem.account.indexOf("OFFI") == -1;
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._lblLevel.text = "";
         this._ldrAlignement.contentPath = "";
         this._mcFight._visible = false;
         this._ldrGuild.contentPath = "";
         this._btnRemove._visible = false;
         this._btnEdit._visible = false;
      }
   }
   function init()
   {
      super.init(false);
      this._mcFight._visible = false;
      this._btnRemove._visible = false;
      this._btnEdit._visible = false;
      this.api = this._mcList.gapi.api;
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnRemove.addEventListener("click",this);
      this._btnRemove.addEventListener("over",this);
      this._btnRemove.addEventListener("out",this);
      this._btnEdit.addEventListener("click",this);
      this._btnEdit.addEventListener("over",this);
      this._btnEdit.addEventListener("out",this);
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
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._mcFight:
            this.api.network.GameActions.joinChallengeAsSpectator(0,this._oItem.id);
            break;
         case this._btnRemove:
            if(this._oItem.account != undefined)
            {
               this._mcList._parent._parent.removeFriend("*" + this._oItem.account);
            }
            else
            {
               this._mcList._parent._parent.removeFriend(this._oItem.name);
            }
            break;
         case this._btnEdit:
            _loc3_ = this._oItem.account;
            _loc4_ = this.api.ui.loadUIComponent("EditSocialNote","EditSocialNote",{title:this.api.lang.getText("SOCIAL_NOTE_TITLE",[_loc3_]),params:{note:this._oItem.note,accountName:_loc3_}});
            _loc4_.addEventListener("save",this);
         default:
            return;
      }
   }
   function over(oEvent)
   {
      var _loc3_;
      switch(oEvent.target)
      {
         case this._mcFight:
            this.api.ui.showTooltip(this.api.lang.getText("CLICK_TO_JOIN_AS_SPECTATOR"));
            return;
         case this._btnRemove:
            this.api.ui.showTooltip(this.api.lang.getText("REMOVE_PLAYER_FROM_LIST"));
            return;
         case this._btnEdit:
            this.api.ui.showTooltip(this.api.lang.getText("EDIT_PERSONAL_NOTE"));
            return;
         default:
            _loc3_ = this.api.lang.getText("PSEUDO_DOFUS",[this._oItem.account]);
            if(this._oItem.note != undefined && this._oItem.note != "")
            {
               _loc3_ += "\n\n" + "<i>" + this._oItem.note + "</i>";
            }
            this.api.ui.showTooltip(_loc3_);
            return;
      }
   }
   function out(oEvent)
   {
      this._mcList.gapi.api.ui.hideTooltip();
   }
   function save(oEvent_)
   {
      this._oItem.note = oEvent_.text;
      if(this._oItem.type == dofus.graphics.gapi.ui.Friends.FRIEND_TYPE)
      {
         this.api.network.Friends.editSocialNote(oEvent_.params.accountName,oEvent_.text);
      }
      if(this._oItem.type == dofus.graphics.gapi.ui.Friends.ENEMY_TYPE)
      {
         this.api.network.Enemies.editSocialNote(oEvent_.params.accountName,oEvent_.text);
      }
   }
}
