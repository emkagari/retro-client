class dofus.graphics.gapi.ui.Friends extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _btnAdd;
   var _btnClose;
   var _btnShowFriendsWarning;
   var _btnSwapMode;
   var _btnTabEnemies;
   var _btnTabFriends;
   var _btnTabIgnore;
   var _dgOffLine;
   var _dgOnLine;
   var _itAddFriend;
   var _lblAddFriend;
   var _lblHelp;
   var _lblInfo;
   var _lblOffLine;
   var _lblOnLine;
   var _lblShowFriendsWarning;
   var _lblTitleInfo;
   var _mcSpousePlacer;
   var _svSpouse;
   var _winBg;
   var addToQueue;
   var attachMovie;
   var gapi;
   var unloadThis;
   static var CLASS_NAME = "Friends";
   static var FRIEND_TYPE = 1;
   static var ENEMY_TYPE = 2;
   var _sCurrentTab = "Friends";
   function Friends()
   {
      super();
   }
   function set enemiesList(aEnemies)
   {
      if(this._sCurrentTab != "Enemies")
      {
         return;
      }
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < aEnemies.length)
      {
         _loc6_ = aEnemies[_loc5_];
         if(_loc6_.account.length != 0)
         {
            if(_loc6_.state != "DISCONNECT")
            {
               _loc3_.push(_loc6_);
            }
            else
            {
               _loc4_.push(_loc6_);
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      this._dgOnLine.dataProvider = _loc3_;
      this._dgOffLine.dataProvider = _loc4_;
   }
   function set friendsList(aFriends)
   {
      if(this._sCurrentTab != "Friends")
      {
         return;
      }
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_ = new ank.utils.ExtendedArray();
      var _loc5_ = 0;
      var _loc6_;
      while(_loc5_ < aFriends.length)
      {
         _loc6_ = aFriends[_loc5_];
         if(_loc6_.account.length != 0)
         {
            if(_loc6_.state != "DISCONNECT")
            {
               _loc3_.push(_loc6_);
            }
            else
            {
               _loc4_.push(_loc6_);
            }
         }
         _loc5_ = _loc5_ + 1;
      }
      this._dgOnLine.dataProvider = _loc3_;
      if(!this.api.config.isStreaming)
      {
         this._dgOffLine.dataProvider = _loc4_;
      }
   }
   function set spouse(oSpouse)
   {
      if(this._svSpouse != undefined)
      {
         this._svSpouse.swapDepths(this._mcSpousePlacer);
         this._svSpouse.removeMovieClip();
      }
      this.attachMovie("SpouseViewer","_svSpouse",10,{_x:this._mcSpousePlacer._x,_y:this._mcSpousePlacer._y,spouse:oSpouse});
      this._svSpouse.swapDepths(this._mcSpousePlacer);
   }
   function removeFriend(sName)
   {
      switch(this._sCurrentTab)
      {
         case "Enemies":
            this.api.network.Enemies.removeEnemy(sName);
            break;
         case "Friends":
            this.api.network.Friends.removeFriend(sName);
            break;
         case "Ignore":
            this.api.kernel.ChatManager.removeToBlacklist(sName);
            this.updateIgnoreList();
         default:
            return;
      }
   }
   function updateIgnoreList()
   {
      if(this._sCurrentTab != "Ignore")
      {
         return undefined;
      }
      var _loc2_ = this.api.kernel.ChatManager.getBlacklist();
      var _loc3_ = new ank.utils.ExtendedArray();
      var _loc4_;
      for(var i in _loc2_)
      {
         if(_loc2_[i] != undefined)
         {
            _loc4_ = {};
            _loc4_.name = _loc2_[i].sName;
            _loc4_.gfxID = _loc2_[i].nClass;
            _loc3_.push(_loc4_);
         }
      }
      this._dgOffLine.dataProvider = new ank.utils.ExtendedArray();
      this._dgOnLine.dataProvider = _loc3_;
   }
   function init()
   {
      super.init(false,dofus.graphics.gapi.ui.Friends.CLASS_NAME);
      this.gapi.getUIComponent("Banner").chatAutoFocus = false;
   }
   function destroy()
   {
      this.gapi.getUIComponent("Banner").chatAutoFocus = true;
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
      this.addToQueue({object:this,method:this.setTextFocus});
      this.addToQueue({object:this,method:this.initData});
      this.addToQueue({object:this,method:this.setCurrentTab,params:[this._sCurrentTab]});
      this._mcSpousePlacer._visible = false;
   }
   function initTexts()
   {
      switch(this._sCurrentTab)
      {
         case "Enemies":
            this._winBg.title = this.api.lang.getText("ENEMIES");
            this._lblAddFriend.text = this.api.lang.getText("ADD_AN_ENEMY");
            this._lblInfo.text = this.api.lang.getText("FRIENDS_INFO_ENEMIES");
            this._dgOnLine.columnsNames = ["",this.api.lang.getText("PSEUDONYM"),this.api.lang.getText("LEVEL"),"",""];
            this._dgOffLine._visible = true;
            this._lblOffLine._visible = this._dgOffLine._visible;
            this._lblOnLine._visible = this._dgOffLine._visible;
            break;
         case "Friends":
            this._winBg.title = this.api.lang.getText("FRIENDS");
            this._lblAddFriend.text = this.api.lang.getText("ADD_A_FRIEND");
            this._lblInfo.text = this.api.lang.getText("FRIENDS_INFO_FRIENDS");
            this._dgOnLine.columnsNames = ["",this.api.lang.getText("PSEUDONYM"),this.api.lang.getText("LEVEL"),"",""];
            this._dgOffLine._visible = true;
            this._lblOffLine._visible = this._dgOffLine._visible;
            this._lblOnLine._visible = this._dgOffLine._visible;
            break;
         case "Ignore":
            this._winBg.title = this.api.lang.getText("IGNORED");
            this._lblAddFriend.text = this.api.lang.getText("ADD_A_IGNORED");
            this._lblInfo.text = this.api.lang.getText("FRIENDS_INFO_IGNORE");
            this._dgOnLine.columnsNames = ["",this.api.lang.getText("PSEUDONYM"),"","",""];
            this._dgOffLine._visible = false;
            this._lblOffLine._visible = this._dgOffLine._visible;
            this._lblOnLine._visible = this._dgOffLine._visible;
      }
      this._btnTabFriends.label = this.api.lang.getText("FRIENDS");
      this._btnTabEnemies.label = this.api.lang.getText("ENEMIES");
      this._btnTabIgnore.label = this.api.lang.getText("IGNORED");
      this._lblHelp.text = this.api.lang.getText("IGNORED_DESC");
      this._lblTitleInfo.text = this.api.lang.getText("INFORMATIONS");
      this._dgOffLine.columnsNames = [this.api.lang.getText("PSEUDO_DOFUS_SIMPLE")];
      this._lblOnLine.text = this.api.lang.getText("ONLINE");
      this._lblOffLine.text = this.api.lang.getText("OFFLINE");
      this._btnAdd.label = this.api.lang.getText("ADD");
      this._lblShowFriendsWarning.text = this.api.lang.getText("WARNING_WHEN_FRIENDS_COME_ONLINE");
      if(!this.api.lang.getConfigText("ENABLE_IGNORE_LIST"))
      {
         this._btnSwapMode._visible = false;
      }
   }
   function addListeners()
   {
      this._btnAdd.addEventListener("click",this);
      this._btnClose.addEventListener("click",this);
      this._btnTabFriends.addEventListener("click",this);
      this._btnTabEnemies.addEventListener("click",this);
      this._btnTabIgnore.addEventListener("click",this);
      this._btnShowFriendsWarning.addEventListener("click",this);
      this._btnShowFriendsWarning.addEventListener("over",this);
      this._btnShowFriendsWarning.addEventListener("out",this);
      this._dgOnLine.addEventListener("itemSelected",this);
      this._dgOnLine.addEventListener("itemdblClick",this);
      this._dgOnLine.addEventListener("itemRollOver",this);
      this._dgOnLine.addEventListener("itemRollOut",this);
      this.api.kernel.KeyManager.addShortcutsListener("onShortcut",this);
   }
   function initData()
   {
      this._btnShowFriendsWarning.selected = this.api.datacenter.Basics.aks_notify_on_friend_connexion;
   }
   function setTextFocus()
   {
      this._itAddFriend.setFocus();
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
   function updateCurrentTabInformations()
   {
      switch(this._sCurrentTab)
      {
         case "Enemies":
            this.api.network.Enemies.getEnemiesList();
            break;
         case "Friends":
            this.api.network.Friends.getFriendsList();
            break;
         case "Ignore":
            this.updateIgnoreList();
      }
      this.addToQueue({object:this,method:this.initTexts});
   }
   function onShortcut(sShortcut)
   {
      if(sShortcut == "ACCEPT_CURRENT_DIALOG" && this._itAddFriend.focused)
      {
         this.click({target:this._btnAdd});
         return false;
      }
      return true;
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnAdd:
            if(this._itAddFriend.text.length != 0)
            {
               switch(this._sCurrentTab)
               {
                  case "Enemies":
                     this.api.network.Enemies.addEnemy("%" + this._itAddFriend.text);
                     if(this._itAddFriend.text != undefined)
                     {
                        this._itAddFriend.text = "";
                     }
                     this.api.network.Enemies.getEnemiesList();
                     break;
                  case "Friends":
                     this.api.network.Friends.addFriend("%" + this._itAddFriend.text);
                     if(this._itAddFriend.text != undefined)
                     {
                        this._itAddFriend.text = "";
                     }
                     this.api.network.Friends.getFriendsList();
                     break;
                  case "Ignore":
                     this.api.kernel.ChatManager.addToBlacklist(this._itAddFriend.text);
                     if(this._itAddFriend.text != undefined)
                     {
                        this._itAddFriend.text = "";
                     }
                     this.updateIgnoreList();
               }
            }
            break;
         case this._btnClose:
            this.callClose();
            break;
         case this._btnTabFriends:
            this.setCurrentTab("Friends");
            break;
         case this._btnTabEnemies:
            this.setCurrentTab("Enemies");
            break;
         case this._btnTabIgnore:
            this.setCurrentTab("Ignore");
            break;
         case this._btnShowFriendsWarning:
            this.api.network.Friends.setNotify(this._btnShowFriendsWarning.selected);
            this.api.datacenter.Basics.aks_notify_on_friend_connexion = this._btnShowFriendsWarning.selected;
         default:
            return;
      }
   }
   function notifyStateChanged(bNotify)
   {
      this._btnShowFriendsWarning.selected = bNotify;
   }
   function itemSelected(oEvent)
   {
      var _loc3_ = oEvent.row.item;
      this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:_loc3_.name,sPlayerID:_loc3_.id,bNoFriendsInvite:true,bShowJoinFriend:true,bShowViewTtgCollection:_loc3_.hasTtgCollection});
   }
   function itemdblClick(oEvent)
   {
      this.api.kernel.GameManager.askPrivateMessage(oEvent.row.item.name);
   }
   function itemRollOver(oEvent)
   {
      if(this._sCurrentTab == "Ignore")
      {
         return undefined;
      }
      oEvent.row.cellRenderer_mc.over(oEvent);
   }
   function itemRollOut(oEvent)
   {
      oEvent.row.cellRenderer_mc.out(oEvent);
   }
   function over(oEvent)
   {
      var _loc0_;
      if((_loc0_ = oEvent.target) === this._btnShowFriendsWarning)
      {
         this.gapi.showTooltip(this.api.lang.getText("WARNING_WHEN_FRIENDS_COME_ONLINE_TOOLTIP"));
      }
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
}
