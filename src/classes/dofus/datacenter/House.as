class dofus.datacenter.House extends Object
{
   var _aSkills;
   var _bForSale;
   var _bHuntTargetInside;
   var _bLocalOwner;
   var _bLocked;
   var _bShared;
   var _nGuildRights;
   var _nID;
   var _nInstanceID;
   var _nPrice;
   var _oGuildEmblem;
   var _pCoords;
   var _sDescription;
   var _sName;
   var api;
   var dispatchEvent;
   static var GUILDSHARE_VISIBLE_GUILD_BRIEF = 1;
   static var GUILDSHARE_DOORSIGN_GUILD = 2;
   static var GUILDSHARE_DOORSIGN_OTHERS = 4;
   static var GUILDSHARE_ALLOWDOOR_GUILD = 8;
   static var GUILDSHARE_FORBIDDOOR_OTHERS = 16;
   static var GUILDSHARE_ALLOWCHESTS_GUILD = 32;
   static var GUILDSHARE_FORBIDCHESTS_OTHERS = 64;
   static var GUILDSHARE_TELEPORT = 128;
   static var GUILDSHARE_RESPAWN = 256;
   var _sOwnerName = new String();
   var _sGuildName = new String();
   function House(nID)
   {
      super();
      this.initialize(nID);
   }
   function get id()
   {
      return this._nID;
   }
   function set instanceID(nInstanceID)
   {
      this._nInstanceID = nInstanceID;
   }
   function get instanceID()
   {
      return this._nInstanceID;
   }
   function get name()
   {
      var _loc2_ = this.api.lang.fetchString(this._sName);
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
   function get description()
   {
      return this.api.lang.fetchString(this._sDescription);
   }
   function set price(nPrice)
   {
      this._nPrice = Number(nPrice);
   }
   function get price()
   {
      return this._nPrice;
   }
   function set localOwner(bLocalOwner)
   {
      this._bLocalOwner = bLocalOwner;
   }
   function get localOwner()
   {
      return this._bLocalOwner;
   }
   function set ownerName(sOwnerName)
   {
      this._sOwnerName = sOwnerName;
   }
   function get ownerName()
   {
      if(typeof this._sOwnerName == "string")
      {
         if(this._sOwnerName.length > 0)
         {
            return this._sOwnerName;
         }
      }
      return null;
   }
   function set guildName(sGuildName)
   {
      this._sGuildName = sGuildName;
      this.dispatchEvent({type:"guild",value:this});
   }
   function get guildName()
   {
      if(typeof this._sGuildName == "string")
      {
         if(this._sGuildName.length > 0)
         {
            return this._sGuildName;
         }
      }
      return null;
   }
   function set guildEmblem(oGuildEmblem)
   {
      this._oGuildEmblem = oGuildEmblem;
      this.dispatchEvent({type:"guild",value:this});
   }
   function get guildEmblem()
   {
      return this._oGuildEmblem;
   }
   function set guildRights(nRights)
   {
      this._nGuildRights = Number(nRights);
      this.dispatchEvent({type:"guild",value:this});
   }
   function get guildRights()
   {
      return this._nGuildRights;
   }
   function set isForSale(bForSale)
   {
      this._bForSale = bForSale;
      this.dispatchEvent({type:"forsale",value:bForSale});
   }
   function get isForSale()
   {
      return this._bForSale;
   }
   function set isLocked(bLocked)
   {
      this._bLocked = bLocked;
      this.dispatchEvent({type:"locked",value:bLocked});
   }
   function get isLocked()
   {
      return this._bLocked;
   }
   function set isShared(bShared)
   {
      this._aSkills = bShared;
      this.dispatchEvent({type:"shared",value:bShared});
   }
   function get isShared()
   {
      return this._aSkills;
   }
   function set coords(pCoords)
   {
      this._pCoords = pCoords;
   }
   function get coords()
   {
      return this._pCoords;
   }
   function set skills(aHouseSkills)
   {
      this._bShared = aHouseSkills;
      return this.skills;
   }
   function get skills()
   {
      return this._bShared;
   }
   function set isHuntTargetInside(bHuntTargetInside)
   {
      this._bHuntTargetInside = bHuntTargetInside;
   }
   function get isHuntTargetInside()
   {
      return this._bHuntTargetInside;
   }
   function initialize(nID)
   {
      this.api = _global.API;
      mx.events.EventDispatcher.initialize(this);
      this._nID = nID;
      var _loc3_ = this.api.lang.getHouseText(nID);
      this._sName = _loc3_.n;
      this._sDescription = _loc3_.d;
   }
   function hasRight(nRight)
   {
      return (this._nGuildRights & nRight) == nRight;
   }
   function getHumanReadableRightsList()
   {
      var _loc2_ = new ank.utils.ExtendedArray();
      var _loc3_ = 1;
      while(_loc3_ < 8192)
      {
         if(this.hasRight(_loc3_))
         {
            _loc2_.push({id:_loc3_,label:this.api.lang.getText("GUILD_HOUSE_RIGHT_" + _loc3_)});
         }
         _loc3_ *= 2;
      }
      return _loc2_;
   }
   function getOwnerAndGuild()
   {
      var _loc2_ = "";
      _loc2_ += this.getHouseOfOwnerName(true);
      _loc2_ += this._sGuildName != "" ? "<font color=\"#c09fe1\"> - " + this._sGuildName + "</font>" : "";
      _loc2_ += !this._bForSale ? "" : " (" + this.api.lang.getText("FOR_SALE_AT",[new ank.utils.ExtendedString(this._nPrice).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]) + "k)";
      return _loc2_;
   }
   function getHouseOfOwnerName(bHTML)
   {
      var _loc4_ = this.ownerName;
      var _loc5_ = _loc4_.split("#");
      var _loc6_ = _loc5_[0];
      var _loc7_ = "#" + _loc5_[1];
      if(_loc4_ == undefined)
      {
         return this.api.lang.getText("NO_OWNER");
      }
      var _loc3_;
      if(this._bLocalOwner)
      {
         _loc3_ = this.api.lang.getText("MY_HOME");
      }
      else if(_loc4_ == "?")
      {
         _loc3_ = this.api.lang.getText("HOUSE_WITH_NO_OWNER");
      }
      else
      {
         _loc3_ = this.api.lang.getText("HOME") + " " + (!bHTML ? _loc6_ + _loc7_ : "<b>" + _loc6_ + "</b>" + _loc7_);
      }
      return _loc3_;
   }
   function loadGuildRightsComponent()
   {
      this.api.ui.loadUIComponent("GuildHouseRights","GuildHouseRights",{house:this});
   }
}
