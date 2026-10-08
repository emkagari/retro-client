class dofus.graphics.gapi.ui.friends.FriendsDisconnectedItem extends ank.gapi.core.UIBasicComponent
{
   var _btnEdit;
   var _btnRemove;
   var _lblName;
   var _mcList;
   var _oItem;
   var addToQueue;
   var api;
   function FriendsDisconnectedItem()
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
         this._lblName.text = oItem.account;
         this._btnRemove._visible = true;
         this._btnEdit._visible = oItem.type != undefined;
         this._btnEdit.enabled = oItem.account.indexOf("OFFI") == -1;
      }
      else if(this._lblName.text != undefined)
      {
         this._lblName.text = "";
         this._btnRemove._visible = false;
         this._btnEdit._visible = false;
      }
   }
   function remove()
   {
      this._oItem.owner.removeFriend(this._oItem.name);
   }
   function init()
   {
      super.init(false);
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
   }
   function click(oEvent)
   {
      var _loc3_;
      var _loc4_;
      switch(oEvent.target)
      {
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
   function over(oEvent_)
   {
      var _loc3_;
      switch(oEvent_.target)
      {
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
   function out(oEvent_)
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
