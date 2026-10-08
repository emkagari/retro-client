class dofus.datacenter.Mutant extends dofus.datacenter.Character
{
   var _bShowIsPlayer;
   var _nMonsterID;
   var _nPowerLevel;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var _sPlayerName;
   var api;
   var initialize;
   var refreshGfxFileName;
   function Mutant(sID, clipClass, sGfxFile, cellNum, dir, gfxID, bShowIsPlayer)
   {
      super();
      this._bShowIsPlayer = bShowIsPlayer == undefined ? false : bShowIsPlayer;
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID);
   }
   function get name()
   {
      if(!this._bShowIsPlayer)
      {
         return this.monsterName;
      }
      return this._sPlayerName;
   }
   function set monsterID(n)
   {
      this._nMonsterID = n;
   }
   function get monsterID()
   {
      return this._nMonsterID;
   }
   function set playerName(n)
   {
      this._sPlayerName = n;
   }
   function get playerName()
   {
      return this._sPlayerName;
   }
   function get monsterName()
   {
      return this.api.lang.getMonstersText(this._nMonsterID).n;
   }
   function get alignment()
   {
      return new dofus.datacenter.Alignment();
   }
   function set powerLevel(nPowerLevel)
   {
      this._nPowerLevel = Number(nPowerLevel);
   }
   function get powerLevel()
   {
      return this._nPowerLevel;
   }
   function get Level()
   {
      return this.api.lang.getMonstersText(this._nMonsterID)["g" + this._nPowerLevel].l;
   }
   function get resistances()
   {
      return this.api.lang.getMonstersText(this._nMonsterID)["g" + this._nPowerLevel].r;
   }
   function set showIsPlayer(b)
   {
      this._bShowIsPlayer = b;
   }
   function get showIsPlayer()
   {
      return this._bShowIsPlayer;
   }
   function get isBoss()
   {
      return this.api.lang.getMonstersText(this._nMonsterID).d;
   }
   function get isArchmonster()
   {
      return dofus.datacenter.Monster.isMiniBossCategory(this.api.lang.getMonstersText(this._nMonsterID).b);
   }
   function get circleFilePath()
   {
      if(this.isBoss || this.isArchmonster)
      {
         return dofus.Constants.CIRCLE_BOSS_FILE;
      }
      return super.circleFilePath;
   }
   function get canSwitchInCreaturesMode()
   {
      return this.api.datacenter.Game.isFight;
   }
   function get creatureGfxFile()
   {
      if(this._sCreatureGfxFile != undefined)
      {
         return this._sCreatureGfxFile;
      }
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH;
      if(this.isBoss || this.isArchmonster)
      {
         _loc2_ += "901.swf";
      }
      else
      {
         _loc2_ += "900.swf";
      }
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
}
