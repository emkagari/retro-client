class dofus.managers.InteractionsManager extends dofus.utils.ApiElement
{
   var _playerManager;
   var _state;
   static var STATE_MOVE_SINGLE = 0;
   static var STATE_SELECT = 1;
   function InteractionsManager(playerManager, oAPI)
   {
      super();
      this.initialize(playerManager,oAPI);
   }
   function initialize(playerManager, oAPI)
   {
      super.initialize(oAPI);
      this._playerManager = playerManager;
   }
   function setState(bFight)
   {
      if(bFight)
      {
         this._state = dofus.managers.InteractionsManager.STATE_SELECT;
         this._playerManager.lastClickedCell = null;
      }
      else
      {
         this._state = dofus.managers.InteractionsManager.STATE_MOVE_SINGLE;
      }
   }
   function calculatePath(mapHandler, cell, bRelease, bIsFight, bIgnoreSprites, bAllDir)
   {
      if(!bIgnoreSprites)
      {
         this.api.gfx.mapHandler.resetEmptyCells();
      }
      var _loc8_ = this._playerManager.data.cellNum;
      var _loc9_ = mapHandler.getCellData(cell);
      var _loc10_ = _loc9_.spriteOnID;
      var _loc11_ = !bIgnoreSprites && _loc10_ != undefined;
      var _loc12_;
      var _loc13_;
      if(_loc11_ && !this.api.datacenter.Game.isFight)
      {
         _loc12_ = dofus.graphics.gapi.ui.Party(this.api.ui.getUIComponent("Party"));
         _loc13_ = false;
         if(_loc12_ != undefined)
         {
            for(var sID in _loc9_.allSpritesOn)
            {
               if(_loc9_.allSpritesOn[sID] && _loc12_.getMember(String(sID)) != undefined)
               {
                  _loc13_ = true;
                  break;
               }
            }
         }
         if(!_loc13_)
         {
            _loc11_ = false;
         }
      }
      if(_loc11_)
      {
         return false;
      }
      if(_loc9_.movement == 0)
      {
         return false;
      }
      if(_loc9_.movement == 1 && bIsFight)
      {
         return false;
      }
      switch(this._state)
      {
         case dofus.managers.InteractionsManager.STATE_MOVE_SINGLE:
            this.api.datacenter.Basics.interactionsManager_path = ank.battlefield.utils.Pathfinding.pathFind(this.api,mapHandler,_loc8_,cell,{bAllDirections:bAllDir,bIgnoreSprites:bIgnoreSprites});
            if(this.api.datacenter.Basics.interactionsManager_path != null)
            {
               return true;
            }
            return false;
            break;
         case dofus.managers.InteractionsManager.STATE_SELECT:
            if(bRelease)
            {
               this.api.gfx.select(this.convertToSimplePath(this.api.datacenter.Basics.interactionsManager_path),dofus.Constants.CELL_PATH_SELECT_COLOR,"moving");
               return this.api.datacenter.Basics.interactionsManager_path != null;
            }
            this.api.datacenter.Basics.interactionsManager_path = ank.battlefield.utils.Pathfinding.pathFind(this.api,mapHandler,_loc8_,cell,{bAllDirections:false,nMaxLength:(!bIsFight ? 500 : this._playerManager.data.MP)});
            this.api.gfx.unSelect(true);
            this.api.gfx.select(this.convertToSimplePath(this.api.datacenter.Basics.interactionsManager_path),dofus.Constants.CELL_PATH_OVER_COLOR,"move");
      }
      return false;
   }
   function convertToSimplePath(aFullPath)
   {
      var _loc3_ = [];
      for(var k in aFullPath)
      {
         _loc3_.push(aFullPath[k].num);
      }
      return _loc3_;
   }
}
