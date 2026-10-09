class dofus.datacenter.MountPark extends Object
{
   var _nMapID;
   var _oArea;
   var _oMap;
   var api;
   var currentItems;
   var guildEmblem;
   var guildName;
   var id;
   var instance;
   var maxItems;
   var owner;
   var price;
   var size;
   function MountPark(nOwner, nPrice, nSize, nCurrentItems, nMaxItems, sGuildName, oGuildEmblem, nMapID, nId, nInstance)
   {
      super();
      this.api = _global.API;
      this.owner = nOwner;
      this.price = nPrice;
      this.size = nSize;
      this.currentItems = nCurrentItems;
      this.maxItems = nMaxItems;
      this.guildName = sGuildName;
      this.guildEmblem = oGuildEmblem;
      this._nMapID = nMapID;
      this._oMap = this.api.lang.getMapText(nMapID);
      this._oArea = this.api.lang.getMapAreaInfos(this._oMap.sa);
      this.id = nId;
      this.instance = nInstance;
   }
   function get isPublic()
   {
      return this.owner == -1;
   }
   function get hasNoOwner()
   {
      return this.owner == 0;
   }
   function isMine(oApi)
   {
      return this.guildName == oApi.datacenter.Player.guildInfos.name;
   }
   function get areaID()
   {
      return this._oArea.areaID;
   }
   function get areaName()
   {
      return this.api.lang.getMapAreaText(this._oArea.areaID).n;
   }
   function get subareaID()
   {
      return this._oMap.sa;
   }
   function get subareaName()
   {
      var _loc2_ = this.api.lang.getMapSubAreaName(this._oMap.sa);
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this._nMapID + ")";
      }
      return _loc2_;
   }
   function get coordinates()
   {
      return this._oMap.x + ", " + this._oMap.y;
   }
   function get mapID()
   {
      return this._nMapID;
   }
   function get instanceId()
   {
      return this.instance;
   }
   function getPrintFormat()
   {
      var _loc2_ = "";
      _loc2_ += this.guildName != "" ? "<b>" + this.guildName + "</b>" : this.name;
      _loc2_ += this.price <= 0 ? "" : " (" + this.api.lang.getText("FOR_SALE_AT",[new ank.utils.ExtendedString(this.price).addMiddleChar(this.api.lang.getConfigText("THOUSAND_SEPARATOR"),3)]) + "k)";
      return _loc2_;
   }
   function get name()
   {
      var _loc2_ = !this.isPublic ? this.api.lang.getText("MOUNTPARK_PRIVATE") : this.api.lang.getText("MOUNTPARK_PUBLIC");
      if(dofus.Constants.DEBUG)
      {
         _loc2_ += " (" + this.id + ")";
      }
      return _loc2_;
   }
}
