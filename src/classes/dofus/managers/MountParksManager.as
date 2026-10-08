class dofus.managers.MountParksManager extends dofus.utils.ApiElement
{
   var api;
   static var _sSelf = null;
   function MountParksManager()
   {
      super();
      dofus.managers.MountParksManager._sSelf = this;
   }
   function initialize(oAPI)
   {
      super.initialize(oAPI);
   }
   static function getInstance()
   {
      return dofus.managers.MountParksManager._sSelf;
   }
   function openMountParkMenu(sObject2Name, aSkills, mcCell, oMountPark)
   {
      var _loc6_ = this.api.datacenter.Map.mountParks;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      var _loc10_;
      var _loc11_;
      if(_loc6_.length == 1 || dofus.datacenter.MountPark(_loc6_[0]).isMine(this.api))
      {
         _loc7_ = dofus.datacenter.MountPark(_loc6_[0]);
         this.openInstancedMountParkMenu(sObject2Name,aSkills,mcCell,_loc7_);
      }
      else
      {
         _loc8_ = this.api.ui.createPopupMenu();
         _loc8_.addStaticItem(sObject2Name);
         _loc9_ = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc10_ = dofus.datacenter.MountPark(_loc6_[_loc9_]);
            if(_loc10_.instanceId != undefined)
            {
               _loc11_ = !(_loc10_.guildName == undefined || _loc10_.guildName.length == 0) ? _loc10_.guildName : sObject2Name;
               _loc8_.addItem(_loc11_ + " >> ",this,this.openInstancedMountParkMenu,[sObject2Name,aSkills,mcCell,_loc10_]);
            }
            _loc9_ = _loc9_ + 1;
         }
         _loc8_.show(_root._xmouse,_root._ymouse);
      }
   }
   function openInstancedMountParkMenu(sObject2Name, aSkills, mcCell, oMountPark)
   {
      var _loc6_ = this.api.mouseClicksMemorizer.getMouseClickForGather(1).rightClick;
      var _loc7_ = true;
      var _loc8_ = this.api.ui.createPopupMenu();
      _loc8_.addStaticItem(sObject2Name);
      if(oMountPark.guildName != undefined && oMountPark.guildName.length != 0)
      {
         _loc8_.addStaticItem(oMountPark.guildName);
      }
      var _loc9_;
      var _loc10_;
      var _loc11_;
      var _loc12_;
      for(var k in aSkills)
      {
         _loc9_ = aSkills[k];
         _loc10_ = new dofus.datacenter.Skill(_loc9_);
         _loc11_ = _loc10_.getState(true,oMountPark.isMine(this.api),oMountPark.price > 0,oMountPark.isPublic || oMountPark.isMine(this.api),false,oMountPark.isPublic);
         if(_loc11_ != "X")
         {
            _loc12_ = _loc11_ == "V";
            if(_loc12_ && (Key.isDown(Key.SHIFT) || _loc6_))
            {
               this.api.kernel.GameManager.useRessource(mcCell,mcCell.num,_loc9_,oMountPark.instanceId);
               _loc7_ = false;
               break;
            }
            _loc8_.addItem(_loc10_.description,this.api.kernel.GameManager,this.api.kernel.GameManager.useRessource,[mcCell,mcCell.num,_loc9_,oMountPark.instanceId],_loc12_);
         }
      }
      if(_loc7_)
      {
         _loc8_.show(_root._xmouse,_root._ymouse);
      }
   }
}
