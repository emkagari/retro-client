class dofus.datacenter.TaxCollector extends dofus.datacenter.PlayableCharacter
{
   var _aResistances;
   var _bIsMine;
   var _oEmblem;
   var _sCreatureGfxFile;
   var _sCreatureGfxFileName;
   var _sGuildName;
   var _sName;
   var api;
   var refreshGfxFileName;
   function TaxCollector(sID, clipClass, sGfxFile, cellNum, dir, gfxID, isMine)
   {
      super();
      this.initialize(sID,clipClass,sGfxFile,cellNum,dir,gfxID,isMine);
   }
   function set name(sName)
   {
      this._sName = sName;
   }
   function get name()
   {
      return this._sName;
   }
   function set guildName(sGuildName)
   {
      this._sGuildName = sGuildName;
   }
   function get guildName()
   {
      return this._sGuildName;
   }
   function set emblem(oEmblem)
   {
      this._oEmblem = oEmblem;
   }
   function get emblem()
   {
      return this._oEmblem;
   }
   function set resistances(aResistances)
   {
      this._aResistances = aResistances;
   }
   function get resistances()
   {
      return this._aResistances;
   }
   function set isMine(bIsMine)
   {
      this._bIsMine = bIsMine;
   }
   function get isMine()
   {
      return this._bIsMine;
   }
   function get circleFilePath()
   {
      return dofus.Constants.CIRCLE_BOSS_FILE;
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
      var _loc2_ = dofus.Constants.CLIPS_PERSOS_PATH + "901.swf";
      this._sCreatureGfxFile = _loc2_;
      this._sCreatureGfxFileName = this.refreshGfxFileName(_loc2_);
      return _loc2_;
   }
}
