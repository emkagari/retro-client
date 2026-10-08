class dofus.utils.consoleParsers.consoleCommands.ConsoleCommandCell
{
   function ConsoleCommandCell()
   {
   }
   static function checkLOS(oContext, aTmp)
   {
      var _loc4_ = Number(aTmp[0]);
      var _loc5_ = Number(aTmp[1]);
      if(_global.isNaN(_loc4_) || (_loc4_ == undefined || (_global.isNaN(_loc5_) || _loc5_ == undefined)))
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.LOS.help,"DEBUG_LOG");
         return undefined;
      }
      oContext.showMessage(undefined,"Line of sight between " + _loc4_ + " and " + _loc5_ + " -> " + ank.battlefield.utils.Pathfinding.checkView(oContext.api.gfx.mapHandler,_loc4_,_loc5_),"DEBUG_LOG");
   }
   static function showCellIds(oContext, aTmp)
   {
      if(aTmp[0] == "1")
      {
         dofus.Constants.DEBUG_SHOW_CELL_IDS = true;
      }
      else if(aTmp[0] == "0")
      {
         dofus.Constants.DEBUG_SHOW_CELL_IDS = false;
      }
      else
      {
         dofus.Constants.DEBUG_SHOW_CELL_IDS = !dofus.Constants.DEBUG_SHOW_CELL_IDS;
      }
      oContext.api.gfx.updateCellIds();
      if(dofus.Constants.DEBUG_SHOW_CELL_IDS && oContext.api.kernel.OptionsManager.getOption("Grid") == false)
      {
         oContext.api.kernel.OptionsManager.setOption("Grid",true);
      }
   }
   static function clearCell(oContext, aTmp)
   {
      var _loc4_ = Number(aTmp[0]);
      if(_global.isNaN(_loc4_) || _loc4_ == undefined)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.CLEARCELL.help,"DEBUG_LOG");
         return undefined;
      }
      oContext.api.gfx.mapHandler.getCellData(_loc4_).removeAllSpritesOnID();
      oContext.showMessage(undefined,"Cell " + _loc4_ + " cleaned.","DEBUG_LOG");
   }
   static function decryptFightCell(oContext, aTmp)
   {
      if(!aTmp[0] || (aTmp[0].length == 0 || aTmp[0].length % 2 != 0))
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.DECRYPTFIGHTCELLS.help,"DEBUG_LOG");
         return undefined;
      }
      oContext.showMessage(undefined,"Full string : " + aTmp[0],"DEBUG_LOG");
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < aTmp[0].length)
      {
         _loc5_ = ank.utils.Compressor.decode64(aTmp[0].charAt(_loc4_)) << 6;
         _loc5_ += ank.utils.Compressor.decode64(aTmp[0].charAt(_loc4_ + 1));
         oContext.showMessage(undefined,aTmp[0].charAt(_loc4_) + aTmp[0].charAt(_loc4_ + 1) + " : " + _loc5_,"DEBUG_LOG");
         _loc4_ += 2;
      }
   }
   static function cryptFightCell(oContext, aTmp)
   {
      if(aTmp[0] == undefined)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.CRYPTCELLS.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc4_ = aTmp[0].split(",");
      var _loc5_ = 0;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      while(_loc5_ < _loc4_.length)
      {
         _loc6_ = Number(_loc4_[_loc5_]);
         if(_global.isNaN(_loc6_) || _loc6_ == undefined)
         {
            oContext.showMessage(undefined,"Number not valid : " + _loc6_,"DEBUG_LOG");
         }
         else
         {
            _loc7_ = Math.floor(_loc6_ / 64);
            _loc8_ = _loc6_ % 64;
            _loc9_ = ank.utils.Compressor.encode64(_loc7_) + ank.utils.Compressor.encode64(_loc8_);
            oContext.showMessage(undefined,_loc6_ + " : " + _loc9_,"DEBUG_LOG");
         }
         _loc5_ = _loc5_ + 1;
      }
   }
   static function cellInfo(oContext, aTmp)
   {
      var _loc4_ = Number(aTmp[0]);
      if(_global.isNaN(_loc4_) || _loc4_ == undefined)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.CELLINFO.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = oContext.api.gfx.mapHandler.getCellData(_loc4_);
      oContext.showMessage(undefined,"Datas about cell " + _loc4_ + ":","DEBUG_LOG");
      for(var k in _loc5_)
      {
         oContext.showMessage(undefined,"    " + k + " -> " + _loc5_[k],"DEBUG_LOG");
         if(_loc5_[k] instanceof Object)
         {
            for(var l in _loc5_[k])
            {
               oContext.showMessage(undefined,"        " + l + " -> " + _loc5_[k][l],"DEBUG_LOG");
            }
         }
      }
   }
}
