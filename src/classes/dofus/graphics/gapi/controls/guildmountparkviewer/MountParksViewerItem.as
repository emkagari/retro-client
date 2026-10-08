class dofus.graphics.gapi.controls.guildmountparkviewer.MountParksViewerItem extends dofus.graphics.gapi.core.DofusAdvancedComponent
{
   var _bUsed;
   var _btnLocate;
   var _btnTeleport;
   var _lblArea;
   var _lblMounts;
   var _lblSubArea;
   var _mcList;
   var _oItem;
   var addToQueue;
   var api;
   static var MAX_PARK_SLOTS = 20;
   function MountParksViewerItem()
   {
      super();
      this.api = _global.API;
   }
   function set list(mcList)
   {
      this._mcList = mcList;
   }
   function setValue(bUsed, sSuggested, oItem)
   {
      this._bUsed = bUsed;
      var _loc5_;
      var _loc6_;
      if(bUsed)
      {
         this._oItem = oItem;
         this._lblArea.text = oItem.areaName;
         this._lblSubArea.text = oItem.subareaName;
         this._btnLocate.label = "[" + oItem.coordinates + "]";
         this._btnLocate._visible = true;
         this._lblMounts.text = oItem.mounts.length + " / " + oItem.size;
         this._btnTeleport._visible = true;
         _loc5_ = 0;
         while(_loc5_ < dofus.graphics.gapi.controls.guildmountparkviewer.MountParksViewerItem.MAX_PARK_SLOTS)
         {
            _loc6_ = this["_ctr" + _loc5_];
            if(_loc5_ < oItem.size)
            {
               _loc6_.backgroundRenderer = !oItem.mounts[_loc5_].isMine(this.api) ? "UI_MountGridBackground" : "UI_MyMountGridBackground";
               _loc6_.contentData = oItem.mounts[_loc5_];
               _loc6_.addEventListener("onContentLoaded",this);
               _loc6_.addEventListener("over",this);
               _loc6_.addEventListener("out",this);
               _loc6_.enabled = true;
               _loc6_._visible = true;
            }
            else
            {
               _loc6_._visible = false;
            }
            if(oItem.size < 11)
            {
               _loc6_._y = 10.8;
            }
            else if(_loc5_ < 10)
            {
               _loc6_._y = 2;
            }
            else
            {
               _loc6_._y = 20;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      else
      {
         this._btnTeleport._visible = false;
         this._btnLocate._visible = false;
         if(this._lblArea.text != undefined)
         {
            this._lblArea.text = "";
            this._lblSubArea.text = "";
            this._lblMounts.text = "";
         }
      }
   }
   function init()
   {
      super.init(false);
   }
   function createChildren()
   {
      this.addToQueue({object:this,method:this.addListeners});
   }
   function addListeners()
   {
      this._btnLocate.addEventListener("click",this);
      this._btnLocate.addEventListener("over",this);
      this._btnLocate.addEventListener("out",this);
      this._btnTeleport.addEventListener("click",this);
      this._btnTeleport.addEventListener("over",this);
      this._btnTeleport.addEventListener("out",this);
   }
   function over(oEvent)
   {
      var _loc3_ = this._mcList._parent._parent.api;
      var _loc4_;
      switch(oEvent.target)
      {
         case this._btnTeleport:
            _loc3_.ui.showTooltip(_loc3_.lang.getText("GUILD_FARM_TELEPORT_TOOLTIP"));
            return;
         case this._btnLocate:
            _loc3_.ui.showTooltip(_loc3_.lang.getText("LOCATE"));
            return;
         default:
            _loc4_ = oEvent.target.contentData;
            _loc3_.ui.showTooltip(_loc4_ == undefined ? _loc3_.lang.getText("CUSTOM_SET_EMPTY_SLOT") : "<b>" + _loc4_.modelName + "</b> " + "<i>(" + _loc4_.name + ")</i> " + (_loc4_.sex != 0 ? "♀" : "♂") + "\n" + _loc3_.lang.getText("OWNER_WORD") + " : " + "<b>" + _loc4_.ownerName + "</b>");
            return;
      }
   }
   function click(oEvent)
   {
      switch(oEvent.target)
      {
         case this._btnLocate:
            this._mcList.gapi.loadUIComponent("MapExplorer","MapExplorer",{mapID:this._oItem.mapID});
            break;
         case this._btnTeleport:
            if(!this._bUsed)
            {
               return undefined;
            }
            this.api.network.Guild.teleportToGuildFarm(this._oItem.mapID);
         default:
            return;
      }
   }
   function out(oEvent)
   {
      var _loc3_ = this._mcList._parent._parent.api;
      _loc3_.ui.hideTooltip();
   }
   function applyRideColor(mc, zone, oEvent)
   {
      var _loc5_ = oEvent.target.contentData["color" + zone];
      if(_loc5_ == -1 || _loc5_ == undefined)
      {
         return undefined;
      }
      var _loc6_ = (_loc5_ & 0xFF0000) >> 16;
      var _loc7_ = (_loc5_ & 0xFF00) >> 8;
      var _loc8_ = _loc5_ & 0xFF;
      var _loc9_ = new Color(mc);
      var _loc10_ = {};
      _loc10_ = {ra:0,ga:0,ba:0,rb:_loc6_,gb:_loc7_,bb:_loc8_};
      _loc9_.setTransform(_loc10_);
   }
   function onContentLoaded(oEvent)
   {
      var ref = this;
      oEvent.content.applyRideColor = function(mc, zone, oEvent)
      {
         ref.applyRideColor(mc,zone,oEvent);
      };
   }
}
