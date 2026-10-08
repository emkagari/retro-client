class dofus.utils.consoleParsers.consoleCommands.ConsoleCommandSearch
{
   function ConsoleCommandSearch()
   {
   }
   static function searchNpc(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHNPC.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for npc : " + _loc4_;
      var _loc6_ = oContext.api.lang.getNonPlayableCharactersTexts();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchBreed(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHBREED.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for breed : " + _loc4_;
      var _loc6_ = oContext.api.lang.getAllClassText();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].sn + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchAlignment(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHALIGNMENT.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for alignment : " + _loc4_;
      var _loc6_ = oContext.api.lang.getAlignments();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchItem(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHITEM.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for item : " + _loc4_;
      var _loc6_ = oContext.api.lang.getItemUnics();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i + " (gfx : " + _loc6_[i].t + "/" + _loc6_[i].g + ".swf)";
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchJob(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHJOB.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for job : " + _loc4_;
      var _loc6_ = oContext.api.lang.getAllJobsText();
      var _loc7_;
      for(var i in _loc6_)
      {
         _loc7_ = _loc6_[i];
         if(!(_global.isNaN(_loc7_.g) || _loc7_.g < 1))
         {
            if(_loc7_.n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
            {
               _loc5_ += "\n " + _loc7_.n + " : " + i;
            }
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchMonster(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHMONSTER.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for monster : " + _loc4_;
      var _loc6_ = oContext.api.lang.getMonsters();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i + " (gfx : " + _loc6_[i].g + ")";
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchSubArea(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHSUBAREA.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for subarea : " + _loc4_;
      var _loc6_ = oContext.api.lang.getMapSubAreas();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchSpell(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHSPELL.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for spell : " + _loc4_;
      var _loc6_ = oContext.api.lang.getSpells();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchQuest(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHQUEST.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for quest : " + _loc4_;
      var _loc6_ = oContext.api.lang.getQuests();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchAchievement(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHACHIEVEMENT.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for achievement : " + _loc4_;
      var _loc6_ = oContext.api.lang.getAchievements();
      for(var i in _loc6_)
      {
         if(_loc6_[i].n.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].n + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
   static function searchTitle(oContext, aArgs)
   {
      var _loc4_ = aArgs.join(" ");
      if(_loc4_ == undefined || _loc4_.length < 2)
      {
         oContext.showMessage(undefined,"Erreur syntaxe : " + dofus.utils.consoleParsers.ConsoleCommand.SEARCHTITLE.help,"DEBUG_LOG");
         return undefined;
      }
      var _loc5_ = "";
      _loc5_ += "Looking for title : " + _loc4_;
      var _loc6_ = oContext.api.lang.getTitles();
      for(var i in _loc6_)
      {
         if(_loc6_[i].t.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1 || _loc6_[i].tf.toUpperCase().indexOf(_loc4_.toUpperCase()) != -1)
         {
            _loc5_ += "\n " + _loc6_[i].t + "/" + _loc6_[i].tf + " : " + i;
         }
      }
      oContext.showMessage(undefined,_loc5_,"DEBUG_LOG");
   }
}
