class dofus.graphics.gapi.ui.party.PartyItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bIsFollowing;
   var _bIsInGroup;
   var _bIsLeader;
   var _btn;
   var _ldrSprite;
   var _mcBack;
   var _mcFollow;
   var _mcHealth;
   var _mcLeader;
   var _oSprite;
   var _parent;
   var _visible;
   var addToQueue;
   var gapi;
   var initialized;
   function PartyItem()
   {
      super();
   }
   function set data(oSprite)
   {
      this._oSprite = oSprite;
      if(this.initialized)
      {
         this.updateData();
      }
   }
   function set following(bIsLeader)
   {
      this._bIsFollowing = bIsLeader;
      this._bIsLeader._visible = bIsLeader;
   }
   function set isLeader(bIsFollowing)
   {
      this._mcFollow = bIsFollowing;
      this._mcLeader._visible = bIsFollowing;
   }
   function get isLeader()
   {
      return this._mcFollow;
   }
   function get isInGroup(bIsInGroup)
   {
      return this._bIsInGroup;
   }
   function setHealth(oSprite)
   {
      if(oSprite.life == undefined)
      {
         return undefined;
      }
      var _loc3_ = oSprite.life.split(",");
      this._mcHealth._yscale = _loc3_[0] / _loc3_[1] * 100;
      this._oSprite.life = oSprite.life;
   }
   function setData(oSprite)
   {
      var _loc3_ = this.doReload(oSprite);
      this._oSprite = oSprite;
      if(_loc3_)
      {
         if(this.initialized)
         {
            this.updateData();
         }
      }
      else
      {
         this.setHealth(oSprite);
      }
   }
   function doReload(oSprite)
   {
      var _loc3_ = true;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(this._oSprite.accessories && (oSprite.accessories.length == this._oSprite.accessories.length && oSprite.id == this._oSprite.id))
      {
         _loc4_ = this._oSprite.accessories;
         _loc5_ = oSprite.accessories;
         _loc6_ = [];
         _loc7_ = [];
         for(var i in _loc4_)
         {
            _loc6_.push(_loc4_[i].unicID);
         }
         for(var i in _loc5_)
         {
            _loc7_.push(_loc5_[i].unicID);
         }
         _loc6_.sort();
         _loc7_.sort();
         _loc3_ = !_loc6_ || _loc6_.join(",") != _loc7_.join(",");
      }
      return _loc3_;
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
      this._mcBack._visible = false;
      this._bIsLeader._visible = false;
      this._mcHealth._visible = false;
      this._btn._visible = false;
   }
   function addListeners()
   {
      this._ldrSprite.addEventListener("initialization",this);
      this._btn.addEventListener("over",this);
      this._btn.addEventListener("out",this);
      this._btn.addEventListener("click",this);
   }
   function updateData()
   {
      if(this._oSprite != undefined)
      {
         this._ldrSprite.contentPath = this._oSprite.gfxFile != undefined ? this._oSprite.gfxFile : "";
         this.api.colors.addSprite(this._ldrSprite,this._oSprite);
         this._mcBack._visible = true;
         this._btn.enabled = true;
         this._btn._visible = true;
         this._mcHealth._visible = true;
         this.setHealth(this._oSprite.life);
         this._bIsInGroup = true;
         this._visible = true;
      }
      else
      {
         this._ldrSprite.contentPath = "";
         this._mcBack._visible = false;
         this._bIsLeader._visible = false;
         this._btn.enabled = false;
         this._btn._visible = false;
         this._mcHealth._visible = false;
         this._bIsInGroup = false;
         this._visible = false;
      }
   }
   function isLocalPlayerLeader()
   {
      return this._parent.leaderID == this.api.datacenter.Player.ID;
   }
   function isLocalPlayer()
   {
      return this._oSprite.id == this.api.datacenter.Player.ID;
   }
   function partyWhere()
   {
      this.api.network.Party.where();
      this.api.ui.loadUIAutoHideComponent("MapExplorer","MapExplorer");
   }
   function initialization(oEvent)
   {
      var _loc3_ = oEvent.target.content;
      _loc3_.attachMovie("staticR","anim",10);
      _loc3_._xscale = -65;
      _loc3_._yscale = 65;
   }
   function over(oEvent)
   {
      var _loc3_ = this._oSprite.life.split(",");
      this._mcHealth._yscale = _loc3_[0] / _loc3_[1] * 100;
      this.gapi.showTooltip("<b>" + this._oSprite.name + "</b>\n" + this.api.lang.getText("LEVEL") + " : <b>" + this._oSprite.level + "</b>\n" + this.api.lang.getText("LIFEPOINTS") + " : " + _loc3_[0] + " / " + _loc3_[1] + "\n" + this.api.lang.getText("INITIATIVE") + " : <b>" + this._oSprite.initiative + "</b>\n" + this.api.lang.getText("DISCERNMENT") + " : <b>" + this._oSprite.prospection + "</b>");
   }
   function out(oEvent)
   {
      this.gapi.hideTooltip();
   }
   function click(oEvent)
   {
      this.api.kernel.GameManager.showPlayerPopupMenu(undefined,{sPlayerName:this._oSprite.name,sPlayerID:this._oSprite.id,oPartyItem:this});
   }
   function addPartyMenuItems(pm)
   {
      pm.addStaticItem(this.api.lang.getText("PARTY"));
      pm.addItem(this.api.lang.getText("PARTY_WHERE"),this,this.partyWhere,[]);
      if(this._oSprite.id == this.api.datacenter.Player.ID)
      {
         pm.addItem(this.api.lang.getText("LEAVE_PARTY"),this.api.network.Party,this.api.network.Party.leave,[]);
         if(this.isLocalPlayerLeader())
         {
            if(this._bIsFollowing)
            {
               pm.addItem(this.api.lang.getText("PARTY_STOP_FOLLOW_ME_ALL"),this.api.network.Party,this.api.network.Party.followAll,[true,this._oSprite.id]);
            }
            else
            {
               pm.addItem(this.api.lang.getText("PARTY_FOLLOW_ME_ALL"),this.api.network.Party,this.api.network.Party.followAll,[false,this._oSprite.id]);
            }
         }
      }
      else
      {
         if(this.isLocalPlayer)
         {
            if(this._bIsFollowing)
            {
               pm.addItem(this.api.lang.getText("STOP_FOLLOW"),this.api.network.Party,this.api.network.Party.follow,[true,this._oSprite.id]);
            }
            else
            {
               pm.addItem(this.api.lang.getText("FOLLOW"),this.api.network.Party,this.api.network.Party.follow,[false,this._oSprite.id]);
            }
         }
         if(this.isLocalPlayerLeader())
         {
            if(this._bIsFollowing)
            {
               pm.addItem(this.api.lang.getText("PARTY_STOP_FOLLOW_HIM_ALL"),this.api.network.Party,this.api.network.Party.followAll,[true,this._oSprite.id]);
            }
            else
            {
               pm.addItem(this.api.lang.getText("PARTY_FOLLOW_HIM_ALL"),this.api.network.Party,this.api.network.Party.followAll,[false,this._oSprite.id]);
            }
            pm.addItem(this.api.lang.getText("KICK_FROM_PARTY"),this.api.network.Party,this.api.network.Party.leave,[this._oSprite.id]);
            pm.addItem(this.api.lang.getText("PROMOTE_PARTY_MEMBER"),this.api.network.Party,this.api.network.Party.promote,[this._oSprite.id]);
         }
      }
   }
}
