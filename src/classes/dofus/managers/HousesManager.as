class dofus.managers.HousesManager extends dofus.utils.ApiElement
{
   static var _sSelf = null;
   function HousesManager()
   {
      super();
      dofus.managers.HousesManager._sSelf = this;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.HousesManager._sSelf;
   }
   function getHouseInstances(nHouseID)
   {
      var _loc3_ = ank.utils.ExtendedObject(this.api.datacenter.Houses.getItemAt(nHouseID));
      if(_loc3_ == undefined)
      {
         _loc3_ = new ank.utils.ExtendedObject();
         this.api.datacenter.Houses.addItemAt(nHouseID,_loc3_);
      }
      return _loc3_;
   }
   function getHouseByInstance(nHouseID, nInstanceID)
   {
      var _loc4_ = this.getHouseInstances(nHouseID);
      var _loc5_ = dofus.datacenter.House(_loc4_.getItemAt(nInstanceID));
      if(_loc5_ == undefined)
      {
         _loc5_ = new dofus.datacenter.House(nHouseID);
         _loc5_.instanceID = nInstanceID;
         _loc4_.addItemAt(nInstanceID,_loc5_);
      }
      return _loc5_;
   }
   function openHouseMenu(sDoorName, nHouseID, aSkills, mcCell)
   {
      sDoorName = sDoorName != undefined ? sDoorName + " " : "";
      var _loc6_;
      var _loc7_;
      if(this.api.datacenter.Map.isMyHome)
      {
         _loc6_ = nHouseID;
         nHouseID = this.api.lang.getHousesMapText(this.api.datacenter.Map.id);
         _loc7_ = this.api.kernel.HouseManager.getHouseByInstance(nHouseID,_loc6_);
         this.openInstancedHouseMenu(sDoorName,_loc7_,aSkills);
         return undefined;
      }
      var _loc8_ = this.getHouseInstances(nHouseID);
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      if(_loc8_.getLength() == 1)
      {
         _loc9_ = dofus.datacenter.House(_loc8_.getFirstItem());
         this.openInstancedHouseMenu(sDoorName,_loc9_,aSkills,mcCell);
      }
      else
      {
         _loc10_ = this.api.ui.createPopupMenu();
         _loc11_ = _loc8_.getFirstItem().name;
         _loc10_.addStaticItem(sDoorName + _loc11_);
         for(var i in _loc8_.getItems())
         {
            _loc12_ = dofus.datacenter.House(_loc8_.getItemAt(i));
            if(_loc12_.instanceID != undefined)
            {
               _loc10_.addItem(_loc12_.getHouseOfOwnerName() + " >> ",this,this.openInstancedHouseMenu,[sDoorName,_loc12_,aSkills,mcCell]);
            }
         }
         _loc10_.show(_root._xmouse,_root._ymouse);
      }
   }
   function openInstancedHouseMenu(sDoorName, hHouse, aSkills, mcCell)
   {
      var _loc6_ = this.api.mouseClicksMemorizer.getMouseClickForGather(1).rightClick;
      var _loc7_ = true;
      var _loc8_ = this.api.ui.createPopupMenu();
      _loc8_.addStaticItem(sDoorName + hHouse.name);
      _loc8_.addStaticItem(hHouse.getHouseOfOwnerName());
      if(this.api.datacenter.Player.isAuthorized && (hHouse.ownerName != undefined && hHouse.ownerName != "?"))
      {
         _loc8_.addItem("*" + hHouse.ownerName + " >>",this.api.kernel.GameManager,this.api.kernel.GameManager.showPlayerPopupMenu,[undefined,{sPlayerName:"*" + hHouse.ownerName}]);
      }
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      for(var k in aSkills)
      {
         _loc9_ = aSkills[k];
         _loc10_ = new dofus.datacenter.Skill(_loc9_);
         _loc11_ = _loc10_.getState(true,hHouse.localOwner,hHouse.isForSale,hHouse.isLocked);
         if(_loc11_ != "X")
         {
            _loc12_ = _loc11_ == "V";
            if(_loc12_ && ((Key.isDown(Key.SHIFT) || _loc6_) && _loc9_ == 84))
            {
               this.api.kernel.GameManager.useRessource(mcCell,mcCell.num,_loc9_,hHouse.instanceID);
               _loc7_ = false;
               break;
            }
            if(mcCell.num != undefined)
            {
               _loc8_.addItem(_loc10_.description,this.api.kernel.GameManager,this.api.kernel.GameManager.useRessource,[mcCell,mcCell.num,_loc9_,hHouse.instanceID],_loc12_);
            }
            else
            {
               _loc8_.addItem(_loc10_.description,this.api.kernel.GameManager,this.api.kernel.GameManager.useSkill,[_loc10_.id],_loc11_ == "V");
            }
         }
      }
      if(!this.api.datacenter.Map.isMyHome && hHouse.isHuntTargetInside)
      {
         _loc8_.addItem(this.api.lang.getText("ASSAULT") + " " + this.api.lang.getText("HUNTED"),this.api.kernel.GameManager,this.api.kernel.GameManager.askAttackIndoor);
      }
      if(this.api.datacenter.Map.isMyHome && (this.api.datacenter.Player.guildInfos != undefined && this.api.datacenter.Player.guildInfos.isValid))
      {
         _loc8_.addItem(this.api.lang.getText("GUILD_HOUSE_CONFIGURATION"),hHouse,hHouse.loadGuildRightsComponent,[hHouse]);
      }
      if(_loc7_)
      {
         _loc8_.show(_root._xmouse,_root._ymouse);
      }
   }
}
